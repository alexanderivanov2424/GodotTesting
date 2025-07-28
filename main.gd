extends Node

var logs: Array[String] = []

@onready var input: TextEdit = $InputBox
@onready var chat: RichTextLabel = $ChatLog

func _ready() -> void:
	Lobby.player_connected.connect(_player_connected)
	Lobby.player_disconnected.connect(_player_disconnected)
	Lobby.server_disconnected.connect(_server_disconnected)

	Lobby.message_received.connect(_got_message)

#func _process(delta: float) -> void:
	#print("tick" + str(delta))

func _on_create_game_pressed() -> void:
	Lobby.create_game(int($Create/PORT.text))
	print("Server Created")

func _on_join_game_pressed() -> void:
	Lobby.join_game($Join/IP.text, int($Join/PORT.text))
	print("Server Joined")

func _on_update_name_pressed() -> void:
	Lobby.update_name($Name.text)
	print("Name Updated")


func _player_connected(peer_id: int, player_info: Dictionary):
	print("%d %s connected!" % [peer_id, player_info["name"]])

func _player_disconnected(peer_id: int):
	print("%d disconnected!" % peer_id)

func _server_disconnected():
	print("server closed")

func _got_message(player_info: Dictionary, message: String):
	chat.text += "[ %s ] %s \n" % [player_info["name"], message]
	chat.scroll_to_line(chat.get_line_count())

func _on_send_button_pressed():
	logs.append(input.text)
	Lobby.send_message(input.text)
	input.clear()
