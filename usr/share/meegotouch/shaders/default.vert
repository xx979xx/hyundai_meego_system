attribute highp vec4 vertex;
attribute lowp  vec2 texCoord;
uniform   highp mat4 matProj;
uniform   highp mat4 matWorld;
varying   lowp  vec2 fragTexCoord;

void main(void)
{
    gl_Position = matProj * matWorld * vertex;
    fragTexCoord = texCoord;
}
