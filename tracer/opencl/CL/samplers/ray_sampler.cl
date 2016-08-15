#ifndef RAY_SAMPLER_CL
#define RAY_SAMPLER_CL

// All samplers in this file are based on the formulas from the 
// GI compedium (https://people.cs.kuleuven.be/~philip.dutre/GI)

float3 rayGetCosWeightedHemisphereSample(float3 normal, float2 randSample);
float3 rayGetGGXSample(float3 h, float a, float2 randSample);

// Generate normalized direction in the hemisphere around the given normal 
// using a cos weighted distribution
// 
// PDF = cos(theta) / pi
float3 rayGetCosWeightedHemisphereSample(float3 normal, float2 randSample) {
	// Generate point on disk
	float rd = sqrt(randSample.x);
	float phi = C_TWO_TIMES_PI*randSample.y;

	// Generate tangent, bi-tangent vectors
	float3 u = normalize(cross((fabs(normal.x) > .1f ? (float3)(0.0f, 1.0f, 0.0f) : (float3)(1.0f, 0.0f, 0.0f)), normal));
	float3 v = cross(normal,u);

	// Project disk point to unit hemisphere and rotate so that the normal points up
	return normalize(u * rd * native_cos(phi) + v * rd * native_sin(phi) + normal * native_sqrt(1 - randSample.x));
}

// Sample the GGX microfacet distribution.
float3 rayGetGGXSample(float3 n, float a, float2 randSample){

	// Generate tangent, bi-tangent vectors
	float3 u = normalize(cross((fabs(n.x) > .1f ? (float3)(0.0f, 1.0f, 0.0f) : (float3)(1.0f, 0.0f, 0.0f)), n));
	float3 v = cross(n,u);

	float phi = C_TWO_TIMES_PI * randSample.x;
	float cosTheta = native_sqrt( (1.0f - randSample.y) / ( 1.0f + (a*a - 1.0f) * randSample.y ) );
	float sinTheta = native_sqrt( 1 - cosTheta * cosTheta );

    // Project and rotate
    return normalize(u * sinTheta * native_cos(phi) + v * sinTheta * native_sin(phi) + n * cosTheta);
}
#endif
