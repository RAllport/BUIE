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

package borris.events;


import openfl.events.Event;
import openfl.geom.Rectangle;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 10/10/2014 (dd/mm/yyyy)
 */
class BPanelEvent extends Event
{
    public static inline var ACTIVATE:String = "activate";
    public static inline var CLOSE:String = "close";
    public static inline var CLOSING:String = "closing";
    public static inline var DEACTIVATE:String = "deactivate";
    public static inline var DISPLAY_STATE_CHANGE:String = "displayStateChange";
    public static inline var DISPLAY_STAGE_CHANGING:String = "displayStateChanging";
    public static inline var MOVE:String = "move";
    public static inline var MOVING:String = "moving";
    public static inline var RESIZE:String = "resize";
    public static inline var RESIZING:String = "resizing";

    //public static const DRAG:String = "drag";
    //public static const DRAGGING:String = "dragging";
    //public static const DROP:String = "drop";
    //public static const DROPPING:String = "dropping";


    private var _afterBounds:Rectangle;
    private var _beforeBounds:Rectangle;


    public function new()
    {
        super();

    }

} // end class


