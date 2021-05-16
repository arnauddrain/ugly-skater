extends Control

signal start_game

func _ready():
	get_tree().paused = true

func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)

func game_over():
	$StartButton.show()
	$StartButton/PlayLabel.text = "Restart"
	get_tree().paused = true

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
	get_tree().paused = false
