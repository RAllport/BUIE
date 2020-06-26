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

package borris.controls;

import openfl.display.DisplayObjectContainer;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 08/10/2014 (dd/mm/yyyy)
 */
class BButton extends BLabelButton
{
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BButton component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will
     * have no initail parent.
     * @param	x The x position to place this component.
     * @param	y The y position to place this component.
     * @param	label The text label for the component.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, label:String = "")
    {
        super(parent, x, y, label);
    }

} // end class


