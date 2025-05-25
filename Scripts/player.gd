extends CharacterBody3D


@onready var head = $CameraController
@onready var camera = $CameraController/Camera3D
@onready var animation = $AnimationPlayer
@onready var gunHolder = $CameraController/Camera3D/WeaponHolder
@onready var gun_barrel = $CameraController/Camera3D/WeaponHolder/RayCast3D
@onready var shotProgress = $"CanvasLayer/Shot Progress"
@onready var crosshair = $CanvasLayer/Crosshair

@onready var bulletShootSFX = $"Shoot Bullet SFX"

var bullet = load("res://Prefabs/bullet.tscn")
var instance
var SENSITIVITY = 0.003
var Zoomed: bool = false

var stowPosition = Vector3(0.422, -0.416, -0.253)
var aimPosition = Vector3(-0.039, -0.286, 0.0)

var cameraFOVStow = 75
var cameraFOVAim = 20

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
	
func _input(event):
	if event.is_action("exit"):
		get_tree().quit()
	if event.is_action("right_click"):
		Zoomed = !Zoomed
	if event.is_action_released("left_click"):
		Fire()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _process(delta: float) -> void:
	
	var weaponPositionSetpoint: Vector3 = aimPosition if Zoomed else stowPosition
	gunHolder.position = lerp(gunHolder.position, weaponPositionSetpoint, 6.0 * delta)
	
	var cameraFOVSetpoint: float = cameraFOVAim if Zoomed else cameraFOVStow
	camera.fov = lerp(camera.fov, cameraFOVSetpoint, 6.0 * delta)
	
	crosshair.visible = Zoomed

func _physics_process(_delta):
	
	move_and_slide()

func _on_timer_display_time_update() -> void:
	time = $"CanvasLayer/Timer Display".total_time_in_secs
