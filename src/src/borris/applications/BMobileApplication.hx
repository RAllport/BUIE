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

import borris.applications.BNativeMenu;
import borris.applications.DisplayObject;
import borris.applications.NativeApplication;
import borris.applications.Rectangle;
import borris.applications.Sprite;
import borris.applications.Stage;
import nme.errors.Error;

import flash.display.*;
import flash.events.*;
import flash.text.*;
import flash.ui.Keyboard;
import flash.desktop.*;  // AIR  
import flash.geom.*;
import flash.net.FileReference;
import flash.net.FileFilter;

import fl.managers.StyleManager;

import borris.display.*;
import borris.desktop.*;
import borris.menus.*;
import borris.panels.*;
import borris.ui.*;
import borris.controls.*;
import borris.containers.*;
import borris.BSlashScreen;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 10/10/2014 (dd/mm/yyyy)
 */
class BMobileApplication extends Sprite
{
    public static var thisApplication(get, never) : NativeApplication;
    public static var mainStage(get, never) : Stage;
    public static var menu(get, set) : BMenu;

    // constants
    public static inline var MAIN_MENU_HEIGHT : Int = 25;
    public static inline var VERSION : String = "1.0";
    private static var SPALSH_SCREEN : BSlashScreen = new BSlashScreen(VERSION);
    
    
    private static var initialized : Bool = false;  //  
    
    //
    private var panelRect : Rectangle;  // [read-only]  
    
    
    // set and get private variables
    private static var _thisApplication : NativeApplication;  // [read-only]  
    private static var _mainStage : Stage;  // [read-only]  
    private static var _menu : BMenu;  // [read-only]  
    private var _preferences : FastXML;  //  
    private var _autoOrient : Bool = true;
    
    
    public function new()
    {
        super();
        
        // check to see if a BWebApplication has already been made
        if (initialized) 
        {
            throw new Error("Only one(1) BWebApplication Object can be created.");
        }  // end if  
        initialized = true;
        
        //
        _thisApplication = NativeApplication.nativeApplication;
        
        
        _mainStage = this.stage;
        
        
        _mainStage.align = StageAlign.TOP_LEFT;
        //_mainStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
        _mainStage.displayState = StageDisplayState.NORMAL;
        _mainStage.scaleMode = StageScaleMode.NO_SCALE;
        
        // stage
        this.stage.color = 0x111111;
        this.stage.setAspectRatio(StageAspectRatio.LANDSCAPE);
        this.stage.autoOrients = true;
    }
    
    
    //***************************************** SET AND GET *******************************************************
    
    // thisAppliction
    private static function get_ThisApplication() : NativeApplication
    {
        return _thisApplication;
    }  //  
    
    
    // mainStage
    private static function get_MainStage() : Stage
    {
        return _mainStage;
    }
    
    
    // menu
    private static function set_Menu(value : BMenu) : BMenu
    {
        _menu = value;
        return value;
    }
    
    
    private static function get_Menu() : BMenu
    {
        return _menu;
    }
    
    
    //***************************************** SET AND GET OVERRIDES************************************************
    
    override public function addChild(child : DisplayObject) : DisplayObject
    {
        if (menu != null) 
        {
            child.y += MAIN_MENU_HEIGHT;
        }
        stage.addChild(child);
        return child;
    }
    
    override public function addChildAt(child : DisplayObject, index : Int) : DisplayObject
    {
        if (menu != null) 
        {
            child.y += MAIN_MENU_HEIGHT;
        }
        stage.addChild(child);
        return child;
    }
}

