shader_type canvas_item;

uniform float x = 0;
uniform float y = 0;

void vertex() {
	UV.x += TIME * x;
	UV.y += TIME * y;
}
