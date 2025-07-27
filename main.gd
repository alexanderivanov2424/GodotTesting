extends Node

@onready
var InputBox : TextEdit = $InputBox

@onready
var ChatLog : RichTextLabel = $ChatLog

@onready
var Lobby : Lobby = $LobbyNode

func _ready() -> void:
	print("Ready!")
	Lobby.player_connected.connect(_player_connected)
	Lobby.player_disconnected.connect(_player_disconnected)
	Lobby.server_disconnected.connect(_server_disconnected)
	
#func _process(delta: float) -> void:
	#print("tick" + str(delta))

func _on_create_game_pressed() -> void:
	Lobby.create_game(int($Create/PORT.text))
	
func _on_join_game_pressed() -> void:
	Lobby.join_game($Join/IP.text, int($Join/PORT.text))

func _on_update_name_pressed() -> void:
	Lobby.player_info.name = $Name.text


func _player_connected(peer_id : int, player_info : PlayerInfo):
	print(str(peer_id) + player_info.name + " connected!")
	
func _player_disconnected(peer_id : int):
	print(str(peer_id) + " disconnected!")
	
func _server_disconnected():
	print("server closed")
