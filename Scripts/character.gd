extends Area3D

@export var setpoints: Array[Vector3]
var setpointIdx: int = 0
var setpointTolerance = 0.1

@export var movementSpeed: float = 1.0;

@onready var deathExplosion: CPUParticles3D = $"Death Particles"

var hitAngle: float = 0.0

var isTarget: bool = false
var dead: bool = false

func _process(delta: float) -> void:

	if not dead:
		var targetSetpoint = setpoints[setpointIdx]
		if len(setpoints) > 1:
			
			var dPosition: Vector3 = position.move_toward(targetSetpoint, movementSpeed * delta)
			position = dPosition
			
			if (abs(position.distance_to(targetSetpoint)) < setpointTolerance):
				
				setpointIdx = (setpointIdx + 1) % len(setpoints)
	
	else:
		
		var xComponent: float = sin(hitAngle) * (PI / 2)
		var zComponent: float = cos(hitAngle) * (PI / 2)
		
		rotation.x = lerp_angle(rotation.x, -xComponent, 8.0 * delta)
		rotation.z = lerp_angle(rotation.z, -zComponent, 8.0 * delta)
		
func _on_area_entered(area: Area3D) -> void:
	
	if area.is_in_group("bullet"):
		
		deathExplosion.restart()
		area.queue_free()
		dead = true
		hitAngle = area.rotation.y
