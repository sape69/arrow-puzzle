extends Node2D

# ============================================================
# ARROW PUZZLE
# First playable prototype
# ============================================================

const BOARD_SIZE := 7

# Board is 652 x 652 in main.tscn.
const BOARD_PIXEL_SIZE := 652.0
const TILE_SIZE := BOARD_PIXEL_SIZE / BOARD_SIZE

const TILE_MARGIN := 4.0

const TILE_COLOR := Color("#F8F1DF")
const ARROW_COLOR := Color("#5A4638")
const ARROW_BLOCKED_COLOR := Color("#D85C70")

const STELLA_PURPLE := Color("#B58CFF")
const STELLA_PINK := Color("#FFB7E8")
const STAR_GOLD := Color("#FFD166")
const TEXT_COLOR := Color("#F8F4FF")

var board: Array = []
var arrow_buttons: Dictionary = {}

var moves := 0
var level_completed := false

var board_node: ColorRect
var moves_label: Label
var status_label: Label
var level_label: Label


func _ready() -> void:
	board_node = get_node_or_null("Board")
	moves_label = get_node_or_null("MovesLabel")
	status_label = get_node_or_null("StatusLabel")
	level_label = get_node_or_null("LevelLabel")

	if board_node == null:
		push_error("Board node not found.")
		return

	_create_level()


# ============================================================
# LEVEL
# ============================================================

func _create_level() -> void:
	level_completed = false
	moves = 0

	_clear_board()

	board = _create_level_data()

	_create_arrow_buttons()

	_update_labels()


func _create_level_data() -> Array:
	var new_board: Array = []

	for y in range(BOARD_SIZE):
		var row: Array = []

		for x in range(BOARD_SIZE):
			row.append(null)

		new_board.append(row)

	# direction:
	# 0 = UP
	# 1 = RIGHT
	# 2 = DOWN
	# 3 = LEFT
	#
	# This is the first hand-made test level.

	var arrows := [
		[1, 1, 0],
		[2, 1, 0],
		[3, 1, 0],
		[4, 1, 0],

		[1, 2, 3],
		[3, 2, 0],
		[5, 2, 1],

		[1, 3, 3],
		[2, 3, 2],
		[3, 3, 1],
		[4, 3, 2],
		[5, 3, 1],

		[2, 4, 3],
		[3, 4, 2],
		[4, 4, 1],

		[1, 5, 3],
		[2, 5, 2],
		[3, 5, 2],
		[4, 5, 2],
		[5, 5, 1]
	]

	for arrow in arrows:
		var x: int = arrow[0]
		var y: int = arrow[1]
		var direction: int = arrow[2]

		new_board[y][x] = {
			"direction": direction
		}

	return new_board


# ============================================================
# CREATE ARROWS
# ============================================================

func _create_arrow_buttons() -> void:
	arrow_buttons.clear()

	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):

			if board[y][x] == null:
				continue

			var button := Button.new()

			button.name = "Arrow_%d_%d" % [x, y]

			var tile_position := Vector2(
				x * TILE_SIZE + TILE_MARGIN,
				y * TILE_SIZE + TILE_MARGIN
			)

			var tile_size := Vector2(
				TILE_SIZE - TILE_MARGIN * 2.0,
				TILE_SIZE - TILE_MARGIN * 2.0
			)

			button.position = tile_position
			button.size = tile_size

			var direction: int = board[y][x]["direction"]

			button.text = _direction_to_arrow(direction)

			button.add_theme_font_size_override(
				"font_size",
				38
			)

			button.add_theme_color_override(
				"font_color",
				ARROW_COLOR
			)

			button.add_theme_color_override(
				"font_hover_color",
				STELLA_PURPLE
			)

			button.add_theme_color_override(
				"font_pressed_color",
				STELLA_PINK
			)

			button.add_theme_color_override(
				"font_focus_color",
				ARROW_COLOR
			)

			button.focus_mode = Control.FOCUS_NONE

			# ----------------------------------------------------
			# Normal tile
			# ----------------------------------------------------

			var normal_style := StyleBoxFlat.new()

			normal_style.bg_color = TILE_COLOR

			normal_style.corner_radius_top_left = 12
			normal_style.corner_radius_top_right = 12
			normal_style.corner_radius_bottom_left = 12
			normal_style.corner_radius_bottom_right = 12

			button.add_theme_stylebox_override(
				"normal",
				normal_style
			)

			# ----------------------------------------------------
			# Hover
			# ----------------------------------------------------

			var hover_style := normal_style.duplicate()

			hover_style.bg_color = Color("#FFF8E8")

			button.add_theme_stylebox_override(
				"hover",
				hover_style
			)

			# ----------------------------------------------------
			# Pressed
			# ----------------------------------------------------

			var pressed_style := normal_style.duplicate()

			pressed_style.bg_color = Color("#EADCFB")

			button.add_theme_stylebox_override(
				"pressed",
				pressed_style
			)

			# ----------------------------------------------------
			# Connect
			# ----------------------------------------------------

			button.pressed.connect(
				_on_arrow_pressed.bind(x, y)
			)

			board_node.add_child(button)

			arrow_buttons[Vector2i(x, y)] = button


# ============================================================
# ARROW PRESS
# ============================================================

func _on_arrow_pressed(x: int, y: int) -> void:
	if level_completed:
		return

	if y < 0 or y >= BOARD_SIZE:
		return

	if x < 0 or x >= BOARD_SIZE:
		return

	if board[y][x] == null:
		return

	var direction: int = board[y][x]["direction"]

	if not _can_arrow_escape(x, y, direction):
		_show_blocked_feedback(x, y)
		return

	_remove_arrow(x, y)


# ============================================================
# CHECK IF ARROW CAN LEAVE
# ============================================================

func _can_arrow_escape(
	x: int,
	y: int,
	direction: int
) -> bool:

	var movement := _direction_vector(direction)

	var check_x := x + int(movement.x)
	var check_y := y + int(movement.y)

	while (
		check_x >= 0
		and check_x < BOARD_SIZE
		and check_y >= 0
		and check_y < BOARD_SIZE
	):
		if board[check_y][check_x] != null:
			return false

		check_x += int(movement.x)
		check_y += int(movement.y)

	return true


# ============================================================
# REMOVE ARROW
# ============================================================

func _remove_arrow(x: int, y: int) -> void:
	var key := Vector2i(x, y)

	if not arrow_buttons.has(key):
		return

	var button: Button = arrow_buttons[key]

	if not is_instance_valid(button):
		arrow_buttons.erase(key)
		return

	var direction: int = board[y][x]["direction"]

	var movement := _direction_vector(direction)

	moves += 1

	# Remove from logical board immediately.
	board[y][x] = null

	# Remove from dictionary immediately.
	arrow_buttons.erase(key)

	status_label.text = "NUOLI PÄÄSEE ULOS!"

	moves_label.text = "LIIKKEET: %d" % moves

	# ----------------------------------------------------------
	# Animate arrow outside the board.
	# ----------------------------------------------------------

	var target_position := button.position + movement * 1800.0

	var tween := create_tween()

	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(
		button,
		"position",
		target_position,
		0.35
	)

	tween.tween_callback(
		func() -> void:
			if is_instance_valid(button):
				button.queue_free()

			_check_level_complete()
		)


# ============================================================
# DIRECTION
# ============================================================

func _direction_vector(direction: int) -> Vector2:
	match direction:
		0:
			return Vector2.UP

		1:
			return Vector2.RIGHT

		2:
			return Vector2.DOWN

		3:
			return Vector2.LEFT

	return Vector2.ZERO


func _direction_to_arrow(direction: int) -> String:
	match direction:
		0:
			return "↑"

		1:
			return "→"

		2:
			return "↓"

		3:
			return "←"

	return "?"


# ============================================================
# BLOCKED FEEDBACK
# ============================================================

func _show_blocked_feedback(x: int, y: int) -> void:
	var key := Vector2i(x, y)

	if not arrow_buttons.has(key):
		return

	var button: Button = arrow_buttons[key]

	if not is_instance_valid(button):
		return

	var original_color := button.get_theme_color(
		"font_color"
	)

	button.add_theme_color_override(
		"font_color",
		ARROW_BLOCKED_COLOR
	)

	status_label.text = "NUOLI ON ESTETTY!"

	# Small shake animation.

	var original_position := button.position

	var tween := create_tween()

	tween.tween_property(
		button,
		"position",
		original_position + Vector2(8.0, 0.0),
		0.05
	)

	tween.tween_property(
		button,
		"position",
		original_position + Vector2(-8.0, 0.0),
		0.05
	)

	tween.tween_property(
		button,
		"position",
		original_position + Vector2(5.0, 0.0),
		0.05
	)

	tween.tween_property(
		button,
		"position",
		original_position,
		0.05
	)

	tween.tween_callback(
		func() -> void:
			if is_instance_valid(button):
				button.add_theme_color_override(
					"font_color",
					original_color
				)
	)


# ============================================================
# LEVEL COMPLETE
# ============================================================

func _check_level_complete() -> void:
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):

			if board[y][x] != null:
				return

	level_completed = true

	status_label.text = "🎉 TASO SUORITETTU!"

	moves_label.text = "LIIKKEET: %d" % moves


# ============================================================
# CLEAR BOARD
# ============================================================

func _clear_board() -> void:
	arrow_buttons.clear()

	if board_node == null:
		return

	var children := board_node.get_children()

	for child in children:
		if is_instance_valid(child):
			child.free()


# ============================================================
# LABELS
# ============================================================

func _update_labels() -> void:
	if level_label != null:
		level_label.text = "TASO 1"

	if moves_label != null:
		moves_label.text = "LIIKKEET: %d" % moves

	if status_label != null:
		status_label.text = "POISTA KAIKKI NUOLET"


# ============================================================
# NEW LEVEL
# ============================================================

func _start_new_level() -> void:
	_create_level()