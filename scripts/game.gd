extends Node

@export var Map: PackedScene
@export var Player: PackedScene

@onready var spawn_point: Node = $SpawnPoint

func _ready() -> void:
	Lobby.lobby_ready.connect(_start_game)

func _start_game():
	spawn_point.add_child(Map.instantiate())

	for peer_id in Lobby.players:
		var player := Player.instantiate()
		player.id = peer_id

		spawn_point.add_child(player, true)
		player.set_multiplayer_authority(peer_id)
