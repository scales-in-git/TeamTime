extends Node

# Set this when loading a file.
var current_save_name: String
var current_save_data: SaveData

signal saved
signal loaded


func _unhandled_input(event):
	pass
	#if event.is_action_pressed('debug_save_1'):
		#current_save_name = "debug_save_1"
		#save()
	#if event.is_action_pressed('debug_save_2'):
		#current_save_name = "debug_save_2"
		#save()
	#if event.is_action_pressed('debug_save_3'):
		#current_save_name = "debug_save_3"
		#save()
#
	#if event.is_action_pressed('debug_load_1'):
		#current_save_name = 'debug_save_1'
		#load_save()
	#if event.is_action_pressed('debug_load_2'):
		#current_save_name = 'debug_save_2'
		#load_save()
	#if event.is_action_pressed('debug_load_3'):
		#current_save_name = 'debug_save_3'
		#load_save()
	#
	#if event.is_action_pressed('debug_print_current_save_data'):
		#print_current_save_data()

func print_current_save_data():
	print(current_save_data)
	
	if current_save_data:
		print("Save Name: %s" % current_save_data.name)
		print("Play Time: %s seconds" % current_save_data.play_time)
		print("Last Save: %f (%s) " % [current_save_data.last_save, Time.get_datetime_string_from_unix_time(current_save_data.last_save as int)])
		print("Last Load: %f (%s) " % [current_save_data.last_save, Time.get_datetime_string_from_unix_time(current_save_data.last_save as int)])
		print("Game Started: %f (%s) " % [current_save_data.game_started, Time.get_datetime_string_from_unix_time(current_save_data.game_started as int)])
		print("Collectibles: ")
		print(current_save_data.collectibles)
		

# For first-time initialization
func build_save_data():
	if current_save_data or not current_save_name:
		return
	
	current_save_data = SaveData.new()
	current_save_data.name = current_save_name
	current_save_data.play_time = 0
	current_save_data.collectibles = CollectiblesManager._collected_items

	var now := Time.get_unix_time_from_system()
	current_save_data.last_save = now
	current_save_data.last_load = now
	current_save_data.game_started = now
	


func save():
	if not current_save_name:
		print("No save set, nothing saved")
		return

	if not current_save_data:
		build_save_data()

	# Todo: this whole process needs to be threaded
	var now := Time.get_unix_time_from_system()

	current_save_data.name = current_save_name
	current_save_data.collectibles = CollectiblesManager._collected_items

	var last_interaction = max(current_save_data.last_save, current_save_data.last_load)
	current_save_data.play_time += (now - last_interaction)
	current_save_data.last_save = now

	var file_path := "user://save/%s.tres" % current_save_name

	print("Saving to %s..." % file_path)
	var save_status := ResourceSaver.save(current_save_data, file_path)
	# var save_status = OK

	if save_status == OK:
		print("Save successful")
	else:
		print("Save failed, received error code %d" % save_status)

	saved.emit()

func load_save():
	if not current_save_name:
		print("No save name set, nothing to load.")
		return

	# Todo: tres is for debugging, should just be res when live.
	var file_path := "user://save/%s.tres" % current_save_name
	if not FileAccess.file_exists(file_path):
		print("%s doesn't exist. Stopping." % file_path)
		return

	print("Loading %s..." % file_path)
	var loaded_save_data: SaveData = ResourceLoader.load(file_path, '', ResourceLoader.CACHE_MODE_IGNORE) as SaveData
	# var loaded_save_data: SaveData = load(file_path) as SaveManager.SaveData

	if loaded_save_data:
		print("Loaded.")
		current_save_data = loaded_save_data
		_update_on_load()
		
	else:
		print("Loading failed. Returned: ", loaded_save_data)

func _update_on_load():
	CollectiblesManager._collected_items = current_save_data.collectibles
	current_save_data.last_load = Time.get_unix_time_from_system()
	loaded.emit()

func _enter_tree():
	var user_dir := DirAccess.open("user://")
	if not user_dir.dir_exists('save'):
		var save_dir_make_success := user_dir.make_dir('save')
		if save_dir_make_success == OK:
			print("NOTE: automatically created save directory")
		else:
			assert(false, "Could not create user save directory, returned error code %d." % save_dir_make_success)
