shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform float specular;

uniform sampler2D t1001 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1002 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1003 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1004 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1005 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1006 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1007 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1008 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1009 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1010 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1011 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1012 : source_color,filter_nearest,repeat_enable;
uniform sampler2D t1013 : source_color,filter_nearest,repeat_enable;
//uniform sampler2D t1014 : source_color,filter_nearest,repeat_enable;
//uniform sampler2D t1015 : source_color,filter_nearest,repeat_enable;
//uniform sampler2D t1016 : source_color,filter_nearest,repeat_enable;
//uniform sampler2D t1017 : source_color,filter_nearest,repeat_enable;
//uniform sampler2D t1018 : source_color,filter_nearest,repeat_enable;
//uniform sampler2D t1019 : source_color,filter_nearest,repeat_enable;
//uniform sampler2D t1020 : source_color,filter_nearest,repeat_enable;

uniform sampler2DArray testarr : source_color,filter_nearest,repeat_enable;

void vertex() {
	UV=UV;
	COLOR = COLOR;
}

vec3 map_to_udim_tile(sampler2D sampler, vec2 uv, vec2 x_thresholds, vec2 y_thresholds) {
	bvec2 ltx = lessThan(vec2(uv.x,uv.x), x_thresholds);
	bvec2 gtx = greaterThan(vec2(uv.x,uv.x), x_thresholds);

	bvec2 lty = lessThan(vec2(uv.y,uv.y), y_thresholds);
	bvec2 gty = greaterThan(vec2(uv.y,uv.y), y_thresholds);

	vec4 f_tex0x = texture(sampler,uv) * float((int(ltx.y) * int(gtx.x)) * (int(lty.y) * int(gty.x)));
	return f_tex0x.rgb;
}

void fragment() {
	ALBEDO = vec3(0.5,0,0);
	vec3 f_tex1001 = map_to_udim_tile(t1001,UV,vec2(0,1),vec2(0,1));
	vec3 f_tex1002 = map_to_udim_tile(t1002,UV,vec2(1,2),vec2(0,1));
	vec3 f_tex1003 = map_to_udim_tile(t1003,UV,vec2(2,3),vec2(0,1));
	vec3 f_tex1004 = map_to_udim_tile(t1004,UV,vec2(3,4),vec2(0,1));
	vec3 f_tex1005 = map_to_udim_tile(t1005,UV,vec2(4,5),vec2(0,1));
	vec3 f_tex1006 = map_to_udim_tile(t1006,UV,vec2(5,6),vec2(0,1));
	vec3 f_tex1007 = map_to_udim_tile(t1007,UV,vec2(6,7),vec2(0,1));
	vec3 f_tex1008 = map_to_udim_tile(t1008,UV,vec2(7,8),vec2(0,1));
	vec3 f_tex1009 = map_to_udim_tile(t1009,UV,vec2(8,9),vec2(0,1));
	vec3 f_tex1010 = map_to_udim_tile(t1010,UV,vec2(9,10),vec2(0,1));
	vec3 f_tex1011 = map_to_udim_tile(t1011,UV,vec2(0,1),vec2(-1,0));
	vec3 f_tex1012 = map_to_udim_tile(t1012,UV,vec2(1,2),vec2(-1,0));
	vec3 f_tex1013 = map_to_udim_tile(t1013,UV,vec2(2,3),vec2(-1,0));
	
	vec3 final_texture =
		f_tex1001 + 
		f_tex1002 +
		f_tex1003 +
		f_tex1004 +
		f_tex1005 +
		f_tex1006 +
		f_tex1007 +
		f_tex1008 +
		f_tex1009 +
		f_tex1010 + 
		f_tex1011 + 
		f_tex1012 +
		f_tex1013;
	
	
	
	ALBEDO = final_texture;
	SPECULAR = specular;
}