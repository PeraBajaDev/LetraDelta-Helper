class_name DialogueInfoWindow
extends AcceptDialog


func _show_dialogue_info(dialogue: Dialogue):
	if dialogue == null:
		return
	show()
	var last_edited_info: PackedStringArray = dialogue.last_edited_by.split(";")
	var author: String = last_edited_info[0]
	var timestamp := int(last_edited_info[1]) if last_edited_info.size() == 2 else -1
	var date := Time.get_date_string_from_unix_time(timestamp) if timestamp != -1 else ""
	var info: Label = $Label
	info.text = "KEY: {key}\n\nLAST_EDIT_DETAILS:
	>    AUTHOR: {author}
	>    LAST_EDITION: {last_edition}".format(
		{
			"key": dialogue.key,
			"author": author,
			"last_edition": date,
		}
	)
