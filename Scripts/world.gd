extends Node3D

@export var numCharacter: int = 2
@onready var enemyResource: Resource = preload("res://Prefabs/character.tscn")
@onready var targetResource: Resource = preload("res://Prefabs/targets.tscn")
@onready var player = $Player

@onready var crowdBGNoise = $"Crowd Talking"
@onready var bgMusic = $"Background Music"

signal target_shot
signal targetAcquried
signal civilianKilled

var target_delay: int = 10
var target_spawn_time: int = 0
var targetCharacter

func _ready() -> void:
	
	var targetCap
	var targetEyeWear
	var targetShirtColor
	for i in range(numCharacter):
		
		var newCharacter = enemyResource.instantiate()
		newCharacter.civilianKilled.connect(civilian)
		newCharacter.targetAcquired.connect(target)
		
		var numSetpoints = randi_range(2, 5)
		for j in range(numSetpoints):
			
			var randX = randf_range(-50.0, 40.0)
			var randZ = randf_range(0, -50.0)
			newCharacter.setpoints.append(Vector3(randX, 0.2, randZ))
			
		newCharacter.position = newCharacter.setpoints[0]
		if (i == 0):
			newCharacter.isTarget = true
			targetCharacter = newCharacter
			player.createReport()
			targetCap = newCharacter.cap
			targetEyeWear = newCharacter.eyeWear
			targetShirtColor = newCharacter.shirtColor
		
		newCharacter.targetCap = targetCap
		newCharacter.targetEyeWear = targetEyeWear
		newCharacter.targetShirtColor = targetShirtColor
			
		add_child(newCharacter)	
		
	var xPos: int = -200
	var yPos: int = -200
	for i in range(randi_range(30, 40)):
		
		var newBuilding = CSGBox3D.new()
		var buildingWidth = randi_range(40, 50)
		var buildingHeight = randi_range(75, 150)
		newBuilding.size = Vector3(buildingWidth, buildingHeight, buildingWidth)
		newBuilding.use_collision = true
		
		newBuilding.position = Vector3(xPos, buildingHeight / 2, yPos + randi_range(2, 5))
		add_child(newBuilding)
		
		xPos += buildingWidth + randi_range(10, 15)
		if yPos > -120 and (xPos > -60 and xPos < 60):
			xPos += 125
		if (xPos > 180):
			
			xPos = -200
			yPos += 30 + randi_range(10, 15)
		

func targetSpawner():
	if player.time == target_spawn_time:
		target_spawn_time += target_delay
		target_delay = randi_range(0,10)
		var newTarget = targetResource.instantiate()
		newTarget.position = Vector3(randf_range(-8.0, 8.0), randf_range(2, 16.0),randf_range(0, -8.0))
		newTarget.died.connect(targetShot)
		add_child(newTarget)

func targetShot():
	emit_signal("target_shot")

func _process(delta: float) -> void:
	
	if not crowdBGNoise.playing:
		crowdBGNoise.play()
	if not bgMusic.playing:
		bgMusic.play()
	targetSpawner()
	
func civilian():
	emit_signal("civilianKilled")
func target():
	emit_signal("targetAcquried")
