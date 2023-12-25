extends CharacterBody2D

var player_velocity = Vector2()
var jumping = false
var jump_speed = -400
var gravity = 1000
var jump_duration = 0.8
var current_jump_duration = 0
var jumping_more = false

signal burned

func _ready():
	live()
	
func skate():
	if jumping:
		$Land.play()
	jumping = false
	jumping_more = false
	$AnimationPlayer.play("skate")

func jump():
	if jumping == false && is_on_floor():
		jumping = true
		player_velocity.y = jump_speed
		jumping_more = true
		current_jump_duration = jump_duration
		$Jump.play()
		$AnimationPlayer.play("jump")

func live():
	show()
	player_velocity.x = 200
	skate()

func die():
	emit_signal("burned")
	hide()
	player_velocity = Vector2()
	
func stop_jump():
	if jumping == true && jumping_more == true:
		jumping_more = false

func _physics_process(delta):
	player_velocity.y += gravity * delta
	if jumping_more && current_jump_duration > 0:
		current_jump_duration -= delta
		player_velocity.y += jump_speed * delta * 2
	set_velocity(player_velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	if is_on_floor() && jumping:
		skate()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is TrashFire:
			die()
	

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		jump()
	if event is InputEventScreenTouch and !event.pressed:
		stop_jump()
