extends Control

@export var readyToFire: bool = false
@onready var animation = $AnimationPlayer
@onready var player = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("ProgressDestroyed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("left_click"):
		animation.play("ProgressIncrement")
		animation.queue("ReadyToFire")
	elif event.is_action_released("left_click"):
		animation.play("ProgressDestroyed")

func _on_animation_player_animation_changed(old_name: StringName, new_name: StringName):
	if old_name == "ProgressIncrement":
		readyToFire = true
