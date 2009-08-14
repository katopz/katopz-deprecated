package
{
	import flash.net.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.events.*;  
	import flash.display.*;
	import flash.system.Security;
	import flash.system.LoaderContext;

	[SWF(width="400", height="300", backgroundColor="#000000", frameRate=31)]
	public class MikuScreen extends Sprite
	{
		public static const WIDTH:uint  = 400;
		public static const HEIGHT:uint = 300;

		private var mRenderer:SceneRenderer;
		private var mVUp:Vec3 = new Vec3(0, 1, 0);
		private var mLookFrom:Vec3 = new Vec3(0, 0, 0);
		private var mModel:Object;
		private var mTexture:BitmapData = null;
		private var mShTexture:BitmapData = null;
		private var mCount:int = 0;
		private var mFloorTrans:Matrix= new Matrix();
		private var mSwingCount:int = 0;
		
		private var mFBuffer:BitmapData;
		private var mFBufferBmp:Bitmap;
		private var mSBuffer :BitmapData;
		private var mSBuffer2:BitmapData;
		private var mEffectBuffer:BitmapData;
		private var mScreenImage:BitmapData;
		private var mBufferRect:Rectangle;
		private var mOffscreen:Sprite = new Sprite();
		private var mOffscreen2:Sprite = new Sprite();
		private var mStencilColor:ColorTransform = new ColorTransform(0, 0, 0);

		function MikuScreen()
		{
			stage.quality = StageQuality.LOW;
			stage.scaleMode = "noScale";
			var req:URLRequest = new URLRequest("images/miku_tex.png");
			var loader:Loader = new Loader();

			var req2:URLRequest = new URLRequest("images/miku_sh_a.png");
			var loader2:Loader = new Loader();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTextureLoaded);
			loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, onShTextureLoaded);

			mFBuffer = new BitmapData(WIDTH, HEIGHT, true, 0);
			mEffectBuffer = new BitmapData(WIDTH, HEIGHT, false, 0);
			mScreenImage = new BitmapData(WIDTH, HEIGHT, true, 0);
			mSBuffer  = new BitmapData(WIDTH, HEIGHT, false, 0);
			mSBuffer2 = new BitmapData(WIDTH, HEIGHT, false, 0);
			mBufferRect = new Rectangle(0, 0, WIDTH, HEIGHT);

//			mFBufferBmp = new Bitmap(mSBuffer2);
			mFBufferBmp = new Bitmap(mFBuffer);
			addChild(mFBufferBmp);

//tx.textColor=0x00ff00;
			mRenderer = new SceneRenderer();

			mRenderer.viewport.x = WIDTH/2;
			mRenderer.viewport.y = HEIGHT/2;
			mRenderer.viewport.w = WIDTH;
			mRenderer.viewport.h = HEIGHT;

			mRenderer.projectionMatrix.perspectiveProj(0.8, WIDTH/HEIGHT, 1, 2000);

			mModel = (new MikuData()).MESH;
			mRenderer.vertices  = mModel.poss;
			mRenderer.indices   = mModel.indices;
			mRenderer.texCoords = mModel.texcoords;
			mRenderer.addPart(mModel.groups[0]);
			mRenderer.addPart(mModel.groups[1]);
			mRenderer.addPart(mModel.groups[2]);
			mRenderer.beforeEnterPart = beforeEnterPart;

			var cx:LoaderContext = new LoaderContext();
			cx.checkPolicyFile = true;

			loader.load(req, cx);
			loader2.load(req2, cx);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
		}

		private function onClick(e:MouseEvent):void
		{
			if (!mSwingCount) mSwingCount = 1;
		}

		private function onEnterFrame(e:Event):void
		{
			var ty:Number = mouseY/Number(HEIGHT);
			if (!isNaN(ty)) {
				ty = 540 - ty*500;
				mLookFrom.y = mLookFrom.y*0.7 + ty*0.3;

				var tx:Number = (mouseX/Number(WIDTH) - 0.5) * 1.8;
				var tz:Number = Math.cos(tx)*(1100-ty);
				tx = Math.sin(tx)*900;
				mLookFrom.x = mLookFrom.x*0.7 + tx*0.3;
				mLookFrom.z = mLookFrom.z*0.7 + tz*0.3;
			}
			prepareEffect();

			var g:Graphics = mOffscreen.graphics;
			g.clear();

			mRenderer.viewMatrix.lookAtLH(mVUp, mLookFrom, new Vec3(0, 120, -90));
			mRenderer.transform();
			mRenderer.recalcAllMatrix();
			drawBack(g);
			drawShadow(g);

			var g2:Graphics = mOffscreen2.graphics;
			g2.clear();
			mRenderer.render(g2);

			// normal rendering
			mFBuffer.fillRect(mBufferRect, 0);
			mFBuffer.draw(mOffscreen);
			mFBuffer.draw(mOffscreen2);

			// stencil rendering
			mSBuffer.fillRect(mBufferRect, 0xffffff);
			mSBuffer.draw(mOffscreen2, null, mStencilColor);

			mRenderer.recalcAllMatrix();

			mSBuffer2.copyPixels(mFBuffer, mBufferRect, new Point(0, 0));
			composeScreenImage(false);
			mFBuffer.copyPixels(mScreenImage, mBufferRect, new Point(0, 0), null, null, true);

			mSBuffer2.copyPixels(mFBuffer, mBufferRect, new Point(0, 0));
			composeScreenImage();
			mFBuffer.copyPixels(mScreenImage, mBufferRect, new Point(0, 0), null, null, true);

			mSBuffer2.copyPixels(mFBuffer, mBufferRect, new Point(0, 0));
			composeScreenImage();
			mFBuffer.copyPixels(mScreenImage, mBufferRect, new Point(0, 0), null, null, true);

			mSBuffer2.copyPixels(mFBuffer, mBufferRect, new Point(0, 0));
			composeScreenImage();
			mFBuffer.copyPixels(mScreenImage, mBufferRect, new Point(0, 0), null, null, true);

			if (mSwingCount) {
				if (++mSwingCount == 11)
					mSwingCount = 0;
			}
			mCount++;
		}

		private static const SC_COLORS:Array = [0x111111, 0x224455];
		private static const SC_ALPHAS:Array = [1, 1];
		private static const SC_RATIOS:Array = [0, 170];
		private var mScGradTrans:Matrix = new Matrix();

		private function prepareEffect():void
		{
			var g:Graphics = mOffscreen.graphics;
			// scan-line effect

			g.clear();
			mScGradTrans.createGradientBox(1, 2, Math.PI/2);
			g.beginGradientFill(GradientType.LINEAR, SC_COLORS, SC_ALPHAS, SC_RATIOS, mScGradTrans, SpreadMethod.REFLECT);
			g.drawRect(0, 0, WIDTH, HEIGHT);

			var by:int = (mCount*8) % HEIGHT;
			g.beginFill(0, 0.3);
			g.drawRect(0, by, WIDTH, 100);
			g.drawRect(0, by-HEIGHT, WIDTH, 100);

			if ((mCount>>1)&1) {
				g.beginFill(0xffffff, 0.03);
				g.drawRect(0, 0, WIDTH, HEIGHT);
			}

			mEffectBuffer.draw(mOffscreen);
		}

		private var scrPosList:Vector.<Number> = new Vector.<Number>(8);
		private var scrIndexList:Vector.<int>;
		private var scrUVList:Vector.<Number>  = new Vector.<Number>(12);
		private function composeScreenImage(useEffect:Boolean = true):void
		{
			const scX:Array = [-400, 400, -400, 400];
			const scY:Array = [ 550, 550, -50, -50];
			
			var am:M44 = mRenderer.allMatrix;
			var spos:Array = [0,0,0,0];

			if (!scrIndexList)
			{
				scrIndexList = new Vector.<int>(6);
				scrIndexList[0] = 0;
				scrIndexList[1] = 1;
				scrIndexList[2] = 2;
				scrIndexList[3] = 2;
				scrIndexList[4] = 1;
				scrIndexList[5] = 3;
			}

			for (var i:int = 0;i < 4;++i)
			{
				am.transVec3W(spos, scX[i], scY[i], -450);

				var W:Number = spos[3];
				spos[0] /= W;
				spos[0] *= mRenderer.viewport.w;
				spos[0] += mRenderer.viewport.x;
				spos[1] /= W;
				spos[1] *= -mRenderer.viewport.h;
				spos[1] += mRenderer.viewport.y;
				spos[2] /= W;

				scrPosList[(i<<1)  ] = spos[0];
				scrPosList[(i<<1)+1] = spos[1];

				scrUVList[i*3  ] = (i%2);
				scrUVList[i*3+1] = int(i/2);
				scrUVList[i*3+2] = 1.0/W;
			}

			var g:Graphics = mOffscreen.graphics;

			if (useEffect)
				mSBuffer2.draw(mEffectBuffer, null, null, BlendMode.ADD);

			// copy rendering result
			g.clear();
			g.beginBitmapFill(mSBuffer2);
			g.drawTriangles(scrPosList, scrIndexList, scrUVList);
			g.endFill();

			mScreenImage.fillRect(mBufferRect, 0);
			mScreenImage.draw(mOffscreen);

			mSBuffer2.fillRect(mBufferRect, 0);
			mSBuffer2.copyChannel(mScreenImage, mBufferRect, new Point(0,0), BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
			mSBuffer2.draw(mSBuffer, null, null, BlendMode.MULTIPLY);
			mScreenImage.copyChannel(mSBuffer2, mBufferRect, new Point(0,0), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
		}

		private var shadowPosList:Vector.<Number> = new Vector.<Number>(8);
		private var shadowIndexList:Vector.<int>;
		private var shadowUVList:Vector.<Number>  = new Vector.<Number>(8);
		private function drawShadow(g:Graphics):void
		{
			const SHSIZE:Number = 120;
			const shX:Array = [-SHSIZE, SHSIZE, -SHSIZE, SHSIZE];
			const shZ:Array = [ SHSIZE, SHSIZE, -SHSIZE, -SHSIZE];
			var am:M44 = mRenderer.allMatrix;
			var spos:Array = [0,0,0,0];

			if (!shadowIndexList)
			{
				shadowIndexList = new Vector.<int>(6);
				shadowIndexList[0] = 0;
				shadowIndexList[1] = 1;
				shadowIndexList[2] = 2;
				shadowIndexList[3] = 2;
				shadowIndexList[4] = 1;
				shadowIndexList[5] = 3;
			}

			for (var i:int = 0;i < 4;++i)
			{
				am.transVec3W(spos, shX[i], -100, shZ[i]);

				var W:Number = spos[3];
				spos[0] /= W;
				spos[0] *= mRenderer.viewport.w;
				spos[0] += mRenderer.viewport.x;
				spos[1] /= W;
				spos[1] *= -mRenderer.viewport.h;
				spos[1] += mRenderer.viewport.y;

				shadowPosList[(i<<1)  ] = spos[0];
				shadowPosList[(i<<1)+1] = spos[1];

				shadowUVList[(i<<1)  ] = (i%2);
				shadowUVList[(i<<1)+1] = 1-int(i/2);
			}

			if (mShTexture) {
				g.beginBitmapFill(mShTexture);
				g.drawTriangles(shadowPosList, shadowIndexList, shadowUVList);
				g.endFill();
			}
		}

		private static const FG_COLORS:Array = [0x111111, 0x444444];
		private static const FG_ALPHAS:Array = [1, 1];
		private static const FG_RATIOS:Array = [0, 60];
		private function drawBack(g:Graphics):void
		{
			var vr:M44 = new M44(mRenderer.viewMatrix);
			vr._41 = 0;
			vr._42 = 0;
			vr._43 = 0;
			vr.transpose33();

			var spos:Array = [0,0,0,0];
			vr.transVec3(spos, 0, 0, 5000);

			var am:M44 = mRenderer.allMatrix;
			am.transVec3W(spos, spos[0], -100, spos[2]);
	
			var W:Number = spos[3];
			spos[1] /= W;
			spos[1] *= -mRenderer.viewport.h;
			spos[1] += mRenderer.viewport.y;

			mFloorTrans.createGradientBox(HEIGHT, HEIGHT-spos[1], Math.PI/2, 0, spos[1]);

			g.lineStyle();

			g.beginFill(0);
			g.drawRect(0, 0, WIDTH, HEIGHT);

			g.beginGradientFill(GradientType.LINEAR, FG_COLORS, FG_ALPHAS, FG_RATIOS, mFloorTrans);
			g.drawRect(0, spos[1], WIDTH, HEIGHT-spos[1]);
		}

		private function onTextureLoaded(e:Event):void
		{
			mTexture = e.target.loader.content.bitmapData;
			mRenderer.texture = mTexture;
		}

		private function onShTextureLoaded(e:Event):void
		{
			mShTexture = e.target.loader.content.bitmapData;
		}

		private function beforeEnterPart(pi:int):void
		{
			if (pi == 0) {
			} else if (pi == 1) {
				var aa:Number = (60.0 - Math.sin(mSwingCount*0.314159) * 50.0) * 0.01745;
				var mx:Number = 0, my:Number = 22.0, mz:Number = -0.5;

				var t:M44 = new M44();
				var u:M44 = new M44();
				var w:M44 = new M44();

				t.translate(mx, -my, mz);
				u.glRotate(aa, 1.0, -0.2, 0.0);
				w.mul(t, u);
				t.copyFrom(w);

				u.translate(mx - 1, my - 7, mz - 1);
				w.mul(t, u);
				t.copyFrom(w);

				u.glRotate(0.1745, 0, 0, 1);
				w.mul(t, u);

				t.copyFrom(mRenderer.allMatrix);
				mRenderer.allMatrix.mul(w, t);
			} else {
				w = new M44();
				t = new M44(w);
				u = new M44();

				u.glRotate(-1.9199, 1, 0, 0);
				w.mul(u, t);
				t.copyFrom(w);

				u.translate(30, 10, 25);
				w.mul(u, t);

				t.copyFrom(mRenderer.allMatrix);
				mRenderer.allMatrix.mul(w, t);
			}
		}
	}
}

class SceneRenderer
{
	import flash.display.*;

	private var mMProj:M44 = new M44();
	private var mMView:M44 = new M44();
	private var mMAll:M44  = new M44();
	private var mViewport:Viewport = new Viewport();

	private var mRenderList:Array = [];
	private var mVertices:Array;
	private var mTexCoords:Array;
	private var mIndices:Array;
	private var mRenderTris:Vector.<RenderTriangle> = null;
	private var mGDrawTris:Vector.<Number> = new Vector.<Number>;
	private var mGDrawUVs:Vector.<Number> = new Vector.<Number>;
	private var mTriCount:uint = 0;
	private var mCurrentTexture:BitmapData = null;
	private var mBeforeEnterPart:Function = null;

	public function get projectionMatrix():M44
	{ return mMProj; }

	public function get viewMatrix():M44
	{ return mMView; }

	public function get allMatrix():M44
	{ return mMAll; }

	public function get viewport():Viewport
	{ return mViewport; }

	public function set vertices(a:Array):void
	{ mVertices = a; }

	public function set texCoords(a:Array):void
	{ mTexCoords = a; }

	public function set indices(a:Array):void
	{ mIndices = a; }

	public function addPart(rset:Object):void
	{
		mRenderList.push(rset);
	}

	public function recalcAllMatrix():void
	{
		mMAll.mul(mMView, mMProj);
	}

	public function set beforeEnterPart(f:Function):void
	{
		mBeforeEnterPart = f;
	}

	public function set texture(t:BitmapData):void
	{ mCurrentTexture = t; }

	public function transform():void
	{
		recalcAllMatrix();
		mTriCount = 0;

		if (!mRenderTris)
			mRenderTris = new Vector.<RenderTriangle>();

		var len:uint = mRenderList.length;
		var iofs:uint = 0;
		var vofs:uint = 0;
		for (var i:uint = 0;i < len;++i)
		{
			var pt:Object = mRenderList[i];
			if (mBeforeEnterPart != null)
				mBeforeEnterPart(i);

			calcPart(iofs, pt.faces, vofs);
			iofs += pt.faces;
			vofs += pt.vertices;
		}
	}

	private static function cmpZSort(a:Object, b:Object):int {return b.key-a.key;}

	public function render(g:Graphics):void
	{

		mRenderTris.sort(cmpZSort);
		mGDrawTris.length = mTriCount * 6;
		mGDrawUVs.length = mTriCount * 6;
		
		var len:uint = mTriCount;
		var vi:uint = 0, ti:uint = 0;
		for (var i:uint = 0;i < len;++i)
		{
			var t:RenderTriangle = mRenderTris[i];

			mGDrawTris[vi++] = t.A.pos.x;
			mGDrawTris[vi++] = t.A.pos.y;
			mGDrawUVs[ti++] = t.A.tu;
			mGDrawUVs[ti++] = t.A.tv;

			mGDrawTris[vi++] = t.B.pos.x;
			mGDrawTris[vi++] = t.B.pos.y;
			mGDrawUVs[ti++] = t.B.tu;
			mGDrawUVs[ti++] = t.B.tv;

			mGDrawTris[vi++] = t.C.pos.x;
			mGDrawTris[vi++] = t.C.pos.y;
			mGDrawUVs[ti++] = t.C.tu;
			mGDrawUVs[ti++] = t.C.tv;
		}

		if (mCurrentTexture)
			g.beginBitmapFill(mCurrentTexture);
		else
			g.beginFill(0xffffff, 0.2);

		g.drawTriangles(mGDrawTris, null, mCurrentTexture ? mGDrawUVs : null, TriangleCulling.POSITIVE);
		g.endFill();
	}

	private function calcPart(i_start:uint, i_count:uint, voffset:uint):void
	{
		var ii:uint;
		var iii:uint, vi:uint, ti:uint;

		var a:Array = [0, 0, 0, 0];
		for (var i:uint = 0;i < i_count;++i) {
			ii = i_start + i;

			var t:RenderTriangle = addTriangle();
			iii = ii*3;
			ti = mIndices[iii++] + voffset;
			vi = ti*3;
			ti <<= 1;
			mMAll.transVec3W(a, mVertices[vi], mVertices[vi+1], mVertices[vi+2]);
			t.A.pos.x = (a[0] / a[3])*mViewport.w + mViewport.x;
			t.A.pos.y = (a[1] / a[3])*-mViewport.h + mViewport.y;
			t.A.pos.z =  a[2] / a[3];
			t.A.tu    = mTexCoords[ti  ];
			t.A.tv    = mTexCoords[ti+1];

			ti = mIndices[iii++] + voffset;
			vi = ti*3;
			ti <<= 1;
			mMAll.transVec3W(a, mVertices[vi], mVertices[vi+1], mVertices[vi+2]);
			t.B.pos.x = (a[0] / a[3])*mViewport.w + mViewport.x;
			t.B.pos.y = (a[1] / a[3])*-mViewport.h + mViewport.y;
			t.B.pos.z =  a[2] / a[3];
			t.B.tu    = mTexCoords[ti  ];
			t.B.tv    = mTexCoords[ti+1];

			ti = mIndices[iii++] + voffset;
			vi = ti*3;
			ti <<= 1;
			mMAll.transVec3W(a, mVertices[vi], mVertices[vi+1], mVertices[vi+2]);
			t.C.pos.x = (a[0] / a[3])*mViewport.w + mViewport.x;
			t.C.pos.y = (a[1] / a[3])*-mViewport.h + mViewport.y;
			t.C.pos.z =  a[2] / a[3];
			t.C.tu    = mTexCoords[ti  ];
			t.C.tv    = mTexCoords[ti+1];

			t.calcSortKey();
			if (t.key >= 999990) mTriCount--; // cancel
		}
	}

	private function addTriangle():RenderTriangle
	{
		if (mRenderTris.length <= mTriCount) {
			mRenderTris.push(new RenderTriangle());
		}

		return mRenderTris[mTriCount++];
	}
}

class RenderTriangle
{
	public var key:int;
	public var A:TexVertex = new TexVertex();
	public var B:TexVertex = new TexVertex();
	public var C:TexVertex = new TexVertex();

	public function calcSortKey():void {
		key = (A.pos.z + B.pos.z + C.pos.z) * 333333;
	}
}

class TexVertex
{
	public var pos:Vec3 = new Vec3();
	public var tu:Number, tv:Number;
}

class Viewport
{
	public var w:Number;
	public var h:Number;
	public var x:Number;
	public var y:Number;
}

class Vec3
{
	function Vec3(aX:Number = 0, aY:Number = 0, aZ:Number = 0)
	{
		x = aX;
		y = aY;
		z = aZ;
	}

	public function smul(k:Number):Vec3
	{
		x *= k;
		y *= k;
		z *= k;
		return this;
	}

	public function copyFrom(v:Vec3):Vec3
	{
		x = v.x;
		y = v.y;
		z = v.z;

		return this;
	}

	public function norm():Number
	{ return Math.sqrt(x*x + y*y + z*z); }

	public function normalize():Vec3
	{
		var nrm:Number = Math.sqrt(x*x + y*y + z*z);
		if (nrm != 0)
		{
			x /= nrm;
			y /= nrm;
			z /= nrm;
		}
		return this;
	}

	public function add(v:Vec3):Vec3
	{
		x += v.x;
		y += v.y;
		z += v.z;
		return this;
	}

	public function sub(v:Vec3):Vec3
	{
		x -= v.x;
		y -= v.y;
		z -= v.z;
		return this;
	}

	public function cp(v:Vec3, w:Vec3):Vec3
	{
		x = (w.y * v.z) - (w.z * v.y);
		y = (w.z * v.x) - (w.x * v.z);
		z = (w.x * v.y) - (w.y * v.x);
		return this;
	}

	public function dpWith(v:Vec3):Number
	{
		return (v.x*x + v.y*y + v.z*z);
	}

	public function leftZAxis():Vec3
	{
		var t:Number = x;
		x = -y;
		y =  t;
		return this;
	}

	public function swapYZ():Vec3
	{
		var t:Number = y;
		y = z;
		z = t;
		
		return this;
	}

	public var x:Number;
	public var y:Number;
	public var z:Number;
}

class M22
{
	public var _11:Number, _12:Number;
	public var _21:Number, _22:Number;

	public static function nearZero(n:Number):Boolean
	{
		return (n > -0.001) && (n < 0.001);
	}

	public function getInvert():M22
	{
		var out:M22 = new M22();
		var det:Number = _11 * _22 - _12 * _21;
		if (nearZero(det))
			return null;
	
		out._11 = _22 / det;
		out._22 = _11 / det;
	
		out._12 = -_12 / det;
		out._21 = -_21 / det;
	
		return out;
	}
}


class M44
{
	public var _11:Number, _12:Number, _13:Number, _14:Number;
	public var _21:Number, _22:Number, _23:Number, _24:Number;
	public var _31:Number, _32:Number, _33:Number, _34:Number;
	public var _41:Number, _42:Number, _43:Number, _44:Number;

	function M44(cpy:M44 = null)
	{
		if (cpy)
			copyFrom(cpy);
		else
			ident();
	}

	public static function fromArray(a:Array):M44
	{
		var m:M44 = new M44();
		m._11 = a[0];  m._12 = a[1];  m._13 = a[2];  m._14 = a[3];
		m._21 = a[4];  m._22 = a[5];  m._23 = a[6];  m._24 = a[7];
		m._31 = a[8];  m._32 = a[9];  m._33 = a[10]; m._34 = a[11];

		return m;
	}

	public function transpose():M44
	{
		var t:Number;

		t = _21; _21 = _12; _12 = t;
		t = _31; _31 = _13; _13 = t;
		t = _41; _41 = _14; _14 = t;

		t = _32; _32 = _23; _23 = t;
		t = _42; _42 = _24; _24 = t;

		t = _43; _43 = _34; _34 = t;

		return this;
	}

	public function get min22():M22
	{
		var m:M22 = new M22();
		m._11 = _11;
		m._12 = _12;
		m._21 = _21;
		m._22 = _22;

		return m;
	}

	public function copyFrom(m:M44):M44
	{
		_11 = m._11;
		_12 = m._12;
		_13 = m._13;
		_14 = m._14;

		_21 = m._21;
		_22 = m._22;
		_23 = m._23;
		_24 = m._24;

		_31 = m._31;
		_32 = m._32;
		_33 = m._33;
		_34 = m._34;

		_41 = m._41;
		_42 = m._42;
		_43 = m._43;
		_44 = m._44;

		return this;
	}

	public function equals(m:M44):Boolean
	{
		return (_11 == m._11) && 
			(_12 == m._12) && 
			(_13 == m._13) && 
			(_14 == m._14) && 

			(_21 == m._21) && 
			(_22 == m._22) && 
			(_23 == m._23) && 
			(_24 == m._24) && 

			(_31 == m._31) && 
			(_32 == m._32) && 
			(_33 == m._33) &&
			(_34 == m._34) && 

			(_41 == m._41) && 
			(_42 == m._42) && 
			(_43 == m._43) &&
			(_44 == m._44);
	}

	public function ident():M44
	{
			  _12 = _13 = _14 = 0;
		_21 =       _23 = _24 = 0;
		_31 = _32 =       _34 = 0;
		_41 = _42 = _43 =       0;

		_11 = _22 = _33 = _44 = 1;

		return this;
	}

	public function transVec3(out:Array, x:Number, y:Number, z:Number):void
	{
		out[0] = x * _11 + y * _21 + z * _31 + _41;
		out[1] = x * _12 + y * _22 + z * _32 + _42;
		out[2] = x * _13 + y * _23 + z * _33 + _43;
	}

	public function transVec3W(out:Array, x:Number, y:Number, z:Number):void
	{
		out[0] = x * _11 + y * _21 + z * _31 + _41;
		out[1] = x * _12 + y * _22 + z * _32 + _42;
		out[2] = x * _13 + y * _23 + z * _33 + _43;
		out[3] = x * _14 + y * _24 + z * _34 + _44;
	}

	public function transVec3Rot(out:Array, x:Number, y:Number, z:Number):void
	{
		out[0] = x * _11 + y * _21 + z * _31;
		out[1] = x * _12 + y * _22 + z * _32;
		out[2] = x * _13 + y * _23 + z * _33;
	}

	public function mul(A:M44, B:M44):M44
	{

		_11 = A._11*B._11  +  A._12*B._21  +  A._13*B._31  +  A._14*B._41;
		_12 = A._11*B._12  +  A._12*B._22  +  A._13*B._32  +  A._14*B._42;
		_13 = A._11*B._13  +  A._12*B._23  +  A._13*B._33  +  A._14*B._43;
		_14 = A._11*B._14  +  A._12*B._24  +  A._13*B._34  +  A._14*B._44;

		_21 = A._21*B._11  +  A._22*B._21  +  A._23*B._31  +  A._24*B._41;
		_22 = A._21*B._12  +  A._22*B._22  +  A._23*B._32  +  A._24*B._42;
		_23 = A._21*B._13  +  A._22*B._23  +  A._23*B._33  +  A._24*B._43;
		_24 = A._21*B._14  +  A._22*B._24  +  A._23*B._34  +  A._24*B._44;

		_31 = A._31*B._11  +  A._32*B._21  +  A._33*B._31  +  A._34*B._41;
		_32 = A._31*B._12  +  A._32*B._22  +  A._33*B._32  +  A._34*B._42;
		_33 = A._31*B._13  +  A._32*B._23  +  A._33*B._33  +  A._34*B._43;
		_34 = A._31*B._14  +  A._32*B._24  +  A._33*B._34  +  A._34*B._44;

		_41 = A._41*B._11  +  A._42*B._21  +  A._43*B._31  +  A._44*B._41;
		_42 = A._41*B._12  +  A._42*B._22  +  A._43*B._32  +  A._44*B._42;
		_43 = A._41*B._13  +  A._42*B._23  +  A._43*B._33  +  A._44*B._43;
		_44 = A._41*B._14  +  A._42*B._24  +  A._43*B._34  +  A._44*B._44;

		return this;
	}

	public function scaleAll(s:Number):M44
	{
		_11 = _22 = _33 = s;
		_12=_13=_14 = _21=_23=_24 = _31=_32=_34 = _41=_42=_43 = 0;
		_44 = 1;			

		return this;
	}

	public function scaleXYZ(x:Number, y:Number, z:Number):M44
	{
		_11 = x;
		_22 = y;
		_33 = z;
		_12=_13=_14 = _21=_23=_24 = _31=_32=_34 = _41=_42=_43 = 0;
		_44 = 1;			

		return this;
	}

	public function rotX(r:Number):M44
	{
		_22 = Math.cos(r);
		_23 = Math.sin(r);
		_32 = -_23;
		_33 = _22;

		_12=_13=_14 = _21=_24 = _31=_34 = _41=_42=_43 = 0;
		_11 = _44 = 1;			

		return this;
	}

	public function rotY(r:Number):M44
	{
		_11 = Math.cos(r);
		_13 = -Math.sin(r);
		_31 = -_13;
		_33 = _11;

		_12=_14 = _21=_23=_24 = _32=_34 = _41=_42=_43 = 0;
		_22 = _44 = 1;			

		return this;
	}

	public function rotZ(r:Number):M44
	{
		_11 = Math.cos(r);
		_12 = Math.sin(r);
		_21 = -_12;
		_22 = _11;

		_13=_14 = _23=_24 = _31=_32=_34 = _41=_42=_43 = 0;
		_33 = _44 = 1;			

		return this;
	}

	public function perspectiveProj(fov:Number, aspct:Number, zn:Number, zf:Number):M44
	{
		var h:Number = 1.0 / Math.tan(fov/2.0);
		var w:Number = h / aspct;

		_11 = w;  _12 = 0;              _13 = 0; _14 = 0;
		_21 = 0;  _22 = h;              _23 = 0; _24 = 0;
		_31 = 0;  _32 = 0; _33 =     zf/(zf-zn); _34 = 1;
		_41 = 0;  _42 = 0; _43 = -zn*zf/(zf-zn); _44 = 0;

		return this;
	}

	public function lookAtLH(aUp:Vec3, aFrom:Vec3, aAt:Vec3):M44
	{
		var aX:Vec3 = new Vec3();
		var aY:Vec3 = new Vec3();

		var aZ:Vec3 = new Vec3(aAt.x, aAt.y, aAt.z);
		aZ.sub(aFrom).normalize();

		aX.cp(aUp, aZ).normalize();
		aY.cp(aZ, aX);

		_11 = aX.x;  _12 = aY.x;  _13 = aZ.x;  _14 = 0;
		_21 = aX.y;  _22 = aY.y;  _23 = aZ.y;  _24 = 0;
		_31 = aX.z;  _32 = aY.z;  _33 = aZ.z;  _34 = 0;

		_41 = -aFrom.dpWith(aX);
		_42 = -aFrom.dpWith(aY);
		_43 = -aFrom.dpWith(aZ);
		_44 = 1;

		return this;
	}

	public function translate(x:Number, y:Number, z:Number):M44
	{
		this._11 = 1;  this._12 = 0;  this._13 = 0;  this._14 = 0;
		this._21 = 0;  this._22 = 1;  this._23 = 0;  this._24 = 0;
		this._31 = 0;  this._32 = 0;  this._33 = 1;  this._34 = 0;

		this._41 = x;  this._42 = y;  this._43 = z;  this._44 = 1;
		return this;
	}

	public function transpose33():M44 {
		var t:Number;

		t = this._12;
		this._12 = this._21;
		this._21 = t;

		t = this._13;
		this._13 = this._31;
		this._31 = t;

		t = this._23;
		this._23 = this._32;
		this._32 = t;

		return this;
	}

	// OpenGL style rotation
	public function glRotate(angle:Number, x:Number, y:Number, z:Number):M44
	{
		var s:Number = Math.sin( angle );
		var c:Number = Math.cos( angle );

		var xx:Number = x * x;
		var yy:Number = y * y;
		var zz:Number = z * z;
		var xy:Number = x * y;
		var yz:Number = y * z;
		var zx:Number = z * x;
		var xs:Number = x * s;
		var ys:Number = y * s;
		var zs:Number = z * s;
		var one_c:Number = 1.0 - c;

		this._11 = (one_c * xx) + c;
		this._12 = (one_c * xy) - zs;
		this._13 = (one_c * zx) + ys;
		this._14 = 0;

		this._21 = (one_c * xy) + zs;
		this._22 = (one_c * yy) + c;
		this._23 = (one_c * yz) - xs;
		this._24 = 0;

		this._31 = (one_c * zx) - ys;
		this._32 = (one_c * yz) + xs;
		this._33 = (one_c * zz) + c;
		this._34 = 0;

		this._41 = 0;
		this._42 = 0;
		this._43 = 0;
		this._44 = 1;

		return this;
	}

}






/* -------------------------------------- */

class MikuData {
public var MESH:Object;
function MikuData(){
MESH = {
groups: [
	{vertices: 1214, faces: 1127}, /* body*/
	{vertices: 98,   faces: 172 }, /* arm */
	{vertices: 52,   faces: 96  }  /* negi */
],
poss: [
35.878300,116.563200,4.016700,// 0
31.774500,115.484900,5.498000,// 1
38.149300,96.219400,-4.500900,// 2
34.045500,95.141100,-3.019600,// 3
29.400300,103.248500,-23.622200,// 4
25.296500,102.170300,-22.140900,// 5
27.129300,123.592400,-15.104600,// 6
23.025500,122.514100,-13.623300,// 7
0.000000,117.679000,-8.242800,// 8
0.000000,117.310800,8.633000,// 9
11.706500,116.468700,3.857700,// 10
16.555500,114.435900,-7.671000,// 11
11.706500,112.403100,-19.199600,// 12
0.000000,111.561100,-23.974900,// 13
0.000000,110.512500,24.083200,// 14
21.630700,108.956600,15.259600,// 15
30.590500,105.200500,-6.042500,// 16
21.630700,101.444300,-27.344600,// 17
0.000000,99.888500,-36.168300,// 18
0.000000,98.319100,35.755900,// 19
28.261900,96.286300,24.227200,// 20
39.968400,91.378700,-3.605400,// 21
28.261900,86.471000,-31.437900,// 22
0.000000,84.438200,-42.966500,// 23
0.000000,82.587000,41.873700,// 24
30.590500,80.386700,29.395200,// 25
43.261500,75.074700,-0.730500,// 26
30.590500,69.762700,-30.856300,// 27
0.000000,67.562400,-43.334800,// 28
0.000000,69.190400,41.505500,// 29
28.261900,63.678400,29.976900,// 30
39.968400,58.770800,2.144300,// 31
28.261900,53.863100,-25.688300,// 32
0.000000,51.830300,-37.216900,// 33
21.630700,48.705100,25.883600,// 34
30.590500,44.949000,4.581500,// 35
21.630700,41.192800,-16.720700,// 36
0.000000,39.637000,-25.544300,// 37
0.000000,38.588300,22.513900,// 38
11.706500,37.746300,17.738500,// 39
16.555500,35.713500,6.209900,// 40
11.706400,34.755900,-10.567100,// 41
0.000000,34.322900,-14.372100,// 42
5.853200,35.108400,12.260100,// 43
0.000000,35.529400,14.647800,// 44
0.000000,32.654600,-1.656100,// 45
5.853200,33.075600,0.731500,// 46
8.277700,34.092000,6.495800,// 47
0.000000,20.574800,5.783400,// 48
5.375100,21.978500,11.183800,// 49
0.000000,21.939600,13.409900,// 50
0.000000,22.204900,-1.790800,// 51
5.375100,22.166100,0.435300,// 52
7.601500,22.072300,5.809600,// 53
10.827300,68.508600,39.865100,// 54
0.000000,50.079700,40.008700,// 55
0.000000,36.454600,39.145100,// 56
12.632700,35.783000,34.923300,// 57
11.597700,49.983700,37.241200,// 58
0.000000,112.916900,12.990800,// 59
21.630700,108.336700,11.743700,// 60
32.130000,94.398700,14.537100,// 61
35.865700,78.499100,19.705100,// 62
33.537200,61.790800,20.286700,// 63
25.861300,47.757000,16.346600,// 64
0.000000,121.582000,-8.931000,// 65
0.000000,121.138800,9.472600,// 66
12.761200,120.220900,4.267100,// 67
18.047100,118.005000,-8.300300,// 68
12.761200,115.789000,-20.867600,// 69
0.000000,114.871100,-26.073200,// 70
0.000000,116.533100,14.582000,// 71
23.727800,111.448500,12.692500,// 72
33.281500,107.866600,-6.512600,// 73
23.533600,103.780000,-29.688700,// 74
0.000000,102.087300,-39.288500,// 75
35.565400,96.055200,15.690000,// 76
43.403800,92.788000,-3.853900,// 77
30.691100,87.458600,-34.078700,// 78
0.000000,85.251100,-46.598300,// 79
39.549500,78.764100,21.207800,// 80
46.945200,75.074700,-0.730500,// 81
33.195300,69.310400,-33.421500,// 82
0.000000,66.922800,-46.962600,// 83
36.972600,60.628500,21.936600,// 84
43.403800,57.361400,2.392800,// 85
30.691100,52.031900,-27.832100,// 86
0.000000,49.824400,-40.351600,// 87
30.644300,46.799400,23.895700,// 88
33.281500,42.282900,5.051600,// 89
23.533600,38.196300,-18.124500,// 90
0.000000,36.503600,-27.724300,// 91
12.761200,34.194500,-10.503400,// 92
0.000000,33.758400,-15.611700,// 93
27.279200,42.650000,5.654300,// 94
6.758900,34.319200,-7.778500,// 95
22.635200,35.997700,31.912700,// 96
10.478300,27.547100,-16.741100,// 97
0.000000,33.829000,6.117600,// 98
0.000000,31.334300,16.984400,// 99
7.684000,31.334300,13.801600,// 100
10.866800,31.334300,6.117600,// 101
7.684000,31.334300,-1.566400,// 102
0.000000,31.334300,-4.749200,// 103
15.679600,-32.213900,51.107900,// 104
27.606600,-29.068500,40.197800,// 105
35.801100,-25.266700,13.858500,// 106
27.606600,-29.068500,-12.480800,// 107
0.000000,-32.508300,-23.390900,// 108
0.000000,-10.264600,13.858500,// 109
0.000000,12.728200,35.310700,// 110
17.463800,12.714500,27.115500,// 111
24.886100,11.809300,12.399400,// 112
16.739200,13.076600,-7.385500,// 113
0.000000,12.728200,-15.580900,// 114
0.000000,-14.783100,45.483800,// 115
20.343000,-14.783100,36.082600,// 116
29.744200,-14.783100,13.386000,// 117
20.343000,-14.783100,-9.310500,// 118
0.000000,-14.783100,-18.711700,// 119
16.103400,24.041100,8.464000,// 120
11.066400,24.514500,-3.740000,// 121
11.337000,24.379300,18.774700,// 122
0.000000,24.384400,-8.795100,// 123
0.000000,24.384400,23.829800,// 124
0.000000,31.136400,21.734900,// 125
14.506700,19.904800,26.290600,// 126
0.000000,31.297400,-5.602300,// 127
0.000000,33.104700,-5.522700,// 128
10.093100,35.187700,8.060400,// 129
13.336700,30.033300,9.946700,// 130
6.278100,34.478600,-2.134400,// 131
10.525600,30.644400,-0.699100,// 132
6.592200,33.472300,16.201900,// 133
13.850600,24.371100,18.996000,// 134
0.000000,28.946000,21.734800,// 135
0.000000,30.756600,-2.957900,// 136
9.920100,31.760400,8.060400,// 137
6.105100,32.130400,0.430500,// 138
6.419200,30.045000,16.201800,// 139
41.654600,94.219900,8.666000,// 140
41.654600,69.477100,8.666000,// 141
47.777400,94.219900,8.666000,// 142
47.777400,69.477100,8.666000,// 143
47.777400,94.219900,-5.772200,// 144
47.777400,69.477100,-5.772200,// 145
41.654600,94.219900,-5.772200,// 146
41.654600,69.477100,-5.772200,// 147
28.694600,117.531100,-6.345400,// 148
34.729600,113.967400,1.167600,// 149
39.440700,116.422700,-1.032900,// 150
41.392100,117.439600,-6.345400,// 151
39.440700,116.422700,-11.657900,// 152
34.729600,113.967400,-13.858400,// 153
30.018500,111.512100,-11.657900,// 154
30.018500,111.512100,-1.032900,// 155
74.266900,-80.882700,-33.357900,// 156
89.705400,-76.846200,-40.370100,// 157
96.100300,-71.470200,-58.371000,// 158
89.705400,-67.904000,-76.816000,// 159
74.266900,-68.236500,-84.900200,// 160
58.828300,-72.273100,-77.888000,// 161
58.828300,-81.215300,-41.442100,// 162
74.266900,-100.905000,-65.593000,// 163
56.346000,85.179800,-6.148800,// 164
51.379000,81.961700,-3.109300,// 165
58.287500,87.353500,-14.022000,// 166
56.066100,87.209600,-22.116900,// 167
46.296000,79.584400,-6.684000,// 168
50.983200,84.832300,-25.691500,// 169
46.016200,81.614300,-22.652000,// 170
66.559900,-22.264400,-25.625900,// 171
82.792100,-14.182100,-29.697600,// 172
55.501900,-25.079600,-32.371300,// 173
87.081600,-9.777400,-43.234400,// 174
55.501900,-18.314000,-59.946400,// 175
82.792100,-7.416400,-57.272600,// 176
65.857500,-14.445700,-65.052100,// 177
6.713700,-27.169600,26.057400,// 178
14.390900,-26.957800,27.420100,// 179
21.390000,-26.403100,24.022300,// 180
25.037800,-25.717600,17.162000,// 181
23.940700,-25.162900,9.459400,// 182
18.518000,-24.951100,3.856700,// 183
10.840800,-25.162900,2.494000,// 184
3.841700,-25.717600,5.891800,// 185
0.194000,-26.403100,12.752200,// 186
1.291000,-26.957800,20.454800,// 187
6.593900,-95.568600,24.593000,// 188
12.603600,-95.808300,25.749000,// 189
18.077200,-96.446800,22.897500,// 190
20.923200,-97.258200,17.129200,// 191
20.054500,-97.932500,10.647400,// 192
15.803700,-98.194300,5.926400,// 193
9.794900,-97.932500,4.768500,// 194
4.322800,-97.258200,7.616900,// 195
1.476800,-96.446800,13.385200,// 196
2.344000,-95.808300,19.870100,// 197
10.563400,-106.770700,16.547500,// 198
7.842000,-69.505500,24.738600,// 199
14.969700,-69.499500,26.093400,// 200
2.814000,-69.499500,19.128000,// 201
21.474700,-69.496700,22.674600,// 202
1.806500,-69.496700,11.404500,// 203
25.410900,-69.519600,15.787700,// 204
5.204300,-69.519600,4.517600,// 205
24.403800,-69.559400,8.063300,// 206
11.709800,-69.559400,1.097900,// 207
18.837700,-69.579600,2.452200,// 208
14.709000,-82.777600,26.506400,// 209
7.758700,-82.631800,25.147700,// 210
21.048500,-83.172400,23.098600,// 211
2.852700,-82.777600,19.541100,// 212
24.355400,-83.686700,16.226800,// 213
1.864700,-83.172400,11.828500,// 214
23.366700,-84.124000,8.515600,// 215
5.171600,-83.686700,4.956600,// 216
18.460200,-84.296000,2.909900,// 217
11.510400,-84.124000,1.550300,// 218
8.016100,-56.329500,25.066000,// 219
15.695100,-56.171600,26.425300,// 220
2.595200,-56.171600,19.460000,// 221
22.699500,-55.771300,23.017800,// 222
1.503400,-55.771300,11.747600,// 223
26.354700,-55.302700,16.143200,// 224
5.158600,-55.302700,4.873100,// 225
25.264700,-54.944800,8.427600,// 226
12.164800,-54.944800,1.462200,// 227
19.844800,-54.813100,2.819600,// 228
11.852800,-102.520700,23.971800,// 229
7.332800,-102.285300,23.095300,// 230
4.131000,-102.520700,19.547100,// 231
3.470400,-103.137000,14.682400,// 232
5.603300,-103.898800,10.359500,// 233
9.714900,-104.515100,8.229500,// 234
14.234900,-104.750400,9.106000,// 235
17.436700,-104.515100,12.654200,// 236
18.097400,-103.898800,17.518800,// 237
15.964500,-103.137000,21.841700,// 238
17.180400,22.563400,8.861500,// 239
45.801300,-36.555000,13.286000,// 240
23.042000,20.723000,6.975600,// 241
65.542200,-24.940800,9.658400,// 242
20.869600,19.684600,-5.300700,// 243
61.153100,-27.523000,-22.493300,// 244
14.886400,21.503500,-4.273400,// 245
41.412200,-39.137200,-18.865700,// 246
19.144600,25.251500,0.331700,// 247
10.916800,26.095400,1.744300,// 248
68.261100,-23.341200,-7.320400,// 249
38.693300,-40.736800,-1.886900,// 250
27.915500,14.399600,7.516300,// 251
23.013900,13.746500,8.729600,// 252
29.947900,15.413000,-0.663900,// 253
16.889300,13.531500,0.819500,// 254
28.937700,12.428200,-8.163400,// 255
20.172500,13.146100,-6.950000,// 256
49.703500,-11.928300,8.047200,// 257
51.946200,-10.680500,-4.589900,// 258
37.295600,-18.351000,10.519000,// 259
47.775300,-14.074400,-16.076900,// 260
30.988100,-20.359700,-1.089900,// 261
33.848000,-19.958000,-13.605100,// 262
-35.878300,116.563200,4.016700,// 263
-31.774500,115.484900,5.498000,// 264
-38.149300,96.219400,-4.500900,// 265
-34.045500,95.141100,-3.019600,// 266
-29.400300,103.248500,-23.622200,// 267
-25.296500,102.170300,-22.140900,// 268
-27.129300,123.592400,-15.104600,// 269
-23.025500,122.514100,-13.623300,// 270
-11.706500,116.468700,3.857700,// 271
-16.555500,114.435900,-7.671000,// 272
-11.706500,112.403100,-19.199600,// 273
-21.630700,108.956600,15.259600,// 274
-30.590500,105.200500,-6.042500,// 275
-21.630700,101.444300,-27.344600,// 276
-28.261900,96.286300,24.227200,// 277
-39.968400,91.378700,-3.605400,// 278
-28.261900,86.471000,-31.437900,// 279
-30.590500,80.386700,29.395200,// 280
-43.261500,75.074700,-0.730500,// 281
-30.590500,69.762700,-30.856300,// 282
-28.261900,63.678400,29.976900,// 283
-39.968400,58.770800,2.144300,// 284
-28.261900,53.863100,-25.688300,// 285
-21.630700,48.705100,25.883600,// 286
-30.590500,44.949000,4.581500,// 287
-21.630700,41.192800,-16.720700,// 288
-11.706500,37.746300,17.738500,// 289
-16.555500,35.713500,6.209900,// 290
-11.706400,34.755900,-10.567100,// 291
-5.853200,35.108400,12.260100,// 292
-5.853200,33.075600,0.731500,// 293
-8.277700,34.092000,6.495800,// 294
-5.375100,21.978500,11.183800,// 295
-5.375100,22.166100,0.435300,// 296
-7.601500,22.072300,5.809600,// 297
-10.827300,68.508600,38.871500,// 298
-12.632700,35.783000,34.923300,// 299
-11.597700,49.983700,37.241200,// 300
-21.630700,108.336700,11.743700,// 301
-32.130000,94.398700,14.537100,// 302
-35.865700,78.499100,19.705100,// 303
-33.537200,61.790800,20.286700,// 304
-25.861300,47.757000,16.346600,// 305
-12.761200,120.220900,4.267100,// 306
-18.047100,118.005000,-8.300300,// 307
-12.761200,115.789000,-20.867600,// 308
-23.727800,111.448500,12.692500,// 309
-33.281500,107.866600,-6.512600,// 310
-23.533600,103.780000,-29.688700,// 311
-35.565400,96.055200,15.690000,// 312
-43.403800,92.788000,-3.853900,// 313
-30.691100,87.458600,-34.078700,// 314
-39.549500,78.764100,21.207800,// 315
-46.945200,75.074700,-0.730500,// 316
-33.195300,69.310400,-33.421500,// 317
-36.972600,60.628500,21.936600,// 318
-43.403800,57.361400,2.392800,// 319
-30.691100,52.031900,-27.832100,// 320
-30.644300,46.799400,23.895700,// 321
-33.281500,42.282900,5.051600,// 322
-23.533600,38.196300,-18.124500,// 323
-12.761200,34.194500,-10.503400,// 324
-27.279200,42.650000,5.654300,// 325
-6.758900,34.319200,-7.778500,// 326
-22.635200,35.997700,31.912700,// 327
-10.478300,27.547100,-16.741100,// 328
-7.684000,31.334300,13.801600,// 329
-10.866800,31.334300,6.117600,// 330
-7.684000,31.334300,-1.566400,// 331
-15.679600,-32.213900,51.107900,// 332
-27.606600,-29.068500,40.197800,// 333
-35.801100,-25.266700,13.858500,// 334
-27.606600,-29.068500,-12.480800,// 335
-17.463800,12.714500,27.115500,// 336
-24.886100,11.809300,12.399400,// 337
-16.739200,13.076600,-7.385500,// 338
-20.343000,-14.783100,36.082600,// 339
-29.744200,-14.783100,13.386000,// 340
-20.343000,-14.783100,-9.310500,// 341
-16.103400,24.041100,8.464000,// 342
-11.066400,24.514500,-3.740000,// 343
-11.337000,24.379300,18.774700,// 344
-14.506700,19.904800,26.290600,// 345
-10.093100,35.187700,8.060400,// 346
-13.336700,30.033300,9.946700,// 347
-6.278100,34.478600,-2.134400,// 348
-10.525600,30.644400,-0.699100,// 349
-6.592200,33.472300,16.201900,// 350
-13.850600,24.371100,18.996000,// 351
-9.920100,31.760400,8.060400,// 352
-6.105100,32.130400,0.430500,// 353
-6.419200,30.045000,16.201800,// 354
-41.654600,94.219900,8.666000,// 355
-41.654600,69.477100,8.666000,// 356
-47.777400,94.219900,8.666000,// 357
-47.777400,69.477100,8.666000,// 358
-47.777400,94.219900,-5.772200,// 359
-47.777400,69.477100,-5.772200,// 360
-41.654600,94.219900,-5.772200,// 361
-41.654600,69.477100,-5.772200,// 362
-28.694600,117.531100,-6.345400,// 363
-34.729600,113.967400,1.167600,// 364
-39.440700,116.422700,-1.032900,// 365
-41.392100,117.439600,-6.345400,// 366
-39.440700,116.422700,-11.657900,// 367
-34.729600,113.967400,-13.858400,// 368
-30.018500,111.512100,-11.657900,// 369
-30.018500,111.512100,-1.032900,// 370
-74.266900,-80.882700,-33.357900,// 371
-89.705400,-76.846200,-40.370100,// 372
-96.100300,-71.470200,-58.371000,// 373
-89.705400,-67.904000,-76.816000,// 374
-74.266900,-68.236500,-84.900200,// 375
-58.828300,-72.273100,-77.888000,// 376
-58.828300,-81.215300,-41.442100,// 377
-74.266900,-100.905000,-65.593000,// 378
-56.346000,85.179800,-6.148800,// 379
-51.379000,81.961700,-3.109300,// 380
-58.287500,87.353500,-14.022000,// 381
-56.066100,87.209600,-22.116900,// 382
-46.296000,79.584400,-6.684000,// 383
-50.983200,84.832300,-25.691500,// 384
-46.016200,81.614300,-22.652000,// 385
-66.559900,-22.264400,-25.625900,// 386
-82.792100,-14.182100,-29.697600,// 387
-55.501900,-25.079600,-32.371300,// 388
-87.081600,-9.777400,-43.234400,// 389
-55.501900,-18.314000,-59.946400,// 390
-82.792100,-7.416400,-57.272600,// 391
-65.857500,-14.445700,-65.052100,// 392
-6.713700,-27.169600,26.057400,// 393
-14.390900,-26.957800,27.420100,// 394
-21.390000,-26.403100,24.022300,// 395
-25.037800,-25.717600,17.162000,// 396
-23.940700,-25.162900,9.459400,// 397
-18.518000,-24.951100,3.856700,// 398
-10.840800,-25.162900,2.494000,// 399
-3.841700,-25.717600,5.891800,// 400
-0.194000,-26.403100,12.752200,// 401
-1.291000,-26.957800,20.454800,// 402
-6.593900,-95.568600,24.593000,// 403
-12.603600,-95.808300,25.749000,// 404
-18.077200,-96.446800,22.897500,// 405
-20.923200,-97.258200,17.129200,// 406
-20.054500,-97.932500,10.647400,// 407
-15.803700,-98.194300,5.926400,// 408
-9.794900,-97.932500,4.768500,// 409
-4.322800,-97.258200,7.616900,// 410
-1.476800,-96.446800,13.385200,// 411
-2.344000,-95.808300,19.870100,// 412
-10.563400,-106.770700,16.547500,// 413
-7.842000,-69.505500,24.738600,// 414
-14.969700,-69.499500,26.093400,// 415
-2.814000,-69.499500,19.128000,// 416
-21.474700,-69.496700,22.674600,// 417
-1.806500,-69.496700,11.404500,// 418
-25.410900,-69.519600,15.787700,// 419
-5.204300,-69.519600,4.517600,// 420
-24.403800,-69.559400,8.063300,// 421
-11.709800,-69.559400,1.097900,// 422
-18.837700,-69.579600,2.452200,// 423
-14.709000,-82.777600,26.506400,// 424
-7.758700,-82.631800,25.147700,// 425
-21.048500,-83.172400,23.098600,// 426
-2.852700,-82.777600,19.541100,// 427
-24.355400,-83.686700,16.226800,// 428
-1.864700,-83.172400,11.828500,// 429
-23.366700,-84.124000,8.515600,// 430
-5.171600,-83.686700,4.956600,// 431
-18.460200,-84.296000,2.909900,// 432
-11.510400,-84.124000,1.550300,// 433
-8.016100,-56.329500,25.066000,// 434
-15.695100,-56.171600,26.425300,// 435
-2.595200,-56.171600,19.460000,// 436
-22.699500,-55.771300,23.017800,// 437
-1.503400,-55.771300,11.747600,// 438
-26.354700,-55.302700,16.143200,// 439
-5.158600,-55.302700,4.873100,// 440
-25.264700,-54.944800,8.427600,// 441
-12.164800,-54.944800,1.462200,// 442
-19.844800,-54.813100,2.819600,// 443
-11.852800,-102.520700,23.971800,// 444
-7.332800,-102.285300,23.095300,// 445
-4.131000,-102.520700,19.547100,// 446
-3.470400,-103.137000,14.682400,// 447
-5.603300,-103.898800,10.359500,// 448
-9.714900,-104.515100,8.229500,// 449
-14.234900,-104.750400,9.106000,// 450
-17.436700,-104.515100,12.654200,// 451
-18.097400,-103.898800,17.518800,// 452
-15.964500,-103.137000,21.841700,// 453
48.853800,-27.801400,5.385300,// 454
54.758500,-34.685300,5.385300,// 455
52.718100,-24.486900,5.385300,// 456
58.622800,-31.370800,5.385300,// 457
52.718100,-24.486900,0.294300,// 458
58.622800,-31.370800,0.294300,// 459
48.853800,-27.801400,0.294300,// 460
54.758500,-34.685300,0.294300,// 461
57.002900,-36.324200,4.853400,// 462
59.900900,-33.838600,4.853400,// 463
59.900900,-33.838600,0.826200,// 464
57.002900,-36.324200,0.826200,// 465
22.270300,-21.609500,-6.112500,// 466
19.796600,-23.399100,-7.967700,// 467
21.651100,-19.215800,33.489600,// 468
19.212100,-21.058700,35.444600,// 469
45.678200,-46.426200,13.713000,// 470
47.616800,-49.372100,13.713000,// 471
36.022300,-38.383100,34.009400,// 472
34.612100,-40.982900,36.078300,// 473
36.692300,-40.337900,-7.297000,// 474
35.269900,-43.128900,-9.203700,// 475
43.619700,-43.775300,26.828300,// 476
44.750200,-46.548900,28.919900,// 477
44.344100,-44.710000,0.169000,// 478
45.664400,-47.554900,-1.802900,// 479
28.896200,-32.224400,35.676500,// 480
26.490900,-34.041800,37.903000,// 481
29.508400,-34.639400,-8.661800,// 482
27.034700,-36.429000,-10.805800,// 483
-46.160200,76.978700,8.046700,// 484
-28.386900,50.125000,33.309000,// 485
-45.203900,77.677400,7.973700,// 486
-27.668600,51.026000,33.025500,// 487
-44.176000,74.257700,6.804900,// 488
-26.610800,49.363300,30.421000,// 489
-45.132400,73.559000,6.877900,// 490
-27.329100,48.462300,30.704500,// 491
-33.138700,53.985000,25.170700,// 492
-33.936200,53.135100,25.393900,// 493
-34.187500,55.653100,27.775500,// 494
-34.985900,54.803800,27.997900,// 495
-40.932200,63.718600,15.939700,// 496
-41.814100,62.938800,16.089200,// 497
-41.970700,65.392600,18.544800,// 498
-42.853400,64.613500,18.693500,// 499
-29.703900,50.488900,33.979000,// 500
-23.296300,46.917100,38.861300,// 501
-28.384000,52.144600,33.458000,// 502
-21.976400,48.572900,38.340300,// 503
-26.440200,49.089100,28.671700,// 504
-20.032700,45.517300,33.554100,// 505
-27.760100,47.433300,29.192700,// 506
-21.352600,43.861600,34.075000,// 507
0.000000,-17.275200,17.118500,// 508
0.000000,-17.275200,40.778200,// 509
13.906800,-17.275200,36.259600,// 510
22.501700,-17.275200,24.429700,// 511
22.501700,-17.275200,9.807300,// 512
13.906800,-17.275200,-2.022500,// 513
0.000000,-17.275200,-6.541100,// 514
-13.906800,-17.275200,-2.022500,// 515
-22.501700,-17.275200,9.807300,// 516
-22.501700,-17.275200,24.429700,// 517
-13.906800,-17.275200,36.259600,// 518
0.000000,-43.490400,57.462300,// 519
23.713500,-43.490400,49.757300,// 520
38.369200,-43.490400,29.585400,// 521
38.369200,-43.490400,4.651600,// 522
23.713500,-43.490400,-15.520300,// 523
0.000000,-43.490400,-23.225300,// 524
-23.713500,-43.490400,-15.520300,// 525
-38.369200,-43.490400,4.651600,// 526
-38.369200,-43.490400,29.585400,// 527
-23.713500,-43.490400,49.757300,// 528
0.000000,-20.304400,17.118500,// 529
5.301600,26.862900,24.181900,// 530
5.301600,25.125100,22.554400,// 531
8.620600,-9.198000,44.047100,// 532
4.547300,21.414000,30.000100,// 533
4.547300,19.676200,28.372600,// 534
-5.301600,25.125100,22.554400,// 535
0.000000,-22.920700,50.752700,// 536
-5.301600,26.862900,24.181900,// 537
8.620600,-8.498900,46.323000,// 538
6.252200,13.019000,34.024400,// 539
6.252200,14.756800,35.651800,// 540
-8.620600,-8.498900,46.323000,// 541
-8.620600,-9.198000,44.047100,// 542
-4.547300,21.414000,30.000100,// 543
-4.547300,19.676200,28.372600,// 544
-6.252200,13.019000,34.024400,// 545
-6.252200,14.756800,35.651800,// 546
48.853800,-27.801400,-0.535900,// 547
54.758500,-34.685300,-0.535900,// 548
52.718100,-24.486900,-0.535900,// 549
58.622800,-31.370800,-0.535900,// 550
52.718100,-24.486900,-5.626900,// 551
58.622800,-31.370800,-5.626900,// 552
48.853800,-27.801400,-5.626900,// 553
54.758500,-34.685300,-5.626900,// 554
57.002900,-36.324200,-1.067800,// 555
59.900900,-33.838600,-1.067800,// 556
59.900900,-33.838600,-5.095000,// 557
57.002900,-36.324200,-5.095000,// 558
48.853800,-27.801400,-6.095300,// 559
54.758500,-34.685300,-6.095300,// 560
52.718100,-24.486900,-6.095300,// 561
58.622800,-31.370800,-6.095300,// 562
52.718100,-24.486900,-11.186300,// 563
58.622800,-31.370800,-11.186300,// 564
48.853800,-27.801400,-11.186300,// 565
54.758500,-34.685300,-11.186300,// 566
57.002900,-36.324200,-6.627200,// 567
59.900900,-33.838600,-6.627200,// 568
59.900900,-33.838600,-10.654400,// 569
57.002900,-36.324200,-10.654400,// 570
48.853800,-27.801400,-11.452000,// 571
54.758500,-34.685300,-11.452000,// 572
52.718100,-24.486900,-11.452000,// 573
58.622800,-31.370800,-11.452000,// 574
52.718100,-24.486900,-16.543000,// 575
58.622800,-31.370800,-16.543000,// 576
48.853800,-27.801400,-16.543000,// 577
54.758500,-34.685300,-16.543000,// 578
57.002900,-36.324200,-11.983900,// 579
59.900900,-33.838600,-11.983900,// 580
59.900900,-33.838600,-16.011100,// 581
57.002900,-36.324200,-16.011100,// 582
35.878300,116.563200,4.016700,// 583
31.774500,115.484900,5.498000,// 584
38.149300,96.219400,-4.500900,// 585
34.045500,95.141100,-3.019600,// 586
29.400300,103.248500,-23.622200,// 587
25.296500,102.170300,-22.140900,// 588
27.129300,123.592400,-15.104600,// 589
23.025500,122.514100,-13.623300,// 590
-35.878300,116.563200,4.016700,// 591
-31.774500,115.484900,5.498000,// 592
-38.149300,96.219400,-4.500900,// 593
-34.045500,95.141100,-3.019600,// 594
-29.400300,103.248500,-23.622200,// 595
-25.296500,102.170300,-22.140900,// 596
-27.129300,123.592400,-15.104600,// 597
-23.025500,122.514100,-13.623300,// 598
22.270300,-21.609500,-6.112500,// 599
19.796600,-23.399100,-7.967700,// 600
21.651100,-19.215800,33.489600,// 601
19.212100,-21.058700,35.444600,// 602
45.678200,-46.426200,13.713000,// 603
47.616800,-49.372100,13.713000,// 604
36.022300,-38.383100,34.009400,// 605
34.612100,-40.982900,36.078300,// 606
36.692300,-40.337900,-7.297000,// 607
35.269900,-43.128900,-9.203700,// 608
43.619700,-43.775300,26.828300,// 609
44.750200,-46.548900,28.919900,// 610
44.344100,-44.710000,0.169000,// 611
45.664400,-47.554900,-1.802900,// 612
28.896200,-32.224400,35.676500,// 613
26.490900,-34.041800,37.903000,// 614
29.508400,-34.639400,-8.661800,// 615
27.034700,-36.429000,-10.805800,// 616
0.000000,118.663800,-8.416400,// 617
0.000000,118.287600,8.847300,// 618
11.975600,117.426100,3.962200,// 619
16.936100,115.346600,-7.831600,// 620
11.975600,113.267100,-19.625200,// 621
0.000000,112.405700,-24.510300,// 622
0.000000,111.333400,24.654300,// 623
22.129200,109.741600,15.627400,// 624
31.295500,105.899000,-6.165700,// 625
22.129200,102.056200,-27.958700,// 626
0.000000,100.464500,-36.985700,// 627
0.000000,98.858100,36.598200,// 628
28.914600,96.778400,24.803200,// 629
40.891500,91.757400,-3.672200,// 630
28.914600,86.736400,-32.147500,// 631
0.000000,84.656600,-43.942400,// 632
-0.015400,82.744500,42.861100,// 633
31.255400,80.515700,30.130900,// 634
44.261500,75.074700,-0.730500,// 635
31.297600,69.639900,-31.552700,// 636
0.000000,67.388800,-44.319600,// 637
-0.044100,69.137600,42.503100,// 638
28.945400,63.409100,30.655400,// 639
40.891500,58.392100,2.211100,// 640
28.914600,53.371000,-26.264300,// 641
0.000000,51.291300,-38.059200,// 642
22.249200,48.082300,26.362600,// 643
31.295500,44.250500,4.704700,// 644
22.129400,40.416300,-17.105800,// 645
0.000000,38.824900,-26.127800,// 646
0.000000,37.588700,22.542800,// 647
11.996500,36.879200,18.143400,// 648
16.936100,34.798100,6.340600,// 649
11.971300,33.811600,-10.762300,// 650
0.000000,33.363600,-14.654500,// 651
6.339700,34.475000,12.861900,// 652
0.000000,34.910500,15.433300,// 653
0.000000,31.977100,-2.391600,// 654
6.441100,32.413200,0.267100,// 655
9.011700,33.422900,6.612600,// 656
0.000000,19.575000,5.765900,// 657
5.891300,21.286100,11.687800,// 658
0.000000,21.242700,14.127100,// 659
0.000000,21.557600,-2.553000,// 660
5.901700,21.508000,-0.102900,// 661
8.336200,21.394000,5.797600,// 662
11.158300,68.480600,40.808300,// 663
0.000000,50.009000,41.006200,// 664
0.000000,35.667500,39.762000,// 665
13.324100,35.067200,35.020900,// 666
11.372300,49.404700,37.929700,// 667
0.000000,34.829000,6.117600,// 668
0.000000,32.210000,17.467200,// 669
8.045400,32.196200,14.157300,// 670
11.414100,32.171200,6.107700,// 671
8.095000,32.145300,-1.982700,// 672
0.000000,32.146700,-5.332300,// 673
15.249300,-33.109900,51.217600,// 674
28.273200,-29.754100,40.490300,// 675
36.527500,-25.953900,13.857900,// 676
28.144100,-29.824200,-12.855000,// 677
0.000000,-33.344800,-23.938900,// 678
0.000000,-11.264600,13.851000,// 679
0.000000,13.267700,36.152700,// 680
18.084700,13.202000,27.729400,// 681
25.804000,12.205300,12.422700,// 682
17.431100,13.404700,-8.028600,// 683
0.000000,13.045700,-16.529200,// 684
0.000000,-14.657400,46.475900,// 685
21.005600,-14.390300,36.720300,// 686
30.682300,-14.436800,13.384200,// 687
21.026100,-14.477900,-9.973900,// 688
0.000000,-14.598300,-19.694500,// 689
16.916100,24.623800,8.461400,// 690
11.690100,25.015200,-4.340300,// 691
11.876700,25.037800,19.299200,// 692
0.000000,24.887500,-9.659300,// 693
0.000000,25.086100,24.542200,// 694
28.203800,118.402400,-6.345400,// 695
34.535400,114.301800,2.089800,// 696
39.770300,117.125900,-0.403000,// 697
41.884300,118.310100,-6.344800,// 698
39.656900,117.217600,-12.224800,// 699
34.446400,114.474700,-14.672300,// 700
29.140500,111.472100,-12.134800,// 701
29.167500,111.356100,-0.531500,// 702
74.309700,-81.434300,-32.524900,// 703
90.448800,-77.261400,-39.845700,// 704
97.070000,-71.707600,-58.429200,// 705
90.448800,-68.029300,-77.473000,// 706
74.309200,-68.338400,-85.894100,// 707
58.040700,-72.521800,-78.451700,// 708
58.040700,-81.696700,-41.057600,// 709
74.507900,-101.847600,-65.824300,// 710
57.104900,85.355000,-5.521600,// 711
51.413000,81.798000,-2.123400,// 712
59.211000,87.735700,-13.991000,// 713
56.726400,87.694600,-22.690300,// 714
45.484300,79.250000,-6.205200,// 715
50.861600,85.164200,-26.627000,// 716
45.140600,81.526100,-23.127000,// 717
66.467700,-22.447100,-24.647100,// 718
83.489100,-14.197500,-28.980700,// 719
54.645600,-25.242100,-31.881100,// 720
88.059800,-9.575900,-43.184900,// 721
54.635400,-18.209600,-60.434600,// 722
83.469100,-7.060500,-57.916800,// 723
65.722900,-14.109600,-65.984300,// 724
6.244800,-27.220500,26.939200,// 725
14.529600,-26.985300,28.410000,// 726
22.083500,-26.396800,24.742700,// 727
26.021600,-25.679900,17.337500,// 728
24.838600,-25.107900,9.022700,// 729
18.986900,-24.899600,2.975000,// 730
10.702000,-25.134800,1.504100,// 731
3.148200,-25.723700,5.171400,// 732
-0.789800,-26.441000,12.576700,// 733
0.393100,-27.012800,20.891500,// 734
6.104900,-95.686900,25.457200,// 735
12.731600,-95.982300,26.725400,// 736
18.750000,-96.687600,23.597000,// 737
21.857200,-97.561200,17.318800,// 738
20.913700,-98.287600,10.279100,// 739
16.259100,-98.570500,5.119500,// 740
9.632600,-98.267500,3.840400,// 741
3.608300,-97.499200,6.960000,// 742
0.498300,-96.596500,13.243200,// 743
1.444500,-95.913000,20.294300,// 744
10.486600,-107.758500,16.683200,// 745
7.350300,-69.497900,25.609400,// 746
15.117100,-69.501900,27.082500,// 747
1.905100,-69.507000,19.545000,// 748
22.168500,-69.536200,23.393700,// 749
0.820100,-69.510200,11.241000,// 750
26.389600,-69.588000,15.981200,// 751
4.488200,-69.522000,3.819700,// 752
25.300300,-69.619000,7.624300,// 753
11.562300,-69.559100,0.108800,// 754
19.306900,-69.604400,1.569500,// 755
14.856400,-82.804100,27.495100,// 756
7.259500,-82.612800,26.014000,// 757
21.764300,-83.257300,23.791700,// 758
1.940900,-82.749600,19.950700,// 759
25.329700,-83.836900,16.394500,// 760
0.877500,-83.171900,11.668700,// 761
24.267200,-84.299200,8.117700,// 762
4.447200,-83.740900,4.269300,// 763
18.952500,-84.453400,2.053800,// 764
11.356100,-84.241600,0.569300,// 765
7.546900,-56.362800,25.948500,// 766
15.834400,-56.201500,27.415100,// 767
1.696900,-56.211900,19.897500,// 768
23.394600,-55.808100,23.735800,// 769
0.519100,-55.798900,11.573000,// 770
27.339600,-55.318600,16.315600,// 771
4.464100,-55.297900,4.153600,// 772
26.163200,-54.938200,7.988700,// 773
12.025400,-54.916200,0.472400,// 774
20.314000,-54.792400,1.936700,// 775
11.904700,-103.140500,24.754900,// 776
6.936400,-102.881700,23.793300,// 777
3.432400,-103.124100,19.931600,// 778
2.708500,-103.784100,14.656100,// 779
5.034300,-104.615600,9.956600,// 780
9.551700,-105.294800,7.625000,// 781
14.532700,-105.547300,8.580500,// 782
18.046600,-105.280500,12.448800,// 783
18.764900,-104.611700,17.733600,// 784
16.425500,-103.798300,22.433400,// 785
17.147900,22.963600,9.777300,// 786
45.663800,-37.113600,14.103900,// 787
23.628200,21.409200,7.406300,// 788
66.258700,-24.876800,10.353000,// 789
21.032600,20.292400,-6.077900,// 790
61.628100,-27.495900,-23.372900,// 791
14.487700,21.813800,-5.136400,// 792
40.999800,-39.748900,-19.540800,// 793
19.554900,26.144600,0.147400,// 794
10.060800,26.610400,1.698800,// 795
69.248300,-23.441000,-7.444600,// 796
38.405000,-41.687200,-1.770400,// 797
28.460200,14.871400,8.209600,// 798
22.706600,13.598100,9.669600,// 799
30.664400,16.108800,-0.715000,// 800
15.986700,13.121000,0.949000,// 801
29.243200,12.968700,-8.947300,// 802
19.578600,13.044700,-7.748100,// 803
50.179400,-11.402500,8.752300,// 804
52.623100,-9.954100,-4.709100,// 805
36.872200,-18.450800,11.419400,// 806
47.998300,-13.568800,-16.910300,// 807
30.071200,-20.730700,-0.942800,// 808
33.155500,-20.068200,-14.318100,// 809
-11.975600,117.426100,3.962200,// 810
-16.936100,115.346600,-7.831600,// 811
-11.975600,113.267100,-19.625200,// 812
-22.129200,109.741600,15.627400,// 813
-31.295500,105.899000,-6.165700,// 814
-22.129200,102.056200,-27.958700,// 815
-28.914600,96.778400,24.803200,// 816
-40.891500,91.757400,-3.672200,// 817
-28.914600,86.736400,-32.147500,// 818
-31.248600,80.502700,30.139200,// 819
-44.261500,75.074700,-0.730500,// 820
-31.297600,69.639900,-31.552700,// 821
-28.930600,63.411600,30.670900,// 822
-40.891500,58.392100,2.211100,// 823
-28.914600,53.371000,-26.264300,// 824
-22.249200,48.082300,26.362600,// 825
-31.295500,44.250500,4.704700,// 826
-22.129400,40.416300,-17.105800,// 827
-11.996500,36.879200,18.143400,// 828
-16.936100,34.798100,6.340600,// 829
-11.971300,33.811600,-10.762300,// 830
-6.339700,34.475000,12.861900,// 831
-6.441100,32.413200,0.267100,// 832
-9.011700,33.422900,6.612600,// 833
-5.891300,21.286100,11.687800,// 834
-5.901700,21.508000,-0.102900,// 835
-8.336200,21.394000,5.797600,// 836
-11.176900,68.489200,39.808200,// 837
-13.324100,35.067200,35.020900,// 838
-11.372300,49.404700,37.929700,// 839
-8.045400,32.196200,14.157300,// 840
-11.414100,32.171200,6.107700,// 841
-8.095000,32.145300,-1.982700,// 842
-15.249300,-33.109900,51.217600,// 843
-28.273200,-29.754100,40.490300,// 844
-36.527500,-25.953900,13.857900,// 845
-28.144100,-29.824200,-12.855000,// 846
-18.084700,13.202000,27.729400,// 847
-25.804000,12.205300,12.422700,// 848
-17.431100,13.404700,-8.028600,// 849
-21.005600,-14.390300,36.720300,// 850
-30.682300,-14.436800,13.384200,// 851
-21.026100,-14.477900,-9.973900,// 852
-16.916100,24.623800,8.461400,// 853
-11.690100,25.015200,-4.340300,// 854
-11.876700,25.037800,19.299200,// 855
-28.203800,118.402400,-6.345400,// 856
-34.535400,114.301800,2.089800,// 857
-39.770300,117.125900,-0.403000,// 858
-41.884300,118.310100,-6.344800,// 859
-39.656900,117.217600,-12.224800,// 860
-34.446400,114.474700,-14.672300,// 861
-29.140500,111.472100,-12.134800,// 862
-29.167500,111.356100,-0.531500,// 863
-74.309700,-81.434300,-32.524900,// 864
-90.448800,-77.261400,-39.845700,// 865
-97.070000,-71.707600,-58.429200,// 866
-90.448800,-68.029300,-77.473000,// 867
-74.309200,-68.338400,-85.894100,// 868
-58.040700,-72.521800,-78.451700,// 869
-58.040700,-81.696700,-41.057600,// 870
-74.507900,-101.847600,-65.824300,// 871
-57.104900,85.355000,-5.521600,// 872
-51.413000,81.798000,-2.123400,// 873
-59.211000,87.735700,-13.991000,// 874
-56.726400,87.694600,-22.690300,// 875
-45.484300,79.250000,-6.205200,// 876
-50.861600,85.164200,-26.627000,// 877
-45.140600,81.526100,-23.127000,// 878
-66.467700,-22.447100,-24.647100,// 879
-83.489100,-14.197500,-28.980700,// 880
-54.645600,-25.242100,-31.881100,// 881
-88.059800,-9.575900,-43.184900,// 882
-54.635400,-18.209600,-60.434600,// 883
-83.469100,-7.060500,-57.916800,// 884
-65.722900,-14.109600,-65.984300,// 885
-6.244800,-27.220500,26.939200,// 886
-14.529600,-26.985300,28.410000,// 887
-22.083500,-26.396800,24.742700,// 888
-26.021600,-25.679900,17.337500,// 889
-24.838600,-25.107900,9.022700,// 890
-18.986900,-24.899600,2.975000,// 891
-10.702000,-25.134800,1.504100,// 892
-3.148200,-25.723700,5.171400,// 893
0.789800,-26.441000,12.576700,// 894
-0.393100,-27.012800,20.891500,// 895
-6.104900,-95.686900,25.457200,// 896
-12.731600,-95.982300,26.725400,// 897
-18.750000,-96.687600,23.597000,// 898
-21.857200,-97.561200,17.318800,// 899
-20.913700,-98.287600,10.279100,// 900
-16.259100,-98.570500,5.119500,// 901
-9.632600,-98.267500,3.840400,// 902
-3.608300,-97.499200,6.960000,// 903
-0.498300,-96.596500,13.243200,// 904
-1.444500,-95.913000,20.294300,// 905
-10.486600,-107.758500,16.683200,// 906
-7.350300,-69.497900,25.609400,// 907
-15.117100,-69.501900,27.082500,// 908
-1.905100,-69.507000,19.545000,// 909
-22.168500,-69.536200,23.393700,// 910
-0.820100,-69.510200,11.241000,// 911
-26.389600,-69.588000,15.981200,// 912
-4.488200,-69.522000,3.819700,// 913
-25.300300,-69.619000,7.624300,// 914
-11.562300,-69.559100,0.108800,// 915
-19.306900,-69.604400,1.569500,// 916
-14.856400,-82.804100,27.495100,// 917
-7.259500,-82.612800,26.014000,// 918
-21.764300,-83.257300,23.791700,// 919
-1.940900,-82.749600,19.950700,// 920
-25.329700,-83.836900,16.394500,// 921
-0.877500,-83.171900,11.668700,// 922
-24.267200,-84.299200,8.117700,// 923
-4.447200,-83.740900,4.269300,// 924
-18.952500,-84.453400,2.053800,// 925
-11.356100,-84.241600,0.569300,// 926
-7.546900,-56.362800,25.948500,// 927
-15.834400,-56.201500,27.415100,// 928
-1.696900,-56.211900,19.897500,// 929
-23.394600,-55.808100,23.735800,// 930
-0.519100,-55.798900,11.573000,// 931
-27.339600,-55.318600,16.315600,// 932
-4.464100,-55.297900,4.153600,// 933
-26.163200,-54.938200,7.988700,// 934
-12.025400,-54.916200,0.472400,// 935
-20.314000,-54.792400,1.936700,// 936
-11.904700,-103.140500,24.754900,// 937
-6.936400,-102.881700,23.793300,// 938
-3.432400,-103.124100,19.931600,// 939
-2.708500,-103.784100,14.656100,// 940
-5.034300,-104.615600,9.956600,// 941
-9.551700,-105.294800,7.625000,// 942
-14.532700,-105.547300,8.580500,// 943
-18.046600,-105.280500,12.448800,// 944
-18.764900,-104.611700,17.733600,// 945
-16.425500,-103.798300,22.433400,// 946
48.039700,-27.739100,5.962700,// 947
54.326000,-35.252900,6.085900,// 948
52.780400,-23.672800,5.962600,// 949
59.249600,-31.029700,6.085900,// 950
52.780400,-23.672800,-0.283000,// 951
59.249600,-31.029700,-0.406300,// 952
48.039700,-27.739100,-0.283100,// 953
54.326000,-35.252900,-0.406300,// 954
57.097200,-37.188100,5.348200,// 955
60.740300,-34.063300,5.348200,// 956
60.740300,-34.063300,0.331400,// 957
57.097200,-37.188100,0.331400,// 958
0.000000,-16.275200,17.118500,// 959
0.000000,-16.393800,41.250600,// 960
14.184500,-16.393800,36.641800,// 961
22.951000,-16.393800,24.575700,// 962
22.951000,-16.393800,9.661300,// 963
14.184500,-16.393800,-2.404700,// 964
0.000000,-16.393800,-7.013500,// 965
-14.184500,-16.393800,-2.404700,// 966
-22.951000,-16.393800,9.661300,// 967
-22.951000,-16.393800,24.575700,// 968
-14.184500,-16.393800,36.641800,// 969
0.000000,-44.214800,58.151700,// 970
24.118700,-44.214800,50.315000,// 971
39.024900,-44.214800,29.798400,// 972
39.024900,-44.214800,4.438600,// 973
24.118700,-44.214800,-16.078000,// 974
0.000000,-44.214800,-23.914700,// 975
-24.118700,-44.214800,-16.078000,// 976
-39.024900,-44.214800,4.438600,// 977
-39.024900,-44.214800,29.798400,// 978
-24.118700,-44.214800,50.315000,// 979
0.000000,-21.304400,17.118500,// 980
48.039700,-27.739100,0.041500,// 981
54.326000,-35.252900,0.164700,// 982
52.780400,-23.672800,0.041400,// 983
59.249600,-31.029700,0.164700,// 984
52.780400,-23.672800,-6.204200,// 985
59.249600,-31.029700,-6.327500,// 986
48.039700,-27.739100,-6.204300,// 987
54.326000,-35.252900,-6.327500,// 988
57.097200,-37.188100,-0.573000,// 989
60.740300,-34.063300,-0.573000,// 990
60.740300,-34.063300,-5.589800,// 991
57.097200,-37.188100,-5.589800,// 992
48.039700,-27.739100,-5.517900,// 993
54.326000,-35.252900,-5.394700,// 994
52.780400,-23.672800,-5.518000,// 995
59.249600,-31.029700,-5.394700,// 996
52.780400,-23.672800,-11.763600,// 997
59.249600,-31.029700,-11.886900,// 998
48.039700,-27.739100,-11.763700,// 999
54.326000,-35.252900,-11.886900,// 1000
57.097200,-37.188100,-6.132400,// 1001
60.740300,-34.063300,-6.132400,// 1002
60.740300,-34.063300,-11.149200,// 1003
57.097200,-37.188100,-11.149200,// 1004
48.039700,-27.739100,-10.874600,// 1005
54.326000,-35.252900,-10.751400,// 1006
52.780400,-23.672800,-10.874700,// 1007
59.249600,-31.029700,-10.751400,// 1008
52.780400,-23.672800,-17.120300,// 1009
59.249600,-31.029700,-17.243600,// 1010
48.039700,-27.739100,-17.120400,// 1011
54.326000,-35.252900,-17.243600,// 1012
57.097200,-37.188100,-11.489100,// 1013
60.740300,-34.063300,-11.489100,// 1014
60.740300,-34.063300,-16.505900,// 1015
57.097200,-37.188100,-16.505900,// 1016
-24.813100,116.560800,12.335100,// 1017
-15.073900,120.446700,16.549100,// 1018
-19.427500,109.418200,27.061700,// 1019
-31.104600,111.462000,12.616500,// 1020
-1.412500,121.021600,15.261200,// 1021
9.942700,120.544400,14.578200,// 1022
25.019200,120.301400,9.164400,// 1023
26.825000,107.336100,23.220800,// 1024
34.583000,111.560000,4.745300,// 1025
42.663100,96.496400,8.688200,// 1026
36.439500,82.861500,27.542900,// 1027
41.412500,76.667900,22.955100,// 1028
-34.617300,92.551500,29.264400,// 1029
-43.077100,93.367300,14.777600,// 1030
-36.674200,70.881200,32.141500,// 1031
-42.973500,72.521400,21.193900,// 1032
0.246900,103.119100,36.262100,// 1033
12.879200,100.457600,36.442000,// 1034
34.550100,96.549000,25.289000,// 1035
45.463900,90.307500,15.067100,// 1036
-30.653700,114.737800,8.860800,// 1037
-35.267800,111.662900,8.049600,// 1038
-39.866100,103.297900,11.822100,// 1039
-41.433800,104.196900,7.805500,// 1040
-3.596700,110.777900,28.932200,// 1041
11.410900,109.184700,31.376800,// 1042
-18.410100,115.014100,10.238200,// 1043
-12.457400,116.027300,10.589300,// 1044
-1.412600,118.664800,12.012900,// 1045
9.496400,118.187700,9.931400,// 1046
24.260300,115.743700,5.730000,// 1047
27.185000,112.190400,1.915700,// 1048
-26.597000,112.058200,6.285100,// 1049
35.937500,105.806700,1.568500,// 1050
42.546700,80.365000,18.708600,// 1051
39.632300,93.681500,6.131600,// 1052
14.051600,115.471900,24.321900,// 1053
24.152700,105.039200,19.597900,// 1054
35.002400,81.727000,22.861000,// 1055
12.743200,99.397500,32.917500,// 1056
30.359700,96.204100,22.159800,// 1057
11.288800,108.124600,27.853900,// 1058
32.894400,63.831400,28.857500,// 1059
-17.275000,108.267000,20.988200,// 1060
-3.834000,116.184400,21.100500,// 1061
-30.229000,91.844200,26.865700,// 1062
-34.413300,68.899500,26.823400,// 1063
0.246900,102.094700,33.791400,// 1064
-3.596700,109.753500,24.717900,// 1065
14.803900,83.326600,38.622400,// 1066
-29.878000,110.678400,8.797900,// 1067
-41.416500,92.333500,9.608200,// 1068
-41.832800,71.487600,15.328700,// 1069
-38.639500,102.514400,8.003500,// 1070
-35.270500,50.726300,29.814200,// 1071
-31.929200,109.929900,5.127500,// 1072
-39.430300,102.255400,5.867100,// 1073
-45.561700,95.893700,9.589000,// 1074
13.532000,112.753200,21.427900,// 1075
-4.940800,113.494400,20.014300,// 1076
-25.093300,117.513900,12.220800,// 1077
-15.274700,121.426300,16.556500,// 1078
-19.399000,109.642200,28.035900,// 1079
-31.726200,112.021100,13.165200,// 1080
-1.403400,122.014400,15.380800,// 1081
9.968100,121.544000,14.564800,// 1082
25.338400,121.231500,8.982600,// 1083
27.157200,107.613900,24.122200,// 1084
35.237900,112.132500,4.252000,// 1085
43.559400,96.939800,8.688800,// 1086
36.199100,82.989700,28.505100,// 1087
42.335900,76.313400,23.102300,// 1088
-34.628300,92.684900,30.255400,// 1089
-44.026200,93.669600,14.866200,// 1090
-36.629700,70.891900,33.140400,// 1091
-43.958300,72.388500,21.306100,// 1092
-0.389900,103.077400,37.032000,// 1093
13.617700,100.763200,37.043100,// 1094
34.569800,96.733800,26.271600,// 1095
46.459600,90.291900,14.975500,// 1096
-30.923300,115.610400,8.453500,// 1097
-35.919500,112.410300,7.920500,// 1098
-39.939600,103.160400,12.809900,// 1099
-42.256200,104.706200,7.552000,// 1100
-4.340000,111.189400,29.459600,// 1101
12.113000,109.587100,31.964300,// 1102
-18.359500,115.656400,9.473400,// 1103
-12.691600,116.756200,9.946000,// 1104
-1.511500,119.552900,11.564000,// 1105
9.511200,119.078900,9.478000,// 1106
24.077100,116.354600,4.959800,// 1107
27.499400,112.859900,1.242800,// 1108
-26.547800,112.788000,5.603200,// 1109
36.782000,106.310600,1.387100,// 1110
43.232000,79.819300,18.226400,// 1111
40.410100,93.467900,5.540400,// 1112
14.531000,115.633300,25.184500,// 1113
23.705000,104.471000,20.288300,// 1114
34.049800,81.688600,23.162700,// 1115
13.734300,99.509600,32.845500,// 1116
29.643500,95.928700,22.801000,// 1117
12.273300,107.953100,27.890300,// 1118
32.626300,63.348500,29.070300,// 1119
-16.739800,107.627600,21.540300,// 1120
-4.196500,116.515900,21.971500,// 1121
-29.458900,91.590700,27.451100,// 1122
-33.498700,68.862500,27.226000,// 1123
-0.623200,101.615700,33.907800,// 1124
-4.577900,109.680600,24.896500,// 1125
14.979700,82.712800,38.701100,// 1126
-30.506500,109.901800,8.755400,// 1127
-42.333000,92.548400,9.270800,// 1128
-42.769000,71.242000,15.077100,// 1129
-37.983200,101.845000,8.351700,// 1130
-35.243400,50.007300,29.714400,// 1131
-32.262100,110.523800,4.395000,// 1132
-39.966700,102.506400,5.061300,// 1133
-46.561100,95.864500,9.568800,// 1134
13.964400,112.058600,22.002800,// 1135
-5.379400,113.319000,20.895700,// 1136
0.000000,112.514100,13.906100,// 1137
21.457800,108.157900,12.712300,// 1138
31.777800,94.480200,15.469500,// 1139
35.483100,78.643500,20.617600,// 1140
33.114900,61.828200,21.192400,// 1141
25.479000,48.154500,18.503400,// 1142
0.000000,122.566800,-9.104600,// 1143
0.000000,122.071100,9.834300,// 1144
13.054500,121.166400,4.408800,// 1145
18.431100,118.914300,-8.460600,// 1146
13.032700,116.651100,-21.295400,// 1147
0.000000,115.713700,-26.611700,// 1148
0.000000,116.735100,15.561400,// 1149
24.061800,111.969300,13.478100,// 1150
33.989500,108.565400,-6.614700,// 1151
24.034600,104.387900,-30.304700,// 1152
0.000000,102.659200,-40.108800,// 1153
35.913400,96.444900,16.542600,// 1154
44.328300,93.162400,-3.926100,// 1155
31.344800,87.720600,-34.788700,// 1156
0.000000,85.466100,-47.574900,// 1157
39.954300,78.937400,22.105600,// 1158
47.944600,75.068400,-0.766000,// 1159
33.902400,69.187600,-34.117900,// 1160
0.000000,66.749200,-47.947400,// 1161
37.367200,60.593600,22.854800,// 1162
44.327700,56.979700,2.420800,// 1163
31.344800,51.542800,-28.409600,// 1164
0.000000,49.288300,-41.195800,// 1165
30.956100,46.993100,24.825900,// 1166
33.813800,41.441100,5.141500,// 1167
23.978100,37.357000,-18.437500,// 1168
0.000000,35.631300,-28.213200,// 1169
13.138500,33.268500,-10.518800,// 1170
0.000000,32.851700,-16.033400,// 1171
26.759100,41.797500,5.706900,// 1172
6.757300,33.457700,-7.270700,// 1173
21.897100,35.367500,32.153700,// 1174
10.614300,26.616800,-16.400400,// 1175
-21.457800,108.157900,12.712300,// 1176
-31.777800,94.480200,15.469500,// 1177
-35.483100,78.643500,20.617600,// 1178
-33.114900,61.828200,21.192400,// 1179
-25.001800,48.154500,20.850900,// 1180
-13.054500,121.166400,4.408800,// 1181
-18.431100,118.914300,-8.460600,// 1182
-13.032700,116.651100,-21.295400,// 1183
-24.061800,111.969300,13.478100,// 1184
-33.989500,108.565400,-6.614700,// 1185
-24.034600,104.387900,-30.304700,// 1186
-35.913400,96.444900,16.542600,// 1187
-44.328300,93.162400,-3.926100,// 1188
-31.344800,87.720600,-34.788700,// 1189
-39.954300,78.937400,22.105600,// 1190
-47.944600,75.068400,-0.766000,// 1191
-33.902400,69.187600,-34.117900,// 1192
-37.367200,60.593600,22.854800,// 1193
-44.327700,56.979700,2.420800,// 1194
-31.344800,51.542800,-28.409600,// 1195
-30.956100,46.993100,24.825900,// 1196
-33.813800,41.441100,5.141500,// 1197
-23.978100,37.357000,-18.437500,// 1198
-13.138500,33.268500,-10.518800,// 1199
-26.759100,41.797500,5.706900,// 1200
-6.757300,33.457700,-7.270700,// 1201
-21.897100,35.367500,32.153700,// 1202
-10.614300,26.616800,-16.400400,// 1203
40.307500,58.439500,8.758700,// 1204
-41.893400,58.027100,6.489700,// 1205
17.090200,76.672400,38.881700,// 1206
32.585100,76.672400,29.935700,// 1207
17.090200,58.780500,38.881700,// 1208
32.585100,58.780500,29.935700,// 1209
-17.090200,76.672400,38.881700,// 1210
-32.585100,76.672400,29.935700,// 1211
-17.090200,58.780500,38.881700,// 1212
-32.585100,58.780500,29.935700, // 1213

/* group 2 ; arm */

	-17.180400, 22.563400, 8.861500,	// 0
	-45.801300, -36.555000, 13.286000,	// 1
	-23.042000, 20.723000, 6.975600,	// 2
	-65.542200, -24.940800, 9.658400,	// 3
	-20.869600, 19.684600, -5.300700,	// 4
	-61.153100, -27.523000, -22.493300,	// 5
	-14.886400, 21.503500, -4.273400,	// 6
	-41.412200, -39.137200, -18.865700,	// 7
	-19.144600, 25.251500, 0.331700,	// 8
	-10.916800, 26.095400, 1.744300,	// 9
	-68.261100, -23.341200, -7.320400,	// 10
	-38.693300, -40.736800, -1.886900,	// 11
	-27.915500, 14.399600, 7.516300,	// 12
	-23.013900, 13.746500, 8.729600,	// 13
	-29.947900, 15.413000, -0.663900,	// 14
	-16.889300, 13.531500, 0.819500,	// 15
	-28.937700, 12.428200, -8.163400,	// 16
	-20.172500, 13.146100, -6.950000,	// 17
	-49.703500, -11.928300, 8.047200,	// 18
	-51.946200, -10.680500, -4.589900,	// 19
	-37.295600, -18.351000, 10.519000,	// 20
	-47.775300, -14.074400, -16.076900,	// 21
	-30.988100, -20.359700, -1.089900,	// 22
	-33.848000, -19.958000, -13.605100,	// 23
	-48.285800, -29.196800, 6.111900,	// 24
	-41.029700, -33.751100, 1.165800,	// 25
	-41.029700, -33.751100, -8.726500,	// 26
	-48.285800, -29.196800, -13.672600,	// 27
	-55.541900, -24.642600, -8.726500,	// 28
	-55.541900, -24.642600, 1.165800,	// 29
	-50.448600, -32.642900, 7.642200,	// 30
	-42.070000, -37.901600, 1.930900,	// 31
	-42.070000, -37.901600, -9.491600,	// 32
	-50.448700, -32.642800, -15.202900,	// 33
	-58.827300, -27.384100, -9.491600,	// 34
	-58.827300, -27.384100, 1.930900,	// 35
	-52.611500, -36.088900, 6.111900,	// 36
	-45.355400, -40.643100, 1.165800,	// 37
	-45.355400, -40.643100, -8.726500,	// 38
	-52.611500, -36.088900, -13.672600,	// 39
	-59.867600, -31.534600, -8.726500,	// 40
	-59.867600, -31.534600, 1.165800,	// 41
	-54.194900, -38.611600, 1.930900,	// 42
	-50.005600, -41.241000, -0.924700,	// 43
	-50.005600, -41.241000, -6.636000,	// 44
	-54.194900, -38.611600, -9.491600,	// 45
	-58.384200, -35.982200, -6.636000,	// 46
	-58.384200, -35.982200, -0.924700,	// 47
	-54.774400, -39.534900, -3.780400,	// 48
	-17.147900, 22.963600, 9.777300,	// 49
	-45.663800, -37.113600, 14.103900,	// 50
	-23.628200, 21.409200, 7.406300,	// 51
	-66.258700, -24.876800, 10.353000,	// 52
	-21.032600, 20.292400, -6.077900,	// 53
	-61.628100, -27.495900, -23.372900,	// 54
	-14.487700, 21.813800, -5.136400,	// 55
	-40.999800, -39.748900, -19.540800,	// 56
	-19.554900, 26.144600, 0.147400,	// 57
	-10.060800, 26.610400, 1.698800,	// 58
	-69.248300, -23.441000, -7.444600,	// 59
	-38.405000, -41.687200, -1.770400,	// 60
	-28.460200, 14.871400, 8.209600,	// 61
	-22.706600, 13.598100, 9.669600,	// 62
	-30.664400, 16.108800, -0.715000,	// 63
	-15.986700, 13.121000, 0.949000,	// 64
	-29.243200, 12.968700, -8.947300,	// 65
	-19.578600, 13.044700, -7.748100,	// 66
	-50.179400, -11.402500, 8.752300,	// 67
	-52.623100, -9.954100, -4.709100,	// 68
	-36.872200, -18.450800, 11.419400,	// 69
	-47.998300, -13.568800, -16.910300,	// 70
	-30.071200, -20.730700, -0.942800,	// 71
	-33.155500, -20.068200, -14.318100,	// 72
	-48.098700, -28.898600, 7.047900,	// 73
	-40.156000, -33.883800, 1.633800,	// 74
	-40.156000, -33.883800, -9.194500,	// 75
	-48.098600, -28.898600, -14.608600,	// 76
	-56.041300, -23.913500, -9.194500,	// 77
	-56.041300, -23.913500, 1.633800,	// 78
	-50.448600, -32.642900, 8.642200,	// 79
	-41.336500, -38.362000, 2.430900,	// 80
	-41.336500, -38.362000, -9.991600,	// 81
	-50.448700, -32.642800, -16.202900,	// 82
	-59.560800, -26.923700, -9.991600,	// 83
	-59.560800, -26.923700, 2.430900,	// 84
	-52.940500, -36.613000, 6.897500,	// 85
	-45.108100, -41.528900, 1.558600,	// 86
	-45.108100, -41.528900, -9.119300,	// 87
	-52.940500, -36.613000, -14.458200,	// 88
	-60.772800, -31.697100, -9.119300,	// 89
	-60.772800, -31.697100, 1.558600,	// 90
	-54.684800, -39.392200, 2.319000,	// 91
	-50.210800, -42.200300, -0.730600,	// 92
	-50.210800, -42.200300, -6.830100,	// 93
	-54.684800, -39.392200, -9.879700,	// 94
	-59.158800, -36.584100, -6.830100,	// 95
	-59.158800, -36.584100, -0.730600,	// 96
	-55.306000, -40.381900, -3.780400,	// 97

/* group 3 ; negi */

	-84.019400, 63.834900, 8.679900,	// 0
	-84.019400, 58.835400, 12.435900,	// 1
	-81.811700, 58.835400, 5.641200,	// 2
	-86.227200, 56.380900, 5.641200,	// 3
	-87.591600, 58.835400, 9.840600,	// 4
	-83.971600, -9.149200, 12.168600,	// 5
	-80.399400, -9.149200, 9.573300,	// 6
	-81.763900, -9.149200, 5.373900,	// 7
	-86.179300, 1.792100, 5.373900,	// 8
	-87.543700, -9.149200, 9.573300,	// 9
	-83.971600, 1.792100, 8.412600,	// 10
	-78.209800, 95.984000, 8.171800,	// 11
	-78.151100, 94.492300, 11.830200,	// 12
	-76.063800, 97.627800, 5.234700,	// 13
	-83.005000, 102.176500, 11.637600,	// 14
	-87.316300, 100.533000, 11.450300,	// 15
	-87.903700, 96.299600, 16.153400,	// 16
	-86.075100, 83.040600, 19.652900,	// 17
	-87.591600, 25.788100, 8.576300,	// 18
	-81.811700, 25.788100, 4.376900,	// 19
	-86.227200, 29.845300, 4.376900,	// 20
	-84.328900, 66.645400, 9.724600,	// 21
	-84.010600, 58.765600, 13.434300,	// 22
	-79.498100, 56.320500, 10.149800,	// 23
	-81.222900, 58.877000, 4.833600,	// 24
	-88.534400, 58.813500, 10.173500,	// 25
	-83.971600, -10.106300, 12.808500,	// 26
	-79.797600, -10.113600, 9.768700,	// 27
	-81.399100, -10.125900, 4.872100,	// 28
	-88.144600, -10.114600, 9.768500,	// 29
	-78.917000, 96.862900, 8.213000,	// 30
	-78.487100, 95.257300, 12.544200,	// 31
	-74.125700, 97.249000, 9.793700,	// 32
	-76.105400, 98.665600, 4.683500,	// 33
	-84.043900, 97.861200, 17.523200,	// 34
	-82.407000, 103.152000, 11.468100,	// 35
	-87.977700, 101.467000, 11.437700,	// 36
	-88.558600, 96.689100, 16.841300,	// 37
	-86.110900, 85.381300, 20.425200,	// 38
	-84.019400, 29.839300, 12.171700,	// 39
	-79.496100, 29.844200, 8.885100,	// 40
	-88.542700, 25.784800, 8.885200,	// 41
	-81.223700, 25.794800, 3.568100,	// 42
	-80.447200, 58.835400, 9.840600,	// 43
	-74.642400, 96.229800, 9.338700,	// 44
	-84.188800, 97.278200, 16.666900,	// 45
	-84.019400, 25.788100, 11.171700,	// 46
	-80.447200, 25.788100, 8.576300,	// 47
	-86.815300, 58.910600, 4.834700,	// 48
	-86.543700, -10.126500, 4.872600,	// 49
	-83.971600, -10.394600, 8.412600,	// 50
	-86.815200, 25.793600, 3.568100	// 51
],
texcoords: [
	0.984840, 0.090560, 	// 0
	0.984840, 0.111630, 	// 1
	0.778350, 0.090560, 	// 2
	0.778350, 0.111630, 	// 3
	0.778350, 0.090560, 	// 4
	0.778350, 0.111630, 	// 5
	0.778350, 0.090560, 	// 6
	0.778350, 0.111630, 	// 7
	0.358380, 0.004540, 	// 8
	0.008120, 0.005150, 	// 9
	0.208750, 0.023480, 	// 10
	0.259570, 0.054020, 	// 11
	0.310790, 0.076130, 	// 12
	0.358380, 0.084160, 	// 13
	0.008120, 0.087810, 	// 14
	0.161330, 0.101780, 	// 15
	0.238810, 0.129550, 	// 16
	0.300210, 0.154530, 	// 17
	0.358380, 0.164140, 	// 18
	0.008120, 0.171750, 	// 19
	0.146220, 0.184250, 	// 20
	0.229680, 0.208880, 	// 21
	0.294740, 0.234700, 	// 22
	0.358380, 0.245020, 	// 23
	0.008120, 0.257340, 	// 24
	0.137130, 0.268890, 	// 25
	0.223330, 0.290330, 	// 26
	0.290490, 0.316470, 	// 27
	0.358380, 0.327260, 	// 28
	0.008120, 0.344780, 	// 29
	0.129220, 0.355460, 	// 30
	0.217200, 0.373600, 	// 31
	0.285970, 0.399920, 	// 32
	0.358380, 0.411200, 	// 33
	0.119640, 0.443660, 	// 34
	0.208940, 0.458190, 	// 35
	0.279050, 0.484810, 	// 36
	0.358380, 0.496940, 	// 37
	0.008120, 0.524410, 	// 38
	0.101570, 0.532520, 	// 39
	0.190670, 0.542100, 	// 40
	0.285680, 0.553190, 	// 41
	0.358380, 0.560770, 	// 42
	0.079470, 0.576140, 	// 43
	0.008120, 0.569890, 	// 44
	0.358380, 0.628300, 	// 45
	0.211050, 0.605630, 	// 46
	0.153160, 0.593780, 	// 47
	0.008120, 0.627760, 	// 48
	0.079890, 0.599460, 	// 49
	0.008120, 0.595440, 	// 50
	0.358380, 0.629550, 	// 51
	0.214830, 0.614450, 	// 52
	0.155210, 0.611080, 	// 53
	0.051640, 0.345880, 	// 54
	0.008120, 0.420900, 	// 55
	0.008120, 0.471700, 	// 56
	0.063720, 0.479470, 	// 57
	0.059760, 0.423710, 	// 58
	0.397760, 0.096920, 	// 59
	0.399570, 0.116470, 	// 60
	0.406930, 0.150840, 	// 61
	0.407500, 0.187480, 	// 62
	0.409640, 0.226730, 	// 63
	0.407760, 0.258320, 	// 64
	0.597930, 0.069030, 	// 65
	0.417130, 0.061740, 	// 66
	0.469560, 0.060800, 	// 67
	0.526280, 0.075390, 	// 68
	0.570750, 0.086340, 	// 69
	0.612050, 0.090320, 	// 70
	0.417130, 0.082390, 	// 71
	0.456880, 0.095980, 	// 72
	0.508390, 0.112990, 	// 73
	0.561610, 0.125360, 	// 74
	0.612050, 0.130120, 	// 75
	0.462580, 0.140880, 	// 76
	0.500510, 0.152440, 	// 77
	0.556880, 0.165230, 	// 78
	0.612050, 0.170350, 	// 79
	0.456800, 0.184020, 	// 80
	0.495020, 0.192890, 	// 81
	0.553200, 0.205860, 	// 82
	0.612050, 0.211220, 	// 83
	0.453550, 0.227270, 	// 84
	0.489700, 0.234190, 	// 85
	0.549280, 0.247260, 	// 86
	0.612050, 0.252870, 	// 87
	0.444010, 0.260510, 	// 88
	0.482510, 0.276050, 	// 89
	0.543230, 0.289300, 	// 90
	0.612050, 0.295340, 	// 91
	0.545670, 0.321580, 	// 92
	0.612050, 0.324140, 	// 93
	0.472320, 0.290300, 	// 94
	0.556680, 0.343210, 	// 95
	0.406680, 0.274940, 	// 96
	0.568430, 0.330040, 	// 97
	0.295830, 0.643370, 	// 98
	0.175500, 0.666630, 	// 99
	0.231450, 0.666630, 	// 100
	0.292030, 0.666630, 	// 101
	0.370650, 0.666630, 	// 102
	0.467520, 0.667750, 	// 103
	0.208280, 0.886510, 	// 104
	0.241780, 0.875620, 	// 105
	0.307820, 0.862470, 	// 106
	0.395260, 0.875620, 	// 107
	0.467520, 0.888650, 	// 108
	0.179230, 0.927910, 	// 109
	0.175500, 0.731000, 	// 110
	0.238520, 0.731050, 	// 111
	0.297590, 0.734180, 	// 112
	0.394270, 0.729800, 	// 113
	0.467520, 0.732130, 	// 114
	0.175500, 0.826200, 	// 115
	0.232040, 0.826200, 	// 116
	0.301930, 0.826200, 	// 117
	0.395770, 0.826200, 	// 118
	0.467520, 0.827320, 	// 119
	0.295200, 0.691860, 	// 120
	0.384400, 0.690220, 	// 121
	0.235330, 0.690690, 	// 122
	0.467520, 0.691800, 	// 123
	0.175500, 0.690670, 	// 124
	0.329820, 0.934230, 	// 125
	0.368840, 0.991750, 	// 126
	0.454820, 0.931020, 	// 127
	0.454820, 0.921770, 	// 128
	0.399230, 0.913480, 	// 129
	0.401790, 0.939880, 	// 130
	0.441070, 0.916310, 	// 131
	0.420840, 0.935950, 	// 132
	0.359720, 0.922260, 	// 133
	0.378570, 0.968880, 	// 134
	0.325780, 0.903780, 	// 135
	0.452450, 0.904300, 	// 136
	0.398570, 0.894880, 	// 137
	0.412630, 0.895520, 	// 138
	0.359010, 0.895340, 	// 139
	0.726580, 0.143930, 	// 140
	0.726580, 0.194310, 	// 141
	0.726580, 0.152270, 	// 142
	0.726580, 0.185970, 	// 143
	0.746240, 0.152270, 	// 144
	0.746240, 0.185970, 	// 145
	0.746240, 0.143930, 	// 146
	0.746240, 0.194310, 	// 147
	0.768800, 0.216880, 	// 148
	0.785540, 0.231280, 	// 149
	0.817590, 0.231280, 	// 150
	0.849640, 0.231280, 	// 151
	0.881690, 0.231280, 	// 152
	0.913730, 0.231280, 	// 153
	0.945790, 0.231280, 	// 154
	0.977840, 0.231280, 	// 155
	0.785540, 0.432230, 	// 156
	0.817590, 0.432230, 	// 157
	0.849640, 0.432230, 	// 158
	0.881690, 0.432230, 	// 159
	0.913730, 0.432230, 	// 160
	0.945790, 0.432230, 	// 161
	0.977840, 0.432230, 	// 162
	0.767360, 0.466790, 	// 163
	0.817590, 0.304040, 	// 164
	0.785540, 0.304040, 	// 165
	0.849640, 0.304040, 	// 166
	0.881690, 0.304040, 	// 167
	0.977840, 0.304040, 	// 168
	0.913730, 0.304040, 	// 169
	0.945790, 0.304040, 	// 170
	0.785540, 0.369780, 	// 171
	0.817590, 0.369780, 	// 172
	0.977840, 0.369780, 	// 173
	0.849640, 0.369780, 	// 174
	0.945790, 0.369780, 	// 175
	0.881690, 0.369780, 	// 176
	0.913730, 0.369780, 	// 177
	0.161540, 0.838940, 	// 178
	0.031610, 0.838940, 	// 179
	0.046040, 0.838940, 	// 180
	0.060480, 0.838940, 	// 181
	0.074920, 0.838940, 	// 182
	0.089360, 0.838940, 	// 183
	0.103790, 0.838940, 	// 184
	0.118230, 0.838940, 	// 185
	0.132670, 0.838940, 	// 186
	0.147110, 0.838940, 	// 187
	0.161540, 0.983320, 	// 188
	0.031610, 0.983320, 	// 189
	0.046040, 0.983320, 	// 190
	0.060480, 0.983320, 	// 191
	0.074920, 0.983320, 	// 192
	0.089360, 0.983320, 	// 193
	0.103790, 0.983320, 	// 194
	0.118230, 0.983320, 	// 195
	0.132670, 0.983320, 	// 196
	0.147110, 0.983320, 	// 197
	0.038820, 0.983320, 	// 198
	0.161540, 0.911130, 	// 199
	0.031610, 0.911130, 	// 200
	0.147110, 0.911130, 	// 201
	0.046040, 0.911130, 	// 202
	0.132670, 0.911130, 	// 203
	0.060480, 0.911130, 	// 204
	0.118230, 0.911130, 	// 205
	0.074920, 0.911130, 	// 206
	0.103790, 0.911130, 	// 207
	0.089360, 0.911130, 	// 208
	0.031610, 0.947220, 	// 209
	0.161540, 0.947220, 	// 210
	0.046040, 0.947220, 	// 211
	0.147110, 0.947220, 	// 212
	0.060480, 0.947220, 	// 213
	0.132670, 0.947220, 	// 214
	0.074920, 0.947220, 	// 215
	0.118230, 0.947220, 	// 216
	0.089360, 0.947220, 	// 217
	0.103790, 0.947220, 	// 218
	0.161540, 0.875040, 	// 219
	0.031610, 0.875040, 	// 220
	0.147110, 0.875040, 	// 221
	0.046040, 0.875040, 	// 222
	0.132670, 0.875040, 	// 223
	0.060480, 0.875040, 	// 224
	0.118230, 0.875040, 	// 225
	0.074920, 0.875040, 	// 226
	0.103790, 0.875040, 	// 227
	0.089360, 0.875040, 	// 228
	0.035210, 0.983320, 	// 229
	0.157930, 0.983320, 	// 230
	0.143500, 0.983320, 	// 231
	0.129060, 0.983320, 	// 232
	0.114620, 0.983320, 	// 233
	0.100180, 0.983320, 	// 234
	0.085750, 0.983320, 	// 235
	0.071310, 0.983320, 	// 236
	0.056870, 0.983320, 	// 237
	0.042430, 0.983320, 	// 238
	0.524770, 0.379990, 	// 239
	0.472560, 0.629020, 	// 240
	0.895980, 0.619920, 	// 241
	0.536970, 0.629020, 	// 242
	0.628400, 0.395180, 	// 243
	0.653850, 0.629020, 	// 244
	0.649130, 0.381220, 	// 245
	0.736260, 0.629020, 	// 246
	0.939330, 0.606380, 	// 247
	0.658230, 0.367710, 	// 248
	0.590510, 0.629020, 	// 249
	0.783530, 0.629680, 	// 250
	0.547600, 0.424600, 	// 251
	0.524030, 0.421110, 	// 252
	0.592400, 0.430230, 	// 253
	0.704090, 0.414210, 	// 254
	0.631600, 0.436100, 	// 255
	0.653410, 0.414880, 	// 256
	0.536850, 0.553430, 	// 257
	0.591480, 0.553430, 	// 258
	0.483900, 0.553430, 	// 259
	0.642610, 0.553430, 	// 260
	0.755360, 0.552770, 	// 261
	0.732050, 0.553430, 	// 262
	0.984840, 0.090560, 	// 263
	0.984840, 0.111630, 	// 264
	0.778350, 0.090560, 	// 265
	0.778350, 0.111630, 	// 266
	0.778350, 0.090560, 	// 267
	0.778350, 0.111630, 	// 268
	0.778350, 0.090560, 	// 269
	0.778350, 0.111630, 	// 270
	0.208750, 0.023480, 	// 271
	0.259570, 0.054020, 	// 272
	0.310790, 0.076130, 	// 273
	0.161330, 0.101780, 	// 274
	0.238810, 0.129550, 	// 275
	0.300210, 0.154530, 	// 276
	0.146220, 0.184250, 	// 277
	0.229680, 0.208880, 	// 278
	0.294740, 0.234700, 	// 279
	0.137130, 0.268890, 	// 280
	0.223330, 0.290330, 	// 281
	0.290490, 0.316470, 	// 282
	0.129220, 0.355460, 	// 283
	0.217200, 0.373600, 	// 284
	0.285970, 0.399920, 	// 285
	0.119640, 0.443660, 	// 286
	0.208940, 0.458190, 	// 287
	0.279050, 0.484810, 	// 288
	0.101570, 0.532520, 	// 289
	0.190670, 0.542100, 	// 290
	0.285680, 0.553190, 	// 291
	0.079470, 0.576140, 	// 292
	0.211050, 0.605630, 	// 293
	0.153160, 0.593780, 	// 294
	0.079890, 0.599460, 	// 295
	0.214830, 0.614450, 	// 296
	0.155210, 0.611080, 	// 297
	0.051640, 0.345880, 	// 298
	0.063720, 0.479470, 	// 299
	0.059760, 0.423710, 	// 300
	0.399570, 0.116470, 	// 301
	0.406930, 0.150840, 	// 302
	0.407500, 0.187480, 	// 303
	0.409640, 0.226730, 	// 304
	0.407760, 0.258320, 	// 305
	0.469560, 0.060800, 	// 306
	0.526280, 0.075390, 	// 307
	0.570750, 0.086340, 	// 308
	0.456880, 0.095980, 	// 309
	0.508390, 0.112990, 	// 310
	0.561610, 0.125360, 	// 311
	0.462580, 0.140880, 	// 312
	0.500510, 0.152440, 	// 313
	0.556880, 0.165230, 	// 314
	0.456800, 0.184020, 	// 315
	0.495020, 0.192890, 	// 316
	0.553200, 0.205860, 	// 317
	0.453550, 0.227270, 	// 318
	0.489700, 0.234190, 	// 319
	0.549280, 0.247260, 	// 320
	0.444010, 0.260510, 	// 321
	0.482510, 0.276050, 	// 322
	0.543230, 0.289300, 	// 323
	0.545670, 0.321580, 	// 324
	0.472320, 0.290300, 	// 325
	0.556680, 0.343210, 	// 326
	0.406680, 0.274940, 	// 327
	0.568430, 0.330040, 	// 328
	0.231450, 0.666630, 	// 329
	0.292030, 0.666630, 	// 330
	0.370650, 0.666630, 	// 331
	0.208280, 0.886510, 	// 332
	0.241780, 0.875620, 	// 333
	0.307820, 0.862470, 	// 334
	0.395260, 0.875620, 	// 335
	0.112480, 0.731050, 	// 336
	0.053410, 0.734180, 	// 337
	0.394270, 0.729800, 	// 338
	0.232040, 0.826200, 	// 339
	0.301930, 0.826200, 	// 340
	0.395770, 0.826200, 	// 341
	0.295200, 0.691860, 	// 342
	0.384400, 0.690220, 	// 343
	0.235330, 0.690690, 	// 344
	0.368840, 0.991750, 	// 345
	0.399230, 0.913480, 	// 346
	0.401790, 0.939880, 	// 347
	0.441070, 0.916310, 	// 348
	0.420840, 0.935950, 	// 349
	0.359720, 0.922260, 	// 350
	0.378570, 0.968880, 	// 351
	0.398570, 0.894880, 	// 352
	0.412630, 0.895520, 	// 353
	0.359010, 0.895340, 	// 354
	0.726580, 0.143930, 	// 355
	0.726580, 0.194310, 	// 356
	0.726580, 0.152270, 	// 357
	0.726580, 0.185970, 	// 358
	0.746240, 0.152270, 	// 359
	0.746240, 0.185970, 	// 360
	0.746240, 0.143930, 	// 361
	0.746240, 0.194310, 	// 362
	0.768800, 0.216880, 	// 363
	0.785540, 0.231280, 	// 364
	0.817590, 0.231280, 	// 365
	0.849640, 0.231280, 	// 366
	0.881690, 0.231280, 	// 367
	0.913730, 0.231280, 	// 368
	0.945790, 0.231280, 	// 369
	0.977840, 0.231280, 	// 370
	0.785540, 0.432230, 	// 371
	0.817590, 0.432230, 	// 372
	0.849640, 0.432230, 	// 373
	0.881690, 0.432230, 	// 374
	0.913730, 0.432230, 	// 375
	0.945790, 0.432230, 	// 376
	0.977840, 0.432230, 	// 377
	0.767360, 0.466790, 	// 378
	0.817590, 0.304040, 	// 379
	0.785540, 0.304040, 	// 380
	0.849640, 0.304040, 	// 381
	0.881690, 0.304040, 	// 382
	0.977840, 0.304040, 	// 383
	0.913730, 0.304040, 	// 384
	0.945790, 0.304040, 	// 385
	0.785540, 0.369780, 	// 386
	0.817590, 0.369780, 	// 387
	0.977840, 0.369780, 	// 388
	0.849640, 0.369780, 	// 389
	0.945790, 0.369780, 	// 390
	0.881690, 0.369780, 	// 391
	0.913730, 0.369780, 	// 392
	0.161540, 0.838940, 	// 393
	0.031610, 0.838940, 	// 394
	0.046040, 0.838940, 	// 395
	0.060480, 0.838940, 	// 396
	0.074920, 0.838940, 	// 397
	0.089360, 0.838940, 	// 398
	0.103790, 0.838940, 	// 399
	0.118230, 0.838940, 	// 400
	0.132670, 0.838940, 	// 401
	0.147110, 0.838940, 	// 402
	0.161540, 0.983320, 	// 403
	0.031610, 0.983320, 	// 404
	0.046040, 0.983320, 	// 405
	0.060480, 0.983320, 	// 406
	0.074920, 0.983320, 	// 407
	0.089360, 0.983320, 	// 408
	0.103790, 0.983320, 	// 409
	0.118230, 0.983320, 	// 410
	0.132670, 0.983320, 	// 411
	0.147110, 0.983320, 	// 412
	0.038820, 0.983320, 	// 413
	0.161540, 0.911130, 	// 414
	0.031610, 0.911130, 	// 415
	0.147110, 0.911130, 	// 416
	0.046040, 0.911130, 	// 417
	0.132670, 0.911130, 	// 418
	0.060480, 0.911130, 	// 419
	0.118230, 0.911130, 	// 420
	0.074920, 0.911130, 	// 421
	0.103790, 0.911130, 	// 422
	0.089360, 0.911130, 	// 423
	0.031610, 0.947220, 	// 424
	0.161540, 0.947220, 	// 425
	0.046040, 0.947220, 	// 426
	0.147110, 0.947220, 	// 427
	0.060480, 0.947220, 	// 428
	0.132670, 0.947220, 	// 429
	0.074920, 0.947220, 	// 430
	0.118230, 0.947220, 	// 431
	0.089360, 0.947220, 	// 432
	0.103790, 0.947220, 	// 433
	0.161540, 0.875040, 	// 434
	0.031610, 0.875040, 	// 435
	0.147110, 0.875040, 	// 436
	0.046040, 0.875040, 	// 437
	0.132670, 0.875040, 	// 438
	0.060480, 0.875040, 	// 439
	0.118230, 0.875040, 	// 440
	0.074920, 0.875040, 	// 441
	0.103790, 0.875040, 	// 442
	0.089360, 0.875040, 	// 443
	0.035210, 0.983320, 	// 444
	0.157930, 0.983320, 	// 445
	0.143500, 0.983320, 	// 446
	0.129060, 0.983320, 	// 447
	0.114620, 0.983320, 	// 448
	0.100180, 0.983320, 	// 449
	0.085750, 0.983320, 	// 450
	0.071310, 0.983320, 	// 451
	0.056870, 0.983320, 	// 452
	0.042430, 0.983320, 	// 453
	0.945470, 0.143330, 	// 454
	0.944480, 0.141400, 	// 455
	0.971970, 0.143330, 	// 456
	0.944440, 0.170750, 	// 457
	0.971970, 0.131480, 	// 458
	0.944790, 0.149410, 	// 459
	0.945470, 0.131480, 	// 460
	0.944480, 0.153250, 	// 461
	0.959880, 0.142640, 	// 462
	0.979750, 0.142640, 	// 463
	0.979750, 0.152020, 	// 464
	0.959880, 0.152020, 	// 465
	0.742740, 0.030450, 	// 466
	0.742740, 0.017810, 	// 467
	0.969730, 0.030450, 	// 468
	0.969730, 0.017810, 	// 469
	0.856240, 0.030450, 	// 470
	0.856240, 0.017810, 	// 471
	0.912980, 0.030450, 	// 472
	0.912980, 0.017810, 	// 473
	0.799490, 0.030450, 	// 474
	0.799490, 0.017810, 	// 475
	0.884610, 0.030450, 	// 476
	0.884610, 0.017810, 	// 477
	0.827860, 0.030450, 	// 478
	0.827860, 0.017810, 	// 479
	0.941360, 0.030450, 	// 480
	0.941360, 0.017810, 	// 481
	0.771120, 0.030450, 	// 482
	0.771120, 0.017810, 	// 483
	0.705170, 0.076000, 	// 484
	0.985540, 0.076000, 	// 485
	0.705170, 0.040950, 	// 486
	0.985540, 0.040950, 	// 487
	0.705170, 0.040950, 	// 488
	0.985540, 0.040950, 	// 489
	0.705170, 0.076000, 	// 490
	0.985540, 0.076000, 	// 491
	0.900530, 0.040950, 	// 492
	0.900530, 0.076000, 	// 493
	0.900530, 0.040950, 	// 494
	0.900530, 0.076000, 	// 495
	0.803700, 0.040950, 	// 496
	0.803700, 0.076000, 	// 497
	0.803700, 0.040950, 	// 498
	0.803700, 0.076000, 	// 499
	0.751760, 0.100720, 	// 500
	0.751760, 0.122630, 	// 501
	0.751760, 0.094150, 	// 502
	0.751760, 0.129270, 	// 503
	0.737390, 0.094150, 	// 504
	0.737390, 0.129270, 	// 505
	0.737390, 0.100720, 	// 506
	0.737390, 0.122630, 	// 507
	0.953850, 0.676250, 	// 508
	0.977410, 0.676250, 	// 509
	0.553500, 0.676250, 	// 510
	0.600600, 0.676250, 	// 511
	0.647710, 0.676250, 	// 512
	0.694800, 0.676250, 	// 513
	0.741900, 0.676250, 	// 514
	0.789010, 0.676250, 	// 515
	0.836100, 0.676250, 	// 516
	0.883210, 0.676250, 	// 517
	0.930310, 0.676250, 	// 518
	0.977410, 0.961320, 	// 519
	0.553500, 0.961320, 	// 520
	0.600600, 0.961320, 	// 521
	0.647710, 0.961320, 	// 522
	0.694800, 0.961320, 	// 523
	0.741900, 0.961320, 	// 524
	0.789010, 0.961320, 	// 525
	0.836100, 0.961320, 	// 526
	0.883210, 0.961320, 	// 527
	0.930310, 0.961320, 	// 528
	0.953850, 0.961320, 	// 529
	0.687310, 0.118860, 	// 530
	0.685140, 0.109990, 	// 531
	0.709420, 0.276630, 	// 532
	0.685090, 0.142700, 	// 533
	0.691600, 0.150300, 	// 534
	0.650910, 0.122850, 	// 535
	0.671710, 0.336660, 	// 536
	0.656100, 0.118860, 	// 537
	0.697080, 0.273570, 	// 538
	0.699060, 0.179430, 	// 539
	0.690110, 0.171820, 	// 540
	0.646330, 0.273570, 	// 541
	0.633990, 0.276630, 	// 542
	0.658320, 0.142700, 	// 543
	0.651810, 0.150300, 	// 544
	0.644350, 0.179430, 	// 545
	0.653300, 0.171820, 	// 546
	0.945470, 0.143330, 	// 547
	0.944480, 0.141400, 	// 548
	0.971970, 0.143330, 	// 549
	0.944440, 0.170750, 	// 550
	0.971970, 0.131480, 	// 551
	0.944790, 0.149410, 	// 552
	0.945470, 0.131480, 	// 553
	0.944480, 0.153250, 	// 554
	0.959880, 0.142640, 	// 555
	0.979750, 0.142640, 	// 556
	0.979750, 0.152020, 	// 557
	0.959880, 0.152020, 	// 558
	0.945470, 0.143330, 	// 559
	0.944480, 0.141400, 	// 560
	0.971970, 0.143330, 	// 561
	0.944440, 0.170750, 	// 562
	0.971970, 0.131480, 	// 563
	0.944790, 0.149410, 	// 564
	0.945470, 0.131480, 	// 565
	0.944480, 0.153250, 	// 566
	0.959880, 0.142640, 	// 567
	0.979750, 0.142640, 	// 568
	0.979750, 0.152020, 	// 569
	0.959880, 0.152020, 	// 570
	0.945470, 0.143330, 	// 571
	0.944480, 0.141400, 	// 572
	0.971970, 0.143330, 	// 573
	0.944440, 0.170750, 	// 574
	0.971970, 0.131480, 	// 575
	0.944790, 0.149410, 	// 576
	0.945470, 0.131480, 	// 577
	0.944480, 0.153250, 	// 578
	0.959880, 0.142640, 	// 579
	0.979750, 0.142640, 	// 580
	0.979750, 0.152020, 	// 581
	0.959880, 0.152020, 	// 582
	0.984840, 0.090560, 	// 583
	0.984840, 0.111630, 	// 584
	0.778350, 0.090560, 	// 585
	0.778350, 0.111630, 	// 586
	0.778350, 0.090560, 	// 587
	0.778350, 0.111630, 	// 588
	0.778350, 0.090560, 	// 589
	0.778350, 0.111630, 	// 590
	0.984840, 0.090560, 	// 591
	0.984840, 0.111630, 	// 592
	0.778350, 0.090560, 	// 593
	0.778350, 0.111630, 	// 594
	0.778350, 0.090560, 	// 595
	0.778350, 0.111630, 	// 596
	0.778350, 0.090560, 	// 597
	0.778350, 0.111630, 	// 598
	0.742740, 0.030450, 	// 599
	0.742740, 0.017810, 	// 600
	0.969730, 0.030450, 	// 601
	0.969730, 0.017810, 	// 602
	0.856240, 0.030450, 	// 603
	0.856240, 0.017810, 	// 604
	0.912980, 0.030450, 	// 605
	0.912980, 0.017810, 	// 606
	0.799490, 0.030450, 	// 607
	0.799490, 0.017810, 	// 608
	0.884610, 0.030450, 	// 609
	0.884610, 0.017810, 	// 610
	0.827860, 0.030450, 	// 611
	0.827860, 0.017810, 	// 612
	0.941360, 0.030450, 	// 613
	0.941360, 0.017810, 	// 614
	0.771120, 0.030450, 	// 615
	0.771120, 0.017810, 	// 616
	0.000000, 0.000000, 	// 617
	0.000000, 0.000000, 	// 618
	0.000000, 0.000000, 	// 619
	0.000000, 0.000000, 	// 620
	0.000000, 0.000000, 	// 621
	0.000000, 0.000000, 	// 622
	0.000000, 0.000000, 	// 623
	0.000000, 0.000000, 	// 624
	0.000000, 0.000000, 	// 625
	0.000000, 0.000000, 	// 626
	0.000000, 0.000000, 	// 627
	0.000000, 0.000000, 	// 628
	0.000000, 0.000000, 	// 629
	0.000000, 0.000000, 	// 630
	0.000000, 0.000000, 	// 631
	0.000000, 0.000000, 	// 632
	0.000000, 0.000000, 	// 633
	0.000000, 0.000000, 	// 634
	0.000000, 0.000000, 	// 635
	0.000000, 0.000000, 	// 636
	0.000000, 0.000000, 	// 637
	0.000000, 0.000000, 	// 638
	0.000000, 0.000000, 	// 639
	0.000000, 0.000000, 	// 640
	0.000000, 0.000000, 	// 641
	0.000000, 0.000000, 	// 642
	0.000000, 0.000000, 	// 643
	0.000000, 0.000000, 	// 644
	0.000000, 0.000000, 	// 645
	0.000000, 0.000000, 	// 646
	0.000000, 0.000000, 	// 647
	0.000000, 0.000000, 	// 648
	0.000000, 0.000000, 	// 649
	0.000000, 0.000000, 	// 650
	0.000000, 0.000000, 	// 651
	0.000000, 0.000000, 	// 652
	0.000000, 0.000000, 	// 653
	0.000000, 0.000000, 	// 654
	0.000000, 0.000000, 	// 655
	0.000000, 0.000000, 	// 656
	0.000000, 0.000000, 	// 657
	0.000000, 0.000000, 	// 658
	0.000000, 0.000000, 	// 659
	0.000000, 0.000000, 	// 660
	0.000000, 0.000000, 	// 661
	0.000000, 0.000000, 	// 662
	0.000000, 0.000000, 	// 663
	0.000000, 0.000000, 	// 664
	0.000000, 0.000000, 	// 665
	0.000000, 0.000000, 	// 666
	0.000000, 0.000000, 	// 667
	0.000000, 0.000000, 	// 668
	0.000000, 0.000000, 	// 669
	0.000000, 0.000000, 	// 670
	0.000000, 0.000000, 	// 671
	0.000000, 0.000000, 	// 672
	0.000000, 0.000000, 	// 673
	0.000000, 0.000000, 	// 674
	0.000000, 0.000000, 	// 675
	0.000000, 0.000000, 	// 676
	0.000000, 0.000000, 	// 677
	0.000000, 0.000000, 	// 678
	0.000000, 0.000000, 	// 679
	0.000000, 0.000000, 	// 680
	0.000000, 0.000000, 	// 681
	0.000000, 0.000000, 	// 682
	0.000000, 0.000000, 	// 683
	0.000000, 0.000000, 	// 684
	0.000000, 0.000000, 	// 685
	0.000000, 0.000000, 	// 686
	0.000000, 0.000000, 	// 687
	0.000000, 0.000000, 	// 688
	0.000000, 0.000000, 	// 689
	0.000000, 0.000000, 	// 690
	0.000000, 0.000000, 	// 691
	0.000000, 0.000000, 	// 692
	0.000000, 0.000000, 	// 693
	0.000000, 0.000000, 	// 694
	0.000000, 0.000000, 	// 695
	0.000000, 0.000000, 	// 696
	0.000000, 0.000000, 	// 697
	0.000000, 0.000000, 	// 698
	0.000000, 0.000000, 	// 699
	0.000000, 0.000000, 	// 700
	0.000000, 0.000000, 	// 701
	0.000000, 0.000000, 	// 702
	0.000000, 0.000000, 	// 703
	0.000000, 0.000000, 	// 704
	0.000000, 0.000000, 	// 705
	0.000000, 0.000000, 	// 706
	0.000000, 0.000000, 	// 707
	0.000000, 0.000000, 	// 708
	0.000000, 0.000000, 	// 709
	0.000000, 0.000000, 	// 710
	0.000000, 0.000000, 	// 711
	0.000000, 0.000000, 	// 712
	0.000000, 0.000000, 	// 713
	0.000000, 0.000000, 	// 714
	0.000000, 0.000000, 	// 715
	0.000000, 0.000000, 	// 716
	0.000000, 0.000000, 	// 717
	0.000000, 0.000000, 	// 718
	0.000000, 0.000000, 	// 719
	0.000000, 0.000000, 	// 720
	0.000000, 0.000000, 	// 721
	0.000000, 0.000000, 	// 722
	0.000000, 0.000000, 	// 723
	0.000000, 0.000000, 	// 724
	0.000000, 0.000000, 	// 725
	0.000000, 0.000000, 	// 726
	0.000000, 0.000000, 	// 727
	0.000000, 0.000000, 	// 728
	0.000000, 0.000000, 	// 729
	0.000000, 0.000000, 	// 730
	0.000000, 0.000000, 	// 731
	0.000000, 0.000000, 	// 732
	0.000000, 0.000000, 	// 733
	0.000000, 0.000000, 	// 734
	0.000000, 0.000000, 	// 735
	0.000000, 0.000000, 	// 736
	0.000000, 0.000000, 	// 737
	0.000000, 0.000000, 	// 738
	0.000000, 0.000000, 	// 739
	0.000000, 0.000000, 	// 740
	0.000000, 0.000000, 	// 741
	0.000000, 0.000000, 	// 742
	0.000000, 0.000000, 	// 743
	0.000000, 0.000000, 	// 744
	0.000000, 0.000000, 	// 745
	0.000000, 0.000000, 	// 746
	0.000000, 0.000000, 	// 747
	0.000000, 0.000000, 	// 748
	0.000000, 0.000000, 	// 749
	0.000000, 0.000000, 	// 750
	0.000000, 0.000000, 	// 751
	0.000000, 0.000000, 	// 752
	0.000000, 0.000000, 	// 753
	0.000000, 0.000000, 	// 754
	0.000000, 0.000000, 	// 755
	0.000000, 0.000000, 	// 756
	0.000000, 0.000000, 	// 757
	0.000000, 0.000000, 	// 758
	0.000000, 0.000000, 	// 759
	0.000000, 0.000000, 	// 760
	0.000000, 0.000000, 	// 761
	0.000000, 0.000000, 	// 762
	0.000000, 0.000000, 	// 763
	0.000000, 0.000000, 	// 764
	0.000000, 0.000000, 	// 765
	0.000000, 0.000000, 	// 766
	0.000000, 0.000000, 	// 767
	0.000000, 0.000000, 	// 768
	0.000000, 0.000000, 	// 769
	0.000000, 0.000000, 	// 770
	0.000000, 0.000000, 	// 771
	0.000000, 0.000000, 	// 772
	0.000000, 0.000000, 	// 773
	0.000000, 0.000000, 	// 774
	0.000000, 0.000000, 	// 775
	0.000000, 0.000000, 	// 776
	0.000000, 0.000000, 	// 777
	0.000000, 0.000000, 	// 778
	0.000000, 0.000000, 	// 779
	0.000000, 0.000000, 	// 780
	0.000000, 0.000000, 	// 781
	0.000000, 0.000000, 	// 782
	0.000000, 0.000000, 	// 783
	0.000000, 0.000000, 	// 784
	0.000000, 0.000000, 	// 785
	0.000000, 0.000000, 	// 786
	0.000000, 0.000000, 	// 787
	0.000000, 0.000000, 	// 788
	0.000000, 0.000000, 	// 789
	0.000000, 0.000000, 	// 790
	0.000000, 0.000000, 	// 791
	0.000000, 0.000000, 	// 792
	0.000000, 0.000000, 	// 793
	0.000000, 0.000000, 	// 794
	0.000000, 0.000000, 	// 795
	0.000000, 0.000000, 	// 796
	0.000000, 0.000000, 	// 797
	0.000000, 0.000000, 	// 798
	0.000000, 0.000000, 	// 799
	0.000000, 0.000000, 	// 800
	0.000000, 0.000000, 	// 801
	0.000000, 0.000000, 	// 802
	0.000000, 0.000000, 	// 803
	0.000000, 0.000000, 	// 804
	0.000000, 0.000000, 	// 805
	0.000000, 0.000000, 	// 806
	0.000000, 0.000000, 	// 807
	0.000000, 0.000000, 	// 808
	0.000000, 0.000000, 	// 809
	0.000000, 0.000000, 	// 810
	0.000000, 0.000000, 	// 811
	0.000000, 0.000000, 	// 812
	0.000000, 0.000000, 	// 813
	0.000000, 0.000000, 	// 814
	0.000000, 0.000000, 	// 815
	0.000000, 0.000000, 	// 816
	0.000000, 0.000000, 	// 817
	0.000000, 0.000000, 	// 818
	0.000000, 0.000000, 	// 819
	0.000000, 0.000000, 	// 820
	0.000000, 0.000000, 	// 821
	0.000000, 0.000000, 	// 822
	0.000000, 0.000000, 	// 823
	0.000000, 0.000000, 	// 824
	0.000000, 0.000000, 	// 825
	0.000000, 0.000000, 	// 826
	0.000000, 0.000000, 	// 827
	0.000000, 0.000000, 	// 828
	0.000000, 0.000000, 	// 829
	0.000000, 0.000000, 	// 830
	0.000000, 0.000000, 	// 831
	0.000000, 0.000000, 	// 832
	0.000000, 0.000000, 	// 833
	0.000000, 0.000000, 	// 834
	0.000000, 0.000000, 	// 835
	0.000000, 0.000000, 	// 836
	0.000000, 0.000000, 	// 837
	0.000000, 0.000000, 	// 838
	0.000000, 0.000000, 	// 839
	0.000000, 0.000000, 	// 840
	0.000000, 0.000000, 	// 841
	0.000000, 0.000000, 	// 842
	0.000000, 0.000000, 	// 843
	0.000000, 0.000000, 	// 844
	0.000000, 0.000000, 	// 845
	0.000000, 0.000000, 	// 846
	0.000000, 0.000000, 	// 847
	0.000000, 0.000000, 	// 848
	0.000000, 0.000000, 	// 849
	0.000000, 0.000000, 	// 850
	0.000000, 0.000000, 	// 851
	0.000000, 0.000000, 	// 852
	0.000000, 0.000000, 	// 853
	0.000000, 0.000000, 	// 854
	0.000000, 0.000000, 	// 855
	0.000000, 0.000000, 	// 856
	0.000000, 0.000000, 	// 857
	0.000000, 0.000000, 	// 858
	0.000000, 0.000000, 	// 859
	0.000000, 0.000000, 	// 860
	0.000000, 0.000000, 	// 861
	0.000000, 0.000000, 	// 862
	0.000000, 0.000000, 	// 863
	0.000000, 0.000000, 	// 864
	0.000000, 0.000000, 	// 865
	0.000000, 0.000000, 	// 866
	0.000000, 0.000000, 	// 867
	0.000000, 0.000000, 	// 868
	0.000000, 0.000000, 	// 869
	0.000000, 0.000000, 	// 870
	0.000000, 0.000000, 	// 871
	0.000000, 0.000000, 	// 872
	0.000000, 0.000000, 	// 873
	0.000000, 0.000000, 	// 874
	0.000000, 0.000000, 	// 875
	0.000000, 0.000000, 	// 876
	0.000000, 0.000000, 	// 877
	0.000000, 0.000000, 	// 878
	0.000000, 0.000000, 	// 879
	0.000000, 0.000000, 	// 880
	0.000000, 0.000000, 	// 881
	0.000000, 0.000000, 	// 882
	0.000000, 0.000000, 	// 883
	0.000000, 0.000000, 	// 884
	0.000000, 0.000000, 	// 885
	0.000000, 0.000000, 	// 886
	0.000000, 0.000000, 	// 887
	0.000000, 0.000000, 	// 888
	0.000000, 0.000000, 	// 889
	0.000000, 0.000000, 	// 890
	0.000000, 0.000000, 	// 891
	0.000000, 0.000000, 	// 892
	0.000000, 0.000000, 	// 893
	0.000000, 0.000000, 	// 894
	0.000000, 0.000000, 	// 895
	0.000000, 0.000000, 	// 896
	0.000000, 0.000000, 	// 897
	0.000000, 0.000000, 	// 898
	0.000000, 0.000000, 	// 899
	0.000000, 0.000000, 	// 900
	0.000000, 0.000000, 	// 901
	0.000000, 0.000000, 	// 902
	0.000000, 0.000000, 	// 903
	0.000000, 0.000000, 	// 904
	0.000000, 0.000000, 	// 905
	0.000000, 0.000000, 	// 906
	0.000000, 0.000000, 	// 907
	0.000000, 0.000000, 	// 908
	0.000000, 0.000000, 	// 909
	0.000000, 0.000000, 	// 910
	0.000000, 0.000000, 	// 911
	0.000000, 0.000000, 	// 912
	0.000000, 0.000000, 	// 913
	0.000000, 0.000000, 	// 914
	0.000000, 0.000000, 	// 915
	0.000000, 0.000000, 	// 916
	0.000000, 0.000000, 	// 917
	0.000000, 0.000000, 	// 918
	0.000000, 0.000000, 	// 919
	0.000000, 0.000000, 	// 920
	0.000000, 0.000000, 	// 921
	0.000000, 0.000000, 	// 922
	0.000000, 0.000000, 	// 923
	0.000000, 0.000000, 	// 924
	0.000000, 0.000000, 	// 925
	0.000000, 0.000000, 	// 926
	0.000000, 0.000000, 	// 927
	0.000000, 0.000000, 	// 928
	0.000000, 0.000000, 	// 929
	0.000000, 0.000000, 	// 930
	0.000000, 0.000000, 	// 931
	0.000000, 0.000000, 	// 932
	0.000000, 0.000000, 	// 933
	0.000000, 0.000000, 	// 934
	0.000000, 0.000000, 	// 935
	0.000000, 0.000000, 	// 936
	0.000000, 0.000000, 	// 937
	0.000000, 0.000000, 	// 938
	0.000000, 0.000000, 	// 939
	0.000000, 0.000000, 	// 940
	0.000000, 0.000000, 	// 941
	0.000000, 0.000000, 	// 942
	0.000000, 0.000000, 	// 943
	0.000000, 0.000000, 	// 944
	0.000000, 0.000000, 	// 945
	0.000000, 0.000000, 	// 946
	0.000000, 0.000000, 	// 947
	0.000000, 0.000000, 	// 948
	0.000000, 0.000000, 	// 949
	0.000000, 0.000000, 	// 950
	0.000000, 0.000000, 	// 951
	0.000000, 0.000000, 	// 952
	0.000000, 0.000000, 	// 953
	0.000000, 0.000000, 	// 954
	0.000000, 0.000000, 	// 955
	0.000000, 0.000000, 	// 956
	0.000000, 0.000000, 	// 957
	0.000000, 0.000000, 	// 958
	0.000000, 0.000000, 	// 959
	0.000000, 0.000000, 	// 960
	0.000000, 0.000000, 	// 961
	0.000000, 0.000000, 	// 962
	0.000000, 0.000000, 	// 963
	0.000000, 0.000000, 	// 964
	0.000000, 0.000000, 	// 965
	0.000000, 0.000000, 	// 966
	0.000000, 0.000000, 	// 967
	0.000000, 0.000000, 	// 968
	0.000000, 0.000000, 	// 969
	0.000000, 0.000000, 	// 970
	0.000000, 0.000000, 	// 971
	0.000000, 0.000000, 	// 972
	0.000000, 0.000000, 	// 973
	0.000000, 0.000000, 	// 974
	0.000000, 0.000000, 	// 975
	0.000000, 0.000000, 	// 976
	0.000000, 0.000000, 	// 977
	0.000000, 0.000000, 	// 978
	0.000000, 0.000000, 	// 979
	0.000000, 0.000000, 	// 980
	0.000000, 0.000000, 	// 981
	0.000000, 0.000000, 	// 982
	0.000000, 0.000000, 	// 983
	0.000000, 0.000000, 	// 984
	0.000000, 0.000000, 	// 985
	0.000000, 0.000000, 	// 986
	0.000000, 0.000000, 	// 987
	0.000000, 0.000000, 	// 988
	0.000000, 0.000000, 	// 989
	0.000000, 0.000000, 	// 990
	0.000000, 0.000000, 	// 991
	0.000000, 0.000000, 	// 992
	0.000000, 0.000000, 	// 993
	0.000000, 0.000000, 	// 994
	0.000000, 0.000000, 	// 995
	0.000000, 0.000000, 	// 996
	0.000000, 0.000000, 	// 997
	0.000000, 0.000000, 	// 998
	0.000000, 0.000000, 	// 999
	0.000000, 0.000000, 	// 1000
	0.000000, 0.000000, 	// 1001
	0.000000, 0.000000, 	// 1002
	0.000000, 0.000000, 	// 1003
	0.000000, 0.000000, 	// 1004
	0.000000, 0.000000, 	// 1005
	0.000000, 0.000000, 	// 1006
	0.000000, 0.000000, 	// 1007
	0.000000, 0.000000, 	// 1008
	0.000000, 0.000000, 	// 1009
	0.000000, 0.000000, 	// 1010
	0.000000, 0.000000, 	// 1011
	0.000000, 0.000000, 	// 1012
	0.000000, 0.000000, 	// 1013
	0.000000, 0.000000, 	// 1014
	0.000000, 0.000000, 	// 1015
	0.000000, 0.000000, 	// 1016
	0.808300, 0.498150, 	// 1017
	0.834210, 0.488390, 	// 1018
	0.842330, 0.511730, 	// 1019
	0.802980, 0.509750, 	// 1020
	0.879410, 0.478260, 	// 1021
	0.927710, 0.481870, 	// 1022
	0.971130, 0.493810, 	// 1023
	0.945800, 0.516340, 	// 1024
	0.986150, 0.511020, 	// 1025
	0.984280, 0.536550, 	// 1026
	0.950430, 0.557530, 	// 1027
	0.960290, 0.566910, 	// 1028
	0.825110, 0.543130, 	// 1029
	0.799150, 0.542080, 	// 1030
	0.826350, 0.575060, 	// 1031
	0.806320, 0.573010, 	// 1032
	0.886340, 0.522380, 	// 1033
	0.909610, 0.527980, 	// 1034
	0.951510, 0.536230, 	// 1035
	0.975160, 0.547110, 	// 1036
	0.795060, 0.496770, 	// 1037
	0.784340, 0.499590, 	// 1038
	0.772790, 0.511700, 	// 1039
	0.770900, 0.506420, 	// 1040
	0.877210, 0.505550, 	// 1041
	0.910250, 0.512070, 	// 1042
	0.807720, 0.488800, 	// 1043
	0.825300, 0.482830, 	// 1044
	0.876600, 0.472240, 	// 1045
	0.939210, 0.477380, 	// 1046
	0.977920, 0.490360, 	// 1047
	0.995900, 0.503880, 	// 1048
	0.795710, 0.493180, 	// 1049
	0.994690, 0.532670, 	// 1050
	0.967090, 0.566420, 	// 1051
	0.988250, 0.545770, 	// 1052
	0.922490, 0.499590, 	// 1053
	0.938760, 0.520060, 	// 1054
	0.942880, 0.555950, 	// 1055
	0.918370, 0.526730, 	// 1056
	0.940560, 0.527190, 	// 1057
	0.917930, 0.511780, 	// 1058
	0.945330, 0.586870, 	// 1059
	0.848000, 0.517790, 	// 1060
	0.873300, 0.490300, 	// 1061
	0.835930, 0.547130, 	// 1062
	0.835710, 0.574720, 	// 1063
	0.880230, 0.522220, 	// 1064
	0.871640, 0.510300, 	// 1065
	0.911450, 0.556070, 	// 1066
	0.788860, 0.520180, 	// 1067
	0.791980, 0.542150, 	// 1068
	0.799940, 0.575330, 	// 1069
	0.773220, 0.516810, 	// 1070
	0.825110, 0.602130, 	// 1071
	0.783550, 0.495850, 	// 1072
	0.765290, 0.506190, 	// 1073
	0.754390, 0.516660, 	// 1074
	0.924730, 0.510550, 	// 1075
	0.864310, 0.509670, 	// 1076
	0.000000, 0.000000, 	// 1077
	0.000000, 0.000000, 	// 1078
	0.000000, 0.000000, 	// 1079
	0.000000, 0.000000, 	// 1080
	0.000000, 0.000000, 	// 1081
	0.000000, 0.000000, 	// 1082
	0.000000, 0.000000, 	// 1083
	0.000000, 0.000000, 	// 1084
	0.000000, 0.000000, 	// 1085
	0.000000, 0.000000, 	// 1086
	0.000000, 0.000000, 	// 1087
	0.000000, 0.000000, 	// 1088
	0.000000, 0.000000, 	// 1089
	0.000000, 0.000000, 	// 1090
	0.000000, 0.000000, 	// 1091
	0.000000, 0.000000, 	// 1092
	0.000000, 0.000000, 	// 1093
	0.000000, 0.000000, 	// 1094
	0.000000, 0.000000, 	// 1095
	0.000000, 0.000000, 	// 1096
	0.000000, 0.000000, 	// 1097
	0.000000, 0.000000, 	// 1098
	0.000000, 0.000000, 	// 1099
	0.000000, 0.000000, 	// 1100
	0.000000, 0.000000, 	// 1101
	0.000000, 0.000000, 	// 1102
	0.000000, 0.000000, 	// 1103
	0.000000, 0.000000, 	// 1104
	0.000000, 0.000000, 	// 1105
	0.000000, 0.000000, 	// 1106
	0.000000, 0.000000, 	// 1107
	0.000000, 0.000000, 	// 1108
	0.000000, 0.000000, 	// 1109
	0.000000, 0.000000, 	// 1110
	0.000000, 0.000000, 	// 1111
	0.000000, 0.000000, 	// 1112
	0.000000, 0.000000, 	// 1113
	0.000000, 0.000000, 	// 1114
	0.000000, 0.000000, 	// 1115
	0.000000, 0.000000, 	// 1116
	0.000000, 0.000000, 	// 1117
	0.000000, 0.000000, 	// 1118
	0.000000, 0.000000, 	// 1119
	0.000000, 0.000000, 	// 1120
	0.000000, 0.000000, 	// 1121
	0.000000, 0.000000, 	// 1122
	0.000000, 0.000000, 	// 1123
	0.000000, 0.000000, 	// 1124
	0.000000, 0.000000, 	// 1125
	0.000000, 0.000000, 	// 1126
	0.000000, 0.000000, 	// 1127
	0.000000, 0.000000, 	// 1128
	0.000000, 0.000000, 	// 1129
	0.000000, 0.000000, 	// 1130
	0.000000, 0.000000, 	// 1131
	0.000000, 0.000000, 	// 1132
	0.000000, 0.000000, 	// 1133
	0.000000, 0.000000, 	// 1134
	0.000000, 0.000000, 	// 1135
	0.000000, 0.000000, 	// 1136
	0.000000, 0.000000, 	// 1137
	0.000000, 0.000000, 	// 1138
	0.000000, 0.000000, 	// 1139
	0.000000, 0.000000, 	// 1140
	0.000000, 0.000000, 	// 1141
	0.000000, 0.000000, 	// 1142
	0.000000, 0.000000, 	// 1143
	0.000000, 0.000000, 	// 1144
	0.000000, 0.000000, 	// 1145
	0.000000, 0.000000, 	// 1146
	0.000000, 0.000000, 	// 1147
	0.000000, 0.000000, 	// 1148
	0.000000, 0.000000, 	// 1149
	0.000000, 0.000000, 	// 1150
	0.000000, 0.000000, 	// 1151
	0.000000, 0.000000, 	// 1152
	0.000000, 0.000000, 	// 1153
	0.000000, 0.000000, 	// 1154
	0.000000, 0.000000, 	// 1155
	0.000000, 0.000000, 	// 1156
	0.000000, 0.000000, 	// 1157
	0.000000, 0.000000, 	// 1158
	0.000000, 0.000000, 	// 1159
	0.000000, 0.000000, 	// 1160
	0.000000, 0.000000, 	// 1161
	0.000000, 0.000000, 	// 1162
	0.000000, 0.000000, 	// 1163
	0.000000, 0.000000, 	// 1164
	0.000000, 0.000000, 	// 1165
	0.000000, 0.000000, 	// 1166
	0.000000, 0.000000, 	// 1167
	0.000000, 0.000000, 	// 1168
	0.000000, 0.000000, 	// 1169
	0.000000, 0.000000, 	// 1170
	0.000000, 0.000000, 	// 1171
	0.000000, 0.000000, 	// 1172
	0.000000, 0.000000, 	// 1173
	0.000000, 0.000000, 	// 1174
	0.000000, 0.000000, 	// 1175
	0.000000, 0.000000, 	// 1176
	0.000000, 0.000000, 	// 1177
	0.000000, 0.000000, 	// 1178
	0.000000, 0.000000, 	// 1179
	0.000000, 0.000000, 	// 1180
	0.000000, 0.000000, 	// 1181
	0.000000, 0.000000, 	// 1182
	0.000000, 0.000000, 	// 1183
	0.000000, 0.000000, 	// 1184
	0.000000, 0.000000, 	// 1185
	0.000000, 0.000000, 	// 1186
	0.000000, 0.000000, 	// 1187
	0.000000, 0.000000, 	// 1188
	0.000000, 0.000000, 	// 1189
	0.000000, 0.000000, 	// 1190
	0.000000, 0.000000, 	// 1191
	0.000000, 0.000000, 	// 1192
	0.000000, 0.000000, 	// 1193
	0.000000, 0.000000, 	// 1194
	0.000000, 0.000000, 	// 1195
	0.000000, 0.000000, 	// 1196
	0.000000, 0.000000, 	// 1197
	0.000000, 0.000000, 	// 1198
	0.000000, 0.000000, 	// 1199
	0.000000, 0.000000, 	// 1200
	0.000000, 0.000000, 	// 1201
	0.000000, 0.000000, 	// 1202
	0.000000, 0.000000, 	// 1203
	0.000000, 0.000000, 	// 1204
	0.000000, 0.000000, 	// 1205
	0.378200, 0.308670, 	// 1206
	0.453880, 0.308670, 	// 1207
	0.378200, 0.384350, 	// 1208
	0.453880, 0.384350, 	// 1209
	0.453880, 0.308670, 	// 1210
	0.378200, 0.308670, 	// 1211
	0.453880, 0.384350, 	// 1212
	0.378200, 0.384350,		// 1213
/* arm */
	0.524770, 0.379990, 	// 0
	0.472560, 0.629020, 	// 1
	0.552230, 0.392640, 	// 2
	0.536970, 0.629020, 	// 3
	0.628400, 0.395180, 	// 4
	0.653850, 0.629020, 	// 5
	0.649130, 0.381220, 	// 6
	0.736260, 0.629020, 	// 7
	0.595580, 0.379100, 	// 8
	0.658230, 0.367710, 	// 9
	0.590510, 0.629020, 	// 10
	0.783530, 0.629680, 	// 11
	0.547600, 0.424600, 	// 12
	0.524030, 0.421110, 	// 13
	0.592400, 0.430230, 	// 14
	0.704090, 0.414210, 	// 15
	0.631600, 0.436100, 	// 16
	0.653410, 0.414880, 	// 17
	0.536850, 0.553430, 	// 18
	0.591480, 0.553430, 	// 19
	0.483900, 0.553430, 	// 20
	0.642610, 0.553430, 	// 21
	0.755360, 0.552770, 	// 22
	0.732050, 0.553430, 	// 23
	0.965070, 0.136240, 	// 24
	0.948670, 0.136240, 	// 25
	0.951950, 0.136240, 	// 26
	0.955230, 0.136240, 	// 27
	0.958510, 0.136240, 	// 28
	0.961790, 0.136240, 	// 29
	0.965070, 0.139520, 	// 30
	0.948670, 0.139520, 	// 31
	0.951950, 0.139520, 	// 32
	0.955230, 0.139520, 	// 33
	0.958510, 0.139520, 	// 34
	0.961790, 0.139520, 	// 35
	0.965070, 0.142800, 	// 36
	0.948670, 0.142800, 	// 37
	0.951950, 0.142800, 	// 38
	0.955230, 0.142800, 	// 39
	0.958510, 0.142800, 	// 40
	0.961790, 0.142800, 	// 41
	0.965070, 0.146080, 	// 42
	0.948670, 0.146080, 	// 43
	0.951950, 0.146080, 	// 44
	0.955230, 0.146080, 	// 45
	0.958510, 0.146080, 	// 46
	0.961790, 0.146080, 	// 47
	0.963430, 0.149360, 	// 48
	0.524770, 0.379990, 	// 49
	0.472560, 0.629020, 	// 50
	0.552230, 0.392640, 	// 51
	0.536970, 0.629020, 	// 52
	0.628400, 0.395180, 	// 53
	0.653850, 0.629020, 	// 54
	0.649130, 0.381220, 	// 55
	0.736260, 0.629020, 	// 56
	0.595580, 0.379100, 	// 57
	0.658230, 0.367710, 	// 58
	0.590510, 0.629020, 	// 59
	0.783530, 0.629680, 	// 60
	0.547600, 0.424600, 	// 61
	0.524030, 0.421110, 	// 62
	0.592400, 0.430230, 	// 63
	0.704090, 0.414210, 	// 64
	0.631600, 0.436100, 	// 65
	0.653410, 0.414880, 	// 66
	0.536850, 0.553430, 	// 67
	0.591480, 0.553430, 	// 68
	0.483900, 0.553430, 	// 69
	0.642610, 0.553430, 	// 70
	0.755360, 0.552770, 	// 71
	0.732050, 0.553430, 	// 72
	0.965070, 0.136240, 	// 73
	0.948670, 0.136240, 	// 74
	0.951950, 0.136240, 	// 75
	0.955230, 0.136240, 	// 76
	0.958510, 0.136240, 	// 77
	0.961790, 0.136240, 	// 78
	0.965070, 0.139520, 	// 79
	0.948670, 0.139520, 	// 80
	0.951950, 0.139520, 	// 81
	0.955230, 0.139520, 	// 82
	0.958510, 0.139520, 	// 83
	0.961790, 0.139520, 	// 84
	0.965070, 0.142800, 	// 85
	0.948670, 0.142800, 	// 86
	0.951950, 0.142800, 	// 87
	0.955230, 0.142800, 	// 88
	0.958510, 0.142800, 	// 89
	0.961790, 0.142800, 	// 90
	0.965070, 0.146080, 	// 91
	0.948670, 0.146080, 	// 92
	0.951950, 0.146080, 	// 93
	0.955230, 0.146080, 	// 94
	0.958510, 0.146080, 	// 95
	0.961790, 0.146080, 	// 96
	0.963430, 0.149360,		// 97

	0.545940, 0.023350, 	// 0
	0.534870, 0.032720, 	// 1
	0.534940, 0.013380, 	// 2
	0.535380, 0.018170, 	// 3
	0.535330, 0.030130, 	// 4
	0.386490, 0.032000, 	// 5
	0.386250, 0.021650, 	// 6
	0.386570, 0.012660, 	// 7
	0.387010, 0.017450, 	// 8
	0.386960, 0.029410, 	// 9
	0.386650, 0.022630, 	// 10
	0.615780, 0.018240, 	// 11
	0.612360, 0.027300, 	// 12
	0.619280, 0.008590, 	// 13
	0.629480, 0.026400, 	// 14
	0.626330, 0.030620, 	// 15
	0.616950, 0.042980, 	// 16
	0.587680, 0.047820, 	// 17
	0.463260, 0.026970, 	// 18
	0.462870, 0.010220, 	// 19
	0.463310, 0.015020, 	// 20
	0.545940, 0.023350, 	// 21
	0.534870, 0.032720, 	// 22
	0.534620, 0.022370, 	// 23
	0.534940, 0.013380, 	// 24
	0.535330, 0.030130, 	// 25
	0.386490, 0.032000, 	// 26
	0.386250, 0.021650, 	// 27
	0.386570, 0.012660, 	// 28
	0.386960, 0.029410, 	// 29
	0.615780, 0.018240, 	// 30
	0.612360, 0.027300, 	// 31
	0.615910, 0.017280, 	// 32
	0.619280, 0.008590, 	// 33
	0.618690, 0.040230, 	// 34
	0.629480, 0.026400, 	// 35
	0.626330, 0.030620, 	// 36
	0.616950, 0.042980, 	// 37
	0.587680, 0.047820, 	// 38
	0.462790, 0.029570, 	// 39
	0.462550, 0.019210, 	// 40
	0.463260, 0.026970, 	// 41
	0.462870, 0.010220, 	// 42
	0.534620, 0.022370, 	// 43
	0.615910, 0.017280, 	// 44
	0.618690, 0.040230, 	// 45
	0.462790, 0.029570, 	// 46
	0.462550, 0.019210, 	// 47
	0.535380, 0.018170, 	// 48
	0.387010, 0.017450, 	// 49
	0.386650, 0.022630, 	// 50
	0.463310, 0.015020	 	// 51

],
indices: [
	8, 9, 10,	// 0
	8, 10, 11,	// 1
	8, 11, 12,	// 2
	8, 12, 13,	// 3
	48, 49, 50,	// 4
	48, 51, 52,	// 5
	48, 52, 53,	// 6
	48, 53, 49,	// 7
	54, 24, 29,	// 8
	58, 39, 34,	// 9
	57, 56, 38,	// 10
	58, 38, 39,	// 11
	58, 57, 38,	// 12
	65, 66, 67,	// 13
	65, 67, 68,	// 14
	65, 68, 69,	// 15
	65, 69, 70,	// 16
	96, 89, 88,	// 17
	96, 88, 64,	// 18
	92, 90, 89,	// 19
	97, 93, 92,	// 20
	97, 92, 95,	// 21
	96, 94, 89,	// 22
	93, 97, 95,	// 23
	94, 96, 64,	// 24
	98, 99, 100,	// 25
	98, 100, 101,	// 26
	98, 101, 102,	// 27
	98, 102, 103,	// 28
	109, 105, 104,	// 29
	109, 106, 105,	// 30
	109, 107, 106,	// 31
	109, 108, 107,	// 32
	109, 104, 115,	// 33
	135, 126, 125,	// 34
	148, 149, 150,	// 35
	148, 150, 151,	// 36
	148, 151, 152,	// 37
	148, 152, 153,	// 38
	148, 153, 154,	// 39
	148, 154, 155,	// 40
	148, 155, 149,	// 41
	163, 157, 156,	// 42
	163, 158, 157,	// 43
	163, 159, 158,	// 44
	163, 160, 159,	// 45
	163, 161, 160,	// 46
	163, 162, 161,	// 47
	163, 156, 162,	// 48
	198, 229, 230,	// 49
	198, 230, 231,	// 50
	198, 231, 232,	// 51
	198, 232, 233,	// 52
	198, 233, 234,	// 53
	198, 234, 235,	// 54
	198, 235, 236,	// 55
	198, 236, 237,	// 56
	198, 237, 238,	// 57
	198, 238, 229,	// 58
	9, 8, 271,	// 59
	271, 8, 272,	// 60
	272, 8, 273,	// 61
	273, 8, 13,	// 62
	295, 48, 50,	// 63
	51, 48, 296,	// 64
	296, 48, 297,	// 65
	297, 48, 295,	// 66
	24, 298, 29,	// 67
	289, 300, 286,	// 68
	56, 299, 38,	// 69
	38, 300, 289,	// 70
	299, 300, 38,	// 71
	66, 65, 306,	// 72
	306, 65, 307,	// 73
	307, 65, 308,	// 74
	308, 65, 70,	// 75
	322, 327, 321,	// 76
	321, 327, 305,	// 77
	323, 324, 322,	// 78
	93, 328, 324,	// 79
	324, 328, 326,	// 80
	325, 327, 322,	// 81
	328, 93, 326,	// 82
	327, 325, 305,	// 83
	99, 98, 329,	// 84
	329, 98, 330,	// 85
	330, 98, 331,	// 86
	331, 98, 103,	// 87
	333, 109, 332,	// 88
	334, 109, 333,	// 89
	335, 109, 334,	// 90
	108, 109, 335,	// 91
	332, 109, 115,	// 92
	345, 135, 125,	// 93
	364, 363, 365,	// 94
	365, 363, 366,	// 95
	366, 363, 367,	// 96
	367, 363, 368,	// 97
	368, 363, 369,	// 98
	369, 363, 370,	// 99
	370, 363, 364,	// 100
	372, 378, 371,	// 101
	373, 378, 372,	// 102
	374, 378, 373,	// 103
	375, 378, 374,	// 104
	376, 378, 375,	// 105
	377, 378, 376,	// 106
	371, 378, 377,	// 107
	444, 413, 445,	// 108
	445, 413, 446,	// 109
	446, 413, 447,	// 110
	447, 413, 448,	// 111
	448, 413, 449,	// 112
	449, 413, 450,	// 113
	450, 413, 451,	// 114
	451, 413, 452,	// 115
	452, 413, 453,	// 116
	453, 413, 444,	// 117
	508, 509, 510,	// 118
	508, 510, 511,	// 119
	508, 511, 512,	// 120
	508, 512, 513,	// 121
	508, 513, 514,	// 122
	508, 514, 515,	// 123
	508, 515, 516,	// 124
	508, 516, 517,	// 125
	508, 517, 518,	// 126
	508, 518, 509,	// 127
	529, 520, 519,	// 128
	529, 521, 520,	// 129
	529, 522, 521,	// 130
	529, 523, 522,	// 131
	529, 524, 523,	// 132
	529, 525, 524,	// 133
	529, 526, 525,	// 134
	529, 527, 526,	// 135
	529, 528, 527,	// 136
	529, 519, 528,	// 137
	536, 532, 538,	// 138
	542, 536, 541,	// 139
	536, 538, 541,	// 140
	298, 280, 283,	// 141
	298, 24, 280,	// 142
	25, 54, 30,	// 143
	25, 24, 54,	// 144
	2, 1, 3,	// 145
	2, 0, 1,	// 146
	4, 3, 5,	// 147
	4, 2, 3,	// 148
	6, 5, 7,	// 149
	6, 4, 5,	// 150
	0, 7, 1,	// 151
	0, 6, 7,	// 152
	10, 14, 15,	// 153
	10, 9, 14,	// 154
	11, 15, 16,	// 155
	11, 10, 15,	// 156
	12, 16, 17,	// 157
	12, 11, 16,	// 158
	13, 17, 18,	// 159
	13, 12, 17,	// 160
	15, 19, 20,	// 161
	15, 14, 19,	// 162
	16, 20, 21,	// 163
	16, 15, 20,	// 164
	17, 21, 22,	// 165
	17, 16, 21,	// 166
	18, 22, 23,	// 167
	18, 17, 22,	// 168
	20, 24, 25,	// 169
	20, 19, 24,	// 170
	21, 25, 26,	// 171
	21, 20, 25,	// 172
	22, 26, 27,	// 173
	22, 21, 26,	// 174
	23, 27, 28,	// 175
	23, 22, 27,	// 176
	26, 30, 31,	// 177
	26, 25, 30,	// 178
	27, 31, 32,	// 179
	27, 26, 31,	// 180
	28, 32, 33,	// 181
	28, 27, 32,	// 182
	31, 34, 35,	// 183
	31, 30, 34,	// 184
	32, 35, 36,	// 185
	32, 31, 35,	// 186
	33, 36, 37,	// 187
	33, 32, 36,	// 188
	35, 39, 40,	// 189
	35, 34, 39,	// 190
	36, 40, 41,	// 191
	36, 35, 40,	// 192
	37, 41, 42,	// 193
	37, 36, 41,	// 194
	44, 39, 38,	// 195
	44, 43, 39,	// 196
	45, 41, 46,	// 197
	45, 42, 41,	// 198
	46, 40, 47,	// 199
	46, 41, 40,	// 200
	43, 40, 39,	// 201
	43, 47, 40,	// 202
	50, 43, 44,	// 203
	50, 49, 43,	// 204
	52, 45, 46,	// 205
	52, 51, 45,	// 206
	53, 46, 47,	// 207
	53, 52, 46,	// 208
	49, 47, 43,	// 209
	49, 53, 47,	// 210
	30, 58, 34,	// 211
	30, 54, 58,	// 212
	55, 54, 29,	// 213
	55, 58, 54,	// 214
	58, 56, 57,	// 215
	58, 55, 56,	// 216
	71, 60, 72,	// 217
	71, 59, 60,	// 218
	67, 71, 72,	// 219
	67, 66, 71,	// 220
	68, 72, 73,	// 221
	68, 67, 72,	// 222
	69, 73, 74,	// 223
	69, 68, 73,	// 224
	70, 74, 75,	// 225
	70, 69, 74,	// 226
	76, 60, 61,	// 227
	76, 72, 60,	// 228
	73, 76, 77,	// 229
	73, 72, 76,	// 230
	73, 78, 74,	// 231
	73, 77, 78,	// 232
	75, 78, 79,	// 233
	75, 74, 78,	// 234
	76, 62, 80,	// 235
	76, 61, 62,	// 236
	77, 80, 81,	// 237
	77, 76, 80,	// 238
	78, 81, 82,	// 239
	78, 77, 81,	// 240
	79, 82, 83,	// 241
	79, 78, 82,	// 242
	80, 63, 84,	// 243
	80, 62, 63,	// 244
	81, 84, 85,	// 245
	81, 80, 84,	// 246
	82, 85, 86,	// 247
	82, 81, 85,	// 248
	82, 87, 83,	// 249
	82, 86, 87,	// 250
	88, 63, 64,	// 251
	88, 84, 63,	// 252
	84, 89, 85,	// 253
	84, 88, 89,	// 254
	86, 89, 90,	// 255
	86, 85, 89,	// 256
	87, 90, 91,	// 257
	87, 86, 90,	// 258
	91, 92, 93,	// 259
	91, 90, 92,	// 260
	92, 94, 95,	// 261
	92, 89, 94,	// 262
	110, 116, 111,	// 263
	110, 115, 116,	// 264
	116, 104, 105,	// 265
	116, 115, 104,	// 266
	111, 117, 112,	// 267
	111, 116, 117,	// 268
	116, 106, 117,	// 269
	116, 105, 106,	// 270
	112, 118, 113,	// 271
	112, 117, 118,	// 272
	117, 107, 118,	// 273
	117, 106, 107,	// 274
	113, 119, 114,	// 275
	113, 118, 119,	// 276
	118, 108, 119,	// 277
	118, 107, 108,	// 278
	101, 121, 102,	// 279
	101, 120, 121,	// 280
	120, 113, 121,	// 281
	120, 112, 113,	// 282
	112, 122, 111,	// 283
	112, 120, 122,	// 284
	120, 100, 122,	// 285
	120, 101, 100,	// 286
	102, 123, 103,	// 287
	102, 121, 123,	// 288
	121, 114, 123,	// 289
	121, 113, 114,	// 290
	111, 124, 110,	// 291
	111, 122, 124,	// 292
	122, 99, 124,	// 293
	122, 100, 99,	// 294
	131, 127, 128,	// 295
	131, 132, 127,	// 296
	132, 129, 130,	// 297
	132, 131, 129,	// 298
	133, 130, 129,	// 299
	133, 134, 130,	// 300
	134, 125, 126,	// 301
	134, 133, 125,	// 302
	131, 136, 138,	// 303
	131, 128, 136,	// 304
	129, 138, 137,	// 305
	129, 131, 138,	// 306
	133, 137, 139,	// 307
	133, 129, 137,	// 308
	125, 139, 135,	// 309
	125, 133, 139,	// 310
	142, 141, 143,	// 311
	142, 140, 141,	// 312
	144, 143, 145,	// 313
	144, 142, 143,	// 314
	146, 145, 147,	// 315
	146, 144, 145,	// 316
	140, 147, 141,	// 317
	140, 146, 147,	// 318
	144, 140, 142,	// 319
	144, 146, 140,	// 320
	143, 147, 145,	// 321
	143, 141, 147,	// 322
	165, 150, 149,	// 323
	165, 164, 150,	// 324
	164, 151, 150,	// 325
	164, 166, 151,	// 326
	165, 155, 168,	// 327
	165, 149, 155,	// 328
	166, 152, 151,	// 329
	166, 167, 152,	// 330
	167, 153, 152,	// 331
	167, 169, 153,	// 332
	168, 154, 170,	// 333
	168, 155, 154,	// 334
	153, 170, 154,	// 335
	153, 169, 170,	// 336
	165, 172, 164,	// 337
	165, 171, 172,	// 338
	171, 157, 172,	// 339
	171, 156, 157,	// 340
	156, 173, 162,	// 341
	156, 171, 173,	// 342
	171, 168, 173,	// 343
	171, 165, 168,	// 344
	172, 166, 164,	// 345
	172, 174, 166,	// 346
	172, 158, 174,	// 347
	172, 157, 158,	// 348
	162, 175, 161,	// 349
	162, 173, 175,	// 350
	173, 170, 175,	// 351
	173, 168, 170,	// 352
	174, 167, 166,	// 353
	174, 176, 167,	// 354
	176, 158, 159,	// 355
	176, 174, 158,	// 356
	175, 160, 161,	// 357
	175, 177, 160,	// 358
	177, 170, 169,	// 359
	177, 175, 170,	// 360
	176, 169, 167,	// 361
	176, 177, 169,	// 362
	177, 159, 160,	// 363
	177, 176, 159,	// 364
	189, 210, 188,	// 365
	189, 209, 210,	// 366
	210, 200, 199,	// 367
	210, 209, 200,	// 368
	200, 211, 202,	// 369
	200, 209, 211,	// 370
	209, 190, 211,	// 371
	209, 189, 190,	// 372
	188, 212, 197,	// 373
	188, 210, 212,	// 374
	212, 199, 201,	// 375
	212, 210, 199,	// 376
	202, 213, 204,	// 377
	202, 211, 213,	// 378
	211, 191, 213,	// 379
	211, 190, 191,	// 380
	197, 214, 196,	// 381
	197, 212, 214,	// 382
	214, 201, 203,	// 383
	214, 212, 201,	// 384
	213, 206, 204,	// 385
	213, 215, 206,	// 386
	215, 191, 192,	// 387
	215, 213, 191,	// 388
	214, 195, 196,	// 389
	214, 216, 195,	// 390
	214, 205, 216,	// 391
	214, 203, 205,	// 392
	215, 208, 206,	// 393
	215, 217, 208,	// 394
	217, 192, 193,	// 395
	217, 215, 192,	// 396
	216, 194, 195,	// 397
	216, 218, 194,	// 398
	216, 207, 218,	// 399
	216, 205, 207,	// 400
	208, 218, 207,	// 401
	208, 217, 218,	// 402
	218, 193, 194,	// 403
	218, 217, 193,	// 404
	178, 220, 179,	// 405
	178, 219, 220,	// 406
	219, 200, 220,	// 407
	219, 199, 200,	// 408
	199, 221, 201,	// 409
	199, 219, 221,	// 410
	221, 178, 187,	// 411
	221, 219, 178,	// 412
	179, 222, 180,	// 413
	179, 220, 222,	// 414
	220, 202, 222,	// 415
	220, 200, 202,	// 416
	221, 203, 201,	// 417
	221, 223, 203,	// 418
	223, 187, 186,	// 419
	223, 221, 187,	// 420
	222, 181, 180,	// 421
	222, 224, 181,	// 422
	222, 204, 224,	// 423
	222, 202, 204,	// 424
	223, 205, 203,	// 425
	223, 225, 205,	// 426
	225, 186, 185,	// 427
	225, 223, 186,	// 428
	181, 226, 182,	// 429
	181, 224, 226,	// 430
	226, 204, 206,	// 431
	226, 224, 204,	// 432
	225, 207, 205,	// 433
	225, 227, 207,	// 434
	227, 185, 184,	// 435
	227, 225, 185,	// 436
	182, 228, 183,	// 437
	182, 226, 228,	// 438
	228, 206, 208,	// 439
	228, 226, 206,	// 440
	227, 208, 207,	// 441
	227, 228, 208,	// 442
	227, 183, 228,	// 443
	227, 184, 183,	// 444
	230, 189, 188,	// 445
	230, 229, 189,	// 446
	230, 197, 231,	// 447
	230, 188, 197,	// 448
	231, 196, 232,	// 449
	231, 197, 196,	// 450
	233, 196, 195,	// 451
	233, 232, 196,	// 452
	234, 195, 194,	// 453
	234, 233, 195,	// 454
	234, 193, 235,	// 455
	234, 194, 193,	// 456
	235, 192, 236,	// 457
	235, 193, 192,	// 458
	236, 191, 237,	// 459
	236, 192, 191,	// 460
	238, 191, 190,	// 461
	238, 237, 191,	// 462
	229, 190, 189,	// 463
	229, 238, 190,	// 464
	247, 239, 241,	// 465
	247, 248, 239,	// 466
	247, 245, 248,	// 467
	247, 243, 245,	// 468
	249, 246, 244,	// 469
	249, 250, 246,	// 470
	250, 242, 240,	// 471
	250, 249, 242,	// 472
	252, 241, 239,	// 473
	252, 251, 241,	// 474
	241, 253, 247,	// 475
	241, 251, 253,	// 476
	254, 239, 248,	// 477
	254, 252, 239,	// 478
	253, 243, 247,	// 479
	253, 255, 243,	// 480
	254, 245, 256,	// 481
	254, 248, 245,	// 482
	243, 256, 245,	// 483
	243, 255, 256,	// 484
	257, 253, 251,	// 485
	257, 258, 253,	// 486
	258, 242, 249,	// 487
	258, 257, 242,	// 488
	257, 240, 242,	// 489
	257, 259, 240,	// 490
	259, 251, 252,	// 491
	259, 257, 251,	// 492
	258, 255, 253,	// 493
	258, 260, 255,	// 494
	260, 249, 244,	// 495
	260, 258, 249,	// 496
	259, 250, 240,	// 497
	259, 261, 250,	// 498
	261, 252, 254,	// 499
	261, 259, 252,	// 500
	255, 262, 256,	// 501
	255, 260, 262,	// 502
	260, 246, 262,	// 503
	260, 244, 246,	// 504
	250, 262, 246,	// 505
	250, 261, 262,	// 506
	261, 256, 262,	// 507
	261, 254, 256,	// 508
	266, 263, 265,	// 509
	266, 264, 263,	// 510
	268, 265, 267,	// 511
	268, 266, 265,	// 512
	270, 267, 269,	// 513
	270, 268, 267,	// 514
	264, 269, 263,	// 515
	264, 270, 269,	// 516
	274, 9, 271,	// 517
	274, 14, 9,	// 518
	275, 271, 272,	// 519
	275, 274, 271,	// 520
	276, 272, 273,	// 521
	276, 275, 272,	// 522
	18, 273, 13,	// 523
	18, 276, 273,	// 524
	277, 14, 274,	// 525
	277, 19, 14,	// 526
	278, 274, 275,	// 527
	278, 277, 274,	// 528
	279, 275, 276,	// 529
	279, 278, 275,	// 530
	23, 276, 18,	// 531
	23, 279, 276,	// 532
	280, 19, 277,	// 533
	280, 24, 19,	// 534
	281, 277, 278,	// 535
	281, 280, 277,	// 536
	282, 278, 279,	// 537
	282, 281, 278,	// 538
	28, 279, 23,	// 539
	28, 282, 279,	// 540
	284, 280, 281,	// 541
	284, 283, 280,	// 542
	285, 281, 282,	// 543
	285, 284, 281,	// 544
	33, 282, 28,	// 545
	33, 285, 282,	// 546
	287, 283, 284,	// 547
	287, 286, 283,	// 548
	288, 284, 285,	// 549
	288, 287, 284,	// 550
	37, 285, 33,	// 551
	37, 288, 285,	// 552
	290, 286, 287,	// 553
	290, 289, 286,	// 554
	290, 288, 291,	// 555
	290, 287, 288,	// 556
	291, 37, 42,	// 557
	291, 288, 37,	// 558
	38, 292, 44,	// 559
	38, 289, 292,	// 560
	291, 45, 293,	// 561
	291, 42, 45,	// 562
	290, 293, 294,	// 563
	290, 291, 293,	// 564
	289, 294, 292,	// 565
	289, 290, 294,	// 566
	292, 50, 44,	// 567
	292, 295, 50,	// 568
	45, 296, 293,	// 569
	45, 51, 296,	// 570
	294, 296, 297,	// 571
	294, 293, 296,	// 572
	294, 295, 292,	// 573
	294, 297, 295,	// 574
	300, 283, 286,	// 575
	300, 298, 283,	// 576
	298, 55, 29,	// 577
	298, 300, 55,	// 578
	56, 300, 299,	// 579
	56, 55, 300,	// 580
	301, 71, 309,	// 581
	301, 59, 71,	// 582
	71, 306, 309,	// 583
	71, 66, 306,	// 584
	309, 307, 310,	// 585
	309, 306, 307,	// 586
	310, 308, 311,	// 587
	310, 307, 308,	// 588
	75, 308, 70,	// 589
	75, 311, 308,	// 590
	301, 312, 302,	// 591
	301, 309, 312,	// 592
	312, 310, 313,	// 593
	312, 309, 310,	// 594
	314, 310, 311,	// 595
	314, 313, 310,	// 596
	79, 311, 75,	// 597
	79, 314, 311,	// 598
	303, 312, 315,	// 599
	303, 302, 312,	// 600
	315, 313, 316,	// 601
	315, 312, 313,	// 602
	316, 314, 317,	// 603
	316, 313, 314,	// 604
	83, 314, 79,	// 605
	83, 317, 314,	// 606
	304, 315, 318,	// 607
	304, 303, 315,	// 608
	318, 316, 319,	// 609
	318, 315, 316,	// 610
	320, 316, 317,	// 611
	320, 319, 316,	// 612
	87, 317, 83,	// 613
	87, 320, 317,	// 614
	304, 321, 305,	// 615
	304, 318, 321,	// 616
	322, 318, 319,	// 617
	322, 321, 318,	// 618
	323, 319, 320,	// 619
	323, 322, 319,	// 620
	91, 320, 87,	// 621
	91, 323, 320,	// 622
	324, 91, 93,	// 623
	324, 323, 91,	// 624
	325, 324, 326,	// 625
	325, 322, 324,	// 626
	339, 110, 336,	// 627
	339, 115, 110,	// 628
	332, 339, 333,	// 629
	332, 115, 339,	// 630
	340, 336, 337,	// 631
	340, 339, 336,	// 632
	334, 339, 340,	// 633
	334, 333, 339,	// 634
	341, 337, 338,	// 635
	341, 340, 337,	// 636
	335, 340, 341,	// 637
	335, 334, 340,	// 638
	119, 338, 114,	// 639
	119, 341, 338,	// 640
	108, 341, 119,	// 641
	108, 335, 341,	// 642
	343, 330, 331,	// 643
	343, 342, 330,	// 644
	338, 342, 343,	// 645
	338, 337, 342,	// 646
	344, 337, 336,	// 647
	344, 342, 337,	// 648
	329, 342, 344,	// 649
	329, 330, 342,	// 650
	123, 331, 103,	// 651
	123, 343, 331,	// 652
	114, 343, 123,	// 653
	114, 338, 343,	// 654
	124, 336, 110,	// 655
	124, 344, 336,	// 656
	99, 344, 124,	// 657
	99, 329, 344,	// 658
	127, 348, 128,	// 659
	127, 349, 348,	// 660
	346, 349, 347,	// 661
	346, 348, 349,	// 662
	347, 350, 346,	// 663
	347, 351, 350,	// 664
	125, 351, 345,	// 665
	125, 350, 351,	// 666
	136, 348, 353,	// 667
	136, 128, 348,	// 668
	353, 346, 352,	// 669
	353, 348, 346,	// 670
	352, 350, 354,	// 671
	352, 346, 350,	// 672
	354, 125, 135,	// 673
	354, 350, 125,	// 674
	358, 355, 357,	// 675
	358, 356, 355,	// 676
	360, 357, 359,	// 677
	360, 358, 357,	// 678
	362, 359, 361,	// 679
	362, 360, 359,	// 680
	356, 361, 355,	// 681
	356, 362, 361,	// 682
	357, 361, 359,	// 683
	357, 355, 361,	// 684
	360, 356, 358,	// 685
	360, 362, 356,	// 686
	365, 380, 364,	// 687
	365, 379, 380,	// 688
	366, 379, 365,	// 689
	366, 381, 379,	// 690
	370, 380, 383,	// 691
	370, 364, 380,	// 692
	367, 381, 366,	// 693
	367, 382, 381,	// 694
	368, 382, 367,	// 695
	368, 384, 382,	// 696
	369, 383, 385,	// 697
	369, 370, 383,	// 698
	385, 368, 369,	// 699
	385, 384, 368,	// 700
	387, 380, 379,	// 701
	387, 386, 380,	// 702
	372, 386, 387,	// 703
	372, 371, 386,	// 704
	388, 371, 377,	// 705
	388, 386, 371,	// 706
	383, 386, 388,	// 707
	383, 380, 386,	// 708
	381, 387, 379,	// 709
	381, 389, 387,	// 710
	373, 387, 389,	// 711
	373, 372, 387,	// 712
	376, 388, 377,	// 713
	376, 390, 388,	// 714
	385, 388, 390,	// 715
	385, 383, 388,	// 716
	382, 389, 381,	// 717
	382, 391, 389,	// 718
	373, 391, 374,	// 719
	373, 389, 391,	// 720
	375, 390, 376,	// 721
	375, 392, 390,	// 722
	385, 392, 384,	// 723
	385, 390, 392,	// 724
	384, 391, 382,	// 725
	384, 392, 391,	// 726
	374, 392, 375,	// 727
	374, 391, 392,	// 728
	425, 404, 403,	// 729
	425, 424, 404,	// 730
	415, 425, 414,	// 731
	415, 424, 425,	// 732
	426, 415, 417,	// 733
	426, 424, 415,	// 734
	405, 424, 426,	// 735
	405, 404, 424,	// 736
	427, 403, 412,	// 737
	427, 425, 403,	// 738
	414, 427, 416,	// 739
	414, 425, 427,	// 740
	428, 417, 419,	// 741
	428, 426, 417,	// 742
	406, 426, 428,	// 743
	406, 405, 426,	// 744
	429, 412, 411,	// 745
	429, 427, 412,	// 746
	416, 429, 418,	// 747
	416, 427, 429,	// 748
	421, 428, 419,	// 749
	421, 430, 428,	// 750
	406, 430, 407,	// 751
	406, 428, 430,	// 752
	410, 429, 411,	// 753
	410, 431, 429,	// 754
	420, 429, 431,	// 755
	420, 418, 429,	// 756
	423, 430, 421,	// 757
	423, 432, 430,	// 758
	407, 432, 408,	// 759
	407, 430, 432,	// 760
	409, 431, 410,	// 761
	409, 433, 431,	// 762
	422, 431, 433,	// 763
	422, 420, 431,	// 764
	433, 423, 422,	// 765
	433, 432, 423,	// 766
	408, 433, 409,	// 767
	408, 432, 433,	// 768
	435, 393, 394,	// 769
	435, 434, 393,	// 770
	415, 434, 435,	// 771
	415, 414, 434,	// 772
	436, 414, 416,	// 773
	436, 434, 414,	// 774
	402, 434, 436,	// 775
	402, 393, 434,	// 776
	395, 435, 394,	// 777
	395, 437, 435,	// 778
	417, 435, 437,	// 779
	417, 415, 435,	// 780
	418, 436, 416,	// 781
	418, 438, 436,	// 782
	402, 438, 401,	// 783
	402, 436, 438,	// 784
	396, 437, 395,	// 785
	396, 439, 437,	// 786
	419, 437, 439,	// 787
	419, 417, 437,	// 788
	420, 438, 418,	// 789
	420, 440, 438,	// 790
	400, 438, 440,	// 791
	400, 401, 438,	// 792
	397, 439, 396,	// 793
	397, 441, 439,	// 794
	419, 441, 421,	// 795
	419, 439, 441,	// 796
	422, 440, 420,	// 797
	422, 442, 440,	// 798
	399, 440, 442,	// 799
	399, 400, 440,	// 800
	443, 397, 398,	// 801
	443, 441, 397,	// 802
	421, 443, 423,	// 803
	421, 441, 443,	// 804
	423, 442, 422,	// 805
	423, 443, 442,	// 806
	398, 442, 443,	// 807
	398, 399, 442,	// 808
	403, 444, 445,	// 809
	403, 404, 444,	// 810
	412, 445, 446,	// 811
	412, 403, 445,	// 812
	411, 446, 447,	// 813
	411, 412, 446,	// 814
	411, 448, 410,	// 815
	411, 447, 448,	// 816
	410, 449, 409,	// 817
	410, 448, 449,	// 818
	408, 449, 450,	// 819
	408, 409, 449,	// 820
	407, 450, 451,	// 821
	407, 408, 450,	// 822
	406, 451, 452,	// 823
	406, 407, 451,	// 824
	406, 453, 405,	// 825
	406, 452, 453,	// 826
	405, 444, 404,	// 827
	405, 453, 444,	// 828
	456, 455, 457,	// 829
	456, 454, 455,	// 830
	458, 457, 459,	// 831
	458, 456, 457,	// 832
	460, 459, 461,	// 833
	460, 458, 459,	// 834
	454, 461, 455,	// 835
	454, 460, 461,	// 836
	458, 454, 456,	// 837
	458, 460, 454,	// 838
	462, 457, 455,	// 839
	462, 463, 457,	// 840
	463, 459, 457,	// 841
	463, 464, 459,	// 842
	464, 461, 459,	// 843
	464, 465, 461,	// 844
	465, 455, 461,	// 845
	465, 462, 455,	// 846
	463, 465, 464,	// 847
	463, 462, 465,	// 848
	476, 471, 470,	// 849
	476, 477, 471,	// 850
	477, 472, 473,	// 851
	477, 476, 472,	// 852
	474, 479, 475,	// 853
	474, 478, 479,	// 854
	478, 471, 479,	// 855
	478, 470, 471,	// 856
	480, 473, 472,	// 857
	480, 481, 473,	// 858
	480, 469, 481,	// 859
	480, 468, 469,	// 860
	482, 467, 466,	// 861
	482, 483, 467,	// 862
	482, 475, 483,	// 863
	482, 474, 475,	// 864
	488, 484, 486,	// 865
	488, 490, 484,	// 866
	487, 491, 489,	// 867
	487, 485, 491,	// 868
	493, 489, 491,	// 869
	493, 492, 489,	// 870
	492, 487, 489,	// 871
	492, 494, 487,	// 872
	493, 485, 495,	// 873
	493, 491, 485,	// 874
	487, 495, 485,	// 875
	487, 494, 495,	// 876
	496, 490, 488,	// 877
	496, 497, 490,	// 878
	497, 492, 493,	// 879
	497, 496, 492,	// 880
	492, 498, 494,	// 881
	492, 496, 498,	// 882
	498, 488, 486,	// 883
	498, 496, 488,	// 884
	490, 499, 484,	// 885
	490, 497, 499,	// 886
	499, 493, 495,	// 887
	499, 497, 493,	// 888
	494, 499, 495,	// 889
	494, 498, 499,	// 890
	498, 484, 499,	// 891
	498, 486, 484,	// 892
	502, 501, 503,	// 893
	502, 500, 501,	// 894
	504, 503, 505,	// 895
	504, 502, 503,	// 896
	506, 505, 507,	// 897
	506, 504, 505,	// 898
	500, 507, 501,	// 899
	500, 506, 507,	// 900
	504, 500, 502,	// 901
	504, 506, 500,	// 902
	503, 507, 505,	// 903
	503, 501, 507,	// 904
	510, 519, 520,	// 905
	510, 509, 519,	// 906
	511, 520, 521,	// 907
	511, 510, 520,	// 908
	512, 521, 522,	// 909
	512, 511, 521,	// 910
	513, 522, 523,	// 911
	513, 512, 522,	// 912
	514, 523, 524,	// 913
	514, 513, 523,	// 914
	515, 524, 525,	// 915
	515, 514, 524,	// 916
	516, 525, 526,	// 917
	516, 515, 525,	// 918
	517, 526, 527,	// 919
	517, 516, 526,	// 920
	518, 527, 528,	// 921
	518, 517, 527,	// 922
	509, 528, 519,	// 923
	509, 518, 528,	// 924
	530, 534, 531,	// 925
	530, 533, 534,	// 926
	531, 537, 530,	// 927
	531, 535, 537,	// 928
	539, 538, 532,	// 929
	539, 540, 538,	// 930
	540, 534, 533,	// 931
	540, 539, 534,	// 932
	535, 543, 537,	// 933
	535, 544, 543,	// 934
	541, 545, 542,	// 935
	541, 546, 545,	// 936
	543, 545, 546,	// 937
	543, 544, 545,	// 938
	538, 546, 541,	// 939
	538, 540, 546,	// 940
	533, 537, 543,	// 941
	533, 530, 537,	// 942
	540, 543, 546,	// 943
	540, 533, 543,	// 944
	549, 548, 550,	// 945
	549, 547, 548,	// 946
	551, 550, 552,	// 947
	551, 549, 550,	// 948
	553, 552, 554,	// 949
	553, 551, 552,	// 950
	547, 554, 548,	// 951
	547, 553, 554,	// 952
	551, 547, 549,	// 953
	551, 553, 547,	// 954
	555, 550, 548,	// 955
	555, 556, 550,	// 956
	556, 552, 550,	// 957
	556, 557, 552,	// 958
	557, 554, 552,	// 959
	557, 558, 554,	// 960
	558, 548, 554,	// 961
	558, 555, 548,	// 962
	556, 558, 557,	// 963
	556, 555, 558,	// 964
	561, 560, 562,	// 965
	561, 559, 560,	// 966
	563, 562, 564,	// 967
	563, 561, 562,	// 968
	565, 564, 566,	// 969
	565, 563, 564,	// 970
	559, 566, 560,	// 971
	559, 565, 566,	// 972
	563, 559, 561,	// 973
	563, 565, 559,	// 974
	567, 562, 560,	// 975
	567, 568, 562,	// 976
	568, 564, 562,	// 977
	568, 569, 564,	// 978
	569, 566, 564,	// 979
	569, 570, 566,	// 980
	570, 560, 566,	// 981
	570, 567, 560,	// 982
	568, 570, 569,	// 983
	568, 567, 570,	// 984
	573, 572, 574,	// 985
	573, 571, 572,	// 986
	575, 574, 576,	// 987
	575, 573, 574,	// 988
	577, 576, 578,	// 989
	577, 575, 576,	// 990
	571, 578, 572,	// 991
	571, 577, 578,	// 992
	575, 571, 573,	// 993
	575, 577, 571,	// 994
	579, 574, 572,	// 995
	579, 580, 574,	// 996
	580, 576, 574,	// 997
	580, 581, 576,	// 998
	581, 578, 576,	// 999
	581, 582, 578,	// 1000
	582, 572, 578,	// 1001
	582, 579, 572,	// 1002
	580, 582, 581,	// 1003
	580, 579, 582,	// 1004
	584, 585, 586,	// 1005
	584, 583, 585,	// 1006
	586, 587, 588,	// 1007
	586, 585, 587,	// 1008
	588, 589, 590,	// 1009
	588, 587, 589,	// 1010
	590, 583, 584,	// 1011
	590, 589, 583,	// 1012
	591, 594, 593,	// 1013
	591, 592, 594,	// 1014
	593, 596, 595,	// 1015
	593, 594, 596,	// 1016
	595, 598, 597,	// 1017
	595, 596, 598,	// 1018
	597, 592, 591,	// 1019
	597, 598, 592,	// 1020
	609, 604, 610,	// 1021
	609, 603, 604,	// 1022
	605, 610, 606,	// 1023
	605, 609, 610,	// 1024
	612, 607, 608,	// 1025
	612, 611, 607,	// 1026
	611, 604, 603,	// 1027
	611, 612, 604,	// 1028
	613, 606, 614,	// 1029
	613, 605, 606,	// 1030
	613, 602, 601,	// 1031
	613, 614, 602,	// 1032
	615, 600, 616,	// 1033
	615, 599, 600,	// 1034
	615, 608, 607,	// 1035
	615, 616, 608,	// 1036
	1059, 1028, 1027,	// 1037
	1071, 1031, 1032,	// 1038
	1066, 1034, 1033,	// 1039
	1074, 1039, 1040,	// 1040
	1059, 1051, 1028,	// 1041
	1066, 1056, 1034,	// 1042
	1059, 1027, 1055,	// 1043
	1053, 1054, 1024,	// 1044
	1053, 1042, 1058,	// 1045
	1071, 1063, 1031,	// 1046
	1066, 1033, 1064,	// 1047
	1061, 1019, 1060,	// 1048
	1061, 1065, 1041,	// 1049
	1071, 1032, 1069,	// 1050
	1074, 1070, 1039,	// 1051
	1074, 1040, 1073,	// 1052
	1053, 1058, 1075,	// 1053
	1053, 1075, 1054,	// 1054
	1061, 1060, 1076,	// 1055
	1061, 1076, 1065,	// 1056
	1017, 1019, 1018,	// 1057
	1017, 1020, 1019,	// 1058
	1018, 1061, 1021,	// 1059
	1018, 1019, 1061,	// 1060
	1061, 1022, 1021,	// 1061
	1061, 1053, 1022,	// 1062
	1053, 1023, 1022,	// 1063
	1053, 1024, 1023,	// 1064
	1025, 1024, 1026,	// 1065
	1025, 1023, 1024,	// 1066
	1029, 1020, 1030,	// 1067
	1029, 1019, 1020,	// 1068
	1029, 1032, 1031,	// 1069
	1029, 1030, 1032,	// 1070
	1035, 1026, 1024,	// 1071
	1035, 1036, 1026,	// 1072
	1036, 1027, 1028,	// 1073
	1036, 1035, 1027,	// 1074
	1020, 1037, 1038,	// 1075
	1020, 1017, 1037,	// 1076
	1039, 1038, 1040,	// 1077
	1039, 1020, 1038,	// 1078
	1041, 1053, 1061,	// 1079
	1041, 1042, 1053,	// 1080
	1042, 1033, 1034,	// 1081
	1042, 1041, 1033,	// 1082
	1043, 1018, 1044,	// 1083
	1043, 1017, 1018,	// 1084
	1044, 1021, 1045,	// 1085
	1044, 1018, 1021,	// 1086
	1045, 1022, 1046,	// 1087
	1045, 1021, 1022,	// 1088
	1046, 1023, 1047,	// 1089
	1046, 1022, 1023,	// 1090
	1047, 1025, 1048,	// 1091
	1047, 1023, 1025,	// 1092
	1049, 1017, 1043,	// 1093
	1049, 1037, 1017,	// 1094
	1025, 1050, 1048,	// 1095
	1025, 1026, 1050,	// 1096
	1026, 1052, 1050,	// 1097
	1026, 1036, 1052,	// 1098
	1036, 1051, 1052,	// 1099
	1036, 1028, 1051,	// 1100
	1057, 1024, 1054,	// 1101
	1057, 1035, 1024,	// 1102
	1055, 1035, 1057,	// 1103
	1055, 1027, 1035,	// 1104
	1042, 1056, 1058,	// 1105
	1042, 1034, 1056,	// 1106
	1019, 1062, 1060,	// 1107
	1019, 1029, 1062,	// 1108
	1062, 1031, 1063,	// 1109
	1062, 1029, 1031,	// 1110
	1064, 1041, 1065,	// 1111
	1064, 1033, 1041,	// 1112
	1068, 1020, 1067,	// 1113
	1068, 1030, 1020,	// 1114
	1069, 1030, 1068,	// 1115
	1069, 1032, 1030,	// 1116
	1067, 1039, 1070,	// 1117
	1067, 1020, 1039,	// 1118
	1072, 1037, 1049,	// 1119
	1072, 1038, 1037,	// 1120
	1073, 1038, 1072,	// 1121
	1073, 1040, 1038,	// 1122
	1207, 1208, 1209,	// 1123
	1207, 1206, 1208,	// 1124
	1213, 1210, 1211,	// 1125
	1213, 1212, 1210,	// 1126

/* arm */

	42, 48, 43,	// 0
	43, 48, 44,	// 1
	44, 48, 45,	// 2
	45, 48, 46,	// 3
	46, 48, 47,	// 4
	47, 48, 42,	// 5
	0, 8, 2,	// 6
	0, 9, 8,	// 7
	6, 8, 9,	// 8
	6, 4, 8,	// 9
	7, 10, 5,	// 10
	7, 11, 10,	// 11
	1, 10, 11,	// 12
	1, 3, 10,	// 13
	2, 13, 0,	// 14
	2, 12, 13,	// 15
	14, 2, 8,	// 16
	14, 12, 2,	// 17
	0, 15, 9,	// 18
	0, 13, 15,	// 19
	4, 14, 8,	// 20
	4, 16, 14,	// 21
	6, 15, 17,	// 22
	6, 9, 15,	// 23
	17, 4, 6,	// 24
	17, 16, 4,	// 25
	14, 18, 12,	// 26
	14, 19, 18,	// 27
	3, 19, 10,	// 28
	3, 18, 19,	// 29
	1, 18, 3,	// 30
	1, 20, 18,	// 31
	12, 20, 13,	// 32
	12, 18, 20,	// 33
	16, 19, 14,	// 34
	16, 21, 19,	// 35
	10, 21, 5,	// 36
	10, 19, 21,	// 37
	11, 20, 1,	// 38
	11, 22, 20,	// 39
	13, 22, 15,	// 40
	13, 20, 22,	// 41
	23, 16, 17,	// 42
	23, 21, 16,	// 43
	7, 21, 23,	// 44
	7, 5, 21,	// 45
	23, 11, 7,	// 46
	23, 22, 11,	// 47
	17, 22, 23,	// 48
	17, 15, 22,	// 49
	25, 30, 31,	// 50
	25, 24, 30,	// 51
	26, 31, 32,	// 52
	26, 25, 31,	// 53
	27, 32, 33,	// 54
	27, 26, 32,	// 55
	28, 33, 34,	// 56
	28, 27, 33,	// 57
	29, 34, 35,	// 58
	29, 28, 34,	// 59
	24, 35, 30,	// 60
	24, 29, 35,	// 61
	31, 36, 37,	// 62
	31, 30, 36,	// 63
	32, 37, 38,	// 64
	32, 31, 37,	// 65
	33, 38, 39,	// 66
	33, 32, 38,	// 67
	34, 39, 40,	// 68
	34, 33, 39,	// 69
	35, 40, 41,	// 70
	35, 34, 40,	// 71
	30, 41, 36,	// 72
	30, 35, 41,	// 73
	36, 43, 37,	// 74
	36, 42, 43,	// 75
	38, 43, 44,	// 76
	38, 37, 43,	// 77
	39, 44, 45,	// 78
	39, 38, 44,	// 79
	40, 45, 46,	// 80
	40, 39, 45,	// 81
	41, 46, 47,	// 82
	41, 40, 46,	// 83
	36, 47, 42,	// 84
	36, 41, 47,	// 85
	91, 92, 97,	// 86
	92, 93, 97,	// 87
	93, 94, 97,	// 88
	94, 95, 97,	// 89
	95, 96, 97,	// 90
	96, 91, 97,	// 91
	57, 49, 51,	// 92
	57, 58, 49,	// 93
	57, 55, 58,	// 94
	57, 53, 55,	// 95
	59, 56, 54,	// 96
	59, 60, 56,	// 97
	59, 50, 60,	// 98
	59, 52, 50,	// 99
	51, 62, 61,	// 100
	51, 49, 62,	// 101
	63, 51, 61,	// 102
	63, 57, 51,	// 103
	49, 64, 62,	// 104
	49, 58, 64,	// 105
	63, 53, 57,	// 106
	63, 65, 53,	// 107
	64, 55, 66,	// 108
	64, 58, 55,	// 109
	66, 53, 65,	// 110
	66, 55, 53,	// 111
	67, 63, 61,	// 112
	67, 68, 63,	// 113
	52, 68, 67,	// 114
	52, 59, 68,	// 115
	67, 50, 52,	// 116
	67, 69, 50,	// 117
	61, 69, 67,	// 118
	61, 62, 69,	// 119
	68, 65, 63,	// 120
	68, 70, 65,	// 121
	59, 70, 68,	// 122
	59, 54, 70,	// 123
	69, 60, 50,	// 124
	69, 71, 60,	// 125
	62, 71, 69,	// 126
	62, 64, 71,	// 127
	72, 65, 70,	// 128
	72, 66, 65,	// 129
	70, 56, 72,	// 130
	70, 54, 56,	// 131
	72, 60, 71,	// 132
	72, 56, 60,	// 133
	71, 66, 72,	// 134
	71, 64, 66,	// 135
	79, 74, 80,	// 136
	79, 73, 74,	// 137
	80, 75, 81,	// 138
	80, 74, 75,	// 139
	81, 76, 82,	// 140
	81, 75, 76,	// 141
	82, 77, 83,	// 142
	82, 76, 77,	// 143
	83, 78, 84,	// 144
	83, 77, 78,	// 145
	84, 73, 79,	// 146
	84, 78, 73,	// 147
	85, 80, 86,	// 148
	85, 79, 80,	// 149
	86, 81, 87,	// 150
	86, 80, 81,	// 151
	87, 82, 88,	// 152
	87, 81, 82,	// 153
	88, 83, 89,	// 154
	88, 82, 83,	// 155
	89, 84, 90,	// 156
	89, 83, 84,	// 157
	90, 79, 85,	// 158
	90, 84, 79,	// 159
	91, 86, 92,	// 160
	91, 85, 86,	// 161
	92, 87, 93,	// 162
	92, 86, 87,	// 163
	93, 88, 94,	// 164
	93, 87, 88,	// 165
	94, 89, 95,	// 166
	94, 88, 89,	// 167
	95, 90, 96,	// 168
	95, 89, 90,	// 169
	96, 85, 91,	// 170
	96, 90, 85,	// 171

/* negi */

	10, 6, 5,	// 0
	10, 7, 6,	// 1
	10, 9, 8,	// 2
	10, 5, 9,	// 3
	17, 0, 4,	// 4
	12, 0, 1,	// 5
	12, 11, 0,	// 6
	13, 0, 11,	// 7
	13, 2, 0,	// 8
	15, 2, 3,	// 9
	15, 14, 2,	// 10
	15, 4, 16,	// 11
	15, 3, 4,	// 12
	18, 8, 9,	// 13
	18, 20, 8,	// 14
	20, 4, 3,	// 15
	20, 18, 4,	// 16
	2, 20, 3,	// 17
	2, 19, 20,	// 18
	19, 8, 20,	// 19
	19, 7, 8,	// 20
	30, 32, 31,	// 21
	30, 33, 32,	// 22
	34, 36, 35,	// 23
	34, 37, 36,	// 24
	38, 21, 22,	// 25
	38, 22, 25,	// 26
	22, 32, 23,	// 27
	22, 31, 32,	// 28
	32, 24, 23,	// 29
	32, 33, 24,	// 30
	21, 35, 24,	// 31
	21, 34, 35,	// 32
	25, 34, 21,	// 33
	25, 37, 34,	// 34
	39, 23, 40,	// 35
	39, 22, 23,	// 36
	39, 27, 26,	// 37
	39, 40, 27,	// 38
	41, 26, 29,	// 39
	41, 39, 26,	// 40
	39, 25, 22,	// 41
	39, 41, 25,	// 42
	40, 24, 42,	// 43
	40, 23, 24,	// 44
	27, 42, 28,	// 45
	27, 40, 42,	// 46
	10, 8, 7,	// 47
	11, 12, 44,	// 48
	11, 44, 13,	// 49
	45, 14, 15,	// 50
	45, 15, 16,	// 51
	17, 1, 0,	// 52
	17, 4, 1,	// 53
	12, 43, 44,	// 54
	12, 1, 43,	// 55
	44, 2, 13,	// 56
	44, 43, 2,	// 57
	14, 0, 2,	// 58
	14, 45, 0,	// 59
	16, 0, 45,	// 60
	16, 4, 0,	// 61
	1, 47, 43,	// 62
	1, 46, 47,	// 63
	47, 5, 6,	// 64
	47, 46, 5,	// 65
	5, 18, 9,	// 66
	5, 46, 18,	// 67
	18, 1, 4,	// 68
	18, 46, 1,	// 69
	43, 19, 2,	// 70
	43, 47, 19,	// 71
	19, 6, 7,	// 72
	19, 47, 6,	// 73
	50, 26, 27,	// 74
	50, 27, 28,	// 75
	50, 28, 49,	// 76
	50, 49, 29,	// 77
	50, 29, 26,	// 78
	38, 25, 21,	// 79
	21, 31, 22,	// 80
	21, 30, 31,	// 81
	33, 21, 24,	// 82
	33, 30, 21,	// 83
	24, 36, 48,	// 84
	24, 35, 36,	// 85
	48, 37, 25,	// 86
	48, 36, 37,	// 87
	41, 49, 51,	// 88
	41, 29, 49,	// 89
	41, 48, 25,	// 90
	41, 51, 48,	// 91
	51, 24, 48,	// 92
	51, 42, 24,	// 93
	28, 51, 49,	// 94
	28, 42, 51	// 95
]
};
}
}