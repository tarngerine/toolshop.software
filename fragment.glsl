// Based on https://thebookofshaders.com/edit.php#11/splatter.frag
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 random2(vec2 st) {
  st = vec2(dot(st, vec2(127.1, 311.7)), dot(st, vec2(269.5, 183.3)));
  return -1.0 + 2.0 * fract(sin(st) * 43758.5453123);
}

// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/XdXGW8
float noise(vec2 st) {
  vec2 i = floor(st);
  vec2 f = fract(st);

  vec2 u = f * f * (3.0 - 2.0 * f);

  return mix(mix(dot(random2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                 dot(random2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
             mix(dot(random2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                 dot(random2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x),
             u.y);
}

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  st.x *= u_resolution.x / u_resolution.y;
  vec3 color = vec3(0.0);

  float t = 1.0;
  // Uncomment to animate
  t = abs(1.0 - sin(u_time * .1)) * 5.;
  st += noise(st * 2.) * t; // Animate the coordinate space
  color = vec3(1.000, 0.048, 0.000) *
          smoothstep(1.040, .5, noise(st * fract(u_time * .2 + 399.)));
  color += vec3(0.586, 1.000, 0.268) *
           smoothstep(0.510, .2, noise(st * abs(u_time * .4 + 1000.)));
  gl_FragColor = mix(
      vec4(color, 1.0),
      vec4(cos(u_time * .5) * st.x, cos(u_time * .3) * st.y, 1., 1.000), 0.5);
}
