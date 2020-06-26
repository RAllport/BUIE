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

import borris.controls.BButton;
import borris.display.BElement;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObjectContainer;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.ui.Keyboard;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 11/11/2015 (dd/mm/yyyy)
 */
class BVirtualDPad extends BUIComponent
{
    // constants


    // assets
    private var _background:BElement;

    private var _upButton:BButton;
    private var _downButton:BButton;
    private var _leftButton:BButton;
    private var _rightButton:BButton;


    // other


    // set and get
    private var _buttonStyle:String = "gamepadArrow"; // gamepadFull(nintendo style), gamepadarraw (sony), gamepadspace keyboard


    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BVirtualDPad component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will
     * have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels.
     * This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels.
     * This value is calculated from the top.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        super(parent, x, y);
        initialize();
        setSize(120, 120);
    }


    //**************************************** HANDLERS *********************************************


    /**
    *
    * @param	event
    */
    private function mouseDownHandler(event:MouseEvent):Void
    {
        var keyboardEvent:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false);

        if(event.target == _upButton)
        {
            keyboardEvent.charCode = Keyboard.UP;
            keyboardEvent.keyCode = Keyboard.UP;
        }
        else if(event.target == _downButton)
        {
            keyboardEvent.charCode = Keyboard.DOWN;
            keyboardEvent.keyCode = Keyboard.DOWN;
        }
        else if(event.target == _leftButton)
        {
            keyboardEvent.charCode = Keyboard.LEFT;
            keyboardEvent.keyCode = Keyboard.LEFT;
        }
        else if(event.target == _rightButton)
        {
            keyboardEvent.charCode = Keyboard.RIGHT;
            keyboardEvent.keyCode = Keyboard.RIGHT;
        }

        dispatchEvent(keyboardEvent);
    } // end function


    /**
     *
     * @param	event
     */
    private function mouseUpHandler(event:MouseEvent):Void
    {
        var keyboardEvent:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_UP, true, false);

        if(event.target == _upButton)
        {
            keyboardEvent.charCode = Keyboard.UP;
            keyboardEvent.keyCode = Keyboard.UP;
        }
        else if(event.target == _downButton)
        {
            keyboardEvent.charCode = Keyboard.DOWN;
            keyboardEvent.keyCode = Keyboard.DOWN;
        }
        else if(event.target == _leftButton)
        {
            keyboardEvent.charCode = Keyboard.LEFT;
            keyboardEvent.keyCode = Keyboard.LEFT;
        }
        else if(event.target == _rightButton)
        {
            keyboardEvent.charCode = Keyboard.RIGHT;
            keyboardEvent.keyCode = Keyboard.RIGHT;
        }

        dispatchEvent(keyboardEvent);
    } // end function


    //**************************************** FUNCTIONS ********************************************


    /**
     * Initailizes the component by creating assets, setting properties and adding listeners.
     */
    override private function initialize():Void
    {
        super.initialize();

        // initialize assets
        _background = new BElement();

        _upButton = new BButton();
        _downButton = new BButton();
        _leftButton = new BButton();
        _rightButton = new BButton();


        _upButton.setStateColors(0x333333, 0x999999, 0x0099CC, 0x333333);
        _downButton.setStateColors(0x333333, 0x999999, 0x0099CC, 0x333333);
        _leftButton.setStateColors(0x333333, 0x999999, 0x0099CC, 0x333333);
        _rightButton.setStateColors(0x333333, 0x999999, 0x0099CC, 0x333333);

        _upButton.setStateAlphas(1, 1, 1, 1, 1, 1, 1, 1);
        _downButton.setStateAlphas(1, 1, 1, 1, 1, 1, 1, 1);
        _leftButton.setStateAlphas(1, 1, 1, 1, 1, 1, 1, 1);
        _rightButton.setStateAlphas(1, 1, 1, 1, 1, 1, 1, 1);

        _upButton.setIcon(new Bitmap(Assets.getBitmapData("img/arrow icon 01 32x32.png")));
        _downButton.setIcon(new Bitmap(Assets.getBitmapData("img/arrow icon 01 32x32.png")));
        _leftButton.setIcon(new Bitmap(Assets.getBitmapData("img/arrow icon 01 32x32.png")));
        _rightButton.setIcon(new Bitmap(Assets.getBitmapData("img/arrow icon 01 32x32.png")));


        // add assets to respective containers
        addChild(_background);
        addChild(_upButton);
        addChild(_downButton);
        addChild(_leftButton);
        addChild(_rightButton);


        // draw
        draw();


        // event handling
        _upButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        _downButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        _leftButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        _rightButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

        _upButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseUpHandler);
        _downButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseUpHandler);
        _leftButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseUpHandler);
        _rightButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseUpHandler);
    } // end function


    /**
     * @inheritDoc
     */
    override private function draw():Void
    {
        // draw the background
        _background.style.backgroundColor = 0x000000;
        _background.style.backgroundOpacity = 0.3;
        _background.width = _width;
        _background.height = _height;


        // set the size of the buttons
        _upButton.setSize(_width / 3, _height / 3);
        _downButton.setSize(_width / 3, _height / 3);
        _leftButton.setSize(_width / 3, _height / 3);
        _rightButton.setSize(_width / 3, _height / 3);

        // move the bottons
        _upButton.move(Std.int(_width / 3), 0);
        _downButton.move(Std.int(_width / 3), Std.int(_height / 3 * 2));
        _leftButton.move(0, Std.int(_height / 3));
        _rightButton.move(Std.int(_width / 3 * 2), Std.int(_height / 3));

        // reposition the icons
        _upButton.setIconBounds(0, 0, 16, 16, 0);
        _downButton.setIconBounds(0, 0, 16, 16, 180);
        _leftButton.setIconBounds(0, 0, 16, 16, -90);
        _rightButton.setIconBounds(0, 0, 16, 16, 90);

        _upButton.iconPlacement = BPlacement.CENTER;
        _downButton.iconPlacement = BPlacement.CENTER;
        _leftButton.iconPlacement = BPlacement.CENTER;
        _rightButton.iconPlacement = BPlacement.CENTER;
    }
    // end function

} // end class

