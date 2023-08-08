extends PopupMenu

var current_tile: Node2D

var global_pos: Vector2

var mouse_distance_max: float = 100

# order name: order resource
var order_names: Dictionary

#signal interaction_selected(interaction, tile)
signal new_order(order)

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	connect("id_pressed", self, "interaction_selected")

func _process(_delta):
	if not visible:
		return
	mouse_distance_max = rect_size.length()
	if get_mouse_pos().distance_to(rect_position + (rect_size / 2)) > mouse_distance_max:
		close()

func interaction_selected(id: int):
	var order_name: String = get_item_text(id)
	var order: PawnOrder = order_names[order_name].gen_order(global_pos, current_tile)
	print("tile order selected: ", order)
	emit_signal("new_order", order)
	close()

func new_interactables(interactables: Dictionary):
	var tile: Node2D = interactables["tiles"][0]
	var orders: Array = tile.get_orders()
	var pos: Vector2 = interactables["input_event"].global_position
	show_interactions(orders, pos, tile)

func show_interactions(orders: Array, pos: Vector2, tile: Node2D):
	orders = orders.duplicate(true)
	for order in orders:
		print(order.order_name, ", ", order.available_for_this_client(tile.player_id))
		if not order.available_for_this_client(tile.player_id):
			orders.erase(order)
	print("showing interactions: ", orders)
	current_tile = tile
	global_pos = get_parent().get_parent().get_global_mouse_position()
	clear()
	rect_size = Vector2(0, 0)
	order_names.clear()
	for order in orders:
		order_names[order.order_name] = order
	rect_position = pos
	gen_buttons(orders)
	show()
	grab_focus()

func gen_buttons(orders: Array):
	for order in orders:
		add_item(order.order_name)

func close():
	clear()
	hide()

func get_mouse_pos() -> Vector2:
	return get_viewport().get_mouse_position()
