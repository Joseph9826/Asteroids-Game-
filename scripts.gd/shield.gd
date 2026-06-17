extends Node2D

func _on_body_entered(body):
	if body is MeleeTarget:
		var tar = body
		tar.explode()
		queue_free()
	
