extends Node

@export var Map: PackedScene
@export var Player: PackedScene

@onready var spawner: MultiplayerSpawner = $Spawner
@onready var spawn_point: Node = $SpawnPoint

func _ready() -> void:
	Lobby.lobby_ready.connect(_start_game)

	spawner.spawn_function = _spawn_player

func _start_game():
	for c in spawn_point.get_children():
		spawn_point.remove_child(c)
		c.queue_free()

	spawn_point.add_child(Map.instantiate())
	for peer_id in Lobby.players:
		spawner.spawn(peer_id)

func _spawn_player(data: Variant) -> Node:
	var peer_id := int(data)
	var player: Player = Player.instantiate()
	player.set_peer_id(peer_id)
	return player
