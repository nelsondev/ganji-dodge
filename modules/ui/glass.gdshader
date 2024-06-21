shader_type spatial;

uniform vec4 tint_color : source_color = vec4(0.443137, 0.368627, 1.000000, 0.611765);
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest_mipmap_anisotropic, repeat_disable;

void fragment() {
	int iter = 20;
	float adjust = 4000.0;
	vec2 uv = round(SCREEN_UV * 166.0) / 166.0;
	vec4 result = texture(screen_texture, uv);
	
	for (int i = 0; i < iter; i++) {
		result += textureLod(screen_texture, vec2(uv.x, uv.y + float(iter) / adjust), 2.0);
		result += textureLod(screen_texture, vec2(uv.x, uv.y - float(iter) / adjust), 2.0);
		result += textureLod(screen_texture, vec2(uv.x + float(iter) / adjust, uv.y), 2.0);
		result += textureLod(screen_texture, vec2(uv.x - float(iter) / adjust, uv.y), 2.0);
	}
	
	result /= float(iter) * 3.0;
	result *= tint_color;
	
	ALBEDO = result.rgb;
}