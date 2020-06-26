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

import borris.display.BElement;
import borris.controls.*;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.text.TextFormat;
import openfl.utils.Timer;


/**
 * The BIconRadioButton component lets you force a user to make a single selection from a set of choices.
 * 	This component must be used in a group of at least two RadioButton instances.
 * 	Only one member of the group can be selected at any given time.
 * 	Selecting one radio button in a group deselects the currently selected radio button in the group.
 * 	You set the groupName parameter to indicate which group a radio button belongs to.
 * 	When the user clicks or tabs into a RadioButton component group, only the selected radio button receives focus.
 *
 * 	A radio button can be enabled or disabled. A disabled radio button does not receive mouse or keyboard input.
 *
 * @author Rohaan Allport
 * @creation-date 20/10/2014 (dd/mm/yyyy)
 */
class BIconRadioButton extends BRadioButton
{
    /**
	 * 
	 */
    public var tooltip(get, never):BTooltip;


    /**
	 * 
	 */
    public var showTooltip(get, set):Bool;


    /**
	 * 
	 */
    public var tooltipDelay(get, set):Int;


    // other
    private var _tooltipTimer:Timer = new Timer(500, 0);

    // set and get
    private var _tooltip:BTooltip;


    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BBIconRadioButton component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x position to place this component.
     * @param	y The y position to place this component.
	 * @param	label The text label for the component.
	 * @param	checked Specify whether the BradioButton should be selected or not.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, label:String = "", checked:Bool = false)
    {
        super(parent, x, y, label, checked);
        setSize(30, 30);
        draw();
    }


    /**
	 * 
	 * @param	event
	 */
    private function tooltipTimerHandler(event:TimerEvent):Void
    {
        _tooltip.display();
        _tooltipTimer.reset();
        _tooltipTimer.removeEventListener(TimerEvent.TIMER, tooltipTimerHandler);
    } // end function


    /**
	 * 
	 * @param	event
	 */
    override private function mouseHandler(event:MouseEvent):Void
    {
        // if this item was clicked on, and it does NOT have a submenu.
        // The CLICK listener is added and removed in the "set enabled" function
        if(event.type == MouseEvent.CLICK)
        {
            // dispatch a new Event.SELECT object
            this.dispatchEvent(new Event(Event.SELECT, false, false));

            // set checked to not checked or Selected
            if(selected)
            {
                selected = true;
            }
            else
            {
                selected = !selected;
            }
        } // end if


        parent.setChildIndex(this, parent.numChildren - 1);
        // TODO. this is a quick fix
        //_tooltip.x = event.stageX;
        //_tooltip.y = event.stageY + 22;
        _tooltip.x = event.localX;
        _tooltip.y = event.localY + 22;

        if(!enabled)
        {
            if(selected)
            {
                changeState(_selectedDisabledSkin);
            }
            else
            {
                changeState(_disabledSkin);
            }

            return;
        } //  end if


        if(enabled)
        {

            // if selected
            if(_selected)
            {
                switch (event.type)
                {
                    case MouseEvent.MOUSE_OVER:
                        changeState(_selectedOverSkin);
                        _tooltipTimer.start();
                        _tooltipTimer.addEventListener(TimerEvent.TIMER, tooltipTimerHandler);

                    case MouseEvent.MOUSE_OUT:
                        changeState(_selectedUpSkin);
                        _tooltip.hide();
                        if(_tooltipTimer.hasEventListener(TimerEvent.TIMER))
                        {
                            _tooltipTimer.removeEventListener(TimerEvent.TIMER, tooltipTimerHandler);
                        }

                    case MouseEvent.MOUSE_DOWN:
                        changeState(_selectedDownSkin);

                    case MouseEvent.MOUSE_UP:
                        changeState(_selectedUpSkin);
                } //  end switch
            }
                //  else (if not selected)
            else
            {
                switch (event.type)
                {
                    case MouseEvent.MOUSE_OVER:
                        changeState(_overSkin);
                        _tooltipTimer.start();
                        _tooltipTimer.addEventListener(TimerEvent.TIMER, tooltipTimerHandler);

                    case MouseEvent.MOUSE_OUT:
                        changeState(_upSkin);
                        _tooltip.hide();
                        if(_tooltipTimer.hasEventListener(TimerEvent.TIMER))
                        {
                            _tooltipTimer.removeEventListener(TimerEvent.TIMER, tooltipTimerHandler);
                        }

                    case MouseEvent.MOUSE_DOWN:
                        changeState(_downSkin);

                    case MouseEvent.MOUSE_UP:
                        changeState(_overSkin);
                } //  end switch
            }
        } // end if

    } // end function


    //***************************************** OVERRIDES *****************************************


    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();

        // set state colors
        setStateColors(0x222222, 0x333333, 0x666666, 0x000000, 0x333333, 0x666666, 0x999999, 0x000000);
        setStateAlphas(0, 1, 1, 1, 1, 1, 1, 1);

        // text
        _enabledTF = new TextFormat("Calibri", 14, 0x000000, false, false, false);

        // tooltip
        // FIXME _tooltip = new BTooltip(cast((root), DisplayObjectContainer), 0, 0, _label);
        _tooltip = new BTooltip(cast((this), DisplayObjectContainer), 0, 0, _label);
        _tooltip.displayPosition = "bottomRight";
        _tooltip.backgroundColor = 0x006699;

        removeChild(_labelText);
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        //
        _upSkin.width =
        _overSkin.width =
        _downSkin.width =
        _disabledSkin.width =
        _selectedUpSkin.width =
        _selectedOverSkin.width =
        _selectedDownSkin.width =
        _selectedDisabledSkin.width = _width;

        _upSkin.height =
        _overSkin.height =
        _downSkin.height =
        _disabledSkin.height =
        _selectedUpSkin.height =
        _selectedOverSkin.height =
        _selectedDownSkin.height =
        _selectedDisabledSkin.height = _height;

        cast((_upSkin), BElement).style.backgroundColor = _upColor;
        cast((_upSkin), BElement).style.backgroundOpacity = _upAlpha;
        cast((_upSkin), BElement).style.borderColor = 0x333333;
        cast((_upSkin), BElement).style.borderOpacity = 1;
        cast((_upSkin), BElement).style.borderWidth = 0;

        cast((_overSkin), BElement).style.backgroundColor = _overColor;
        cast((_overSkin), BElement).style.backgroundOpacity = _overAlpha;
        cast((_overSkin), BElement).style.borderColor = 0x666666;
        cast((_overSkin), BElement).style.borderOpacity = 1;
        cast((_overSkin), BElement).style.borderWidth = 2;

        cast((_downSkin), BElement).style.backgroundColor = _downColor;
        cast((_downSkin), BElement).style.backgroundOpacity = _downAlpha;
        cast((_downSkin), BElement).style.borderColor = 0xCCCCCC;
        cast((_downSkin), BElement).style.borderOpacity = 0;
        cast((_downSkin), BElement).style.borderWidth = 2;

        cast((_disabledSkin), BElement).style.backgroundColor = _disabledColor;
        cast((_disabledSkin), BElement).style.backgroundOpacity = _disabledAlpha;
        cast((_disabledSkin), BElement).style.borderColor = 0xCCCCCC;
        cast((_disabledSkin), BElement).style.borderOpacity = 1;
        cast((_disabledSkin), BElement).style.borderWidth = 0;

        //
        cast((_selectedUpSkin), BElement).style.backgroundColor = _selectedUpColor;
        cast((_selectedUpSkin), BElement).style.backgroundOpacity = _selectedUpAlpha;
        cast((_selectedUpSkin), BElement).style.borderColor = 0xCCCCCC;
        cast((_selectedUpSkin), BElement).style.borderOpacity = 1;
        cast((_selectedUpSkin), BElement).style.borderWidth = 0;
        //cast((_selectedUpSkin), BElement).style.filters = [new DropShadowFilter(1, 90, 0x000000, 1, 4, 4, 1, 1, true)];

        cast((_selectedOverSkin), BElement).style.backgroundColor = _selectedOverColor;
        cast((_selectedOverSkin), BElement).style.backgroundOpacity = _selectedOverAlpha;
        cast((_selectedOverSkin), BElement).style.borderColor = 0xCCCCCC;
        cast((_selectedOverSkin), BElement).style.borderOpacity = 1;
        cast((_selectedOverSkin), BElement).style.borderWidth = 0;
        //cast((_selectedOverSkin), BElement).style.filters = [new DropShadowFilter(1, 90, 0x000000, 1, 4, 4, 1, 1, true)];

        cast((_selectedDownSkin), BElement).style.backgroundColor = _selectedDownColor;
        cast((_selectedDownSkin), BElement).style.backgroundOpacity = _selectedDownAlpha;
        cast((_selectedDownSkin), BElement).style.borderColor = 0xCCCCCC;
        cast((_selectedDownSkin), BElement).style.borderOpacity = 1;
        cast((_selectedDownSkin), BElement).style.borderWidth = 0;
        //cast((_selectedDownSkin), BElement).style.filters = [new DropShadowFilter(1, 90, 0x000000, 1, 4, 4, 1, 1, true)];

        cast((_selectedDisabledSkin), BElement).style.backgroundColor = _selectedDisabledColor;
        cast((_selectedDisabledSkin), BElement).style.backgroundOpacity = _selectedDisabledAlpha;
        cast((_selectedDisabledSkin), BElement).style.borderColor = 0xCCCCCC;
        cast((_selectedDisabledSkin), BElement).style.borderOpacity = 1;
        cast((_selectedDisabledSkin), BElement).style.borderWidth = 0;
        //cast((_selectedDisabledSkin), BElement).style.filters = [new DropShadowFilter(1, 90, 0x000000, 1, 4, 4, 1, 1, true)];


        // reposition the _icons
        positionIcons();

    } // end function


    /**
	 * @inheritDoc
	 */
    override private function changeState(state:DisplayObject):Void
    {

        for(i in 0..._states.length)
        {
            var tempState:DisplayObject = _states[i];
            var tempIcon:DisplayObject = _icons[i];

            if(state == tempState)
            {
                tempState.visible = true;
                tempIcon.visible = true;
            }
            else
            {
                tempState.visible = false;
                tempIcon.visible = false;
            }
        } // end for

        if(_allIconsSameFlag)
        {
            _upIcon.visible = _allIconsSameFlag;
        } // end if

    } // function


    //***************************************** SET AND GET *****************************************


    private function get_tooltip():BTooltip
    {
        return _tooltip;
    }


    private function get_showTooltip():Bool
    {
        return _tooltip.visible;
    }

    private function set_showTooltip(value:Bool):Bool
    {
        if(value)
        {
            _tooltip.visible = true;
            _tooltip.scaleX = _tooltip.scaleY = 1;
            _tooltip.alpha = 1;
        }
        else
        {
            _tooltip.visible = false;
            _tooltip.scaleX = _tooltip.scaleY = 0;
            _tooltip.alpha = 0;
        }
        return value;
    }


    private function get_tooltipDelay():Int
    {
        return cast(_tooltipTimer.delay, Int);
    }

    private function set_tooltipDelay(value:Int):Int
    {
        _tooltipTimer.delay = value;
        return value;
    }
}

