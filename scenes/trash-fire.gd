class_name TrashFire

extends StaticBody2D

func _ready():
	$AnimationPlayer.play("fire")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
