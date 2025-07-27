extends Node
class_name Lobby

# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id : int, player_info : PlayerInfo)
signal player_disconnected(peer_id : int)
signal server_disconnected

signal message_received(player_info : PlayerInfo, message : String)

const MAX_CONNECTIONS = 20

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}

var player_info : PlayerInfo

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func join_game(IP : String, PORT : int):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(IP, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

const SERVER_ID = 1

func create_game(PORT : int):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
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
func _on_player_connected(id : int):
	_register_player.rpc_id(id, player_info)

@rpc("any_peer", "reliable")
func _register_player(new_player_info : PlayerInfo):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)

func _on_connected_fail():
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
	
	
# ########################

func send_message(message : String):
	_send_message.rpc(player_info, message)

@rpc("any_peer", "reliable")
func _send_message(sender : PlayerInfo, message : String):
	message_received.emit(sender, message)
