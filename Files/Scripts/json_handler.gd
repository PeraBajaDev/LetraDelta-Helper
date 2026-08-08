extends RefCounted
class_name JSONHandler


## Returns a DataStore instance if given path is found
## If an error occurs, return an empty DataStore with an error attached
static func get_data_store(json_file_path: String) -> DataStore:
	var text_data = FileAccess.get_file_as_string(json_file_path)
	if FileAccess.get_open_error() != OK:
		return DataStore.create_with_given_error(FileAccess.get_open_error())
	var json_data: Dictionary = JSON.parse_string(text_data)
	if json_data == null:
		return DataStore.create_with_given_error(Error.ERR_FILE_CORRUPT)
	if not json_data.has_all([&"Style", &"Dialogues"]):
		return DataStore.create_with_given_error(Error.ERR_FILE_CORRUPT)

	var style: StringName = json_data[&"Style"]
	var entries: Array[DialogueEntry] = []
	for id in json_data[&"Dialogues"]:
		var dialogues: Array[Dialogue] = []
		for dialogue: Dictionary in json_data[&"Dialogues"][id]:
			dialogues.append(
				Dialogue.new(
					dialogue[&"Key"],
					dialogue[&"Content"],
					dialogue[&"OriginalContent"],
					dialogue.get(&"LastEdited", ""),
				)
			)
		entries.append(DialogueEntry.new(id, dialogues))
	return DataStore.new(style, entries)
