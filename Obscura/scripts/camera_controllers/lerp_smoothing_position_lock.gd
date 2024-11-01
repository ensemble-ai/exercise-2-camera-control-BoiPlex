class_name LerpSmoothingPositionLock
extends CameraControllerBase

@export var follow_speed:float = 10.0
@export var catchup_speed:float = 5.0
@export var leash_distance:float = 5.0

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
	
	var diff := Vector2(tpos.x - cpos.x, tpos.z - cpos.z)
	var distance:float = diff.length()
	
	var moving_target:bool = not target.velocity.is_zero_approx()
	
	if not moving_target:
		global_position = global_position.lerp(tpos, catchup_speed * delta)
	elif distance > leash_distance:
		var plane_direction:Vector2 = diff.normalized()
		var direction := Vector3(plane_direction.x, 0.0, plane_direction.y)
		var leash_position:Vector3 = tpos - direction * leash_distance
		global_position.x = leash_position.x
		global_position.z = leash_position.z
	else:
		global_position = global_position.lerp(tpos, follow_speed * delta)
		
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
