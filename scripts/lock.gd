class_name Lock
## Basically a bool that multiple things contribute to. Multiple things can hold
## the bool's "attention" by locking their own tags. E.g. you can impede player
## input by locking "ui" during textboxes and "cutscene" during cutscenes.


var _tags: Array


func lock(tag: String) -> void:
	if not tag in _tags:
		_tags.append(tag)


func unlock(tag: String) -> void:
	_tags.erase(tag)


func clear() -> void:
	_tags.clear()


func is_locked() -> bool:
	return _tags.size() > 0