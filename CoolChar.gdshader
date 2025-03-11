shader_type canvas_item;

// Base "llight"
uniform vec4 base_neon: source_color;
uniform float cycle_length = 1.0;
uniform float min_intensity = 0.5;
uniform float max_intensity = 1.0;

// Pattern stuff
uniform sampler2D stars: filter_linear_mipmap_anisotropic, repeat_enable;
uniform vec4 stars_adjust: source_color;
uniform float stars_ratio = 500.0;
uniform float stars_speed = 0.0;
uniform float stars_intensity = 0.75;
uniform float rot_offset_angle = 0.0; // In radians

// Gradient
uniform sampler2D gradient;

// CRT stuff
uniform float scanline_intensity = 1.0;
uniform float color_bleed_weight: hint_range(0.0, 1.0) = 0.35;
uniform float scanline_quantity = 50.0;
uniform int crt_line_ratio = 4;

// Close to original warm cyan: 28989c
// Colour I was using: 286e9c

// Helper math function
float float_mix(float min_value, float max_value, float interpolate_value) {
	float difference = max_value - min_value;
	return min_value + difference*interpolate_value;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

// I took this from a online shader and modified. Currently unused, not the best,
// as all it does is just add black lines
void add_scanlines(inout vec4 color, in vec2 uv, in vec2 xy_ratio) {
	// Darken top halves of pixels
	float colour_dark_offset = 0.0;
	int y_pos = int(floor(uv.y * xy_ratio.y * float(crt_line_ratio)));
	if (int(floor((float(y_pos) / float(crt_line_ratio)))) * crt_line_ratio == y_pos)
		colour_dark_offset = scanline_intensity;

	color.rgb *= (1.0 - color_bleed_weight) - colour_dark_offset;
}

void fragment() {
 	if (length(COLOR.rgb) > 0.2) {
		// Reset our colour to black to make pattern adding easier.
		// You'll probably want to delete this.
		COLOR.rgb = vec3(0.0,0.0,0.0);

		// These rotation matrices rotated the star image I had, which made it look
		// less repetitive
		mat2 rot_offset = mat2(
			vec2(cos(rot_offset_angle), -sin(rot_offset_angle)),
			vec2(sin(rot_offset_angle), cos(rot_offset_angle))
		);
		mat2 rot_offset_2 = mat2(
			vec2(cos(-rot_offset_angle), -sin(-rot_offset_angle)),
			vec2(sin(-rot_offset_angle), cos(-rot_offset_angle))
		);

		// Good luck with the math :3
		vec4 stars_color = texture(stars, (rot_offset*(VERTEX + vec2(0, stars_speed*stars_ratio*TIME)))/stars_ratio);
		vec3 stars_add = stars_color.rgb*(stars_color.rgb*stars_color.a)*stars_intensity;
		COLOR.rgb = (stars_adjust * vec4(stars_add, 1.0)).rgb;

		// Second pattern adder to achieve a mock paralax effect
		//vec4 stars_color_2 = texture(stars, (VERTEX + vec2(0, 2.0*stars_speed*stars_ratio*TIME))/(stars_ratio));
		//vec4 stars_color_2 = texture(stars, rot_offset_2*(VERTEX + (vec2(0, 0.5*stars_speed*stars_ratio*TIME)))/(5.0*stars_ratio));
		//vec3 stars_add_2 =  stars_color_2.rgb*stars_color_2.a*stars_intensity;
		//COLOR.rgb += stars_add_2;

		// Now add our base colour. (don't read if you want to figure it out on your own: change it to *= )
		COLOR.rgb += base_neon.rgb;

		// Add gradient
		vec4 gradient_colour = texture(gradient, UV);
		vec3 gradient_add = gradient_colour.rgb * gradient_colour.a;
		COLOR.rgb += gradient_add;

		// Scanlines, uncomment to add again
		//add_scanlines(COLOR, UV, vec2(scanline_quantity));

		// Apply the phase adjustment
		float multiplier = 0.0;
		float rads_to_revs = 1.0 / TAU;
		float revs_to_rads = TAU;
		float phase = (sin((1.0/cycle_length)*TIME*revs_to_rads) + 1.0)/2.0;
		COLOR.rgb *= float_mix(min_intensity, max_intensity, phase);

	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
