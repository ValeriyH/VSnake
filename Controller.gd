extends Node2D

signal swipe
var swipe_start = null
var minimum_drag = 20

func _unhandled_input(event):
	if event is InputEventScreenTouch: # or event is InputEventMouseButton:
		if event.pressed:
			$Debug.text = "Pressed " + str(event.position)
			swipe_start = event.position
		else:
			$Debug.text = "Released " + str(event.position)
			_calculate_swipe(event.position)

		
func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	print(swipe)
	# Minimium swipe check
	if abs(swipe.x) + abs(swipe.y) > minimum_drag:
		# Horizontal or vertical?
		if abs(swipe.x) > abs(swipe.y):
			if swipe.x > 0:
				emit_signal("swipe", "right")
				$Debug.text += "\nright"
			else:
				emit_signal("swipe", "left")
				$Debug.text += "\nleft"
		else:
			if swipe.y > 0:
				emit_signal("swipe", "down")
				$Debug.text += "\ndown"
			else:
				emit_signal("swipe", "up")
				$Debug.text += "\nup"

