package  
{
	import __AS3__.vec.Vector;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.hires.debug.Stats;	

	[SWF(width='800',height='600',frameRate='30',backgroundColor='0x000000')]
	/**
	 * @author Joa Ebert
	 * @mod katopz
	 */
	public final class CopyPixelParticles extends Sprite 
	{
		private const MAX_PARTICLES: int = 5000;//0x400;//25fps
		//private const _screen: BitmapData = new BitmapData( 800, 600, false, 0x000000 );
		private const _buffer: Vector.<uint> = new Vector.<uint>( 800 * 600, true );
		private const _matrix: Matrix3D = new Matrix3D();
		private var _particles: Particle;
		private var _focalLength: Number;
		private var _targetX: Number = 0.0;
		private var _targetY: Number = 0.0;
		private var bmp:Bitmap = new Bitmap();
		
		private var mats:Vector.<BitmapData>;
		 
		private var mat:BitmapData; 
		private var graphicsData:Vector.<IGraphicsData>;
		protected var _graphicsBitmapFill:GraphicsBitmapFill = new GraphicsBitmapFill();
		
		private const size:uint = 32;  
		
		private var j:uint = 0;
		private var k:uint = 0;
		private var particles:Array;
		private var _focus:Number = 5000;
		private var _zoom:Number = 1;
		private var fz:Number;
		private var _bmp_graphics:Graphics; 
		
		public function CopyPixelParticles()
		{
			addChild(bmp);
			screenSetup();
			mouseEnabled = false;
			mouseChildren = false;
			
			/*
			var view:Shape = new Shape();
			addChild(view);
			_bmp_graphics = view.graphics; 
			*/
			
			
			
			mats = new Vector.<BitmapData>(30, true);
			
			for(var i:int=0;i<30;i++)
			{
				var sprite:Sprite = new Sprite();
				drawDot(sprite.graphics,size/2,size/2,size/2,0xFFFFFF-0x00FF00*Math.sin(Math.PI*i/30),0x000000);
				
				mat = new BitmapData(size,size,true,0x00000000);
				mat.draw(sprite);
			
				mats[i] = mat;
			}
			
			//_graphicsBitmapFill.bitmapData = mat;
			
			//graphicsData = new Vector.<IGraphicsData>([_graphicsBitmapFill]);
			
			createParticles();
			calculatePositions();
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		private function drawDot(_graphics:Graphics, x:Number, y:Number, size:Number, colorLight:uint, colorDark:uint):void
        {
            var colors:Array = [colorLight, colorDark];
            var alphas:Array = [1.0, 1.0];
            var ratios:Array = [0, 255];
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox(size * 2, 
                                     size * 2, 
                                     0,
                                     x - size,
                                     y - size);
            
            _graphics.lineStyle();
            _graphics.beginGradientFill(GradientType.RADIAL, 
                                        colors,
                                        alphas,
                                        ratios,
                                        matrix);
            _graphics.drawCircle(x, y, size);
            _graphics.endFill();
        }

		private function screenSetup(): void
		{
			var perspectiveProjection: PerspectiveProjection = new PerspectiveProjection( );
			//perspectiveProjection.fieldOfView = 60.0;
			perspectiveProjection.projectionCenter = new Point(800/2, 600/2);
			perspectiveProjection.fieldOfView = int(360*Math.atan2(800, 2*_zoom*_focus)/Math.PI);
			fz = _focus*_zoom;
			
			perspectiveProjection.focalLength+=2000
			
			_focalLength = perspectiveProjection.focalLength;
			
			//stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;
			stage.fullScreenSourceRect = new Rectangle( 0.0, 0.0, 800.0, 600.0 );
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//addChild( new Bitmap( _screen, PixelSnapping.NEVER, false ) );
			addChild( new Stats() );
			
			var tf : TextFormat = new TextFormat();
			tf.font = 'arial';
			tf.size = 10;
			tf.color = 0xffffff;
			
			var textField: TextField = new TextField();
			textField.x = 72;
			textField.mouseEnabled = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = tf;
			textField.selectable = false;
			textField.multiline = true;
			textField.text = String(MAX_PARTICLES) + " particles";
			addChild( textField );
		}
		
		private function createParticles(): void
		{
			if( 1 > MAX_PARTICLES )
				return;
		
			_particles = new Particle();
			
			var currentParticle: Particle = _particles;
			var numParticles: int = MAX_PARTICLES;
			
			while( --numParticles != 0 )
			{
				currentParticle = currentParticle.next = new Particle();
			}
		}
		
		private function calculatePositions(): void
		{
			var _a:Number = 1.111;
			var _b:Number = 1.479;
			var _f:Number = 4.494;
			var _g:Number = 0.44;
		 	var _d:Number = 0.135;
			var cx:Number = 1;
			var cy:Number = 1;
			var cz:Number = 1;
			var mx:Number = 0;
			var my:Number = 0;
			var mz:Number = 0;
			
			var scale:Number = 160;
			var particle: Particle = _particles;
			//particleVector3Ds = new Vector.<Number>();
			
			while( particle )
			{
				mx = cx + _d * (-_a * cx - cy * cy - cz * cz + _a * _f);
				my = cy + _d * (-cy + cx * cy - _b * cx * cz + _g);
				mz = cz + _d * (-cz + _b * cx * cy + cx * cz);
				
				cx = mx;
				cy = my;
				cz = mz;
				
				particle.x = mx * scale;
				particle.y = my * scale;
				particle.z = mz * scale;
				
				particle = particle.next;
				/*
				if(particle)
				{
					particleVector3Ds.push(particle.x, particle.y, particle.z);
				}
				*/
			}
			//particleVector3Ds.fixed = true;
		}
		
		private var particleVector3Ds:Vector.<Number>;
		private var projectedVector3Ds:Vector.<Number>;
		
		private function onEnterFrame( event: Event ): void
		{
			_targetX += ( mouseX - _targetX ) * 0.1;
			_targetY += ( mouseY - _targetY ) * 0.1;
			
			_matrix.identity();
			_matrix.appendRotation( _targetX, Vector3D.Y_AXIS );
			_matrix.appendRotation( _targetY, Vector3D.X_AXIS );
			//_matrix.appendTranslation( 0.0, 0.0, 0 );
			
			var particle: Particle = _particles;
			
			var x: Number;
			var y: Number;
			var z: Number;
			var w: Number;
			
			var pz: Number;
			
			var xi: int;
			var yi: int;

			var p00: Number = _matrix.rawData[ 0x0 ];
			var p01: Number = _matrix.rawData[ 0x1 ];
			var p02: Number = _matrix.rawData[ 0x2 ];
			var p10: Number = _matrix.rawData[ 0x4 ];
			var p11: Number = _matrix.rawData[ 0x5 ];
			var p12: Number = _matrix.rawData[ 0x6 ];
			var p20: Number = _matrix.rawData[ 0x8 ];
			var p21: Number = _matrix.rawData[ 0x9 ];
			var p22: Number = _matrix.rawData[ 0xa ];
			var p32: Number = _matrix.rawData[ 0xe ];
			/*
			var bufferWidth: int = 800;
			var bufferMax: int = _buffer.length;
			var bufferMin: int = -1;
			var bufferIndex: int;
			*/
			var buffer: Vector.<uint> = _buffer;
			/*
			var color: uint;
			var colorInc: uint = 0x202020;
			var colorMax: uint = 0xffffff;
			*/
			var cx: Number = 800/2;
			var cy: Number = 600/2;
			var minZ: Number = 0.0;

			//var n: int = bufferMax;
			//while( --n ) buffer[ n ] = 0x000000;

			var matrix:Matrix = new Matrix();
			particles = [];
			
			var index:uint = 0;
			
			do
			{
				x = particle.x, y = particle.y, z = particle.z;
				pz = _focalLength + x * p02 + y * p12 + z * p22 + p32;
				
				if( minZ < pz )
				{
					xi = ( w = _focalLength / pz ) * ( x * p00 + y * p10 + z * p20 ) + cx ;
					yi = w * ( x * p01 + y * p11 + z * p21 ) + cy ;
					
					/*
					if(!isDraw)
					{
						isDraw = true;
						_bmp_graphics.moveTo(xi, yi);
					}
					*/
					
					//_bmp_graphics.lineStyle(1, 0xFFFFFF/z, pz/MAX_PARTICLES);
					//_bmp_graphics.lineTo(xi,yi);
					//var matrix:Matrix = new Matrix();
					/*
					matrix.tx = xi;
					matrix.ty = yi;
					_bmp_graphics.beginBitmapFill(mat, matrix);
					_bmp_graphics.drawRect(xi, yi, size, size);
					*/
					
					scale = fz / (fz + pz);
					
					particle.screenX = scale*(cx+xi);
					particle.screenY = scale*(cy+yi);
					particle.screenZ = pz;
					
					particle.index = index;
					
					if(++index>30)
						index=0
					
					//var fz:Number = focus*zoom;
					//scale = fz / (fz + pz);
					
					/*
					if( bufferMin < ( bufferIndex = int( xi + int( yi * bufferWidth ) ) ) && bufferIndex < bufferMax )
						buffer[ bufferIndex ] = ( ( color = buffer[ bufferIndex ] + colorInc ) > colorMax ) ? colorMax : color;
					*/
				}
				
				particle = particle.next;
				
				if(particle)
					particles.push(particle);
			} 
			while( particle );
			
			/*
			projectedVector3Ds = new Vector.<Number>();
			var uvts:Vector.<Number> = new Vector.<Number>();
			Utils3D.projectVectors(_matrix, particleVector3Ds, projectedVector3Ds,uvts);
			*/
			
			particles.sortOn("screenZ", 18);
			
			//render
			//_bmp_graphics.clear();
			
			bmp.bitmapData = new BitmapData(800,600,true);
			bmp.bitmapData.lock();
			
			var scale:Number;
			var rect:Rectangle = new Rectangle(0, 0, size, size);
			
			var _bmp_bitmapData_copyPixels:Function = bmp.bitmapData.copyPixels;
			for each(var _particle:Particle in particles)
			{
				//scale = fz / (fz + _particle.screenZ);
				
				//trace(_particle.screenZ/5000);
				/*
				matrix.identity();
				
				xi = matrix.tx = cx+_particle.screenX;
				yi = matrix.ty = cy+_particle.screenY;
				
				matrix.scale(scale, scale);
				*/
				//_bmp_graphics.beginBitmapFill(mats[(_particle.index+j)%29], matrix, true);
				//_bmp_graphics.drawRect(xi*scale, yi*scale, size*scale, size*scale);
				
				_bmp_bitmapData_copyPixels(mats[int((_particle.index+j)%29)],rect,new Point(_particle.screenX, _particle.screenY),null,null,true);
			}
			bmp.bitmapData.unlock();
			if(++j>29)j = 0;
			
			//_bmp_graphics.endFill();
			
			//_screen.lock();
			//_screen.setVector( _screen.rect, buffer );
			//_screen.fillRect(_screen.rect, 0x000000);
			//_screen.draw(bmp);
			//_screen.unlock( _screen.rect );
		}
	}
}
