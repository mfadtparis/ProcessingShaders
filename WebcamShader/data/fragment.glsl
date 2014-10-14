#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float contrast;
uniform float brightness;

uniform bool invert;
uniform bool adjust;
uniform bool bw;

uniform bool colorFilter;
uniform float minRed;
uniform float maxRed;
uniform float minGreen;
uniform float maxGreen;
uniform float minBlue;
uniform float maxBlue;

uniform float pixelSize;
uniform bool pixelate;

uniform bool hFlip;
uniform bool vFlip;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

uniform bool emboss;
uniform bool edge;

vec4 emboss(vec2 coords) {
  vec2 tc0 = coords + vec2(-texOffset.s, -texOffset.t);
  vec2 tc1 = coords + vec2(         0.0, -texOffset.t);
  vec2 tc2 = coords + vec2(-texOffset.s,          0.0);
  vec2 tc3 = coords + vec2(+texOffset.s,          0.0);
  vec2 tc4 = coords + vec2(         0.0, +texOffset.t);
  vec2 tc5 = coords + vec2(+texOffset.s, +texOffset.t);
  
  vec4 col0 = texture2D(texture, tc0);
  vec4 col1 = texture2D(texture, tc1);
  vec4 col2 = texture2D(texture, tc2);
  vec4 col3 = texture2D(texture, tc3);
  vec4 col4 = texture2D(texture, tc4);
  vec4 col5 = texture2D(texture, tc5);

  vec4 sum = vec4(0.5) + (col0 + col1 + col2) - (col3 + col4 + col5);
  float lum = dot(sum, lumcoeff);

  return vec4(lum, lum, lum, 1.0) * vertColor;  
}


vec4 edge(vec2 coords) {
  vec2 tc0 = coords + vec2(-texOffset.s, -texOffset.t);
  vec2 tc1 = coords + vec2(         0.0, -texOffset.t);
  vec2 tc2 = coords + vec2(+texOffset.s, -texOffset.t);
  vec2 tc3 = coords + vec2(-texOffset.s,          0.0);
  vec2 tc4 = coords + vec2(         0.0,          0.0);
  vec2 tc5 = coords + vec2(+texOffset.s,          0.0);
  vec2 tc6 = coords + vec2(-texOffset.s, +texOffset.t);
  vec2 tc7 = coords + vec2(         0.0, +texOffset.t);
  vec2 tc8 = coords + vec2(+texOffset.s, +texOffset.t);
  
  vec4 col0 = texture2D(texture, tc0);
  vec4 col1 = texture2D(texture, tc1);
  vec4 col2 = texture2D(texture, tc2);
  vec4 col3 = texture2D(texture, tc3);
  vec4 col4 = texture2D(texture, tc4);
  vec4 col5 = texture2D(texture, tc5);
  vec4 col6 = texture2D(texture, tc6);
  vec4 col7 = texture2D(texture, tc7);
  vec4 col8 = texture2D(texture, tc8);

  vec4 sum = 8.0 * col4 - (col0 + col1 + col2 + col3 + col5 + col6 + col7 + col8); 
  return vec4(sum.rgb, 1.0) * vertColor; 
}

vec4 adjust(vec4 pixelColor, float contrast, float brightness) {
        return mix(pixelColor * brightness, mix(lumcoeff, pixelColor, contrast), .5);
}

vec4 bw(vec4 pixelColor) {
  float lum = dot(pixelColor, lumcoeff);
  if (lum > .5) {
    return vec4(1.);
  }
  return vec4(0, 0, 0, 1);
}

vec4 invert(vec4 pixelColor) {
  return vec4(vec3(1.) - pixelColor.rgb, 1.);
}

// If red value is below or above a the limit, then make the color transparent
vec4 red(vec4 pixelColor) {
  if (pixelColor.r > minRed && pixelColor.r < maxRed) {
    return pixelColor;
  }
  return vec4(0.);
}

// If green value is below or above the limit, then make the color transparent
vec4 green(vec4 pixelColor) {
  if (pixelColor.g > minGreen && pixelColor.g < maxGreen) {
    return pixelColor;
  }
  return vec4(0.);
}

// If blue value is below or above the limit, then make the color transparent
vec4 blue(vec4 pixelColor) {
  if (pixelColor.b > minBlue && pixelColor.b < maxBlue) {
    return pixelColor;
  }
  return vec4(0.);
}

// Pixelate 
vec2 pixelate(vec2 coordinates) {
  int si = int(coordinates.s * pixelSize);
  int sj = int(coordinates.t * pixelSize);  
  
  return vec2(float(si) / pixelSize, float(sj) / pixelSize);  
}


// Flip texture (horizontally and/or vertically)
vec2 flip(vec2 coordinates, bool hFlip, bool vFlip) {
  vec2 v = coordinates;
  
  if (hFlip) {
    v.s = 1. - coordinates.s;
  }
  if (vFlip) {
    v.t = 1. - coordinates.t;
  }
  return v;
}

void main() {
  
  // Coordinates transformation 
  
  vec2 coords = vertTexCoord.st;
  
  if (pixelate)  {
  	coords = pixelate(coords);
  }
  
  if (hFlip || vFlip) {
  	coords = flip(coords, hFlip, vFlip);
  }


  // Color transformations
  
  vec4 col =  texture2D(texture, coords) * vertColor;


 if (edge) {
 	col = edge(coords);
 }
 if (emboss) {
 	col = emboss(coords);
 }

  if (adjust) {
     col = adjust(col, contrast, brightness); 
  }
  if (invert) {
     col = invert(col);
  }
  if (bw) {
    col = bw(col);
  }
  
  if (colorFilter) {
    col = red(col);
    col = green(col);
    col = blue(col);
  }
  gl_FragColor = col;
}
