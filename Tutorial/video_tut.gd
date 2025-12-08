extends Node2D


func _ready() -> void:
	$VideoStreamPlayer.connect("finished", Callable(self, "_on_video_finished"))

func _on_video_finished():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Tutorial/tut.tscn")
	
	
func _process(delta: float) -> void:
	pass
