extends Node3D

@export var numCharacter: int = 2
@onready var enemyResource: Resource = preload("res://Prefabs/character.tscn")
@onready var targetResource: Resource = preload("res://Prefabs/targets.tscn")
@onready var player = $Player

signal target_shot

var target_delay: int = 10
var target_spawn_time: int = 0
var targetCharacter

func _ready() -> void:
	
	for i in range(numCharacter):
		
		var newCharacter = enemyResource.instantiate()
		
		var numSetpoints = randi_range(2, 5)
		for j in range(numSetpoints):
			
			var randX = randf_range(-40.0, 40.0)
			var randZ = randf_range(0, -40.0)
			newCharacter.setpoints.append(Vector3(randX, 0.2, randZ))
			
		newCharacter.position = newCharacter.setpoints[0]
		if (i == 0):
			newCharacter.isTarget = true
			targetCharacter = newCharacter
			player.updateReport()
			
		add_child(newCharacter)	
		

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
	targetSpawner()
	
