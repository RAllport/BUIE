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

import motion.Actuate;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 19/10/2014 (dd/mm/yyyy)
 */
class BToggleButton extends BLabelButton
{
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * The BToggleButton displays an oval/elipse like shape contains a circular icon.
     * 	A BToggleButton can also display an optional text label that is positioned to the left, right, top, or bottom of the BToggleButton.
     *
     * 	<p>A BToggleButton changes its state in response to a mouse click or swipe, from on to off, or from off to on.
     * 	BToggleButton components include a set of true or false values that are not mutually exclusive.</P>
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
	 * @param	label The text label for the component.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, label:String = "")
    {
        super(parent, x, y, label);
        setSize(100, 20);

        _toggle = true;
        _autoSize = false;
    }


    //************************************* FUNCTIONS ******************************************


    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 * 
	 */
    override private function initialize():Void
    {
        super.initialize();

        //
        _labelText.x = 50;
        _labelText.y = 0;

        // set state colors
        setStateColors(0xCCCCCC, 0xFFFFFF, 0x999999, 0x666666, 0x0099CC, 0x00CCFF, 0x006699, 0x003366);
        setStateAlphas(1, 1, 1, 0.8, 1, 1, 1, 0.8);
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        var buttonWidth:Int = 40;
        var buttonHeight:Int = 20;
        var strokeThickness:Int = 2;
        var circleRadius:Int = 6;
        var backColor:Int = 0x000000;
        var borderRadius:Int = Std.int(buttonHeight/2);

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
        cast((_selectedUpSkin), BElement).style.backgroundColor = _selectedUpColor;
        cast((_selectedUpSkin), BElement).style.backgroundOpacity = _selectedUpAlpha;
        cast((_selectedUpSkin), BElement).style.borderColor = _selectedUpColor;
        cast((_selectedUpSkin), BElement).style.borderOpacity = _selectedUpAlpha;
        cast((_selectedUpSkin), BElement).style.borderRadius = borderRadius;
        cast((_selectedUpSkin), BElement).style.borderWidth = 0;

        cast((_selectedOverSkin), BElement).style.backgroundColor = _selectedOverColor;
        cast((_selectedOverSkin), BElement).style.backgroundOpacity = _selectedOverAlpha;
        cast((_selectedOverSkin), BElement).style.borderColor = _selectedOverColor;
        cast((_selectedOverSkin), BElement).style.borderOpacity = _selectedOverAlpha;
        cast((_selectedOverSkin), BElement).style.borderRadius = borderRadius;
        cast((_selectedOverSkin), BElement).style.borderWidth = 0;

        cast((_selectedDownSkin), BElement).style.backgroundColor = _selectedDownColor;
        cast((_selectedDownSkin), BElement).style.backgroundOpacity = _selectedDownAlpha;
        cast((_selectedDownSkin), BElement).style.borderColor = _selectedDownColor;
        cast((_selectedDownSkin), BElement).style.borderOpacity = _selectedDownAlpha;
        cast((_selectedDownSkin), BElement).style.borderRadius = borderRadius;
        cast((_selectedDownSkin), BElement).style.borderWidth = 0;

        cast((_selectedDisabledSkin), BElement).style.backgroundColor = _selectedDisabledColor;
        cast((_selectedDisabledSkin), BElement).style.backgroundOpacity = _selectedDisabledAlpha;
        cast((_selectedDisabledSkin), BElement).style.borderColor = _selectedDisabledColor;
        cast((_selectedDisabledSkin), BElement).style.borderOpacity = _selectedDisabledAlpha;
        cast((_selectedDisabledSkin), BElement).style.borderRadius = borderRadius;
        cast((_selectedDisabledSkin), BElement).style.borderWidth = 0;


        // _icons
        cast((_upIcon), Sprite).graphics.clear();
        cast((_upIcon), Sprite).graphics.beginFill(_upColor, 1);
        cast((_upIcon), Sprite).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
        cast((_upIcon), Sprite).graphics.endFill();

        cast((_overIcon), Sprite).graphics.clear();
        cast((_overIcon), Sprite).graphics.beginFill(_overColor, 1);
        cast((_overIcon), Sprite).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
        cast((_overIcon), Sprite).graphics.endFill();

        cast((_downIcon), Sprite).graphics.clear();
        cast((_downIcon), Sprite).graphics.beginFill(_downColor, 1);
        cast((_downIcon), Sprite).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
        cast((_downIcon), Sprite).graphics.endFill();

        cast((_disabledIcon), Sprite).graphics.clear();
        cast((_disabledIcon), Sprite).graphics.beginFill(_disabledColor, 1);
        cast((_disabledIcon), Sprite).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
        cast((_disabledIcon), Sprite).graphics.endFill();

        // selected _icons
        cast((_selectedUpIcon), Sprite).graphics.clear();
        cast((_selectedUpIcon), Sprite).graphics.beginFill(_upColor, 1);
        cast((_selectedUpIcon), Sprite).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
        cast((_selectedUpIcon), Sprite).graphics.endFill();

        cast((_selectedOverIcon), Sprite).graphics.clear();
        cast((_selectedOverIcon), Sprite).graphics.beginFill(_overColor, 1);
        cast((_selectedOverIcon), Sprite).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
        cast((_selectedOverIcon), Sprite).graphics.endFill();

        cast((_selectedDownIcon), Sprite).graphics.clear();
        cast((_selectedDownIcon), Sprite).graphics.beginFill(_downColor, 1);
        cast((_selectedDownIcon), Sprite).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
        cast((_selectedDownIcon), Sprite).graphics.endFill();

        cast((_selectedDisabledIcon), Sprite).graphics.clear();
        cast((_selectedDisabledIcon), Sprite).graphics.beginFill(_disabledColor, 1);
        cast((_selectedDisabledIcon), Sprite).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
        cast((_selectedDisabledIcon), Sprite).graphics.endFill();


        // position _icons
        _upIcon.x = _overIcon.x = _downIcon.x = _disabledIcon.x = (buttonHeight - (circleRadius * 2)) / 2;
        _selectedUpIcon.x = _selectedOverIcon.x = _selectedDownIcon.x = _selectedDisabledIcon.x = buttonWidth - 2 - 2 - 12;
        _upIcon.y = _overIcon.y = _downIcon.y = _disabledIcon.y = _selectedUpIcon.y = _selectedOverIcon.y = _selectedDownIcon.y = _selectedDisabledIcon.y = (buttonHeight - (circleRadius * 2)) / 2;
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

        if(state == _selectedOverSkin)
        {
            Actuate.tween(_upIcon, 0.3, { x: (40 - 2 - 2 - 12)});
            Actuate.tween(_selectedUpIcon, 0.3, { x: (40 - 2 - 2 - 12)});
            Actuate.tween(_overIcon, 0.3, { x: (40 - 2 - 2 - 12)});
            Actuate.tween(_selectedOverIcon, 0.3, { x: (40 - 2 - 2 - 12) });
        }
        else if(state == _overSkin)
        {
            Actuate.tween(_upIcon, 0.3, { x: (2 + 2)});
            Actuate.tween(_selectedUpIcon, 0.3, { x: (2 + 2)});
            Actuate.tween(_overIcon, 0.3, { x: (2 + 2) });
            Actuate.tween(_selectedOverIcon, 0.3, { x: (2 + 2) });
        }
    } // end function


    //***************************************** SET AND GET *****************************************


    /**
     * A toggle button toggles by definition, so the <code>toggle</code> property is set to 
     * <code>true</code> in the constructor and cannot be changed.
	 */
    override private function set_toggle(value:Bool):Bool
    {
        return true;
    }


    /**
	 * The toggle button icon is a circle. It is set in the constructor and cannot be changed.
	 */
    override private function set_icon(value:DisplayObject):DisplayObject
    {
        return null;
    }

    override private function get_icon():DisplayObject
    {
        return null;
    }
} // end class

