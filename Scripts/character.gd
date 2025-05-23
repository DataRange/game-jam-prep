extends RigidBody3D

@export var setpoints: Array[Vector3]
var setpointIdx: int = 0
var setpointTolerance = 0.1

@export var movementSpeed: float = 1.0;

var isTarget: bool = false

func _init() -> void:
	
	gravity_scale = 0.0

func _process(delta: float) -> void:

	var targetSetpoint = setpoints[setpointIdx]
	if len(setpoints) > 1:
		
		var dPosition: Vector3 = position.move_toward(targetSetpoint, movementSpeed * delta)
		position = dPosition
		
		if (abs(position.distance_to(targetSetpoint)) < setpointTolerance):
			
			setpointIdx = (setpointIdx + 1) % len(setpoints)
		
