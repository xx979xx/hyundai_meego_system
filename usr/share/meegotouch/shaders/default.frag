varying lowp vec2 fragTexCoord;
uniform sampler2D texture0;
uniform lowp float opacity;

void main(void)
{
    gl_FragColor = texture2D(texture0, fragTexCoord) * opacity;
}
