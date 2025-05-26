extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_world_civilian_killed() -> void:
	show()
	pass # Replace with function body.


func _on_world_target_acquried() -> void:
	pass # Replace with function body.
