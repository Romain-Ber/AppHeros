#ifdef GL_ES
precision mediump float;
#endif

#define TAU 6.28318530718

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 hash( vec2 x )
{
    const vec2 k = vec2( 0.3183099, 0.3678794 );
    x = x*k + k.yx;
    return -1.0 + 2.0*fract( 16.0 * k*fract( x.x*x.y*(x.x+x.y)) );
}

float noise( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );
	
	vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( hash( i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ), 
                     dot( hash( i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( hash( i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ), 
                     dot( hash( i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

// -----------------------------------------------




void main() {
    // Normalize screen coordinates
    //vec2 uv = gl_FragCoord.xy / u_resolution;
    float sineValue = sin(u_time * 0.1);
    float scaledValue = sineValue * 0.5; // Scale to range from -0.5 to 0.5
    float clampedValue = clamp(scaledValue, -0.5, 0.5);
    vec2 dir = vec2(clampedValue, 1) * 8.0;
    //vec2 dir = vec2(sin(u_time * 0.1), 1) * 8.0;
    vec2 coord = gl_FragCoord.xy;
    vec2 scale = vec2(3.0, 3.0);
    vec2 q = (ceil(coord / scale) + ceil(dir * (u_time * 2.0) + 5.0)) * scale;
    vec2 p = q / (u_resolution.xy * 10.0);
    p = fract(p);

    vec2 uv = p*vec2(u_resolution.x/u_resolution.y,1.0);

    float f = 0.0;

    uv *= 10.0;
    mat2 m = mat2( 1.6,  1.2, -1.2,  1.6 );
    f  = 0.5000*noise( uv ); uv = m*uv;
    f += 0.2500*noise( uv ); uv = m*uv;
    f += 0.1250*noise( uv ); uv = m*uv;
    f += 0.0625*noise( uv ); uv = m*uv;
	

	f = (f + 0.1) * 1.0 + 0.1;
	
    //f *= smoothstep( 0.0, 0.005, abs(p.x-0.6) );	
	
	gl_FragColor = vec4( f, f, f, 1.0 );
    //vec2 uv = gl_FragCoord.xy / u_resolution.xy;
     //vec3 p = vec3(uv, u_time*speed);
    //float time = u_time / 4.;
    // Create time variable

   
    
    // Render
    //gl_FragColor = vec4(1.0,0.0,1.0,1.0);
}