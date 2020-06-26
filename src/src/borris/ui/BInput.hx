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

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 26/10/2014 (dd/mm/yyyy)
 */
class BInput
{
    /**
	 * The last key that was pressed.
	 */
    public static var lastKey(get, never):Int;

    /**
	 * How many frames have passed since the last key was pressed.
	 */
    public static var framesSinceLastKey(get, never):Int;

    /**
	 * 
	 */
    public static var lastKeyFrameDifference(get, never):Int;

    /**
	 * 
	 */
    public static var handleOwnUpdate(get, set):Bool;


    // constants
    public static inline var KEY_DOWN:String = "keyDown";
    public static inline var KEY_UP:String = "keyUp";
    public static inline var KEY_PRESSED:String = "keyPressed";
    public static inline var KEY_RELEASED:String = "keyReleased";

    public static inline var MOUSE_DOWN:String = "mouseDown";
    public static inline var MOUSE_UP:String = "mouseUp";
    public static inline var MOUSE_PRESSED:String = "mousePressed";
    public static inline var MoOUSE_RELEASED:String = "mouseReleased";
    public static inline var MOUSE_MOVING:String = "mouseMoving";


    // key variables
    private static var _keysDown:Array<Dynamic>;
    private static var _keyState:Array<Dynamic>;
    private static var _lastKey:Int;
    private static var _framesSinceLastKey:Int = 0;
    private static var _lastKeyFrameDifference:Int = 0;
    //public static var timeSinceLastKey:int;
    //private static var _keyBuffer:Array<Dynamic>;
    //private static var _bufferSize:Int;


    // TODO These should be read only
    // mouse variables
    public static var mouseIsDown:Bool = false;
    public static var mouseReleased:Bool = false;
    public static var mousePressed:Bool = false;
    //public static var mouseOver:Boolean = false;
    public static var mouseX:Float = 0;
    public static var mouseY:Float = 0;
    public static var prevMouseX:Float = 0;
    public static var prevMouseY:Float = 0;
    private static var _mousePos:Point = new Point();
    public static var mouseOffsetX:Float = 0;
    public static var mouseOffsetY:Float = 0;
    public static var mouseDragX:Float = 0;
    public static var mouseDragY:Float = 0;
    public static var mouseDetectable:Bool = false;


    // TODO These should be read only
    // touch variables
    //public static var touch:Touch;
    public static var touchX:Float = 0;
    public static var touchY:Float = 0;
    public static var prevTouchX:Float = 0;
    public static var prevTouchY:Float = 0;
    private static var _touchPos:Point = new Point();
    public static var touchOffsetX:Float = 0;
    public static var touchOffsetY:Float = 0;
    public static var touchDragX:Float = 0;
    public static var touchDragY:Float = 0;

    public static var touchPressure:Float = 0;
    public static var touchWidth:Float = 0;
    public static var touchHeight:Float = 0;

    public static var fingerIsDown:Bool = false;
    public static var fingerReleased:Bool = false;
    public static var fingerTap:Bool = false;


    // gesture variables


    // stage
    private static var stage:DisplayObjectContainer;


    // other
    private static var _initialized:Bool = false;


    /**
	 * Initialize the BInput
	 * 
	 * @param	mainStage
	 * @param	handleOwnUpdate
	 */
    public static function initialize(mainStage:DisplayObjectContainer, handleOwnUpdate:Bool = false):Void
    {
        if(_initialized)
        {
            return;
        }
        _initialized = true;

        stage = mainStage;
        BInput.handleOwnUpdate = handleOwnUpdate;
        _keysDown = new Array<Dynamic>();


        // keyboard
        _keyState = new Array<Dynamic>();
        for(i in 0...222)
        {
            _keyState[i] = KEY_UP;
        }


        // event handling  
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
        stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);

        // mouse
        stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
        /*stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.RELEASE_OUTSIDE, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MIDDLE_CLICK, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouseClickHandler, false, 0, true);*/
        stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);

        // touch
        stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
        stage.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
        stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
    } // end function initialize  


    //****************************************** MOUSE INPUT FUNCTIONS ***************************************************

    /**
	 * Fills an array with any keys that are currently held down
	 * 
	 * @param	event
	 */
    private static function keyDown(event:KeyboardEvent):Void
    {
        for(key in _keysDown)
        {
            if(key == event.keyCode)
            {
                return;
            }
        } // end for

        _keysDown.push(event.keyCode);

        _keyState[event.keyCode] = KEY_PRESSED;
        _lastKey = event.keyCode;
        _lastKeyFrameDifference = _framesSinceLastKey;
        _framesSinceLastKey = 0;

    } // end function pressAKey  


    /**
	 * Removes keys from an array if they were released
	 * 
	 * @param	event
	 */
    private static function keyUp(event:KeyboardEvent):Void
    {
        _keysDown.remove(event.keyCode);

        _keyState[event.keyCode] = KEY_RELEASED;

    } // end function releaseAKey  


    /**
	 * Runs when "handleOwnUpdate" is true
	 * 
	 * @param	event
	 */
    private static function enterFrameHandler(event:Event):Void
    {
        //trace("BInput | W: "  + keyState[Keyboard.W]);
        update();
    } // end function enterFrameHandler  


    /**
	 * 
	 * @param	keyCode
	 * @return
	 */
    public static function keyIsDown(keyCode:Int):Bool
    {
        if(_keyState[keyCode] == KEY_DOWN || _keyState[keyCode] == KEY_PRESSED)
        {
            return true;
        }
        return false;

    } // end function keyIsDown  


    /**
	 * Check to see if the key was pressed on the current frame
	 * 
	 * @param	keyCode
	 * @return
	 */
    public static function keyPressed(keyCode:Int):Bool
    {
        if(_keyState[keyCode] == KEY_PRESSED)
        {
            return true;
        }
        return false;
    } // end function keyPressed  


    /**
	 * Check to see if a key has been released on that frame.
	 * 
	 * @param	keyCode
	 * @return
	 */
    public static function keyReleased(keyCode:Int):Bool
    {
        if(_keyState[keyCode] == KEY_RELEASED)
        {
            return true;
        }
        return false;
    } // end function keyReleased  


    /**
	 * Run this function in the main loop.
	 */
    public static function update():Void
    {
        _framesSinceLastKey++;

        // update key states
        for(i in 0..._keyState.length)
        {

            if(_keyState[i] != KEY_UP)
            {
                // set key state to UP if the key state is currently "RELEASED"
                if(_keyState[i] == KEY_RELEASED)
                {
                    _keyState[i] = KEY_UP;
                }

                // set key state to DOWN if the key state is currently "PRESSED"  
                if(_keyState[i] == KEY_PRESSED)
                {
                    _keyState[i] = KEY_DOWN;
                } // end if  
            } // end if  
        } // end for

        // update mouse states
        //mouseIsDown = false;
        mousePressed = false;
        mouseReleased = false;
        //mouseOver = false;

        //fingerIsDown = false;
        fingerTap = false;
        fingerReleased = false;
    } // end function update  


    //****************************************** MOUSE INPUT FUNCTIONS ***************************************************


    /**
	 * 
	 * @param	event
	 */
    private static function mouseDownHandler(event:MouseEvent):Void
    {
        mouseIsDown = true;
        mouseReleased = false;
        mousePressed = true;
        mouseDragX = 0;
        mouseDragY = 0;
    } // end function mouseDownHandler  


    /**
	 * 
	 * @param	event
	 */
    private static function mouseUpHandler(event:MouseEvent):Void
    {
        mouseIsDown = false;
        mouseReleased = true;
        mousePressed = false;
    } // end function mouseUpHandler  


    /**
	 * 
	 * @param	event
	 */
    private static function mouseMoveHandler(event:MouseEvent):Void
    {
        // TODO Fix mouse release not being registered from mouse going off stage
        if(mouseIsDown != event.buttonDown)
        {
            mouseIsDown = event.buttonDown;
            mouseReleased = !event.buttonDown;
            mousePressed = event.buttonDown;
            mouseDragX = 0;
            mouseDragY = 0;
        }

        // Set mouseX, mouseY and mousePos
        mouseX = _mousePos.x = event.stageX - stage.x;
        mouseY = _mousePos.y = event.stageY - stage.y;

        // Store offset
        mouseOffsetX = mouseX - prevMouseX;
        mouseOffsetY = mouseY - prevMouseY;

        // Update drag
        if(mouseIsDown)
        {
            mouseDragX += mouseOffsetX;
            mouseDragY += mouseOffsetY;
        }

        prevMouseX = mouseX;
        prevMouseY = mouseY;
    } // end function mouseMoveHandler  


    /**
	 * 
	 * @param	event
	 */
    private static function mouseLeaveHandler(event:Event):Void
    {
        mouseReleased = mouseIsDown;
        mouseIsDown = false;
        mousePressed = false;

        mouseDetectable = false;
    } // end function mouseLeavHandler  


    /**
	 * 
	 * @param	displayObject
	 * @return
	 */
    public static function mousePositionIn(displayObject:DisplayObject):Point
    {
        return displayObject.globalToLocal(_mousePos);
    } // function mousePositionIn


    //****************************************** TOUCH INPUT FUNCTIONS ***************************************************


    /**
	 * 
	 * @param	event
	 */
    public static function touchBeginHandler(event:TouchEvent):Void
    {
        fingerIsDown = true;
        fingerReleased = false;
        fingerTap = true;
        touchDragX = 0;
        touchDragY = 0;

        touchPressure = event.pressure;
    } // end function touchBeginHandler  


    /**
	 * 
	 * @param	event
	 */
    public static function touchEndHandler(event:TouchEvent):Void
    {
        fingerIsDown = false;
        fingerReleased = true;
        fingerTap = false;

        touchPressure = 0;
    } // end function touchEndHandler  


    /**
	 * 
	 * @param	event
	 */
    public static function touchMoveHandler(event:TouchEvent):Void
    {
        // Set touchX, touchY and touchPos
        touchX = _touchPos.x = event.stageX - stage.x;
        touchY = _touchPos.y = event.stageY - stage.y;

        // Store offset
        touchOffsetX = touchX - prevTouchX;
        touchOffsetY = touchY - prevTouchY;

        // Update drag
        if(fingerIsDown)
        {
            touchDragX += touchOffsetX;
            touchDragY += touchOffsetY;
        }

        prevTouchX = touchX;
        prevTouchY = touchY;

        // Set touchPressure
        touchPressure = event.pressure;
    } // end function touchMoveHandler  


    /**
	 * 
	 * @param	displayObject
	 * @return
	 */
    public static function touchPositionIn(displayObject:DisplayObject):Point
    {
        return displayObject.globalToLocal(_touchPos);
    } // end function touchPositionIn  


    // **************************************  ********************************************

    //
    //
    /*public static function penStartHandler(event:AccelerometerEvent):void
		{
			AccelerometerEvent;
			GeolocationEvent;
			LocationChangeEvent
			PressAndTapGestureEvent
			StageOrientationEvent
		} // */


    // ************************************** SET AND GET ********************************************


    // lastKey
    private static function get_lastKey():Int
    {
        return _lastKey;
    }


    // framesSinceLastKey
    private static function get_framesSinceLastKey():Int
    {
        return _framesSinceLastKey;
    }


    // lastKeyFrameDifference
    private static function get_lastKeyFrameDifference():Int
    {
        return _lastKeyFrameDifference;
    }


    // handleOwnUpdate
    private static function get_handleOwnUpdate():Bool
    {
        return stage.hasEventListener(Event.ENTER_FRAME);
    }

    private static function set_handleOwnUpdate(value:Bool):Bool
    {
        // if value is true, add an enter frame listener to run the update function
        if(value)
        {
            stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }
            //  end if
        else
        {
            if(stage.hasEventListener(Event.ENTER_FRAME))
            {
                stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            }
        }
        return value;
    }


}

