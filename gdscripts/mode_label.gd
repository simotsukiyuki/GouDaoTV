extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# 接收WebView的信号signal fast_mode_changed(current_mode)
func _on_web_view_fast_mode_changed(current_mode: Variant) -> void:
	if(current_mode==false):
		$".".text="当前加载模式：兼容模式"
	else:
		$".".text="当前加载模式：高速模式"
	pass # Replace with function body.
