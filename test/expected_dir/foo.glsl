glsl	comment	// GLSL vertex shader
glsl	code	void main() {
glsl	code		gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
glsl	code	}