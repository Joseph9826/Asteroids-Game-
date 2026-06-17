extends Control

func _on_button_pressed():
	# Load the game scene when the button is pressed
	var scene = ResourceLoader.load("res://Asteroids.tscn") as PackedScene
	if scene:
		get_tree().change_scene_to(scene)
	else:
		print("Failed to load scene.")
