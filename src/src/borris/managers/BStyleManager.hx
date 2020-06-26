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

package borris.managers;

import borris.display.*;
import borris.controls.*;
import borris.menus.*;

import openfl.display.Sprite;

/**
 * The BStyle manager class contains useful constants and function for styling BComponents
 *
 * @author Rohaan Allport
 * @creation-date 07/08/2015 (dd/mm/yyyy)
 */
class BStyleManager
{
    // constants
    public static inline var THEME_BORRIS_DARK:String = "borrisDark";
    public static inline var THEME_AERO_LIGHT:String = "aeroLight";
    public static inline var THEME_AERO_DARK:String = "aeroDark";
    public static inline var THEME_MORDERN_UI_LIGHT:String = "modernUILight";
    public static inline var THEME_MODERN_UI_DARK:String = "modernUIDark";


    // other
    private static var _components:Array<BUIComponent> = [];


    //  set and get
    private static var _theme:String = THEME_BORRIS_DARK;
    private var _aeroMenuOverColor:Int = 0x006699;
    private var _modernUIMenuOverColor:Int = 0x006699;

    //public static const ;


    // function registerBUIComponent
    // resgisters a component and pushes it in the components array.
    // called in the contructor of the BUIComponent class.
    // used for applying styles and themes
    /**
	 * 
	 * @param	component
	 */
    public static function registerStyle(component:BUIComponent):Void
    {
        if(_components.indexOf(component) > -1) return;
        _components.push(component);
    } // end function


    // function unRegisterBUIComponent
    // unregisters a component
    /**
	 * 
	 * @param	component
	 */
    public static function unRegisterBUIComponent(component:BUIComponent):Void
    {
        _components.splice(Lambda.indexOf(_components, component), 1);
    } // end function


    // function setTheme
    // Sets the theme of the UI
    /**
	 * 
	 * @param	theme
	 */
    public static function setTheme(theme:String):Void
    {
        if(_theme == theme)
        {
            return;
        } // end if

        _theme = theme;

        for(i in 0..._components.length)
        {
            _components[i].style.draw();
        } // end for

    } // end function


    /**
     * 
     */
    public static function getTheme():String
    {
        return _theme;
    } // end function


    /*************************************** Borris theme functions ********************************************/

    /**
     * 
     */
    public static function drawBorrisAppMenu(_items:Array<Dynamic>):Void
    {
        //trace("BNativeMenu | Drawing menu\n");
        var item:BMenuItem = null;
        var prevItem:BMenuItem = null;


        //********************************* DRAWING FOR APPLICATION MENU ************************************************

        var xPos:Int = 0;

        for(i in 0..._items.length)
        {
            item = _items[i];
            //item.drawForAppMenu();

            // find the previous item if there is 1
            if(i > 0)
            {
                prevItem = _items[i - 1];
            } // end if

            if(prevItem != null)
            {
                // set xPos to 2px to the right of the previous item. (place the new item 2px to the right of the previous item)
                xPos = prevItem.x + prevItem.width + 2;
            } //trace("BApplicationMenu | Drawing item: " + item.label);


            item.x = xPos;
            item.y = 0;
        } //trace("BNativeMenu | draw(): Drawing for application menu.");    // end for
    } // end function


    private static var longestTotalWidth:Int = 100;
    private var totalWidth:Int;

    /**
     * 
     */
    public static function drawBorrisContextMenu(_items:Array<Dynamic>, _width:Float, _height:Float, contextMenuBackground:Sprite, iconSeparator:Sprite, labelTextWidth:Float, keyEquivalentTextWidth:Float):Void
    {
        //trace("BNativeMenu | Drawing menu\n");
        var item:BMenuItem = null;
        var prevItem:BMenuItem = null;


        var borderWidth:Int = 0;
        var borderHeight:Int = 0;

        var topMargin:Int = 1;
        var bottomMargin:Int = 1;
        var itemHeight:Int = 30;

        var separatorTopMargin:Int = 2;
        var separatorBottomMargin:Int = 2;
        var separatorHeight:Int = 2;

        var leftBorderWidth:Int = 2;
        var rightBorderWidth:Int = 2;

        var iconWidth:Int = 22;
        var textIconSpacing:Int = 8;
        var arrowIconSpacing:Int = 16;
        var textSpacing:Int = 32;


        //********************************* DRAWING FOR CONTEXT MENU ************************************************

        _height = borderWidth * 2;

        for(i in 0..._items.length)
        {
            item = _items[i];
            //item.draw();
            item.x = borderWidth;
            item.y = borderHeight;

            // find the previous item if there is 1
            if(i > 0)
            {
                prevItem = _items[i - 1];
            } // end if

            if(!item.isSeparator)
            {
                _height += topMargin + itemHeight;
                if(prevItem != null)
                {
                    item.y = prevItem.y + topMargin + itemHeight;
                    if(prevItem.isSeparator)
                    {
                        item.y = prevItem.y + separatorTopMargin + separatorHeight + separatorBottomMargin;
                    }
                }
            }
                // end if
                //  end else if
            else if(item.isSeparator) // if it is a separator
            {
                _height += separatorTopMargin + separatorHeight + separatorBottomMargin;
                if(prevItem != null)
                {
                    item.y = prevItem.y + itemHeight + separatorTopMargin;
                    if(prevItem.isSeparator)
                    {
                        item.y = prevItem.y + separatorTopMargin + itemHeight;
                    }
                }
            }
        } // set x, y, width, height    // end for


        var totalWidth:Int = leftBorderWidth + rightBorderWidth + iconWidth + textIconSpacing + textSpacing + arrowIconSpacing + Math.ceil(labelTextWidth) + Math.ceil(keyEquivalentTextWidth);
        if(longestTotalWidth < totalWidth)
        {
            longestTotalWidth = totalWidth;
        } //  end if

        _width = borderWidth * 2 + longestTotalWidth;


        contextMenuBackground.x = 0;
        contextMenuBackground.y = 0;
        contextMenuBackground.graphics.clear();
        contextMenuBackground.graphics.beginFill(0x666666, 1);
        contextMenuBackground.graphics.drawRect(0, 0, _width, _height);
        contextMenuBackground.graphics.beginFill(0x222222, 1);
        contextMenuBackground.graphics.drawRect(2, 2, _width - 4, _height - 4);

        iconSeparator.x = borderWidth + iconWidth + Std.int(textIconSpacing / 2);
        iconSeparator.y = Math.round(borderWidth / 2);
        iconSeparator.height = _height - (borderWidth);
    } // end function


    /**
     * 
     */
    public static function drawBorrisCircleMenu():Void
    {


    } // end function


    /**
     * 
     */
    public static function drawBorrisButton():Void
    {


    } // end function


    /***********************************************************************************************************/


    /**
     * 
     */
    public static function drawAeroContextMenu():Void
    {


    } // end function


    /**
     * 
     */
    public static function drawModernUIContextMenu():Void
    {


    } // end function


    /**
     * 
     */
    public static function drawAeroAppMenu(_items:Array<Dynamic>):Void
    {
        //trace("BNativeMenu | Drawing menu\n");
        var item:BMenuItem = null;
        var prevItem:BMenuItem = null;


        //********************************* DRAWING FOR APPLICATION MENU ************************************************

        var xPos:Int = 5;

        for(i in 0..._items.length)
        {
            item = _items[i];
            //item.drawForAppMenu();

            // find the previous item if there is 1
            if(i > 0)
            {
                prevItem = _items[i - 1];
            } // end if

            if(prevItem != null)
            {
                // set xPos to 2px to the right of the previous item. (place the new item 2px to the right of the previous item)
                xPos = prevItem.x + prevItem.width + 2;
            } //trace("BApplicationMenu | Drawing item: " + item.label);


            item.x = xPos;
            item.y = 2;
        } //trace("BNativeMenu | draw(): Drawing for application menu.");    // end for
    } // end function


    /**
     * 
     */
    public static function drawModernUIAppMenu(_items:Array<Dynamic>):Void
    {


    } // end function


    /**
     * 
     */
    public static function drawAeroButton():Void
    {


    } // end function


    /**
     * 
     */
    public static function drawModernUIButton():Void
    {


    }
    // end function


} // end class

