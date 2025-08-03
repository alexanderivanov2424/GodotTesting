extends Node

# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id: int, player_info: Dictionary)
signal player_disconnected(peer_id: int)
signal server_disconnected
signal message_received(player_info: Dictionary, message: String)

signal lobby_ready

const MAX_CONNECTIONS = 20
const SERVER_ID = 1

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players: Dictionary[int, Dictionary] = {}

# This is the local player info.
var player_info: Dictionary = {"name": "Name", "ready": false}

var ready_player_count = 0

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)

	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func join_game(ip: String, port: int):
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_client(ip, port)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

func create_game(port: int):
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(port, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	players[SERVER_ID] = player_info
	player_connected.emit(SERVER_ID, player_info)

func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null
	players.clear()

# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id: int):
	_register_player.rpc_id(id, player_info)

@rpc("any_peer", "reliable")
func _register_player(new_player_info: Dictionary):
	var new_player_id := multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func _on_player_disconnected(id: int):
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_ok():
	var peer_id := multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)

func _on_connected_fail():
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

# ########################

func send_message(message: String):
	var peer_id := multiplayer.get_unique_id()
	_send_message.rpc(peer_id, message)

@rpc("any_peer", "call_local", "reliable")
func _send_message(peer_id: int, message: String):
	var sender := players[peer_id]
	message_received.emit(sender, message)

func update_name(new_name: String):
	player_info["name"] = new_name
	var peer_id := multiplayer.get_unique_id()
	_update_name.rpc(peer_id, new_name)

@rpc("any_peer", "call_local", "reliable")
func _update_name(peer_id: int, new_name: String):
	if peer_id in players:
		players[peer_id]["name"] = new_name
		
func send_ready():
	var peer_id := multiplayer.get_unique_id()
	_send_ready.rpc_id(SERVER_ID)

@rpc("any_peer", "call_local", "reliable")
func _send_ready():
	var peer_id : int = multiplayer.get_remote_sender_id()
	if multiplayer.is_server():
		
		if !players[peer_id]["ready"]:
			ready_player_count += 1
			players[peer_id]["ready"] = true
		
		if (ready_player_count == players.size()):
			lobby_ready.emit()
			_clear_players_ready_state()
				
func _clear_players_ready_state():
	ready_player_count = 0
	for p in players:
		players[p]["ready"] = false
