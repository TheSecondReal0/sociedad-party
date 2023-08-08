extends Container

var h_separation: int = 5
var v_separation: int = 5

var col_height: int = 20

var my_rect = Rect2(Vector2(), rect_size)
var current_vec = Vector2()

func _notification(what):
	if (what==NOTIFICATION_SORT_CHILDREN):
		sort()

func sort():
	my_rect = Rect2(Vector2(), rect_size)
	current_vec = Vector2()
	for child in get_children():
		var c_rect: Rect2 = Rect2(Vector2(), child.rect_size)
		current_vec = get_new_vec(c_rect)
		var new_rect = get_new_rect(c_rect)
#		print(new_rect)
		fit_child_in_rect(child, new_rect)
		current_vec += Vector2(new_rect.size.x + h_separation, 0)
		rect_size.y = child.rect_position.y + child.rect_size.y

func get_new_rect(rect: Rect2) -> Rect2:
	if rect.size.y > col_height:
# warning-ignore:narrowing_conversion
		col_height = rect.size.y
	var new_rect: Rect2 = Rect2()
	var new_vec = current_vec
	new_rect.position = new_vec
	new_rect.size = Vector2(rect.size.x, col_height)
	return new_rect

func get_new_vec(rect: Rect2) -> Vector2:
	var new_vec: Vector2 = Vector2()
	if fits_x(rect):
		return current_vec# + Vector2(h_separation, 0)
	new_vec = Vector2(0, current_vec.y + col_height + v_separation)
	return new_vec

func fits_x(rect: Rect2) -> bool:
	if my_rect.size.x - current_vec.x > rect.size.x:
		return true
	return false
