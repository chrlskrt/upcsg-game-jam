extends Node2D

@export var block_scene: PackedScene

@onready var spawn_marker = $SpawnMarker
@onready var blocks = $Blocks
@onready var camera = $Camera2D

signal exit_app

var current_block
var last_block: Node2D = null
var stack_height := 0

func _ready():
	spawn_block()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"): # Esc
		emit_signal("exit_app")

func spawn_block():
	current_block = block_scene.instantiate()
	current_block.position = spawn_marker.position

	# 📏 size difficulty (from earlier)
	var max_w = max(60, 140 - stack_height * 6)
	current_block.max_width = max_w
	current_block.min_width = max_w - 30

	# ⏩ swing speed difficulty
	current_block.speed = min(
		current_block.base_speed + stack_height * 25,
		600
	)


	blocks.add_child(current_block)


func _input(event):
	if event.is_action_pressed("ui_accept") and current_block:
		handle_block_drop()

func handle_block_drop():
	current_block.drop()

	# First block always succeeds
	if last_block == null:
		last_block = current_block
		next_round()
		return

	var overlap := get_overlap(current_block, last_block)

	# ❌ no overlap = game over
	if overlap <= 10:
		game_over()
		return

	# ✂️ trim block
	current_block.trim_to_overlap(overlap, last_block.global_position.x)

	last_block = current_block
	next_round()

func get_overlap(a, b) -> float:
	var a_left = a.global_position.x - a.width / 2
	var a_right = a.global_position.x + a.width / 2

	var b_left = b.global_position.x - b.width / 2
	var b_right = b.global_position.x + b.width / 2

	return min(a_right, b_right) - max(a_left, b_left)

func next_round():
	stack_height += 1
	move_camera()
	current_block = null
	await get_tree().create_timer(0.4).timeout
	spawn_block()

func move_camera():
	camera.position.y -= 64
	spawn_marker.position.y -= 64

func game_over():
	print("GAME OVER")
	get_tree().paused = true

func _on_exit_button_pressed():
	emit_signal("exit_app")
