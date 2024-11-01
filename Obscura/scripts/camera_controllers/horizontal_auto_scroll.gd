class_name HorizontalAutoScroll
extends CameraControllerBase

const DEFAULT_BOX_SIZE:float = 5.0

@export var top_left:Vector2 = DEFAULT_BOX_SIZE * Vector2(-1, -1)
@export var bottom_right:Vector2 = DEFAULT_BOX_SIZE * Vector2(1, 1)
@export var autoscroll_speed:Vector3 = Vector3(10, 0, 0)

var _left:float
var _right:float
var _top:float
var _bottom:float

func _ready() -> void:
	super()
	position = target.position
	
	_left = top_left.x
	_right = bottom_right.x
	_top = top_left.y
	_bottom = bottom_right.y
	

func _process(delta: float) -> void:
	if not current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos:Vector3 = target.global_position
	var cpos:Vector3 = global_position
	
	# Autoscroll
	target.global_position += autoscroll_speed * delta
	global_position += autoscroll_speed * delta
	
	# Boundary checks
	# Left
	var diff_between_left_edges:float = (tpos.x - target.WIDTH / 2.0) - (cpos.x + _left)
	if diff_between_left_edges < 0.0:
		target.global_position.x -= diff_between_left_edges
	# Right
	var diff_between_right_edges:float = (tpos.x + target.WIDTH / 2.0) - (cpos.x + _right)
	if diff_between_right_edges > 0.0:
		target.global_position.x -= diff_between_right_edges
	# Top
	var diff_between_top_edges:float = (tpos.z - target.HEIGHT / 2.0) - (cpos.z + _top)
	if diff_between_top_edges < 0.0:
		target.global_position.z -= diff_between_top_edges
	# Bottom
	var diff_between_bottom_edges:float = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + _bottom)
	if diff_between_bottom_edges > 0.0:
		target.global_position.z -= diff_between_bottom_edges
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(_right, 0, _top))
	immediate_mesh.surface_add_vertex(Vector3(_right, 0, _bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(_right, 0, _bottom))
	immediate_mesh.surface_add_vertex(Vector3(_left, 0, _bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(_left, 0, _bottom))
	immediate_mesh.surface_add_vertex(Vector3(_left, 0, _top))
	
	immediate_mesh.surface_add_vertex(Vector3(_left, 0, _top))
	immediate_mesh.surface_add_vertex(Vector3(_right, 0, _top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
