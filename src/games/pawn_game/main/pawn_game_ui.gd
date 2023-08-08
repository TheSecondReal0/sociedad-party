extends CanvasLayer

export var main_path: NodePath
export var map_editor_path: NodePath
export var blueprint_ui_path: NodePath
export var shop_ui_path: NodePath
export var menu_buttons_path: NodePath
export var resources_ui_path: NodePath
export var interact_popup_path: NodePath
export var map_editor_only: bool = false

onready var main: Node2D = get_node(main_path)
onready var map_editor: Control = get_node(map_editor_path)
onready var blueprint_ui: Control = get_node(blueprint_ui_path)
onready var shop_ui: Control = get_node(shop_ui_path)
onready var menu_buttons: Control = get_node(menu_buttons_path)
onready var resources_ui: VBoxContainer = get_node(resources_ui_path)
onready var interact_popup: PopupMenu = get_node(interact_popup_path)

var menus: Array = ["map_editor", "blueprint_ui", "shop_ui"]
var open_menu: String = ""

signal pawn_purchased
signal interaction_selected(interaction, tile)
signal new_order(order)
signal resource_updated(resource, value)

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	main.connect("new_interactables", self, "new_interactables")
# warning-ignore:return_value_discarded
	main.connect("tile_created", self, "tile_created")
# warning-ignore:return_value_discarded
	main.connect("my_castle_created", self, "my_castle_created")
# warning-ignore:return_value_discarded
	shop_ui.connect("pawn_purchased", self, "pawn_purchased")
# warning-ignore:return_value_discarded
	#interact_popup.connect("interaction_selected", self, "interaction_selected")
# warning-ignore:return_value_discarded
	interact_popup.connect("new_order", self, "new_order")
# warning-ignore:return_value_discarded
	main.connect("resource_updated", self, "resource_updated")
	menu_buttons.connect("ui_toggled", self, "ui_toggled")
	if map_editor_only:
		for child in get_children():
			if not child == map_editor:
				child.hide()

func ui_toggled(ui_name: String):
	#print("ui_toggled: ", ui_name, " current ui: ", open_menu)
	if not ui_name in menus:
		return
	if open_menu != "":
		get_node(open_menu).close()
		get_node(open_menu).hide()
	if ui_name != open_menu:
		get_node(ui_name).open()
		open_menu = ui_name
	else:
		open_menu = ""

#func tile_interacted_with(tile: Node2D, input: InputEventMouseButton):
#	return
## warning-ignore:unreachable_code
#	print(tile, " interacted with")
#	#print(tile.orders)
#	# uncomment for crash, used for testing
#	#print(get_node_or_null("sdgf").x)
#	interact_popup.show_interactions(tile.orders, input.position, tile)

func new_interactables(interactables: Dictionary):
	interact_popup.new_interactables(interactables)

func tile_created(tile):
	#print("tile created, ", tile)
	tile.connect("interacted_with", self, "tile_interacted_with")

func pawn_purchased():
	emit_signal("pawn_purchased")

func interaction_selected(interaction, tile):
	emit_signal("interaction_selected", interaction, tile)

func new_order(order: PawnOrder):
	emit_signal("new_order", order)

func resource_updated(resource, value):
	emit_signal("resource_updated", resource, value)

func my_castle_created():
	pass
#	if is_release_mode_enabled():
#		map_editor.close_editor()

func is_release_mode_enabled():
	return main.is_release_mode_enabled()
