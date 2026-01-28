extends Area2D

@export var monitor: PackedScene
var player_near := false
var pc_open := false

@export var hint : TileMapLayer

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_near = true
		hint.visible = true # pc hint to interact

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_near = false
		hint.visible = false

func _process(_delta):	
	if player_near and Input.is_action_just_pressed("interact") and !pc_open:
		open_pc()

func open_pc():
	if monitor:
		print("monitor is here")
		var monitor_scene = monitor.instantiate()
		get_tree().current_scene.add_child(monitor_scene)

		pc_open = true
		
		

		monitor_scene.monitor_closed.connect(func():
			pc_open = false
		)
