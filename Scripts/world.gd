extends Node3D

@export var numCharacter: int = 2
@onready var enemyResource: Resource = preload("res://Prefabs/character.tscn")

func _ready() -> void:
	
	for i in range(numCharacter):
		
		var newCharacter: RigidBody3D = enemyResource.instantiate()
		
		var numSetpoints = randi_range(2, 5)
		for j in range(numSetpoints):
			
			var randX = randf_range(-8.0, 8.0)
			var randZ = randf_range(0, -8.0)
			newCharacter.setpoints.append(Vector3(randX, 1.5, randZ))
			
		newCharacter.position = newCharacter.setpoints[0]
		if (i == 0):
			newCharacter.isTarget = true
			var characterNodes: Array[Node] = newCharacter.get_children()
			for characterNode in characterNodes:
				if characterNode.name == "CharacterMesh":
					var targetMaterial: StandardMaterial3D = StandardMaterial3D.new()
					targetMaterial.albedo_color = Color.RED
					characterNode.material_overlay = targetMaterial
					break
			
		add_child(newCharacter)
