/* FRAGMENT shader */
#define PI 3.1415926538
in vec4 fragmentView;
in vec2 pos;
uniform vec3 fogColor;
uniform sampler2D material;

uniform vec4 ambience;
uniform vec4 liteColor;
uniform vec3 lightPos;
uniform vec3 viewPos;
uniform float specularStrength;
uniform float metallic;

in vec3 Normal;
in vec3 FragmentPos;

vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv)
{
  //float fogAmount = atan(length(fragmentView) * 0.1) * 2.0 / PI;
  //vec4 color = vec4(mix(graphicsColor.rgb, fogColor, fogAmount), graphicsColor.a);
  //return color;

  //return graphicsColor * lovrDiffuseColor * lovrVertexColor * texture(image, uv);
  // return texture(material, pos);

  //diffuse
  vec3 norm = normalize(Normal);
  vec3 lightDir = normalize(lightPos - FragmentPos);
  float diff = max(dot(norm, lightDir), 0.0);
  vec4 diffuse = diff * liteColor;
  
  //specular
  vec3 viewDir = normalize(viewPos - FragmentPos);
  vec3 reflectDir = reflect(-lightDir, norm);
  vec3 halfVec = normalize(viewDir+reflectDir);
  // float spec = pow(max(dot(viewDir, reflectDir), 0.0), metallic);
  float spec = pow(max(dot(viewDir, halfVec), 0.0), metallic);
  vec4 specular = specularStrength * spec * liteColor;

  // vec4 baseColor = graphicsColor * texture(image, uv);
  vec4 baseColor = vec4(0.15, 0.33, 0.77, 0.8) * texture(image, uv);            
  vec4 fragcol = baseColor * (ambience + diffuse + specular);
  // return vec4(fragcol.xyz, 0.5);
  return fragcol;
}