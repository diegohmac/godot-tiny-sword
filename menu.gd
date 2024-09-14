extends Control


func _ready() -> void:
	for button in get_tree().get_nodes_in_group("Button"):
		button.pressed.connect(on_button_pressed.bind(button.name))

func on_button_pressed(buttonName: String) -> void:
	match buttonName:
		"NewGame":
			transition_screen.scene_path = "res://main.tscn"
			transition_screen.fade_in()
		"Quit":
			transition_screen.can_quit = true
			transition_screen.fade_in()
