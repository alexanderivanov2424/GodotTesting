extends CharacterBody2D
class_name  Player

@export var speed = 400

@export var peer_id : int = -1 :
	set(id):
		peer_id = id
		$ID.text = str(id)
		set_multiplayer_authority(id, true)
		
func _ready():
	if peer_id == multiplayer.get_unique_id():
		$Camera2D.make_current()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
