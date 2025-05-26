extends Area3D

@export var setpoints: Array[Vector3]
var setpointIdx: int = 0
var setpointTolerance = 0.1

@export var movementSpeed: float = 1.0;

@onready var deathExplosion: CPUParticles3D = $"Death Particles"
@onready var animation: AnimationPlayer = $character/AnimationPlayer

var hitAngle: float = 0.0

var isTarget: bool = false
var dead: bool = false

@onready var body = $character/body

var capSpecs: Array[String] = ["Black", "Blue", "White", "Red"]
var cap: int = randi_range(0, len(capSpecs))

var eyeWearSpecs: Array[String] = ["Sunglasses", "Glasses"]
var eyeWear: int = randi_range(0, len(eyeWearSpecs))

var shirtColors: Array[Color] = [Color.RED, Color.BLUE, Color.MAGENTA, Color.BLACK, Color.ROYAL_BLUE]

func _ready() -> void:
	
	if cap < len(capSpecs):
		
		var newCap = load("res://Raw Models/Accessories/Caps/" + capSpecs[cap] + " Cap.gltf").instantiate()
		newCap.position.y = 0.5;
		newCap.rotation.y = PI
		body.add_child(newCap)
		
	if eyeWear < len(eyeWearSpecs):
		
		var newEyeWear = load("res://Raw Models/Accessories/Eyewear/" + eyeWearSpecs[eyeWear] + ".gltf").instantiate()
		newEyeWear.position.z = -1.0;
		body.add_child(newEyeWear)
		
	var newShirt: MeshInstance3D = MeshInstance3D.new()
	newShirt.mesh = CylinderMesh.new()
	newShirt.scale.x = 2.0
	newShirt.scale.y = .75
	newShirt.scale.z = 2.0
	newShirt.position.y = -1
	
	var shirtColor: StandardMaterial3D = StandardMaterial3D.new()
	shirtColor.albedo_color = shirtColors[randi_range(0, len(shirtColors) - 1)]
	newShirt.material_overlay = shirtColor
	
	body.add_child(newShirt)

func _process(delta: float) -> void:

	if not dead:
		animation.play("walk")
		var targetSetpoint = setpoints[setpointIdx]
		if len(setpoints) > 1:
			look_at(targetSetpoint)
			var dPosition: Vector3 = position.move_toward(targetSetpoint, movementSpeed * delta)
			position = dPosition
			
			if (abs(position.distance_to(targetSetpoint)) < setpointTolerance):
				
				setpointIdx = (setpointIdx + 1) % len(setpoints)
	
	else:
		animation.stop()
		var xComponent: float = sin(hitAngle) * (PI / 2)
		var zComponent: float = cos(hitAngle) * (PI / 2)
		
		rotation.x = lerp_angle(rotation.x, -xComponent, 8.0 * delta)
		rotation.z = lerp_angle(rotation.z, -zComponent, 8.0 * delta)
		
func _on_area_entered(area: Area3D) -> void:
	
	if area.is_in_group("bullet"):
		
		deathExplosion.restart()
		dead = true
		hitAngle = area.rotation.y
		
		if isTarget:
			
			print("You got the target!")
