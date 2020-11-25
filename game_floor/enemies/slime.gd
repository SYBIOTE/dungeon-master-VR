extends KinematicBody

var path=[]
var path_node=0
var speed = 2.5
var detected : bool
var element : int
var ele_list=[Color("ffffff"),Color("ff9500"),Color("00fff3")]
var names=["cryo","pyro","hydro"]
export var small :bool
export var medium :bool
export var large:bool
onready var nav = get_parent()
func _ready():
	$body/health.texture.set("width",9)
	set_physics_process(false)
	randomize()
	var color = $body.get("material/0")
#	print("color is ", color.emission)
	var choice=randi()%3
	element=choice
	color.emission=ele_list[element]
	$body.set("material/0",color)
	$body/Label3D.text=names[element]
#	color = $body.get("material/0")
#	print("color is  ", color.emission)
	$body/OmniLight.light_color=ele_list[element]
	if small:
		scale=Vector3(1,1,1)*.2
	if medium:
		scale=Vector3(1,1,1)*.5
	if large:
		scale=Vector3(1,1,1)*.8
func _physics_process(delta):
	if path_node<path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length()<1:
			path_node+=1
		else:
			move_and_slide(direction.normalized()*speed,Vector3.UP)
	aim()
func move_to(pos):
	path=nav.get_simple_path(global_transform.origin,pos)
	path_node=0
func aim():
	var desired = global_transform.looking_at(vr.vrCamera.global_transform.origin,Vector3.UP)
	var desired_rot= desired.basis.get_euler()
#	var desired_rot=transform.looking_at(vr.player_pos,Vector3.UP)
#	var a=Quat(transform.basis.get_rotation_quat()).slerp(desired_rot.basis.get_rotation_quat(),.1)
	desired_rot.y+=deg2rad(180)
	rotation.y=lerp_angle(rotation.y,desired_rot.y,.07)
#	set_transform(Transform(a,transform.origin))
#	scale=s
#func attack():
#	pass
func die():
	$slime/CollisionShape2.disabled=true
	$AnimationPlayer.play("die")


func take_dmg():
	if (element+1)%3==vr.current_sword_element:
		hits+=1
		if small:
			$body/health.texture.set("width",0)
			if hits==1:
				die()
		if medium:
			$body/health.texture.set("width",$body/health.texture.get_width()-$body/health.texture.get_width()/3)
			if hits==3:
				die()
		if large:
			$body/health.texture.set("width",$body/health.texture.get_width()-$body/health.texture.get_width()/5)
			if hits==5:
				die()
		
var hits=0
func _on_slime_body_entered(body):
	if body.name=="sword_blade":
		take_dmg()
		

func _on_Timer_timeout():
	if detected:
		move_to(vr.vrCamera.global_transform.origin)

func _on_detection_body_entered(body):
	if body.name == "Feature_PlayerCollision" and !detected:
		detected = true
		$AnimationPlayer.play("MOVE")
		set_physics_process(true)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="die":
		print("dead")
		queue_free()




func _on_detection_body_exited(body):
	if body.name == "Feature_PlayerCollision" and detected:
		detected = false
		$AnimationPlayer.stop()
		set_physics_process(false)


func _on_slime_area_entered(area):
	if area.name=="player":
		print("affected")
