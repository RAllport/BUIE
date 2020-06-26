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

package borris.applications;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.display.StageAlign;
import openfl.display.StageDisplayState;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.utils.Timer;

import openfl.ui.Keyboard;
//import openfl.desktop.*; // AIR
import openfl.net.FileReference;
import openfl.net.FileFilter;

import borris.display.*;
import borris.desktop.*;
import borris.menus.*;
import borris.panels.*;
import borris.ui.*;
import borris.controls.*;
import borris.containers.*;
import borris.BSlashScreen;

// TODO clean up code

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date  (dd/mm/yyyy)
 */
class BWebApplication extends Sprite
{
    public static var thisApplication(get, never):BWebApplication;
    public static var mainStage(get, never):Stage;
    public static var menu(get, set):BMenu;

    // constants
    public static inline var MAIN_MENU_HEIGHT:Int = 25;
    public static inline var VERSION:String = "1.0";
    private static var SPALSH_SCREEN:BSlashScreen = new BSlashScreen(VERSION);


    private static var initialized:Bool = false; //

    //
    private var panelRect:Rectangle; // [read-only]


    // set and get private variables
    private static var _thisApplication:BWebApplication; // [read-only]
    private static var _mainStage:Stage; // [read-only]
    private static var _menu:BMenu; // [read-only]
    private var _preferences:FastXML; //


    public function new()
    {
        super();

        // check to see if a BWebApplication has already been made
        if(initialized)
        {
            //throw new Error("Only one(1) BWebApplication Object can be created.");
        } // end if
        initialized = true;

        //
        _thisApplication = this;

        if(stage)
            initialize()
        else
            addEventListener(Event.ADDED_TO_STAGE, initialize);
    }


    // function initialize
    //
    private function initialize(event:Event = null):Void
    {
        _mainStage = this.stage;


        _mainStage.align = StageAlign.TOP_LEFT;
        _mainStage.displayState = StageDisplayState.NORMAL;
        _mainStage.scaleMode = StageScaleMode.NO_SCALE;

        // stage
        this.stage.color = 0x111111;
        this.stage.stageWidth = 1280;
        this.stage.stageHeight = 720;
    } // end function initialize


    //***************************************** SET AND GET *******************************************************

    private static function get_thisApplication():BWebApplication
    {
        return _thisApplication;
    } //


    private static function get_mainStage():Stage
    {
        return _mainStage;
    }


    private static function set_menu(value:BMenu):BMenu
    {
        _menu = value;
        return value;
    }


    private static function get_menu():BMenu
    {
        return _menu;
    }


    //***************************************** SET AND GET OVERRIDES************************************************

    override public function addChild(child:DisplayObject):DisplayObject
    {
        if(menu != null)
        {
            child.y += MAIN_MENU_HEIGHT;
        }
        stage.addChild(child);
        return child;
    }


    override public function addChildAt(child:DisplayObject, index:Int):DisplayObject
    {
        if(menu != null)
        {
            child.y += MAIN_MENU_HEIGHT;
        }
        stage.addChild(child);
        return child;
    }
}


