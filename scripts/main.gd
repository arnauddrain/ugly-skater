extends Node2D

var screen_size
var rng = RandomNumberGenerator.new()
var trash_scene
var trash_fire_scene
var street_size
var street_scene
var score

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

func _on_TrashTimer_timeout():
	if rng.randi_range(0, 10) > 4:
		var trash_node
		if rng.randi_range(0,3) > 1:
			trash_node = trash_scene.instantiate()
		else:
			trash_node = trash_fire_scene.instantiate()
		add_child(trash_node)
		move_child(trash_node, 100)
		trash_node.position.y = screen_size.y / 2 + 20
		trash_node.position.x = $Player.position.x + screen_size.x
		trash_node.connect("up_score", Callable(self, "_on_up_score"))

func _on_up_score():
	score += 1
	$CanvasLayer/HUD.update_score(score)
	
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

func _on_HUD_start_game():
	$Music.play()
	get_tree().call_group("trash", "remove")
	score = 0
	$CanvasLayer/HUD.update_score(score)
	$Player.live()
	$Player.position.x = screen_size.x / 4
	$Player.position.y = screen_size.y / 2
	generateStreet()
