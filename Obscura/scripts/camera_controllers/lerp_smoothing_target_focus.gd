class_name LerpSmoothingTargetFocus
extends CameraControllerBase

@export var lead_speed:float = 3.0
@export var catchup_delay_duration:float = 0.2
@export var catchup_speed:float = 5.0
@export var leash_distance:float = 7.0

var _buffer:float = 0.1
var _catchup_timer:float = 0.0

func _ready() -> void:
	super()
	position = target.position

	
func _process(delta: float) -> void:
	if not current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos:Vector3 = target.global_position
	var cpos:Vector3 = global_position
	
	var moving_target:bool = not target.velocity.is_zero_approx()
	
	# Move camera with target
	global_position += target.velocity * delta
	
	# Decide how to lerp relatively
	if not moving_target:
		_catchup_timer += delta
		if _catchup_timer >= catchup_delay_duration:
			global_position = global_position.lerp(tpos, catchup_speed * delta)
	else:
		_catchup_timer = 0.0
		var direction := target.velocity.normalized()
		var leash_position:Vector3 = tpos + direction * leash_distance
		global_position = global_position.lerp(leash_position, lead_speed * delta)
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var crosshair_len:float = 5.0
	
	var left:float = -crosshair_len / 2.0
	var right:float = crosshair_len / 2.0
	var top:float = -crosshair_len / 2.0
	var bottom:float = crosshair_len / 2.0
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))
	
	immediate_mesh.surface_add_vertex(Vector3(0, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
