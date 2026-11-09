extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 5.0

# Player nodes
@onready var head: Node3D = $head
@onready var touch_debug: ColorRect = $CanvasLayer/CameraTouch/Touch_debug

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# =========================================================================
	# CAMERA ORIENTATION & UP/DOWN PITCH FIX
	# =========================================================================
	var input_dir := Input.get_vector("a", "d", "w", "s")
	
	# 1. Get the camera/head's forward and right directions
	var forward := -head.global_transform.basis.z
	var right := head.global_transform.basis.x
	
	# 2. FLATTEN the up/down (pitch) tilt by zeroing out the Y axis. 
	#    This ensures looking up or down never tilts your movement into the floor/sky.
	forward.y = 0.0
	forward = forward.normalized()
	
	right.y = 0.0
	right = right.normalized()
	
	# 3. Combine inputs with the flattened camera orientation
	var direction := (forward * -input_dir.y + right * input_dir.x).normalized()
	# =========================================================================

	# Ground and air movement logic
	if is_on_floor():
		if direction != Vector3.ZERO:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 2.0)

	# Toggle debug view
	if Input.is_action_pressed("0"):
		touch_debug.visible = !touch_debug.visible

	move_and_slide()

	# Head updates headbob independently
	if head.has_method("update_headbob"):
		head.update_headbob(delta, velocity.length(), is_on_floor())
