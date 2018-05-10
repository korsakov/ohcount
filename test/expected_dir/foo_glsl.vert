glsl	comment	// from OGRE3D's skinningTwoWeightsShadowCasterVp.glsl
glsl	comment	// Example GLSL program for skinning with two bone weights per vertex
glsl	blank	
glsl	code	attribute vec4 vertex;
glsl	code	attribute vec4 uv0;
glsl	code	attribute vec4 blendIndices;
glsl	code	attribute vec4 blendWeights;
glsl	blank	
glsl	comment	// 3x4 matrix, passed as vec4's for compatibility with GL 2.0
glsl	comment	// GL 2.0 supports 3x4 matrices
glsl	comment	// Support 24 bones ie 24*3, but use 72 since our parser can pick that out for sizing
glsl	code	uniform vec4 worldMatrix3x4Array[72];
glsl	code	uniform mat4 viewProjectionMatrix;
glsl	code	uniform vec4 ambient;
glsl	blank	
glsl	code	void main()
glsl	code	{
glsl	code		vec3 blendPos = vec3(0,0,0);
glsl	blank	
glsl	code		for (int bone = 0; bone < 2; ++bone)
glsl	code		{
glsl	comment			// perform matrix multiplication manually since no 3x4 matrices
glsl	comment	        // ATI GLSL compiler can't handle indexing an array within an array so calculate the inner index first
glsl	code		    int idx = int(blendIndices[bone]) * 3;
glsl	comment	        // ATI GLSL compiler can't handle unrolling the loop so do it manually
glsl	comment	        // ATI GLSL has better performance when mat4 is used rather than using individual dot product
glsl	comment	        // There is a bug in ATI mat4 constructor (Cat 7.2) when indexed uniform array elements are used as vec4 parameter so manually assign
glsl	code			mat4 worldMatrix;
glsl	code			worldMatrix[0] = worldMatrix3x4Array[idx];
glsl	code			worldMatrix[1] = worldMatrix3x4Array[idx + 1];
glsl	code			worldMatrix[2] = worldMatrix3x4Array[idx + 2];
glsl	code			worldMatrix[3] = vec4(0);
glsl	comment			// now weight this into final 
glsl	code			blendPos += (vertex * worldMatrix).xyz * blendWeights[bone];
glsl	code		}
glsl	blank	
glsl	comment		// apply view / projection to position
glsl	code		gl_Position = viewProjectionMatrix * vec4(blendPos, 1);
glsl	blank	
glsl	code		gl_FrontSecondaryColor = vec4(0,0,0,0);
glsl	code		gl_FrontColor = ambient;
glsl	code		gl_TexCoord[0] = uv0;
glsl	code	}
