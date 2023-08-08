extends Node

func get_system_time_msecs() -> int:
	return int(Time.get_unix_time_from_system() * 1000)

func load_files_in_dir_with_exts(directory: String, exts: PackedStringArray) -> Array:
	var paths: Array = get_file_paths_in_dir_with_exts(directory, exts)
	var resources: Array = []
	for path in paths:
		var res: Resource = ResourceLoader.load(path)
		resources.append(res)
	return resources

func get_file_paths_in_dir_with_exts(directory: String, exts: PackedStringArray) -> Array:
	var paths: Array = []
	for ext in exts:
		paths += get_file_paths_in_dir(directory, ext)
	return paths

func get_file_paths_in_dir(directory: String, ext: String = "") -> Array:
	var paths: Array = []
	var dir = DirAccess.open(directory)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		#print(file)
		if file == "":
			# completely break out of the loop
			break
		# check if this file was remapped
		if file.ends_with(".remap"):
			# remove .remap
			file = file.trim_suffix(".remap")
		# if file path doesn't have the right extension
		if not is_valid_file_name(file, ext):
			# skip to the next iteration of the loop
			continue
		var path: String = directory
		if not path.ends_with("/"):
			path += "/"
		path += file
		paths.append(path)
	dir.list_dir_end()
	#print(paths)
	return paths

func is_valid_file_name(file_name: String, ext: String = "") -> bool:
	if file_name == "":
		return false
	# if file path doesn't have the right extension
	if ext != "" and not file_name.ends_with(ext) and not file_name.ends_with(ext + ".remap"):
		return false
		# don't include non-files
	if file_name == "." or file_name == "..":
		return false
	# if file is actually a folder
	if file_name.split(".").size() < 2:
		return false
	return true
