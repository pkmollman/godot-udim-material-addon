@tool
extends Resource
class_name UDIMTextureTileset

@export_group("UDIM Textures", "tile_")
@export_subgroup("Row 0")
@export var tile_1001: Texture:
	set(value):
		tile_1001 = value
		changed.emit()
@export var tile_1002: Texture:
	set(value):
		tile_1002 = value
		changed.emit()
@export var tile_1003: Texture:
	set(value):
		tile_1003 = value
		changed.emit()
@export var tile_1004: Texture:
	set(value):
		tile_1004 = value
		changed.emit()
@export var tile_1005: Texture:
	set(value):
		tile_1005 = value
		changed.emit()
@export var tile_1006: Texture:
	set(value):
		tile_1006 = value
		changed.emit()
@export var tile_1007: Texture:
	set(value):
		tile_1007 = value
		changed.emit()
@export var tile_1008: Texture:
	set(value):
		tile_1008 = value
		changed.emit()
@export var tile_1009: Texture:
	set(value):
		tile_1009 = value
		changed.emit()
@export var tile_1010: Texture:
	set(value):
		tile_1010 = value
		changed.emit()

@export_subgroup("Row 1")
@export var tile_1011: Texture:
	set(value):
		tile_1011 = value
		changed.emit()
@export var tile_1012: Texture:
	set(value):
		tile_1012 = value
		changed.emit()
@export var tile_1013: Texture:
	set(value):
		tile_1013 = value
		changed.emit()
@export var tile_1014: Texture:
	set(value):
		tile_1014 = value
		changed.emit()
@export var tile_1015: Texture:
	set(value):
		tile_1015 = value
		changed.emit()
@export var tile_1016: Texture:
	set(value):
		tile_1016 = value
		changed.emit()
@export var tile_1017: Texture:
	set(value):
		tile_1017 = value
		changed.emit()
@export var tile_1018: Texture:
	set(value):
		tile_1018 = value
		changed.emit()
@export var tile_1019: Texture:
	set(value):
		tile_1019 = value
		changed.emit()
@export var tile_1020: Texture:
	set(value):
		tile_1020 = value
		changed.emit()

@export_subgroup("Row 2")
@export var tile_1021: Texture:
	set(value):
		tile_1021 = value
		changed.emit()
@export var tile_1022: Texture:
	set(value):
		tile_1022 = value
		changed.emit()
@export var tile_1023: Texture:
	set(value):
		tile_1023 = value
		changed.emit()
@export var tile_1024: Texture:
	set(value):
		tile_1024 = value
		changed.emit()
@export var tile_1025: Texture:
	set(value):
		tile_1025 = value
		changed.emit()
@export var tile_1026: Texture:
	set(value):
		tile_1026 = value
		changed.emit()
@export var tile_1027: Texture:
	set(value):
		tile_1027 = value
		changed.emit()
@export var tile_1028: Texture:
	set(value):
		tile_1028 = value
		changed.emit()
@export var tile_1029: Texture:
	set(value):
		tile_1029 = value
		changed.emit()
@export var tile_1030: Texture:
	set(value):
		tile_1030 = value
		changed.emit()


const tile_cordinate_map: Dictionary = {
	'tile_1001': [Vector2(0, 1),  Vector2(0, 1)],
	'tile_1002': [Vector2(1, 2),  Vector2(0, 1)],
	'tile_1003': [Vector2(2, 3),  Vector2(0, 1)],
	'tile_1004': [Vector2(3, 4),  Vector2(0, 1)],
	'tile_1005': [Vector2(4, 5),  Vector2(0, 1)],
	'tile_1006': [Vector2(5, 6),  Vector2(0, 1)],
	'tile_1007': [Vector2(6, 7),  Vector2(0, 1)],
	'tile_1008': [Vector2(7, 8),  Vector2(0, 1)],
	'tile_1009': [Vector2(8, 9),  Vector2(0, 1)],
	'tile_1010': [Vector2(9, 10), Vector2(0, 1)],
	'tile_1011': [Vector2(0, 1),  Vector2(-1, 0)],
	'tile_1012': [Vector2(1, 2),  Vector2(-1, 0)],
	'tile_1013': [Vector2(2, 3),  Vector2(-1, 0)],
	'tile_1014': [Vector2(3, 4),  Vector2(-1, 0)],
	'tile_1015': [Vector2(4, 5),  Vector2(-1, 0)],
	'tile_1016': [Vector2(5, 6),  Vector2(-1, 0)],
	'tile_1017': [Vector2(6, 7),  Vector2(-1, 0)],
	'tile_1018': [Vector2(7, 8),  Vector2(-1, 0)],
	'tile_1019': [Vector2(8, 9),  Vector2(-1, 0)],
	'tile_1020': [Vector2(9, 10), Vector2(-1, 0)],
	'tile_1021': [Vector2(0, 1),  Vector2(-2, -1)],
	'tile_1022': [Vector2(1, 2),  Vector2(-2, -1)],
	'tile_1023': [Vector2(2, 3),  Vector2(-2, -1)],
	'tile_1024': [Vector2(3, 4),  Vector2(-2, -1)],
	'tile_1025': [Vector2(4, 5),  Vector2(-2, -1)],
	'tile_1026': [Vector2(5, 6),  Vector2(-2, -1)],
	'tile_1027': [Vector2(6, 7),  Vector2(-2, -1)],
	'tile_1028': [Vector2(7, 8),  Vector2(-2, -1)],
	'tile_1029': [Vector2(8, 9),  Vector2(-2, -1)],
	'tile_1030': [Vector2(9, 10), Vector2(-2, -1)],
}

func has_tiles() -> bool:
	for i in range(1001, 1031):
		var tile = "tile_" + str(i)
		if get(tile) != null:
			return true
	return false

func get_tiles_status() -> Dictionary:
	var tiles = {}
	for i in range(1001, 1031):
		var tile = "tile_" + str(i)
		tiles[tile] = [
			get(tile) != null,
			tile_cordinate_map[tile],
		]
	return tiles
