extends State
class_name PlayerGrip

var latched_obj
var mount
var align
signal CollideToggle

func enter():
		player.linear_velocity = Vector2.ZERO
		#set grip surface values
		latched_obj = get_parent().grip_surface
		mount = latched_obj.player_position
		align = latched_obj.alignment_vector
		
		CollideToggle.emit(true, latched_obj.owner)
		player.position = mount.global_position
		player.rotation = align.angle()
		
		#assign player to be effected by surface's remote transform 
		#latched_obj.remote_transform_2d.remote_path = player.get_path()
		#align position and rotation to player

		#animate
		player.paper_character.set_animation("Grab")

func exit():
	CollideToggle.emit(false, latched_obj.owner)
	

func physics_update(_delta:float):
	point_and_tools()
	
	if Input.is_action_just_pressed("click"):
		latched_obj.remote_transform_2d.remote_path = latched_obj.get_path()
		kick_off()
		Transitioned.emit(self,"PlayerZeroG")
		
	
func forces_update(state: PhysicsDirectBodyState2D):
	if align:
		player.global_rotation = latched_obj.alignment_vector.angle()
	if mount:
		player.position = mount.global_position
