package ssen.flexkit.components.scroll.skins {
import spark.skins.SparkSkin;

public class SimpleScrollBarThumbSkin extends SparkSkin {
	protected var thumbNormalColor:uint=0x000000;
	protected var thumbOverColor:uint=0x000000;
	protected var thumbDownColor:uint=0x000000;
	protected var thumbNormalAlpha:Number=0.1;
	protected var thumbOverAlpha:Number=0.2;
	protected var thumbDownAlpha:Number=0.5;

	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch (styleProp) {
			case "thumbColor":
				thumbNormalColor=getStyle(styleProp);
				break;
			case "thumbOverColor":
				thumbOverColor=getStyle(styleProp);
				break;
			case "thumbDownColor":
				thumbNormalColor=getStyle(styleProp);
				break;
			case "thumbAlpha":
				thumbNormalAlpha=getStyle(styleProp);
				break;
			case "thumbOverAlpha":
				thumbOverAlpha=getStyle(styleProp);
				break;
			case "thumbDownAlpha":
				thumbNormalAlpha=getStyle(styleProp);
				break;
		}
	}
}
}
