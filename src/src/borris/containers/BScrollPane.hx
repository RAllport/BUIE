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

package borris.containers;

import openfl.display.DisplayObjectContainer;

/**
 * The BScrollPane component displays display objects and JPEG, GIF, and PNG files, in a scrollable area.
 *
 * @author Rohaan Allport
 * @creation-date  (dd/mm/yyyy)
 */
class BScrollPane extends BBaseScrollPane
{
    /**
     * [read-only] Gets a reference to the content loaded into the scroll pane.
     */
    public var content(get, never):DisplayObjectContainer;

    // assets


    // other


    // set and get
    // TODO implement scrollDrag
    //public var scrollDrag:Boolean;			// Gets or sets a value that indicates whether scrolling occurs when a user drags on content within the scroll pane.


    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        super(parent, x, y);
    }


    //************************************* FUNCTIONS ******************************************

    /**
	 * The request parameter of this method accepts only a URLRequest object whose source property contains a string, a class, or a URLRequest object.
	 */
    /*public function load(request:URLRequest, context:LoaderContext = null):void
	{
		
	} // end function
    */


    /**
	 * Reloads the contents of the scroll pane.
	 */
    /*public function refreshPane():void
	{
		
	} // end function
	*/


    /**
	 * Refreshes the scroll bar properties based on the width and height of the content.
	 */
    /*public function update():void
	{
		
	} // end function
	*/

    //***************************************** SET AND GET *****************************************

    private function get_content():DisplayObjectContainer
    {
        update();
        // NOTE this is actually kind of a dirty cheat code.
        draw();
        return _container;
    }

}

