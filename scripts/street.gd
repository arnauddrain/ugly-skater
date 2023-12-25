extends StaticBody2D

var size

signal up_score

func _ready():
	size = $Sprite2D.texture.get_size().x * scale.x

func _on_VisibilityNotifier2D_screen_exited():
	position.x += size * 9
	emit_signal("up_score")
