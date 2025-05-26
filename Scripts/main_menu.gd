extends Control

@onready var bgMusic = $Music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Start.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not bgMusic.playing:
		bgMusic.play()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_controls_pressed() -> void:
	$"Controls screen".show()
	$Label.hide()
	$VBoxContainer.hide()

func _input(event):
	if event.is_action("exit"):
		$"Controls screen".hide()
		$Label.show()
		$VBoxContainer.show()
