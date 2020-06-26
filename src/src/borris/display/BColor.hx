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

package borris.display;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 05/01/2015 (dd/mm/yyyy)
 */
@:enum
abstract BColor(UInt)
{
    /**
	 * 
	 */
    function RGBA(red:Int, green:Int, blue:Int, alpha:Float):Void
    {
        red = red > (255) ? 255 : red;
        green = green > (255) ? 255 : green;
        blue = blue > (255) ? 255 : blue;
        alpha = Math.max(0, alpha);
        alpha = Math.min(1, alpha);
    } // end function


    /**
	 * 
	 */
    function BGradient():BGradient
    {


    }
    // end function

}

