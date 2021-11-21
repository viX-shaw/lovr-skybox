/* VERTEX shader */
out vec2 pos;
out vec3 Normal;

uniform float uTime;
// uniform float wvlength;
// uniform float wvSteep;
out vec4 fragmentView;
out vec3 FragmentPos;

vec3 gerstnerwave (vec4 wave, vec3 p, inout vec3 tangent, inout vec3 binormal) {
  float steepness = wave.z;
  // steepness = steepness * (0.25 - p.x/3);
  float wavelength = wave.w;
  float k = 2.0 * 3.142857 / wavelength;
  float c = sqrt(9.8 / k);
  vec2 d = normalize(wave.xy);
  float f = k * (dot(d, p.xy) - c * uTime * 0.2);
  float a = steepness / k;
  
  //p.x += d.x * (a * cos(f));
  //p.y = a * sin(f);
  //p.z += d.y * (a * cos(f));

  tangent += vec3(
    -d.x * d.x * (steepness * sin(f)),
    d.x * (steepness * cos(f)),
    -d.x * d.y * (steepness * sin(f))
  );
  binormal += vec3(
    -d.x * d.y * (steepness * sin(f)),
    d.y * (steepness * cos(f)),
    -d.y * d.y * (steepness * sin(f))
  );
  return vec3(
    d.x * (a * cos(f)),
    d.y * (a * cos(f)),
    -a * sin(f)
  );
}

vec4 position(mat4 projection, mat4 transform, vec4 vertex) {
  // // float amplitude = 0.1;
  // float wavelength = 2.0;
  // float steepness = 0.5;
  // // float speed = 0.3;
  // float k = (2.0 * 3.14) / wavelength;
  // float c = sqrt(9.8 / k);
  // vec2 direction = vec2(1, 1);
  // vec2 d = normalize(direction);
  // // float f = k*(vertex.x - c*uTime);
  // float f = k*(dot(d, vertex.xy) - c*uTime);
  // float a = steepness / k;
  // //FOr texture
  // pos = vertex.xy;
  // //Waves
  // vertex.z = -a*sin(f)+1.7; // +1.7 for placement at the feet 
  // vertex.x += d.x *(a*cos(f));
  // vertex.y += d.y *(a*cos(f));
  // // vec3 tangent = normalize(vec3(1, k * amplitude * cos(f), 0));
  // vec3 tangent = normalize(vec3(
  //   1.0 - d.x * d.x * steepness*sin(f),
  //   d.x * steepness * cos(f),
  //   -d.x * d.y * (steepness*sin(f))));

  // vec3 binormal = normalize(vec3(
  //   -d.x * d.y * steepness*sin(f),
  //   d.y * steepness * cos(f),
  //   1.0 - d.y * d.y * (steepness*sin(f))));

  // // vec3 normal = vec3(-tangent.y, tangent.x, 0);
  // vec3 normal = normalize(cross(binormal, tangent));
  // fragmentView = projection * transform * vertex;
  // vec4 wave1 = vec4(1,1,0.10,0.1); //make it a uniform 0.1, 0.055, 0.029
  float wvlength = 0.01*sin(uTime*0.15) + 0.15;
  float wvSteep = 0.05*sin(uTime*0.15 + 1.57) + 0.2;

  vec4 wave1 = vec4(1.0, 1.0, wvSteep, wvlength);
  vec4 wave2 = vec4(1.0,0.6,wvSteep,wvlength/1.81); //make it a uniform
  vec4 wave3 = vec4(1.0,1.3,wvSteep,wvlength/3.44); //make it a uniform
  // vec4 wave4 = vec4(-1,-0.4,wvSteep,wvlength/2.0); //make it a uniform


  vec3 tangent = vec3(1.0,0.0,0.0);
  vec3 binormal = vec3(0.0,0.0,1.0);
  vec3 gridpoint = vertex.xyz;
  vec3 p = vertex.xyz;

  p += gerstnerwave(wave1, gridpoint, tangent, binormal);
  p += gerstnerwave(wave2, gridpoint, tangent, binormal);
  p += gerstnerwave(wave3, gridpoint, tangent, binormal);
  // p += gerstnerwave(wave4, gridpoint, tangent, binormal);

  vec3 normal = normalize(cross(binormal, tangent));
  //For lighting
  // Normal = lovrNormal * lovrNormalMatrix;
  Normal = normal * lovrNormalMatrix;
  vertex.xyz = p;
  FragmentPos = vec3(vertex);
  fragmentView = projection * transform * vertex;
  return fragmentView;
}