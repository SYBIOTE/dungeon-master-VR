extends Spatial




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_play_pressed():
	vr.switch_scene("res://game_floor/floor_1.tscn")


func _on_quit_pressed():
	get_tree().quit()
