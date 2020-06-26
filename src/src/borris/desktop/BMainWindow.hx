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

package borris.desktop;


import borris.desktop.BNativeWindow;
import openfl.events.Event;
import openfl.geom.Rectangle;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 12/10/2015 (dd/mm/yyyy)
 */
class BMainWindow extends BNativeWindow
{

    public function new()
    {

        var newWindowInitOption:NativeWindowInitOptions = new NativeWindowInitOptions();
        newWindowInitOption.maximizable = true;
        newWindowInitOption.minimizable = true;
        newWindowInitOption.renderMode = NativeWindowRenderMode.AUTO;
        newWindowInitOption.resizable = true;
        newWindowInitOption.systemChrome = NativeWindowSystemChrome.NONE;
        newWindowInitOption.transparent = true; // SystemChrome must be set to 'none'/'NativeWindowSystemChrome.NONE' to allow this feature
        newWindowInitOption.type = NativeWindowType.NORMAL;

        super(newWindowInitOption);
        thisWindow.close();

        thisWindow = NativeApplication.nativeApplication.openedWindows[0];

        initialize(thisWindow.bounds);
    }


    //**************************************** HANDLERS *********************************************


    //************************************* FUNCTIONS ******************************************

    /**
	 * 
	 * @param	bounds
	 */
    override private function initialize(bounds:Rectangle = null):Void
    {

        super.initialize(bounds);
        _titleBar.title = thisWindow.title;

        // if the system chrome is not none, then
        if(thisWindow.systemChrome != NativeWindowSystemChrome.NONE)
        {
            padding = 0; // set paddig to 0;

            // make every child not visible except background and content
            for(i in 0...container.numChildren)
            {
                container.getChildAt(i).visible = false;
            }
            _drawElement.visible = true;
            _content.visible = true;
        }
    } // end function


    /**
	 * 
	 * @param	event
	 */
    override private function draw(event:Event = null):Void
    {
        super.draw();
        if(thisWindow.systemChrome != NativeWindowSystemChrome.NONE)
        {
            //container.x = 0;
            //container.y = 0;
            _content.x = padding;
            _content.y = padding + _titleBar.height;
        }
    }
    // end function


    // ************************************************* SET AND GET **************************************************

    #if flash
    private function set_width(value:Float):Float
    {
        thisWindow.width = value;
        resizeAlign();
        return value;
    }
    
    private function get_width():Float
    {
        return thisWindow.bounds.width;
    }
    
    private function set_height(value:Float):Float
    {
        thisWindow.height = value;
        resizeAlign();
        return value;
    }
    
    private function get_height():Float
    {
        return thisWindow.bounds.height;
    }
	#end

} // end class

