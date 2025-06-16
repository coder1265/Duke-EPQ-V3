extends Control

var main = preload("res://Scripts/main_game.gd")
@onready var turn = Globals.winning_turn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if turn == "White":
		$RichTextLabel.text = "Blue Wins"
	elif turn == "Black":
		$RichTextLabel.text = "Red Wins"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse = get_global_mouse_position()
	$particles_left.global_position = mouse
	if Input.is_action_just_pressed("left_mouse_click"):
		$particles_left.emitting = true
		#$particles_right.emitting= true


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Play_screen.tscn")
