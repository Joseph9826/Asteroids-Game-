class_name Ship extends CharacterBody2D

signal laser_shot(laser)
signal died()
@export var acceleration := 10.0
@export var ship_speed := 350.0
@export var rotation_speed := 100.0
@onready var gunTip = $muzzle
@onready var sprite = $Sprite2D
@onready var shield = $Shield
var laser_scene = preload("res://laser.tscn")
var laser_cd = false
var alive := true

func _process(delta):
	
	if Input.is_action_pressed("shoot"):
		if !laser_cd:
			laser_cd = true
			shoot_laser()
			await get_tree().create_timer(0.15).timeout
			laser_cd = false
			
func _physics_process(delta):
	var input_vector := Vector2(0, Input.get_axis("move_foward", "move_backward"))
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(ship_speed)
	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(rotation_speed * delta))
	if Input.is_action_pressed("rotate_left"):
		rotate(deg_to_rad(-rotation_speed * delta))
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	move_and_slide()
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0
	
func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = gunTip.global_position
	l.rotation = rotation
	emit_signal("laser_shot", l)


func die():
	if alive == true:
		alive = false
		emit_signal("died")
		sprite.visible = false
		process_mode = Node.PROCESS_MODE_DISABLED

func respawn(pos):
	if alive == false:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		process_mode = Node.PROCESS_MODE_INHERIT


	
