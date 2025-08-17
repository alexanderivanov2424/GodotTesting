extends CharacterBody2D

@export var speed := 400

@export var id: int = -1:
	set(peer_id):
		id = peer_id
		$ID.text = str(peer_id)

func _physics_process(_delta):
	if id == multiplayer.get_unique_id():
		get_input()
		move_and_slide()

func get_input():
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
