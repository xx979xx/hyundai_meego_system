varying lowp vec2 fragTexCoord;
uniform sampler2D textureYUV;
uniform lowp float opacity;

void main(void)
{
    highp vec3  yuv = texture2D(textureYUV, fragTexCoord).xyz;
    highp float y = yuv.x;
    highp float u = yuv.y;
    highp float v = yuv.z;
    
    u = u - 0.5;
    v = v - 0.5;
    y = 1.164 * (y - 0.0625);
    
    gl_FragColor = vec4(y + 1.403 * v, y - (0.344 * u) - (0.714 * v), y + (1.770 * u), 1.0) * opacity;
}
