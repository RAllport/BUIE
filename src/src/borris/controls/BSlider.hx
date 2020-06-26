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

import motion.Actuate;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextFieldAutoSize;


// TODO/imporovemtns:
// TODO finish live dragging
// TODO finish position thumbs
// TODO add labels
/**
 * Decription: The Slider component lets users select a value by moving a slider thumb between the end points of the slider track. The current value of the Slider component is determined by the relative location of the thumb between the end points of the slider, corresponding to the minimum and maximum values of the Slider component.
 *
 * @author Rohaan Allport
 * @creation-date 27/04/2015 (dd/mm/yyyy)
 */
class BSlider extends BUIComponent
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
	 * Gets or sets the current value of the BSlider component. 
	 * This value is determined by the position of the slider thumb between the minimum and maximum values.
	 */
	public var value(get, set):Float;
    
	/**
	 * 
	 */
	public var labelMode(never, set):BSliderLabelMode;
    
	/**
	 * 
	 */
	public var labelPrecision(get, set):Int;
    
	/**
	 * 
	 */
	public var labelPlacement(get, set):BPlacement;

	
    // assets
    private var _thumb:BBaseButton;
    
    private var _sliderTrackSkin:Sprite;
    private var _sliderTrackDisabledSkin:Sprite;
    
    private var _tickSkin:Sprite;
    
    private var _label:BLabel;
    
    
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
    private var _value:Float = 0;
    private var _labelMode:BSliderLabelMode = BSliderLabelMode.ALWAYS;
    private var _labelPrecision:Int = 0;
    private var _labelPlacement:BPlacement = BPlacement.TOP;
    
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BSlider component instance.
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
        // for when the user clicks the track
        // bring the thumb to the position clicked
        if (event.currentTarget == _sliderTrackSkin) 
        {
            if (_orientation == BOrientation.HORIZONTAL) 
            {
                Actuate.tween(_thumb, 0.2, {x: mouseX});
                _value = mouseX / width * (_maximum - _minimum) + _minimum;
            }
            else if(_orientation == BOrientation.VERTICAL) 
            {
                Actuate.tween(_thumb, 0.2, {y: mouseY});
                _value = (_height - mouseY) / height * (_maximum - _minimum) + _minimum;
            }
            snap();
            //trace("Value: " + _value);
            dispatchEvent(new Event(Event.CHANGE));
        } // end if
        
        // for snapping the thumb  
        if (_snapInterval != 0) 
        {
            if (_orientation == BOrientation.HORIZONTAL) 
            {
                _thumb.x = Math.round(_width / (_maximum - _minimum)) * _value;
            }
            else if (_orientation == BOrientation.VERTICAL) 
            {
                _thumb.y = -Math.round(_height / (_maximum - _minimum)) * _value + _height;
            }
        }
        
        updateLabel();
    }  // end function mouseHandler  
    
    
    /**
	 * 
	 * @param	event
	 */
    private function onDragThumb(event:MouseEvent):Void
    {
        stage.addEventListener(MouseEvent.MOUSE_UP, onDropThumb);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlideThumb);
        
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            _thumb.startDrag(false, new Rectangle(0, 10, _width, 0));
        }
        // show the label if label mode is move
        else if (_orientation == BOrientation.VERTICAL) 
        {
            _thumb.startDrag(false, new Rectangle(-10, 0, 0, _height));
        }
        
        
        
        if (_labelMode == BSliderLabelMode.MOVE) 
        {
            _label.visible = true;
        }  //trace("Value: " + _value);  
    }  // end function onDragThumb  
    
    
    /**
	 * 
	 * @param	event
	 */
    private function onDropThumb(event:MouseEvent):Void
    {
        stage.removeEventListener(MouseEvent.MOUSE_UP, onDropThumb);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlideThumb);
        stopDrag();
        
        // hide the label if label mode is move
        if (_labelMode == BSliderLabelMode.MOVE) 
        {
            _label.visible = false;
        }
		snap();
    }  // end function onSlideThumb  
    
    
    /**
	 * 
	 * @param	event
	 */
    private function onSlideThumb(event:MouseEvent):Void
    {
        var prevValue:Float = _value;
        
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            _value = _thumb.x / width * (_maximum - _minimum) + _minimum;
        }
        else if (_orientation == BOrientation.VERTICAL) 
        {
            _value = (_height - _thumb.y) / height * (_maximum - _minimum) + _minimum;
        }
        
        if (_value != prevValue) 
        {
            dispatchEvent(new Event(Event.CHANGE));
        }
        
        updateLabel();
        //snap();
    }  // end function onSlideThumb  
    
    
    
    
    
    //************************************* FUNCTIONS ******************************************
    
    
    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();
        
		// initialize the assets
        _thumb = new BBaseButton(this);
        _thumb.setSkins(_thumb.getSkin("upSkin"), _thumb.getSkin("overSkin"), _thumb.getSkin("downSkin"), _thumb.getSkin("disabledSkin"));
        //_thumb.focusEnabled = false;
		
        _sliderTrackSkin = new Sprite();
        _sliderTrackDisabledSkin = new Sprite();
        
        _tickSkin = new Sprite();
        
        _label = new BLabel(this, 0, 0, Std.string(_value));
        _label.autoSize = TextFieldAutoSize.LEFT;
        
        // add assets to respective containers
        addChild(_sliderTrackSkin);
        addChild(_sliderTrackDisabledSkin);
        addChild(_tickSkin);
        addChild(_thumb);
        
        
        //
        buttonMode = true;
        useHandCursor = true;
        mouseChildren = true;
        
        
        // checking to see if the orientation property is set to horizontal or vertical, or neither
        if (_orientation == BOrientation.HORIZONTAL) 
        {
            setSize(200, 20);
            _trackWidth = Std.int(_width);
            _trackHeight = 2;
        }
        // event handling
        else if(_orientation == BOrientation.VERTICAL) 
        {
            setSize(20, 200);
            _trackWidth = 2;
            _trackHeight = Std.int(_height);
        }
        else 
        {
            setSize(200, 20);
            _orientation = BOrientation.HORIZONTAL;
            _trackWidth = Std.int(_width);
            _trackHeight = 2;
            //throw new Error("The BSlider.orientation property can only me 'horizontal' or 'vertical'. Use the BOrientation class for set this property.");
        }
        
        
        
        
        _sliderTrackSkin.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        _thumb.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        _thumb.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
        _thumb.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
        _thumb.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
        
        _thumb.addEventListener(MouseEvent.MOUSE_DOWN, onDragThumb);
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
            _thumb.rotation = 0;
            _thumb.x = Math.round(_width / (_maximum - _minimum)) * _value;
            _thumb.y = 10;
            
            _trackWidth = Std.int(_width);
            _trackHeight = 2;
        }
        // redraws the tick marks
        else if (_orientation == BOrientation.VERTICAL) 
        {
            _thumb.rotation = 90;
            _thumb.x = -10;
            _thumb.y = -Math.round(_height / (_maximum - _minimum)) * _value + _height;
            
            _trackWidth = 2;
            _trackHeight = Std.int(_height);
        }
        
        
        tickInterval = _tickInterval;
        
        var thumbWidth:Int = 10;
        var thumbHeight:Int = 12;
        
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
        
        cast((_thumb.getSkin("upSkin")), Sprite).graphics.clear();
        cast((_thumb.getSkin("upSkin")), Sprite).graphics.beginFill(0x999999, 1);
        cast((_thumb.getSkin("upSkin")), Sprite).graphics.drawCircle(0, 0, 10);
        cast((_thumb.getSkin("upSkin")), Sprite).graphics.endFill();
        cast((_thumb.getSkin("upSkin")), Sprite).graphics.beginFill(0x999999, 1);  // make a pointy arrow  
        cast((_thumb.getSkin("upSkin")), Sprite).graphics.moveTo(-10, 0);
        cast((_thumb.getSkin("upSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_thumb.getSkin("upSkin")), Sprite).graphics.lineTo(10, 0);
        //Sprite(thumb.getSkin("upSkin")).graphics.drawRoundRect( -4, -13, 8, 26, 8, 8);
        cast((_thumb.getSkin("upSkin")), Sprite).graphics.endFill();
        
        cast((_thumb.getSkin("overSkin")), Sprite).graphics.clear();
        cast((_thumb.getSkin("overSkin")), Sprite).graphics.beginFill(0xFFFFFF, 1);
        cast((_thumb.getSkin("overSkin")), Sprite).graphics.drawCircle(0, 0, 10);
        cast((_thumb.getSkin("overSkin")), Sprite).graphics.beginFill(0xFFFFFF, 1);  // make a pointy arrow  
        cast((_thumb.getSkin("overSkin")), Sprite).graphics.moveTo(-10, 0);
        cast((_thumb.getSkin("overSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_thumb.getSkin("overSkin")), Sprite).graphics.lineTo(10, 0);
        cast((_thumb.getSkin("overSkin")), Sprite).graphics.endFill();
        
        cast((_thumb.getSkin("downSkin")), Sprite).graphics.clear();
        cast((_thumb.getSkin("downSkin")), Sprite).graphics.beginFill(0x0099CC, 1);
        cast((_thumb.getSkin("downSkin")), Sprite).graphics.drawCircle(0, 0, 10);
        cast((_thumb.getSkin("downSkin")), Sprite).graphics.beginFill(0x0099CC, 1);  // make a pointy arrow  
        cast((_thumb.getSkin("downSkin")), Sprite).graphics.moveTo(-10, 0);
        cast((_thumb.getSkin("downSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_thumb.getSkin("downSkin")), Sprite).graphics.lineTo(10, 0);
        cast((_thumb.getSkin("downSkin")), Sprite).graphics.endFill();
        cast((_thumb.getSkin("downSkin")), Sprite).scaleX = cast((_thumb.getSkin("downSkin")), Sprite).scaleY = 1.5;
        
        cast((_thumb.getSkin("disabledSkin")), Sprite).graphics.clear();
        cast((_thumb.getSkin("disabledSkin")), Sprite).graphics.beginFill(0x333333, 1);
        cast((_thumb.getSkin("disabledSkin")), Sprite).graphics.drawCircle(0, 0, 10);
        cast((_thumb.getSkin("disabledSkin")), Sprite).graphics.beginFill(0x333333, 1);  // make a pointy arrow  
        cast((_thumb.getSkin("disabledSkin")), Sprite).graphics.moveTo(-10, 0);
        cast((_thumb.getSkin("disabledSkin")), Sprite).graphics.lineTo(0, -15);
        cast((_thumb.getSkin("disabledSkin")), Sprite).graphics.lineTo(10, 0);
        cast((_thumb.getSkin("disabledSkin")), Sprite).graphics.endFill();
        
        // update the label
        updateLabel();
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
			
            var rounded:Float = Math.round(_value * pow);
            var snapped:Float = Math.round(rounded / snap) * snap;
            var val:Float = snapped / pow;
            _value = Math.max(minimum, Math.min(maximum, val));
        }
    }  // end function snap  
    
    
    /**
	 * 
	 */
    private function updateLabel():Void
    {
        //label.text = _value.toPrecision(3);  //getLabelForValue(lowValue);  
        _label.text = _value + "";
        
        if (_orientation == BOrientation.VERTICAL) 
        {
            _label.y = _thumb.y - _label.height / 2;
            
            if (_labelPlacement == BPlacement.LEFT) 
            {
                _label.x = -_label.width - 5;
            }
            else 
            {
                _label.x = _width - 5;
            }
        }
        else if(_orientation == BOrientation.HORIZONTAL) 
        {
            _label.x = _thumb.x - _label.width / 2;
            
            if (_labelPlacement == BPlacement.BOTTOM) 
            {
                _label.y = _height + 2;
            }
            else 
            {
                _label.y = -_label.height - 10;
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
            _trackHeight = 5;
        }
        else if(_orientation == BOrientation.VERTICAL) 
        {
            //setSize(_height, _width);
            prevOrientation == (BOrientation.VERTICAL) ? setSize(_width, _height) : setSize(_height, _width);
            _trackWidth = 5;
            _trackHeight = Std.int(_height);
        }
        else 
        {
            setSize(_width, _height);
            _orientation = BOrientation.HORIZONTAL;
            _trackWidth = Std.int(_width);
            _trackHeight = 5;
            //throw new Error("The BSlider.orientation property can only me 'horizontal' or 'vertical'. Use the BOrientation class to set this property.");
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
                _tickSkin.graphics.beginFill(0xFFFFFF, 1);
                
                if (_orientation == BOrientation.HORIZONTAL) 
                {
                    _tickSkin.graphics.drawRect((_width / (_maximum - _minimum) * _tickInterval * i) - 0.5, -4, 1, 3);
                }
                else if (_orientation == BOrientation.VERTICAL) 
                {
                    _tickSkin.graphics.drawRect(3, (_height / (_maximum - _minimum) * _tickInterval * i) - 0.5, 3, 1);
                }
                _tickSkin.graphics.endFill();
            }  // end for  
        }
        return value;
    }
    
    
    private function get_value():Float
    {
        return _value;
    }
    private function set_value(value:Float):Float
    {
        _value = value;
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
            _label.visible = true;
        }
        else if (value == BSliderLabelMode.NEVER || value == BSliderLabelMode.MOVE) 
        {
            _label.visible = false;
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

