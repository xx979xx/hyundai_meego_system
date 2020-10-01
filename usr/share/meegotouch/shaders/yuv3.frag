varying lowp vec2 fragTexCoord;
uniform sampler2D textureY;
uniform sampler2D textureU;
uniform sampler2D textureV;
uniform lowp float opacity;

void main(void)
{
    highp float y = texture2D(textureY, fragTexCoord).x;
    highp float u = texture2D(textureU, fragTexCoord).x;
    highp float v = texture2D(textureV, fragTexCoord).x;
    
    u = u - 0.5;
    v = v - 0.5;
    y = 1.164 * (y - 0.0625);
    
    gl_FragColor = vec4(y + 1.403 * v, y - (0.344 * u) - (0.714 * v), y + (1.770 * u), 1.0) * opacity;
}
