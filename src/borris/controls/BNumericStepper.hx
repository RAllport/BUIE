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

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.utils.Timer;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 11/04/2015 (dd/mm/yyyy)
 */
class BNumericStepper extends BUIComponent
{
    /**
	 * Gets or sets the maximum number of characters that a user can enter in the text field.
	 */
    public var maxChars(get, set):Int;

    /**
	 * Gets or sets the maximum value in the sequence of numeric values.
	 * 
	 * @default 10
	 */
    public var maximum(get, set):Float;

    /**
	 * Gets or sets the minimum number in the sequence of numeric values.
	 * 
	 * @default 0
	 */
    public var minimum(get, set):Float;

    /**
	 * Gets the next value in the sequence of values.
	 */
    public var nextValue(get, never):Float;

    /**
	 * Gets the previous value in the sequence of values.
	 */
    public var previousValue(get, never):Float;

    /**
	 * 
	 */
    public var stepSize(get, set):Float;

    /**
	 * Gets or sets a nonzero number that describes the unit of change between values. 
	 * The value property is a multiple of this number less the minimum. 
	 * The NumericStepper component rounds the resulting value to the nearest step size.
	 * 
	 * @default 1
	 */
    public var value(get, set):Float;

    /**
	 * TOP
	 * BOTTOM
	 * LEFT
	 * RIGHT
	 * VERTICAL
	 * HORIZONTAL
	 */
    public var buttonPlacement(get, set):BPlacement;

    /**
	 * @copy borris.controls.BTextInput#editable
	 */
    public var editable(get, set):Bool;

    /**
	 * 
	 */
    public var mode(get, set):BNumericStepperMode;


    // assets
    private var _inputText:BTextInput;
    private var _upButton:BButton;
    private var _downButton:BButton;
    private var _percentageText:TextField;

    // other
    private var _repeatDelay:Timer; // The number of milliseconds to wait after the buttonDown event is first dispatched before sending a second buttonDown event.
    private var _repeatInterval:Timer; // The interval, in milliseconds, between buttonDown events that are dispatched after the delay that is specified by the repeatDelay.
    private var _direction:String;

    // set and get
    private var _maxChars:Int = 0;
    private var _maximum:Float = 10;
    private var _minimum:Float = 0;
    private var _nextValue:Float = 1;
    private var _previousValue:Float = 0;
    private var _stepSize:Float = 1;
    private var _value:Float = 0;
    private var _buttonPlacement:BPlacement = BPlacement.LEFT;
    private var _mode:BNumericStepperMode = BNumericStepperMode.NORMAL;


    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BNumericStepper component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x position to place this component.
     * @param	y The y position to place this component.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        super(parent, x, y);
        initialize();
        setSize(100, 30);
    }


    //**************************************** HANDLERS *********************************************


    /**
     * 
     * @param	event
     */
    private function mouseDownHandler(event:MouseEvent = null):Void
    {
        if(event.currentTarget == _upButton)
        {
            _direction = "increment";
        }
        else if(event.currentTarget == _downButton)
        {
            _direction = "decrement";
        }

        incrementOrDecrement(_direction);

        // start the repeate delay timer
        _repeatDelay.start();

        // add an event listener to listen for when the mouse is up
        stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);

        dispatchEvent(new Event(Event.CHANGE, false, false));
    } // end function mouseDownHandler


    /**
     * 
     * @param	event
     */
    private function inputTextChangeHandler(event:Event):Void
    {
        var tempValue:Float = Std.parseFloat(_inputText.text);

        if(tempValue >= _minimum && tempValue <= _maximum)
        {
            _value = tempValue;
        }

        validateValues();
        trace("BNumericStepper | value: " + _value);
        trace("BNumericStepper | next value: " + _nextValue);
        trace("BNumericStepper | prev value: " + _previousValue);

        dispatchEvent(new Event(Event.CHANGE, false, false));
    } // end function inputTextChangeHander


    /**
	 * Used for stopping continuous scrolling.
	 * Called when the mouse is held up.
	 * 
	 * @param	event
	 */
    private function onReleaseMouse(event:MouseEvent):Void
    {
        _repeatDelay.stop();
        _repeatDelay.reset();

        _repeatInterval.stop();
        _repeatInterval.reset();

        stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
    } // end function onReleaseButtonOrTrack


    /**
	 * 
	 * @param	event
	 */
    private function repeatDelayCompleteHandler(event:TimerEvent):Void
    {
        _repeatInterval.start();
    } // end function repeatDelayCompleteHandler


    /**
	 * 
	 * @param	event
	 */
    private function repeatIntervalTimerHandler(event:TimerEvent):Void
    {
        incrementOrDecrement(_direction);

        dispatchEvent(new Event(Event.CHANGE, false, false));
    } // end function repeatIntervalTimerHandler


    //************************************* FUNCTIONS ******************************************


    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();

        // initialize assets

        //
        _inputText = new BTextInput(this, 0, 0, Std.string(_value));
        _inputText.restrict = "-1234567890.";

        //
        _upButton = new BButton(this, 0, 0);
        _downButton = new BButton(this, 0, 0);

        // icons
        _upButton.icon = new Bitmap(Assets.getBitmapData("graphics/arrow icon 10x5.png"));
        _downButton.icon = new Bitmap(Assets.getBitmapData("graphics/arrow icon 10x5.png"));

        // percentage text
        _percentageText = new TextField();
        _percentageText.text = "%";
        _percentageText.autoSize = TextFieldAutoSize.RIGHT;
        _percentageText.setTextFormat(_inputText.textField.getTextFormat());
        _percentageText.defaultTextFormat = _inputText.textField.getTextFormat();
        _percentageText.height = _inputText.textField.height;
        _percentageText.selectable = false;
        addChild(_percentageText);
        _percentageText.visible = (_mode == BNumericStepperMode.PERCENTAGE);


        // timers
        _repeatDelay = new Timer(500, 1);
        _repeatInterval = new Timer(50);


        // draw the Numeric stepper
        draw();


        // event handling
        _upButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        _downButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        _inputText.addEventListener(Event.CHANGE, inputTextChangeHandler);

        _repeatDelay.addEventListener(TimerEvent.TIMER_COMPLETE, repeatDelayCompleteHandler);
        _repeatInterval.addEventListener(TimerEvent.TIMER, repeatIntervalTimerHandler);
    } // end function initialize


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        super.draw();

        var textHeight:Int = 30;
        var buttonWidth:Int = 30;

        // set the width and height of the text input
        _inputText.width = _width - buttonWidth;
        _inputText.height = _height;


        // set the width, height and positions of the buttons
        _upButton.icon.rotation = 0;
        _downButton.icon.rotation = 180;


        if(_buttonPlacement == BPlacement.TOP)
        {
            _height = 60;

            _inputText.x = 0;
            _inputText.y = _height / 2;
            _inputText.width = _width;
            _inputText.height = _height / 2;

            _upButton.width = _width;
            _upButton.height = _height / 4;
            _upButton.x = 0;
            _upButton.y = 0;

            _downButton.width = _width;
            _downButton.height = _height / 4;
            _downButton.x = 0;
            _downButton.y = _upButton.height;
        }
        else if(_buttonPlacement == BPlacement.BOTTOM)
        {
            _height = 60;

            _inputText.x = 0;
            _inputText.y = 0;
            _inputText.width = _width;
            _inputText.height = _height / 2;

            _upButton.width = _width;
            _upButton.height = _height / 4;
            _upButton.x = 0;
            _upButton.y = _inputText.y + _inputText.height;

            _downButton.width = _width;
            _downButton.height = _height / 4;
            _downButton.x = 0;
            _downButton.y = _upButton.y + _upButton.height;
        }
        else if(_buttonPlacement == BPlacement.LEFT)
        {
            _height = 30;

            _inputText.x = 0;
            _inputText.y = 0;
            _inputText.width = _width - buttonWidth;
            _inputText.height = _height;

            _upButton.width = buttonWidth;
            _upButton.height = _height / 2;
            _upButton.x = _width - _upButton.width;
            _upButton.y = 0;

            _downButton.width = buttonWidth;
            _downButton.height = _height / 2;
            _downButton.x = _width - _downButton.width;
            _downButton.y = _height / 2;
        }
        else if(_buttonPlacement == BPlacement.RIGHT)
        {
            _height = 30;

            _inputText.x = buttonWidth;
            _inputText.y = 0;
            _inputText.width = _width - buttonWidth;
            _inputText.height = _height;

            _upButton.width = buttonWidth;
            _upButton.height = _height / 2;
            _upButton.x = 0;
            _upButton.y = 0;

            _downButton.width = buttonWidth;
            _downButton.height = _height / 2;
            _downButton.x = 0;
            _downButton.y = _height / 2;
        }
        else if(_buttonPlacement == BPlacement.VERTICAL)
        {
            _height = 60;

            _inputText.x = 0;
            _inputText.y = _height / 4;
            _inputText.width = _width;
            _inputText.height = _height / 2;

            _upButton.width = _width;
            _upButton.height = _height / 4;
            _upButton.x = 0;
            _upButton.y = 0;

            _downButton.width = _width;
            _downButton.height = _height / 4;
            _downButton.x = 0;
            _downButton.y = _height * 3 / 4;
        }
        else if(_buttonPlacement == BPlacement.HORIZONTAL)
        {
            _height = 30;

            _inputText.x = buttonWidth;
            _inputText.y = 0;
            _inputText.width = _width - buttonWidth * 2;
            _inputText.height = _height;

            _upButton.width = buttonWidth;
            _upButton.height = _height;
            _upButton.x = _inputText.x + _inputText.width;
            _upButton.y = 0;

            _downButton.width = buttonWidth;
            _downButton.height = _height;
            _downButton.x = 0;
            _downButton.y = 0;

            _upButton.icon.rotation = 90;
            _downButton.icon.rotation = -90;
        }

        _upButton.icon.x = _upButton.width / 2;
        _upButton.icon.y = _upButton.height / 2;
        _downButton.icon.x = _downButton.width / 2;
        _downButton.icon.y = _downButton.height / 2;

        /*upButton.icon.width = upButton.icon.height = 16;
			downButton.icon.width = downButton.icon.height = 16;
			upButton.icon.x = upButton.width / 2 - upButton.icon.width/2;
			upButton.icon.y = upButton.height / 2 - upButton.icon.height/2;
			downButton.icon.x = downButton.width / 2 - downButton.icon.width/2;
			downButton.icon.y = downButton.height / 2 - downButton.icon.height/2;
			upButton.icon.rotation = 0;
			downButton.icon.rotation = 0;*/

        _percentageText.setTextFormat(_inputText.textField.getTextFormat());
        _percentageText.defaultTextFormat = _inputText.textField.getTextFormat();
        _percentageText.height = _inputText.textField.height;
        _percentageText.x = _inputText.x + _inputText.width - _percentageText.width;
        _percentageText.y = _inputText.y + _inputText.textField.y;


        //
        validateValues();

        // update the text of the TextInput
        updateTextInput();
    } // end function draw


    /**
	 * updates the text of the text input
	 */
    private function updateTextInput():Void
    {
        _inputText.text = Std.string(_value);
    } // end function updateValue


    /**
	 * Makes sure that value, nextValue, previousValue is not geater than or less then maximum and minimum.
	 * Called during draw(), mouseClickHandler(), inputTextChangeHandler(), set value(), set maximum(), set minimum(), and set stepSize();
	 */
    private function validateValues():Void
    {
        // make sure value is not above maximum and not below minimum
        if(_value > _maximum)
        {_value = _maximum;
        }
        if(_value < _minimum)
        {_value = _minimum;
        } // set next value and previous value


        _nextValue = _value + _stepSize;
        _previousValue = value - _stepSize;

        //
        if(_nextValue > _maximum)
        {_nextValue = _maximum;
        }
        if(_previousValue < _minimum)
        {_previousValue = _minimum;
        }
    } //  end function validateValues


    /**
	 * 
	 * @param	direction
	 */
    private function incrementOrDecrement(direction:String):Void
    {
        if(direction == "increment")
        {
            _value += _stepSize;
        }
        else if(direction == "decrement")
        {
            _value -= _stepSize;
        }

        validateValues();
        updateTextInput();
    } // end function incrementOrDecrement


    //***************************************** SET AND GET *****************************************


    private function get_maxChars():Int
    {
        return _maxChars;
    }

    private function set_maxChars(value:Int):Int
    {
        _maxChars = value;
        _inputText.maxChars = value;
        return value;
    }


    private function get_maximum():Float
    {
        return _maximum;
    }

    private function set_maximum(value:Float):Float
    {
        _maximum = value;
        validateValues();
        return value;
    }


    private function get_minimum():Float
    {
        return _minimum;
    }

    private function set_minimum(value:Float):Float
    {
        _minimum = value;
        validateValues();
        return value;
    }


    private function get_nextValue():Float
    {
        return _nextValue;
    }


    private function get_previousValue():Float
    {
        return _previousValue;
    }


    private function get_stepSize():Float
    {
        return _stepSize;
    }

    private function set_stepSize(value:Float):Float
    {
        _stepSize = value;
        validateValues();
        return value;
    }


    private function get_value():Float
    {
        return _value;
    }

    private function set_value(value:Float):Float
    {
        _value = value;
        validateValues();
        updateTextInput();
        return value;
    }


    private function get_buttonPlacement():BPlacement
    {
        return _buttonPlacement;
    }

    private function set_buttonPlacement(value:BPlacement):BPlacement
    {
        _buttonPlacement = value;
        draw();
        return value;
    }


    private function get_editable():Bool
    {
        return _inputText.editable;
    }

    private function set_editable(value:Bool):Bool
    {
        _inputText.editable = value;
        _inputText.textField.selectable = value;
        return value;
    }


    private function get_mode():BNumericStepperMode
    {
        return _mode;
    }

    private function set_mode(value:BNumericStepperMode):BNumericStepperMode
    {
        _mode = value;
        _percentageText.visible = (_mode == BNumericStepperMode.PERCENTAGE);
        return value;
    }
}

