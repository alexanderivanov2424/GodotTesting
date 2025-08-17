extends Node

@onready var camera: Camera2D = $PlayerPosition/Camera2D

# Set by the authority, synchronized on spawn.
@export var id: int = -1:
	set(peer_id):
		id = peer_id
		$PlayerPosition.set_multiplayer_authority(peer_id)

func _ready() -> void:
	if id == multiplayer.get_unique_id():
		camera.make_current()
	$PlayerPosition.id = id
