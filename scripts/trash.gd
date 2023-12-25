class_name Trash

extends StaticBody2D

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func remove():
	queue_free()
