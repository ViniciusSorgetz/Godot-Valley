shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0);
uniform vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {

}

void fragment() {

	vec4 original_color = texture(TEXTURE, UV);
	COLOR = mix(original_color, color, progress);
	COLOR.a = original_color.a;
}
