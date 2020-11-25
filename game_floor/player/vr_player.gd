extends Spatial

var sword_ele=[Color("ffffff"),Color("ff9500"),Color("00fff3")]
var random = RandomNumberGenerator.new()
onready var health = $OQ_ARVROrigin/OQ_LeftController/OQ_VisibilityToggle/OQ_UI2DCanvas
var keys=0
var damaging=false
func _ready():
	random.randomize()


func set_element(element):
	var mat = $OQ_ARVROrigin/OQ_RightController/blade/hand/sword/Sword001/blade001.get("material/0")
	print(mat)
	mat.emission = sword_ele[element]
	$OQ_ARVROrigin/OQ_RightController/blade/hand/sword/Sword001/blade001.set("material/0",mat)

func _process(delta):
	if damaging:
		health.ui_control.value-=10
		

func _on_player_area_exited(area):
	if area.name=="slime":
		damaging=false
		print("out of damage")
func _on_player_area_entered(area):
	if area.name=="slime":
		damaging=true
		print("damaged trigger")

func _on_blade_area_entered(area):
	if area.name=="slime":
		print("hit")
		var element=area.get_parent().element
		set_element(element)
		vr.current_sword_element=element
	if area.name=="element_pole":
		print("area pole entered")
		var element=area.get_parent().element
		print("element")
		set_element(element)
		vr.current_sword_element=element


func _on_hand_body_entered(body):
	var l_o_s=body
	print("entered body", l_o_s.name)
	match l_o_s.name :
		"key":
			keys+=1
			print("got key, numbers of keys = ", keys)
			l_o_s.get_parent().queue_free()
		"keyhole":
			if keys>0:
				l_o_s.get_parent().get_parent().unlock()
				keys-=1
			else:
				print("no keys")
			print("unlocked, numbers of keys = ", keys )

		"door":
			l_o_s.get_parent().get_parent().open_door()
		"transport_1":
			print("switching")
			vr.switch_scene("res://game_floor/floor_2.tscn")
		"transport_2":
			print("switching")
			vr.switch_scene("res://starting_vr/vr_main.tscn")


func _on_health_value_changed(value):
	if value<1:
		vr.switch_scene("res://starting_vr/vr_main.tscn")


