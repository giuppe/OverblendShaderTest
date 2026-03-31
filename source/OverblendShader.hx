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
            
           
            float temp = 1;
            gl_FragColor = vec3(temp);

        }')
	public function new()
	{
		super();
	}
}
