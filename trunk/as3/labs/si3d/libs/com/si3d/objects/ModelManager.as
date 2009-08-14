package com.si3d.objects
{
	import __AS3__.vec.Vector;
	
	import com.si3d.geom.Mesh;
	import com.si3d.materials.Material;
	import com.si3d.render.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	import mx.utils.Base64Decoder;

	public class ModelManager
	{
		public var mdlFlyer:Model;
		public var mdlFire:Model;
		public var texFire:Vector.<BitmapData>=new Vector.<BitmapData>(8, true);
		private var _dec:Base64Decoder=new Base64Decoder();
		private const SCALE:Number=0.1;

		function ModelManager()
		{
			var i:int, vdata:String="", idata:String="", shp:Shape=new Shape(), mtx:Matrix=new Matrix();
			// Flyer model
			vdata+="iN94Art14Ar5234tF43zutz4Au503zwR4HwxNz4Awt030zN34Ar524ItF44Mu504MwR4IQwt04LiN94Aft73Yft93AtF43znt53Q";
			vdata+="mt93AwR4HwvR6nmtN6nQvSB3mmuD4AmuF3gmuB3AiOD4AfuF3gfuB3AzN34A0SEIA0uAHm1N73w1N54A4eDYA4uAHz4t+324t94A";
			vdata+="7OB4AhN734at73Aat53Iat53Yat534at74AVt73AVt53IVt53YVt73gWR73rVt/3AVuB3IVuB3YVt/3gWR/3rat/3AauB3IauB3Y";
			vdata+="at/3gat/4AfuD3oiN94AUt6nQUt7XZUt7XGUt93cUt93DUuAHGUuAHZUuA3QWt93QWt93QiN94Aft74oft95AtF44Mnt54wmt95A";
			vdata+="wR4IQvR6oZtN6owvSB4ZmuD4AmuF4gmuB5AiOD4AfuF4gfuB5AzN34A0SEIA0uAIZ1N74Q1N54A4eDYA4uAIM4t+4J4t94A7OB4A";
			vdata+="hN74Iat75Aat544at54oat54Iat74AVt75AVt544Vt54oVt74gWR74UVt/5AVuB44VuB4oVt/4gWR/4Uat/5AauB44auB4oat/4g";
			vdata+="fuD4YiN94AUt6owUt7YmUt7Y5Ut94jUt948UuAI5UuAImUuA4wWt94wWt94wbN/3AbN/2QZt/0gdV93AdV92AgB93AgB92AcN/0I";
			vdata+="mt93AgB/3AgB/2AdV/3AdV/2Amt93AbN/5AbN/5wZt/7gdV95AdV96AgB95AgB96AcN/74mt95AgB/5AgB/6AdV/5AdV/6Amt95A";
			vdata+="UN/1wat93AWV92YX193ASt/2AUt92gVN93ATt/24VN93AWB/3AX193Aat93AUN/6Qat95AWV95oX195ASt/6AUt95gVN95ATt/5I";
			vdata+="VN95AWB/5AX195Aat95AWtj3IUtj3IVt53IVt53Qat53Iat53QWtj44Utj44Vt544Vt54wat544at54w"
			idata+="AAQIAAAgMABCQgHBCQYIBCAYFAAAoBAAAsKBBw4JBDg0JBDA0OAFRYTAEhUTADxITAEA8TAGBcWAFxsUAGRoYAJiglAJygmAJSgk";
			idata+="AHyMiAFh8iAFhUfAFiIhAGBYhAHjo5AKywQALDEyALSwyAPh0cAPxApAOh4dAOzodAGBobAFxgbAIBkYAISAYAQEExAMEAxAQUMy";
			idata+="AMUEyAQ0Y3AMkM3ARkc2AN0Y2AR0U1ANkc1ARUQ0ANUU0AREIvANEQvAQkAwAL0IwCSEZDCQUhDCRUdICSERFCSEJECSEBCCQUBI";
			idata+="ATlFQATlBNATk1KATkpLAUVJTAT1ZSAU1VUAYGNhAYWNiAX2NgAXV5aAXVpRAWlBRAXF1RAXFFTAdHVZAS2dmAbWxnAbWdoAV1h4";
			idata+="AZEt5AWFl1AWHV2AVlVTAVlNSAU1RbAU1tcAbHt6AbHprAbX17AbXtsAcoB9Acn1tAcYGAAcYByAcH+BAcIFxAb35/Ab39wAanx+";
			idata+="Aan5vAa3p8Aa3xqCfYCCCfYJ7CgoF/Cf36CCfnyCCfHqCCgnp7AbmkzAPXM4AFhMXAFBMXAT05SAUU5SAiIaFAhYaQAi4qRAiomR";
			idata+="Ai5GOAjI2OAk5SWAnpSTAn5iZAn5eYAnJ+ZAnJuaAp6WkAo6qhAqKmmAo6GiAqKepApKmnAqaSgAoKKrAq6mgAsLGzArbavAsrW0";
			idata+="Arq2vAtbO0As7WwArLC1At66sArLW3Auru5AuL28Av8HAAwsO+BBAUCBAQQCBBQYDBAgUDBCAUEBBwgEBCgwEBAQoEBCw0MBCgsM";
			idata+="BBAwOBBwQOAFBEQAExQQAFxQTAFhcTAHB0aAGRwaAHR4bAGh0bAFBseAERQeAIiYlAISIlAJyYiAIyciAJCAhAJSQhAKxARAKisR";
			idata+="ALSkQALC0QALg8pALS4pALzArAKi8rAMDEsAKzAsAMy4tAMjMtANzgzAMjczAOTo1ANDk1AOjs2ANTo2AOzw3ANjs3APD04ANzw4";
			idata+="AHT48AOx08APhw9APD49AOSoRAHjkRANC8qAOTQqCR0ZICSUdIAS0xPATktPATk9SAUU5SAVFVYAV1RYAVVZZAWFVZATFlWAT0xW";
			idata+="AYGFdAXGBdAXWFiAXl1iAXFtfAYFxfATEtmAZUxmAS2RoAZ0toAZEppAaGRpAZWZrAamVrAZmdsAa2ZsAaGluAbWhuAbW5zAcm1z";
			idata+="Ab3B1AdG91AcHF2AdXB2AcXJ3AdnF3AcnM9Ad3I9Adnd4AWHZ4APVd4Adz14AWUxlAdFllAdGVqAb3RqCg4KACgYOAAOHNuAMzhu";
			idata+="Ah4iFAhIeFAiYqIAh4mIAi4aIAiouIAj5COAjY+OAkIaLAjpCLAhIWQAj4SQAkpOWAlZKWAlZaYAl5WYAlpSZAmJaZAm5yeAnZue";
			idata+="AnJmUAnpyUAnZ6TAkp2TApaKgApKWgApaajAoqWjAp6imApaemArK6xAsKyxArq+yAsa6yAsbK0As7G0Aubu9AuLm9Aurm4AvLq4";
			idata+="AvsPBAv77BAwr6/AwMK/"
			mdlFlyer=_unpackModel(vdata, idata, [new Material().setColor2(0xc0c0c0), new Material().setColor2(0x203040), new Material().setColor2(0xffc040)]);
			// Fire billboard
			mtx.createGradientBox(32, 32, 0, 0);
			for (i=0; i < 8; ++i)
			{
				texFire[i]=new BitmapData(32, 32, true, 0);
				shp.graphics.clear();
				shp.graphics.beginGradientFill(GradientType.RADIAL, [0x80c0f0, 0x80c0f0], [0, 0.5 - i * 0.05], [0, 255], mtx);
				shp.graphics.drawCircle(16, 16, 16);
				shp.graphics.endFill();
				texFire[i].draw(shp);
			}
			mdlFire=new Model(Vector.<Number>([-1, -1, 0, -1, 1, 0, 1, -1, 0, 1, 1, 0]), Vector.<Number>([0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0]));
			mdlFire.face(0, 1, 2).face(3, 2, 1);
		}

		private function _unpackModel(vdata:String, idata:String, materials:Array):Model
		{
			var i:int, ui:uint, model:Model=new Model(null, null, Vector.<Material>(materials));
			for (i=0; i < vdata.length; i+=5)
			{
				_dec.decode(vdata.substr(i, 5) + "A==");
				ui=(_dec.toByteArray().readUnsignedInt()) >> 2;
				model.vertices.push(((ui & 1023) - 512) * SCALE, (((ui >> 10) & 1023) - 512) * SCALE, (((ui >> 20) & 1023) - 512) * SCALE);
			}
			for (i=0; i < idata.length; i+=5)
			{
				_dec.decode(idata.substr(i, 5) + "A==");
				ui=(_dec.toByteArray().readUnsignedInt()) >> 2;
				model.face(ui & 255, (ui >> 8) & 255, (ui >> 16) & 255, (ui >> 24) & 63);
			}
			return model;
		}
	}
}