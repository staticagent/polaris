// Global parameters that will be set via a template during compilation time.
__constant unsigned int frameW = 512;
__constant unsigned int frameH = 512;
__constant float texelStepX = 1.0 / 512.0;
__constant float texelStepY = 1.0 / 512.0;

// Emit the color of a pixel by tracing a ray through the scene.
__kernel void tracePixel(
		__global float4 *frameBuffer,
		__global float4 *frustrumCorners,
		const unsigned int blockY,
		const unsigned int samplesPerPixel,
		const float exposure
){
	// Get pixel coordinates
	unsigned int x = get_global_id(0);
	unsigned int y = get_global_id(1);
	if ( x > frameW || y > frameH ) {
		return;
	}

	// Just interpolate the x,y coordinates
	float tx = (float)(x) * texelStepX;
	float ty = (float)(y) * texelStepY;
	frameBuffer[y * frameW + x] = (float4)(tx, ty, 0, 0.0);
}
