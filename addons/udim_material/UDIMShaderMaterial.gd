@icon("res://addons/udim_material/icons/udim_shader_material.svg")
@tool
extends ShaderMaterial
class_name UDIMShaderMaterial

func int_to_str(int_str):
	if int_str < 10:
		return "00" + str(int_str)
	elif int_str < 100:
		return "0" + str(int_str)
	return str(int_str)


const IGNORED_PROPERTIES = [
	"shader",
	"use_custom_shader",
]

func _validate_property(property):
	if property.name in IGNORED_PROPERTIES:
		property.usage = PROPERTY_USAGE_NO_EDITOR

## Allow using a custom shader script (Currently does nothing)
@export() var use_custom_shader: bool = false:
	set(new_value):
		use_custom_shader = new_value
		_update_shader()

# transparancy
@export_subgroup("Transparency")
@export var transparency: BaseMaterial3D.Transparency = BaseMaterial3D.TRANSPARENCY_DISABLED:
	set(new_value):
		transparency = new_value
		_update_shader()
@export var blend_mode: BaseMaterial3D.BlendMode = BaseMaterial3D.BLEND_MODE_MIX:
	set(new_value):
		blend_mode = new_value
		_update_shader()
@export var cull_mode: BaseMaterial3D.CullMode =  BaseMaterial3D.CULL_BACK:
	set(new_value):
		cull_mode = new_value
		_update_shader()
@export var depth_draw_mode: BaseMaterial3D.DepthDrawMode = BaseMaterial3D.DEPTH_DRAW_OPAQUE_ONLY:
	set(new_value):
		depth_draw_mode = new_value
		_update_shader()

# shading
@export_subgroup("Shading")
@export var shading_mode: BaseMaterial3D.ShadingMode =  BaseMaterial3D.SHADING_MODE_PER_PIXEL:
	set(new_value):
		shading_mode = new_value
		_update_shader()
@export var diffuse_mode: BaseMaterial3D.DiffuseMode = BaseMaterial3D.DIFFUSE_BURLEY:
	set(new_value):
		diffuse_mode = new_value
		_update_shader()
@export var specular_mode: BaseMaterial3D.SpecularMode =  BaseMaterial3D.SPECULAR_SCHLICK_GGX:
	set(new_value):
		specular_mode = new_value
		_update_shader()
@export var disable_ambient_light: bool = false:
	set(new_value):
		disable_ambient_light = new_value
		_update_shader()
@export var disable_fog: bool = false:
	set(new_value):
		disable_fog = new_value
		_update_shader()


# vertex color
@export_subgroup("Vertex Color")
@export var vertex_color_use_as_albedo: bool = false:
	set(new_value):
		vertex_color_use_as_albedo = new_value
		_update_shader()
@export var vertex_color_is_srgb: bool = false:
	set(new_value):
		vertex_color_is_srgb = new_value
		_update_shader()

# albedo
@export_subgroup("Albedo")
@export var albedo_color: Color = Color.WHITE:
	set(new_value):
		albedo_color = new_value
		_update_shader()
@export var albedo_tileset: UDIMTextureTileset:
	set(value):
		albedo_tileset = value
		if albedo_tileset != null and not albedo_tileset.changed.is_connected(update_shader):
			albedo_tileset.changed.connect(_update_shader)
		_update_shader()
@export var texture_force_srgb: bool:
	set(new_value):
		texture_force_srgb = new_value
		_update_shader()
@export var texture_msdf: bool:
	set(new_value):
		texture_msdf = new_value
		_update_shader()

# metallic
@export_subgroup("Metallic")
@export_range(0.0, 1.0) var metallic: float = 0.0:
	set(new_value):
		metallic = new_value
		_update_shader()
@export_range(0.0, 1.0) var metallic_specular: float = 0.5:
	set(new_value):
		metallic_specular = new_value
		_update_shader()
@export var metallic_texture: Texture:
	set(new_value):
		metallic_texture = new_value
		_update_shader()
@export var metallic_texture_channel: BaseMaterial3D.TextureChannel:
	set(new_value):
		metallic_texture_channel = new_value
		_update_shader()

# roughness
@export_subgroup("Roughness")
@export_range(0.0, 1.0) var roughness: float = 1.0:
	set(new_value):
		roughness = new_value
		_update_shader()
@export var roughness_texture: Texture:
	set(new_value):
		roughness_texture = new_value
		_update_shader()
@export var roughness_texture_channel: BaseMaterial3D.TextureChannel:
	set(new_value):
		roughness_texture_channel = new_value
		_update_shader()

# emission
@export_subgroup("Emission")
@export var emission_enabled: bool = false:
	set(new_value):
		emission_enabled = new_value
		_update_shader()
@export var emission_color: Color = Color.BLACK:
	set(new_value):
		emission_color = new_value
		_update_shader()
@export_range(0.0, 16.0) var emission_multiplier: float = 1.0:
	set(new_value):
		emission_multiplier = new_value
		_update_shader()
@export var emission_op: BaseMaterial3D.EmissionOperator = BaseMaterial3D.EMISSION_OP_ADD:
	set(new_value):
		emission_op = new_value
		_update_shader()
@export var emission_on_uv2: bool = false:
	set(new_value):
		emission_on_uv2 = new_value
		_update_shader()
@export var emission_texture: Texture:
	set(new_value):
		emission_texture = new_value
		_update_shader()

# normal map
@export_subgroup("Normal Map")
@export var normal_enabled: bool = false:
	set(new_value):
		normal_enabled = new_value
		_update_shader()
@export_range(-16.0, 16.0) var normal_scale: float = 1.0:
	set(new_value):
		normal_scale = new_value
		_update_shader()
@export var normal_texture: Texture:
	set(new_value):
		normal_texture = new_value
		_update_shader()

# rim
@export_subgroup("Rim")
@export var rim_enabled: bool = false:
	set(new_value):
		rim_enabled = new_value
		_update_shader()
@export_range(0.0, 1.0) var rim: float = 1.0:
	set(new_value):
		rim = new_value
		_update_shader()
@export_range(0.0, 1.0) var rim_tint: float = 0.5:
	set(new_value):
		rim_tint = new_value
		_update_shader()
@export var rim_texture: Texture:
	set(new_value):
		rim_texture = new_value
		_update_shader()

# clearcoat
@export_subgroup("Clearcoat")
@export var clearcoat_enabled: bool = false:
	set(new_value):
		clearcoat_enabled = new_value
		_update_shader()
@export_range(0.0, 1.0) var clearcoat: float = 1.0:
	set(new_value):
		clearcoat = new_value
		_update_shader()
@export_range(0.0, 1.0) var clearcoat_roughness: float = 0.5:
	set(new_value):
		clearcoat_roughness = new_value
		_update_shader()
@export var clearcoat_texture: Texture:
	set(new_value):
		clearcoat_texture = new_value
		_update_shader()

# anisotropy
@export_subgroup("Anisotropy")
@export var anisotropy_enabled: bool = false:
	set(new_value):
		anisotropy_enabled = new_value
		_update_shader()
@export_range(-1.0, 1.0) var anisotropy: float = 0.0:
	set(new_value):
		anisotropy = new_value
		_update_shader()
@export var anisotropy_flowmap: Texture:
	set(new_value):
		anisotropy_flowmap = new_value
		_update_shader()

# ambient_occlusion
@export_subgroup("Ambient Occlusion")
@export var ao_enabled: bool = false:
	set(new_value):
		ao_enabled = new_value
		_update_shader()
@export_range(0.0, 1.0) var ao_light_effect: float = 0.0:
	set(new_value):
		ao_light_effect = new_value
		_update_shader()
@export var ao_texture: Texture:
	set(new_value):
		ao_texture = new_value
		_update_shader()
@export var ao_on_uv2: bool = false:
	set(new_value):
		ao_on_uv2 = new_value
		_update_shader()
@export var ao_texture_channel: BaseMaterial3D.TextureChannel:
	set(new_value):
		ao_texture_channel = new_value
		_update_shader()

# heightmap
@export_subgroup("Heightmap")
@export var heightmap_enabled: bool = false:
	set(new_value):
		heightmap_enabled = new_value
		_update_shader()
@export_range(-16.0, 16.0) var heightmap_scale: float = 5.0:
	set(new_value):
		heightmap_scale = new_value
		_update_shader()
@export var heightmap_deep_parallax: bool = false:
	set(new_value):
		heightmap_deep_parallax = new_value
		_update_shader()
@export var heightmap_flip_tangent: bool = false:
	set(new_value):
		heightmap_flip_tangent = new_value
		_update_shader()
@export var heightmap_flip_binormal: bool = false:
	set(new_value):
		heightmap_flip_binormal = new_value
		_update_shader()
@export var heightmap_texture: Texture:
	set(new_value):
		heightmap_texture = new_value
		_update_shader()
@export var heightmap_flip_texture: bool = false:
	set(new_value):
		heightmap_flip_texture = new_value
		_update_shader()

# subfur_scatter
@export_subgroup("Subsurface Scattering")
@export var subsurf_scatter_enabled: bool = false:
	set(new_value):
		subsurf_scatter_enabled = new_value
		_update_shader()
@export_range(0.0, 1.0) var subsurf_scatter_strength: float = 0.0:
	set(new_value):
		subsurf_scatter_strength = new_value
		_update_shader()
@export var subsurf_scatter_skin_mode: bool = false:
	set(new_value):
		subsurf_scatter_skin_mode = new_value
		_update_shader()
@export var subsurf_scatter_texture: Texture:
	set(new_value):
		subsurf_scatter_texture = new_value
		_update_shader()
@export var subsurf_scatter_transmittance_enabled: bool = false:
	set(new_value):
		subsurf_scatter_transmittance_enabled = new_value
		_update_shader()
@export_range(0.001, 8.0) var subsurf_scatter_transmittance_depth: float = 0.1:
	set(new_value):
		subsurf_scatter_transmittance_depth = new_value
		_update_shader()
@export_range(0.0, 1.0) var subsurf_scatter_transmittance_boost: float = 0.0:
	set(new_value):
		subsurf_scatter_transmittance_boost = new_value
		_update_shader()

# backlight
@export_subgroup("Backlight")
@export var backlight_enabled: bool = false:
	set(new_value):
		backlight_enabled = new_value
		_update_shader()
@export var backlight_backlight: Color = Color.BLACK:
	set(new_value):
		backlight_backlight = new_value
		_update_shader()
@export var backlight_texture: Texture:
	set(new_value):
		backlight_texture = new_value
		_update_shader()

# refraction
@export_subgroup("Refraction")
@export var refraction_enabled: bool = false:
	set(new_value):
		refraction_enabled = new_value
		_update_shader()
@export_range(-1.0, 1.0) var refraction_scale: float = 0.05:
	set(new_value):
		refraction_scale = new_value
		_update_shader()
@export var refraction_texture: Texture:
	set(new_value):
		refraction_texture = new_value
		_update_shader()
@export var refraction_texture_channel: BaseMaterial3D.TextureChannel:
	set(new_value):
		refraction_texture_channel = new_value
		_update_shader()

# detail
@export_subgroup("Detail")
@export var detail_enabled: bool = false:
	set(new_value):
		detail_enabled = new_value
		_update_shader()
@export var detail_mask: Texture:
	set(new_value):
		detail_mask = new_value
		_update_shader()
@export var detail_blend_mode: BaseMaterial3D.BlendMode:
	set(new_value):
		detail_blend_mode = new_value
		_update_shader()
@export var detail_uv: BaseMaterial3D.DetailUV:
	set(new_value):
		detail_uv = new_value
		_update_shader()
@export var detail_albedo: Texture:
	set(new_value):
		detail_albedo = new_value
		_update_shader()
@export var detail_normal: Texture:
	set(new_value):
		detail_normal = new_value
		_update_shader()

# sampling
@export_subgroup("Sampling")
@export var texture_filter: BaseMaterial3D.TextureFilter:
	set(new_value):
		texture_filter = new_value
		_update_shader()
@export var texture_repeat: bool = true:
	set(new_value):
		texture_repeat = new_value
		_update_shader()

# shadows
@export_subgroup("Shadows")
@export var disable_receive_shadows: bool = false:
	set(new_value):
		disable_receive_shadows = new_value
		_update_shader()
@export var shadow_to_opacity: bool = false:
	set(new_value):
		shadow_to_opacity = new_value
		_update_shader()

# billboard
# pls no more
@export_subgroup("Billboard")
@export var billboard_mode: BaseMaterial3D.BillboardMode

# grow
@export_subgroup("Grow")
@export var grow_enabled: bool:
	set(new_value):
		grow_enabled = new_value
		_update_shader()
@export_range(-16.0, 16.0) var grow_amount: float = 0.0:
	set(new_value):
		grow_amount = new_value
		_update_shader()


# transform
@export_subgroup("Transform")
@export var fixed_size: bool = false:
	set(new_value):
		fixed_size = new_value
		_update_shader()
@export var use_point_size: bool = false:
	set(new_value):
		use_point_size = new_value
		_update_shader()
@export_range(0.1, 128.0, 0.01, "suffix:px") var point_size: float = 1.0:
	set(new_value):
		point_size = new_value
		_update_shader()
@export var use_particle_trails: bool = false:
	set(new_value):
		use_particle_trails = new_value
		_update_shader()

# proximity fade
@export_subgroup("Proximity Fade")
@export var proximity_fade_enabled: bool:
	set(new_value):
		proximity_fade_enabled = new_value
		_update_shader()
@export_range(0.1, 128.0, 0.01, "suffix:m") var proximity_fade_distance: float = 1.0:
	set(new_value):
		proximity_fade_distance = new_value
		_update_shader()


# TODO skipping for now....
@export var distance_fade: BaseMaterial3D.DistanceFadeMode


# TODO 
@export var alpha_antialiasing_mode: BaseMaterial3D.AlphaAntiAliasing



var features = {
	BaseMaterial3D.FEATURE_EMISSION: false,
	BaseMaterial3D.FEATURE_NORMAL_MAPPING: false,
	BaseMaterial3D.FEATURE_RIM: false,
	BaseMaterial3D.FEATURE_CLEARCOAT: false,
	BaseMaterial3D.FEATURE_ANISOTROPY: false,
	BaseMaterial3D.FEATURE_AMBIENT_OCCLUSION: false,
	BaseMaterial3D.FEATURE_HEIGHT_MAPPING: false,
	BaseMaterial3D.FEATURE_SUBSURFACE_SCATTERING: false,
	BaseMaterial3D.FEATURE_SUBSURFACE_TRANSMITTANCE: false,
	BaseMaterial3D.FEATURE_BACKLIGHT: false,
	BaseMaterial3D.FEATURE_REFRACTION: false,
	BaseMaterial3D.FEATURE_DETAIL: false,
	BaseMaterial3D.FEATURE_MAX: false,
}

func _update_features():
	features[BaseMaterial3D.FEATURE_EMISSION] = emission_enabled
	features[BaseMaterial3D.FEATURE_NORMAL_MAPPING] = normal_enabled
	features[BaseMaterial3D.FEATURE_RIM] = rim_enabled
	features[BaseMaterial3D.FEATURE_CLEARCOAT] = clearcoat_enabled
	features[BaseMaterial3D.FEATURE_ANISOTROPY] = anisotropy_enabled
	features[BaseMaterial3D.FEATURE_AMBIENT_OCCLUSION] = ao_enabled
	features[BaseMaterial3D.FEATURE_HEIGHT_MAPPING] = heightmap_enabled
	features[BaseMaterial3D.FEATURE_SUBSURFACE_SCATTERING] = subsurf_scatter_enabled
	features[BaseMaterial3D.FEATURE_SUBSURFACE_TRANSMITTANCE] = subsurf_scatter_transmittance_enabled
	features[BaseMaterial3D.FEATURE_BACKLIGHT] = backlight_enabled
	features[BaseMaterial3D.FEATURE_REFRACTION] = refraction_enabled
	features[BaseMaterial3D.FEATURE_DETAIL] = detail_enabled

var flags = {
	BaseMaterial3D.FLAG_DISABLE_DEPTH_TEST: false,
	BaseMaterial3D.FLAG_ALBEDO_FROM_VERTEX_COLOR: false,
	BaseMaterial3D.FLAG_SRGB_VERTEX_COLOR: false,
	BaseMaterial3D.FLAG_USE_POINT_SIZE: false,
	BaseMaterial3D.FLAG_FIXED_SIZE: false,
	BaseMaterial3D.FLAG_BILLBOARD_KEEP_SCALE: false,
	BaseMaterial3D.FLAG_UV1_USE_TRIPLANAR: false,
	BaseMaterial3D.FLAG_UV2_USE_TRIPLANAR: false,
	BaseMaterial3D.FLAG_UV1_USE_WORLD_TRIPLANAR: false,
	BaseMaterial3D.FLAG_UV2_USE_WORLD_TRIPLANAR: false,
	BaseMaterial3D.FLAG_AO_ON_UV2: false,
	BaseMaterial3D.FLAG_EMISSION_ON_UV2: false,
	BaseMaterial3D.FLAG_ALBEDO_TEXTURE_FORCE_SRGB: false,
	BaseMaterial3D.FLAG_DONT_RECEIVE_SHADOWS: false,
	BaseMaterial3D.FLAG_DISABLE_AMBIENT_LIGHT: false,
	BaseMaterial3D.FLAG_USE_SHADOW_TO_OPACITY: false,
	BaseMaterial3D.FLAG_USE_TEXTURE_REPEAT: false,
	BaseMaterial3D.FLAG_INVERT_HEIGHTMAP: false,
	BaseMaterial3D.FLAG_SUBSURFACE_MODE_SKIN: false,
	BaseMaterial3D.FLAG_PARTICLE_TRAILS_MODE: false,
	BaseMaterial3D.FLAG_ALBEDO_TEXTURE_MSDF: false,
	BaseMaterial3D.FLAG_DISABLE_FOG: false,
	BaseMaterial3D.FLAG_MAX: false,
}

func _update_flags():
	flags[BaseMaterial3D.FLAG_DISABLE_DEPTH_TEST] = false
	flags[BaseMaterial3D.FLAG_ALBEDO_FROM_VERTEX_COLOR] = vertex_color_use_as_albedo
	flags[BaseMaterial3D.FLAG_SRGB_VERTEX_COLOR] = vertex_color_is_srgb
	flags[BaseMaterial3D.FLAG_USE_POINT_SIZE] = use_point_size
	flags[BaseMaterial3D.FLAG_FIXED_SIZE] = fixed_size
	flags[BaseMaterial3D.FLAG_BILLBOARD_KEEP_SCALE] = false
	flags[BaseMaterial3D.FLAG_UV1_USE_TRIPLANAR] = false
	flags[BaseMaterial3D.FLAG_UV2_USE_TRIPLANAR] = false
	flags[BaseMaterial3D.FLAG_UV1_USE_WORLD_TRIPLANAR] = false
	flags[BaseMaterial3D.FLAG_UV2_USE_WORLD_TRIPLANAR] = false
	flags[BaseMaterial3D.FLAG_AO_ON_UV2] = ao_on_uv2
	flags[BaseMaterial3D.FLAG_EMISSION_ON_UV2] = emission_on_uv2
	flags[BaseMaterial3D.FLAG_ALBEDO_TEXTURE_FORCE_SRGB] = texture_force_srgb
	flags[BaseMaterial3D.FLAG_DONT_RECEIVE_SHADOWS] = disable_receive_shadows
	flags[BaseMaterial3D.FLAG_DISABLE_AMBIENT_LIGHT] = disable_ambient_light
	flags[BaseMaterial3D.FLAG_USE_SHADOW_TO_OPACITY] = shadow_to_opacity
	flags[BaseMaterial3D.FLAG_USE_TEXTURE_REPEAT] = texture_repeat
	flags[BaseMaterial3D.FLAG_INVERT_HEIGHTMAP] = heightmap_flip_texture
	flags[BaseMaterial3D.FLAG_SUBSURFACE_MODE_SKIN] = subsurf_scatter_skin_mode
	flags[BaseMaterial3D.FLAG_PARTICLE_TRAILS_MODE] = use_particle_trails
	flags[BaseMaterial3D.FLAG_ALBEDO_TEXTURE_MSDF] = texture_msdf
	flags[BaseMaterial3D.FLAG_DISABLE_FOG] = disable_fog

func _init():
	_update_shader()
	if albedo_tileset != null and not albedo_tileset.changed.is_connected(_update_shader):
		albedo_tileset.changed.connect(_update_shader)

func update_shader():
	if albedo_tileset != null:
		for tile_name in albedo_tileset.get_tiles_status().keys():
			set_shader_parameter(tile_name, albedo_tileset.get(tile_name))
	else:
		update_shader_null()

func update_shader_null():
	for tile_name in UDIMTextureTileset.tile_cordinate_map.keys():
		set_shader_parameter(tile_name, null)

func _update_shader_params():
	update_shader()
	# handle features
	if features[BaseMaterial3D.FEATURE_EMISSION]:
		set_shader_parameter("emission_color", emission_color)
		set_shader_parameter("emission_energy", emission_multiplier)
		set_shader_parameter("emission_texture", emission_texture)
		set_shader_parameter("emission_op", emission_op)
		set_shader_parameter("emission_on_uv2", emission_on_uv2)
	
	if features[BaseMaterial3D.FEATURE_NORMAL_MAPPING]:
		set_shader_parameter("normal_scale", normal_scale)
		set_shader_parameter("normal_texture", normal_texture)
	
	if features[BaseMaterial3D.FEATURE_RIM]:
		set_shader_parameter("rim", rim)
		set_shader_parameter("rim_tint", rim_tint)
		set_shader_parameter("rim_texture", rim_texture)
	
	if features[BaseMaterial3D.FEATURE_CLEARCOAT]:
		set_shader_parameter("clearcoat", clearcoat)
		set_shader_parameter("clearcoat_roughness", clearcoat_roughness)
		set_shader_parameter("clearcoat_texture", clearcoat_texture)

	if features[BaseMaterial3D.FEATURE_ANISOTROPY]:
		set_shader_parameter("anisotropy", anisotropy)
		set_shader_parameter("anisotropy_flowmap", anisotropy_flowmap)
	
	if features[BaseMaterial3D.FEATURE_AMBIENT_OCCLUSION]:
		set_shader_parameter("ao_light_effect", ao_light_effect)
		set_shader_parameter("ao_texture", ao_texture)
		set_shader_parameter("ao_texture_channel", ao_texture_channel)
		set_shader_parameter("ao_on_uv2", ao_on_uv2)
	
	if features[BaseMaterial3D.FEATURE_HEIGHT_MAPPING]:
		set_shader_parameter("heightmap_scale", heightmap_scale)
		set_shader_parameter("heightmap_deep_parallax", heightmap_deep_parallax)
		set_shader_parameter("heightmap_flip_tangent", heightmap_flip_tangent)
		set_shader_parameter("heightmap_flip_binormal", heightmap_flip_binormal)
		set_shader_parameter("heightmap_texture", heightmap_texture)
		set_shader_parameter("heightmap_flip_texture", heightmap_flip_texture)
	
	if features[BaseMaterial3D.FEATURE_SUBSURFACE_SCATTERING]:
		set_shader_parameter("subsurf_scatter_strength", subsurf_scatter_strength)
		set_shader_parameter("subsurf_scatter_skin_mode", subsurf_scatter_skin_mode)
		set_shader_parameter("subsurf_scatter_texture", subsurf_scatter_texture)
	
	if features[BaseMaterial3D.FEATURE_SUBSURFACE_TRANSMITTANCE]:
		set_shader_parameter("subsurf_scatter_transmittance_depth", subsurf_scatter_transmittance_depth)
		set_shader_parameter("subsurf_scatter_transmittance_boost", subsurf_scatter_transmittance_boost)
	
	if features[BaseMaterial3D.FEATURE_BACKLIGHT]:
		set_shader_parameter("backlight", backlight_backlight)
		set_shader_parameter("backlight_texture", backlight_texture)
	
	if features[BaseMaterial3D.FEATURE_REFRACTION]:
		set_shader_parameter("refraction_scale", refraction_scale)
		set_shader_parameter("refraction_texture", refraction_texture)
		set_shader_parameter("refraction_texture_channel", refraction_texture_channel)
	
	if features[BaseMaterial3D.FEATURE_DETAIL]:
		set_shader_parameter("detail_mask", detail_mask)
		set_shader_parameter("detail_blend_mode", detail_blend_mode)
		set_shader_parameter("detail_uv", detail_uv)
		set_shader_parameter("detail_albedo", detail_albedo)
		set_shader_parameter("detail_normal", detail_normal)
	
	# handle thins that dont change
	set_shader_parameter("albedo", albedo_color)
	# set_shader_parameter("texture_albedo", albedo_texture)
	set_shader_parameter("metallic", metallic)
	set_shader_parameter("metallic_specular", metallic_specular)
	set_shader_parameter("metallic_texture", metallic_texture)
	set_shader_parameter("metallic_texture_channel", metallic_texture_channel)
	set_shader_parameter("roughness", roughness)
	set_shader_parameter("roughness_texture", roughness_texture)
	set_shader_parameter("roughness_texture_channel", roughness_texture_channel)
	set_shader_parameter("point_size", point_size)
	set_shader_parameter("grow", grow_amount)
	set_shader_parameter("proximity_fade_distance", proximity_fade_distance)
	set_shader


func _update_shader():
	_update_features()
	_update_flags()

	var texfilter_str: String
	var texfilter_height_str: String

	match texture_filter:
		BaseMaterial3D.TextureFilter.TEXTURE_FILTER_NEAREST:
			texfilter_str = "filter_nearest"
			texfilter_height_str = "filter_linear"
		BaseMaterial3D.TextureFilter.TEXTURE_FILTER_LINEAR:
			texfilter_str = "filter_linear"
			texfilter_height_str = "filter_linear"
		BaseMaterial3D.TextureFilter.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS:
			texfilter_str = "filter_nearest_mipmap"
			texfilter_height_str = "filter_linear_mipmap"
		BaseMaterial3D.TextureFilter.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS:
			texfilter_str = "filter_linear_mipmap"
			texfilter_height_str = "filter_linear_mipmap"
		BaseMaterial3D.TextureFilter.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC:
			texfilter_str = "filter_nearest_mipmap_anisotropic"
			texfilter_height_str = "filter_linear_mipmap_anisotropic"
		BaseMaterial3D.TextureFilter.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC:
			texfilter_str = "filter_linear_mipmap_anisotropic"
			texfilter_height_str = "filter_linear_mipmap_anisotropic"

	if flags[BaseMaterial3D.FLAG_USE_TEXTURE_REPEAT]:
		texfilter_str += ",repeat_enable"
		texfilter_height_str += ",repeat_enable"
	else:
		texfilter_str += ",repeat_disable"
		texfilter_height_str += ",repeat_disable"

	var code = "// NOTE: This UDIM Shader is automatically generated\n\n"

	code += "shader_type spatial;\nrender_mode "
	match blend_mode:
		BaseMaterial3D.BlendMode.BLEND_MODE_MIX:
			code += "blend_mix"
		BaseMaterial3D.BlendMode.BLEND_MODE_ADD:
			code += "blend_add"
		BaseMaterial3D.BlendMode.BLEND_MODE_SUB:
			code += "blend_sub"
		BaseMaterial3D.BlendMode.BLEND_MODE_MUL:
			code += "blend_mul"
	
	var ddm: BaseMaterial3D.DepthDrawMode = depth_draw_mode
	if features[BaseMaterial3D.FEATURE_REFRACTION]:
		ddm = BaseMaterial3D.DEPTH_DRAW_ALWAYS
	
	match ddm:
		BaseMaterial3D.DEPTH_DRAW_OPAQUE_ONLY:
			code += ",depth_draw_opaque"
		BaseMaterial3D.DEPTH_DRAW_ALWAYS:
			code += ",depth_draw_always"
		BaseMaterial3D.DEPTH_DRAW_DISABLED:
			code += ",depth_draw_never"
	
	match cull_mode:
		BaseMaterial3D.CULL_BACK:
			code += ",cull_back"
		BaseMaterial3D.CULL_FRONT:
			code += ",cull_front"
		BaseMaterial3D.CULL_DISABLED:
			code += ",cull_disabled"
	
	match diffuse_mode:
		BaseMaterial3D.DIFFUSE_BURLEY:
			code += ",diffuse_burley"
		BaseMaterial3D.DIFFUSE_LAMBERT:
			code += ",diffuse_lambert"
		BaseMaterial3D.DIFFUSE_LAMBERT_WRAP:
			code += ",diffuse_lambert_wrap"
		BaseMaterial3D.DIFFUSE_TOON:
			code += ",diffuse_toon"

	match specular_mode:
		BaseMaterial3D.SPECULAR_SCHLICK_GGX:
			code += ",specular_schlick_ggx"
		BaseMaterial3D.SPECULAR_TOON:
			code += ",specular_toon"
		BaseMaterial3D.SPECULAR_DISABLED:
			code += ",specular_disabled"

	if features[BaseMaterial3D.FEATURE_SUBSURFACE_SCATTERING] and flags[BaseMaterial3D.FLAG_SUBSURFACE_MODE_SKIN]:
		code += ",sss_mode_skin"

	if shading_mode == BaseMaterial3D.ShadingMode.SHADING_MODE_UNSHADED:
		code += ",unshaded"

	if flags[BaseMaterial3D.FLAG_DISABLE_DEPTH_TEST]:
		code += ",depth_test_disabled"

	if flags[BaseMaterial3D.FLAG_PARTICLE_TRAILS_MODE]:
		code += ",particle_trails"

	if shading_mode == BaseMaterial3D.ShadingMode.SHADING_MODE_PER_VERTEX:
		code += ",vertex_lighting"

	if flags[BaseMaterial3D.FLAG_DONT_RECEIVE_SHADOWS]:
		code += ",shadows_disabled"

	if flags[BaseMaterial3D.FLAG_DISABLE_AMBIENT_LIGHT]:
		code += ",ambient_light_disabled"

	if flags[BaseMaterial3D.FLAG_USE_SHADOW_TO_OPACITY]:
		code += ",shadow_to_opacity"

	if transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS:
		code += ",depth_prepass_alpha"

	if transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_HASH or transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR:
		if alpha_antialiasing_mode == BaseMaterial3D.ALPHA_ANTIALIASING_ALPHA_TO_COVERAGE:
			code += ",alpha_to_coverage"
		elif alpha_antialiasing_mode == BaseMaterial3D.ALPHA_ANTIALIASING_ALPHA_TO_COVERAGE_AND_TO_ONE:
			code += ",alpha_to_coverage_and_one"

	code += ";\n"

	code += "uniform vec4 albedo : source_color;\n"
	code += "uniform sampler2D texture_albedo : source_color," + texfilter_str + ";\n"

	if albedo_tileset != null and albedo_tileset.has_tiles():
		var tile_stats = albedo_tileset.get_tiles_status()
		var valid_tiles = []
		for tile_name in tile_stats.keys():
			if tile_stats[tile_name][0]:
				valid_tiles.append(tile_name)
		for tile_name in valid_tiles:
			code += "uniform sampler2D " + tile_name + " : source_color," + texfilter_str + ";\n"

	if grow_enabled:
		code += "uniform float grow;\n"

	if proximity_fade_enabled:
		code += "uniform float proximity_fade_distance;\n"

	if distance_fade != BaseMaterial3D.DistanceFadeMode.DISTANCE_FADE_DISABLED:
		code += "uniform float distance_fade_min;\n"
		code += "uniform float distance_fade_max;\n"

	if flags[BaseMaterial3D.FLAG_ALBEDO_TEXTURE_MSDF]:
		code += "uniform float msdf_pixel_range;\n"
		code += "uniform float msdf_outline_size;\n"

	if transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR:
		code += "uniform float alpha_scissor_threshold;\n"
	elif transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_HASH:
		code += "uniform float alpha_hash_scale;\n"

	if alpha_antialiasing_mode != BaseMaterial3D.ALPHA_ANTIALIASING_OFF and (transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR or transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_HASH):
		code += "uniform float alpha_antialiasing_edge;\n"
		code += "uniform ivec2 albedo_texture_size;\n"

	code += "uniform float point_size : hint_range(0,128);\n"

	code += "uniform float roughness : hint_range(0,1);\n";
	code += "uniform sampler2D texture_metallic : hint_default_white," + texfilter_str + ";\n";
	
	code += "uniform vec4 metallic_texture_channel;\n";
	match roughness_texture_channel:
		BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_RED:
			code += "uniform sampler2D texture_roughness : hint_roughness_r," + texfilter_str + ";\n"
		BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_GREEN:
			code += "uniform sampler2D texture_roughness : hint_roughness_g," + texfilter_str + ";\n"
		BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_BLUE:
			code += "uniform sampler2D texture_roughness : hint_roughness_b," + texfilter_str + ";\n"
		BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_ALPHA:
			code += "uniform sampler2D texture_roughness : hint_roughness_a," + texfilter_str + ";\n"
		BaseMaterial3D.TextureChannel.TEXTURE_CHANNEL_GRAYSCALE:
			code += "uniform sampler2D texture_roughness : hint_roughness_gray," + texfilter_str + ";\n"

	code += "uniform float specular;\n";
	code += "uniform float metallic;\n";

	if billboard_mode == BaseMaterial3D.BillboardMode.BILLBOARD_PARTICLES:
		code += "uniform int particles_anim_h_frames;\n"
		code += "uniform int particles_anim_v_frames;\n"
		code += "uniform bool particles_anim_loop;\n"

	if features[BaseMaterial3D.FEATURE_EMISSION]:
		code += "uniform sampler2D texture_emission : source_color, hint_default_black," + texfilter_str + ";\n"
		code += "uniform vec4 emission : source_color;\n"
		code += "uniform float emission_energy;\n"

	if features[BaseMaterial3D.FEATURE_REFRACTION]:
		code += "uniform sampler2D texture_refraction : " + texfilter_str + ";\n"
		code += "uniform float refraction : hint_range(-16,16);\n"
		code += "uniform vec4 refraction_texture_channel;\n"

	if features[BaseMaterial3D.FEATURE_REFRACTION]:
		code += "uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;"

	if proximity_fade_enabled:
		code += "uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;"

	if features[BaseMaterial3D.FEATURE_NORMAL_MAPPING]:
		code += "uniform sampler2D texture_normal : hint_roughness_normal," + texfilter_str + ";\n"
		code += "uniform float normal_scale : hint_range(-16,16);\n"

	if features[BaseMaterial3D.FEATURE_RIM]:
		code += "uniform float rim : hint_range(0,1);\n"
		code += "uniform float rim_tint : hint_range(0,1);\n"
		code += "uniform sampler2D texture_rim : hint_default_white," + texfilter_str + ";\n"

	if features[BaseMaterial3D.FEATURE_CLEARCOAT]:
		code += "uniform float clearcoat : hint_range(0,1);\n"
		code += "uniform float clearcoat_roughness : hint_range(0,1);\n"
		code += "uniform sampler2D texture_clearcoat : hint_default_white," + texfilter_str + ";\n"

	if features[BaseMaterial3D.FEATURE_ANISOTROPY]:
		code += "uniform float anisotropy_ratio : hint_range(0,256);\n"
		code += "uniform sampler2D texture_flowmap : hint_anisotropy," + texfilter_str + ";\n"

	if features[BaseMaterial3D.FEATURE_AMBIENT_OCCLUSION]:
		code += "uniform sampler2D texture_ambient_occlusion : hint_default_white, " + texfilter_str + ";\n"
		code += "uniform vec4 ao_texture_channel;\n"
		code += "uniform float ao_light_affect;\n"

	if features[BaseMaterial3D.FEATURE_DETAIL]:
		code += "uniform sampler2D texture_detail_albedo : source_color," + texfilter_str + ";\n"
		code += "uniform sampler2D texture_detail_normal : hint_normal," + texfilter_str + ";\n"
		code += "uniform sampler2D texture_detail_mask : hint_default_white," + texfilter_str + ";\n"

	if features[BaseMaterial3D.FEATURE_SUBSURFACE_SCATTERING]:
		code += "uniform float subsurface_scattering_strength : hint_range(0,1);\n"
		code += "uniform sampler2D texture_subsurface_scattering : hint_default_white," + texfilter_str + ";\n"

	if features[BaseMaterial3D.FEATURE_SUBSURFACE_TRANSMITTANCE]:
		code += "uniform vec4 transmittance_color : source_color;\n"
		code += "uniform float transmittance_depth;\n"
		code += "uniform sampler2D texture_subsurface_transmittance : hint_default_white," + texfilter_str + ";\n"
		code += "uniform float transmittance_boost;\n"

	if features[BaseMaterial3D.FEATURE_BACKLIGHT]:
		code += "uniform vec4 backlight : source_color;\n"
		code += "uniform sampler2D texture_backlight : hint_default_black," + texfilter_str + ";\n"

	if features[BaseMaterial3D.FEATURE_HEIGHT_MAPPING]:
		code += "uniform sampler2D texture_heightmap : hint_default_black," + texfilter_height_str + ";\n"
		code += "uniform float heightmap_scale;\n"
		code += "uniform int heightmap_min_layers;\n"
		code += "uniform int heightmap_max_layers;\n"
		code += "uniform vec2 heightmap_flip;\n"

	code += "uniform vec3 uv1_scale;\n"
	code += "uniform vec3 uv1_offset;\n"
	code += "uniform vec3 uv2_scale;\n"
	code += "uniform vec3 uv2_offset;\n"

	code += "\n\n"


	code += "vec4 map_to_udim_tile(sampler2D sampler, vec2 uv, vec2 x_thresholds, vec2 y_thresholds) {\n"
	code += "	bvec2 ltx = lessThan(vec2(uv.x,uv.x), x_thresholds);\n"
	code += "	bvec2 gtx = greaterThan(vec2(uv.x,uv.x), x_thresholds);\n"
	code += "	bvec2 lty = lessThan(vec2(uv.y,uv.y), y_thresholds);\n"
	code += "	bvec2 gty = greaterThan(vec2(uv.y,uv.y), y_thresholds);\n"
	code += "	vec4 f_tex0x = texture(sampler,uv) * float((int(ltx.y) * int(gtx.x)) * (int(lty.y) * int(gty.x)));\n"
	code += "	f_tex0x.a = 1.0;\n"
	code += "	return f_tex0x;\n"
	code += "}\n"

	code += "\n\n"

	code += "void vertex() {\n"

	if flags[BaseMaterial3D.FLAG_SRGB_VERTEX_COLOR]:
		code += "	if (!OUTPUT_IS_SRGB) {\n"
		code += "		COLOR.rgb = mix(pow((COLOR.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)), vec3(2.4)), COLOR.rgb * (1.0 / 12.92), lessThan(COLOR.rgb, vec3(0.04045)));\n"
		code += "	}\n"

	if flags[BaseMaterial3D.FLAG_USE_POINT_SIZE]:
		code += "	POINT_SIZE=point_size;\n"

	if shading_mode == BaseMaterial3D.ShadingMode.SHADING_MODE_PER_VERTEX:
		code += "	ROUGHNESS=roughness;\n"

	match billboard_mode:
		BaseMaterial3D.BillboardMode.BILLBOARD_DISABLED:
			pass

		BaseMaterial3D.BillboardMode.BILLBOARD_ENABLED:
			code += "	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);\n"
			if flags[BaseMaterial3D.FLAG_BILLBOARD_KEEP_SCALE]:
				code += "	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0), vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));\n"
			code += "	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);\n"

		BaseMaterial3D.BILLBOARD_FIXED_Y:
			code += "	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);\n"
			if flags[BaseMaterial3D.FLAG_BILLBOARD_KEEP_SCALE]:
				code += "	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));\n"
			code += "	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);\n"

		BaseMaterial3D.BILLBOARD_PARTICLES:
			# make billboard
			code += "	mat4 mat_world = mat4(normalize(INV_VIEW_MATRIX[0]), normalize(INV_VIEW_MATRIX[1]) ,normalize(INV_VIEW_MATRIX[2]), MODEL_MATRIX[3]);\n";
			# rotate by rotation
			code += "	mat_world = mat_world * mat4(vec4(cos(INSTANCE_CUSTOM.x), -sin(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));\n";
			# set modelview
			code += "	MODELVIEW_MATRIX = VIEW_MATRIX * mat_world;\n";
			if flags[BaseMaterial3D.FLAG_BILLBOARD_KEEP_SCALE]:
				code += "	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));\n";
			# set modelview normal
			code += "	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);\n";

			# handle animation
			code += "	float h_frames = float(particles_anim_h_frames);\n";
			code += "	float v_frames = float(particles_anim_v_frames);\n";
			code += "	float particle_total_frames = float(particles_anim_h_frames * particles_anim_v_frames);\n";
			code += "	float particle_frame = floor(INSTANCE_CUSTOM.z * float(particle_total_frames));\n";
			code += "	if (!particles_anim_loop) {\n";
			code += "		particle_frame = clamp(particle_frame, 0.0, particle_total_frames - 1.0);\n";
			code += "	} else {\n";
			code += "		particle_frame = mod(particle_frame, particle_total_frames);\n";
			code += "	}\n";
			code += "	UV /= vec2(h_frames, v_frames);\n";
			code += "	UV += vec2(mod(particle_frame, h_frames) / h_frames, floor((particle_frame + 0.5) / h_frames) / v_frames);\n";

	if flags[BaseMaterial3D.FLAG_FIXED_SIZE]:
		code += "	if (PROJECTION_MATRIX[3][3] != 0.0) {\n"
		code += "		float h = abs(1.0 / (2.0 * PROJECTION_MATRIX[1][1]));\n"
		code += "		float sc = (h * 2.0); //consistent with Y-fov\n"
		code += "		MODELVIEW_MATRIX[0]*=sc;\n"
		code += "		MODELVIEW_MATRIX[1]*=sc;\n"
		code += "		MODELVIEW_MATRIX[2]*=sc;\n"
		code += "	} else {\n"
		code += "		float sc = -(MODELVIEW_MATRIX)[3].z;\n"
		code += "		MODELVIEW_MATRIX[0]*=sc;\n"
		code += "		MODELVIEW_MATRIX[1]*=sc;\n"
		code += "		MODELVIEW_MATRIX[2]*=sc;\n"
		code += "	}\n"

	if detail_uv == BaseMaterial3D.DETAIL_UV_2:
		code += "	UV2=UV2*uv2_scale.xy+uv2_offset.xy;\n"

	if grow_enabled:
		code += "	VERTEX+=NORMAL*grow;\n"

	code += "}\n"
	code += "\n\n"

	if flags[BaseMaterial3D.FLAG_ALBEDO_TEXTURE_MSDF]:
		code += "float msdf_median(float r, float g, float b, float a) {\n"
		code += "	return min(max(min(r, g), min(max(r, g), b)), a);\n"
		code += "}\n"


	code += "\n\n"
	code += "void fragment() {\n"

	code += "	vec2 base_uv = UV;\n"

	if ((features[BaseMaterial3D.FEATURE_DETAIL] and detail_uv == BaseMaterial3D.DETAIL_UV_2) or (features[BaseMaterial3D.FEATURE_AMBIENT_OCCLUSION] and flags[BaseMaterial3D.FLAG_AO_ON_UV2]) or (features[BaseMaterial3D.FEATURE_EMISSION] and flags[BaseMaterial3D.FLAG_EMISSION_ON_UV2])):
		code += "	vec2 base_uv2 = UV2;\n"

	if features[BaseMaterial3D.FEATURE_HEIGHT_MAPPING]:
		code += "	{\n"
		code += "		vec3 view_dir = normalize(normalize(-VERTEX + EYE_OFFSET) * mat3(TANGENT * heightmap_flip.x, -BINORMAL * heightmap_flip.y, NORMAL));\n"

		if heightmap_deep_parallax:
			code += "		float num_layers = mix(float(heightmap_max_layers),float(heightmap_min_layers), abs(dot(vec3(0.0, 0.0, 1.0), view_dir)));\n"
			code += "		float layer_depth = 1.0 / num_layers;\n"
			code += "		float current_layer_depth = 0.0;\n"
			code += "		vec2 P = view_dir.xy * heightmap_scale * 0.01;\n"
			code += "		vec2 delta = P / num_layers;\n"
			code += "		vec2 ofs = base_uv;\n"
			if flags[BaseMaterial3D.FLAG_INVERT_HEIGHTMAP]:
				code += "		float depth = texture(texture_heightmap, ofs).r;\n"
			else:
				code += "		float depth = 1.0 - texture(texture_heightmap, ofs).r;\n"
			code += "		float current_depth = 0.0;\n"
			code += "		while(current_depth < depth) {\n"
			code += "			ofs -= delta;\n"
			if flags[BaseMaterial3D.FLAG_INVERT_HEIGHTMAP]:
				code += "			depth = texture(texture_heightmap, ofs).r;\n"
			else:
				code += "			depth = 1.0 - texture(texture_heightmap, ofs).r;\n"
			code += "			current_depth += layer_depth;\n"
			code += "		}\n"
			code += "		vec2 prev_ofs = ofs + delta;\n"
			code += "		float after_depth  = depth - current_depth;\n"
			if flags[BaseMaterial3D.FLAG_INVERT_HEIGHTMAP]:
				code += "		float before_depth = texture(texture_heightmap, prev_ofs).r - current_depth + layer_depth;\n"
			else:
				code += "		float before_depth = ( 1.0 - texture(texture_heightmap, prev_ofs).r  ) - current_depth + layer_depth;\n"
			code += "		float weight = after_depth / (after_depth - before_depth);\n"
			code += "		ofs = mix(ofs,prev_ofs,weight);\n"

		else:
			if flags[BaseMaterial3D.FLAG_INVERT_HEIGHTMAP]:
				code += "		float depth = texture(texture_heightmap, base_uv).r;\n"
			else:
				code += "		float depth = 1.0 - texture(texture_heightmap, base_uv).r;\n"
			code += "		vec2 ofs = base_uv - view_dir.xy * depth * heightmap_scale * 0.01;\n"

		code += "		base_uv=ofs;\n"
		if features[BaseMaterial3D.FEATURE_DETAIL] and detail_uv == BaseMaterial3D.DETAIL_UV_2:
			code += "		base_uv2-=ofs;\n"

		code += "	}\n"

	if albedo_tileset != null and albedo_tileset.has_tiles():
		var tile_stats = albedo_tileset.get_tiles_status()
		for tile_name in tile_stats.keys():
			if tile_stats[tile_name][0]:
				code += "	vec4 f_" + tile_name + " = map_to_udim_tile(" + tile_name + ",base_uv,vec2(" + str(tile_stats[tile_name][1][0].x) + "," + str(tile_stats[tile_name][1][0].y) + "),vec2(" + str(tile_stats[tile_name][1][1].x) + "," + str(tile_stats[tile_name][1][1].y) + "));\n"
			

		code += "	vec4 albedo_tex = "

		var valid_tiles = []
		for tile_name in tile_stats.keys():
			if tile_stats[tile_name][0]:
				valid_tiles.append("f_" + tile_name)
		
		code += "+".join(valid_tiles) + ";\n"

		# for tile_name in tile_stats.keys():
			
		# 	if tile_stats[tile_name][0]:
		# 		if tile_name == tile_stats.keys()[len(tile_stats.keys())-1]:
		# 			code += "		f_" + tile_name + ";\n"
		# 		else:
		# 			code += "		f_" + tile_name + " +\n"
		code += "	albedo_tex.a = 1.0;\n"
	
	if flags[BaseMaterial3D.FLAG_ALBEDO_TEXTURE_MSDF]:
		code += "	{\n";
		code += "		albedo_tex.rgb = mix(vec3(1.0 + 0.055) * pow(albedo_tex.rgb, vec3(1.0 / 2.4)) - vec3(0.055), vec3(12.92) * albedo_tex.rgb.rgb, lessThan(albedo_tex.rgb, vec3(0.0031308)));\n";
		code += "		vec2 msdf_size = vec2(msdf_pixel_range) / vec2(textureSize(texture_albedo, 0));\n";
		if flags[BaseMaterial3D.FLAG_USE_POINT_SIZE]:
			code += "		vec2 dest_size = vec2(1.0) / fwidth(POINT_COORD);\n";
		else:
			code += "		vec2 dest_size = vec2(1.0) / fwidth(base_uv);\n";
		
		code += "		float px_size = max(0.5 * dot(msdf_size, dest_size), 1.0);\n";
		code += "		float d = msdf_median(albedo_tex.r, albedo_tex.g, albedo_tex.b, albedo_tex.a) - 0.5;\n";
		code += "		if (msdf_outline_size > 0.0) {\n";
		code += "			float cr = clamp(msdf_outline_size, 0.0, msdf_pixel_range / 2.0) / msdf_pixel_range;\n";
		code += "			albedo_tex.a = clamp((d + cr) * px_size, 0.0, 1.0);\n";
		code += "		} else {\n";
		code += "			albedo_tex.a = clamp(d * px_size + 0.5, 0.0, 1.0);\n";
		code += "		}\n";
		code += "		albedo_tex.rgb = vec3(1.0);\n";
		code += "	}\n";

	elif flags[BaseMaterial3D.FLAG_ALBEDO_TEXTURE_FORCE_SRGB]:
		code += "	albedo_tex.rgb = mix(pow((albedo_tex.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)),vec3(2.4)),albedo_tex.rgb.rgb * (1.0 / 12.92),lessThan(albedo_tex.rgb,vec3(0.04045)));\n"

	if flags[BaseMaterial3D.FLAG_ALBEDO_FROM_VERTEX_COLOR]:
		code += "	albedo_tex *= COLOR;\n"
	
	if albedo_tileset != null and albedo_tileset.has_tiles():
		code += "	ALBEDO = albedo.rgb * albedo_tex.rgb;\n"
	else:
		code += "	ALBEDO = albedo.rgb;\n"


	code += "	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);\n";

	code += "	METALLIC = metallic_tex * metallic;\n";

	match roughness_texture_channel:
		BaseMaterial3D.TEXTURE_CHANNEL_RED:
			code += "	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);\n";
		BaseMaterial3D.TEXTURE_CHANNEL_GREEN:
			code += "	vec4 roughness_texture_channel = vec4(0.0,1.0,0.0,0.0);\n";
		BaseMaterial3D.TEXTURE_CHANNEL_BLUE:
			code += "	vec4 roughness_texture_channel = vec4(0.0,0.0,1.0,0.0);\n";
		BaseMaterial3D.TEXTURE_CHANNEL_ALPHA:
			code += "	vec4 roughness_texture_channel = vec4(0.0,0.0,0.0,1.0);\n";
		BaseMaterial3D.TEXTURE_CHANNEL_GRAYSCALE:
			code += "	vec4 roughness_texture_channel = vec4(0.333333,0.333333,0.333333,0.0);\n";


	code += "	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);\n";
	
	code += "	ROUGHNESS = roughness_tex * roughness;\n";
	code += "	SPECULAR = specular;\n";

	if features[BaseMaterial3D.FEATURE_NORMAL_MAPPING]:
		code += "	NORMAL_MAP = texture(texture_normal,base_uv).rgb;\n";
		code += "	NORMAL_MAP_DEPTH = normal_scale;\n";

	if features[BaseMaterial3D.FEATURE_EMISSION]:
		if flags[BaseMaterial3D.FLAG_EMISSION_ON_UV2]:
			code += "	vec3 emission_tex = texture(texture_emission,base_uv2).rgb;\n";
		else:
			code += "	vec3 emission_tex = texture(texture_emission,base_uv).rgb;\n";
		
		if emission_op == BaseMaterial3D.EMISSION_OP_ADD:
			code += "	EMISSION = (emission.rgb+emission_tex)*emission_energy;\n";
		else:
			code += "	EMISSION = (emission.rgb*emission_tex)*emission_energy;\n";

	if features[BaseMaterial3D.FEATURE_REFRACTION]:
		if features[BaseMaterial3D.FEATURE_NORMAL_MAPPING]:
			code += "	vec3 unpacked_normal = NORMAL_MAP;\n"
			code += "	unpacked_normal.xy = unpacked_normal.xy * 2.0 - 1.0;\n"
			code += "	unpacked_normal.z = sqrt(max(0.0, 1.0 - dot(unpacked_normal.xy, unpacked_normal.xy)));\n"
			code += "	vec3 ref_normal = normalize( mix(NORMAL,TANGENT * unpacked_normal.x + BINORMAL * unpacked_normal.y + NORMAL * unpacked_normal.z,NORMAL_MAP_DEPTH) );\n"
		else:
			code += "	vec3 ref_normal = NORMAL;\n"
		

		code += "	vec2 ref_ofs = SCREEN_UV - ref_normal.xy * dot(texture(texture_refraction,base_uv),refraction_texture_channel) * refraction;\n"
		
		code += "	float ref_amount = 1.0 - albedo.a * albedo_tex.a;\n"
		code += "	EMISSION += textureLod(screen_texture,ref_ofs,ROUGHNESS * 8.0).rgb * ref_amount * EXPOSURE;\n"
		code += "	ALBEDO *= 1.0 - ref_amount;\n"
		code += "	ALPHA = 1.0;\n"

	elif transparency != BaseMaterial3D.TRANSPARENCY_DISABLED or flags[BaseMaterial3D.FLAG_USE_SHADOW_TO_OPACITY] or (distance_fade == BaseMaterial3D.DISTANCE_FADE_PIXEL_ALPHA) or proximity_fade_enabled:
		code += "	ALPHA *= albedo.a * albedo_tex.a;\n"

	if transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_HASH:
		code += "	ALPHA_HASH_SCALE = alpha_hash_scale;\n"
	elif transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR:
		code += "	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;\n"

	if alpha_antialiasing_mode != BaseMaterial3D.ALPHA_ANTIALIASING_OFF and (transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_HASH or transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR):
		code += "	ALPHA_ANTIALIASING_EDGE = alpha_antialiasing_edge;\n"
		code += "	ALPHA_TEXTURE_COORDINATE = UV * vec2(albedo_texture_size);\n"

	if proximity_fade_enabled:
		code += "	float depth_tex = textureLod(depth_texture,SCREEN_UV,0.0).r;\n"
		code += "	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV*2.0-1.0,depth_tex,1.0);\n"
		code += "	world_pos.xyz/=world_pos.w;\n"
		code += "	ALPHA*=clamp(1.0-smoothstep(world_pos.z+proximity_fade_distance,world_pos.z,VERTEX.z),0.0,1.0);\n"

	if distance_fade != BaseMaterial3D.DISTANCE_FADE_DISABLED:
		if distance_fade == BaseMaterial3D.DISTANCE_FADE_OBJECT_DITHER or distance_fade == BaseMaterial3D.DISTANCE_FADE_PIXEL_DITHER:
			code += "	{\n"
			if distance_fade == BaseMaterial3D.DISTANCE_FADE_OBJECT_DITHER:
				code += "		float fade_distance = length((VIEW_MATRIX * MODEL_MATRIX[3]));\n"
			else:
				code += "		float fade_distance = length(VERTEX);\n"
			code += "		const vec3 magic = vec3(0.06711056f, 0.00583715f, 52.9829189f);"
			code += "		float fade = clamp(smoothstep(distance_fade_min, distance_fade_max, fade_distance), 0.0, 1.0);\n"
			code += "		if (fade < 0.001 || fade < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {\n"
			code += "			discard;\n"
			code += "		}\n"
			code += "	}\n\n"
		else:
			code += "	ALPHA *= clamp(smoothstep(distance_fade_min, distance_fade_max, length(VERTEX)), 0.0, 1.0);\n"

	if features[BaseMaterial3D.FEATURE_RIM]:
		code += "	vec2 rim_tex = texture(texture_rim,base_uv).xy;\n";
		code += "	RIM = rim*rim_tex.x;"
		code += "	RIM_TINT = rim_tint*rim_tex.y;\n"

	if features[BaseMaterial3D.FEATURE_CLEARCOAT]:
		code += "	vec2 clearcoat_tex = texture(texture_clearcoat,base_uv).xy;\n";
		code += "	CLEARCOAT = clearcoat*clearcoat_tex.x;"
		code += "	CLEARCOAT_ROUGHNESS = clearcoat_roughness*clearcoat_tex.y;\n"

	if features[BaseMaterial3D.FEATURE_ANISOTROPY]:
		code += "	vec3 anisotropy_tex = texture(texture_flowmap,base_uv).rga;\n";
		code += "	ANISOTROPY = anisotropy_ratio*anisotropy_tex.b;\n"
		code += "	ANISOTROPY_FLOW = anisotropy_tex.rg*2.0-1.0;\n"

	if features[BaseMaterial3D.FEATURE_AMBIENT_OCCLUSION]:
		if flags[BaseMaterial3D.FLAG_AO_ON_UV2]:
			code += "	AO = dot(texture(texture_ambient_occlusion,base_uv2),ao_texture_channel);\n";
		else:
			code += "	AO = dot(texture(texture_ambient_occlusion,base_uv),ao_texture_channel);\n";
		
		code += "	AO_LIGHT_AFFECT = ao_light_affect;\n";


	if features[BaseMaterial3D.FEATURE_SUBSURFACE_SCATTERING]:
		code += "	float sss_tex = texture(texture_subsurface_scattering,base_uv).r;\n";
		code += "	SSS_STRENGTH=subsurface_scattering_strength*sss_tex;\n";

	if features[BaseMaterial3D.FEATURE_SUBSURFACE_TRANSMITTANCE]:
		code += "	vec4 trans_color_tex = texture(texture_subsurface_transmittance,base_uv);\n";
	
		code += "	SSS_TRANSMITTANCE_COLOR=transmittance_color*trans_color_tex;\n";

		code += "	SSS_TRANSMITTANCE_DEPTH=transmittance_depth;\n";
		code += "	SSS_TRANSMITTANCE_BOOST=transmittance_boost;\n";

	if features[BaseMaterial3D.FEATURE_BACKLIGHT]:
		code += "	vec3 backlight_tex = texture(texture_backlight,base_uv).rgb;\n";
		code += "	BACKLIGHT = (backlight.rgb+backlight_tex);\n";


	if features[BaseMaterial3D.FEATURE_DETAIL]:

		var det_uv = "base_uv" if detail_uv == BaseMaterial3D.DETAIL_UV_1 else "base_uv2"
		code += "	vec4 detail_tex = texture(texture_detail_albedo," + det_uv + ");\n"
		code += "	vec4 detail_norm_tex = texture(texture_detail_normal," + det_uv + ");\n"


		code += "	vec4 detail_mask_tex = texture(texture_detail_mask,base_uv);\n"

		match detail_blend_mode:
			BaseMaterial3D.BLEND_MODE_MIX:
				code += "	vec3 detail = mix(ALBEDO.rgb,detail_tex.rgb,detail_tex.a);\n"
			BaseMaterial3D.BLEND_MODE_ADD:
				code += "	vec3 detail = mix(ALBEDO.rgb,ALBEDO.rgb+detail_tex.rgb,detail_tex.a);\n"
			BaseMaterial3D.BLEND_MODE_SUB:
				code += "	vec3 detail = mix(ALBEDO.rgb,ALBEDO.rgb-detail_tex.rgb,detail_tex.a);\n"
			BaseMaterial3D.BLEND_MODE_MUL:
				code += "	vec3 detail = mix(ALBEDO.rgb,ALBEDO.rgb*detail_tex.rgb,detail_tex.a);\n"
		
		code += "	vec3 detail_norm = mix(NORMAL_MAP,detail_norm_tex.rgb,detail_tex.a);\n"
		code += "	NORMAL_MAP = mix(NORMAL_MAP,detail_norm,detail_mask_tex.r);\n"
		code += "	ALBEDO.rgb = mix(ALBEDO.rgb,detail,detail_mask_tex.r);\n"

	code += "}\n"

	var new_shader = Shader.new()
	new_shader.code = code
	
	# print(new_shader.get_mode())
	
	shader = new_shader
	# print(code)
	_update_shader_params()
