import flixel.graphics.tile.FlxGraphicsShader;

class OverblendShader extends FlxGraphicsShader
{
	@:glFragmentSource('
        #pragma header

        uniform vec2 sunPosition;
        uniform float sunRadius;
        
        uniform float power;

        void main()
        {
            
            vec2 pixsize = 1.0 / openfl_TextureSize;
			
            vec2 pixpos = openfl_TextureCoordv;

            vec4 source = flixel_texture2D(bitmap, pixpos);

            vec4 result = source;
            if(power==1.0){
            vec3 lightColor = vec3(1.0, 0.9, 0.25);

            float intensity = 0.8; //1.0-sunPosition.y;
            float radius = 0.9; //1.0-sunPosition.y;

            vec2 pos = pixpos-sunPosition;
            float dist = 1./length(pos);
            
            dist *= radius;
    

            dist = pow(dist, intensity);

            vec3 col = dist * lightColor;
            
            //exponential decrease to limit the filter
            //col = 1.0 - exp( -col );
            
            result = vec4(source.rgb*col, 1.0);
            }
            
            gl_FragColor = result;

        }')
	public function new()
	{
		super();
	}
}
