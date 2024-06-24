shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_normal : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_noise : source_color,filter_linear_mipmap,repeat_enable;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform float wiggle_speed : hint_range(0.00, 1.0, 0.01) = 0.25;
uniform float wiggle_size : hint_range(0.0, 100.0, 0.01) = 10.0;
uniform float wiggle_scalar : hint_range(1.0, 10.0, 0.1) = 1.0;

float height(vec2 position, float time) {
  vec2 offset = wiggle_size * cos(position + time * wiggle_speed);
  return texture(texture_noise, (position / 10.0) - offset).x;
}

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	VERTEX.y += height(VERTEX.xz, TIME) * wiggle_scalar;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	NORMAL_MAP = texture(texture_normal, base_uv).rgb;
	ALPHA *= albedo.a * albedo_tex.a;
	ALPHA_SCISSOR_THRESHOLD = 0.25;
}
