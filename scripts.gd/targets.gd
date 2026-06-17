class_name MeleeTarget extends Area2D

signal exploded(pos, size, points)
var target_movement_vector := Vector2(0,-1)
enum AsteroidSize{LARGE, MEDIUM, SMALL}
@export var size := AsteroidSize.LARGE
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D


var speed := 50

var points: int:
	get:
		match size:
			AsteroidSize.LARGE:
				return 25
			AsteroidSize.MEDIUM:
				return 50
			AsteroidSize.SMALL:
				return 100
			_:
				return 0
			

func _ready():
	
	match size:
		AsteroidSize.LARGE:
			speed = randf_range(100,200)
			sprite.texture = preload("res://Game Parts/slow speed target.png")
			cshape.shape = preload("res://Shapes/targets.tres")
		AsteroidSize.MEDIUM:
			speed = randf_range(200,300)
			sprite.texture = preload("res://Game Parts/Moderate speed target.png")
			cshape.shape = preload("res://Shapes/targets.tres")
		AsteroidSize.SMALL:
			speed = randf_range(300,400)
			sprite.texture = preload("res://Game Parts/SSBM_Trophy_Target (1).png")
			cshape.shape = preload("res://Shapes/targets.tres")
	
		
	
func _physics_process(delta):
	global_position += target_movement_vector.rotated(rotation) * speed * delta
	var radius = cshape.shape.radius
	var screen_size = get_viewport_rect().size
	if (global_position.y+radius) < 0:
		global_position.y = (screen_size.y+radius)
	elif (global_position.y-radius) > screen_size.y:
		global_position.y = -radius
	if (global_position.x+radius) < 0:
		global_position.x = (screen_size.x+radius)
	elif (global_position.x-radius) > screen_size.x:
		global_position.x = -radius

func explode():
	emit_signal("exploded", global_position, size, points)
	queue_free()
		
	
		


func _on_body_entered(body):
	if body is Ship:
		var ship = body
		ship.die()
