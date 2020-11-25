extends Spatial
export var fixed_door : bool
export var locked : bool
var open : bool
func _ready():
	if !locked:
		$key_hole.queue_free()
		$key_hole2.queue_free()
func open_door():
	if !locked and !fixed_door and !open:
		$AnimationPlayer.play("open")
		self.open=true

func unlock():
	print("unlocked")
	$key_hole.queue_free()
	$key_hole2.queue_free()
	self.locked=false



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="open" and open:
		$close_door.start()


func _on_close_door_timeout():
	self.open=false
	$AnimationPlayer.play_backwards("open")
