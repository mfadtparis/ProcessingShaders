#ifdef GL_ES
precision mediump float;
#endif

// shorter version --novalis

uniform float time;
uniform vec2 resolution;

void main(void) {
	vec2 p = gl_FragCoord.xy/resolution.xx*2.-vec2(1.,.5);
	gl_FragColor = length(p)*vec4(vec3((mod(.3/length(p)+time*.1,.1)>cos(time+p.x)*0.05+0.05)^^(mod(atan(p.y,p.x)*7./22.+time*.1,.1)>sin(time+p.y)*0.05+0.05)),1.)*.4;
}