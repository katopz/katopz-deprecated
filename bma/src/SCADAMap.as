package
{
	import flash.display.*

	public class SCADAMap extends Map
	{

		public function SCADAMap()
		{

			contentParentName = "SCADA"
			housesMovieClip = iHouses as MovieClip;

			init();

			//test();
			
			trace("map");
		}
	}
}