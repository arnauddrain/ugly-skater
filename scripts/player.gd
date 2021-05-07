extends KinematicBody2D

var velocity = Vector2()
var jumping = false
var jump_speed = -400
var gravity = 1000
var jump_duration = 0.8
var current_jump_duration = 0
var jumping_more = false

signal burned

# Called when the node enters the scene tree for the first time.
func _ready():
	skate()
	velocity.x = 200

func skate():
	jumping = false
	jumping_more = false
	$AnimationPlayer.play("skate")

func jump():
	if jumping == false && is_on_floor():
		jumping = true
		velocity.y = jump_speed
		jumping_more = true
		current_jump_duration = jump_duration
		$AnimationPlayer.play("jump")
	
	
func stop_jump():
	if jumping == true && jumping_more == true:
		jumping_more = false

func _physics_process(delta):
	velocity.y += gravity * delta
	if jumping_more && current_jump_duration > 0:
		current_jump_duration -= delta
		velocity.y += jump_speed * delta * 2
	move_and_slide(velocity, Vector2.UP)
	if is_on_floor() && jumping:
		skate()
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is TrashFire:
			emit_signal("burned")
			hide()
			velocity.x = 0
	

func _input(event):

	if event is InputEventScreenTouch and event.pressed:
		jump()
	if event is InputEventScreenTouch and !event.pressed:
		stop_jump()
