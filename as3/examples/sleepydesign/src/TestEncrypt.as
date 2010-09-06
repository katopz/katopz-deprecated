package
{
	import com.sleepydesign.net.FileUtil;

	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public class TestEncrypt extends Sprite
	{
		public function TestEncrypt()
		{
			var test:ByteArray = new ByteArray();
			test.writeUTF("1234567890");
			test.compress();

			FileUtil.save(test, "foo.zip");
		}
	}
}