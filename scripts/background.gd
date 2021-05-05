extends Sprite

var velocity = -100
var size = 0

func _ready():
	size = texture.get_size().x * scale.x

func _process(delta):
	position.x += velocity * delta 
	if (position.x < -size):
		position.x += 2 * size
