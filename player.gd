extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	velocity = input_vector.normalized() * SPEED

	move_and_slide()
