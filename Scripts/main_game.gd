extends Node2D


var is_white_turn: bool = true
var is_white_summon = false
var is_black_summon = false
var selected_piece
var mouse_position
@onready var global_tilemaplayer_ref = $board_layer
var main_layer_id
var min_left:int = -1
var min_right:int = 6
var min_top:int = -1
var min_bottom:int = 6
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.playing = true
func end_turn():
	if is_white_turn:
		is_white_turn = false
	else:
		is_white_turn = true

func called_summon():
	if is_white_turn:
		is_white_summon = true
		$"Piece Holder".summoned_white()
	else:
		is_black_summon = true
		$"Piece Holder".summoned_black()
