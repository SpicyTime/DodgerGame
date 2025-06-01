shader_type canvas_item;

uniform bool effect_enabled = false;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	vec3 flash_color = vec3(1.0, 0.0, 0.0);
	if(effect_enabled){
		vec3 final_color = mix(tex_color.rgb, flash_color, 0.5);
		COLOR = vec4(final_color, tex_color.a);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
