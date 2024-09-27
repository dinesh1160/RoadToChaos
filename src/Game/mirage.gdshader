shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture,filter_linear_mipmap;
// Animate from 0 to 1, result in 0 should be the same as in 1, a loop
uniform float progress: hint_range(0.0, 1.0) = 0.0;

// How jagged each band of melting pixels are
// This is also the amplitude of the wave
uniform float meltness: hint_range(0.0, 3.0) = 1.0;

// If it should affect only lower parts of the shader, it also increases the meltness
uniform float how_low: hint_range(0.0, 5.0) = 1.0;

// How wavy. 
uniform float wave_frequency: hint_range(0.0, 30.0) = 20.0;

float wave(float x) {
	return x - 2.5 + cos(2.0 * PI * progress + wave_frequency * x);
}

void fragment() {
	vec2 uv = UV;
	vec4 bg = texture(SCREEN_TEXTURE,SCREEN_UV);
	uv.y -= pow( uv.y,how_low ) * 0.02 * meltness * wave( UV.x - mod( UV.x, TEXTURE_PIXEL_SIZE.x ));
	
	COLOR = texture(TEXTURE, uv);
	
	// "delete" pixels out of range
	if (uv.y <= 0.0 || uv.y >= 1.0) {
		COLOR.a = 0.0;
	}
}