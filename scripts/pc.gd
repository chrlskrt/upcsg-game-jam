extends Area2D

@export var monitor: PackedScene
var player_near := false
var pc_open := false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_near = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_near = false

func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact") and !pc_open:
		open_pc()

func open_pc():
	if monitor:
		print("monitor is here")
		var monitor_scene = monitor.instantiate()
		get_tree().current_scene.add_child(monitor_scene)
		pc_open = true 

		if monitor_scene.has_node("Panel/Button"):
			var btn = monitor_scene.get_node("Panel/Button")
			btn.pressed.connect(func():
				pc_open = false  # allow PC to be reopened
			)
