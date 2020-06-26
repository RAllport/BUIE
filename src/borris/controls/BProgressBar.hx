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

import borris.display.BProgressBarMode;

import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

/**
 * The BProgressBar component displays the progress of content that is being loaded.
 * The ProgressBar is typically used to display the status of images, as well as portions of applications, while they are loading.
 * The loading process can be determinate or indeterminate.
 * A determinate progress bar is a linear representation of the progress of a task over time and is used when the amount of content to load is known.
 * An indeterminate progress bar has a striped fill and a loading source of unknown size.
 *
 * @author Rohaan Allport
 * @creation-date 19/10/2014 (dd/mm/yyyy)
 */
class BProgressBar extends BUIComponent
{
    /**
     * 
     */
	public var color(get, set):Int;
    
	
	/**
	 * Indicates the fill direction for the progress bar.	//BProgressBarDirection.RIGHT  
	 */
	public var direction(get, set):String;
    
	/**
	 * Gets or sets the maximum value for the progress bar when the ProgressBar.mode property is set to BBProgressBarMode.MANUAL.  
	 */
	public var maximum(get, set):Float;
    
	/**
	 * Gets or sets the minimum value for the progress bar when the ProgressBar.mode property is set to BBProgressBarMode.MANUAL.  
	 */
	public var minimum(get, set):Float;
    
	/**
	 * Gets or sets the method to be used to update the progress bar.
	 */
	public var mode(get, set):String;
    
	/**
	 * [read-only] Gets a number between 0 and 100 that indicates the percentage of the content has already loaded. 
	 */
	public var percentComplete(get, never):Float;
    
	/**
	 * Gets or sets a reference to the content that is being loaded and for which the ProgressBar is measuring the progress of the load operation.  
	 */
	public var source(get, set):Dynamic;
    
	/**
	 * 
	 */
	public var value(get, set):Float;
	
	
    // contants
    
    
    // assets
    // text assest
    private var enabledTF:TextFormat;
    private var disabledTF:TextFormat;
    private var progressLabelText:TextField;
    //protected var estimatedTimeLabelText:TextField;
    //protected var  transferRateLabelText:TextField;
    
    // skin assets
	// TODO use only 1 skin.
    private var _enabledSkin:Sprite;  //  
    //protected var _disabledSkin:Sprite;			//
    
    private var _enabledLeftSkin:Sprite;  //  
    private var _enabledCenterSkin:Sprite;  //  
    private var _enabledRightSkin:Sprite;  //  
    
    //protected var _disabledLeftSkin:Sprite;		//
    //protected var _disabledCenterSkin:Sprite;	//
    //protected var _disabledRightSkin:Sprite;		//
    
    private var _bar:Shape;  //  
    //protected var mk:Shape;						//
    
    
    // other
    
    
    // set and get
    private var _color:Int = 0x0066FF;
    private var _direction:String = "right";
    private var _maximum:Float;
    private var _minimum:Float;
    private var _mode:String;
    private var _percentComplete:Float; 
    private var _source:Dynamic;
    private var _value:Float;  
    
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BProgressBar component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x position to place this component.
     * @param	y The y position to place this component.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        super(parent, x, y);
        _mode = BProgressBarMode.EVENT;
        _maximum = 0;
        _minimum = 0;
        _percentComplete = 0;
        _value = 0;
        
        // initialize asset variables
        enabledTF = new TextFormat("Calibri", 14, 0xCCCCCC, false);
        disabledTF = new TextFormat("Calibri", 14, 0x000000, false);
        
        progressLabelText = new TextField();
        //progressLabelText.text = "Progress Label";
        progressLabelText.type = TextFieldType.DYNAMIC;
        progressLabelText.selectable = false;
        progressLabelText.width = 100;
        progressLabelText.height = 20;
        progressLabelText.setTextFormat(enabledTF);
        progressLabelText.defaultTextFormat = enabledTF;
        progressLabelText.mouseEnabled = false;
        //progressLabelText.autoSize = TextFieldAutoSize.LEFT;
        progressLabelText.antiAliasType = AntiAliasType.ADVANCED;
        
        
        _enabledSkin = new Sprite();
        _enabledSkin.mouseEnabled = false;
        
        _enabledLeftSkin = left_mc;
        _enabledCenterSkin = center_mc;
        _enabledRightSkin = right_mc;
        
        _bar = new Shape();
        _bar.alpha = 1;
        //bar.graphics.beginFill(_color, 1);
        _bar.graphics.drawRoundRect(0, 0, 100, 22, 22, 22);
        _bar.graphics.endFill();
        _bar.x = 0;
        _bar.y = 20;
        
        
        // add assets to stage
        addChild(_bar);
        addChild(progressLabelText);
        addChild(_enabledSkin);
        
        _enabledSkin.addChild(_enabledLeftSkin);
        _enabledSkin.addChild(_enabledCenterSkin);
        _enabledSkin.addChild(_enabledRightSkin);
        
        
        //
        this.width = 300;
        this.color = 0x0066ff;
        //this.update();
        draw();
    }
    
    
	//**************************************** HANDLERS *********************************************
	
	
    /**
     * 
     * @param	event
     */
    private function enterFrameHandler(event:Event):Void
    {
        if (_source == null) 
            return;
        
        setProgress(_source.bytesLoaded, _source.bytesTotal, true);
        
        if (_value == _maximum && _maximum > 0) 
        {
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }  // end function enterFrameHandler  
    
    
    /**
     * 
     * @param	event
     */
    private function progressHandler(event:ProgressEvent):Void
    {
        var _percentComplete:Float = Math.round(event.bytesLoaded / event.bytesTotal) * 100;
        setProgress(event.bytesLoaded, event.bytesTotal, true);
        trace("BProgressBar | " + _percentComplete);
    }  // end function progressHandler  
    
    
	/**
	 * 
	 * @param	event
	 */
    private function onCompleteHandler(event:Event):Void
    {
        setProgress(_maximum, _maximum, true);
        dispatchEvent(event);
    }  // end function onCompleteHandle  
    
	
	//**************************************** FUNCTIONS ********************************************
    
    
    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        progressLabelText.x = 0;
        progressLabelText.y = 22;
        //progressLabelText.text = "Progress Label";
        
        _enabledLeftSkin.x = 0;
        _enabledLeftSkin.y = 0;
        
        _enabledCenterSkin.x = _enabledLeftSkin.x + _enabledLeftSkin.width;
        _enabledCenterSkin.y = 0;
        _enabledCenterSkin.width = _width - _enabledLeftSkin.width - _enabledRightSkin.width;
        
        _enabledRightSkin.x = _enabledCenterSkin.x + _enabledCenterSkin.width;
        _enabledRightSkin.y = 0;
        
        _bar.x = 0;
        _bar.y = 0;
        
        update();
    }  // end function draw  
    
    
    /**
	 * Resets the progress bar for a new load operation.
	 */
    public function reset():Void
    {
        setProgress(0, 0);
        var tempScource:Dynamic = _source;
        _source = null;
        source = tempScource;
    }  // end function reset  
    
    
    /**
	 * Sets the state of the bar to reflect the amount of progress made when using manual mode.
	 * 
	 * @param	value
	 * @param	maximum
	 * @param	dispatchEvent
	 */
    private function setProgress(value:Float, maximum:Float, dispatchEvent:Bool = false):Void
    {
        if (value == _value && maximum == _maximum) 
        {
            return;
        }
        
        _value = value;
        _maximum = maximum;
        
        if (_value != _percentComplete && dispatchEvent) 
        {
            this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _value, _maximum));
            _percentComplete = _value;
        }
        
        update();
    }  // end function setProgress  
    
    
    /**
	 * update the bar, and text, and animations of any.
	 */
    private function update():Void
    {
        progressLabelText.text = this.percentComplete + "%";
        updateBar();
    }  // end function update  
    
    
    /**
	 * update the bar only
	 */
    private function updateBar():Void
    {
        //var barWidth:Number = _value / _maximum;
        var barWidth:Float = (_width / 100) * percentComplete;
        
        _bar.graphics.clear();
        _bar.graphics.beginFill(_color, 1);
        _bar.graphics.drawRoundRect(0, 0, barWidth, 22, 22, 22);
        _bar.graphics.endFill();
    }  // end function update  
    
    
    //***************************************** SET AND GET *****************************************
    
    private function get_color():Int
    {
        return _color;
    }
    private function set_color(value:Int):Int
    {
        _color = value;
        update();
        return value;
    }
    
    
    private function get_direction():String
    {
        return _direction;
    }
    private function set_direction(value:String):String
    {
        
        
        return value;
    }
    
    
    private function get_maximum():Float
    {
        return _maximum;
    }
    private function set_maximum(value:Float):Float
    {
        if (_mode != BProgressBarMode.MANUAL) 
            return  //_maximum = Math.max(value, 0);  ;
        
        _maximum = value;
        _value = Math.min(_value, _maximum);
        updateBar();
        return value;
    }
    
    
    private function get_minimum():Float
    {
        return _minimum;
    }
    private function set_minimum(value:Float):Float
    {
        if (_mode != BProgressBarMode.MANUAL) 
            return  //_minimum = Math.max(value, 0);  ;
        
        _minimum = value;
        _value = Math.max(_value, _minimum);
        updateBar();
        return value;
    }
    
    
    private function get_mode():String
    {
        return _mode;
    }
    private function set_mode(value:String):String
    {
        if (_mode == value) 
            return  //resetProgress();  ;
        
        
        
        
        _mode = value;
        
        if (value == BProgressBarMode.EVENT && _source != null) 
        {
            _source.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
            _source.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
        }
        else if (value == BProgressBarMode.POLLED) 
        {
            addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
        }
        return value;
    }
    
    
    private function get_percentComplete():Float
    {
        //_percentComplete = (_maximum <= _minimum || _value <= _minimum) ?  0 : Math.max(0, Math.min(100, (_value-_minimum) / (_maximum - _minimum) * 100));
        return _percentComplete;
    }
    
    
    private function get_source():Dynamic
    {
        return _source;
    }
    private function set_source(value:Dynamic):Dynamic
    {
        if (_source == value) 
            return  /*if (_mode != BProgressBarMode.MANUAL) 
			{ 
				//resetProgress(); 
			}*/  ;
        
        
        
        
        _source = value;
        
        if (_source == null) 
            return  // Can not poll or add listeners to a null source!  ;
        
        if (_mode == BProgressBarMode.EVENT) 
        {
            _source.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
            _source.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
        }
        else if (_mode == BProgressBarMode.POLLED) 
        {
            addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
        }
        return value;
    }
    
    
    private function get_value():Float
    {
        return _value;
    }
    private function set_value(value:Float):Float
    {
        value = value > (_maximum != 0) ? _maximum : value;
        value = value < (_minimum != 0) ? _minimum : value;
        _value = value;
        update();
        return value;
    }
}

