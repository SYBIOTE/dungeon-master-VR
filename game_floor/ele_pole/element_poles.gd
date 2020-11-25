extends Spatial

var ele=[Color("ffffff"),Color("ff9500"),Color("00fff3")]
var element=0

func _ready():
	randomize()
	$switch.wait_time=randi()%5+7
	set_element()

func set_element():
	var mat=$orb.get("material/0")
	mat.emission=ele[element]
	$orb.set("material/0",mat)
	$orb/OmniLight.light_color=ele[element]
	
func _on_switch_timeout():
	element+=1
	element%=3
	set_element()
	

