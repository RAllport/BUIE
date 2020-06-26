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

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextFieldAutoSize;

// BUG snapInterval not working
// TODO finish live dragging
// TODO finish position thumbs
/**
 * The Slider component lets users select a value by moving a slider thumb between the end points of the slider track. The current value of the Slider component is determined by the relative location of the thumb between the end points of the slider, corresponding to the minimum and maximum values of the Slider component.
 *
 * @author Rohaan Allport
 * @creation-date 01/05/2015  (dd/mm/yyyy)
 */
class BRangeSlider extends BUIComponent
{
    /**
	 * Gets or sets a Boolean value that indicates whether the value is changed
	 * continuously as the user moves the slider thumb. 
	 */
	public var liveDragging(get, set):Bool;
    
	/**
	 * The maximum allowed value on the BSlider component instance.
	 * 
	 * @default 10
	 */
	public var maximum(get, set):Float;
    
	/**
	 * The minimum value allowed on the BSlider component instance.
	 * 
	 * @default 0
	 */
	public var minimum(get, set):Float;
    
	/**
	 * Sets the orientaion of the slider. 
	 * Acceptable values are BOrientation.HORIZONTAL and BOrientation.VERTICAL.
	 */
	public var orientation(get, set):BOrientation;
    
	/**
	 * Gets or sets the increment by which the value is increased or decreased as the user moves the slider thumb.
	 * 
	 * <p>For example, this property is set to 2, the minimum value is 0, and the maximum value is 10, 
	 * the position of the thumb will always be at 0, 2, 4, 6, 8, or 10. If this property is set to 0, 
	 * the slider moves continuously between the minimum and maximum values.</p>
	 * 
	 * @default 0
	 */
	public var snapInterval(get, set):Float;
    
	/**
	 * The spacing of the tick marks relative to the maximum value of the component. 
	 * The BSlider component displays tick marks whenever you set the tickInterval property to a nonzero value.
	 * 
	 * @default 0
	 */
	public var tickInterval(get, set):Float;
    
	/**
	 * Gets or sets the current high value of the BSlider component. 
	 * This value is determined by the position of the slider thumb between the minimum and maximum values.
	 */
	public var highValue(get, set):Float;
    
	/**
	 * Gets or sets the current low value of the BSlider component. 
	 * This value is determined by the position of the slider thumb between the minimum and maximum values.
	 */
	public var lowValue(get, set):Float;
    
	/**
	 * 
	 */
	public var labelMode(get, set):BSliderLabelMode;
    
	/**
	 * 
	 */
	public var labelPrecision(get, set):Int;
    
	/**
	 * 
	 */
	public var labelPlacement(get, set):BPlacement;

	
    // constants
    
    
    // assets
    private var _highThumb:BBaseButton;
    private var _lowThumb:BBaseButton;
    
    private var _sliderTrackSkin:Sprite;
    private var _sliderTrackDisabledSkin:Sprite;
    
    private var _tickSkin:Sprite;
    
    private var _highLabel:BLabel;
    private var _lowLabel:BLabel;
    
    
    // other
    private var _disabledAlpha:Float = 0.5;
    
    private var _trackWidth:Int;
    private var _trackHeight:Int;
    
    
    // set and get
    private var _liveDragging:Bool = true;
    private var _maximum:Float = 100;
    private var _minimum:Float = 0;
    private var _orientation:BOrientation;
    private var _snapInterval:Float = 0;
    private var _tickInterval:Float = 0;
    private var _highValue:Float = 100;
    private var _lowValue:Float = 0;
    private var _labelMode:BSliderLabelMode = BSliderLabelMode.ALWAYS;
    private var _labelPrecision:Int = 0;
    private var _labelPlacement:BPlacement = BPlacement.TOP;
    
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BRangeSlider component instance.
	 * 
     * @param	orientation The orientation of the slider. Either horizontal or vertial 
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
     */
    public function new(orientation:BOrientation = BOrientation.HORIZONTAL, parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        _orientation = orientation;
        
        super(parent, x, y);
        initialize();
        //setSize(100, 12);
        draw();
    }
    
    
    //**************************************** HANDLERS *********************************************
    
    
    /**
	 * 
	 * @param	event
	 */
    private function mouseHandler(event:MouseEvent):Void
    {
        
        
        
    }  // end function mouseHandler  
    
    
    /**
	 * 
	 * @param	event
	 */
    private function onDragHighThumb(event:MouseEvent):Void
    {
        stage.addEventListener(MouseEvent.MOUSE_UP, onDropThumb);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlideHighThumb);
        
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            _highThumb.startDrag(false, new Rectangle(_lowThumb.x, 10, _width - _lowThumb.x, 0));
        }
        // show the labels if label mode is move
        else if (_orientation == BOrientation.VERTICAL) 
        {
            _highThumb.startDrag(false, new Rectangle(-10, 0, 0, _lowThumb.y));
        }
        
        
        
        if (_labelMode == BSliderLabelMode.MOVE) 
        {
            _lowLabel.visible = true;
            _highLabel.visible = true;
        }
    }  // end function onDragHighThumb  
    
    
    /**
	 * 
	 * @param	event
	 */
    private function onDragLowThumb(event:MouseEvent):Void
    {
        stage.addEventListener(MouseEvent.MOUSE_UP, onDropThumb);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlideLowThumb);
        
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            _lowThumb.startDrag(false, new Rectangle(0, 10, _highThumb.x, 0));
        }
        // show the labels if label mode is move
        else if (_orientation == BOrientation.VERTICAL) 
        {
            _lowThumb.startDrag(false, new Rectangle(-10, _highThumb.y, 0, _height - _highThumb.y));
        }
        
        
        
        if (_labelMode == BSliderLabelMode.MOVE) 
        {
            _lowLabel.visible = true;
            _highLabel.visible = true;
        }
    }  // end function onDragThumb  
    
    
    /**
	 * 
	 * @param	event
	 */
    private function onDropThumb(event:MouseEvent):Void
    {
        stage.removeEventListener(MouseEvent.MOUSE_UP, onDropThumb);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlideHighThumb);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlideLowThumb);
        stopDrag();
        
        // hide the labels if label mode is move
        if (_labelMode == BSliderLabelMode.MOVE) 
        {
            _lowLabel.visible = false;
            _highLabel.visible = false;
        }
		snap();
    }  // end function onSlideThumb  
    
    
    /**
	 * 
	 * @param	event
	 */
    private function onSlideHighThumb(event:MouseEvent):Void
    {
        var prevValue:Float = _highValue;
        
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            _highValue = _highThumb.x / width * (_maximum - _minimum) + _minimum;
        }
        else if (_orientation == BOrientation.VERTICAL) 
        {
            _highValue = (_height - _highThumb.y) / height * (_maximum - _minimum) + _minimum;
        }
        
        if (_highValue != prevValue) 
        {
            dispatchEvent(new Event(Event.CHANGE));
        }
        
        updateLabels();
        snap();
    }  // end function onSlideHighThumb  
    
    
    /**
	 * 
	 * @param	event
	 */
    private function onSlideLowThumb(event:MouseEvent):Void
    {
        var prevValue:Float = _lowValue;
        
        //
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            _lowValue = _lowThumb.x / width * (_maximum - _minimum) + _minimum;
        }
        else if (_orientation == BOrientation.VERTICAL) 
        {
            _lowValue = (_height - _lowThumb.y) / height * (_maximum - _minimum) + _minimum;
        }
        
        if (_lowValue != prevValue) 
        {
            dispatchEvent(new Event(Event.CHANGE));
        }
        
        updateLabels();
        snap();
    }  // end function onSlideLowThumb  
    
    
    //************************************* FUNCTIONS ******************************************
    
    
    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();
        
        // initialize the assets
        _highThumb = new BBaseButton(this);
        _lowThumb = new BBaseButton(this);
        _highThumb.setSkins(_highThumb.getSkin("upSkin"), _highThumb.getSkin("overSkin"), _highThumb.getSkin("downSkin"), _highThumb.getSkin("disabledSkin"));
        _lowThumb.setSkins(_lowThumb.getSkin("upSkin"), _lowThumb.getSkin("overSkin"), _lowThumb.getSkin("downSkin"), _lowThumb.getSkin("disabledSkin"));
        
        _sliderTrackSkin = new Sprite();
        _sliderTrackDisabledSkin = new Sprite();
        
        _tickSkin = new Sprite();
        
        _highLabel = new BLabel(this, 0, 0, Std.string(_highValue));
        _lowLabel = new BLabel(this, 0, 0, Std.string(_lowValue));
        _highLabel.autoSize = TextFieldAutoSize.LEFT;
        _lowLabel.autoSize = TextFieldAutoSize.LEFT;
        
        // add assets to respective containers
        addChild(_sliderTrackSkin);
        addChild(_sliderTrackDisabledSkin);
        addChild(_tickSkin);
        
        
        //
        buttonMode = true;
        useHandCursor = true;
        mouseChildren = true;
        
        
        // checking to see if the orientation property is set to horizontal or vertical, or neither
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            setSize(200, 20);
            _trackWidth = Std.int(_width);
            _trackHeight = 5;
            _labelPlacement = BPlacement.TOP;
        }
        // event handling
        //sliderTrackSkin.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        else if(_orientation == BOrientation.VERTICAL) 
        {
            setSize(20, 200);
            _trackWidth = 5;
            _trackHeight = Std.int(_height);
            _labelPlacement = BPlacement.RIGHT;
        }
        else 
        {
            setSize(200, 20);
            _orientation = BOrientation.HORIZONTAL;
            _trackWidth = Std.int(_width);
            _trackHeight = 20;
            _labelPlacement = BPlacement.TOP;
            //throw new Error("The BSlider.orientation property can only me 'horizontal' or 'vertical'. Use the BOrientation class for set this property.");
        } // end else
        
		
		// maybe the slidertrack down handler can be added, but takes into consideration the last thumb pressed/dragged
		// event handling
		//_sliderTrackSkin.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        _highThumb.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        _highThumb.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
        _highThumb.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
        _highThumb.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
        
        _highThumb.addEventListener(MouseEvent.MOUSE_DOWN, onDragHighThumb);
        
        _lowThumb.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        _lowThumb.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
        _lowThumb.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
        _lowThumb.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
        
        _lowThumb.addEventListener(MouseEvent.MOUSE_DOWN, onDragLowThumb);
    }  // end function initialize  
    
    
    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        super.draw();
        
        // checking to see if the orientation property is set to horizontal or vertical, or neither
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            addChild(_highThumb);
            _highThumb.scaleX = 1;
            _highThumb.rotation = 0;
            //highThumb.x = _width;
            _highThumb.x = Math.round(_width / (_maximum - _minimum)) * _highValue;
            _highThumb.y = 10;
            
            _lowThumb.scaleX = 1;
            _lowThumb.rotation = 0;
            //lowThumb.x = 0;
            _lowThumb.x = Math.round(_width / (_maximum - _minimum)) * _lowValue;
            _lowThumb.y = 10;
            
            _trackWidth = Std.int(_width);
            _trackHeight = 2;
        }
        // redraws the tick marks
        //tickInterval = _tickInterval;
        else if (_orientation == BOrientation.VERTICAL) 
        {
            addChild(_lowThumb);
            _highThumb.scaleX = -1;
            _highThumb.rotation = 90;
            _highThumb.x = -10;
            _highThumb.y = 0;
            _highThumb.y = -Math.round(_height / (_maximum - _minimum)) * _highValue + _height;
            
            _lowThumb.scaleX = -1;
            _lowThumb.rotation = 90;
            _lowThumb.x = -10;
            _lowThumb.y = _height;
            _lowThumb.y = -Math.round(_height / (_maximum - _minimum)) * _lowValue + _height;
            
            _trackWidth = 2;
            _trackHeight = Std.int(_height);
        }
        
        
        
        
        
        
        var thumbWidth:Int = 10;
        var thumbHeight:Int = 16;
        
        _sliderTrackSkin.graphics.clear();
        _sliderTrackSkin.graphics.beginFill(0x999999, 1);
        _sliderTrackSkin.graphics.drawRect(0, 0, _trackWidth, _trackHeight);
        _sliderTrackSkin.graphics.beginFill(0x000000, 0);
        _sliderTrackSkin.graphics.drawRect(-_width + _trackWidth, 0, _width, _height);
        _sliderTrackSkin.graphics.endFill();
        
        _sliderTrackDisabledSkin.graphics.clear();
        _sliderTrackDisabledSkin.graphics.beginFill(0x666666, 1);
        _sliderTrackDisabledSkin.graphics.drawRect(0, 0, _trackWidth, _trackHeight);
        _sliderTrackDisabledSkin.graphics.endFill();
        _sliderTrackDisabledSkin.visible = false;
        
        
        // draw high thumb
        cast((_highThumb.getSkin("upSkin")), Sprite).graphics.clear();
        cast((_highThumb.getSkin("upSkin")), Sprite).graphics.beginFill(0x999999, 1);
        cast((_highThumb.getSkin("upSkin")), Sprite).graphics.drawCircle(10, 0, 10);
        cast((_highThumb.getSkin("upSkin")), Sprite).graphics.endFill();
        cast((_highThumb.getSkin("upSkin")), Sprite).graphics.beginFill(0x999999, 1);  // make a pointy arrow  
        cast((_highThumb.getSkin("upSkin")), Sprite).graphics.moveTo(0, 0);
        cast((_highThumb.getSkin("upSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_highThumb.getSkin("upSkin")), Sprite).graphics.lineTo(20, 0);
        cast((_highThumb.getSkin("upSkin")), Sprite).graphics.endFill();
        
        cast((_highThumb.getSkin("overSkin")), Sprite).graphics.clear();
        cast((_highThumb.getSkin("overSkin")), Sprite).graphics.beginFill(0xFFFFFF, 1);
        cast((_highThumb.getSkin("overSkin")), Sprite).graphics.drawCircle(10, 0, 10);
        cast((_highThumb.getSkin("overSkin")), Sprite).graphics.endFill();
        cast((_highThumb.getSkin("overSkin")), Sprite).graphics.beginFill(0xFFFFFF, 1);  // make a pointy arrow  
        cast((_highThumb.getSkin("overSkin")), Sprite).graphics.moveTo(0, 0);
        cast((_highThumb.getSkin("overSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_highThumb.getSkin("overSkin")), Sprite).graphics.lineTo(20, 0);
        cast((_highThumb.getSkin("overSkin")), Sprite).graphics.endFill();
        
        cast((_highThumb.getSkin("downSkin")), Sprite).graphics.clear();
        cast((_highThumb.getSkin("downSkin")), Sprite).graphics.beginFill(0x0099CC, 1);
        cast((_highThumb.getSkin("downSkin")), Sprite).graphics.drawCircle(10, 0, 10);
        cast((_highThumb.getSkin("downSkin")), Sprite).graphics.endFill();
        cast((_highThumb.getSkin("downSkin")), Sprite).graphics.beginFill(0x0099CC, 1);  // make a pointy arrow  
        cast((_highThumb.getSkin("downSkin")), Sprite).graphics.moveTo(0, 0);
        cast((_highThumb.getSkin("downSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_highThumb.getSkin("downSkin")), Sprite).graphics.lineTo(20, 0);
        cast((_highThumb.getSkin("downSkin")), Sprite).graphics.endFill();
        cast((_highThumb.getSkin("downSkin")), Sprite).scaleX = cast((_highThumb.getSkin("downSkin")), Sprite).scaleY = 1.5;
        
        cast((_highThumb.getSkin("disabledSkin")), Sprite).graphics.clear();
        cast((_highThumb.getSkin("disabledSkin")), Sprite).graphics.beginFill(0x333333, 1);
        cast((_highThumb.getSkin("disabledSkin")), Sprite).graphics.drawCircle(10, 0, 10);
        cast((_highThumb.getSkin("disabledSkin")), Sprite).graphics.endFill();
        cast((_highThumb.getSkin("disabledSkin")), Sprite).graphics.beginFill(0x333333, 1);  // make a pointy arrow  
        cast((_highThumb.getSkin("disabledSkin")), Sprite).graphics.moveTo(0, 0);
        cast((_highThumb.getSkin("disabledSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_highThumb.getSkin("disabledSkin")), Sprite).graphics.lineTo(20, 0);
        cast((_highThumb.getSkin("disabledSkin")), Sprite).graphics.endFill();
        
        
        // draw low thumb
        cast((_lowThumb.getSkin("upSkin")), Sprite).graphics.clear();
        cast((_lowThumb.getSkin("upSkin")), Sprite).graphics.beginFill(0x999999, 1);
        cast((_lowThumb.getSkin("upSkin")), Sprite).graphics.drawCircle(-10, 0, 10);
        cast((_lowThumb.getSkin("upSkin")), Sprite).graphics.endFill();
        cast((_lowThumb.getSkin("upSkin")), Sprite).graphics.beginFill(0x999999, 1);
        cast((_lowThumb.getSkin("upSkin")), Sprite).graphics.moveTo(0, 0);
        cast((_lowThumb.getSkin("upSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_lowThumb.getSkin("upSkin")), Sprite).graphics.lineTo(-20, 0);
        cast((_lowThumb.getSkin("upSkin")), Sprite).graphics.endFill();
        
        cast((_lowThumb.getSkin("overSkin")), Sprite).graphics.clear();
        cast((_lowThumb.getSkin("overSkin")), Sprite).graphics.beginFill(0xFFFFFF, 1);
        cast((_lowThumb.getSkin("overSkin")), Sprite).graphics.drawCircle(-10, 0, 10);
        cast((_lowThumb.getSkin("overSkin")), Sprite).graphics.endFill();
        cast((_lowThumb.getSkin("overSkin")), Sprite).graphics.beginFill(0xFFFFFF, 1);
        cast((_lowThumb.getSkin("overSkin")), Sprite).graphics.moveTo(0, 0);
        cast((_lowThumb.getSkin("overSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_lowThumb.getSkin("overSkin")), Sprite).graphics.lineTo(-20, 0);
        cast((_lowThumb.getSkin("overSkin")), Sprite).graphics.endFill();
        
        cast((_lowThumb.getSkin("downSkin")), Sprite).graphics.clear();
        cast((_lowThumb.getSkin("downSkin")), Sprite).graphics.beginFill(0x0099CC, 1);
        cast((_lowThumb.getSkin("downSkin")), Sprite).graphics.drawCircle(-10, 0, 10);
        cast((_lowThumb.getSkin("downSkin")), Sprite).graphics.endFill();
        cast((_lowThumb.getSkin("downSkin")), Sprite).graphics.beginFill(0x0099CC, 1);
        cast((_lowThumb.getSkin("downSkin")), Sprite).graphics.moveTo(0, 0);
        cast((_lowThumb.getSkin("downSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_lowThumb.getSkin("downSkin")), Sprite).graphics.lineTo(-20, 0);
        cast((_lowThumb.getSkin("downSkin")), Sprite).graphics.endFill();
        cast((_lowThumb.getSkin("downSkin")), Sprite).scaleX = cast((_lowThumb.getSkin("downSkin")), Sprite).scaleY = 1.5;
        
        cast((_lowThumb.getSkin("disabledSkin")), Sprite).graphics.clear();
        cast((_lowThumb.getSkin("disabledSkin")), Sprite).graphics.beginFill(0x333333, 1);
        cast((_lowThumb.getSkin("disabledSkin")), Sprite).graphics.drawCircle(-10, 0, 10);
        cast((_lowThumb.getSkin("disabledSkin")), Sprite).graphics.endFill();
        cast((_lowThumb.getSkin("disabledSkin")), Sprite).graphics.beginFill(0x333333, 1);
        cast((_lowThumb.getSkin("disabledSkin")), Sprite).graphics.moveTo(0, 0);
        cast((_lowThumb.getSkin("disabledSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_lowThumb.getSkin("disabledSkin")), Sprite).graphics.lineTo(-20, 0);
        cast((_lowThumb.getSkin("disabledSkin")), Sprite).graphics.endFill();
        
        // update the labels
        updateLabels();
    }  // end function draw  
    
    
    /**
	 * 
	 */
    private function snap():Void
    {
        if (_snapInterval <= 0) 
        {
            return;
        }
        else 
        {
            var pow:Float = Math.pow(10, 6);
            var snap:Float = _snapInterval * pow;
            
            var rounded:Float = Math.round(_highValue * pow);
            var snapped:Float = Math.round(rounded / snap) * snap;
            var val:Float = snapped / pow;
            _highValue = Math.max(minimum, Math.min(maximum, val));
            
            
            rounded = Math.round(_lowValue * pow);
            snapped = Math.round(rounded / snap) * snap;
            val = snapped / pow;
            _lowValue = Math.max(minimum, Math.min(maximum, val));
        }
    }  // end function snap  
    
    
    /**
	 * 
	 */
    private function updateLabels():Void
    {
        //lowLabel.text = _lowValue.toPrecision(3);  //getLabelForValue(lowValue);  
        //highLabel.text = _highValue.toPrecision(3);  //getLabelForValue(highValue);  
		_lowLabel.text = _lowValue + "";
        _highLabel.text = _highValue + "";
        
        if (_orientation == BOrientation.VERTICAL) 
        {
            _lowLabel.y = _lowThumb.y - _lowLabel.height / 2;
            _highLabel.y = _highThumb.y - _highLabel.height / 2;
            
            if (_labelPlacement == BPlacement.LEFT) 
            {
                _lowLabel.x = -_lowLabel.width - 5;
                _highLabel.x = -_highLabel.width - 5;
            }
            else 
            {
                _lowLabel.x = _width - 5;
                _highLabel.x = _width - 5;
            }
        }
        else if(_orientation == BOrientation.HORIZONTAL) 
        {
            _lowLabel.x = _lowThumb.x - _lowLabel.width / 2;
            _highLabel.x = _highThumb.x - _highLabel.width / 2;
            
            if (_labelPlacement == BPlacement.BOTTOM) 
            {
                _lowLabel.y = _height + 2;
                _highLabel.y = _height + 2;
            }
            else 
            {
                _lowLabel.y = -_lowLabel.height - 10;
                _highLabel.y = -_highLabel.height - 10;
            }
        }
    }  // end function updateLabels  
    
    
    /**
	 * 
	 */
    private function positionThumb():Void
    {
        
        
    }  // end function positionThumb  
    
    
    //***************************************** SET AND GET *****************************************
    
    
    private function get_liveDragging():Bool
    {
        return _liveDragging;
    }
    private function set_liveDragging(value:Bool):Bool
    {
        _liveDragging = value;
        return value;
    }
    
    
    private function get_maximum():Float
    {
        return _maximum;
    }
    private function set_maximum(value:Float):Float
    {
        _maximum = value;
        return value;
    }
    
    
    private function get_minimum():Float
    {
        return _minimum;
    }
    private function set_minimum(value:Float):Float
    {
        _minimum = value;
        return value;
    }
    
    
    private function get_orientation():BOrientation
    {
        return _orientation;
    }
    private function set_orientation(value:BOrientation):BOrientation
    {
        var prevOrientation:BOrientation = _orientation;
        var prevWidth:Float = _width;
        var prevHeight:Float = _height;
        
        _orientation = value;
        
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            //setSize(_width, _height);
            prevOrientation == (BOrientation.HORIZONTAL) ? setSize(_width, _height) : setSize(_height, _width);
            _trackWidth = Std.int(_width);
            _trackHeight = 2;
        }
        else if(_orientation == BOrientation.VERTICAL) 
        {
            //setSize(_height, _width);
            prevOrientation == (BOrientation.VERTICAL) ? setSize(_width, _height) : setSize(_height, _width);
            _trackWidth = 2;
            _trackHeight = Std.int(_height);
        }
        else 
        {
            setSize(_width, _height);
            _orientation = BOrientation.HORIZONTAL;
            _trackWidth = Std.int(_width);
            _trackHeight = 2;
            //throw new Error("The BSlider.orientation property can only me 'horizontal' or 'vertical'. Use the BOrientation class for set this property.");
        }
        
        invalidate();
        return value;
    }
    
    
    private function get_snapInterval():Float
    {
        return _snapInterval;
    }
    private function set_snapInterval(value:Float):Float
    {
        _snapInterval = value;
        return value;
    }
    
    
    private function get_tickInterval():Float
    {
        return _tickInterval;
    }
    private function set_tickInterval(value:Float):Float
    {
        _tickInterval = value;
        
        _tickSkin.graphics.clear();
        
        if (value != 0) 
        {
            var ticks:Int = Math.floor((_maximum - _minimum) / value);
            
            for (i in 0...ticks + 1){
                _tickSkin.graphics.beginFill(0x999999, 1);
                
                if (_orientation == BOrientation.HORIZONTAL) 
                {
                    _tickSkin.graphics.drawRect((_width / (_maximum - _minimum) * _tickInterval * i) - 0.5, -4, 1, 3);
                }
                else if (_orientation == BOrientation.VERTICAL) 
                {
                    _tickSkin.graphics.drawRect(6, (_height / (_maximum - _minimum) * _tickInterval * i) - 0.5, 3, 1);
                }
                _tickSkin.graphics.endFill();
            }  // end for  
        }
        return value;
    }
    
    
    private function get_highValue():Float
    {
        return _highValue;
    }
    private function set_highValue(value:Float):Float
    {
        _highValue = value;
        return value;
    }
    
    
    private function get_lowValue():Float
    {
        return _lowValue;
    }
    private function set_lowValue(value:Float):Float
    {
        _lowValue = value;
        return value;
    }
    
    
    private function get_labelMode():BSliderLabelMode
    {
        return _labelMode;
    }
    private function set_labelMode(value:BSliderLabelMode):BSliderLabelMode
    {
        _labelMode = value;
        
        if (value == BSliderLabelMode.ALWAYS) 
        {
            _lowLabel.visible = true;
            _highLabel.visible = true;
        }
        else if (value == BSliderLabelMode.NEVER || value == BSliderLabelMode.MOVE) 
        {
            _lowLabel.visible = false;
            _highLabel.visible = false;
        }
        return value;
    }
    
    
    private function get_labelPrecision():Int
    {
        return _labelPrecision;
    }
    private function set_labelPrecision(value:Int):Int
    {
        _labelPrecision = value;
        return value;
    }
    
    
    private function get_labelPlacement():BPlacement
    {
        return _labelPlacement;
    }
    private function set_labelPlacement(value:BPlacement):BPlacement
    {
        _labelPlacement = value;
        return value;
    }
}

