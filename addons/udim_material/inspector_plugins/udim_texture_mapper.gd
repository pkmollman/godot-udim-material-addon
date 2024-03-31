@tool
class_name UDIMTextureMapperPlugin
extends EditorInspectorPlugin

func _can_handle(object):
	if object is UDIMTextureTileset:
		return true
	return false


func _parse_begin(object):
	# We handle properties of type integer.
	if object is UDIMTextureTileset:
		# Create an instance of the custom property editor and register
		# it to a specific property path.
		var mapper_button: UDIMTextureMapper = UDIMTextureMapper.new()
		mapper_button.tileset = object
		add_custom_control(mapper_button)
		# Inform the editor to remove the default property editor for
		# this property type.
