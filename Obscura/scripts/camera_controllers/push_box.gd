class_name PushBox
extends CameraControllerBase

@export var box_width:float = 10.0
@export var box_height:float = 10.0

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
	
	# Boundary checks
	# Left
	var diff_between_left_edges:float = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	if diff_between_left_edges < 0.0:
		global_position.x += diff_between_left_edges
	# Right
	var diff_between_right_edges:float = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	if diff_between_right_edges > 0.0:
		global_position.x += diff_between_right_edges
	# Top
	var diff_between_top_edges:float = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	if diff_between_top_edges < 0.0:
		global_position.z += diff_between_top_edges
	# Bottom
	var diff_between_bottom_edges:float = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	if diff_between_bottom_edges > 0.0:
		global_position.z += diff_between_bottom_edges
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -box_width / 2.0
	var right:float = box_width / 2.0
	var top:float = -box_height / 2.0
	var bottom:float = box_height / 2.0
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
