extends Area2D
signal delete

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	delete.emit()
