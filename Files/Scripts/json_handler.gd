extends RefCounted
class_name JSONHandler

const STYLE_KEY = &"Style"
const DIALOGUES_KEY = &"Dialogues"


## Returns a DataStore instance if given path is found
## If an error occurs, return an empty DataStore with an error attached
static func get_data_store(json_file_path: String) -> DataStore:
	var text_data = FileAccess.get_file_as_string(json_file_path)
	var hash_sha256 := text_data.sha256_text()
	if FileAccess.get_open_error() != OK:
		return DataStore.create_with_given_error(FileAccess.get_open_error())
	var json_data: Dictionary = JSON.parse_string(text_data)
	if json_data == null:
		return DataStore.create_with_given_error(Error.ERR_FILE_CORRUPT)
	if not json_data.has_all([STYLE_KEY, DIALOGUES_KEY]):
		return DataStore.create_with_given_error(Error.ERR_FILE_CORRUPT)

	var style: StringName = json_data[STYLE_KEY]
	var entries: Array[DialogueEntry] = []
	for id in json_data[DIALOGUES_KEY]:
		var dialogues: Array[Dialogue] = []
		for dialogue: Dictionary in json_data[DIALOGUES_KEY][id]:
			dialogues.append(
				Dialogue.new(
					dialogue[&"Key"],
					dialogue[&"Content"],
					dialogue[&"OriginalContent"],
					dialogue.get(&"LastEdited", ""),
				)
			)
		entries.append(DialogueEntry.new(id, dialogues))
	return DataStore.new(style, entries, json_file_path, hash_sha256)


## Save data_store information in the path from data_store.path
## If save_as_path is given, it will use that path to save.
static func save_data_store(data_store: DataStore, save_as_path: StringName = &"") -> Error:
	var save_path = save_as_path if not save_as_path.is_empty() else data_store.path
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var open_error = FileAccess.get_open_error()
	if open_error:
		return open_error
	var stringified_data_store: String = JSONHandler.stringify_data_store(data_store)
	data_store.save_new_hash(stringified_data_store.sha256_text())
	file.store_string(stringified_data_store)
	return OK


static func stringify_data_store(data_store: DataStore) -> String:
	var serialized_dict := { STYLE_KEY: data_store.style, DIALOGUES_KEY: { } }
	for entry in data_store.dialogues_entries:
		serialized_dict[DIALOGUES_KEY][entry.id] = []
		for dialogue in entry.dialogues:
			serialized_dict[DIALOGUES_KEY][entry.id].append(
				{
					&"Key": dialogue.key,
					&"Content": dialogue.content,
					&"OriginalContent": dialogue.original_content,
					&"LastEdited": dialogue.last_edited_by,
				}
			)
	return JSON.stringify(serialized_dict)


static func export_to_game_format(data_store: DataStore, save_path: StringName) -> Error:
	var serialized_dict := { }
	for entry in data_store.dialogues_entries:
		for dialogue in entry.dialogues:
			serialized_dict[dialogue.key] = dialogue.content if not dialogue.content.is_empty() else dialogue.original_content

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var open_error = FileAccess.get_open_error()
	if open_error:
		return open_error
	file.store_string(JSON.stringify(serialized_dict))
	return OK
