extends Node

@export var Map: PackedScene
@export var Player: PackedScene

@onready var spawner: MultiplayerSpawner = $Spawner
@onready var spawn_point: Node = $SpawnPoint

func _ready() -> void:
	Lobby.lobby_ready.connect(_start_game)

	spawner.spawn_function = func(peer_id: int) -> Node:
		var player = Player.instantiate()
		player.id = peer_id
		player.set_multiplayer_authority(peer_id)
		return player

func _start_game():
	spawn_point.add_child(Map.instantiate())

	for peer_id in Lobby.players:
		spawner.spawn(peer_id)
