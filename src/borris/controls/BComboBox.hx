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

import borris.controls.BUIComponent;
import borris.display.BElement;

import motion.Actuate;

import openfl.display.Shape;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.utils.Timer;


/**
 * The BComboBox component contains a drop-down list from which the user can select one value.
 * Its functionality is similar to that of the SELECT form element in HTML.
 * The BComboBox component can be editable, in which case the user can type entries that
 * are not in the list into the TextInput portion of the BComboBox component.
 *
 * @author Rohaan Allport
 * @creation-date 09/10/2014 (dd/mm/yyyy)
*/
class BComboBox extends BUIComponent
{
	/**
	 * Gets a reference to the BList component that the BComboBox component contains. 
	 */
    public var dropdown(get, never):BList;
	
	/**
	 * Gets a reference to the BTextInput component that the BComboBox component contains. 
	 */
    public var textField(get, never):BTextInput;
    
	/**
	 * Gets or sets a Boolean value that indicates whether the BComboBox component is editable or read-only. 
	 * A value of <code>true</code> indicates that the BComboBox component is editable; 
	 * a value of <code>false</code> indicates that it is not.
	 * 
	 * <p>In an editable ComboBox component, a user can enter values into the text box that do not appear in the drop-down list. The text box displays the text of the item in the list. If a ComboBox component is not editable, text cannot be entered into the text box.</p>
	 * 
	 * @default false;
	 */
	public var editable(get, set):Bool;
    
	/**
	 * Gets the number of items in the list. This property belongs to the BList component but can be accessed from a BComboBox instance.
	 */
	public var length(get, never):Int;
    
	/**
	 * Gets or sets the characters that a user can enter in the text field. 
	 * If the value of the restrict property is a string of characters, 
	 * you can enter only characters in the string into the text field. 
	 * The string is read from left to right. If the value of the restrict property is null, you can enter any character. 
	 * If the value of the restrict property is an empty string (""), you cannot enter any character. 
	 * You can specify a range by using the hyphen (-) character. 
	 * This restricts only user interaction; a script can put any character into the text field.
	 * 
	 * @default null
	 */
	public var restrict(get, set):String;
    
	/**
	 * Gets or sets the maximum number of rows that can appear in a drop-down list that does not have a scroll bar. 
	 * If the number of items in the drop-down list exceeds this value, the list is resized and a scroll bar is displayed, 
	 * if necessary. If the number of items in the drop-down list is less than this value, the drop-down list is resized 
	 * to accommodate the number of items that it contains.
	 * 
	 * <p>This behavior differs from that of the List component, which always shows the number of rows specified 
	 * by its rowCount property, even if this includes empty space.</p>
	 * 
	 * @default 0
	 */
	public var rowCount(get, never):Int;
    
	/**
	 * Gets or sets the index of the item that is selected in a single-selection list. A single-selection list is a list in which only one item can be selected at a time.
	 * 
	 * <p>A value of -1 indicates that no item is selected; if multiple selections are made, 
	 * this value is equal to the index of the item that was selected last in the group of selected items.</p>
	 * 
	 */
	public var selectedIndex(get, set):Int;
    
	 /**
	 * Gets or sets the value of the item that is selected in the drop-down list. 
	 * If the user enters text into the text box of an editable ComboBox component, the selectedItem property is undefined. 
	 * If the ComboBox component is not editable, the value of the selectedItem property is always valid. 
	 * If there are no items in the drop-down list of an editable ComboBox component, the value of this property is null.
	 * 
	 * @default null
	 */
	public var selectedItem(get, set):Dynamic;
    
	/**
	 * Gets the string that is displayed in the TextInput portion of the ComboBox component. 
	 * This value is calculated from the data by using the labelField or labelFunction property.
	 */
	public var selectedLabel(get, never):String;
    
	/**
	 * Gets or sets the text that the text box contains in an editable ComboBox component. 
	 * For ComboBox components that are not editable, this value is read-only.
	 * 
	 * @default ""
	 */
	public var text(get, set):String;
    
	/**
	 * Gets or sets the position of the list.
	 * 
	 * <p>You can use the following constants to set this property:</p>
	 * 
	 * <ul>
	 * 	<li>BPlacement.LEFT</li>
	 * 	<li>BPlacement.RIGHT</li>
	 * 	<li>BPlacement.TOP</li>
	 * 	<li>BPlacement.BOTTOM</li>
	 * 	<li>BPlacement.CENTER</li>
	 * </ul>
	 * 
	 * @default BPlacement.CENTER
	 */
	public var listPlacement(get, set):BPlacement;

    
	// assets
    private var _button:BLabelButton;
    private var _inputText:BTextInput;
    private var _arrowIcon:Shape;
    
    // other
    private var _listMask:Shape;
    private var _showList:Bool;  // A flag boolean for toggling the dropdown.  
    
    // set and get
    private var _dropdown:BList;  // [read-only] Gets a reference to the List component that the ComboBox component contains.  
    private var _editable:Bool = false;  //  
    private var _listPlacement:BPlacement = BPlacement.CENTER;  //  
    
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BComboBox component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
		super(parent, x, y);
        initialize();
        setSize(200, 30);
    }
    
    
    //**************************************** HANDLERS *********************************************
    
    /**
	 * 
	 * @param	event
	 */
    private function mouseDownHandler(event:MouseEvent):Void
    {
        event.stopImmediatePropagation();

		// TODO find out why focusung won't work.
		parent.setChildIndex(this, parent.numChildren -1);

        //trace("Current Target: " + event.currentTarget);
        if(event.currentTarget == _button)
        {
            toggleDropdown(_showList);
        }
    } // end function


    private function mouseDownHandler2(event:MouseEvent):Void
    {
        event.stopImmediatePropagation();

        if(event.currentTarget == stage)
        {
            if(!hitTestPoint(event.stageX, event.stageY, true))
            {
                hideDropdown();
            }
        }
    } // end function
    
    
    /**
	 * 
	 * @param	event
	 */
    private function dropdownChangeHander(event:Event):Void
    {
        event.stopImmediatePropagation();
        
        _button.label = cast(cast(_dropdown.selectedItem).label, String);
        _inputText.text = cast(cast(_dropdown.selectedItem).label, String);
        hideDropdown();
        
        dispatchEvent(event);
    } // end function
    
    
    
    //************************************* FUNCTIONS ******************************************
    
    
    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();
        
        // initialize the button;
        _button = new BLabelButton(this, 0, 0, "Label");
        _button.autoSize = false;
		//_button.toggle = true;
		_button.setStateColors(0x0000, 0x000000, 0x333333, 0x000000, 0x000000, 0x000000, 0x333333, 0x000000);
		
        // initialize the text input
        _inputText = new BTextInput(null, 0, 0, "text");
        
        // icons
        _arrowIcon = new Shape();
        _arrowIcon.graphics.lineStyle(1, 0xCCCCCC, 1, false, "normal", "none");
        _arrowIcon.graphics.moveTo(-2.5, -5);
        _arrowIcon.graphics.lineTo(2.5, 0);
        _arrowIcon.graphics.lineTo(-2.5, 5);
        
        _button.icon = _arrowIcon;
        _button.setIconBounds(_width - _height / 2, _height / 2);
        
        // initialize the dropdown (the BList)
        _dropdown = new BList(this, _width, _button.height);
        _dropdown.visible = false;
		_showList = true;
        
        
        // initialize listMask
        _listMask = new Shape();
        _listMask.graphics.beginFill(0xFF00FF, 1);
        _listMask.graphics.drawRect(0, 0, 100, 100);
        _listMask.graphics.endFill();
        _listMask.x = 0;
        _listMask.y = 0;
        _dropdown.mask = _listMask;
        
		
        // add assets
        addChild(_listMask);
        
        // draw the combo box
        draw();
        
        // event handling
        _button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        _inputText.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        _dropdown.addEventListener(Event.CHANGE, dropdownChangeHander);
    } // end function
    
    
    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        super.draw();
        
        var strokeThickness:Int = 2;
        
        //
        _button.width = _width;
        _button.height = _height;
        
        //
        _inputText.width = _width;
        _inputText.height = _height;
        
        //
        _button.visible = !_editable;
        _inputText.visible = _editable;
        
        //
        _arrowIcon.x = _width - _height / 2;
        _arrowIcon.y = _height / 2;
        //button.setIconBounds(_width - _height/2, _height/2);
        
        //
        _dropdown.width = _width;
        
        //
        //listMask.x = 0;
        //listMask.y = _height;
        _listMask.width = _width;
        _listMask.height = _dropdown.height;
        
		// BUG for some reason background color wont change.
        // draw button skins
        cast((_button.getSkin("upSkin")), BElement).style.backgroundColor = 0x000000;
        cast((_button.getSkin("upSkin")), BElement).style.backgroundOpacity = 1;
        cast((_button.getSkin("upSkin")), BElement).style.borderColor = 0x666666;
        cast((_button.getSkin("upSkin")), BElement).style.borderOpacity = 1;
        cast((_button.getSkin("upSkin")), BElement).style.borderWidth = 2;
        
        cast((_button.getSkin("overSkin")), BElement).style.backgroundColor = 0x000000;
        cast((_button.getSkin("overSkin")), BElement).style.backgroundOpacity = 1;
        cast((_button.getSkin("overSkin")), BElement).style.borderColor = 0x999999;
        cast((_button.getSkin("overSkin")), BElement).style.borderOpacity = 1;
        cast((_button.getSkin("overSkin")), BElement).style.borderWidth = 2;
        
        cast((_button.getSkin("downSkin")), BElement).style.backgroundColor = 0x333333;
        cast((_button.getSkin("downSkin")), BElement).style.backgroundOpacity = 1;
        cast((_button.getSkin("downSkin")), BElement).style.borderColor = 0x666666;
        cast((_button.getSkin("downSkin")), BElement).style.borderOpacity = 1;
        cast((_button.getSkin("downSkin")), BElement).style.borderWidth = 2;
		
    } // end function
    
    
    /**
	 * 
	 * @param	showList
	 */
    private function toggleDropdown(showList:Bool = true):Void
    {
        if(showList) 
        {
            showDropdown();
        }
        else 
		{
            hideDropdown();
        }
		
    } // end function
    
    
    /**
	 * Displays the list.
	 */
    private function showDropdown():Void
    {
        // BUG (easy fix) fixes bug where dropdown is not the width of the combobox, due to not drawing
        // another fix is calling the draw function in the BUIComponent.setSize() function
        //_dropdown.width = _width;
        
        Actuate.tween(_dropdown, 0.3, { alpha: 1} );
		
        switch (_listPlacement)
        {
            /* 
			 * It is important that we set the position of the mask and dropdown for each (most) case(s)
			 */
            
            /*case BPlacement.CENTER:
                // in center mode, we tween the mask instead
                _dropdown.x = 0;
                _dropdown.y = -_dropdown.height / 2 + _height / 2;
                _listMask.y = _height / 2;
                Actuate.tween(_listMask, 0.3, { y: (-_dropdown.height / 2 + _height / 2), height: _dropdown.height} );
                setChildIndex(_dropdown, numChildren - 1);
                _arrowIcon.visible = false;
                _arrowIcon.rotation = -90;*/
            
            case BPlacement.TOP:
                _listMask.x = 0;
                _listMask.y = -_dropdown.height;
                _dropdown.x = 0;
                Actuate.tween(_dropdown, 0.3, {y: - _dropdown.height});
				Actuate.tween(_arrowIcon, 0.3, {rotation: -90});
            
            case BPlacement.BOTTOM:
                _listMask.x = 0;
                _listMask.y = _height;
                _dropdown.x = 0;
                Actuate.tween(_dropdown, 0.3, {y: _height});
				Actuate.tween(_arrowIcon, 0.3, {rotation: 90});
            
            case BPlacement.LEFT:
                _listMask.x = -_dropdown.width;
                _listMask.y = 0;
                _dropdown.y = 0;
                Actuate.tween(_dropdown, 0.3, {x: - _dropdown.width});
				Actuate.tween(_arrowIcon, 0.3, {rotation: 180});
            
            case BPlacement.RIGHT:
                _listMask.x = _dropdown.width;
                _listMask.y = 0;
                _dropdown.y = 0;
                Actuate.tween(_dropdown, 0.3, {x: _dropdown.width});
				Actuate.tween(_arrowIcon, 0.3, {rotation: 0});
				
			default: // center
				_dropdown.x = 0;
                _dropdown.y = -_dropdown.height / 2 + _height / 2;
                _listMask.y = _height / 2;
				Actuate.tween(_listMask, 0.3, { y: (-_dropdown.height / 2 + _height / 2), height: _dropdown.height} );
                setChildIndex(_dropdown, numChildren - 1);
                _arrowIcon.visible = false;
                _arrowIcon.rotation = -90;
				
        } // end switch
        
        _dropdown.visible = true;
        setChildIndex(_dropdown, numChildren - 1);
		
        stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler2);
        _showList = false;
    } // end function
    
    
    /**
	 * Hides the list.
	 */
    private function hideDropdown():Void
    {
        Actuate.tween(_dropdown, 0.3, {alpha: 0});
        
        switch (_listPlacement)
        {
            case BPlacement.CENTER:
                Actuate.tween(_listMask, 0.3, {y: _height / 2});
                setChildIndex(_dropdown, 0);
                _arrowIcon.visible = true;
            
            case BPlacement.TOP:
                Actuate.tween(_dropdown, 0.3, {y: 0});
				Actuate.tween(_arrowIcon, 0.3, {rotation: 90});
            
            case BPlacement.BOTTOM:
                Actuate.tween(_dropdown, 0.3, {y: _height - _dropdown.height});
				Actuate.tween(_arrowIcon, 0.3, {rotation: -90});
            
            case BPlacement.LEFT:
                Actuate.tween(_dropdown, 0.3, {x: 0});
				Actuate.tween(_arrowIcon, 0.3, {rotation: 0});
            
            case BPlacement.RIGHT:
				Actuate.tween(_dropdown, 0.3, {x: 0});
				Actuate.tween(_arrowIcon, 0.3, {rotation: 180});
				
			default: // center
				Actuate.tween(_listMask, 0.3, {y: _height / 2});
                setChildIndex(_dropdown, 0);
                _arrowIcon.visible = true;
				
        }  // create a timer and event listener to set the visibility of the list to false after a giving time  
        
        
        
        var visibilityTimer:Timer = new Timer(300, 1);
        visibilityTimer.addEventListener(TimerEvent.TIMER_COMPLETE,
                function(event:TimerEvent):Void
                {
                    _dropdown.visible = false;
                }
                );
        visibilityTimer.start();
        
        
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler2);
        _showList = true;
    } // end function
    
    
    //*************************************** SET AND GET **************************************
    
	
    private function get_dropdown():BList
    {
        return _dropdown;
    }
    
    
    private function get_textField():BTextInput
    {
        return _inputText;
    }
    
    
    private function get_editable():Bool
    {
        return _editable;
    }
    private function set_editable(value:Bool):Bool
    {
        _editable = value;
        draw();
        return value;
    }
    
    
    private function get_length():Int
    {
        return _dropdown.length;
    }
    
    
    private function get_restrict():String
    {
        return _inputText.restrict;
    }
    private function set_restrict(value:String):String
    {
        _inputText.restrict = value;
        return value;
    }
    
    
    private function get_rowCount():Int
    {
        return _dropdown.rowCount;
    }
    /*public function set rowCount(value:uint):void
		{
			_dropdown.rowCount = value;
		}*/
    
    
    private function get_selectedIndex():Int
    {
        return _dropdown.selectedIndex;
    }
    private function set_selectedIndex(value:Int):Int
    {
        _dropdown.selectedIndex = value;
        _button.label = _inputText.text = _dropdown.getItemAt(value).label;
        return value;
    }
    
    
    private function get_selectedItem():Dynamic
    {
        return _dropdown.selectedItem;
    }
    private function set_selectedItem(value:Dynamic):Dynamic
    {
        _dropdown.selectedItem = value;
        _button.label = _inputText.text = value.label;
        return value;
    }
    
    
    private function get_selectedLabel():String
    {
        return dropdown.selectedItem.label;
    }
    
    
    private function get_text():String
    {
        return _inputText.text;
    }
    private function set_text(value:String):String
    {
        _inputText.text = value;
        return value;
    }
    
    
    // value
    /*public function get value():String
		{
			
		}*/
    
    
    private function get_listPlacement():BPlacement
    {
        return _listPlacement;
    }
    private function set_listPlacement(value:BPlacement):BPlacement
    {
        switch (value)
        {
            case BPlacement.CENTER:
                _dropdown.x = 0;
                _dropdown.y = -_dropdown.height / 2 + _height / 2;
                _arrowIcon.rotation = -90;
            
            case BPlacement.TOP:
                _listMask.x = 0;
                _listMask.y = -_dropdown.height;
                _dropdown.x = 0;
                _arrowIcon.rotation = -90;
            
            case BPlacement.BOTTOM:
                _listMask.x = 0;
                _listMask.y = _height;
                _dropdown.x = 0;
                _arrowIcon.rotation = -90;
            
            case BPlacement.LEFT:
                _listMask.x = -_dropdown.width;
                _listMask.y = 0;
                _dropdown.y = 0;
                _arrowIcon.rotation = -90;
            
            case BPlacement.RIGHT:
                _listMask.x = _dropdown.width;
                _listMask.y = 0;
                _dropdown.y = 0;
                _arrowIcon.rotation = -90;
				
			default: // center
				_dropdown.x = 0;
                _dropdown.y = -_dropdown.height / 2 + _height / 2;
                _arrowIcon.rotation = -90;
			
        } // end switch
        
        _listPlacement = value;
        return value;
    }
}


