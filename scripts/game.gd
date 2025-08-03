extends Node

@export var game_scene: PackedScene

@export var player_scene: PackedScene

func _ready() -> void:
	Lobby.lobby_ready.connect(_start_game)
	
	$MultiplayerSpawner.add_spawnable_scene(game_scene.resource_path)
	$MultiplayerSpawner.add_spawnable_scene(player_scene.resource_path)
	$MultiplayerSpawner.add_spawnable_scene(player_scene.resource_path)
	$MultiplayerSpawner.add_spawnable_scene(player_scene.resource_path)
	$MultiplayerSpawner.add_spawnable_scene(player_scene.resource_path)

func _start_game():	
	var multiplayer_root = $MultiplayerRoot
	
	for c in multiplayer_root.get_children():
		multiplayer_root.remove_child(c)
		c.queue_free()
		
	multiplayer_root.add_child(game_scene.instantiate())
	
	for peer_id in Lobby.players:
		var player : Player = player_scene.instantiate()
		player.peer_id = peer_id
		multiplayer_root.add_child(player, true)
