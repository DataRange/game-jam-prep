extends RichTextLabel

@export var speed: int = 5
@export var fade: bool = false

var time = 5
var sinTime = 0
var _visible = true

func flashMyText():
	if !fade:
		if sinTime > 0:
			_visible = true
		else:
			_visible = false
		pass
	else:
		_visible = true
		modulate.a = sinTime
		pass
	visible = _visible

func _physics_process(delta: float) -> void:
	time += delta
	sinTime = sin(time*speed)
	flashMyText()
	if time > 5:
		hide()


func _on_player_newinfo() -> void:
	time = 0
	show()
