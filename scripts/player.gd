extends CharacterBody2D

@export var speed := 400

# Set by the authority, synchronized on spawn.
@export var id: int = -1:
	set(peer_id):
		id = peer_id
		$ID.text = str(peer_id)

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	if id == multiplayer.get_unique_id():
		camera.make_current()

func _physics_process(_delta):
	if id == multiplayer.get_unique_id():
		get_input()
		move_and_slide()

func get_input():
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
