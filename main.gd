extends Control

@onready
var InputBox : TextEdit = $InputBox

@onready
var ChatLog : RichTextLabel = $ChatLog

var lobby : Lobby = Lobby.new()

func _ready() -> void:
	print("Ready!")
	lobby.player_connected.connect(_player_connected)
	lobby.player_disconnected.connect(_player_disconnected)
	lobby.server_disconnected.connect(_server_disconnected)
	
#func _process(delta: float) -> void:
	#print("tick" + str(delta))

func _on_create_game_pressed() -> void:
	lobby.create_game(int($Create/PORT.text))
	
func _on_join_game_pressed() -> void:
	lobby.join_game($Join/IP.text, int($Join/PORT.text))

func _on_update_name_pressed() -> void:
	pass # Replace with function body.



func _player_connected(peer_id : int, player_info):
	print(str(peer_id) + player_info["name"] + " connected!")
	
func _player_disconnected(peer_id : int):
	print(str(peer_id) + " disconnected!")
	
func _server_disconnected():
	print("server closed")
