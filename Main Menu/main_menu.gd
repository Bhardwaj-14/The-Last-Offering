extends Node2D

func _input(event):
	if event is InputEventKey and event.pressed:
		#space, play
		if event.keycode == KEY_SPACE:
			get_tree().change_scene_to_file("res://Tutorial/video.tscn")
			
		# esc, options
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://options.tscn")
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Tutorial/video.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
