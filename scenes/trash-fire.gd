extends StaticBody2D

var velocity = -200
var size

func _ready():
	$AnimationPlayer.play("fire")
	size = $Sprite.texture.get_size().x * scale.x

func _process(delta):
	position.x += velocity * delta 
	if (position.x < -size):
		queue_free()
