extends StaticBody2D

var size

func _ready():
	size = $Sprite.texture.get_size().x * scale.x

func _on_VisibilityNotifier2D_screen_exited():
	position.x += size * 9
