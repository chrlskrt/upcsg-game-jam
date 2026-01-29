extends RigidBody2D

@export var base_speed := 200.0
var speed := 200
@export var min_width := 60
@export var max_width := 140
@export var height := 32

var width: float
var direction := 1
var is_dropped := false

@onready var rect = $ColorRect
@onready var collision = $CollisionShape2D

func _ready():
	speed = base_speed
	width = randf_range(min_width, max_width)
	set_block_size(width)

	# 🎨 random color
	rect.color = Color(randf(), randf(), randf())

func set_block_size(width: float):
	rect.size = Vector2(width, height)
	rect.position = -rect.size / 2

	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collision.shape = shape

func _physics_process(delta):
	if is_dropped:
		return

	position.x += speed * direction * delta

	if position.x > 400:
		direction = -1
	elif position.x < -400:
		direction = 1

func drop():
	is_dropped = true
	freeze = false

func trim_to_overlap(overlap: float, reference_x: float):
	width = overlap
	set_block_size(width)

	# snap block to aligned position
	global_position.x = reference_x
