extends Area3D

@export var setpoints: Array[Vector3]
var setpointIdx: int = 0
var setpointTolerance = 0.1

@export var movementSpeed: float = 1.0;

@onready var deathExplosion: CPUParticles3D = $"Death Particles"

var isTarget: bool = false

func _process(delta: float) -> void:

	var targetSetpoint = setpoints[setpointIdx]
	if len(setpoints) > 1:
		
		var dPosition: Vector3 = position.move_toward(targetSetpoint, movementSpeed * delta)
		position = dPosition
		
		if (abs(position.distance_to(targetSetpoint)) < setpointTolerance):
			
			setpointIdx = (setpointIdx + 1) % len(setpoints)

func _on_area_entered(area: Area3D) -> void:
	
	if area.is_in_group("bullet"):
		
		deathExplosion.restart()
