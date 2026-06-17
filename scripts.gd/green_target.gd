extends Area2D

var target_movement_vector := Vector2(0,-1)
enum AsteroidSize{MEDIUM}
@export var size := AsteroidSize.MEDIUM
@onready var sprite = $Sprite2D
var speed := 50
func _ready():
	rotation = randf_range(0,2*PI)
	match size:
		
		AsteroidSize.MEDIUM:
			speed = randf_range(100,150)
			sprite.texture = preload("res://scripts.gd/1200px-Smash_Target_SSBB_Models Green Target.png")
		
	print(speed)
		
	
func _physics_process(delta):
	global_position += target_movement_vector.rotated(rotation) * speed * delta
