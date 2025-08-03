extends Node

@export var Map: PackedScene
@export var Player: PackedScene

@onready var map: Node = $Map
@onready var players: Node = $Players
@onready var map_spawner: MultiplayerSpawner = $MapSpawner
@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner

func _ready() -> void:
	Lobby.lobby_ready.connect(_start_game)

	map_spawner.add_spawnable_scene(Map.resource_path)
	player_spawner.add_spawnable_scene(Player.resource_path)
	player_spawner.spawn_function = _spawn_player

func _start_game():
	for c in map.get_children():
		map.remove_child(c)
		c.queue_free()

	map.add_child(Map.instantiate())

	for c in players.get_children():
		players.remove_child(c)
		c.queue_free()

	for peer_id in Lobby.players:
		player_spawner.spawn(peer_id)

func _spawn_player(data: Variant) -> Node:
	var peer_id := int(data)
	var player: Player = Player.instantiate()
	player.set_peer_id(peer_id)
	return player
