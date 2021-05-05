extends StaticBody2D

var velocity = -200
var size

func _ready():
	size = $Sprite.texture.get_size().x * scale.x

func _process(delta):
	position.x += velocity * delta 
	if (position.x < -size):
		position.x += size * 9
