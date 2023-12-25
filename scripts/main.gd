extends Node2D

var screen_size
var rng = RandomNumberGenerator.new()
var trash_scene
var trash_fire_scene
var street_size
var street_scene
var score
var next_trash

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	screen_size = get_viewport_rect().size
	trash_scene = load("res://scenes/trash.tscn")
	trash_fire_scene = load("res://scenes/trash-fire.tscn")
	var camera = $Player.get_node("Camera3D")
	camera.limit_top = 10
	street_scene = load("res://scenes/street.tscn")
	var street_node_sample = street_scene.instantiate()
	street_size = street_node_sample.get_node('Sprite2D').texture.get_size() * street_node_sample.scale
	$Player.position.x = screen_size.x / 4
	$Player.position.y = screen_size.y / 2
	generateStreet()

func add_element(node, offset = 0):
	add_child(node);
	move_child(node, 100)
	node.position.y = screen_size.y / 2 + 20
	node.position.x = $Player.position.x + screen_size.x + street_size.x * offset

# this is call every "meter" (every square of street)
func _on_up_score():
	score += 1
	if score > 100 && score % 10 == 0:
		$Player.faster()
	$CanvasLayer/HUD.update_score(score)
	if next_trash > 0:
		next_trash -= 1
	if next_trash == 0:
		# first 25 meters, a fire trash with at least 3 spaces
		if score < 25:
			if rng.randi_range(0, 2) > 1:
				next_trash = 3
				add_element(trash_fire_scene.instantiate())
		# then probability increase
		elif score < 50:
			if rng.randi_range(0, 2) >= 1:
				next_trash = 3
				add_element(trash_fire_scene.instantiate())
		# then sometimes 2 trashes, and sometimes closer, but 2/5 chances of nothing
		elif score < 75:
			var scenario = randi_range(0, 4)
			if scenario == 0:
				next_trash = 3
				add_element(trash_fire_scene.instantiate(), 0)
				add_element(trash_fire_scene.instantiate(), 0.4)
			elif score == 1:
				next_trash = 3
				add_element(trash_fire_scene.instantiate(), 0)
			elif score == 2:
				next_trash = 2
				add_element(trash_fire_scene.instantiate(), 0)
		# then fun muahah
		else:
			var scenario = randi_range(0, 5)
			if scenario == 0:
				next_trash = 3
				add_element(trash_scene.instantiate())
				add_element(trash_fire_scene.instantiate(), 1)
				add_element(trash_fire_scene.instantiate(), 1.5)
			elif scenario == 1:
				next_trash = 3
				add_element(trash_fire_scene.instantiate(), 0)
				add_element(trash_fire_scene.instantiate(), 0.4)
			elif score == 2:
				next_trash = 3
				add_element(trash_fire_scene.instantiate(), 0)
			else:
				next_trash = 2
				add_element(trash_fire_scene.instantiate(), 0)
	
func _on_Player_burned():
	$Music.stop()
	$CanvasLayer/HUD.game_over()

func generateStreet():
	# deleting existing streets
	get_tree().call_group("street", "queue_free")
	
	# generating the street blocks
	for i in range(9):
		var street_node = street_scene.instantiate()
		street_node.position.x = i * street_size.x;
		street_node.position.y = screen_size.y - street_size.y / 2 + 20;
		add_child(street_node)
		move_child(street_node, 1)
		street_node.add_to_group("street")
		street_node.connect("up_score", Callable(self, "_on_up_score"))

func _on_HUD_start_game():
	$Music.play()
	get_tree().call_group("trash", "remove")
	score = 0
	next_trash = 0
	$CanvasLayer/HUD.update_score(score)
	$Player.live()
	$Player.position.x = screen_size.x / 4
	$Player.position.y = screen_size.y / 2
	generateStreet()
