extends Control
@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value)
var UIlife_scene = preload("res://ui_life.tscn")
@onready var lives = $Lives
func init_lives(amount):
	for ui in lives.get_children():
		ui.queue_free()
	for i in amount:
		var ui = UIlife_scene.instantiate()
		lives.add_child(ui)
