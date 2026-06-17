extends Node2D

@onready var lasers = $Lasers
@onready var player = $ship
@onready var target = $Target
@onready var hud = $UI/HUD
@onready var failure_screen = $UI/GameOverScreen
@onready var respawn = $PlayerRespawnPos
@onready var player_spawn = $PlayerRespawnPos/PlayerSpawnArea
@onready var  start_screen = $UI/MainScreen
@onready var win_screen = $UI/CompleteScreen
@onready var reflector = $Shield

var target_scene = preload("res://targets.tscn")

var playerscore := 0:
		set(value):
			playerscore = value
			hud.score = playerscore
var lives = 3:
	set(value):
		lives = value
		hud.init_lives(lives)

func _ready():
	
	
	$GameMusic.play()
	
	win_screen.visible = false
	failure_screen.visible = false
	playerscore = 0
	lives = 3
		
	
	player.connect("laser_shot", _on_player_bullet_shot)
	player.connect("died", _on_player_death)
	
	for targets in target.get_children():
			targets.connect("exploded", _on_target_hit)
		
			
	
		

func _process(_delta):
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
	
	if target.get_child_count() == 0:
		$GameMusic.stop()
		$Complete.play()
		win_screen.visible = true 
	
	
	
		
		
		
		
func _on_player_bullet_shot(laser):
	$LaserSound.play()
	lasers.add_child(laser)

func _on_target_hit(pos, size, _points):
	$TargetHitSound.play()
	playerscore += _points
	for i in range(2):
		match size:
			MeleeTarget.AsteroidSize.LARGE:
				spawn_target(pos, MeleeTarget.AsteroidSize.MEDIUM)
			MeleeTarget.AsteroidSize.MEDIUM:
				spawn_target(pos, MeleeTarget.AsteroidSize.SMALL)
			MeleeTarget.AsteroidSize.SMALL:
				pass
				
		
			
	

func spawn_target(pos, size):
	var a = target_scene.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("exploded", _on_target_hit)
	target.add_child(a)
	
		
	
func _on_player_death():
	$Explosion.play()
	lives -= 1
	if lives <= 0:
		$GameMusic.stop()
		$CrowdGasp.play()
		await get_tree().create_timer(1).timeout
		$Announcer.play()
		failure_screen.visible = true
	else:
		await get_tree().create_timer(1).timeout
		while !player_spawn.is_area_empty:
			await get_tree().create_timer(0.1).timeout
		player.respawn(respawn.global_position)
