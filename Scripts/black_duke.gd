extends Area2D

var mouse_entered_black_duke: bool = false
@onready var duke_pos = $"..".black_duke_start_pos
@onready var local_white_turn = get_node("/root/Main").is_white_turn
@onready var local_black_summon = get_node("/root/Main").is_white_summon
@onready var board = $"/root/Main/board_layer"
var movement_pos = preload("res://Scenes/move_holder.tscn")
var summon_holder = preload("res://Scenes/summon_holder.tscn")
var summonable_pieces = ["footman","pikeman","pikeman","pikeman","champion","seer","wizard","assassin","priest"]
var possible_moves = []
var possible_moves_on_board = []
var placeable_locations = []
var unplaceable_locations = []
var checked_move_holders = []
var map_not_valid_locations = [] # locations local to the tilemap of all the black pieces
var new_positions = [] # positions to move to for summoning
var is_front: bool = true
var is_holder_clicked:bool = false
var cell_size:int = 16
@onready var min_left = get_node("/root/Main").min_left
@onready var min_right = get_node("/root/Main").min_right
@onready var min_top = get_node("/root/Main").min_top
@onready var min_bottom = get_node("/root/Main").min_bottom

var move_coordinates
var holder
var show_moves
var show_summon_locations
var summoned_piece
var current_tile_pos

#region code to detect if the mouse over
func _on_mouse_entered():
	mouse_entered_black_duke = true
func _on_mouse_exited():
	mouse_entered_black_duke = false
#endregion

func _input(event):
	if Input.is_action_just_pressed("left_mouse_click"):
		local_white_turn = get_node("/root/Main").is_white_turn
		if show_summon_locations: # code to implement instantiation of pieces after showing summon locations
			clicked_summon()
		if mouse_entered_black_duke == true: # if statement to show movement positions
			if local_white_turn == false:
				do_moves(event)
		if show_moves && local_white_turn == false:
			var x2 = checked_move_holders.map(func(element): return element + duke_pos)
			if x2.has(Vector2i(get_global_mouse_position()/cell_size)):
				print("new position is: ",Vector2i(get_global_mouse_position()/cell_size))
				self.position = (Vector2i(get_global_mouse_position()/cell_size)*cell_size)+Vector2i(8,8)
				if is_front:
					is_front = false
				else:
					is_front = true
				call_deferred("change_turn")
		if mouse_entered_black_duke == false: # deletes children if clicked of the duke positions
			delete_children()
			show_summon_locations = false

#region controls code for summoning
func get_summon_data():
	if summonable_pieces.size() > 0:
		local_pos_to_map()
		if duke_pos != null:
			var x9 = $"/root/Main/board_layer".get_surrounding_cells(duke_pos)
			placeable_locations.clear()
			for i in x9:
				if i.x > min_left && i.x < min_right && i.y > min_top && i.y < min_bottom:
					placeable_locations.append(i)
			#print("This is placeable locations ",placeable_locations)
			new_positions = updates_moves_to_not_include_black_pieces(placeable_locations)
			print("Summonable positions local to the map ", new_positions)
			var check3 = []
			for i in unplaceable_locations:
				var local_to_the_black_duke = i + duke_pos
				check3.append(local_to_the_black_duke)
			for i in check3:
				if check3.has(i):
					new_positions.erase(i)
			#print("This is new new placeable locations", placeable_locations)
			#print("This is new positions ",new_positions)
			for i in range(new_positions.size()):
				var summon_place = summon_holder.instantiate()
				add_child(summon_place)
				#summon_place.position = $"/root/Main/board_layer".map_to_local(Vector2i(placeable_locations[i]))
				summon_place.global_position = Vector2i(new_positions[i]*cell_size) + Vector2i(8,8)
			show_summon_locations = true
	else:
		print("Can't summon")
		# implement function to state on information board that you can't summon

func clicked_summon():
	current_tile_pos = Vector2i(get_global_mouse_position()/cell_size)
	if new_positions.has(current_tile_pos):
		$"..".instantiate_location = current_tile_pos
		show_summon_locations = false
		if summonable_pieces.size() > 0:
			summoned_piece = summonable_pieces.pick_random()
			$"..".summoned_a_piece(summoned_piece)
			var check_var = $"..".summon_move_checker
			if check_var:
				summonable_pieces.erase(summoned_piece)
				get_node("/root/Main").is_black_summon = false
				if is_front:
					is_front = false
				else:
					is_front = true
#endregion
#region this region is for movement and capturing of the duke
func do_moves(_event):
	possible_moves.clear() # clears any possible moves
	if is_front == true:
		for i in range(0,11): # range is 10, i is intiger from 0-10
			var x_coord = i-5
			possible_moves.push_back(Vector2i(x_coord,0))
	else:
		for i in range(0,11):
			var y_coord = i-5
			possible_moves.push_back(Vector2i(0,y_coord))
	#print("Possible moves ", possible_moves)
	local_pos_to_map()
	possible_moves_on_board.clear()
	for iterable in possible_moves:
		var umm = iterable + duke_pos
		if umm.x > -1 and umm.x < 6 and umm.y > -1 and umm.y < 6:
			possible_moves_on_board.push_back(iterable) 
	possible_moves_on_board.remove_at(possible_moves_on_board.find(Vector2i(0,0)))
	print("Possible moves are: ",possible_moves_on_board)
	checked_move_holders = updates_moves_to_not_include_black_pieces(possible_moves_on_board)
	print("This is active move holders", checked_move_holders)
	for i in range(checked_move_holders.size()):
		holder = movement_pos.instantiate()
		holder.global_position = Vector2i(checked_move_holders[i]*cell_size)
		add_child(holder)
	show_moves = true
#endregion
func local_pos_to_map():
	var black_duke_position = self.position
	duke_pos = board.local_to_map(black_duke_position)
func _on_area_entered(area: Area2D):
	if not local_white_turn:
		if area.is_in_group("white_pieces"):
			area.queue_free()
func updates_moves_to_not_include_black_pieces(incoming_array_to_check):
	var valid_moves = []
	var active_pieces = get_tree().get_nodes_in_group("black_pieces") # gets all black piece objects including positions
	unplaceable_locations.clear()
	map_not_valid_locations.clear()
	for piece in active_pieces: # piece is each object in the group black_pieces, so all the black pieces ¬_¬
		if piece is Area2D:
			var world_pos = piece.global_position # returns in pixels 
			var black_piece_local_to_tilemap = board.local_to_map(world_pos) # converts to local to the tilemap
			map_not_valid_locations.append(black_piece_local_to_tilemap)
			var black_piece_local_to_duke = black_piece_local_to_tilemap - duke_pos # converts the tilemap locations to local to the duke by minusing the duke position of all the places, so effectively moves 0,0 to the dukes position
			unplaceable_locations.append(black_piece_local_to_duke)
	print("This is unplaceable locations, ",unplaceable_locations)
	for move in incoming_array_to_check: # this code checks the incoming array and compares it to the locations of the black pieces, if there is a white piece there it does not add it to the array
		if not unplaceable_locations.has(move):
			valid_moves.append(move)
	return valid_moves # returns the incoming array less the positions of other black piece (if there is any)
func delete_children():
	for child in range($".".get_children().size()):
		if is_instance_of($".".get_children()[child],Area2D):
			$".".get_child(child).queue_free()
	show_moves = false

func change_turn():
	get_node("/root/Main").is_white_turn = true
