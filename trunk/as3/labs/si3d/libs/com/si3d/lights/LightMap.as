package com.si3d.lights
{
	import __AS3__.vec.Vector;

	import flash.display.*;
	import flash.geom.*;

	public class LightMap extends BitmapData 
	{
	    function LightMap(dif:int, spc:int) 
	    { 
	    	super(dif, spc, false); 
	    }
	    
	    public function diffusion(amb:int, dif:int) : BitmapData {
	        var col:int, rc:Rectangle = new Rectangle(0, 0, 1, height), ipk:Number = 1 / width;
	        for (rc.x=0; rc.x<width; rc.x+=1) {
	            col = ((rc.x * (dif - amb)) * ipk) + amb;
	            fillRect(rc, (col<<16)|(col<<8)|col);
	        }
	        return this;
	    }
	    
	    public function specular(spc:int, pow:Number) : BitmapData {
	        var col:int, rc:Rectangle = new Rectangle(0, 0, width, 1),
	            mpk:Number = (pow + 2) * 0.15915494309189534, ipk:Number = 1 / height;
	        for (rc.y=0; rc.y<height; rc.y+=1) {
	            col = Math.pow(rc.y * ipk, pow) * spc * mpk;
	            if (col > 255) col = 255;
	            fillRect(rc, (col<<16)|(col<<8)|col);
	        }
	        return this;
	    }
	}
}
