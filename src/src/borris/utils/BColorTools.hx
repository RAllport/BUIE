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

package borris.utils;

import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.geom.ColorTransform;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 27/11/201 (dd/mm/yyyy)
 */
class BColorTools
{

	/**
	 * 
	 * @param	color
	 * @param	displayObject
	 */
	public static function tint(color:UInt, displayObject:DisplayObject):Void
	{
        // TODO use ColorTransform.color?
		//transform.colorTransform = new ColorTransform(0, 0, 0, 1, 0x00, 0x99, 0xCC, 0);
        displayObject.transform.colorTransform = new ColorTransform(0, 0, 0, 1, (color >> 16 & 0xFF), (color >> 8 & 0xFF), (color & 0xFF), 0);
	} // end function
	
	
	/**
	 * (Depreciated)
	 *
	 * @param	bitmap
	 * @param	colorTransform
	 * @param	all
	 */
	public static function html5BtmColorTransform(bitmap:Bitmap, colorTransform:ColorTransform, all:Bool = false):Void
	{
		if(!all)
		{
			bitmap.bitmapData = bitmap.bitmapData.clone();
		}
		bitmap.bitmapData.colorTransform(bitmap.getRect(bitmap), colorTransform);
	} // end function 
	
	
	/**
	 * 
	 * @param	color
	 * @param	bitmap
	 */
	public static function html5BitmapTint(color:UInt, bitmap:Bitmap):Void
	{
		var colorTransform = new ColorTransform();
		colorTransform.color = color;
		BColorTools.html5BtmColorTransform(bitmap, colorTransform, false);
	} // end function

} // end class