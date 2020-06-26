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

import motion.Actuate;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.utils.Timer;

/**
 * The BScrollBar component provides the end user with a way to control the portion of data that is displayed when there is too much data to fit in the display area.
 *
 * The ScrollBar component provides the end user with a way to control the portion of data that is displayed when there is too much data to fit in the display area.
 * The scroll bar consists of four parts: two arrow buttons, a track, and a thumb. The position of the thumb and display of the buttons depends on the current
 * state of the scroll bar. The scroll bar uses four parameters to calculate its display state: a minimum range value; a maximum range value; a current position
 * that must be within the range values; and a viewport size that must be equal to or less than the range and represents the number of items in the range that can
 * be displayed at the same time.
 *
 * @author Rohaan Allport
 * @creation-date 19/10/2014 (dd/mm/yyyy)
 */
class BScrollBar extends BUIComponent
{
    /**
	 * Gets or sets a value that represents the increment by which to scroll the page when the scroll bar track is pressed. 
	 * The pageScrollSize is measured in increments between the minScrollPosition and the maxScrollPosition values. 
	 * If this value is set to 0, the value of the pageSize property is used.
	 * 
	 * @default 0
	 */
	public var lineScrollSize(get, set):Float;
    
	/**
	 * Gets or sets a number that represents the maximum scroll position. 
	 * The scrollPosition value represents a relative position between the minScrollPosition and the maxScrollPosition values. 
	 * This property is set by the component that contains the scroll bar, and is the maximum value. 
	 * Usually this property describes the number of pixels between the bottom of the component and the bottom of the content, 
	 * but this property is often set to a different value to change the behavior of the scrolling. 
	 * For example, the TextArea component sets this property to the maxScrollH value of the text field, 
	 * so that the scroll bar scrolls appropriately by line of text.
	 * 
	 * @default 10
	 */
	public var maxScrollPosition(get, set):Float;
    
	/**
	 * Gets or sets a number that represents the minimum scroll position. 
	 * The scrollPosition value represents a relative position between the minScrollPosition and the maxScrollPosition values. 
	 * This property is set by the component that contains the scroll bar, and is usually zero.
	 * 
	 * @default 0
	 */
	public var minScrollPosition(get, set):Float;
    
	/**
	 * Gets or sets a value that indicates whether the scroll bar scrolls horizontally or vertically. 
	 * Valid values are BOrientation.HORIZONTAL and BOrientation.VERTICAL.
	 */
	public var orientation(get, set):BOrientation;
    
	/**
	 * Gets or sets a value that represents the increment by which the page is scrolled when the scroll bar track is pressed. 
	 * The pageScrollSize value is measured in increments between the minScrollPosition and the maxScrollPosition values. 
	 * If this value is set to 0, the value of the pageSize property is used.
	 * 
	 * @default 0
	 */
	public var pageScrollSize(get, set):Float;
    
	/**
	 * Gets or sets the number of lines that a page contains. 
	 * The lineScrollSize is measured in increments between the minScrollPosition and the maxScrollPosition. 
	 * If this property is 0, the scroll bar will not scroll.
	 * 
	 * @default 10;
	 */
	public var pageSize(get, set):Float;
    
	/**
	 * Gets or sets the current scroll position and updates the position of the thumb. 
	 * The scrollPosition value represents a relative position between the minScrollPosition and maxScrollPosition values.
	 * 
	 * @default 0
	 */
	public var scrollPosition(get, set):Float;
    
	/**
	 * Registers a TextField instance with the ScrollBar component instance.
	 */
	public var scrollTarget(get, set):TextField;
    
	/**
	 * 
	 */
	public var autoHide(get, set):Bool;
    
	/**
	 * 
	 */
	public var hideDelay(get, set):Int;
    
	/**
	 * 
	 */
	public var scrollBarMode(get, set):String;

    
    // assets
    private var _thumbIcon:Sprite;  //  
    private var _upArrow:BButton;  //  
    private var _downArrow:BButton;  //  
    private var _thumb:BBaseButton;  // The the draggable part of the scroll bar  
    private var _track:BBaseButton;  // The back or the scroll bar. The area where the thumb can slide  
    
    private var _upArrowIcon:DisplayObject;
    private var _downArrowIcon:DisplayObject;
    
    // other
    private var _trackWidth:Int;
    private var _trackHeight:Int;
    //protected var _thumbWidth:int;
    //protected var _thumbHeight:int;
    private var _thumbPercent:Float = 1;  // The size if the thumb in terms of percentage to the height/width  
    private var _delayTimer:Timer;  // The Timer use to timer when the scroll bar is to hide.  
    private var _thumbUpdateX:Float = 0;  // Required for tweening  
    private var _thumbUpdateY:Float = 0;  // Required for tweening  
    
    private var _repeatDelay:Timer;  // The number of milliseconds to wait after the buttonDown event is first dispatched before sending a second buttonDown event.  
    private var _repeatInterval:Timer;  // The interval, in milliseconds, between buttonDown events that are dispatched after the delay that is specified by the repeatDelay.  
    private var _direction:String;
	
	
    // set and get
    private var _lineScrollSize:Float = 0.2;  // Gets or sets a value that represents the increment by which to scroll the page when the scroll bar track is pressed.  
    private var _maxScrollPosition:Float;  // Gets or sets a number that represents the maximum scroll position.  
    private var _minScrollPosition:Float;  // Gets or sets a number that represents the minimum scroll position.  
    private var _orientation:BOrientation;  // Gets or sets a value that indicates whether the scroll bar scrolls horizontally or vertically.  
    private var _pageScrollSize:Float;  // Gets or sets a value that represents the increment by which the page is scrolled when the scroll bar track is pressed.  
    private var _pageSize:Float;  // Gets or sets the number of lines that a page contains.  
    private var _scrollPosition:Float = 0;  // Gets or sets the current scroll position and updates the position of the thumb.  
    private var _scrollTarget:TextField;  // Registers a TextField instance with the ScrollBar component instance.  
    
    private var _autoHide:Bool = true;  // Get or set whether this scroll bar should auto hide after a giving time.  
    private var _hideDelay:Int = 2000;  // Get or set the time it take for the scroll bar to hide.  
    
    private var _scrollBarMode:String = "all";  // Gets or sets the mode of the scroll bat.  
    
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BSrollBar component instance.
	 * 
     * @param	orientation The orientation of the slider. Either horizontal or vertial 
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
     */
    public function new(orientation:BOrientation = BOrientation.VERTICAL, parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        _orientation = orientation;
        
        super(parent, x, y);
        initialize();
        //setSize(100, 20);
        draw();
    }
    
    //**************************************** HANDLERS *********************************************
    
    
    /**
	 * When the trace is clicked the thumb and scroll position changes.
	 * There should be a repeatTime and repeatDelay to adjust how fast it scrolls
	 * 
	 * @param	event
	 */
    private function onTrackMouseDown(event:MouseEvent):Void
    {
        //trace("on track down");
        
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            if (this.mouseX < _thumb.x + _thumb.width / 2) 
            {
                _direction = "up";
                doScroll(_direction);
            }
            else if (this.mouseX > _thumb.x + _thumb.width / 2) 
            {
                _direction = "down";
                doScroll(_direction);
            }
        }
        // start the repeate delay timer
        else if (_orientation == BOrientation.VERTICAL) 
        {
            if (this.mouseY < _thumb.y + _thumb.height / 2) 
            {
                _direction = "up";
                doScroll(_direction);
            }
            else if (this.mouseY > _thumb.y + _thumb.height / 2) 
            {
                _direction = "down";
                doScroll(_direction);
            }
        }
        
        
        _repeatDelay.start();
        
        // add an event listener to listen for when the mouse is up
        stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
        
        // dispatch a new change event
        dispatchEvent(new Event(Event.CHANGE));
    }  // end function onTrackMouseDown  
    
    
    /**
	 * When the mounse is held down on the thumb, the user is able to drag it.
	 * in a range from the top for the track to the bottom of the track
	 * 
	 * @param	event
	 */
    private function onThumbDown(event:MouseEvent):Void
    {
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            _thumb.startDrag(false, new Rectangle(_minScrollPosition, 0, _maxScrollPosition, 0));
        }
        // add an event listen
        else if (_orientation == BOrientation.VERTICAL) 
        {
            _thumb.startDrag(false, new Rectangle(0, _minScrollPosition, 0, _maxScrollPosition));
        }
        
        
        
        stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, updateValue);
    }  // end function onThumbDown  
    
    
    /**
	 * Stops the thumb dragging
	 * called when the user releases the thumb (the stage actually)
	 * 
	 * @param	event
	 */
    private function stopDragging(event:MouseEvent):Void
    {
        _thumb.stopDrag();
        stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateValue);
    }  // end function stopDragging  
    
    
    /**
	 * Updates the value of the scrollPosition (for scroll panes) and the scroll target scroll (for text fields)
	 * called during onClickScrollButton() 
	 * 
	 * @param	event
	 */
    private function updateValue(event:MouseEvent = null):Void
    {
        if (event != null)   // for tweening  
        {
            _thumbUpdateX = _thumb.x;
            _thumbUpdateY = _thumb.y;
        }
        
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            //_scrollPosition = (thumb.x - _minScrollPosition) / _maxScrollPosition;
            _scrollPosition = (_thumbUpdateX - _minScrollPosition) / _maxScrollPosition;
            if (_scrollTarget != null && event != null)   // for textFields  
            {
                _scrollTarget.scrollH = Math.ceil(_scrollPosition * _scrollTarget.maxScrollH);
            }
        }
        // dispatch a new change event
        else if (_orientation == BOrientation.VERTICAL) 
        {
            //_scrollPosition = (thumb.y - _minScrollPosition) / _maxScrollPosition;
            _scrollPosition = (_thumbUpdateY - _minScrollPosition) / _maxScrollPosition;
            
            if (_scrollTarget != null && event != null)   // for textFields  
            {
                _scrollTarget.scrollV = Math.ceil(_scrollPosition * _scrollTarget.maxScrollV);
            }
        }
        
        
        
        dispatchEvent(new Event(Event.CHANGE));
    }  // end function updateValue  
    
    
    /**
	 * Calls doScroll() and passes in "up" or "down" based on the button pressed.
	 * Called when a button is clicked (add functionality for holding down)
	 * 
	 * @param	event
	 */
    private function onMouseDownScrollButton(event:MouseEvent):Void
    {
        if (event.currentTarget == _upArrow) 
        {
            _direction = "up";
        }
        else if (event.currentTarget == _downArrow) 
        {
            _direction = "down";
        }
        
        doScroll(_direction);
        
        // start the repeate delay timer
        _repeatDelay.start();
        
        // add an event listener to listen for when the mouse is up
        stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
    }  // end function onMouseDownScrollButton  
    
    
    /**
	 * Used for stopping continuous scrolling
	 * Called when the mouse is held up
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
    }  // end function onReleaseButtonOrTrack  
    
    
    /**
	 * Starts a timer to hide the scroll bar after a giving time
	 * Called when the mouse rolls off the scroll bar
	 * 
	 * @param	event
	 */
    private function autoHideMouseHandler(event:MouseEvent):Void
    {
        this.addEventListener(MouseEvent.ROLL_OVER, autoHideMouseRollOverHandler);
        
        if (!stage.hasEventListener(MouseEvent.MOUSE_MOVE)) 
        {
            _delayTimer.addEventListener(TimerEvent.TIMER, autoHideTimerHandler);
            _delayTimer.reset();
            _delayTimer.start();
        }
    }  // end function autoHideMouseHandler  
    
    
    /**
	 * Hides the scroll bar 
	 * Called after a giving time after the mouse rolled off the scroll bar
	 * 
	 * @param	event
	 */
    private function autoHideTimerHandler(event:TimerEvent):Void
    {
        _delayTimer.removeEventListener(TimerEvent.TIMER, autoHideTimerHandler);
        //var tween:Tween = new Tween(this, "alpha", Regular.easeOut, 1, 0, 0.3, true);
		// TODO made quick fix (0.01). find alternative?
		Actuate.tween(this, 0.3, { alpha: 0.01} );
    }  // end function autoHideTimerHandler  
    
    
    /**
	 * Shows the scroll bar
	 * Called when the mouse rolls of the scroll bar
	 * 
	 * @param	event
	 */
    private function autoHideMouseRollOverHandler(event:MouseEvent):Void
    {
        this.removeEventListener(MouseEvent.ROLL_OVER, autoHideMouseRollOverHandler);
        _delayTimer.removeEventListener(TimerEvent.TIMER, autoHideTimerHandler);
        
        //var tween:Tween = new Tween(this, "alpha", Regular.easeOut, this.alpha, 1, 0.3, true);
		Actuate.tween(this, 0.3, { alpha: 1} );
    }  // end function autoHideMouseRollOverHandler  
    
    
    /**
	 * 
	 * @param	event
	 */
    private function repeatDelayCompleteHandler(event:TimerEvent):Void
    {
        _repeatInterval.start();
    }  // end function repeatDelayCompleteHandler  
    
    
    /**
	 * 
	 * @param	event
	 */
    private function repeatIntervalTimerHandler(event:TimerEvent):Void
    {
        doScroll(_direction);
    }  // end function repeatIntervalTimerHandler  
    
    
    //************************************* FUNCTIONS ******************************************
    
    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();
        
		// initialize the assets
        _track = new BBaseButton(this);
        _upArrow = new BButton(this);
        _downArrow = new BButton(this);
        _thumb = new BBaseButton(this);
		
		_track.focusEnabled = false;
		_upArrow.focusEnabled = false;
		_downArrow.focusEnabled = false;
		_thumb.focusEnabled = false;
        
        // initialize buttons
        _thumb.setStateColors(0x999999, 0x999999, 0xCCCCCC, 0x111111);
        _thumb.setStateAlphas(0.5, 1, 1, 1, 1, 1, 1, 1);
        
        _track.setStateColors(0x666666, 0x666666, 0x666666, 0x666666);
        _track.setStateAlphas(0.5, 1, 1, 1, 1, 1, 1, 1);
        
        _upArrow.setSize(14, 14);
        _downArrow.setSize(14, 14);
        _upArrow.setStateColors(0x000000, 0x999999, 0xCCCCCC, 0x000000);
        _downArrow.setStateColors(0x000000, 0x999999, 0xCCCCCC, 0x000000);
        _upArrow.setStateAlphas(0, 1, 1, 1, 0, 1, 1, 1);
        _downArrow.setStateAlphas(0, 1, 1, 1, 0, 1, 1, 1);
        
        // icons
        _upArrowIcon = new Bitmap(Assets.getBitmapData ("graphics/arrow icon 01 32x32.png"));
        _downArrowIcon = new Bitmap(Assets.getBitmapData ("graphics/arrow icon 01 32x32.png"));
        _upArrowIcon.width = 10;
        _upArrowIcon.height = 10;
        _downArrowIcon.width = 10;
        _downArrowIcon.height = 10;
        _downArrowIcon.rotation = 180;
        
        _upArrow.icon = _upArrowIcon;
        _downArrow.icon = _downArrowIcon;
        _downArrow.y = 100;
        
        //
        buttonMode = true;
        useHandCursor = true;
        mouseChildren = true;
        
        // prevent the track from coming infront the other assets
        //track.tabEnabled = false;
		_track.focusEnabled = false;
        
        //
        autoHide = true;
        
        // timers
        _delayTimer = new Timer(_hideDelay);
        _repeatDelay = new Timer(500, 1);
        _repeatInterval = new Timer(50);
        
        // checking to see if the orientation property is set to horizontal or vertical, or neither
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            setSize(200, 14);
            _trackWidth = cast _width;
            _trackHeight = 14;
        }
        else if (_orientation == BOrientation.VERTICAL) 
        {
            setSize(14, 200);
            _trackWidth = 14;
            _trackHeight = cast _height;
        }
        else 
        {
            setSize(200, 14);
            _orientation = BOrientation.HORIZONTAL;
            _trackWidth = cast _width;
            _trackHeight = 14;
            //throw new Error("The BOrientation.orientation property can only me 'horizontal' or 'vertical'. Use the BSliderOrientation class for set this property.");
        }
        
        
        
        // event handling
        _track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackMouseDown);
        _thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
        _upArrow.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownScrollButton);
        _downArrow.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownScrollButton);
        
        _repeatDelay.addEventListener(TimerEvent.TIMER_COMPLETE, repeatDelayCompleteHandler);
        _repeatInterval.addEventListener(TimerEvent.TIMER, repeatIntervalTimerHandler);
    }  // end function initialize  
    
    
    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        super.draw();
        
        var thumbWidth:Int = 14;
        var thumbHeight:Int = 14;
        
		
		
        // checking to see if the orientation property is set to horizontal or vertical, or neither
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            _thumb.x = 14;
            _thumb.y = 0;
            
            _trackWidth = cast _width;
            _trackHeight = 14;
            
            // set the thumb with and height
            if (_scrollTarget != null) 
            {
                _thumbPercent = _scrollTarget.width / _scrollTarget.textWidth;
            }
            thumbWidth = Std.int((_width - 14 * 2) * _thumbPercent);
            thumbWidth = Std.int(Math.max(_trackHeight, thumbWidth));
            thumbHeight = _trackHeight;
            
            //
            _minScrollPosition = 14;
            _maxScrollPosition = _width - thumbWidth - 14 * 2;
        }
        else if (_orientation == BOrientation.VERTICAL) 
        {
            _thumb.x = 0;
            _thumb.y = 14;
            
            _trackWidth = 14;
            _trackHeight = cast _height;
            
            // set the thumb width and height
            thumbWidth = _trackWidth;
            if (_scrollTarget != null) 
            {
                _thumbPercent = _scrollTarget.height / _scrollTarget.textHeight;
            }
            thumbHeight = Std.int((_height - 14 * 2) * _thumbPercent);
            thumbHeight = cast Math.max(_trackWidth, thumbHeight);
            
            //
            _minScrollPosition = 14;
            _maxScrollPosition = _height - thumbHeight - 14 * 2;
        }
        
        
		// draw track
        // draw upArrow
        // draw downArrow
        _upArrow.setSize(14, 14);
        _downArrow.setSize(14, 14);
        _thumb.setSize(thumbWidth, thumbHeight);
        _track.setSize(_trackWidth, _trackHeight);
        
        
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            //upArrow.move(0, 0);
            //downArrow.move(_width - downArrow.width, 0);
            
            _upArrow.move(0, cast _upArrow.height);
            _downArrow.move(cast(_width - _downArrow.width), cast _downArrow.height);
            _upArrow.rotation = -90;
            _downArrow.rotation = -90;
        }
        else if (_orientation == BOrientation.VERTICAL) 
        {
            _upArrow.move(0, 0);
            _downArrow.move(0, cast(_height - _downArrow.height));
            _upArrow.rotation = 0;
            _downArrow.rotation = 0;
        }
        
		// TODO rethink this. This causes a bug in parent UI such as BList where the scrollbar won't stay invisible even when needed such as autoSize.
        /*if (_thumbPercent == 1) 
        {
            visible = false;
        }
        else 
        {
            visible = true;
        }*/
    }  // end function draw  
    
    
    /**
	 * Adjusts position of handle when value, maximum or minimum have changed.
	 */
    private function positionThumb():Void
    {
        /*
			if(_orientation == BOrientation.HORIZONTAL)
			{
				
			}
			else if(_orientation == BOrientation.VERTICAL)
			{
				
			}*/
        
    }  // end function positionThumb  
    
    
	/**
	 * Used the adjusting the size of the thumb in terms of a percentage
	 * Called in a displayObjectContainer such as a BscrollPane
	 * 
	 * @param	value
	 */
    public function setThumbPercent(value:Float):Void
    {
        _thumbPercent = Math.min(value, 1.0);
        invalidate();
    }  // end function setThumbPercent  
    
    
    /**
	 * Changes the position of the thumb.
	 * changes the scroll target scroll (for textfields)
	 * calls updateValue()
	 * Called when the buttons are clicked, held down or the track is held down
	 * 
	 * @param	direction
	 */
    public function doScroll(direction:String):Void
    {
        // removed tweening because of scrolling when track is down.
        
        var percent:Float = 0;  // used for positioning the thumb  
        
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            if (_scrollTarget != null)   // for scrolling text fields  
            {
                _scrollTarget.scrollH += ((direction == "up")) ? -10 : 10;
                percent = (_scrollTarget.scrollH - 1) / (_scrollTarget.maxScrollH - 1);
				// TODO make horizontal scrolling
            }
            else if (_lineScrollSize != 0)   // for scrolling display objects  
            {
                percent = (_thumb.x - _minScrollPosition) / _maxScrollPosition;
                percent += ((direction == "up")) ? -_lineScrollSize : _lineScrollSize;
                if (percent < 0) 
                {
                    percent = 0;
                }
                else if (percent > 1) 
                {
                    percent = 1;
                }
            }
            
            _thumb.x = percent * _maxScrollPosition + 14;
            _thumbUpdateX = percent * _maxScrollPosition + 14;
        } // end if
        //
        else if (_orientation == BOrientation.VERTICAL) 
        {
            if (_scrollTarget != null)   // for scrolling text fields  
            {
                _scrollTarget.scrollV += ((direction == "up")) ? -1 : 1;
                percent = (_scrollTarget.scrollV - 1) / (_scrollTarget.maxScrollV - 1);
				//_thumb.y = percent * (_height - _thumb.height - 14 * 2) + 14;
				_maxScrollPosition = (_height - _thumb.height - 14 * 2);
            }
            else if (_lineScrollSize != 0)   // for scrolling display objects  
            {
                percent = (_thumb.y - _minScrollPosition) / _maxScrollPosition;
                percent += ((direction == "up")) ? -_lineScrollSize : _lineScrollSize;
                if (percent < 0) 
                {
                    percent = 0;
                }
                else if (percent > 1) 
                {
                    percent = 1;
                }
            }
            
            _thumb.y = percent * _maxScrollPosition + 14;
            _thumbUpdateY = percent * _maxScrollPosition + 14;
        } // end if
        
        
        updateValue();
    }  // end function doScroll  
    
    
    //***************************************** SET AND GET *****************************************
    
    
    private function get_lineScrollSize():Float
    {
        return _lineScrollSize;
    }
    private function set_lineScrollSize(value:Float):Float
    {
        _lineScrollSize = value;
        return value;
    }
    
    
    private function get_maxScrollPosition():Float
    {
        return _maxScrollPosition;
    }
    private function set_maxScrollPosition(value:Float):Float
    {
        _maxScrollPosition = value;
        return value;
    }
    
    
    private function get_minScrollPosition():Float
    {
        return _minScrollPosition;
    }
    private function set_minScrollPosition(value:Float):Float
    {
        _minScrollPosition = value;
        return value;
    }
    
    
    private function get_orientation():BOrientation
    {
        return _orientation;
    }
    private function set_orientation(value:BOrientation):BOrientation
    {
        var prevOrientation:BOrientation = _orientation;  // a temporary variable to hold the previous orientation  
        //var prevWidth:Number = _width;				// a temporary variable to hold the previous width
        //var prevHeight:Number = _height;			// a temporary variable to hold the previous height
        
        _orientation = value;
        
        // determine the new orrientation and swap the width and height
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            prevOrientation == (BOrientation.HORIZONTAL) ? setSize(_width, _height) : setSize(_height, _width);
        }
        else if(_orientation == BOrientation.VERTICAL) 
        {
            prevOrientation == (BOrientation.VERTICAL) ? setSize(_width, _height) : setSize(_height, _width);
        }
        else 
        {
            setSize(_width, _height);
            _orientation = BOrientation.HORIZONTAL;
            //throw new Error("The BScrollBar.orientation property can only me 'horizontal' or 'vertical'. Use the BOrientation class for set this property.");
        }
        
        invalidate();
        return value;
    }
    
    
    private function get_pageScrollSize():Float
    {
        return _pageScrollSize;
    }
    private function set_pageScrollSize(value:Float):Float
    {
        _pageScrollSize = value;
        return value;
    }
    
    
    private function get_pageSize():Float
    {
        return _pageSize;
    }
    private function set_pageSize(value:Float):Float
    {
        _pageSize = value;
        return value;
    }
    
    
    private function get_scrollPosition():Float
    {
        return _scrollPosition;
    }
    private function set_scrollPosition(value:Float):Float
    {
        _scrollPosition = value;
        return value;
    }
    
    
    private function get_scrollTarget():TextField
    {
        return _scrollTarget;
    }
    private function set_scrollTarget(value:TextField):TextField
    {
        _scrollTarget = value;
        invalidate();
        return value;
    }
    
    
    private function get_autoHide():Bool
    {
        return _autoHide;
    }
    private function set_autoHide(value:Bool):Bool
    {
        _autoHide = value;
        
        if (value) 
        {
            this.addEventListener(MouseEvent.ROLL_OUT, autoHideMouseHandler);
            this.addEventListener("releaseOutside", autoHideMouseHandler);
        }
        else 
        {
            this.removeEventListener(MouseEvent.ROLL_OUT, autoHideMouseHandler);
            this.removeEventListener("releaseOutside", autoHideMouseHandler);
        }
        return value;
    }
    
    
    private function get_hideDelay():Int
    {
        return _hideDelay;
    }
    private function set_hideDelay(value:Int):Int
    {
        _hideDelay = value;
        _delayTimer.delay = _hideDelay;
        return value;
    }
    
    
    private function get_scrollBarMode():String
    {
        return _scrollBarMode;
    }
    private function set_scrollBarMode(value:String):String
    {
        switch (value)
        {
            case BScrollBarMode.ALL:
                _track.visible = true;
                _thumb.visible = true;
                _upArrow.visible = true;
                _downArrow.visible = true;
            
            case BScrollBarMode.BUTTONS_ONLY:
                _track.visible = false;
                _thumb.visible = false;
                _upArrow.visible = true;
                _downArrow.visible = true;
            
            case BScrollBarMode.SLIDER_ONLY:
                _track.visible = true;
                _thumb.visible = true;
                _upArrow.visible = false;
                _downArrow.visible = false;
            
            
            default:
                _track.visible = true;
                _thumb.visible = true;
                _upArrow.visible = true;
                _downArrow.visible = true;
        }
        
        _scrollBarMode = value;
        return value;
    }
	
}

