class_name Trash

extends StaticBody2D

signal up_score

var deleting = false

func _on_VisibilityNotifier2D_screen_exited():
	if !deleting:
		emit_signal("up_score")
	queue_free()

func remove():
	deleting = true
	queue_free()
