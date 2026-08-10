extends Object
class_name RecentFilesHandler

const RECENT_FILES_PATH := &"user://recent_files.dat"


static func add_to_recent_files(recent_file_path):
	var file = FileAccess.open(RECENT_FILES_PATH, FileAccess.READ_WRITE)
	if not FileAccess.file_exists(RECENT_FILES_PATH):
		file = FileAccess.open(RECENT_FILES_PATH, FileAccess.WRITE)
	var stored_file_paths: PackedStringArray = file.get_as_text().split("\n")
	if stored_file_paths.find(recent_file_path) != -1:
		return
	file.seek_end()
	file.store_string(recent_file_path + "\n")


static func erase_recent_files():
	FileAccess.open(RECENT_FILES_PATH, FileAccess.WRITE)
	if not FileAccess.file_exists(RECENT_FILES_PATH):
		return
