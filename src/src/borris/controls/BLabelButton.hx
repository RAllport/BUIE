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

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;


// BUG labelPlacement and iconPlacement is buggy
/**
 * The BLabelButton class is an abstract class that extends the BaseButton class by adding a label, 
 * an icon, and toggle functionality. The LabelButton class is subclassed by the 
 * BButton, BCheckBox, BRadioButton, and BCellRenderer classes.
 * 
 * <p>The LabelButton component is used as a simple button class that can be combined with custom 
 * skin _states that support ScrollBar buttons, NumericStepper buttons, ColorPicker swatches, and so on.</p>
 * 
 * @author Rohaan Allport
 * @creation-date 19/10/2014 (dd/mm/yyyy)
 */
class BLabelButton extends BBaseButton
{
    /**
	 * Position of the icon in relation to button in which it is contained.
	 * 
	 * <p>You can use the following constants to set this property:</p>
	 * 
	 * <ul>
	 * 	<li>BPlacement.LEFT</li>
	 * 	<li>BPlacement.RIGHT</li>
	 * 	<li>BPlacement.TOP</li>
	 * 	<li>BPlacement.BOTTOM</li>
	 * 	<li>BPlacement.CENTER</li>
	 * 	<li>BPlacement.TOP_LEFT</li>
	 * 	<li>BPlacement.BOTTOM_LEFT</li>
	 * 	<li>BPlacement.TOP_RIGHT</li>
	 * 	<li>BPlacement.BOTTOM_RIGHT</li>
	 * </ul>
	 * 
	 * @default BPlacement.CENTER
	 */
    public var iconPlacement(get, set):BPlacement;

    /**
	 * Gets or sets the text label for the component. By default, the label text appears centered on the button.
	 * 
	 * @default ""
	 */
    @:keep public var label(get, set):String;

    /**
	 * Position of the label in relation to button in which it is contained.
	 * 
	 * <p>You can use the following constants to set this property:</p>
	 * 
	 * <ul>
	 * 	<li>BPlacement.LEFT</li>
	 * 	<li>BPlacement.RIGHT</li>
	 * 	<li>BPlacement.TOP</li>
	 * 	<li>BPlacement.BOTTOM</li>
	 * 	<li>BPlacement.CENTER</li>
	 * 	<li>BPlacement.TOP_LEFT</li>
	 * 	<li>BPlacement.BOTTOM_LEFT</li>
	 * 	<li>BPlacement.TOP_RIGHT</li>
	 * 	<li>BPlacement.BOTTOM_RIGHT</li>
	 * </ul>
	 * 
	 * @default BPlacement.LEFT
	 */
    public var labelPlacement(get, set):BPlacement;

    /**
	 * Gets or sets a Boolean value that indicates whether a toggle button is toggled in the on or off position. 
	 * A value of <code>true</code> indicates that it is toggled in the on position; 
	 * a value of <code>false</code> indicates that it is toggled in the off position. 
	 * This property can be set only if the toggle property is set to true.
	 * 
	 * <p>For a BCheckBox component, this value indicates whether the box displays a check mark. 
	 * For a BRadioButton component, this value indicates whether the component is selected.</p>
	 * 
	 * <p>The user can change this property by clicking the component, but you can also set this property programmatically.</p>
	 * 
	 * <p>If the toggle property is set to <code>true</code>, changing this property also dispatches a change event.</p>
	 * 
	 * @default false
	 */
    public var selected(get, set):Bool;

    /**
	 * A reference to the component's internal text field.
	 */
    public var textField(get, never):TextField;

    /**
	 * Gets or sets a Number value for padding of the text and icon.
	 */
    public var textPadding(get, set):Float;

    /**
	 * Gets or sets a Boolean value that indicates whether a button can be toggled. 
	 * A value of <code>true</code> indicates that it can; 
	 * a value of <code>false</code> indicates that it cannot.
	 * 
	 * <p>If this value is true, clicking the button toggles it between selected and unselected _states. 
	 * You can get or set this state programmatically by using the selected property.</p>
	 * 
	 * <p>If this value is false, the button does not stay pressed after the user releases it. In this case, its selected property is always false.</p>
	 * 
	 * <p><strong>Note:</strong> When the toggle is set to false, selected is forced to false because only toggle buttons can be selected.</p>
	 * 
	 * @default false
	 */
    public var toggle(get, set):Bool;

    /**
	 * Gets or sets the icon for the component.
	 * 
	 * <p>This has the same effect as using the setIcon() function add passining a value to the all paramenter.</p>
	 * 
	 * <p>Setting a value of <code>null</code> will remove the current icon.</p>
	 * 
	 * @see #setIcon
	 */
    public var icon(get, set):DisplayObject;

    /**
	 * Gets or sets whether the button should auto size in length with the label
	 */
    public var autoSize(get, set):Bool;


    // assets
    private var _labelText:BLabel;

    private var _upIcon:DisplayObject;
    private var _overIcon:DisplayObject;
    private var _downIcon:DisplayObject;
    private var _disabledIcon:DisplayObject;

    private var _selectedUpIcon:DisplayObject;
    private var _selectedDownIcon:DisplayObject;
    private var _selectedOverIcon:DisplayObject;
    private var _selectedDisabledIcon:DisplayObject;


    // text stuff
    private var _enabledTF:TextFormat;
    private var _disabledTF:TextFormat;
    private var _disabledTextAlpha:Float = 0.5;


    // other
    private var _icons:Array<Dynamic>;
    private var _allIconsSameFlag:Bool = false;
    private var _iconBoundsFlag:Bool = false;


    // set and get
    private var _label:String;
    private var _labelPlacement:BPlacement = BPlacement.CENTER;
    private var _iconPlacement:BPlacement = BPlacement.CENTER;
    //protected var _autoRepaet:Boolean;			//
    private var _selected:Bool;
    private var _toggle:Bool = false; // Gets or sets a Boolean value that indicates whether a button can be toggled.
    private var _icon:DisplayObject; //
    private var _autoSize:Bool = true; // Gets or sets whether the button should auto size in length with the label
    private var _textPadding:Float = 5; // The spacing between the text and the edges of the component, and the spacing between the text and the icon, in pixels. The default value is 5.


    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BLabelButton component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
	 * @param	label The text label for the component.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, label:String = "")
    {
        _label = label;
        super(parent, x, y);
    }


    /**
	 * @inheritDoc
	 * 
	 * @param	event
	 */
    override private function mouseHandler(event:MouseEvent):Void
    {
        //trace("mouse event recieved!: " + event.type);
        // if the button is not enabled set the disabeled skins and skip everything
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

        // if this button was clicked on set selected
        // selected can only be set if the the toggle property is true
        if(event.type == MouseEvent.CLICK)
        {
            // set selected to not selected
            selected = !selected;

            // only if selected is true, dispatch a new select event
            if(selected)
            {
                // dispatch a new selecte event
                dispatchEvent(new Event(Event.SELECT, false, false));
            }

        } // end if  

        // this is a toggle button and it is selected, use the selecetd _states
        // a button cant be selected unless is it a toggle button, so having the _toogle condition is unneccessary.    
        // see BLableButton.selected    
        if(_toggle && _selected)
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
            } // end switch
        }
        else // else if it is not a toggle button and not selected, use the normal skins
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
            } // end switch
        }

    } // end function


    //************************************* FUNCTIONS ******************************************


    /**
	 * @inheritDoc
	 */
    override private function initialize():Void
    {
        super.initialize();

        // initialize label
        _labelText = new BLabel(null, _textPadding, 0, _label);
        _labelText.autoSize = TextFieldAutoSize.LEFT;
        labelPlacement = BPlacement.LEFT;

        // icons
        _upIcon = new Sprite();
        _overIcon = new Sprite();
        _downIcon = new Sprite();
        _disabledIcon = new Sprite();

        _selectedUpIcon = new Sprite();
        _selectedOverIcon = new Sprite();
        _selectedDownIcon = new Sprite();
        _selectedDisabledIcon = new Sprite();


        // add assets to respective containers
        addChild(_labelText);

        addChild(_upIcon);
        addChild(_overIcon);
        addChild(_downIcon);
        addChild(_disabledIcon);

        addChild(_selectedUpIcon);
        addChild(_selectedOverIcon);
        addChild(_selectedDownIcon);
        addChild(_selectedDisabledIcon);


        // add the icons to the icon array
        _icons = [_upIcon, _overIcon, _downIcon, _disabledIcon, _selectedUpIcon, _selectedOverIcon, _selectedDownIcon, _selectedDisabledIcon];
        changeState(_upSkin);

        // event handling
        addEventListener(MouseEvent.CLICK, mouseHandler);
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        // if label is blank, remove it
        if(_labelText.text == "")
        {
            if(_labelText.parent != null)
            {
                //removeChild(labelText);
            }
        }
        else
        {
            addChild(_labelText);
        } // if autoSize then adjust the width of the button automatically


        if(_autoSize)
        {
            if(_labelText.text != "")
            {
                _width = _labelText.width + _textPadding * 2;
            }
        } // reposition the label


        positionLabel(_labelPlacement);

        // reposition the icons
        if(!_iconBoundsFlag)
            positionIcons();


        // needs to be called last, not sure why yet
        super.draw();
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function changeState(state:DisplayObject):Void
    {
        super.changeState(state);

        if(_allIconsSameFlag)
        {
            _upIcon.visible = _allIconsSameFlag;
            return;
        }

        for(i in 0..._states.length)
        {
            var tempState:DisplayObject = _states[i];
            var tempIcon:DisplayObject = _icons[i];

            if(state == tempState)
            {
                //tempState.visible = true;
                tempIcon.visible = true;
            }
            else
            {
                //tempState.visible = false;
                tempIcon.visible = false;
            }
        } // end for
    } // end function


    /**
     * 
	 * 
     * @param	all
     * @param	upIcon
     * @param	overIcon
     * @param	downIcon
     * @param	disabledIcon
     * @param	selectedUpIcon
     * @param	selectedOverIcon
     * @param	selectedDownIcon
     * @param	selectedDisabledIcon
     */
    public function setIcon(all:DisplayObject = null, upIcon:DisplayObject = null, overIcon:DisplayObject = null, downIcon:DisplayObject = null, disabledIcon:DisplayObject = null, selectedUpIcon:DisplayObject = null, selectedOverIcon:DisplayObject = null, selectedDownIcon:DisplayObject = null, selectedDisabledIcon:DisplayObject = null):Void
    {
        _allIconsSameFlag = false; // flag to false arbitrarily

        // create temporary icons to hold the previous icons
        var tempUpIcon:DisplayObject = _upIcon;
        var tempOverIcon:DisplayObject = _overIcon;
        var tempDownIcon:DisplayObject = _downIcon;
        var tempDisabledIcon:DisplayObject = _disabledIcon;
        var tempSelectedUpIcon:DisplayObject = _selectedUpIcon;
        var tempSelectedOverIcon:DisplayObject = _selectedOverIcon;
        var tempSelectedDownIcon:DisplayObject = _selectedDownIcon;
        var tempSelectedDisabledIcon:DisplayObject = _selectedDisabledIcon;


        // remove all Icons
        if(_upIcon.parent != null) _upIcon.parent.removeChild(_upIcon);
        if(_overIcon.parent != null) _overIcon.parent.removeChild(_overIcon);
        if(_downIcon.parent != null) _downIcon.parent.removeChild(_downIcon);
        if(_disabledIcon.parent != null) _disabledIcon.parent.removeChild(_disabledIcon);
        if(_selectedUpIcon.parent != null) _selectedUpIcon.parent.removeChild(_selectedUpIcon);
        if(_selectedOverIcon.parent != null) _selectedOverIcon.parent.removeChild(_selectedOverIcon);
        if(_selectedDownIcon.parent != null) _selectedDownIcon.parent.removeChild(_selectedDownIcon);
        if(_selectedDisabledIcon.parent != null) _selectedDisabledIcon.parent.removeChild(_selectedDisabledIcon);


        // if all is set, then make all the icons for each state the same
        if(all != null)
        {
            //set Icons
            _upIcon = all;
            _overIcon = all;
            _downIcon = all;
            _disabledIcon = all;
            _selectedUpIcon = all;
            _selectedOverIcon = all;
            _selectedDownIcon = all;
            _selectedDisabledIcon = all;

            _allIconsSameFlag = true;
            //trace("All icons the same.");
        }
            // add the Icons
        else if(upIcon == null &&
        overIcon == null &&
        downIcon == null &&
        disabledIcon == null &&
        selectedUpIcon == null &&
        selectedOverIcon == null &&
        selectedDownIcon == null &&
        selectedDisabledIcon == null) // if all are null, then return. No icons should be set
        {
            //trace("clear icons!");
            return;
        }
        else // 
        {
            _upIcon = (upIcon != null) ? upIcon : tempUpIcon;
            _overIcon = (overIcon != null) ? overIcon : tempOverIcon;
            _downIcon = (downIcon != null) ? downIcon : tempDownIcon;
            _disabledIcon = (disabledIcon != null) ? disabledIcon : tempDisabledIcon;
            _selectedUpIcon = (selectedUpIcon != null) ? selectedUpIcon : tempSelectedUpIcon;
            _selectedOverIcon = (selectedOverIcon != null) ? selectedOverIcon : tempSelectedOverIcon;
            _selectedDownIcon = (selectedDownIcon != null) ? selectedDownIcon : tempSelectedDownIcon;
            _selectedDisabledIcon = (selectedDisabledIcon != null) ? selectedDisabledIcon : tempSelectedDisabledIcon;
            //trace("Icons are diferent.");
        }


        addChild(_upIcon);
        addChild(_overIcon);
        addChild(_downIcon);
        addChild(_disabledIcon);
        addChild(_selectedUpIcon);
        addChild(_selectedOverIcon);
        addChild(_selectedDownIcon);
        addChild(_selectedDisabledIcon);


        // recreate/fill the _states array
        _icons = [_upIcon, _overIcon, _downIcon, _disabledIcon, _selectedUpIcon, _selectedOverIcon, _selectedDownIcon, _selectedDisabledIcon];
        changeState(_currentState);

        // set the position of the new icons
        positionIcons();
    } // end function


    /**
	 * 
	 * 
	 * @param	x
	 * @param	y
	 * @param	width
	 * @param	height
	 * @param	rotation
	 */
    public function setIconBounds(x:Float, y:Float, width:Float = 0, height:Float = 0, rotation:Float = 0):Void
    {
        var icon:DisplayObject;
        _iconBoundsFlag = true;

        for(i in 0..._icons.length)
        {
            icon = _icons[i];

            icon.x = x;
            icon.y = y;
            if(width > 0)
            {
                icon.width = width;
            }
            if(height > 0)
            {
                icon.height = height;
            }

        }

        //positionIcons();

        // rotate the icons after they have been positioned (because the position icons function uses the bounds of the icon to calculate) 
        // however, changing the rotation will (usually lol) change the bounds of the a displayObject
        for(i in 0..._icons.length)
        {
            icon = _icons[i];
            icon.rotation = rotation;
        }

    } // end function


    /**
	 * 
	 * @param	placement
	 */
    private function positionLabel(placement:BPlacement):Void
    {

        switch (placement)
        {
            case BPlacement.LEFT:
                _labelText.x = _textPadding;
                _labelText.y = _height / 2 - _labelText.height / 2;

            case BPlacement.RIGHT:
                _labelText.x = _width - _labelText.width - _textPadding;
                _labelText.y = _height / 2 - _labelText.height / 2;

            case BPlacement.TOP:
                _labelText.x = _width / 2 - _labelText.width / 2;
                _labelText.y = _textPadding;

            case BPlacement.BOTTOM:
                _labelText.x = _width / 2 - _labelText.width / 2;
                _labelText.y = _height - _labelText.height - _textPadding;


            case BPlacement.TOP_LEFT:
                _labelText.x = _textPadding;
                _labelText.y = _textPadding;

            case BPlacement.TOP_RIGHT:
                _labelText.x = _width - _labelText.width - _textPadding;
                _labelText.y = _textPadding;

            case BPlacement.BOTTOM_LEFT:
                _labelText.x = _textPadding;
                _labelText.y = _height - _labelText.height - _textPadding;

            case BPlacement.BOTTOM_RIGHT:
                _labelText.x = _width - _labelText.width - _textPadding;
                _labelText.y = _height - _labelText.height - _textPadding;

            case BPlacement.CENTER:
                _labelText.x = _width / 2 - _labelText.width / 2;
                _labelText.y = _height / 2 - _labelText.height / 2;

            default: // left
                _labelText.x = _textPadding;
                _labelText.y = _height / 2 - _labelText.height / 2;

        } // end switch  
    } // end function


    /**
	 * 
	 */
    private function positionIcons():Void
    {
        //
        var shorterSide:Float = Math.min(_width, _height);

        var widthLonger:Bool;
        var heightLonger:Bool;

        // loop through the icons array
        for(i in 0..._icons.length)
        {
            var icon:DisplayObject = _icons[i];

            // if the icon is larger than the button
            if((icon.width > _width || icon.height > _height) && !_iconBoundsFlag)
            {
                // scale each icon so that it is not larger than width or height of the button
                widthLonger = icon.width > (icon.height) ? true : false;
                heightLonger = icon.height > (icon.width) ? true : false;

                if(widthLonger)
                {
                    icon.width = shorterSide;
                    icon.scaleY = icon.scaleX;
                }
                else //if(heightLonger) // remove if part to make exact fit
                {
                    icon.height = shorterSide;
                    icon.scaleX = icon.scaleY;
                }

            } // end if  


            // position the icons based on their bounds (because just using the x and y properties wouldn't work on all cases).
            // get the difference between the x position and the center of the bounds of the icon
            var xDifference:Float = (icon.getBounds(this).left + icon.getBounds(this).right) / 2 - icon.x;
            var yDifference:Float = (icon.getBounds(this).top + icon.getBounds(this).bottom) / 2 - icon.y;

            var centerX:Float = _width / 2 - xDifference;
            var centerY:Float = _height / 2 - yDifference;
            //var top:Number = centerY - icon.height/2 + _textPadding;
            //var bottom:Number = centerY + icon.height/2 - _textPadding;
            //var left:Number = centerX - icon.width/2 + _textPadding;
            //var right:Number = centerX + icon.width / 2 - _textPadding;

            var top:Float = centerY - _height / 2 + icon.height / 2 + _textPadding;
            var bottom:Float = centerY + _height / 2 - icon.height / 2 - _textPadding;
            var left:Float = centerX - _width / 2 + icon.width / 2 + _textPadding;
            var right:Float = centerX + _width / 2 - icon.width / 2 - _textPadding;

            // set the icons position
            switch (_iconPlacement)
            {
                case BPlacement.LEFT:
                    icon.x = left;
                    icon.y = centerY;

                case BPlacement.RIGHT:
                    icon.x = right;
                    icon.y = centerY;

                case BPlacement.TOP:
                    icon.x = centerX;
                    icon.y = top;

                case BPlacement.BOTTOM:
                    icon.x = centerX;
                    icon.y = bottom;


                case BPlacement.TOP_LEFT:
                    icon.x = left;
                    icon.y = top;

                case BPlacement.TOP_RIGHT:
                    icon.x = right;
                    icon.y = top;

                case BPlacement.BOTTOM_LEFT:
                    icon.x = left;
                    icon.y = bottom;

                case BPlacement.BOTTOM_RIGHT:
                    icon.x = right;
                    icon.y = bottom;

                case BPlacement.CENTER:
                    icon.x = centerX;
                    icon.y = centerY;

                default:
                    icon.x = centerX;
                    icon.y = centerY;
            } // end switch

            if(icon.scrollRect != null)
            {
                var scrollRectRatio:Float = icon.scrollRect.width / icon.width;
                var scaleRatio = icon.scaleX * scrollRectRatio;
                icon.scaleX *= scaleRatio;
                icon.scaleY = icon.scaleX;
                icon.x = icon.y = 0;
                //icon.x -= (icon.scrollRect.x + icon.scrollRect.width);
                //icon.y -= (icon.scrollRect.y + icon.scrollRect.height);
                //icon.x -= icon.scrollRect.x;
                //icon.y -= icon.scrollRect.y;
            } // end if

        } // end for
    } // end function


    //***************************************** SET AND GET *****************************************


    private function get_iconPlacement():BPlacement
    {
        return _iconPlacement;
    }

    private function set_iconPlacement(value:BPlacement):BPlacement
    {
        _iconPlacement = value;
        positionIcons();
        return value;
    }


    private function get_label():String
    {
        return _label;
    }

    private function set_label(value:String):String
    {
        _label = value;
        _labelText.text = _label;
        return value;
    }


    private function get_labelPlacement():BPlacement
    {
        return _labelPlacement;
    }

    private function set_labelPlacement(value:BPlacement):BPlacement
    {
        _labelPlacement = value;
        positionLabel(value);
        return value;
    }


    private function get_selected():Bool
    {
        return _selected;
    }

    private function set_selected(value:Bool):Bool
    {
        // if this is not a toggle button, then it cannot be selected
        if(!_toggle)
        {
            _selected = false;
        }

        // change the state to ensure the correct state is active
        // when the selected property via BLabel.selected = x, rather then a mouse event being dispatched.
        // (you are allowed to set the selected property even if the button is disabled)    
        if(value)
        {
            if(_enabled)
            {
                changeState(_selectedUpSkin);
            }
            else
            {
                changeState(_selectedDisabledSkin);
            }
        }
        else
        {
            if(_enabled)
            {
                changeState(_upSkin);
            }
            else
            {
                changeState(_disabledSkin);
            }
        }

        _selected = value;
        return value;
    }


    private function get_textField():TextField
    {
        return _labelText.textField;
    }


    private function get_textPadding():Float
    {
        return _textPadding;
    }

    private function set_textPadding(value:Float):Float
    {
        _textPadding = value;
        positionLabel(_labelPlacement);
        return value;
    }


    private function get_toggle():Bool
    {
        return _toggle;
    }

    private function set_toggle(value:Bool):Bool
    {
        _toggle = value;

        if(!value)
        {
            selected = false;
        }
        return value;
    }


    private function get_icon():DisplayObject
    {
        return _upIcon;
    }

    private function set_icon(value:DisplayObject):DisplayObject
    {
        if(value != null)
        {
            setIcon(value);
        }
        else
        {
            setIcon();
        }
        return value;
    }


    private function get_autoSize():Bool
    {
        return _autoSize;
    }

    private function set_autoSize(value:Bool):Bool
    {
        _autoSize = value;
        draw();
        return value;
    }


    override private function set_enabled(value:Bool):Bool
    {
        super.enabled = value;

        // change the state to ensure the correct state is active
        // when the enabled property via BLabel.enabled = x.
        if(value)
        {
            if(_selected)
            {
                changeState(_selectedUpSkin);
            }
            else
            {
                changeState(_upSkin);
            }
        }
        else
        {
            if(_selected)
            {
                changeState(_selectedDisabledSkin);
            }
            else
            {
                changeState(_disabledSkin);
            }
        }
        return value;
    }
}

