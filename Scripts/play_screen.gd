extends Control
@onready var how_to_play_menu: MarginContainer = $How_to_play_menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	how_to_play_menu.show()
	pass # Replace with function body.
	#create_credits_screen


func _on_close_help_pressed() -> void:
	how_to_play_menu.hide()


func _on_rules_pressed() -> void:
	$How_to_play_menu/HBoxContainer/NinePatchRect/Duke_ruleset.show()
	$How_to_play_menu/HBoxContainer/NinePatchRect/sprites.hide()
	$How_to_play_menu/HBoxContainer/NinePatchRect/credits.hide()

func _on_sprites_pressed() -> void:
	$How_to_play_menu/HBoxContainer/NinePatchRect/Duke_ruleset.hide()
	$How_to_play_menu/HBoxContainer/NinePatchRect/sprites.show()
	$How_to_play_menu/HBoxContainer/NinePatchRect/credits.hide()


func _on_list_credits_pressed() -> void:
	$How_to_play_menu/HBoxContainer/NinePatchRect/Duke_ruleset.hide()
	$How_to_play_menu/HBoxContainer/NinePatchRect/sprites.hide()
	$How_to_play_menu/HBoxContainer/NinePatchRect/credits.show()
