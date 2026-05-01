extends Label


func _on_action_swaping_plus_and_minus(state: Variant) -> void:
	if(state == false):
		$".".text = "上下键倒转：OFF"
	else:
		$".".text = "上下键倒转：ON"
	
