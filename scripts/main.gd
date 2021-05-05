extends Node2D

var screen_size
var rng = RandomNumberGenerator.new()
var trash_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	screen_size = get_viewport_rect().size
	trash_scene = load("res://scenes/trash.tscn")
	var street_scene = load("res://scenes/street.tscn")
	var street_node_sample = street_scene.instance()
	var street_size = street_node_sample.get_node('Sprite').texture.get_size() * street_node_sample.scale
	$Player.position.x = screen_size.x / 4
	$Player.position.y = screen_size.y / 2
	for i in range(9):
		var street_node = street_scene.instance()
		street_node.position.x = i * street_size.x;
		street_node.position.y = screen_size.y - street_size.y / 2 + 20;
		add_child(street_node)
		move_child(street_node, 2)

func _on_TrashTimer_timeout():
	if rng.randi_range(0, 10) >4:
		var trash_node = trash_scene.instance()
		add_child(trash_node)
		move_child(trash_node, 100)
		trash_node.position.y = screen_size.y / 2 + 20
		trash_node.position.x = screen_size.x + 50	