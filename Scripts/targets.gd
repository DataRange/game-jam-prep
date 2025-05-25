extends Area3D



@onready var deathExplosion: CPUParticles3D = $"Death Particles"
@onready var target: Node3D = $target
@onready var timer: Timer = $Timer
@onready var progress: ProgressBar = $SubViewport/ProgressBar

signal died

func _ready() -> void:
	timer.wait_time = randi_range(3,7) * 1.0
	progress.max_value = timer.wait_time
	timer.one_shot = true
	timer.start()

func _process(delta: float) -> void:
	progress.value = timer.time_left
	pass

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("bullet"):
		emit_signal("died")
		timer.stop()
		target.hide()
		progress.hide()
		deathExplosion.restart()

func _on_death_particles_finished() -> void:
	queue_free() # Replace with function body.

func _on_timer_timeout() -> void:
	target.hide()
	progress.hide()
	deathExplosion.restart()
