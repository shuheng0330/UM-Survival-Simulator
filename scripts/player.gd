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
