extends AnimatableBody2D

@export var speed := 20

@export var direction: Vector2 = Vector2(1.0, 0.0)

func _ready() -> void:
	set_sync_to_physics(false)

func _physics_process(_delta):
	move_and_collide(direction * speed)
