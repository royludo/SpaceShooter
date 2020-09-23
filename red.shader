shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.r *= 1.2;
	color.b /= 2.0;
	color.g /= 2.0;
	COLOR = color;
}