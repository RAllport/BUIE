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

import lime.app.Application;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 27/11/2017 (dd/mm/yyyy)
 */
class BMouse
{

    public static var cursor(get, set):String;

    private static var _cursor:String;
    private static var _cursorIcon:DisplayObject;
    private static var _cursors:Array<Dynamic> = [];


    //***************************


    private function mouseMovehandler(event:MouseEvent):Void
    {

    }


    //***************************

    /**
	 * 
	 * @param name
	 * @param cursor
	 */
    public static function registerCursor(name:String, cursor:DisplayObject):Void
    {
        _cursors.push({name: name, cursor: cursor});
    } // end function registerMouseCursor


    /**
	 * 
	 * @param name
	 */
    public static function unregisterCursor(name:String):Void
    {

    } // end function unregisterMouseCursor


    //***************************

    public function get_cursor():String
    {
        return _cursor;
    }

    public function set_cursor(value:String):String
    {
        if(_cursorIcon.parent != null)
        {
            _cursorIcon.parent.removeChild(_cursorIcon);
        }

        for(i in 0..._cursors.length)
        {
            if(_cursors[i].name == value)
            {
                _cursor = value;
                _cursorIcon = _cursors[i].cursor;
                _cursorIcon.addEventListener(MouseEvent.MOUSE_MOVE, mouseMovehandler);
                //var stage:Stage = new Stage(Application.current.window, 0xff0000);
                Application.current.window.stage.addChild(_cursorIcon);
            }
        }
        return _cursor;
    }

}