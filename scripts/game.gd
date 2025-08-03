extends Node

@export var game_scene: PackedScene

func _ready() -> void:
	Lobby.lobby_ready.connect(_start_game)
	
	$MultiplayerSpawner.add_spawnable_scene(game_scene.resource_path)

func _start_game():	
	var multiplayer_root = $MultiplayerRoot
	
	for c in multiplayer_root.get_children():
		multiplayer_root.remove_child(c)
		c.queue_free()
		
	multiplayer_root.add_child(game_scene.instantiate())
