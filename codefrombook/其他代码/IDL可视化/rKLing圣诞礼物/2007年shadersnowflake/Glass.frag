/*
 * This is essentially the nVidia example shader, the only difference is
 * we can't use cube mapping (IDL doesn't support it), so we read from 
 * an equirectangular texture map (see section 10.5 in the orange book).
 */ 

const vec3 Xunitvec = vec3 (1.0, 0.0, 0.0);
const vec3 Yunitvec = vec3 (0.0, 1.0, 0.0);

// inputs
varying vec3 normal;
varying vec3 incident;

// uniform inputs
uniform vec3 etaValues;
uniform vec3 fresnelValues;
uniform sampler2D environmentMap;

// glsl implementation of refract function from Cg stdlib
vec3 refract(vec3 i, vec3 n, float eta)
{
    float cosi = dot(-i, n);
    float cost2 = 1.0 - eta * eta * (1.0 - cosi*cosi);
    vec3 t = eta*i + ((eta*cosi - sqrt(abs(cost2))) * n);
    return t * vec3(cost2 > 0.0);
}

// fresnel approximation
float fast_fresnel(vec3 I, vec3 N, vec3 fresnelValues)
{
    float power = fresnelValues.x;
    float scale = fresnelValues.y;
    float bias = fresnelValues.z;

    return bias + pow(1.0 - dot(I, N), power) * scale;
}

vec3 textureEnvmap(sampler2D tex, vec3 dir) {
    // Compute altitude and azimuth angles
    vec2 index;

    index.y = dot(normalize(dir), Yunitvec);
    dir.y = 0.0;
    index.x = dot(normalize(dir), Xunitvec) * 0.5;

    // Translate index values into proper range
    if (dir.z >= 0.0)
        index = (index + 1.0) * 0.5;
    else
    {
        index.t = (index.t + 1.0) * 0.5;
        index.s = (-index.s) * 0.5 + 1.0;
	if (index.s > 1.0)
	    index.s -= 1.0;
    }
      
    // Do the lookup into the environment map.
    return vec3(texture2D(tex, index));
}

void main()
{
    // normalize incoming vectors
    vec3 normalVec = normalize(normal);
    vec3 incidentVec = normalize(incident);

    vec3 refractColor;

    // calculate refract color for each color channel
    refractColor.r = textureEnvmap(environmentMap, refract(incidentVec, normalVec, etaValues.x)).r;
    refractColor.g = textureEnvmap(environmentMap, refract(incidentVec, normalVec, etaValues.y)).g;
    refractColor.b = textureEnvmap(environmentMap, refract(incidentVec, normalVec, etaValues.z)).b;

    // fetch reflection from environment map
    vec3 reflectColor = textureEnvmap(environmentMap, reflect(incidentVec, normalVec)).rgb;

    vec3 fresnelTerm = vec3(fast_fresnel(-incidentVec, normalVec, fresnelValues));
    gl_FragColor = vec4(mix(refractColor, reflectColor, fresnelTerm), 1.0);
}
