extends Node

@onready
var InputBox : TextEdit = $InputBox

@onready
var ChatLog : RichTextLabel = $ChatLog

@onready
var Lobby : Lobby = $LobbyNode

var logs : Array[String] = []

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
	Lobby.player_info.name = $Name.text
	print("Name Updated")


func _player_connected(peer_id : int, player_info):
	print(str(peer_id) + " " + player_info["name"] + " connected!")
	
func _player_disconnected(peer_id : int):
	print(str(peer_id) + " disconnected!")
	
func _server_disconnected():
	print("server closed")
	
func _got_message(player_info, message : String):
	logs.append(message)
	print("[ " + player_info["name"] + " ] " + message)


func _on_send_button_pressed() -> void:
	print("Sending " + InputBox.text)
	Lobby.send_message(InputBox.text)
	InputBox.clear()
