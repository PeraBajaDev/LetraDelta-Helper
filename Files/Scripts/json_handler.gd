extends RefCounted
class_name JSONHandler


## Returns a DataFile instance if given path is found, else returns null
static func get_data_file(json_file_path: String) -> DataFile:
	var text_data = FileAccess.get_file_as_string(json_file_path)
	var json_data: Dictionary = JSON.parse_string(text_data)
	if json_data == null or text_data.is_empty():
		return null
	var style: StringName = json_data[&"Style"]
	var entries: Array[DialogueEntry] = []
	for id in json_data[&"Dialogues"]:
		var dialogues: Array[Dialogue] = []
		for dialogue in json_data[&"Dialogues"][id]:
			dialogues.append(
				Dialogue.new(
					dialogue[&"Key"],
					dialogue[&"Content"],
					dialogue[&"OriginalContent"],
					dialogue[&"LastEdited"],
				)
			)
		entries.append(DialogueEntry.new(id, dialogues))
	return DataFile.new(style, entries)
