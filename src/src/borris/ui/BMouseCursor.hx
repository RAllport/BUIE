/*
 * MIT License
 *
 * Copyright (c) 2016 Rohaan Allport
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package borris.ui;

import openfl.Assets;
import openfl.display.BitmapData;
import openfl.ui.Mouse;
import openfl.geom.Point;
import openfl.Vector;

#if flash
import flash.Vector;
import flash.ui.Mouse;
import flash.ui.MouseCursorData;
#end

// TODO complete lime and openfl part
/**
 * The BMouseCursor class is an enumeration of constant values used in setting the cursor property of the Mouse class.
 *
 * @author Rohaan Allport
 * @creation-date 07/06/2014 (dd/mm/yyyy)
 */
class BMouseCursor
{
	
    // window moving
    public static inline var MOVE:String = "move";
    
    // window resizing
    public static inline var RESIZE_TOP_LEFT:String = "resize top left";
    public static inline var RESIZE_TOP_RIGHT:String = "resize top right";
    public static inline var RESIZE_BOTTOM_LEFT:String = "resize bottom left";
    public static inline var RESIZE_BOTTOM_RIGHT:String = "resize bottom right";
    public static inline var RESIZE_TOP:String = "resize top";
    public static inline var RESIZE_BOTTOM:String = "resize bottom";
    public static inline var RESIZE_LEFT:String = "resize left";
    public static inline var RESIZE_RIGHT:String = "resize right";
    
    // panel resizing
    // public static const RESIZE_HEIGHT_TOP:String = "resize height top";
    public static inline var RESIZE_WIDTH:String = "resize width";
    public static inline var RESIZE_HEIGHT:String = "resize height";
    
    //misc
    public static inline var TARGET:String = "target";
	
    
	// custom cursor
    //private static var tempVec:Array<BitmapData> = new Array<BitmapData>();
	

	#if flash
	public static var initialized(get, never):Bool;
	private static var _initialized:Bool = false;
	
	
	private static var cursorData:MouseCursorData = new MouseCursorData();
    private static var tempVec:Vector<BitmapData> = new Vector<BitmapData>();
	
	// TODO find a way to run this code automatically
	/**
	 * Only available on flash targets.
	 * You will need to run this function before custom cursors can take effect.
	 */
	public static function initialize()
	{
		if (_initialized) return;
		_initialized = true;
		
		// move cursor
        tempVec[0] = Assets.getBitmapData("graphics/cursor move.png");
        cursorData.data = tempVec;
        cursorData.hotSpot = new Point(11, 11);
        Mouse.registerCursor("move", cursorData);
		
		// resize top left cursor
        tempVec[0] = Assets.getBitmapData("graphics/cursor resize corner0001.png");
        cursorData.data = tempVec;
        cursorData.hotSpot = new Point(8, 8);
        Mouse.registerCursor("resize top left", cursorData);
		
		// resize bottom right cursor
		//tempVec[0] = Assets.getBitmapData("graphics/");
		//cursorData.data = tempVec;
        cursorData.hotSpot = new Point(7, 7);
        Mouse.registerCursor("resize bottom right", cursorData);
		
		// resize top right cursor
        tempVec = new Vector<BitmapData>();
        tempVec.push(Assets.getBitmapData("graphics/cursor resize corner0002.png"));
        cursorData.data = tempVec;
        cursorData.hotSpot = new Point(8, 7);
        Mouse.registerCursor("resize top right", cursorData);
		
		// resize bottom left cursor
		//tempVec[0] = Assets.getBitmapData("graphics/"));
		//cursorData.data = tempVec;
        cursorData.hotSpot = new Point(7, 8);
        Mouse.registerCursor("resize bottom left", cursorData);
		
		// resize top edge cursor
        tempVec[0] = Assets.getBitmapData("graphics/cursor resize edge V.png");
        cursorData.data = tempVec;
        cursorData.hotSpot = new Point(11, 11);
        Mouse.registerCursor("resize top", cursorData);
		
		// resize bottom edge cursor
		//tempVec[0] = Assets.getBitmapData("graphics/");
		//cursorData.data = tempVec;
        cursorData.hotSpot = new Point(11, 10);
        Mouse.registerCursor("resize bottom", cursorData);
		
		// resize left edge cursor
        tempVec[0] = Assets.getBitmapData("graphics/cursor resize edge H.png");
        cursorData.data = tempVec;
        cursorData.hotSpot = new Point(11, 11);
        Mouse.registerCursor("resize left", cursorData);
		
		// resize right edge cursor
		//tempVec[0] = Assets.getBitmapData("graphics/");
		//cursorData.data = tempVec;
        cursorData.hotSpot = new Point(10, 11);
        Mouse.registerCursor("resize right", cursorData);
		
		// resize panel width cursor
        tempVec[0] = Assets.getBitmapData("graphics/cursor panel resize width.png");
        cursorData.data = tempVec;
        cursorData.hotSpot = new Point(11, 9);
        Mouse.registerCursor("resize width", cursorData);
		
		// resize panel height cursor
        tempVec[0] = Assets.getBitmapData("graphics/cursor panel resize height.png");
        cursorData.data = tempVec;
        cursorData.hotSpot = new Point(11, 9);
        Mouse.registerCursor("resize height", cursorData);
		
		
		// target
        tempVec[0] = Assets.getBitmapData("graphics/cursor target.png");
        cursorData.data = tempVec;
        cursorData.hotSpot = new Point(11, 9);
        Mouse.registerCursor("target", cursorData);
		
    }
	
	
	private static function get_initialized():Bool
	{
		return _initialized;
	}
	
	#end

} // end class


