extends CharacterBody3D

@onready var world = $".."
@onready var head = $CameraController
@onready var camera = $CameraController/Camera3D
@onready var animation = $AnimationPlayer
@onready var gunHolder = $CameraController/Camera3D/WeaponHolder
@onready var gun_barrel = $CameraController/Camera3D/WeaponHolder/RayCast3D
@onready var shotProgress = $"CanvasLayer/Shot Progress"
@onready var crosshair = $CanvasLayer/Crosshair
@onready var guide = $CameraController/Camera3D/Guide
@onready var guideLabel = $CameraController/Camera3D/Guide/Description

@onready var bulletShootSFX = $"Shoot Bullet SFX"

var bullet = load("res://Prefabs/bullet.tscn")
var instance
var SENSITIVITY = 0.003
var Zoomed: bool = false
var checkingGuide: bool = false

var gunStowPosition = Vector3(0.422, -0.416, -0.253)
var gunAimPosition = Vector3(-0.039, -0.286, 0.0)
var gunGuidePosition = Vector3(0.422, -0.75, -0.253)

var guideStowPosition = Vector3(0, -1.0, -0.6)
var guideUsePosition = Vector3(0, 0, -0.8)

var cameraFOVStow = 75
var cameraFOVAim = 20

var targets_shot: int = 0
var info_level: int = 0

@export var time: int = 0

#func Zoom():
	#if !Zoomed:
		#animation.play("Zooming")
		#SENSITIVITY = 0.0015
	#else:
		#animation.play_backwards("Zooming")
		#SENSITIVITY = 0.003
	#Zoomed = !Zoomed

func Fire():
	if shotProgress.readyToFire: 
		bulletShootSFX.play()
		instance = bullet.instantiate()
		instance.position = gun_barrel.global_position 
		instance.transform.basis = gun_barrel.global_transform.basis
		get_parent().add_child(instance)
		shotProgress.readyToFire = false
		animation.play("Recoil")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func createReport():
	
	var capLabel: String = ""
	if world.targetCharacter.cap >= len(world.targetCharacter.capSpecs):
		capLabel = "Target is not wearing a cap"
	else:
		capLabel = "Target is wearing a " + world.targetCharacter.capSpecs[world.targetCharacter.cap] + " cap"
	if info_level >=1:
		guideLabel.text = "> " + capLabel
	else:
		guideLabel.text = "> " + "shoot more targets"
	
	var eyeWearLabel: String = ""
	if world.targetCharacter.eyeWear >= len(world.targetCharacter.eyeWearSpecs):
		eyeWearLabel = "Target has perfect vision"
	else:
		eyeWearLabel = "Target is wearing " + world.targetCharacter.eyeWearSpecs[world.targetCharacter.eyeWear]
	if info_level >=2:
		guideLabel.text += "\n> " + eyeWearLabel
	else:
		guideLabel.text += "\n> " + "shoot more targets"
	
	var shirtLabel: String = "Target is wearing a " + world.targetCharacter.shirtColorSpecs[world.targetCharacter.shirtColor] + " shirt"
	if info_level >=3:
		guideLabel.text += "\n> " + shirtLabel
	else:
		guideLabel.text += "\n> " + "shoot more targets"
	
func _input(event):
	if event.is_action("exit"):
		get_tree().quit()
	
	if not checkingGuide:
		if event.is_action_pressed("right_click"):
			Zoomed = true
		elif event.is_action_released("right_click"):
			Zoomed = false
			
		if event.is_action_released("left_click"):
			Fire()
		
	if event.is_action_pressed("open_guide"):
		checkingGuide = true
	elif event.is_action_released("open_guide"):
		checkingGuide = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _process(delta: float) -> void:
	createReport()
	
	if checkingGuide: Zoomed = false
	
	var weaponPositionSetpoint: Vector3 = gunAimPosition if Zoomed else gunStowPosition
	var weaponRotSetpoint: float = deg_to_rad(90.0) if checkingGuide else 0.0
	var cameraFOVSetpoint: float = cameraFOVAim if Zoomed else cameraFOVStow
	var guidePositionSetpoint: Vector3 = guideUsePosition if checkingGuide else guideStowPosition
	
	gunHolder.position = lerp(gunHolder.position, weaponPositionSetpoint, 6.0 * delta)
	gunHolder.rotation.z = lerp(gunHolder.rotation.z, weaponRotSetpoint, 6.0 * delta)
	guide.position = lerp(guide.position, guidePositionSetpoint, 6.0 * delta)
	camera.fov = lerp(camera.fov, cameraFOVSetpoint, 6.0 * delta)
	
	shotProgress.visible = not checkingGuide
	
	crosshair.visible = Zoomed

func _physics_process(_delta):
	
	move_and_slide()

func _on_timer_display_time_update() -> void:
	time = $"CanvasLayer/Timer Display".total_time_in_secs


func _on_world_target_shot() -> void:
	targets_shot += 1
	if targets_shot > 2:
		info_level = 1
		if targets_shot > 4:
			info_level = 2
			if targets_shot > 7:
				info_level = 3
				if targets_shot > 10:
					info_level = 4
	createReport()
	print("info level = ",info_level)
	print("targets shot = ",targets_shot)
