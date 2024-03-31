class_name UDIMTextureMapper
extends Button

@export var tileset: UDIMTextureTileset = null

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Import UDIM Texture Set"
	pressed.connect(open_select_dialog)
	

func open_select_dialog():
	var dialog = EditorFileDialog.new()
	dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	dialog.size = Vector2(800, 600)
	dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	dialog.file_selected.connect(udim_dir_selected)
	add_child(dialog)
	dialog.show()

func udim_dir_selected(file_path: String):
	var path_split = file_path.split(("/"))
	if len(path_split) < 3 or path_split[0] != "res:":
		push_error("Invalid UDIM import path")
		return
	var dirr = "/".join(path_split.slice(0,len(path_split)-1))
	var regex = RegEx.new()
	regex.compile('(.*)(\\d{4})(\\.\\w+)')
	var reg_matches = regex.search_all(path_split[len(path_split)-1])
	if len(reg_matches) != 1 or len(reg_matches[0].strings) != 4:
		push_error("Invalid UDIM import path: " + file_path)
		return
	var filename = reg_matches[0].strings[1]
	var filetype = reg_matches[0].strings[3]
	var dir = DirAccess.open(dirr)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(filetype):
				var sregex = RegEx.new()
				sregex.compile(filename+'(\\d{4})'+filetype)
				if sregex.search(file_name):
					var texture = load(dirr + "/" + file_name)
					var udim_id = regex.search_all(file_name)[0].strings[2]
					tileset.set("tile_" + udim_id,texture)
			file_name = dir.get_next()
	else:
		push_error("An error occurred when trying to access the UDIM path: " + file_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
