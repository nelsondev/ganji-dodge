shader_type spatial;

uniform vec4 tint_color : source_color = vec4(0.443137, 0.368627, 1.000000, 0.611765);
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap_anisotropic, repeat_disable;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 pixel_size = vec2(0.2);
	float blurriness = 0.1;
	int iterations = 10;
	int quality = 50;
	float pi = 6.25;

	vec2 radius = blurriness / (1.0 / pixel_size).xy;
	vec4 blurred_tex = texture(screen_texture, uv);

	for(float d = 0.0; d < pi; d += pi / float(iterations)){
		for( float i = 1.0 / float(quality); i <= 1.0; i += 1.0 / float(quality) ){
			vec2 directions = uv + vec2(cos(d), sin(d)) * radius * i;
			blurred_tex += texture(screen_texture, directions);
		}
	}
	blurred_tex /= float(quality) * float(iterations) + 1.0;
	blurred_tex += tint_color;

	ALBEDO = blurred_tex.rgb;
}