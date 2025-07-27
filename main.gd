extends Control

@onready
var InputBox : TextEdit = $InputBox

@onready
var ChatLog : RichTextLabel = $ChatLog

func _ready() -> void:
	print("Ready!")
	print(InputBox.text)
	
func create_server(PORT : int, MAX_CLIENTS : int) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	self.multiplayer.multiplayer_peer = peer
	
func create_client(IP_ADDRESS : String, PORT : int) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
func _process(delta: float) -> void:
	print("tick" + str(delta))
