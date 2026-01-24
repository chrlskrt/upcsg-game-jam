extends CanvasLayer

func _ready():
	get_tree().paused = false

func _on_close_pressed():
	queue_free()
