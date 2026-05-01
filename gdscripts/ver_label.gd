extends Label

func _ready() -> void:
	var ver = ProjectSettings.get_setting("application/config/version")
	$".".text = "APP Ver: " + ver
