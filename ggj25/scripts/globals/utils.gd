class_name Utils


static func create_array(size: int, fill = null) -> Array:
	var result = []
	result.resize(size)
	result.fill(fill)
	return result
