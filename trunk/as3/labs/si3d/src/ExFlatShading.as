// forked from keim_at_Si's wonderflで3D 【Flat shading】
// 高速化，マウスで光源移動，クリックで材質変更
//--------------------------------------------------
package {
    import com.si3d.lights.*;
    import com.si3d.materials.*;
    import com.si3d.objects.*;
    import com.si3d.render.*;
    import com.si3d.ui.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    
    import net.hires.debug.Stats;
	
    [SWF(width="465", height="465", backgroundColor="0x000000", frameRate="30")]
    public class ExFlatShading extends Sprite {
        private var _matrix:Matrix3D = new Matrix3D();
        private var _engine:EngineFaceBasedRender = new EngineFaceBasedRender();
        
        // material setting (color, alpha, amb, dif, spc, phong, emi, doubleSided)
        private var _materials:Vector.<Material> = Vector.<Material>([
            (new Material()).setColor2(0x8080c0, 1, 64, 128, 128, 12, 0, false),   // standerd
            (new Material()).setColor2(0x8080c0, 1, 64, 192,   0,  0, 0, false),   // matte
            (new Material()).setColor2(0x8080c0, 1, 16,  64, 192, 18, 0, false),   // speculer
            (new Material()).setColor2(0x8080c0, 1,  8,  32, 256, 24, 0, false),   // more speculer
            (new Material()).setColor2(0x8080c0, 1,  0, 255,   0,  0, 0, false),   // diffusion only
            (new Material()).setColor2(0x8080c0, 1,  0,   0, 255, 12, 0, false),   // speculer only
            (new Material()).setColor2(0x8080c0, 1,128, 128,   0,  0, 0, false),   // one color
            (new Material()).setColor2(0x8080c0, 1,  0,   0,   0,  0, 255, false), // one color (same)
        ]);
        private var _light:Light = new Light(1,0.5,0.25);
        private var _model:Model = new Model();
        private var _boxVertex:Vector.<Number> = new Vector.<Number>();
        private var _sphVertex:Vector.<Number> = new Vector.<Number>();
        private var _vertexNormal:Vector.<Vector3D> = new Vector.<Vector3D>();
        
        private var _t:Number, _dt:Number, _rot:Number, _matIndex:int;
        private var _timeSum:int, _timeCount:int;
        
        private var _textField:TextField = new TextField();
        
        function ExFlatShading() {
        	stage.scaleMode = "noScale";
            _engine.x = 232;
            _engine.y = 232;
            addChild(_engine);
            addEventListener("enterFrame", _onEnterFrame);
            stage.addEventListener("click", function(e:Event):void{ _matIndex=(_matIndex+1)&7; });

            // create shape
            for (var x:Number=-14; x<16; x+=4) {
                for (var y:Number=-14; y<16; y+=4) {
                    _vertex( x, y, 16);
                    _vertex( x,-y,-16);
                    _vertex( y, 16, x);
                    _vertex(-y,-16, x);
                    _vertex( 16, x, y);
                    _vertex(-16, x,-y);
                }
            }
            for (var i:int=0; i<7; ++i) {
                for (var j:int=0; j<7; j++) {
                    for (var k:int=0; k<6; k++) {
                        var i0:int = (i*8+j)*6+k;
                        _model.face(i0, i0+6, i0+48).face(i0+54, i0+48, i0+6);
                    }
                }
            }
            _model.vertices.length = _boxVertex.length;
            _model.texCoord.length = _boxVertex.length;
            _vertexNormal.length = _boxVertex.length/3;
            for (i=0; i<_vertexNormal.length; ++i) _vertexNormal[i] = new Vector3D();
            
            // initialize parameters
            _matIndex = 0;
            _rot = 0;
            _t = 0;
            _dt = 0.01;
            _timeSum = 0;
            _timeCount = 0;
            _textField.autoSize = "left";
            _textField.background = true;
            _textField.backgroundColor = 0x80f080;
            addChild(_textField);
            var status:Stats = new Stats();
            status.x = 400;
            addChild(status);

            function _vertex(x:Number, y:Number, z:Number) : void {
                _boxVertex.push( x, y, z);
                var ilen:Number = 20/Math.sqrt(x*x+y*y+z*z);
                _sphVertex.push( x*ilen, y*ilen, z*ilen);
            }
            
            camera=new Vector3D(0, 0, -50);
            //var projectionMesh:ProjectionMesh = new ProjectionMesh(_model);
        }
		private var gl:Render3D=new Render3D(300, 1);
		private var camera:Vector3D;
        private function _onEnterFrame(e:Event) : void {
            var i:int, t:int;
            // update paremters
            _rot += 1;
            _t += _dt;
            if (_t>3 || _t<-3) { _dt = -_dt; _t += _dt; }
            for (i=0; i<_model.vertices.length; ++i) {
                _model.vertices[i] = _boxVertex[i]*_t + _sphVertex[i]*(1-_t);
            }

            // light position
            //_light.setPosition(mouseX-232, mouseY-232, -100);
         	_light.transformBy(gl.id().tv(camera).ry(180-(456-mouseX)/2 ).matrix);
         	//var v3D:Vector3D = new Vector3D(mouseX-232, mouseY-232, -100);
			//_light.transformBy(gl.id().tv(v3D).matrix);
			
            t = getTimer();
            _engine.pushMatrix();
            _matrix.identity();
            _matrix.appendRotation(_rot*0.3, Vector3D.X_AXIS);
            _matrix.appendRotation(_rot,     Vector3D.Y_AXIS);
            _matrix.appendTranslation(0, 0, 100);
            _engine.matrix.append(_matrix);
            _engine.project(_model);
            _engine.render(_model, _light, _materials[_matIndex], "flat");
            _engine.popMatrix();
            _timeSum += getTimer() - t;
            
            if (++_timeCount == 30) {
                _textField.text = "Redering time: " + String(_timeSum) + "[ms/30frames]";
                _timeSum = 0;
                _timeCount = 0;
            }
        }
    }
}