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
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.*;
import openfl.text.*;
import openfl.ui.Keyboard;
import openfl.desktop.*;  // AIR
import openfl.geom.*;
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

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 10/10/2014 (dd/mm/yyyy)
 */
class BDesktopApplication extends Sprite
{
    public static var thisApplication(get, never) : NativeApplication;
    public static var mainWindow(get, never) : NativeWindow;
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
    private static var _mainWindow : NativeWindow;  // [read-only]  
    private static var _menu : BMenu;  // [read-only]  
    private var _preferences : FastXML;  //  
    
    
    public function new()
    {
        super();
        
        // check to see if a BDestopApplication has already been made
        if (initialized) 
        {
            throw new Error("Only one(1) BDesktopnApplication Object can be created.");
        }  //    // end if  
        
        
        
        _thisApplication = NativeApplication.nativeApplication;
        
        
        //_mainWindow = thisApplication.openedWindows[0];
        _mainWindow = stage.nativeWindow;
        _mainWindow.alwaysInFront = false;
        _mainWindow.title = "A BDesktopApplication";
        //_mainWindow.maximize();
        //_mainWindow.menu = appMenu;
        
        //_mainWindow.bounds = new Rectangle(0, 0, 300, 40);
        //_mainWindow.maxSize = new Point(1000, 40);
        //_mainWindow.minSize = new Point(200, 40);
        //_mainWindow.width = 300;
        //_mainWindow.height = 40;
        _mainWindow.x = Screen.mainScreen.bounds.width / 2 - _mainWindow.width / 2;
        _mainWindow.y = 100;
        _mainWindow.visible = true;
        
        _mainWindow.stage.align = StageAlign.TOP_LEFT;
        _mainWindow.stage.displayState = StageDisplayState.NORMAL;
        _mainWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
        
        _mainWindow.activate();
        
        initialized = true;
        
        // stage
        this.stage.stageWidth = 1280;
        this.stage.stageHeight = 720;
    }
    
    
    //
    //
    private function adjustWorkspaceRect() : Void
    {
        trace("hi man!");
        if (menu == null) 
        {
            for (i in 0...numChildren - 1){
                getChildAt(i).y -= MAIN_MENU_HEIGHT;
            }  //  end for  
        }  // end if  
    }  //  
    
    
    //
    
    
    
    //***************************************** SET AND GET *******************************************************
    
    // thisAppliction
    private static function get_ThisApplication() : NativeApplication
    {
        return _thisApplication;
    }  //  
    
    
    // mainWindow
    private static function get_MainWindow() : NativeWindow
    {
        return _mainWindow;
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


