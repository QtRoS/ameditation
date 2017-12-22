import QtQuick 2.6

ShaderEffect {
    fragmentShader: "
        uniform lowp sampler2D source;
        uniform lowp float qt_Opacity;
        varying highp vec2 qt_TexCoord0;

        void main() {
            lowp vec4 p = texture2D(source, qt_TexCoord0);
            p.r = min(0.8, (1.0 - p.r) * 0.8 + 0.1);
            p.g = min(0.8, (1.0 - p.g) * 0.8 + 0.1);
            p.b = min(0.8, (1.0 - p.b) * 0.8 + 0.1);
            gl_FragColor = vec4(vec3(dot(p.rgb, vec3(0.299, 0.587, 0.114))), p.a) * qt_Opacity;
        }
    "
}
