extends Area2D

var is_area_empty: bool:
	get:
		return !has_overlapping_areas() && !has_overlapping_bodies()
		
