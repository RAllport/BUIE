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

import openfl.events.Event;
import openfl.events.MouseEvent;

// TODO imporovemtns:
//					- Use more constants
//					- Events to dispatch:
//						- displaying
//						- preparing
//						- select

/**
 * The BContextMenu class contains methods and properties for defining native context menus.
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
class BContextMenu extends BMenu
{
    @:allow(borris.menus)
    private static var BORDER_WIDTH:Int = 1;
    @:allow(borris.menus)
    private static var ITEM_PADDING:Int = 0;

    public function new()
    {
        super();
    }


    /**
	 * 
	 * @param	event
	 */
    override private function mouseHandler(event:MouseEvent = null):Void
    {
        // event.currentTarget is the stage (parentStage)
        // event.target can be any object of This BNativeMenu or the BNativeMenuItem that was clicked on

        switch (event.type)
        {
            case MouseEvent.MOUSE_DOWN:
                // hide the menu if it was NOT clicked on
                if(!_container.hitTestPoint(event.stageX, event.stageY))
                {
                    // the following is "shit code", quick, dirty, half asses quick fix to make the menu NOT hide if this menu's parent is an Application menu
                    if(this.parent != null)
                    {
                        //trace("BContextMenu | has parent");
                        if(Std.is(this.parent, BApplicationMenu))
                        {
                            //trace("BContextMenu | Parent is BApplicationMenu");
                            if(this.parent._isFocused)
                            {
                                //trace("BContextMenu | Parent is focus");
                                return;
                            } //return;
                        }
                    } // end shit code

                    hide();
                }
        } // end switch
    } // end function


    /**
	 * 
	 * @param	event
	 */
    override private function deactivateHandler(event:Event):Void
    {
        hide();
    } // end function


    /**
     * 
     */
    @:allow(borris.menus)
    override private function draw():Void
    {
        //trace("BNativeMenu | Drawing menu\n");
        var item:BMenuItem = null;
        var prevItem:BMenuItem = null;


        //********************************* DRAWING FOR CONTEXT MENU ************************************************

        _height = BORDER_WIDTH * 2;

        for(i in 0..._items.length)
        {
            item = _items[i];
            item.draw();
            item.x = BORDER_WIDTH;
            item.y = BORDER_WIDTH;

            // find the previous item if there is 1
            if(i > 0)
            {
                prevItem = _items[i - 1];
            } // end if

            if(!item.isSeparator)
            {
                _height += BMenuItem.TOP_MARGIN + BMenuItem.ITEM_HEIGHT;
                if(prevItem != null)
                {
                    item.y = prevItem.y + BMenuItem.TOP_MARGIN + BMenuItem.ITEM_HEIGHT;
                    if(prevItem.isSeparator)
                    {
                        item.y = prevItem.y + BMenuItem.SEPARATOR_TOP_MARGIN + BMenuItem.SEPARATOR_HEIGHT + BMenuItem.SEPARATOR_BOTTOM_MARGIN;
                    } // end if
                } // end if
            } // end if
            else // if it is a separator
            {
                _height += BMenuItem.SEPARATOR_TOP_MARGIN + BMenuItem.SEPARATOR_HEIGHT + BMenuItem.SEPARATOR_BOTTOM_MARGIN;
                if(prevItem != null)
                {
                    item.y = prevItem.y + BMenuItem.ITEM_HEIGHT + BMenuItem.SEPARATOR_TOP_MARGIN; // + BNativeMenuItem.SEPARATOR_HEIGHT;
                    if(prevItem.isSeparator)
                    {
                        item.y = prevItem.y + BMenuItem.SEPARATOR_TOP_MARGIN + BMenuItem.ITEM_HEIGHT;
                    } // end if
                } // end if
            } // end if
        } // end for  

        // set x, y, width, height
        _width = BORDER_WIDTH * 2 + BMenuItem._longestTotalWidth;

        _iconSeparator.x = BORDER_WIDTH + BMenuItem.ICON_WIDTH + Std.int(BMenuItem.TEXT_ICON_SPACING / 2); // 26;
        _iconSeparator.y = Math.round(BORDER_WIDTH / 2);
        _iconSeparator.height = _height - (BORDER_WIDTH);

        _style.backgroundColor = 0x222222;
        _style.borderColor = 0x666666;
        _style.borderWidth = 1;
    } // end function

} // end class

