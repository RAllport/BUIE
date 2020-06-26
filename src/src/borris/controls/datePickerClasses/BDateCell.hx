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

package borris.controls.datePickerClasses;

import borris.controls.BLabelButton;
import borris.display.BElement;

import motion.Actuate;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextFormat;

// TODO change skins to BElements
/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date  (dd/mm/yyyy)
 */
class BDateCell extends BLabelButton
{
    /**
	 * Gets for sets the sate of the cell.
	 */
    public var state(get, set):String;

    // assets
    private var _currentUpSkin:Sprite;
    private var _currentOverSkin:Sprite;
    private var _currentDownSkin:Sprite;
    
    private var _currentSelectedUpSkin:Sprite;
    private var _currentSelectedOverSkin:Sprite;
    private var _currentSelectedDownSkin:Sprite;
    
    
    // style
    private var _currentMonthTF:TextFormat = new TextFormat("Calibri", 22, 0xFFFFFF, false);
    
    
    // other
    private var _currentDay:Bool = false;
    private var _currentMonth:Bool = false;
    
    
    // set and get
    private var _state:String = "normal";  // up, over, down, selectedUp, selectedOver, selectedDown, current, notMonth  
    
    
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        super(parent, x, y);
        setSize(40, 40);
        
        autoSize = false;
        labelPlacement = BPlacement.CENTER;
        toggle = true;
        setStateColors(0x000000, 0xCCCCCC, 0x666666, 0x000000, 0x00CCFF, 0x0099CC, 0x000000, 0x000000);
        setStateAlphas(0, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.1);
    }
    
    
    
    //**************************************** HANDLERS *********************************************
    
    
    /**
	 * @inheritDoc 
	 * 
	 * @param	event
	 */
    override private function mouseHandler(event:MouseEvent):Void
    {
        
        //trace("mouse event recieved!: " + event.type);
        // if the button is not enabled set the disabeled skins and skip everything
        if (!enabled) 
        {
            if (selected) 
            {
                changeState(_selectedDisabledSkin);
            }
            else 
            {
                changeState(_disabledSkin);
            }
            
            return;
        } //  end if  
        
        
        // if this button was clicked on set selected
        // selected can only be set if the the toggle property is true
        if(event.type == MouseEvent.CLICK) 
        {
            // set selected to not selected
            selected = !selected;
            
            // only if selected is true, dispatch a new select event
            if (selected) 
            {
                // dispatch a new selecte event
                this.dispatchEvent(new Event(Event.SELECT, false, false));
            }
        } // end if  
        
		
        // this is a toggle button and it is selected, use the selecetd _states
        // a button cant be selected unless is it a toggle button, so having the _toogle condition is unneccessary.
        // see BLableButton.selected
        if (_toggle && _selected) 
        {
            switch (event.type)
            {
                case MouseEvent.MOUSE_OVER:
                    changeState(_selectedOverSkin);
                
                case MouseEvent.MOUSE_OUT:
                    changeState(_selectedUpSkin);
                
                case MouseEvent.MOUSE_DOWN:
                    changeState(_selectedDownSkin);
                
                case MouseEvent.MOUSE_UP:
                    changeState(_selectedOverSkin);
                
                case MouseEvent.CLICK:
                    changeState(_selectedOverSkin);
            }  // end switch  
            
            if(_currentDay)
            switch (event.type)
            {
                case MouseEvent.MOUSE_OVER:
                    changeState(_currentSelectedOverSkin);
                
                case MouseEvent.MOUSE_OUT:
                    changeState(_currentSelectedUpSkin);
                
                case MouseEvent.MOUSE_DOWN:
                    changeState(_currentSelectedDownSkin);
                
                case MouseEvent.MOUSE_UP:
                    changeState(_currentSelectedOverSkin);
                
                case MouseEvent.CLICK:
                    changeState(_currentSelectedOverSkin);
            }  // end switch  ;
        }
        // else if it is not a toggle button and not selected, use the normal skins
        else 
        {
            switch (event.type)
            {
                case MouseEvent.MOUSE_OVER:
                    changeState(_overSkin);
                
                case MouseEvent.MOUSE_OUT:
                    changeState(_upSkin);
                
                case MouseEvent.MOUSE_DOWN:
                    changeState(_downSkin);
                
                case MouseEvent.MOUSE_UP:
                    changeState(_overSkin);
                
                case MouseEvent.CLICK:
                    changeState(_overSkin);
            }  // end switch  
            
            if (_currentDay)
            switch (event.type)
            {
                case MouseEvent.MOUSE_OVER:
                    changeState(_currentOverSkin);
                
                case MouseEvent.MOUSE_OUT:
                    changeState(_currentUpSkin);
                
                case MouseEvent.MOUSE_DOWN:
                    changeState(_currentDownSkin);
                
                case MouseEvent.MOUSE_UP:
                    changeState(_currentOverSkin);
                
                case MouseEvent.CLICK:
                    changeState(_currentOverSkin);
            }  // end switch
        }  
		
		//trace("Selected: " + selected);  
    } // end function
    
    
    
    //**************************************** FUNCTIONS ********************************************
    
    
    /**
	 * @inheritDoc
	 */
    override private function initialize():Void
    {
        // initialize the skins
        _currentUpSkin = new BElement();
        _currentOverSkin = new BElement();
        _currentDownSkin = new BElement();
        _currentSelectedUpSkin = new BElement();
        _currentSelectedOverSkin = new BElement();
        _currentSelectedDownSkin = new BElement();
        
        // call super initialize
        super.initialize();
        
        
        // add assets to respective containers
        addChild(_currentUpSkin);
        addChild(_currentOverSkin);
        addChild(_currentDownSkin);
        addChild(_currentSelectedUpSkin);
        addChild(_currentSelectedOverSkin);
        addChild(_currentSelectedDownSkin);
        
        removeChild(_disabledSkin);
        removeChild(_selectedDisabledSkin);
        
        
        // add the state skins to the state array
        _states = [_upSkin, _overSkin, _downSkin, _selectedUpSkin, _selectedOverSkin, _selectedDownSkin, _currentUpSkin,
                _currentOverSkin, _currentDownSkin, _currentSelectedUpSkin, _currentSelectedOverSkin, _currentSelectedDownSkin];
        //changeState(_upSkin);
        
        //
        //textField.setTextFormat(currentMonthTF);
        //textField.defaultTextFormat = currentMonthTF;
		textField.getTextFormat().size = 22;
    } // end function
    
    
    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        super.draw();
        
        var borderWidth:Int = 2;
        var borderOpacity:Float = 0.8;
        
        //var upBorderColor:uint = 0x000000;
        var overBorderColor:Int = 0xCCCCCC;
        var downBorderColor:Int = 0xFFFFFF;
        var selectedUpBorderColor:Int = 0x0099CC;
        var selectedOverBorderColor:Int = 0x00CCFF;
        var selectedDownBorderColor:Int = 0x006699;
        var currentUpBorderColor:Int = 0x0099CC;
        var currentOverBorderColor:Int = 0x00CCFF;
        var currentDownBorderColor:Int = 0x006699;
        
        
        cast((_upSkin), BElement).style.backgroundColor = _upColor;
        cast((_upSkin), BElement).style.backgroundOpacity = _upAlpha;
        
        cast((_overSkin), BElement).style.backgroundColor = _overColor;
        cast((_overSkin), BElement).style.backgroundOpacity = _overAlpha;
        cast((_overSkin), BElement).style.borderWidth = borderWidth;
        cast((_overSkin), BElement).style.borderColor = overBorderColor;
        cast((_overSkin), BElement).style.borderOpacity = borderOpacity;
        
        cast((_downSkin), BElement).style.backgroundColor = _downColor;
        cast((_downSkin), BElement).style.backgroundOpacity = _downAlpha;
        cast((_downSkin), BElement).style.borderWidth = borderWidth;
        cast((_downSkin), BElement).style.borderColor = downBorderColor;
        cast((_downSkin), BElement).style.borderOpacity = borderOpacity;
        
        // selected skins
        cast((_selectedUpSkin), BElement).style.backgroundColor = _selectedUpColor;
        cast((_selectedUpSkin), BElement).style.backgroundOpacity = _selectedUpAlpha;
        cast((_selectedUpSkin), BElement).style.borderWidth = borderWidth;
        cast((_selectedUpSkin), BElement).style.borderColor = selectedUpBorderColor;
        cast((_selectedUpSkin), BElement).style.borderOpacity = borderOpacity;
        
        cast((_selectedOverSkin), BElement).style.backgroundColor = _selectedOverColor;
        cast((_selectedOverSkin), BElement).style.backgroundOpacity = _selectedOverAlpha;
        cast((_selectedOverSkin), BElement).style.borderWidth = borderWidth;
        cast((_selectedOverSkin), BElement).style.borderColor = selectedOverBorderColor;
        cast((_selectedOverSkin), BElement).style.borderOpacity = borderOpacity;
        
        cast((_selectedDownSkin), BElement).style.backgroundColor = _selectedDownColor;
        cast((_selectedDownSkin), BElement).style.backgroundOpacity = _selectedDownAlpha;
        cast((_selectedDownSkin), BElement).style.borderWidth = borderWidth;
        cast((_selectedDownSkin), BElement).style.borderColor = selectedDownBorderColor;
        cast((_selectedDownSkin), BElement).style.borderOpacity = borderOpacity;
        
        
        // current skins
        
        _currentUpSkin.width =
                _currentOverSkin.width =
                        _currentDownSkin.width =
                                _currentSelectedUpSkin.width =
                                        _currentSelectedOverSkin.width =
                                                _currentSelectedDownSkin.width = _width;
        
        _currentUpSkin.height =
                _currentOverSkin.height =
                        _currentDownSkin.height =
                                _currentSelectedUpSkin.height =
                                        _currentSelectedOverSkin.height =
                                                _currentSelectedDownSkin.height = _height;
        
        cast((_currentUpSkin), BElement).style.backgroundColor = 0x0099CC;
        cast((_currentUpSkin), BElement).style.backgroundOpacity = 1;
        
        cast((_currentOverSkin), BElement).style.backgroundColor = 0x0099CC;
        cast((_currentOverSkin), BElement).style.backgroundOpacity = 1;
        cast((_currentOverSkin), BElement).style.borderWidth = borderWidth;
        cast((_currentOverSkin), BElement).style.borderColor = 0x66CCFF;
        cast((_currentOverSkin), BElement).style.borderOpacity = 1;
        
        cast((_currentDownSkin), BElement).style.backgroundColor = 0x0099CC;
        cast((_currentDownSkin), BElement).style.backgroundOpacity = 1;
        cast((_currentDownSkin), BElement).style.borderWidth = borderWidth;
        cast((_currentDownSkin), BElement).style.borderColor = 0x006699;
        cast((_currentDownSkin), BElement).style.borderOpacity = 1;
        
        // selected
        cast((_currentSelectedUpSkin), BElement).style.backgroundColor = 0x0099CC;
        cast((_currentSelectedUpSkin), BElement).style.backgroundOpacity = 1;
        cast((_currentSelectedUpSkin), BElement).style.borderWidth = borderWidth;
        //BElement(currentSelectedUpSkin).style.borderColor = 0x0099CC;
        cast((_currentSelectedUpSkin), BElement).style.borderColor = 0x66CCFF;
        cast((_currentSelectedUpSkin), BElement).style.borderOpacity = 1;
        
        cast((_currentSelectedOverSkin), BElement).style.backgroundColor = 0x0099CC;
        cast((_currentSelectedOverSkin), BElement).style.backgroundOpacity = 1;
        cast((_currentSelectedOverSkin), BElement).style.borderWidth = borderWidth;
        //BElement(currentSelectedOverSkin).style.borderColor = 0x66CCFF;
        cast((_currentSelectedOverSkin), BElement).style.borderColor = 0x99CCFF;
        cast((_currentSelectedOverSkin), BElement).style.borderOpacity = 1;
        
        cast((_currentSelectedDownSkin), BElement).style.backgroundColor = 0x0099CC;
        cast((_currentSelectedDownSkin), BElement).style.backgroundOpacity = 1;
        cast((_currentSelectedDownSkin), BElement).style.borderWidth = borderWidth;
        cast((_currentSelectedDownSkin), BElement).style.borderColor = 0x006699;
        cast((_currentSelectedDownSkin), BElement).style.borderOpacity = 1;
    } // end function
    
    
    /**
	 * @inheritDoc
	 */
    override private function changeState(state:DisplayObject):Void
    {
        // replication of BBaseButton.changeState()
        for (i in 0..._states.length)
		{
            var tempState:DisplayObject = _states[i];
			
            if (state == tempState) 
            {
				Actuate.tween(state, 0.3, { alpha: 1} );
                _currentState = state;
            }
            else 
            {
				//Actuate.tween(state, 0.3, { alpha: 0.1 } );
				tempState.alpha = 0;
            }
        }  //    // end for  
        
        
        Actuate.timer(0.3).onComplete(
		function():Void
		{ 
			for (i in 0..._states.length)
			{
				var tempState:DisplayObject = _states[i];
				tempState.alpha = 0;
				
				if (state == tempState) 
				{
					tempState.alpha = 1;
					
				}
			}  // end for  
		}
		);
        
        //
        if (_currentMonth)
        {
            textField.alpha = 1;
        }
        else 
        {
            textField.alpha = 0.5;
        }
    } // end function
    
    
    
    //**************************************** SET AND GET ******************************************
    

    private function get_state():String
    {
        return _state;
    }
    
    private function set_state(value:String):String
    {
        _state = value;
        
        
        _currentDay = false;
        _currentMonth = false;
        
        switch (_state)
        {
            case "normal":
                changeState(_upSkin);
            
            case "currentMonth":
                _currentMonth = true;
                changeState(_upSkin);
            
            case "currentDay":
                _currentMonth = true;
                _currentDay = true;
                changeState(_currentUpSkin);
            
            default:
                changeState(_upSkin);
        }  // end switch case  
        return value;
    }
	

	/**
     * A toggle button toggles by definition, so the <code>toggle</code> property is set to
     * <code>true</code> in the constructor and cannot be changed.
	 */
    override private function set_toggle(value:Bool):Bool
    {
        return true;
    }
	
	
}

