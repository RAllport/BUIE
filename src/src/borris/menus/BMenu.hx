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

import openfl.display.DisplayObjectContainer;
import borris.display.BStyle;
import borris.menus.BMenu;

import motion.Actuate;

import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;

// TODO imporovemtns:
//					- Use more constants
//					- Events to dispatch:
//						- displaying
//						- preparing
//						- select

/**
 * The BMenu class contains methods and properties for defining native menus.
 *
 * A menu object contains menu items. A menu item can represent a command, a submenu, or a separator line. Add menu items to a menu using the addItem() or addItemAt() method. The display order of the menu items matches the order of the items in the menu's items array.
 *
 * To create a submenu, add a menu item to the parent menu object. Assign the menu object representing the submenu to the submenu property of the matching menu item in the parent menu.
 *
 * Note: The root menu of window and application menus must contain only submenu items; items that do not represent submenus may not be displayed and are contrary to user expectation for these types of menus.
 *
 * Menus dispatch select events when a command item in the menu or one of its submenus is selected. (Submenu and separator items are not selectable.) The target property of the event object references the selected item.
 *
 * Menus dispatch preparing events just before the menu is displayed and when a key equivalent attached to one of the items in the menu is pressed. You can use this event to update the contents of the menu based on the current state of the application.
 *
 * @author Rohaan Allport
 * @creation-date 11/07/2014 (dd/mm/yyyy)
 */
class BMenu extends EventDispatcher
{
    // properties
    public var items(get, set):Array<BMenuItem>;
    public var numItems(get, never):Int;
    public var parent(get, never):BMenu;

    @:allow(borris.menus.BMenuItem)
    private var x(get, set):Int;
    @:allow(borris.menus.BMenuItem)
    private var y(get, set):Int;


    // constants
    public static inline var APPLICATION_MENU_HEIGHT:Int = 25; //

    @:allow(borris.menus)
    private static var BORDER_WIDTH:Int = 4;
    @:allow(borris.menus)
    private static var ITEM_PADDING:Int = 4;

    private static var _applicationMenuSet:Bool = false;

    // asset variabes
    @:allow(borris.menus)
    private var _container:Sprite; //
    private var _style:BStyle;
    // TODO test out making _iconSeparator a BUIComponent or BElement or a separator class?
    private var _iconSeparator:Sprite; //

    // other
    private var _isApplicationMenu:Bool;

    @:allow(borris.menus)
    private var _width:Int;

    @:allow(borris.menus)
    private var _height:Int;
    private var _parentStage:DisplayObjectContainer;

    @:allow(borris.menus)
    private var _isFocused:Bool = false;

    @:allow(borris.menus)
    private var _applMenuClicked:Bool = false;


    // set and get private variables
    private var _items:Array<BMenuItem>; // The array of BMenuItem objects in this menu.
    @:allow(borris.menus)
    private var _parent:BMenu; // [read-only] The parent menu.


    public function new()
    {
        super();

        // create the container sprite
        _container = new Sprite();
        _container.scaleX = _container.scaleY = 1;
        _container.focusRect = false;

        _width = 0;
        _height = 0;

        _iconSeparator = new Sprite();
        _iconSeparator.graphics.beginFill(0x222222, 1);
        _iconSeparator.graphics.drawRect(0, 0, 1, 100);
        _iconSeparator.graphics.beginFill(0x666666, 1);
        _iconSeparator.graphics.drawRect(1, 0, 1, 100);
        _iconSeparator.graphics.endFill();

        _items = [];

        _style = new BStyle(_container);
        _style.backgroundColor = 0x222222;
    }


    //**************************************** HANDLERS *********************************************


    /**
     * 
     * @param	event
     */
    private function mouseHandler(event:MouseEvent = null):Void
    {
        // event.currentTarget is the stage (parentStage)
        // event.target can be any object of This BMenu or the BMenuItem that was clicked on
        // override this function
    } // end function


    /**
     * 
     * @param	event
     */
    private function deactivateHandler(event:Event):Void
    {
        // override this function
        hide();
    } // end function


    //**************************************** FUNCTIONS ********************************************


    /**
	 * Hide the the menu and remove it from the stage.
	 */
    @:allow(borris.menus)
    private function hide():Void
    {
        // check for parent stage and isApplicationMenu
        if(_parentStage != null)
        {
            _container.visible = false;

            if(_parentStage.contains(_container))
            {
                _parentStage.removeChild(_container);
            } // end if

            if(_parentStage.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                _parentStage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
            } // end if

            _parentStage.removeEventListener(Event.DEACTIVATE, deactivateHandler);
        } // end if

        // this works the same way as above ._.
        /*if(container.parent && !isApplicationMenu)
		{
			container.parent.removeChild(container);
			trace("BMenu | hiding context menu");
			
			if(parentStage.hasEventListener(MouseEvent.MOUSE_DOWN))
				parentStage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
		} // end if*/

    } // end function


    /**
	 * 
	 */
    @:allow(borris.menus)
    private function draw():Void
    {
        // override this function in a subclass

    } // end function


    /**
	 * Adds a menu item at the bottom of the menu.
	 * 
	 * @param	item
	 * @return
	 */
    public function addItem(item:BMenuItem):BMenuItem
    {
        return addItemAt(item, _items.length);
    } // end function


    /**
	 * Inserts a menu item at the specified position.
	 * 
	 * @param	item
	 * @param	index
	 * @return
	 */
    public function addItemAt(item:BMenuItem, index:Int):BMenuItem
    {
        // check to see if item is already in this menu
        if(containsItem(item))
        {
            trace("The specified item is already contained in this menu.");
            return item;
        }// end if

        item._menu = this;
        item.display(_container);
        _items.insert(index, item);

        // redraw the menu
        draw();

        return item;
    } // end function


    /**
	 * Adds a submenu to the menu by inserting a new menu item.
	 * 
	 * @param	submenu
	 * @param	label
	 * @return
	 */
    public function addSubmenu(submenu:BMenu, label:String):BMenuItem
    {
        return addSubmenuAt(submenu, _items.length, label);
    } // end function


    /**
	 * Adds a submenu to the menu by inserting a new menu item at the specified position.
	 * 
	 * @param	submenu
	 * @param	index
	 * @param	label
	 * @return
	 */
    public function addSubmenuAt(submenu:BMenu, index:Int, label:String):BMenuItem
    {
        var item:BMenuItem = new BMenuItem(label, false);
        item.submenu = submenu;

        addItemAt(item, index);

        // assign the submenu's parent this this
        submenu._parent = this;

        // redraw the menu
        draw();

        return item;
    } // end function


    /**
	 * Creates a copy of the menu and all items.
	 * 
	 * @return
	 */
    public function clone():BMenu
    {
        var menu:BMenu = new BMenu();

        // loop through all its items and clone them
        for(item in _items)
        {
            menu.addItem(item.clone());
        } // end for

        return menu;
    } // end function


    /**
	 * Reports whether this menu contains the specified menu item.
	 * 
	 * @param	item
	 * @return
	 */
    public function containsItem(item:BMenuItem):Bool
    {
        // something wrong
        for(i in 0..._items.length)
        {
            if(item == _items[i])
            {
                return true;
            }
        } // end for  

        return false;
    } // end function


    /**
	 * Pops up this menu at the specified location.
	 * 
	 * @param	stage
	 * @param	stageX
	 * @param	stageY
	 * @param	animate
	 */
    public function display(stage:DisplayObjectContainer, stageX:Int = 0, stageY:Int = 0, animate:Bool = true):Void
    {
        // Note: In a flash player application, the stage, might not be ready, when the display is called.
        // need to find a way to get around this.

        // quick fix the make all the menu items go back to their original state
        //draw(); sigh, causes another drawing error. makes all menus the same length. the length of the longest menu.

        // dispatch a new Event.DISPLAYING Event object
        //dispatchEvent(new Event(Event.DISPLAYING, false, false));

        _parentStage = stage; // set parentStage property to stage

        // add an event listener to parentStage
        _parentStage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        _parentStage.addEventListener(Event.DEACTIVATE, deactivateHandler);

        _container.visible = true; // make the container (that holds all the assets) visible
        _container.x = stageX;
        _container.y = stageY;

        if(animate)
        {
            _container.x = stageX - 100;
            _container.y = stageY - 100;
            Actuate.tween(_container, 0.3, {x: stageX, alpha: 1});
            _container.y = stageY;
        }
        else
        {
            _container.x = stageX;
            _container.y = stageY;
        }

        // add the container to the stage
        stage.addChildAt(_container, stage.numChildren);
    } // end function


    /**
	 * Gets the menu item at the specified index.
	 * 
	 * @param	index
	 * @return
	 */
    public function getItemAt(index:Int):BMenuItem
    {
        if(_items.length - 1 >= index)
        {
            return _items[index];
        }
        // TODO error check
        /*else 
        {
            throw new Error("The suplied index is out of bounds.", 0);
        }*/

        return null;

    } // end function


    /**
	 * Gets the menu item with the specified name.
	 * 
	 * @param	name
	 * @return
	 */
    public function getItemByName(name:String):BMenuItem
    {
        for(item in _items)
        {
            if(item.name == name)
            {
                return item;
            } // end if
        } // end for  

        return null;
    } // end function


    /**
	 * Gets the menu item with the specified label.
	 * 
	 * @param	label
	 * @return
	 */
    public function getItemByLabel(label:String):BMenuItem
    {
        for(item in _items)
        {
            if(item.label == label)
            {
                return item;
            } // end if
        } // end for  

        return null;
    } // end function


    /**
	 * Gets the position of the specified item.
	 * 
	 * @param	item
	 * @return
	 */
    public function getItemIndex(item:BMenuItem):Int
    {
        return _items.indexOf(item);
    } // end function


    /**
	 * Removes all items from the menu.
	 */
    public function removeAllItems():Void
    {
        /*var item:BMenuItem;
        
        // loop backwards
        var i:Int = _items.length - 1;
        while (i >= 0)
		{
            removeItemAt(i);
            i--;
        }  //trace("removeAllItems function incomplete.");    // end for  
		*/
        _items = [];
        _container.removeChildren();
        draw();

    } // end function


    /**
	 * Removes the specified menu item.
	 * 
	 * @param	item
	 * @return
	 */
    public function removeItem(item:BMenuItem):BMenuItem
    {
        if(containsItem(item))
        {
            _items.remove(item);

            // remove the item container from its parent
            //item.container.parent.removeChild(item.container);

            // redraw the menu
            draw();
        }
        // TODO error check
        //else 
        //throw new Error("The specified BMenuItem is not contained within this BMenu.");

        // redraw the menu
        draw();

        return item;
    } // end function


    /**
	 * Removes and returns the menu item at the specified index.
	 * 
	 * @param	index
	 * @return
	 */
    public function removeItemAt(index:Int):BMenuItem
    {
        var item:BMenuItem = _items[index];
        if(containsItem(item))
        {
            _items.splice(index, 1);

            // remove the item container from its parent
            //item.container.parent.removeChild(item.container);

            // redraw the menu
            draw();
        } // end if
        // TODO error check
        //else 
        //throw new Error("The specified BMenuItem is not contained within this BMenu.");

        // redraw the menu
        draw();

        return item;
    } // end function


    /**
	 * Moves a menu item to the specified position.
	 * 
	 * @param	item
	 * @param	index
	 */
    public function setItemIndex(item:BMenuItem, index:Int):Void
    {
        if(containsItem(item))
        {
            _items.remove(item);
            _items.insert(index, item);

            // redraw the menu
            draw();
        }
        // TODO error check
        //else 
        //throw new Error("The specified BMenuItem is not contained within this BMenu.");
    } // end function


    //**************************************** SET AND GET ******************************************


    private function set_items(value:Array<BMenuItem>):Array<BMenuItem>
    {
        if(_items != null)
        {
            removeAllItems();
        }

        _items = value;
        return value;
    }

    private function get_items():Array<BMenuItem>
    {
        return _items;
    }


    private function get_numItems():Int
    {
        return _items.length;
    }


    private function get_parent():BMenu
    {
        return _parent;
    }


    private function set_x(value:Int):Int
    {
        _container.x = value;
        return value;
    }

    private function get_x():Int
    {
        return Std.int(_container.x);
    }


    private function set_y(value:Int):Int
    {
        _container.y = value;
        return value;
    }

    private function get_y():Int
    {
        return Std.int(_container.y);
    }


}


