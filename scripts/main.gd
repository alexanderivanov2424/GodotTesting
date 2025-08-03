extends Node

var logs: Array[String] = []

@onready var input: TextEdit = $InputBox
@onready var chat: RichTextLabel = $ChatLog

@export var game_scene: PackedScene

func _ready() -> void:
	Lobby.player_connected.connect(_player_connected)
	Lobby.player_disconnected.connect(_player_disconnected)
	Lobby.server_disconnected.connect(_server_disconnected)

	Lobby.message_received.connect(_got_message)
	
	Lobby.lobby_ready.connect(_start_game)

#func _process(delta: float) -> void:
	#print("tick" + str(delta))

func _on_create_game_pressed() -> void:
	Lobby.create_game(_get_int($Create/PORT))
	print("Server Created")

func _on_join_game_pressed() -> void:
	Lobby.join_game(_get_str($Join/IP), _get_int($Join/PORT))
	print("Server Joined")

func _on_update_name_pressed() -> void:
	var name := _get_str($Name)
	Lobby.update_name(name)
	print("Name Updated to %s" % name)

func _player_connected(peer_id: int, player_info: Dictionary):
	print("%d %s connected!" % [peer_id, player_info["name"]])
	_update_active_players()

func _player_disconnected(peer_id: int):
	print("%d disconnected!" % peer_id)
	_update_active_players()

func _server_disconnected():
	print("server closed")

func _got_message(player_info: Dictionary, message: String):
	var chat_message := "[ %s ] %s" % [player_info["name"], message]
	print(chat_message)
	chat.text += chat_message + "\n"
	chat.scroll_to_line(chat.get_line_count())

func _on_send_button_pressed():
	logs.append(input.text)
	Lobby.send_message(input.text)
	input.clear()

func _get_str(box: TextEdit) -> String:
	var text := box.text
	if not text:
		text = box.placeholder_text
	return text

func _get_int(box: TextEdit) -> int:
	return int(_get_str(box))

func _update_active_players():
	var player_status_text = ""
	for player_id in Lobby.players.keys():
		var player_info = Lobby.players[player_id]
		player_status_text += player_info["name"] + "\n"
		
	$RightPane/Players.text = player_status_text

func _on_ready_button_pressed():
	Lobby.send_ready()
	
	
func _start_game():
	get_tree().change_scene_to_packed(game_scene)
