package;

import borris.BUIEDemo;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.StageQuality;
import openfl.display.StageScaleMode;
import openfl.display.StageAlign;
import openfl.events.Event;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 19/09/2018 (dd/mm/yyyy)
 */
class Main extends Sprite
{
	
	
	public function new ()
	{
		
		super ();

		//BCSSParser.parseCSS();
		//var _stats:BStats = new BStats();
		//TODO add this back addChild(_stats);

		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.quality = StageQuality.HIGH;
		//stage.frameRate = 120;



		//initialiazeDemo();
		//testXML();

		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}


	private function onAddedToStage(event):Void
	{
		//trace("Width: " + );
		// A function for basic visual testing.
		// draws a red circle in the centre of the app.
		function test():Void
		{
			graphics.beginFill(0xCCCCCC, 1);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();

			graphics.beginFill(0xFF0000, 1);
			graphics.drawCircle(width/2, height/2, 50);
			graphics.endFill();
		} // end function

		test();
	} // end function


	/**
	*
	*/
	private function initialiazeDemo():Void
	{
		var demo:BUIEDemo = new BUIEDemo();
		addChild(demo);
	}


	/**
	*
	*/
	private function testXML():Void
	{
		/*var buieXML = Xml.parse(Assets.getText("assets/buieXML/test.xml"));
		var bElement = BBuieXmlParser.parseBUIEXML(buieXML);
		addChild(bElement);
		bElement.style.backgroundColor = 0x003366;
		bElement.style.borderWidth = 2;
		bElement.style.borderColor = 0xff0000;
		bElement.width = 500;
		bElement.height = 500;*/
	} // end function
	
	
}