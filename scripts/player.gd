#extends CharacterBody2D
#
#@export var speed := 500.0
#
#func _ready():
	#print("Player script is running")
#
#func _physics_process(_delta):
	#if Input.is_action_pressed("move_right"):
		#print("RIGHT pressed")
		#position.x += speed * _delta
#
	#if Input.is_action_pressed("move_left"):
		#print("LEFT pressed")
		#position.x -= speed * _delta
#
	#if Input.is_action_pressed("move_down"):
		#print("DOWN pressed")
		#position.y += speed * _delta
#
	#if Input.is_action_pressed("move_up"):
		#print("UP pressed")
		#position.y -= speed * _delta


extends CharacterBody2D

@export var speed := 300.0
@export var world_bounds := Rect2(Vector2.ZERO, Vector2(1800.0, 990.0))

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	print("Player script is running")

func _physics_process(_delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	velocity = direction.normalized() * speed
	move_and_slide()
	_clamp_to_world_bounds()

func _clamp_to_world_bounds() -> void:
	if collision_shape == null or collision_shape.shape == null:
		global_position = global_position.clamp(world_bounds.position, world_bounds.end)
		return

	var rect_shape := collision_shape.shape as RectangleShape2D
	if rect_shape == null:
		global_position = global_position.clamp(world_bounds.position, world_bounds.end)
		return

	var half_size := rect_shape.size * 0.5
	var min_point := collision_shape.global_position - half_size
	var max_point := collision_shape.global_position + half_size
	var correction := Vector2.ZERO

	if min_point.x < world_bounds.position.x:
		correction.x = world_bounds.position.x - min_point.x
	elif max_point.x > world_bounds.end.x:
		correction.x = world_bounds.end.x - max_point.x

	if min_point.y < world_bounds.position.y:
		correction.y = world_bounds.position.y - min_point.y
	elif max_point.y > world_bounds.end.y:
		correction.y = world_bounds.end.y - max_point.y

	if correction != Vector2.ZERO:
		global_position += correction
