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

import borris.menus.BMenu;
import openfl.display.DisplayObjectContainer;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;

// TODO imporovemtns:
//					- Use more constants
//					- Events to dispatch:
//						- displaying
//						- preparing
//						- select

/**
 * The BApplicationMenu class contains methods and properties for defining native application menus.
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
 * @creation-date 12/10/2014 (dd/mm/yyyy)
 */
class BApplicationMenu extends BMenu
{

    public function new(hasBackground:Bool = true)
    {
        super();

        if(hasBackground)
        {
            _style.backgroundColor = 0x222222;
        } // event handling


        _container.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
        _container.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
        _container.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler);
        _container.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
    }


    /**
     * 
     * @param	event
     */
    private function focusInHandler(event:FocusEvent):Void
    {
        //trace("Focused in.");
        _isFocused = true;
    } // end function


    /**
     * 
     * @param	event
     */
    private function focusOutHandler(event:FocusEvent):Void
    {
        //trace("Focused out.");
        _isFocused = false;
    } // end function


    /**
     * 
     * @param	event
     */
    private function mouseFocusChangeHandler(event:FocusEvent):Void
    {
        //trace("mouse focus change.");


    } // end function


    /**
     * 
     * @param	event
     */
    private function keyFocusChangeHandler(event:FocusEvent):Void
    {
        //trace("key focus change.");


    } // end function


    /**
     * 
     * @param	event
     */
    override private function mouseHandler(event:MouseEvent = null):Void
    {
        // event.currentTarget is the stage (parentStage)
        // event.target can be any object of This BMenu or the BMenuItem that was clicked on

        switch (event.type)
        {
            case MouseEvent.MOUSE_DOWN:
                if(_container.hitTestPoint(event.stageX, event.stageY))
                {
                    //trace("_container hit down.");
                    if(_container.stage != null)
                    {
                        _container.stage.focus = _container;
                    }
                }
                if(!_container.hitTestPoint(event.stageX, event.stageY))
                {
                    //trace("_container not hit.");
                    if(_container.stage != null)
                    {
                        _container.stage.focus = null;
                    }
                    _applMenuClicked = false;
                }
        } // end switch

    } //  end function


    /**
     * 
     * @param	event
     */
    override private function deactivateHandler(event:Event):Void
    {
        // hide all its visible submenus
        // though, the submenus will prob handle that on their own anyway


    } // end function


    /**
     * 
     */
    @:allow(borris.menus)
    override private function draw():Void
    {

        //trace("BMenu | Drawing menu\n");
        var item:BMenuItem = null;
        var prevItem:BMenuItem = null;
        var rightMargin:Int = 0;


        //********************************* DRAWING FOR APPLICATION MENU ************************************************

        var xPos:Int = 0;

        for(i in 0..._items.length)
        {
            item = _items[i];
            item.drawForAppMenu();

            // find the previous item if there is 1
            if(i > 0)
            {
                prevItem = _items[i - 1];
            } // end if

            if(prevItem != null)
            {
                // set xPos to 2px to the right of the previous item. (place the new item 2px to the right of the previous item)
                xPos = prevItem.x + prevItem.width + rightMargin;
            } //trace("BApplicationMenu | Drawing item: " + item.label);


            item.x = xPos;
            item.y = 0;
        } //trace("BMenu | draw(): Drawing for application menu.");    // end for
    } // end function


    /**
     * Pops up this menu at the specified location.
     */
    override public function display(stage:DisplayObjectContainer, stageX:Int = 0, stageY:Int = 0, animate:Bool = false):Void
    {
        //super.display(stage, 0, 0);
        super.display(stage, stageX, stageY, false);
    }
    // end function

} // end class

