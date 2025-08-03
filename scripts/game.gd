extends Node

@export var game_scene: PackedScene

@export var player_scene: PackedScene

func _ready() -> void:
	Lobby.lobby_ready.connect(_start_game)
	
	$MapSpawner.add_spawnable_scene(game_scene.resource_path)
	$PlayerSpawner.add_spawnable_scene(player_scene.resource_path)
	
	$PlayerSpawner.spawn_function = spawn_player

func _start_game():	
	var map_root = $Map
	var player_root = $Players
	
	for c in map_root.get_children():
		map_root.remove_child(c)
		c.queue_free()
		
	map_root.add_child(game_scene.instantiate())
		
	for c in player_root.get_children():
		player_root.remove_child(c)
		c.queue_free()
	
	
	for peer_id in Lobby.players:
		$PlayerSpawner.spawn(peer_id)
		
		
func spawn_player(data : Variant) -> Node:
	var player : Player = player_scene.instantiate()
	var peer_id = int(data)
	player.set_peer_id(peer_id)
	return player
