class_name SpeedupPushZone
extends CameraControllerBase

const DEFAULT_PUSHBOX_SIZE:float = 3.0
const DEFAULT_SPEEDUP_ZONE_SIZE:float = 6.0

@export var push_ratio:float = 0.8
@export var pushbox_top_left:Vector2 = DEFAULT_PUSHBOX_SIZE * Vector2(-1, -1)
@export var pushbox_bottom_right:Vector2 = DEFAULT_PUSHBOX_SIZE * Vector2(1, 1)
@export var speedup_zone_top_left:Vector2 = DEFAULT_SPEEDUP_ZONE_SIZE * Vector2(-1, -1)
@export var speedup_zone_bottom_right:Vector2 = DEFAULT_SPEEDUP_ZONE_SIZE * Vector2(1, 1)

var _pushbox:Dictionary = {}
var _speedup_zone:Dictionary = {}

func _ready() -> void:
	super()
	position = target.position

	_pushbox = {
		"Left": pushbox_top_left.x,
		"Right": pushbox_bottom_right.x,
		"Top": pushbox_top_left.y,
		"Bottom": pushbox_bottom_right.y,
	}
	_speedup_zone = {
		"Left": speedup_zone_top_left.x,
		"Right": speedup_zone_bottom_right.x,
		"Top": speedup_zone_top_left.y,
		"Bottom": speedup_zone_bottom_right.y,
	}


func _process(delta: float) -> void:
	if not current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos:Vector3 = target.global_position
	var cpos:Vector3 = global_position
	
	# Difference from the center of the camera to the left/right/top/bottom of the target
	var diff_left_from_center:float = (tpos.x - target.WIDTH / 2.0) - (cpos.x)
	var diff_right_from_center:float = (tpos.x + target.WIDTH / 2.0) - (cpos.x)
	var diff_top_from_center:float = (tpos.z - target.HEIGHT / 2.0) - (cpos.z)
	var diff_bottom_from_center:float = (tpos.z + target.HEIGHT / 2.0) - (cpos.z)
	
	var target_horizontal_speed = abs(target.velocity.x)
	var target_vertical_speed = abs(target.velocity.z)
	
	var push_x:float = 0.0
	var push_z:float = 0.0
	
	# Boundary checks
	# Left
	if diff_left_from_center <= _speedup_zone["Left"]:
		push_x = (diff_left_from_center - _speedup_zone["Left"])
	elif diff_right_from_center <= _pushbox["Left"]:
		push_x = -1.0 * push_ratio * target_horizontal_speed * delta
	# Right
	if diff_right_from_center >= _speedup_zone["Right"]:
		push_x = (diff_right_from_center - _speedup_zone["Right"])
	elif diff_left_from_center >= _pushbox["Right"]:
		push_x = push_ratio * target_horizontal_speed * delta
	# Top
	if diff_top_from_center <= _speedup_zone["Top"]:
		push_z = (diff_top_from_center - _speedup_zone["Top"])
	elif diff_bottom_from_center <= _pushbox["Top"]:
		push_z = -1.0 * push_ratio * target_vertical_speed * delta
	# Bottom
	if diff_bottom_from_center >= _speedup_zone["Bottom"]:
		push_z = (diff_bottom_from_center - _speedup_zone["Bottom"])
	elif diff_top_from_center >= _pushbox["Bottom"]:
		push_z = push_ratio * target_vertical_speed * delta
	
	# Move the camera
	global_position.x += push_x
	global_position.z += push_z
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF	
	
	# Draw the pushbox
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	_draw_box(immediate_mesh, _pushbox)
	immediate_mesh.surface_end()
	
	# Draw the speedup zone
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	_draw_box(immediate_mesh, _speedup_zone)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()


func _draw_box(immediate_mesh:ImmediateMesh, box:Dictionary) -> void:
	immediate_mesh.surface_add_vertex(Vector3(box["Right"], 0, box["Top"]))
	immediate_mesh.surface_add_vertex(Vector3(box["Right"], 0, box["Bottom"]))
	
	immediate_mesh.surface_add_vertex(Vector3(box["Right"], 0, box["Bottom"]))
	immediate_mesh.surface_add_vertex(Vector3(box["Left"], 0, box["Bottom"]))
	
	immediate_mesh.surface_add_vertex(Vector3(box["Left"], 0, box["Bottom"]))
	immediate_mesh.surface_add_vertex(Vector3(box["Left"], 0, box["Top"]))
	
	immediate_mesh.surface_add_vertex(Vector3(box["Left"], 0, box["Top"]))
	immediate_mesh.surface_add_vertex(Vector3(box["Right"], 0, box["Top"]))
