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

package borris.materialDesign;

import borris.display.BStyle;
import openfl.display.DisplayObject;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date  (dd/mm/yyyy)
 */
class BMDStyle
{
    // TODO public static variables for each MD color
    // TODO make font varables/set functions
    // TODO make dark and light theme
    // TODO make default animations
    // TODO add default effects. eg. ripple
    // TODO have primary and secondary colors. main, dark and light of each


    // TODO include default resting positions (for each platfrom)
    // TODO dynamic elevation (e.g., normal, focused, and pressed)

    // resting elevations
    // @see https://material.io/guidelines/material-design/elevation-shadows.html#elevation-shadows-elevation-android
    public static inline var SWITCH_RESTING_ELEVATION:Int = 1;

    public static inline var CARD_RESTING_ELEVATION:Int = 2;
    public static inline var RAISED_BUTTON_RESTING_ELEVATION:Int = 2;
    public static inline var SWITCH_BAR_RESTING_ELEVATION:Int = 2;

    public static inline var REFRESH_INDICATOR_RESTING_ELEVATION:Int = 3;

    public static inline var APP_BAR_RESTING_ELEVATION:Int = 4;

    public static inline var FAB_RESTING_ELEVATION:Int = 6;
    public static inline var SNACKBAR_RESTING_ELEVATION:Int = 6;

    public static inline var BOTTOM_NAVIGATION_BAR_RESTING_ELEVATION:Int = 8;
    public static inline var MENU_RESTING_ELEVATION:Int = 8;

    public static inline var SUB_MENU_RESTING_ELEVATION:Int = 9;
    // (+1 dp for each sub menu)

    public static inline var NAV_DRAWER_RESTING_ELEVATION:Int = 16;
    public static inline var RIGHT_DRAWER_RESTING_ELEVATION:Int = 16;
    public static inline var MODEL_BOTTOM_SHEET_RESTING_ELEVATION:Int = 16;

    public static inline var DIALOG_RESTING_ELEVATION:Int = 24;
    public static inline var PICKER_RESTING_ELEVATION:Int = 24;

    // dynamic elevations
    // Another name for 'search bar' is 'quick entry'
    public static inline var SWITCH_BAR_SCROLLED_ELEVATION:Int = 3;
    //public static inline var CARD_SELECTED_ELEVATION:Int = 8;
    public static inline var CARD_RAISED_ELEVATION:Int = 8;
    public static inline var RAISED_BUTTON_PRESSED_ELEVATION:Int = 8;
    public static inline var FAB_PRESSED_ELEVATION:Int = 12;


    // Styles
    public static inline var _STYLE:BStyle = new BStyle();


    public static inline var BOTTOM_NAVIGATION_STYLE:BStyle = new BStyle();

    public static inline var MODAL_BOTTOM_SHEETS_STYLE:BStyle = new BStyle();
    public static inline var PERSISTENT_BOTTOM_SHEETS_STYLE:BStyle = new BStyle();

    public static inline var FLAT_BUTTON_STYLE:BStyle = new BStyle();
    public static inline var RAISED_BUTTON_STYLE:BStyle = new BStyle();
    public static inline var PERSISTENT_FOOTER_BUTTON_STYLE:BStyle = new BStyle();
    public static inline var DROPDOWN_BUTTON_STYLE:BStyle = new BStyle();
    public static inline var TOGGLE_BUTTON_STYLE:BStyle = new BStyle();
    public static inline var FLOATING_BUTTON_STYLE:BStyle = new BStyle();

    public static inline var CARD_STYLE:BStyle = new BStyle();

    public static inline var CHIP_STYLE:BStyle = new BStyle();

    public static inline var DATA_TABLES_STYLE:BStyle = new BStyle();

    public static inline var DIALOG_STYLE:BStyle = new BStyle();

    public static inline var DIVIDER_STYLE:BStyle = new BStyle();

    public static inline var EXPANSION_STYLE:BStyle = new BStyle();

    public static inline var GRID_LIST_STYLE:BStyle = new BStyle();

    public static inline var LIST_STYLE:BStyle = new BStyle();

    public static inline var CHECKBOX_STYLE:BStyle = new BStyle();
    public static inline var SWITCH_STYLE:BStyle = new BStyle();
    public static inline var REORDER_STYLE:BStyle = new BStyle();
    public static inline var EXPAND_COLLAPSE_STYLE:BStyle = new BStyle();
    public static inline var LEAVE_BEHINDS_STYLE:BStyle = new BStyle();

    public static inline var CHECK_STYLE:BStyle = new BStyle();
    public static inline var LINE_INFORMATION_STYLE:BStyle = new BStyle();
    public static inline var NESTED_MENU_INDICATOR_STYLE:BStyle = new BStyle();

    public static inline var MENU_STYLE:BStyle = new BStyle();

    public static inline var DATE_PICKER_STYLE:BStyle = new BStyle();
    public static inline var TIME_PICKER_STYLE:BStyle = new BStyle();

    public static inline var LINEAR_PROGRESS_INDICATOR_STYLE:BStyle = new BStyle();
    public static inline var CIRCULAR_PROGRESS_INDICATOR_STYLE:BStyle = new BStyle();

    //public static inline var CHECKBOX_STYLE:BStyle = new BStyle();
    public static inline var RADIO_BUTTON_STYLE:BStyle = new BStyle();
    //public static inline var SWITCH_STYLE:BStyle = new BStyle();

    public static inline var SLIDER_STYLE:BStyle = new BStyle();

    public static inline var SNACKBAR_STYLE:BStyle = new BStyle();

    public static inline var STEPPERS_STYLE:BStyle = new BStyle();

    public static inline var SUBHEADERS_STYLE:BStyle = new BStyle();

    public static inline var TAB_STYLE:BStyle = new BStyle();

    // TODO figure out text field styles (important!)
    //public static inline var _STYLE:BStyle = new BStyle();


    public static inline var TOOL_STYLE:BStyle = new BStyle();

    public static inline var TOOLBAR_STYLE:BStyle = new BStyle();

    public static inline var TOOLTIP_STYLE:BStyle = new BStyle();

    //public static inline var WIDGET_STYLE:BStyle = new BStyle();

    /**
    * @see https://material.io/guidelines/patterns/navigation-drawer.html
    */
    public static inline var NAVIGATION_DRAWER_STYLE:BStyle = new BStyle();

    /*public function new()
    {

    }*/


    /************************************* HANDLERS *****************************************/


    /************************************* FUNCTIONS *****************************************/

    /**
    *
    */
    function setElevation(displayObject:DisplayObject, elevation:Int = 4):Void
    {
        // make sure elevation is always even.
        if(elevation % 2 != 0)
        {

        } // end if

        // TODO add ambient light. this is only 'key light'


    }
    // end function


    /************************************* SET AND GET *****************************************/
}
