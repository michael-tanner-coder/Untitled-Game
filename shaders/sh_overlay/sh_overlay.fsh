//---------------------------------------------------------------
    uniform sampler2D overlayTexture;
    //---------------------------------------------------------------
    varying vec2 v_vTexcoord;
    //---------------------------------------------------------------
    float overlay( float S, float D ) {
        return float( D > 0.5 ) * ( 2.0 * (S + D - D * S ) - 1.0 )
        + float( D <= 0.5 ) * ( ( 2.0 * D ) * S );
    }
    //---------------------------------------------------------------
    void main() {
        vec4 D = texture2D( gm_BaseTexture, v_vTexcoord );  //destination color
        vec4 S = texture2D( overlayTexture, v_vTexcoord );  //source color
        //---------------------------------------------------------------
        gl_FragColor = vec4(
            mix(
                vec3( overlay( S.r, D.r ), overlay( S.g, D.g ), overlay( S.b, D.b ) ),
                D.rgb,
                1.0 - S.a
            ),
            D.a
        );
    }
//---------------------------------------------------------------