extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_HIDDEN && 
	Input.get_last_mouse_velocity()!=Vector2.ZERO):
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		$".".start(5)
	#如果鼠标模式位隐藏并且移动了鼠标，则显示鼠标
	#5秒后自动隐藏


func _on_mouse_hide_timeout() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
