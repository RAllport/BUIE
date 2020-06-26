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

import Std;
import borris.display.BElement;

import motion.Actuate;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
 * The RadioButton component lets you force a user to make a single selection from a set of choices.
 * This component must be used in a group of at least two RadioButton instances.
 * Only one member of the group can be selected at any given time.
 * Selecting one radio button in a group deselects the currently selected radio button in the group.
 * You set the groupName parameter to indicate which group a radio button belongs to.
 * When the user clicks or tabs into a RadioButton component group, only the selected radio button receives focus.
 *
 * A radio button can be enabled or disabled. A disabled radio button does not receive mouse or keyboard input.
 *
 * @author Rohaan Allport
 * @creation-date 20/10/2014 (dd/mm/yyyy)
 */
class BRadioButton extends BLabelButton
{
    /**
	 * The BRadioButtonGroup object to which this RadioButton belongs.
	 */
	public var group(get, set):BRadioButtonGroup;

	/**
	 * The group name for a radio button instance or group. 
	 * You can use this property to get or set a group name for a radio button instance or for a radio button group
	 * 
	 * @default "RadioButtonGroup"
	 */
	public var groupName(get, set):String;

	/**
	 * A user-defined value that is associated with a radio button.
	 * 
	 * @default null
	 */
	public var value(get, set):Dynamic;

    // constants


    // assets


    // other
    private var _defaultGroupName:String = "BRadioButtonGroup";


    // set and get
    private var _group:BRadioButtonGroup;  // The BRadioButtonGroup object to which this RadioButton belongs.
    private var _groupName:String;  // The group name for a radio button instance or group.
    private var _value:Dynamic;  // A user-defined value that is associated with a radio button.


    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BRadioButton component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x position to place this component.
     * @param	y The y position to place this component.
	 * @param	label The text label for the component.
	 * @param	checked Specify whether the BradioButton should be selected or not.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, label:String = "", checked:Bool = false)
    {
        super(parent, x, y, label);

		_toggle = true;
        _autoSize = false;
        _groupName = _defaultGroupName;
        _value = null;
    }


    /**
	 * @inheritDoc
	 */
    override private function mouseHandler(event:MouseEvent):Void
    {
        // the super.mouseHandler() could be called here, but it wouldn't make much sense due to the nature and order of how to change the _states.

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

		// The CLICK listener is added and removed in the "set enabled" function
		if (event.type == MouseEvent.CLICK)
        {
            // if this button was clicked on set selected
            // selected can only be set if the the toggle property is true
            // if a radio buton is click when it is slected, it remains selected.
            // a radio button cannot become unselected by clicking it, only via another radio button from the same group being clicked
            if (selected)
            {
                return;
            }
            else
            {
                selected = !selected;
            }

			// only if selected is true, dispatch a new select event
            if (selected)
            {
                // dispatch a new selecte event
                this.dispatchEvent(new Event(Event.SELECT, false, false));
            }
        }  // end if


        if (_selected)
        //if (_toggle && _selected)
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
                    changeState(_selectedUpSkin);

                case MouseEvent.CLICK:
                    changeState(_selectedUpSkin);
            }  // end switch
        }
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
                    changeState(_upSkin);

                case MouseEvent.CLICK:
                    changeState(_upSkin);
            }  // end switch
        }
    }  // end function mouseHandler


    //************************************* FUNCTIONS ******************************************


    /**
	 * @inheritDoc
	 */
    override private function initialize():Void
    {
        super.initialize();

        //
        _labelText.x = 30;
        _labelText.y = 0;

        // set state colors
        setStateColors(0xCCCCCC, 0xFFFFFF, 0x999999, 0x666666, 0x0099CC, 0x00CCFF, 0x006699, 0x003366);
        setStateAlphas(1, 1, 1, 0.8, 1, 1, 1, 0.8);
    }  // end function initialize


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        var buttonWidth:Int = 20;
        var buttonHeight:Int = 20;
        var strokeThickness:Int = 2;
        var circleRadius:Int = 6;
        var backColor:Int = 0x000000;
        var borderRadius:Int = Std.int(buttonWidth/2);


        //
        _upSkin.width =
        _overSkin.width =
        _downSkin.width =
        _disabledSkin.width =
        _selectedUpSkin.width =
        _selectedOverSkin.width =
        _selectedDownSkin.width =
        _selectedDisabledSkin.width = buttonWidth;

        _upSkin.height =
        _overSkin.height =
        _downSkin.height =
        _disabledSkin.height =
        _selectedUpSkin.height =
        _selectedOverSkin.height =
        _selectedDownSkin.height =
        _selectedDisabledSkin.height = buttonHeight;

        cast((_upSkin), BElement).style.backgroundColor = backColor;
        cast((_upSkin), BElement).style.backgroundOpacity = _upAlpha;
        cast((_upSkin), BElement).style.borderColor = _upColor;
        cast((_upSkin), BElement).style.borderOpacity = _upAlpha;
        cast((_upSkin), BElement).style.borderRadius = borderRadius;
        cast((_upSkin), BElement).style.borderWidth = strokeThickness;

        cast((_overSkin), BElement).style.backgroundColor = backColor;
        cast((_overSkin), BElement).style.backgroundOpacity = _overAlpha;
        cast((_overSkin), BElement).style.borderColor = _overColor;
        cast((_overSkin), BElement).style.borderOpacity = _overAlpha;
        cast((_overSkin), BElement).style.borderRadius = borderRadius;
        cast((_overSkin), BElement).style.borderWidth = strokeThickness;

        cast((_downSkin), BElement).style.backgroundColor = backColor;
        cast((_downSkin), BElement).style.backgroundOpacity = _downAlpha;
        cast((_downSkin), BElement).style.borderColor = _downColor;
        cast((_downSkin), BElement).style.borderOpacity = _downAlpha;
        cast((_downSkin), BElement).style.borderRadius = borderRadius;
        cast((_downSkin), BElement).style.borderWidth = strokeThickness;

        cast((_disabledSkin), BElement).style.backgroundColor = backColor;
        cast((_disabledSkin), BElement).style.backgroundOpacity = _disabledAlpha;
        cast((_disabledSkin), BElement).style.borderColor = _downColor;
        cast((_disabledSkin), BElement).style.borderOpacity = _disabledAlpha;
        cast((_disabledSkin), BElement).style.borderRadius = borderRadius;
        cast((_disabledSkin), BElement).style.borderWidth = strokeThickness;

        //
        cast((_selectedUpSkin), BElement).style.backgroundColor = backColor;
        cast((_selectedUpSkin), BElement).style.backgroundOpacity = _selectedUpAlpha;
        cast((_selectedUpSkin), BElement).style.borderColor = _selectedUpColor;
        cast((_selectedUpSkin), BElement).style.borderOpacity = _selectedUpAlpha;
        cast((_selectedUpSkin), BElement).style.borderRadius = borderRadius;
        cast((_selectedUpSkin), BElement).style.borderWidth = strokeThickness;

        cast((_selectedOverSkin), BElement).style.backgroundColor = backColor;
        cast((_selectedOverSkin), BElement).style.backgroundOpacity = _selectedOverAlpha;
        cast((_selectedOverSkin), BElement).style.borderColor = _selectedOverColor;
        cast((_selectedOverSkin), BElement).style.borderOpacity = _selectedOverAlpha;
        cast((_selectedOverSkin), BElement).style.borderRadius = borderRadius;
        cast((_selectedOverSkin), BElement).style.borderWidth = strokeThickness;

        cast((_selectedDownSkin), BElement).style.backgroundColor = backColor;
        cast((_selectedDownSkin), BElement).style.backgroundOpacity = _selectedDownAlpha;
        cast((_selectedDownSkin), BElement).style.borderColor = _selectedDownColor;
        cast((_selectedDownSkin), BElement).style.borderOpacity = _selectedDownAlpha;
        cast((_selectedDownSkin), BElement).style.borderRadius = borderRadius;
        cast((_selectedDownSkin), BElement).style.borderWidth = strokeThickness;

        cast((_selectedDisabledSkin), BElement).style.backgroundColor = backColor;
        cast((_selectedDisabledSkin), BElement).style.backgroundOpacity = _selectedDisabledAlpha;
        cast((_selectedDisabledSkin), BElement).style.borderColor = _selectedDisabledColor;
        cast((_selectedDisabledSkin), BElement).style.borderOpacity = _selectedDisabledAlpha;
        cast((_selectedDisabledSkin), BElement).style.borderRadius = borderRadius;
        cast((_selectedDisabledSkin), BElement).style.borderWidth = strokeThickness;



        // _icons
        /*_upIcon.graphics.clear();
			_upIcon.graphics.beginFill(_upColor, 1);
			_upIcon.graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			_upIcon.graphics.endFill();
			
			_overIcon.graphics.clear();
			_overIcon.graphics.beginFill(_overColor, 1);
			_overIcon.graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			_overIcon.graphics.endFill();
			
			_downIcon.graphics.clear();
			_downIcon.graphics.beginFill(_downColor, 1);
			_downIcon.graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			_downIcon.graphics.endFill();
			
			_disabledIcon.graphics.clear();
			_disabledIcon.graphics.beginFill(_disabledColor, 1);
			_disabledIcon.graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			_disabledIcon.graphics.endFill();*/


        // selected _icons
        cast((_selectedUpIcon), Sprite).graphics.clear();
        cast((_selectedUpIcon), Sprite).graphics.beginFill(_upColor, 1);
        cast((_selectedUpIcon), Sprite).graphics.drawCircle(0, 0, circleRadius);
        cast((_selectedUpIcon), Sprite).graphics.endFill();

        cast((_selectedOverIcon), Sprite).graphics.clear();
        cast((_selectedOverIcon), Sprite).graphics.beginFill(_overColor, 1);
        cast((_selectedOverIcon), Sprite).graphics.drawCircle(0, 0, circleRadius);
        cast((_selectedOverIcon), Sprite).graphics.endFill();

        cast((_selectedDownIcon), Sprite).graphics.clear();
        cast((_selectedDownIcon), Sprite).graphics.beginFill(_downColor, 1);
        cast((_selectedDownIcon), Sprite).graphics.drawCircle(0, 0, circleRadius);
        cast((_selectedDownIcon), Sprite).graphics.endFill();

        cast((_selectedDisabledIcon), Sprite).graphics.clear();
        cast((_selectedDisabledIcon), Sprite).graphics.beginFill(_disabledColor, 1);
        cast((_selectedDisabledIcon), Sprite).graphics.drawCircle(0, 0, circleRadius);
        cast((_selectedDisabledIcon), Sprite).graphics.endFill();


        // position _icons
        _upIcon.x = _overIcon.x = _downIcon.x = _disabledIcon.x = buttonHeight / 2;
        _selectedUpIcon.x = _selectedOverIcon.x = _selectedDownIcon.x = _selectedDisabledIcon.x = buttonHeight / 2;
        _upIcon.y = _overIcon.y = _downIcon.y = _disabledIcon.y = _selectedUpIcon.y = _selectedOverIcon.y = _selectedDownIcon.y = _selectedDisabledIcon.y = buttonHeight / 2;
    }  // end function draw


    /**
	 * @inheritDoc
	 */
    override private function changeState(state:DisplayObject):Void
    {
		var prevState:DisplayObject = null;

        for (i in 0..._states.length)
		{
            var tempState:DisplayObject = _states[i];
            var tempIcon:DisplayObject = _icons[i];

            if (tempState.visible)
            {
                prevState = tempState;
            }

            if (state == tempState)
            {
                tempState.visible = true;
                tempIcon.visible = true;
            }
            else
            {
                tempState.visible = false;
                tempIcon.visible = false;
            }
        }  // end for

		if(state == _selectedUpSkin)
        {
			if(prevState == _upSkin)
            {
				_selectedUpIcon.scaleX = _selectedUpIcon.scaleY = 0;
                Actuate.tween(_selectedUpIcon, 0.3, { scaleX: 1, scaleY: 1} );
            }  // end if
        }
        // end else if
        else if (state == _upSkin)
        {
			_selectedUpIcon.visible = true;
			Actuate.tween(_selectedUpIcon, 0.3, { scaleX: 0, scaleY: 0 } );
        }
    }  // end function changeState


    //***************************************** SET AND GET *****************************************


    private function get_group():BRadioButtonGroup
    {
        return _group;
    }
    private function set_group(value:BRadioButtonGroup):BRadioButtonGroup
    {
        _group = value;
        value.addRadioButton(this);
        return value;
    }


    private function get_groupName():String
    {
        return _groupName;
    }
    private function set_groupName(value:String):String
    {
        _groupName = value;
        return value;
    }


    /**
	 * Indicates whether a radio button is currently selected (true) or deselected (false). 
	 * You can only set this value to true; setting it to false has no effect. 
	 * To achieve the desired effect, select a different radio button in the same radio button group.
	 * 
	 * @default false
	 */
    override private function set_selected(value:Bool):Bool
    {
        if (value && _enabled)
        {
            changeState(_selectedUpSkin);
        }
        else
        {
            changeState(_upSkin);
        }

        _selected = value;

        if (_group != null)
        {
            if(_selected)
            {
				//trace("about to clear group!");
                _group.clear(this);
            }
        }
        return value;
    }


    /**
	 * A radio button is a toggle button; its toggle property is set to true in the constructor and cannot be changed.
	 * 
	 * @default true
	 */
    override private function set_toggle(value:Bool):Bool
    {
        return true;
    }


    private function get_value():Dynamic
    {
        return _value;
    }
    private function set_value(value:Dynamic):Dynamic
    {
        _value = value;
        return value;
    }
}

