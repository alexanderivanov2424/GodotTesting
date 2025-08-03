extends CharacterBody2D
class_name  Player

@export var speed = 400

@export var peer_id : int = -1

func set_peer_id(peer_id : int):
	print("setting %d" % peer_id)
	self.peer_id = peer_id
	$ID.text = str(peer_id)
	set_multiplayer_authority(peer_id)

func _enter_tree() -> void:
	pass

func _ready() -> void:
	print("ready")
	if peer_id == multiplayer.get_unique_id():
		$Camera2D.make_current()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	if peer_id == multiplayer.get_unique_id():
		get_input()
		move_and_slide()
