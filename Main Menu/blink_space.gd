extends Panel

func _blink():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "modulate:a", 0.0,1.0)
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_blink()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
