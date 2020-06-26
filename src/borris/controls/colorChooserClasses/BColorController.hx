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

package borris.controls.colorChooserClasses;

import Std;
import borris.controls.BUIComponent;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 22/01/2016 (dd/mm/yyyy)
 */
class BColorController extends BUIComponent
{
    /**
     * Gets the string value of the current color selection.
     */
    public var hexValue(get, never):String;

    /**
     * Gets or sets value of the swatch color.
     */
    public var value(get, set):Int;

    /**
     *
     */
    public var valueX(get, set):Float;

    /**
     *
     */
    public var valueY(get, set):Float;

    // assets
    private var background:Sprite = new Sprite();
    private var thumb:Shape;
    public var backBitmap:Bitmap;


    // other
    public var bitmapData:BitmapData;
    private var pointerRange:Rectangle;


    public function new(parent:DisplayObjectContainer, x:Float, y:Float, width:Float, height:Float, defaultHandler:Dynamic->Void = null)
    {
        super();
        // contructor
        super(parent, x, y);
        //setSize(width, height);


        backBitmap = new Bitmap(bitmapData = new BitmapData(Std.int(width), Std.int(height), false, 0x808080));
        thumb = new Shape();

        pointerRange = bitmapData.rect;


        // add assets to respective containers
        addChild(background);
        addChild(thumb);
        background.addChild(backBitmap);

        buttonMode = true;

        //draw();
        setSize(width, height);


        // event handling
        addEventListener(MouseEvent.MOUSE_DOWN, onDragStart);

        if(defaultHandler != null)
            addEventListener(Event.CHANGE, defaultHandler);
    }


    //**************************************** HANDLERS *********************************************


    /**
     *
     * @param	event
     */
    private function onDragStart(event:MouseEvent):Void
    {
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragging);
        stage.addEventListener(MouseEvent.MOUSE_UP, onDragEnd);
        onDragging(event);
    } // end function


    /**
     *
     * @param	event
     */
    private function onDragging(event:MouseEvent):Void
    {
        thumb.x = mouseX;
        thumb.y = mouseY;

        // make sure the thumb is within the thumb range bounds
        if(thumb.x < pointerRange.left)
            thumb.x = pointerRange.left
        else if(thumb.x > pointerRange.right)
            thumb.x = pointerRange.right;

        if(thumb.y < pointerRange.top)
            thumb.y = pointerRange.top
            // dispatch a new cgange event
        else if(thumb.y > pointerRange.bottom)
            thumb.y = pointerRange.bottom;


        dispatchEvent(new Event(Event.CHANGE));
    } // end function


    /**
     *
     * @param	event
     */
    private function onDragEnd(event:MouseEvent):Void
    {
        onDragging(event);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragging);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onDragEnd);
    } // end function


    //**************************************** FUNCTIONS ********************************************


    /**
     * @inheritDoc
     */
    override private function draw():Void
    {
        //pointerRange = bitmapData.rect;

        // draw a thin grey border
        background.graphics.clear();
        background.graphics.beginFill(0x666666, 1);
        background.graphics.drawRect(-2, -2, _width + 4, _height + 4);
        background.graphics.endFill();

        drawThumb();
    } // end function


    /**
     *
     * @return
     */
    private function drawThumb():Void
    {
        thumb.graphics.clear();
        thumb.graphics.beginFill(0xFFFFFF, 1);
        thumb.graphics.drawCircle(0, 0, 6);
        thumb.graphics.drawCircle(0, 0, 5);
        thumb.graphics.beginFill(0x000000, 1);
        thumb.graphics.drawCircle(0, 0, 5);
        thumb.graphics.drawCircle(0, 0, 4);
        thumb.graphics.endFill();
    } // end function


    /**
     * Sets the value of the thumb in terms of percentage.
     * percentX and percentY cannot be greater than 1 or less than 0.
     * The values are automatically changed if a value greater than 1 or less than 0
     * are passed.
     *
     * @param	percentX
     * @param	percentY
     */
    public function valueXY(percentX:Float, percentY:Float):Void
    {
        percentX = Math.min(percentX, 1);
        percentY = Math.min(percentY, 1);

        percentX = Math.max(percentX, 0);
        percentY = Math.max(percentY, 0);

        thumb.x = pointerRange.width * percentX;
        thumb.y = pointerRange.height * (1 - percentY);
    } // end function


    //**************************************** SET AND GET ******************************************


    private function get_hexValue():String
    {
        return Std.string(bitmapData.getPixel32(Std.int(thumb.x), Std.int(thumb.y)));
    }


    private function get_value():Int
    {
        return bitmapData.getPixel(Std.int(thumb.x), Std.int(thumb.y));
    }

    private function set_value(val:Int):Int
    {
        // set string to the string value of val in base 16
        /*var colorString:String = val.toString(16).toUpperCase();
			
			// while the the string is less than 6 characters, add zeros (0) infront of it.
			while(colorString.length < 6)
			{
				colorString = "0" + colorString;
			}
			
			// set text of the input text to the color string
			inputText.text = colorString;
			
			// convert string to a number in base 16
			_value = parseInt("0x" + inputText.text, 16);
			
			// redraw the color chooser (although only the swatch needs to redraw)
			draw();*/

        return val;
    }


    private function get_valueX():Float
    {
        return thumb.x / pointerRange.width;
    }

    private function set_valueX(value:Float):Float
    {
        value = Math.min(value, 1);
        value = Math.max(value, 0);
        thumb.x = pointerRange.width * value;
        return value;
    }


    private function get_valueY():Float
    {
        return 1 - thumb.y / pointerRange.height;
    }

    private function set_valueY(value:Float):Float
    {
        value = Math.min(value, 1);
        value = Math.max(value, 0);
        thumb.y = pointerRange.height * (1 - value);
        return value;
    }
}




