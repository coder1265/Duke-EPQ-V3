extends Button

@onready var is_white_turn
@onready var Piece_holder_reference
@onready var white_duke_summonable_pieces
@onready var black_duke_sumonable_pieces


func _ready() -> void:
	Piece_holder_reference = $"/root/Main/Piece_Holder"
	if Piece_holder_reference == null:
		print("piece holder is null")
	#white_duke_summonable_pieces = Piece_holder_reference.white_duke.summonable_pieces
	#if white_duke_summonable_pieces != null:
		#print("found white duke pieces")
		#print(white_duke_summonable_pieces)
		#


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_white_turn = $".".is_white_turn
	if is_white_turn:
		pass
	if not is_white_turn:
		pass
