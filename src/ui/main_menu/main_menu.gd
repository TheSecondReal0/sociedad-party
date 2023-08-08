extends Control

var random_name_pool: PackedStringArray = ["Brochacho", "Ghandi", "Khan", 
							"Gilgamesh", "Kuzco", "Confucious", 
							"Mansa Musa", "Elizabeth VII", "Seondeok", 
							"Ramses", "Olga", "Boudica", 
							"Hammurabi", "Caesar", "Pocahontas"]

@onready var name_input: LineEdit = $"VBoxContainer/name"
@onready var ip_input: LineEdit = $"VBoxContainer/ip"
@onready var color_input: ColorPickerButton = $"VBoxContainer/ColorPickerButton"

@onready var color_picker: ColorPicker = $ColorPicker

func _ready():
	name_input.text = random_name_pool[randi() % random_name_pool.size()]
#	#hide dropper in ColorPicker
#	color_picker.get_children()[1].get_children()[1].hide()
#	#give color rect literally any fucking height
#	color_picker.get_children()[1].get_children()[0].rect_min_size.y = 25

func _process(_delta: float) -> void:
	Network.myName = name_input.text
	Network.myColor = color_picker.color

func _on_Button_pressed():
	if name_input.text != "":
		Network.myName = name_input.text
		Network.myColor = color_picker.color
		Network.client(ip_input.text)

func _on_hostButton_pressed():
	if name_input.text != "":
		Network.myName = name_input.text
		Network.myColor = color_picker.color
		Network.host()
		#print("returned from Network.host()")

# warning-ignore:unused_argument
func _on_name_text_changed(new_text):
	Network.myName = new_text

# warning-ignore:unused_argument
func _on_ColorPicker_color_changed(color):
	Network.myColor = color

func _on_ip_text_submitted(new_text: String):
	if new_text.is_empty():
		ip_input.text = "localhost"
	_on_Button_pressed()
