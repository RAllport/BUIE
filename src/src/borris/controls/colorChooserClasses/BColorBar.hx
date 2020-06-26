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

import haxe.Constraints.Function;

import borris.controls.BOrientation;
import borris.controls.colorChooserClasses.BColorController;
import openfl.display.DisplayObjectContainer;
import openfl.geom.Rectangle;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 27/01/2016 (dd/mm/yyyy)
 */
class BColorBar extends BColorController
{
    public var orientation(get, set):BOrientation;


    // set and get
    private var _orientation:BOrientation;


    public function new(parent:DisplayObjectContainer, x:Float, y:Float, width:Float, height:Float, defaultHandler:Dynamic -> Void = null)
    {
        //_orientation = orientation;
        _orientation = BOrientation.VERTICAL;

        super(parent, x, y, width, height + 1, defaultHandler);

        pointerRange = new Rectangle(width / 2, 0, 0, height);
        thumb.x = pointerRange.x;
    }


    //**************************************** HANDLERS *********************************************


    //**************************************** FUNCTIONS ********************************************


    /**
	 * 
	 * @return
	 */
    override private function drawThumb():Void
    {
        super.drawThumb();

        thumb.graphics.clear();
        thumb.graphics.beginFill(0x999999, 1);

        if(_orientation == BOrientation.HORIZONTAL)
        {
            thumb.graphics.moveTo(0, -_height / 2);
            thumb.graphics.lineTo(-5, -_height / 2 - 5);
            thumb.graphics.lineTo(-5, -_height / 2 - 15);
            thumb.graphics.lineTo(5, -_height / 2 - 15);
            thumb.graphics.lineTo(5, -_height / 2 - 5);
            thumb.graphics.lineTo(0, -_height / 2);

            thumb.graphics.moveTo(0, _height / 2);
            thumb.graphics.lineTo(-5, _height / 2 + 5);
            thumb.graphics.lineTo(-5, _height / 2 + 15);
            thumb.graphics.lineTo(5, _height / 2 + 15);
            thumb.graphics.lineTo(5, _height / 2 + 5);
            thumb.graphics.lineTo(0, _height / 2);

            thumb.y = _height / 2;
        }
        else if(_orientation == BOrientation.VERTICAL)
        {
            thumb.graphics.moveTo(-_width / 2, 0);
            thumb.graphics.lineTo(-_width / 2 - 5, 5);
            thumb.graphics.lineTo(-_width / 2 - 15, 5);
            thumb.graphics.lineTo(-_width / 2 - 15, -5);
            thumb.graphics.lineTo(-_width / 2 - 5, -5);
            thumb.graphics.lineTo(-_width / 2, 0);

            thumb.graphics.moveTo(_width / 2, 0);
            thumb.graphics.lineTo(_width / 2 + 5, 5);
            thumb.graphics.lineTo(_width / 2 + 15, 5);
            thumb.graphics.lineTo(_width / 2 + 15, -5);
            thumb.graphics.lineTo(_width / 2 + 5, -5);
            thumb.graphics.lineTo(_width / 2, 0);

            thumb.x = _width / 2;
        }

        thumb.graphics.endFill();
    } // end function


    //**************************************** SET AND GET ******************************************


    /**
	 * Gets or sets the orientaion of the color bar.
	 * This property changes the thumb rotation and the thumb range. 
	 * The width, and height is not affected by this property.
	 * Acceptable values are BOrientation.HORIZONTAL and BOrientation.VERTICAL.
	 */
    private function get_orientation():BOrientation
    {
        return _orientation;
    }

    private function set_orientation(value:BOrientation):BOrientation
    {
        _orientation = value;

        if(_orientation == BOrientation.HORIZONTAL)
        {
            pointerRange = new Rectangle(0, _height / 2, _width, 0);
        }
        else if(_orientation == BOrientation.VERTICAL)
        {
            pointerRange = new Rectangle(_width / 2, 0, 0, _height);
        }

        draw();
        return value;
    }

}

