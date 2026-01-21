extends CharacterBody2D


const SPEED = 200.0
@onready var sprite = $AnimatedSprite2D
var last_dir = "down"

@export var tile_size = 16.0
@export var speed = 6.0 # tiles moved per second

func _physics_process(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	velocity = input_vector.normalized() * SPEED

	if velocity != Vector2.ZERO:
		if abs(velocity.x) > abs(velocity.y):
			last_dir = "right" if velocity.x > 0 else "left"
		else:
			last_dir = "down" if velocity.y > 0 else "up"
			
		sprite.play("walk_" + last_dir)
	else:
		sprite.play("default_" + last_dir)

	move_and_slide()
