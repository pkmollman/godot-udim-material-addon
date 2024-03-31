@tool
extends EditorPlugin

var udim_mapper: UDIMTextureMapperPlugin = null

func _enter_tree():
	udim_mapper = UDIMTextureMapperPlugin.new()
	add_inspector_plugin(udim_mapper)

func _exit_tree():
	remove_inspector_plugin(udim_mapper)
