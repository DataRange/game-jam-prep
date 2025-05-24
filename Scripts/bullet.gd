extends Area3D

const speed = 80.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,-speed,0) * delta


func _on_area_entered(area: Area3D) -> void:
	queue_free()
