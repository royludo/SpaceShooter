shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.b *= 1.5;
	color.r /= 3.0;
	color.g /= 2.0;
	COLOR = color;
}