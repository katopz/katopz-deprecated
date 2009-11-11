/**************************************************************************
* LOGOSWARE Class Library.
*
* Copyright 2009 (c) LOGOSWARE (http://www.logosware.com) All rights reserved.
*
*
* This program is free software; you can redistribute it and/or modify it under
* the terms of the GNU General Public License as published by the Free Software
* Foundation; either version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* this program; if not, write to the Free Software Foundation, Inc., 59 Temple
* Place, Suite 330, Boston, MA 02111-1307 USA
*
**************************************************************************/ 
package com.logosware.utils.QRcode 
{
	import com.logosware.utils.LabelingClass;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @author UENO Kenichi
	 */
	public class QRCodeDetecter extends Sprite
	{
		private var image:DisplayObject;
		private var bd:BitmapData;
		private var bd2:BitmapData;
		private var threshold:uint = 0xFF888888;
		private var grayConst:Array = [
			0.3, 0.59, 0.11, 0, 0,
			0.3, 0.59, 0.11, 0, 0,
			0.3, 0.59, 0.11, 0, 0,
			0, 0, 0, 0, 255
		];
		/**
		 * 画像からQRコードを見つけ出します
		 * @param	imageSource
		 */
		public function QRCodeDetecter(imageSource:DisplayObject) 
		{
			image = imageSource;
			bd = new BitmapData(image.width, image.height, true, 0x0);
			bd2 = new BitmapData(image.width, image.height, true, 0x0);
// debug code
/*
			var bmp:Bitmap = new Bitmap( bd );
			image.parent.addChild( bmp );
			bmp.x = image.width;
*/
		}
		/**
		 * 見つかったQRコードの位置情報を返します
		 * @return マーカー配列
		 * 	[
		 * 		{
		 * 			image:BitmapData,
		 * 			borderColors:[
		 * 				0: uint color of topleft marker
		 * 				1: uint color of topright marker
		 * 				2: uint color of bottomleft marker
		 * 			],
		 * 			originalLocation:[
		 * 				0: Rectangle of topleft marker
		 * 				1: Rectangle of topright marker
		 * 				2: Rectangle of bottomleft marker
		 * 			]
		 * 		}
		 * 		...
		 * 	]
		 */
		private var _temp_point:Point = new Point();
		public function detect():Array {
			var ret:Array = [];
			bd.lock();
			bd.draw(image);
			
			// グレー化
			var _bd_rect:Rectangle = bd.rect;
			bd.applyFilter(bd, _bd_rect, _temp_point, new ColorMatrixFilter(grayConst));
			bd.applyFilter(bd, _bd_rect, _temp_point, new ConvolutionFilter(5, 5, [
				0, -1, -1, -1, 0,
				-1, -1, -2, -1, -1,
				-1, -2, 25, -2, -1,
				-1, -1, -2, -1, -1,
				0, -1, -1, -1, 0
			]));
			bd.applyFilter(bd, _bd_rect, _temp_point, new BlurFilter(3, 3));
			
			// 二値化
			bd.threshold(bd, _bd_rect, _temp_point, ">", threshold, 0xFFFFFFFF, 0x0000FF00);
			bd.threshold(bd, _bd_rect, _temp_point, "!=", 0xFFFFFFFF, 0xFF000000);
			
			// ラベリング
			var LabelingObj:LabelingClass = new LabelingClass(); 
			LabelingObj.Labeling( bd, 10, 0xFF88FFFE, true ); // ラベリング実行
			
			var pickedRects:Array = LabelingObj.getRects();
			var pickedColor:Array = LabelingObj.getColors();
			
			LabelingObj = null;
			
			// マーカー候補の矩形を取得
			var borders:Array = _searchBorders( bd, pickedRects, pickedColor );
			
			// 直角の位置にあるコードを検索
			var codes:Array = _searchCode( borders );
			
			// 適切な角度で切り抜き
			var images:Array = _clipCodes( bd, codes );
			var _images_length:int = images.length;
			for ( var i:int = 0; i < _images_length; i++ ) {
				var _codes_i:* = codes[i];
				ret.push( { image:images[i], borderColors:[_codes_i[0].borderColor, _codes_i[1].borderColor, _codes_i[2].borderColor], originalLocation:[_codes_i[0].borderRect, _codes_i[1].borderRect, _codes_i[2].borderRect] } );
			}
			bd.unlock();
			return ret;
		}
		private function _clipCodes( bd:BitmapData, codes:Array):Array {
			var ret:Array = [];
			var _codes_length:int = codes.length;
			for ( var i:int = 0; i < _codes_length; i++ ) 
			{
				var _codes_i:* = codes[i];
				var marker1:Rectangle = _codes_i[0].borderRect; // top left
				var marker2:Rectangle = _codes_i[1].borderRect; // top right
				var marker3:Rectangle = _codes_i[2].borderRect; // bottom left
				var vector12:Point = marker2.topLeft.subtract( marker1.topLeft ); // vector: top left -> top right
				var vector13:Point = marker3.topLeft.subtract( marker1.topLeft ); // vector: top left -> bottom left
				var theta:Number = -Math.atan2( vector12.y, vector12.x ); // 平面状の回転角
				
				var matrix:Matrix = new Matrix();
				var d:Number = (0.5 * marker1.width) / (Math.abs(Math.cos( theta )) + Math.abs(Math.sin( theta ) ) ); // マーカーの一辺の長さの半分
				
				matrix.translate( -(marker1.topLeft.x + marker1.width * 0.5), -(marker1.topLeft.y + marker1.height * 0.5) );
				matrix.rotate( theta );
				matrix.translate( 20 + d, 20 + d );
				
				var matrix2:Matrix = new Matrix();
				matrix2.rotate( theta );
				var vector13r:Point = matrix2.transformPoint( vector13 );
				
				matrix2 = new Matrix(1.0, 0, -vector13r.x/vector13r.y, vector12.length / vector13r.y );
				
				matrix.concat( matrix2 );
				
				var len:Number = ( vector12.length + 2 * d ); // QRコードの一辺の長さ
				var bd2:BitmapData = new BitmapData( 40 + len, 40 + len );
				bd2.draw( bd, matrix );
				ret.push( bd2 );
			}
			return ret;
		}
		/**
		 * マーカーの候補をピックアップする
		 * @param	bmp ラベリング済みの画像
		 * @param	rectArray 矩形情報
		 * @param	colorArray 矩形の色情報
		 * @return 候補の配列
		 */
		private function _searchBorders(bmp:BitmapData, rectArray:Array, colorArray:Array):Array {
			function isMarker( ary:Array ):Boolean {
				var c:Number = 0.75;
				var ave:Number = (ary[0] + ary[1] + ary[2] + ary[3] + ary[4]) / 7;
				return(
					ary[0] > ((1.0-c)*ave) && ary[0] < ((1.0+c)*ave) &&
					ary[1] > ((1.0-c)*ave) && ary[1] < ((1.0+c)*ave) &&
					ary[2] > ((3.0-c)*ave) && ary[2] < ((3.0+c)*ave) &&
					ary[3] > ((1.0-c)*ave) && ary[3] < ((1.0+c)*ave) &&
					ary[4] > ((1.0-c) * ave) && ary[4] < ((1.0+c) * ave)
				);
			}
			var retArray:Array = [];
			var _rectArray_length:int = rectArray.length;
			var _bmp_getPixel:Function = bmp.getPixel;
			for ( var i:int = 0; i < _rectArray_length; i++ ) {
				var _rectArray_i:* = rectArray[i];
				
				var count:int = 0;
				var target:Number = 0;
				var tempRect:Rectangle = rectArray[i];// 外側
				var _rectArray_i_width:int;
				
				if( colorArray[i] != _bmp_getPixel( _rectArray_i.topLeft.x + _rectArray_i.width*0.5, _rectArray_i.topLeft.y + _rectArray_i.height*0.5) ){
					var oldFlg:uint = 0;
					var tempFlg:uint = 0;
					var index:int = -1;
					var countArray:Array = [0.0, 0.0, 0.0, 0.0, 0.0];
					var j:int;
					var constNum:Number;

					// 横方向
					constNum = _rectArray_i.topLeft.y + _rectArray_i.height*0.5;
					
					_rectArray_i_width = _rectArray_i.width;
					for ( j = 0; j < _rectArray_i_width; j++ ){
						tempFlg = (_bmp_getPixel( _rectArray_i.topLeft.x + j, constNum ) == 0xFFFFFF)?0:1;
						if( (index == -1) && (tempFlg == 0) ){
							//go next
						} else {
							if( tempFlg != oldFlg ){
								index++;
								oldFlg = tempFlg;
								if( index >= 5 ){
									break;
								}
							} 
							countArray[index]++;
						}
					}

					if ( isMarker(countArray) ) {
						// 縦方向
						countArray = [0.0, 0.0, 0.0, 0.0, 0.0];
						oldFlg = tempFlg = 0;
						index = -1;

						constNum = _rectArray_i.topLeft.x + _rectArray_i.width*0.5;
						_rectArray_i_width = _rectArray_i.width;
						for ( j = 0; j < _rectArray_i_width; j++ ) {
							tempFlg = (_bmp_getPixel( constNum, _rectArray_i.topLeft.y + j ) == 0xFFFFFF)?0:1;
							if( (index == -1) && (tempFlg == 0) ){
								//go next
							} else {
								if( tempFlg != oldFlg ){
									index++;
									oldFlg = tempFlg;
									if( index >= 5 ){
										break;
									}
								} 
								countArray[index]++;
							}
						}
						if ( isMarker(countArray) ) {
							retArray.push( {borderColor:colorArray[i], borderRect:_rectArray_i} );
						}
					}
				}
			}
			return retArray;
		}
		/**
		 * 直角関係にあるマーカーを探します
		 * @param	borders 候補の配列
		 * @return
		 */
		private function _searchCode( borders:Array ):Array {
			function isNear( p1:Point, p2:Point, d:Number ):Boolean {
				return(
					(p1.x + d) > p2.x &&
					(p1.x - d) < p2.x &&
					(p1.y + d) > p2.y &&
					(p1.y - d) < p2.y
				);
			}
			var ret:Array = [];
			var loop:int = borders.length;
			for ( var i:int = 0; i < (loop-2); i++ ) 
			{
				var borders_i:* = borders[i];
				var borders_i_borderRect_topLeft:Point = borders_i.borderRect.topLeft;
				
				for ( var j:int = i + 1; j < (loop-1); j++ ) 
				{
					var borders_j:* = borders[j];
					var borders_j_borderRect_topLeft:Point = borders_j.borderRect.topLeft;
					var vec:Point = borders_i_borderRect_topLeft.subtract( borders_j_borderRect_topLeft );
					var _0125_vec_length:Number = 0.125 * vec.length;
					
					for ( var k:int = j + 1; k < loop; k++ ) 
					{
						var borders_k:* = borders[k];
						var borders_k_borderRect_topLeft:Point = borders_k.borderRect.topLeft;
						
						if( isNear( borders_k_borderRect_topLeft, new Point( borders_i_borderRect_topLeft.x + vec.y, borders_i_borderRect_topLeft.y - vec.x ), _0125_vec_length ))
							ret.push( [borders_i, borders_j, borders_k] );
						else if ( isNear( borders_k_borderRect_topLeft, new Point( borders_i_borderRect_topLeft.x - vec.y, borders_i_borderRect_topLeft.y + vec.x ), _0125_vec_length ))
							ret.push( [borders_i, borders_k, borders_j] );
						else if ( isNear( borders_k_borderRect_topLeft, new Point( borders_j_borderRect_topLeft.x + vec.y, borders_j_borderRect_topLeft.y - vec.x ), _0125_vec_length ))
							ret.push( [borders_j, borders_k, borders_i] );
						else if ( isNear( borders_k_borderRect_topLeft, new Point( borders_j_borderRect_topLeft.x - vec.y, borders_j_borderRect_topLeft.y + vec.x ), _0125_vec_length ))
							ret.push( [borders_j, borders_i, borders_k] );
					}
				}
			}
			return ret;
		}
	}
}