extends Control

@export var total_time_in_secs : int = 0
signal TimeUpdate

func _ready():
	$Timer.start()

func _on_timer_timeout():
	total_time_in_secs += 1
	var m = int(total_time_in_secs / 60.0)
	var s = total_time_in_secs - m * 60
	$Label.text = '%02d:%02d' % [m, s]
	emit_signal("TimeUpdate")


func _on_player_game_over() -> void:
	$Timer.stop()
