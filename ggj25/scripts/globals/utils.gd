class_name Utils


static func create_array(size: int, fill = null) -> Array:
	var result = []
	result.resize(size)
	result.fill(fill)
	return result


static func create_array_of_arrays(size: int) -> Array[Array]:
	var result: Array[Array] = []
	for i in range(size):
		result.append([])
	return result
