extends CanvasLayer

signal monitor_closed

@onready var desktop = $Desktop
@onready var app_container = $AppContainer

func _ready():
	get_tree().paused = false  # optional
	show_desktop()

func show_desktop():
	desktop.visible = true
	app_container.visible = false
	clear_apps()

func open_app(scene_path: String):
	clear_apps()
	
	var app = load(scene_path).instantiate()
	app_container.add_child(app)

	# 🔌 CONNECT SIGNAL HERE
	if app.has_signal("exit_app"):
		app.connect("exit_app", Callable(self, "close_app"))

	desktop.visible = false
	app_container.visible = true


func close_app():
	show_desktop()

func clear_apps():
	for child in app_container.get_children():
		child.queue_free()

func close_monitor():
	queue_free()
	emit_signal("monitor_closed")

func _on_close_pressed():
	close_monitor()

func _process(_delta):
	if Input.is_action_just_pressed("close"): # X key
		close_monitor()


func _on_tower_stack_app_pressed() -> void:
	open_app("res://scenes/minigames/tower_stack/tower_stack.tscn")
