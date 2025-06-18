extends Control

@onready var anim = $AnimationPlayer

func _on_button_pressed() -> void:
	anim.play("blur")
	self.hide()
