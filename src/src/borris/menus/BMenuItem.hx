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

package borris.menus;

import borris.controls.BLabel;
import borris.controls.BLabelButton;
import borris.menus.BMenu;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;
import openfl.text.TextFieldAutoSize;
import openfl.ui.Keyboard;

// TODO imporovemtns:
//					- Use more constants, for like text x, text y, text height. item width, item height
//					- Events to dispatch:
//						- displaying
//						- preparing
//						- select

/**
 *  The NativeMenuItem class represents a single item in a menu.
 *	A menu item can be a command, a submenu, or a separator line:
 *
 *	To create a command item, call the NativeMenuItem constructor, passing in a string for the label and false for the isSeparator parameter.
 *	To create a submenu, create a command item for the parent menu and assign the NativeMenu object of the submenu to the item's submenu property. You can also call the addSubmenu() method of the parent NativeMenu object to create the item and set the submenu property at the same time.
 *	To create a separator, call the NativeMenuItem constructor, passing in an empty string for the label and true for the isSeparator parameter.
 *
 * Note: KeyEquivalentModifier property must be set b4 keyEqivalent, both in and out of class.
 * 		- enabled, checked, and submenu should be/ are all connected
 *		- icon and checked are connected
 *		- checked and submenu are connected
 *
 * @author Rohaan Allport
 * @creation-date 103/10/2014 (dd/mm/yyyy)
 */
class BMenuItem extends EventDispatcher
{
    public var checked(get, set):Bool;
    public var data(get, set):Dynamic;
    public var enabled(get, set):Bool;
    public var isSeparator(get, never):Bool;
    // keyEquivalent
    // Set the keyEquivalent with a lowercase letter to assign a shortcut without a Shift-key modifier. Set with an uppercase letter to assign a shortcut with the Shift-key modifier.
    // By default, a key equivalent modifier (Ctrl on Windows or Linux and Command on Mac OS X) is included as part of the key equivalent. If you want the key equivalent to be a key with no modifier, set the keyEquivalentModifiers property to an empty array.
    public var keyEquivalent(get, set):String;
    public var keyEquivalentModifiers(get, set):Array<Dynamic>;
    public var label(get, set):String;
    public var menu(get, never):BMenu;
    public var mnemonicIndex(get, set):Int;
    // TODO this probably doesnt need to be a property, maybe just a variable will do
    @:allow(borris.menus)
    private var name(get, set):String;
    public var submenu(get, set):BMenu;
    public var icon(get, set):DisplayObject;
    public var x(get, set):Int;
    public var y(get, set):Int;
    public var width(get, never):Int;
    public var height(get, never):Int;

    // constants
    @:allow(borris.menus)
    private static inline var TOP_MARGIN:Int = 0; //
    @:allow(borris.menus)
    private static inline var BOTTOM_MARGIN:Int = 1; //
    @:allow(borris.menus)
    private static inline var ITEM_HEIGHT:Int = 40;

    @:allow(borris.menus)
    private static inline var SEPARATOR_TOP_MARGIN:Int = 2; //
    @:allow(borris.menus)
    private static inline var SEPARATOR_BOTTOM_MARGIN:Int = 2; //
    @:allow(borris.menus)
    private static inline var SEPARATOR_HEIGHT:Int = 2;

    @:allow(borris.menus)
    private static inline var LEFT_BORDER_WIDTH:Int = 2; //
    @:allow(borris.menus)
    private static inline var RIGHT_BORDER_WIDTH:Int = 2; //

    @:allow(borris.menus)
    private static inline var ICON_WIDTH:Int = 40; //
    @:allow(borris.menus)
    private static inline var TEXT_ICON_SPACING:Int = 8; //
    @:allow(borris.menus)
    private static inline var ARROW_ICON_SPACING:Int = 16; //
    @:allow(borris.menus)
    private static inline var TEXT_SPACING:Int = 32; //


    // assets
    @:allow(borris.menus)
    private var _container:Sprite;
    private var _button:BLabelButton;

    // context menu assets
    private var _arrowIcon:DisplayObject;


    // text fields and formats
    private var _keyEquivalentText:BLabel;


    // other
    @:allow(borris.menus)
    private static var _longestTotalWidth:Int = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING;
    private var _totalWidth:Int = 340;
    @:allow(borris.menus)
    private var _submenuRolledOver:Bool = false; //
    private var _offset:Float = 0;


    // Set and get
    private var _checked:Bool; // Controls whether this menu item displays a checkmark.
    private var _data:Dynamic; // An arbitrary data object associated with this menu item.
    private var _isSeparator:Bool; // [read-only] Reports whether this item is a menu separator line.
    private var _keyEquivalent:String; // The key equivalent for this menu item.
    private var _keyEquivalentModifiers:Array<Dynamic>; // The array of key codes for the key equivalent modifiers.
    @:allow(borris.menus.BMenu)
    private var _menu:BMenu; // [read-only] The menu that contains this item.
    private var _mnemonicIndex:Int = -1; // The position of the mnemonic character in the menu item label.
    private var _name:String; // The name of this menu item.
    private var _submenu:BMenu; // The submenu associated with this menu item.


    // set and get (for internal properties)
    private var _width:Int = 0; // [read-only] The width of this item
    private var _height:Int = 0; // [read-only] The height of this item


    public function new(label:String = "", isSeparator:Bool = false, enabled:Bool = true)
    {
        super();
        _container = new Sprite();

        _button = new BLabelButton(_container, 0, 0, label);
        _button.autoSize = false;

        // do setters
        _data = null;
        _isSeparator = isSeparator;
        this.label = label;
        // menu
        //this.mnemonicIndex = 0;
        // name
        // submenu


        _keyEquivalentText = new BLabel(null, 0, 0, "");
        // BUG autoSize messes up the width of the menu item
        _keyEquivalentText.autoSize = TextFieldAutoSize.LEFT;

        // calculate the width of this menu item
        //totalWidth = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING + Math.ceil(labelText.width) + Math.ceil(keyEquivalentText.width);

        if(_longestTotalWidth < _totalWidth)
        {
            _longestTotalWidth = _totalWidth;
        } // end if

        // create the assets
        //_arrowIcon = new MenuArrowIcon10x10();
        _arrowIcon = new Bitmap(Assets.getBitmapData("graphics/menu arrow icon 01 10x10.png"));
        _arrowIcon.visible = false;

        // if label is empty and _separetor is false
        if(label != "" && !_isSeparator)
        {
            setSeparator(false);
        }
        else
        {
            setSeparator(true);
        } // end else  

        // more setters
        checked = false;
        this.enabled = enabled;
        _keyEquivalentModifiers = [Keyboard.SHIFT];
        keyEquivalent = "";
    }


    //**************************************** HANDLERS *********************************************


    // function mouseHandler
    // this is for context menus
    /**
	 * 
	 * @param	event
	 */
    private function mouseHandler(event:MouseEvent):Void
    {
        // if this item was clicked on, and it does NOT have a a submenu.
        // The CLICK listener is added and removed in the "set enabled" function
        if(event.type == MouseEvent.CLICK && _submenu == null)
        {
            // dispatch a new Event.SELECT object
            dispatchEvent(new Event(Event.SELECT, true, false));

            // set checked to not checked
            checked = !checked;

            // hide the menu that contains this item
            if(!(Std.is(_menu, BApplicationMenu)))
                _menu.hide();

            return;
        } // end if  


        switch(event.type)
        {
            case MouseEvent.MOUSE_OVER:
                if(enabled)
                {
                    showSubmenu();
                } // end if

                // this loops through all the items in the menu and hides their submenu if it's not this menu that the mouse is over
                for(item in menu.items)
                {
                    if(item._submenuRolledOver && item != this)
                    {
                        item._submenuRolledOver = false;
                        item.hideSubmenu();
                    } // end if
                } // end for

        } // end switch

    } // end function


    // function mouseHandler2
    // this is for application menus
    /**
	 * 
	 * @param	event
	 */
    private function mouseHandler2(event:MouseEvent):Void
    {
        switch (event.type)
        {
            case MouseEvent.MOUSE_DOWN:
                _menu._applMenuClicked = true;

                if(_submenu != null)
                {
                    _submenu.display(_container.parent.stage, _menu.x + x, _menu.y + y + _height, false);
                } // end if

            case MouseEvent.MOUSE_OVER:
                if(enabled)
                {
                    if(_submenu != null && _menu._applMenuClicked)
                    {
                        _submenu.display(_container.parent.stage, _menu.x + x, _menu.y + y + _height, false);
                        _submenuRolledOver = true;
                    } // end if
                } // end if

                // this loops through all the items in the menu and hides their submenu if it's not this menu that the mouse is over
                for(item in menu.items)
                {
                    if(item != this)
                    {
                        item.hideSubmenu();
                    }
                } // end for
        } // end switch
    } // end function


    //**************************************** FUNCTIONS ********************************************


    /**
	 * 
	 * @return
	 */
    public function clone():BMenuItem
    {
        var newItem:BMenuItem = new BMenuItem(label, _isSeparator);
        /*if (newItem.isSeparator)
			{
				return newItem;
			}*/
        //newItem.label = label;
        if(_data) newItem.data = _data;
        newItem.enabled = enabled;
        if(_keyEquivalent != null) newItem.keyEquivalent = _keyEquivalent;
        newItem.keyEquivalentModifiers = _keyEquivalentModifiers;
        //newItem.menu = _menu; [read-only]
        if(_mnemonicIndex != -1) newItem.mnemonicIndex = _mnemonicIndex;
        if(_name != null) newItem.name = _name;
        if(_submenu != null) newItem.submenu = _submenu.clone();

        return newItem;
    } // end function


    /**
	 * [override] Returns a string containing all the properties of the BMenuItem object.
	 * 
	 * @return
	 */
    override public function toString():String
    {
        var s:String = "BMenuItem | \n";
        //s += "\t: " + this + "\n";
        s += "\tchecked: " + checked + "\n";
        s += "\tdata: " + _data + "\n";
        s += "\tenabled: " + enabled + "\n";
        s += "\tisSeparator: " + _isSeparator + "\n";
        s += "\tkeyEquivalent: " + _keyEquivalent + "\n";
        s += "\tkeyEquivalentModifiers: " + _keyEquivalentModifiers + "\n";
        s += "\tlabel: " + label + "\n";
        s += "\tmenu: " + Std.string(_menu) + "\n";
        s += "\tmnemonicIndex: " + _mnemonicIndex + "\n";
        s += "\tname: " + _name + "\n";
        s += "\tsubmenu: " + _submenu + "\n";


        return s;
    } // end function


    /**
	 * 
	 */
    @:allow(borris.menus.BMenu)
    private function draw():Void
    {
        // calculate the width of this menu item
        // this SHIT cost me like 10 hours to fix!
        //totalWidth = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING + Math.ceil(labelText.width) + Math.ceil(keyEquivalentText.width);

        // TODO make as enum
        function tickIcon():DisplayObject
        {
            var tickIcon = new Bitmap(Assets.getBitmapData("graphics/tick icon.png"));
            return tickIcon;
        } // end function


        if(_longestTotalWidth < _totalWidth)
        {
            _longestTotalWidth = _totalWidth;
        } // end if


        if(_isSeparator)
        {
            _keyEquivalentText.visible = false;

            _button.x = 10;
            _button.width = _longestTotalWidth - 20;
            _button.height = 1;
            _button.setStateColors(0xCCCCCC, 0xCCCCCC, 0xCCCCCC, 0xCCCCCC, 0xCCCCCC, 0xCCCCCC, 0xCCCCCC, 0xCCCCCC);
            _button.setIcon(null);

            return;
        }
        else if(!_isSeparator)
        {
            var buttonWidth:Int = _longestTotalWidth;
            var buttonHeight:Int = ITEM_HEIGHT;

            _button.x = 0;
            _button.width = buttonWidth;
            _button.height = buttonHeight;
            _button.textField.x = 30;
            _button.setStateColors(0x000000, 0x999999, 0xCCCCCC, 0x000000);
            _button.setStateAlphas(0, 0.5, 0.5, 0, 0.5, 0.5, 0.5, 0);
            _button.setIcon(null, null, null, null, null, tickIcon(), tickIcon(), tickIcon(), tickIcon());
            _button.setIconBounds(10, 10, 16, 16);
            _button.toggle = true;

            _button.addChild(_keyEquivalentText);
            // BUG autoSize width causing shit problems. Dirty fix using validateWidthDraw();
            //_keyEquivalentText.x = _longestTotalWidth - _keyEquivalentText.width - RIGHT_BORDER_WIDTH - ARROW_ICON_SPACING;
            validateWidthDraw();
            _keyEquivalentText.y = _button.height / 2 - _keyEquivalentText.height / 2;
            //trace(_keyEquivalentText.width);


            _button.addChild(_arrowIcon);
            //arrowIcon.x = longestTotalWidth - buttonHeight/2;
            _arrowIcon.x = _longestTotalWidth - _arrowIcon.width - RIGHT_BORDER_WIDTH - Std.int(ARROW_ICON_SPACING / 2);
            _arrowIcon.y = _button.height / 2;
        }


        if(!_container.hasEventListener(MouseEvent.MOUSE_OVER))
            _container.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);

        if(!_container.hasEventListener(MouseEvent.MOUSE_OUT))
            _container.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);

    } // end function


    private function validateWidthDraw():Void
    {
        addEventListener(Event.ENTER_FRAME, validateWidthEnterFrameHandler);
    } // end function

    private function validateWidthEnterFrameHandler(event:Event):Void
    {
        _keyEquivalentText.x = _longestTotalWidth - _keyEquivalentText.width - RIGHT_BORDER_WIDTH - ARROW_ICON_SPACING;
        removeEventListener(Event.ENTER_FRAME, validateWidthEnterFrameHandler);
    } // end function


    /**
	 * 
	 * @param	width
	 * @param	height
	 */
    @:allow(borris.menus.BMenu)
    private function drawForAppMenu(width:Int = 100, height:Int = 0):Void
    {
        _button.autoSize = true;
        _button.height = _height = 30;
        _button.setIcon(null);

        _width = Std.int(_button.width);

        // events handling
        if(!_container.hasEventListener(MouseEvent.MOUSE_OVER))
            _container.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler2);

        if(!_container.hasEventListener(MouseEvent.MOUSE_OUT))
            _container.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler2);

        if(!_container.hasEventListener(MouseEvent.MOUSE_DOWN))
            _container.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler2);
    } // end function


    /**
	 * 
	 */
    @:allow(borris.menus.BMenu)
    private function drawForCircleMenu():Void
    {


    } // end function


    /**
	 * 
	 */
    @:allow(borris.menus)
    private function showSubmenu():Void
    {
        if(_submenu != null)
        {
            _submenuRolledOver = true;
            //_submenu.display(container.parent.stage, _menu.x + _menu._width, _menu.y + y, false);
            _submenu.display(_container.parent.stage, _menu.x + _menu._width - 1, _menu.y + y, false);
        } // end if
    } // end function


    /**
	 * 
	 */
    @:allow(borris.menus)
    private function hideSubmenu():Void
    {
        if(_submenu != null)
        {
            _submenu.hide();
        } // end if
    } // end function


    // function setSeparator
    // call the once in the contructor.
    // this function sets the visibility if the appropriate assets. aka, if it's a separator, everything invisible yo! (except for line)
    /**
		 * 
		 * @param	value
		 */
    private function setSeparator(value:Bool):Void
    {

        if(!value)
        {
            _container.mouseEnabled = _container.mouseChildren = true;
            _container.tabEnabled = _container.tabChildren = true;
            _button.enabled = true;
        }
        else
        {
            _arrowIcon.visible = false;

            _container.mouseEnabled = _container.mouseChildren = false;
            _container.tabEnabled = _container.tabChildren = false;
            _button.enabled = false;
        } // end else
    } // end function


    /**
	 * 
	 * @param	container
	 */
    @:allow(borris.menus.BMenu)
    private function display(container:DisplayObjectContainer):Void
    {
        // add the container of this items assets to the DisplayObjectContainer passed as the argument
        container.addChild(_container);
    } // end function


    //**************************************** SET AND GET ******************************************


    private function get_checked():Bool
    {
        //return button.selected;
        return _checked;
    }

    private function set_checked(value:Bool):Bool
    {
        _button.toggle = value;
        _button.selected = value;
        _checked = value;
        return value;
    }


    private function get_data():Dynamic
    {
        return _data;
    }

    private function set_data(value:Dynamic):Dynamic
    {
        _data = value;
        return _data;
    }


    private function get_enabled():Bool
    {
        return _button.enabled;
    }

    private function set_enabled(value:Bool):Bool
    {
        if(value)
        {
            if(_submenu == null)
            {
                _container.addEventListener(MouseEvent.CLICK, mouseHandler);
            } // end if
        }
            // end if
        else
        {
            _container.removeEventListener(MouseEvent.CLICK, mouseHandler);
        } // end else

        _button.enabled = value;
        return value;
    }


    private function get_isSeparator():Bool
    {
        return _isSeparator;
    }


    private function get_keyEquivalent():String
    {
        return _keyEquivalent;
    }

    private function set_keyEquivalent(value:String):String
    {
        if(value != "")
        {
            // check length of string
            if(value.length > 1)
            {
                trace("BMenuItem | The keyEquivalent should only be 1 character long.\n");
                value = value.substring(0, 1);
            } // end if  

            // check for modifiers    
            if(keyEquivalentModifiers != null)
            {

                _keyEquivalentText.text = "";

                for(i in 0...keyEquivalentModifiers.length)
                {
                    if(keyEquivalentModifiers[i] == Keyboard.CONTROL)
                    {
                        _keyEquivalentText.textField.appendText("Ctrl+");
                    }
                    if(keyEquivalentModifiers[i] == Keyboard.SHIFT)
                    {
                        _keyEquivalentText.textField.appendText("Shift+");
                    }
                    if(keyEquivalentModifiers[i] == Keyboard.ALTERNATE)
                    {
                        _keyEquivalentText.textField.appendText("Alt+");
                    }
                } // end for
            } // end if
        } // end if

        value = value.toUpperCase();
        _keyEquivalentText.textField.appendText(value);
        _keyEquivalent = value;

        // calculate the width of this menu item
        // this SHIT cost me like 10 hours to fix!
        //totalWidth = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING + Math.ceil(labelText.width) + Math.ceil(keyEquivalentText.width);

        if(_longestTotalWidth < _totalWidth)
        {
            _longestTotalWidth = _totalWidth;
        } // end if

        if(_menu != null)
        {
            _menu.draw();
        }

        return value;
    }


    private function get_keyEquivalentModifiers():Array<Dynamic>
    {
        return _keyEquivalentModifiers;
    }

    private function set_keyEquivalentModifiers(value:Array<Dynamic>):Array<Dynamic>
    {
        if(value != null)
        {
            // TODO handle error
            /*if (value.length > 3) 
            {
                throw new Error("The keyEquivalentModifiers can have no more than 3 values.");
            } // end if*/

            for(i in 0...keyEquivalentModifiers.length)
            {
                if(keyEquivalentModifiers[i] != Keyboard.SHIFT || keyEquivalentModifiers[i] != Keyboard.ALTERNATE || keyEquivalentModifiers[i] != Keyboard.CONTROL)
                {
                    //trace("The keyEquivalentModifiers can have no more than 3 values containing Shift, Ctrll or Alt");
                    //throw new Error("The keyEquivalentModifiers can have no more than 3 values containing Shift, Ctrll or Alt");

                } // end if
            } // end for
        }

        _keyEquivalentModifiers = value;

        // set keyEquivalent (setter) to _keyEquivalent to redraw and update text
        keyEquivalent = _keyEquivalent;
        return value;
    }


    private function get_label():String
    {
        return _button.label;
    }

    private function set_label(value:String):String
    {
        _button.label = value;
        return value;
    }


    private function get_menu():BMenu
    {
        return _menu;
    }


    private function get_mnemonicIndex():Int
    {
        return _mnemonicIndex;
    }

    private function set_mnemonicIndex(value:Int):Int
    {
        _mnemonicIndex = value;
        return value;
    }


    //@:allow(borris.menus)
    private function get_name():String
    {
        return _name;
    }

    //@:allow(borris.menus)
    private function set_name(value:String):String
    {
        _name = value;
        return _name;
    }


    private function get_submenu():BMenu
    {
        return _submenu;
    }

    private function set_submenu(value:BMenu):BMenu
    {
        if(!_isSeparator)
        {
            if(value != null)
            {
                _arrowIcon.visible = true;
                _keyEquivalent = "";
                _keyEquivalentModifiers = [];
                checked = false;
            }
            else
            {
                _arrowIcon.visible = false;
            }
        } // end if

        // assign the submenu's parent this items menu  
        value._parent = _menu;

        _submenu = value;
        return _submenu;
    }


    private function get_icon():DisplayObject
    {
        return _button.icon;
    }

    private function set_icon(value:DisplayObject):DisplayObject
    {
        _button.icon = value;
        return value;
    }


    //********************************** INTERNAL SETTER AND GETTERS *******************************************

    private function get_x():Int
    {
        return Std.int(_container.x);
    }

    private function set_x(value:Int):Int
    {
        _container.x = value;
        return value;
    }


    private function get_y():Int
    {
        return Std.int(_container.y);
    }

    private function set_y(value:Int):Int
    {
        _container.y = value;
        return value;
    }


    private function get_width():Int
    {
        return _width;
    }

    /*internal function set width(value:int):void
		{
			_width = value;
		}*/


    private function get_height():Int
    {
        return _height;
    }

    /*internal function set height(value:int):void
		{
			_height = value;
		}*/


    //************************ overriding EventDispatcher functions (for reasons :P) ********************************


    /**
	 * @inheritDoc
	 */
    override public function addEventListener(type:String, listener:Dynamic -> Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
    {
        // Used to make sure that separators cannot have listeners or if the item contains a submenu.
        // Also, it adds the listener to the container, rather than the actual object.

        if(submenu != null || isSeparator)
            return;

        _container.addEventListener(type, listener, useCapture, priority, useWeakReference);
    } // end function


    /**
	 * @inheritDoc
	 */
    override public function dispatchEvent(event:Event):Bool
    {
        return _container.dispatchEvent(event);
    } // end function


    /**
	 * @inheritDoc
	 */
    override public function hasEventListener(type:String):Bool
    {
        return _container.hasEventListener(type);
    } // end function


    /**
	 * @inheritDoc
	 */
    override public function removeEventListener(type:String, listener:Dynamic -> Void, useCapture:Bool = false):Void
    {
        _container.removeEventListener(type, listener, useCapture);
    } // end function


    override public function willTrigger(type:String):Bool
    {
        return _container.willTrigger(type);
    }
    // end function

} // end class


