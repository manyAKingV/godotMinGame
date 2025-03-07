extends RigidBody3D

@export_range(300,3000) var thrust: float = 1000.0
@export_range(10,300) var rs: float = 1000.0
var transtioning: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("up"):
		apply_central_force(basis.y * delta * thrust)
	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0,0.0,rs * delta))
	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0,0.0,-rs * delta))


func _on_body_entered(body):
	if transtioning == false:
		if "group" in body.get_groups():
			crash_sequence(body.file_path)
		if "knocked" in body.get_groups():
			complete_level()
		if "cloth" in body.get_groups():
			print("碰上了")

# 重新加载场景
func complete_level():
	print("KABOOM!")
	transtioning = true
	set_process(false)  # 设置键盘输入不再监听
	# 类似于延迟函数 time
	var tween = create_tween() 
	tween.tween_interval(1.0) # 延迟1s
	tween.tween_callback(get_tree().reload_current_scene) # 执行get_tree().reload_current_scene()方法
	

# 进入下一关
func crash_sequence(scene_file_path: String):
	# 执行时，将会转到文件路径所在的场景	
	transtioning = true
	set_process(false)
	var tween = create_tween() 
	tween.tween_interval(1.0) # 延迟1s
	tween.tween_callback(get_tree().change_scene_to_file.bind(scene_file_path))
	
