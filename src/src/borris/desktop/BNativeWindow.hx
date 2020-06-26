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

package borris.desktop;

import borris.containers.BPanelBounds;
import borris.controls.BLabelButton;
import borris.controls.windowClasses.BTitleBar;
import borris.display.BElement;
import borris.display.BStyle;
import borris.display.BTitleBarMode;
import borris.events.BStyleEvent;
import borris.menus.BMenu;
import borris.ui.BMouseCursor;

import motion.Actuate;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;
import openfl.utils.Timer;

#if false
// TODO create different window shapes. eg. rectangular, circular, polygonal. (in progress)
// TODO add different closeButton styles.
/**
 * The BNativeWindow class provides an interface for creating and controlling native desktop windows.
 *
 * @author Rohaan Allport
 * @creation-date 31/07/2015 (dd/mm/yyyy)
 */
class BNativeWindow extends NativeWindow
{
    /**
	 * [read-only] A reference to the internal title bar.
	 */
    public var titleBar(get, never):BTitleBar;
    public var titleTextColor(get, set):UInt;
    public var titleBarHight(get, never):Float;
    public var titleBarMode(get, set):BTitleBarMode;
    public var bMenu(get, set):BMenu;
    public var backgroundDrag(get, set):Bool;
    public var windowShape(get, set):BShape;
    public var content(get, never):DisplayObjectContainer;
    //public var menu(get, set):NativeMenu;
    //public var title(get, set):String;
    public var style(get, set):BStyle;


    // assets
    private var container:Sprite;
    private var _content:Sprite;
    private var contentMask:Shape;

    private var _titleBar:BTitleBar;
    private var _drawElement:BElement;

    private var closeButton:BLabelButton;
    private var minimizeButton:BLabelButton;
    private var maximizeButton:BLabelButton;
    //private var contextMenu:BContextMenu;
    //private var nativeMenu:BNativeMenu;
    public var panelBounds:BPanelBounds;


    // icons
    private var xIcon:DisplayObject;
    private var maximizeIcon:DisplayObject;
    private var minimizeIcon:DisplayObject;
    private var windowIcon:DisplayObject;


    // resize grabbers
    private var _resizeGrabberTL:Sprite;
    private var _resizeGrabberTR:Sprite;
    private var _resizeGrabberBL:Sprite;
    private var _resizeGrabberBR:Sprite;
    private var _resizeGrabberTE:Sprite;
    private var _resizeGrabberBE:Sprite;
    private var _resizeGrabberLE:Sprite;
    private var _resizeGrabberRE:Sprite;


    // other
    private var thisWindow:NativeWindow;
    private var padding:Int = 10; //
    private var borderMaxThickness:Int = 10; //
    private var borderMinThickness:Int = 1; //
    private var activatedTF:TextFormat; //
    private var deactivatedTF:TextFormat; //
    private var tempWidth:Int; //
    private var tempHeight:Int; //
    private var buttonsWidth:Int = 150; // the width of the buttons and icons in the the titlebar. used for calucating the title text width
    private var resizeGrabberThickness:Int = 5;


    // set and get
    private var _titleTextColor:UInt = 0xFFFFFF;

    private var _bMenu:BMenu; //
    private var _backgroundDrag:Bool = false; //
    private var _windowShape:BShape = RECTANGULAR; //

    private var _titleBarMode:BTitleBarMode = COMPACT_TEXT; // The mode of the title bar. 4 modes in total. minimal (3 dots), compact (text or icon), full (text and icon)
    private var _titleBarHeight:Int; // [read-only] The height of th title bar after calculating the titleBar height and mode, etc


    public function new(initOptions:NativeWindowInitOptions = null, bounds:Rectangle = null)
    {
        // constructor code

        if(initOptions == null)
        {
            var newWindowInitOption:NativeWindowInitOptions;
            newWindowInitOption = new NativeWindowInitOptions();
            newWindowInitOption.maximizable = true;
            newWindowInitOption.minimizable = true;
            newWindowInitOption.renderMode = NativeWindowRenderMode.AUTO;
            newWindowInitOption.resizable = true;
            newWindowInitOption.systemChrome = NativeWindowSystemChrome.NONE;
            newWindowInitOption.transparent = true; // SystemChrome must be set to 'none'/'NativeWindowSystemChrome.NONE' to allow this feature
            newWindowInitOption.type = NativeWindowType.NORMAL;
            initOptions = newWindowInitOption;
        }

        // call the super() (NativeWinodw) contructor
        super(initOptions);
        thisWindow = this;

        initialize(bounds);
    }


    //**************************************** HANDLERS *********************************************


    private function styleChangeHandler(event:BStyleEvent):Void
    {
        //draw();
    } // end function


    /**
	 * 
	 * @param event
	 */
    private function closeWindow(event:MouseEvent):Void
    {
        var tween = Actuate.tween(container, 0.3, {alpha: 0, scaleX: 0.5, scaleY: 0.5 });

        if(_windowShape == BShape.CIRCULAR)
        {
            var tween = Actuate.tween(container, 0.3, {x: width / 4, y: width / 4 });
        }

        var closeTimer:Timer = new Timer(334);
        closeTimer.addEventListener(TimerEvent.TIMER, closeTimerHandler);
        closeTimer.start();
    } // end function


    /**
	 * 
	 * @param event
	 */
    private function minimizeWindow(event:MouseEvent):Void
    {
        thisWindow.minimize();
    } // end function


    /**
	 * 
	 * @param event
	 */
    private function maximizeWindow(event:MouseEvent = null):Void
    {
        if(thisWindow.displayState == NativeWindowDisplayState.NORMAL)
        {
            padding = 8;
            thisWindow.maximize();
            maximizeButton.icon = windowIcon;
        }
        else if(thisWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
        {
            padding = 10;
            thisWindow.restore();
            maximizeButton.icon = maximizeIcon;
        }
        draw();
        //resizeAlign();

    } // end function


    /**
	 * 
	 * @param event
	 */
    private function moveWindow(event:MouseEvent):Void
    {
        thisWindow.startMove();
        // for when maximized
        /*if (thisWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
		{
			titleBar.addEventListener(MouseEvent.MOUSE_MOVE, moveWindow);
			
			if (titleBar.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				titleBar.removeEventListener(MouseEvent.MOUSE_MOVE, moveWindow);
				thisWindow.restore();
				thisWindow.m
				maximizeButton.icon = maximizeIcon;
				//thisWindow.x = stage.mouseX;
				//thisWindow.y = stage.mouseY;
				//thisWindow.startMove();
				moveWindow(event);
			}
		}*/

    } // end function


    /**
	 * 
	 * @param event
	 */
    private function resizeWindow(event:MouseEvent):Void
    {
        if(event.target == _resizeGrabberTL)
        {
            thisWindow.startResize(NativeWindowResize.TOP_LEFT);
        }
        if(event.target == _resizeGrabberTR)
        {
            thisWindow.startResize(NativeWindowResize.TOP_RIGHT);
        }
        if(event.target == _resizeGrabberBL)
        {
            thisWindow.startResize(NativeWindowResize.BOTTOM_LEFT);
        }
        if(event.target == _resizeGrabberBR)
        {
            thisWindow.startResize(NativeWindowResize.BOTTOM_RIGHT);
        }

        if(event.target == _resizeGrabberTE)
        {
            thisWindow.startResize(NativeWindowResize.TOP);
        }
        if(event.target == _resizeGrabberBE)
        {
            thisWindow.startResize(NativeWindowResize.BOTTOM);
        }
        if(event.target == _resizeGrabberLE)
        {
            thisWindow.startResize(NativeWindowResize.LEFT);
        }
        if(event.target == _resizeGrabberRE)
        {
            thisWindow.startResize(NativeWindowResize.RIGHT);
        }

    } // end function


    /**
	 * 
	 * @param event
	 */
    private function resizeAlign(event:Event = null):Void
    {
        //trace("window closed: " + thisWindow.closed);
        //trace("Window title: " + thisWindow.title);
        var borderAndPaddingWidth:Int = padding + Std.int(_drawElement.style.borderWidth);

        closeButton.x = thisWindow.width - closeButton.width - borderAndPaddingWidth;
        closeButton.y = borderAndPaddingWidth;
        maximizeButton.x = closeButton.x - maximizeButton.width;
        maximizeButton.y = borderAndPaddingWidth;
        minimizeButton.x = maximizeButton.x - minimizeButton.width;
        minimizeButton.y = borderAndPaddingWidth;


        _drawElement.width = thisWindow.width - padding * 2;
        _drawElement.height = thisWindow.height - padding * 2;
        //_drawElement.x = 0;
        //_drawElement.y = 0;

        _titleBar.width = thisWindow.width - borderAndPaddingWidth * 2;
        _titleBar.height = _titleBarHeight + _titleBar.style.borderBottomWidth;
        _titleBar.x = borderAndPaddingWidth;
        _titleBar.y = borderAndPaddingWidth;


        contentMask.width = thisWindow.width - borderAndPaddingWidth * 2;
        contentMask.height = thisWindow.height - _titleBar.height - borderAndPaddingWidth * 2;

        drawResizeGrabber();

        //
        panelBounds.width = Std.int(contentMask.width);
        panelBounds.height = Std.int(contentMask.height);

    } // end function


    /**
	 * 
	 * @param event
	 */
    private function closeTimerHandler(event:TimerEvent):Void
    {
        cast(event.target, Timer).stop();
        event.target.removeEventListener(TimerEvent.TIMER, closeTimerHandler);
        thisWindow.close();

    } // end function


    /**
	 * Change the cursor based on the event type, and event target.
	 * 
	 * @param event
	 */
    private function changeCursor(event:MouseEvent):Void
    {
        BMouseCursor.initialize();

        /*if(event.type == MouseEvent.ROLL_OVER)
		{
			switch(event.currentTarget)
			{
				case _titleBar:
					Mouse.cursor = BMouseCursor.MOVE;
				
				case resizeGrabberTL:
					Mouse.cursor = BMouseCursor.RESIZE_TOP_LEFT;
				
				case resizeGrabberTR:
					Mouse.cursor = BMouseCursor.RESIZE_TOP_RIGHT;
				
				case resizeGrabberTE:
					Mouse.cursor = BMouseCursor.RESIZE_TOP;
				
				case resizeGrabberBL:
					Mouse.cursor = BMouseCursor.RESIZE_BOTTOM_LEFT;
				
				case resizeGrabberBR:
					Mouse.cursor = BMouseCursor.RESIZE_BOTTOM_RIGHT;
				
				case resizeGrabberBE:
					Mouse.cursor = BMouseCursor.RESIZE_BOTTOM;
				
				case resizeGrabberLE:
					Mouse.cursor = BMouseCursor.RESIZE_LEFT;
				
				case resizeGrabberRE:
					Mouse.cursor = BMouseCursor.RESIZE_RIGHT;
				
			} // end switch
		} // end if
		else if(event.type == MouseEvent.ROLL_OUT)
			Mouse.cursor = MouseCursor.AUTO;*/

        //if(event.type == MouseEvent.MOUSE_OVER)
        if(event.type == MouseEvent.ROLL_OVER)
        {
            if(event.currentTarget == _titleBar)
                Mouse.cursor = BMouseCursor.MOVE;
            else if(event.currentTarget == _resizeGrabberTL)
                Mouse.cursor = BMouseCursor.RESIZE_TOP_LEFT;
            else if(event.currentTarget == _resizeGrabberTR)
                Mouse.cursor = BMouseCursor.RESIZE_TOP_RIGHT;
            else if(event.currentTarget == _resizeGrabberTE)
                Mouse.cursor = BMouseCursor.RESIZE_TOP;
            else if(event.currentTarget == _resizeGrabberBL)
                Mouse.cursor = BMouseCursor.RESIZE_BOTTOM_LEFT;
            else if(event.currentTarget == _resizeGrabberBR)
                Mouse.cursor = BMouseCursor.RESIZE_BOTTOM_RIGHT;
            else if(event.currentTarget == _resizeGrabberBE)
                Mouse.cursor = BMouseCursor.RESIZE_BOTTOM;
            else if(event.currentTarget == _resizeGrabberLE)
                Mouse.cursor = BMouseCursor.RESIZE_LEFT;
            else if(event.currentTarget == _resizeGrabberRE)
                Mouse.cursor = BMouseCursor.RESIZE_RIGHT;

            //Mouse.cursor = MouseCursor.IBEAM;
        }
            //else if(event.type == MouseEvent.MOUSE_OUT)
        else if(event.type == MouseEvent.ROLL_OUT)
            Mouse.cursor = MouseCursor.AUTO;

    } // end function


    /**
	 * 
	 * @param	event
	 */
    private function timerResizeHandler(event:TimerEvent):Void
    {
        //Timer(event.target).removeEventListener(TimerEvent.TIMER, timerResizeHandler);

        if(Math.abs(tempWidth - thisWindow.width) <= 1)
        {
            thisWindow.width = tempWidth;
        }
        else
        {
            thisWindow.width += (tempWidth - thisWindow.width) * 0.3;
        }

        if(Math.abs(tempHeight - thisWindow.height) <= 1)
        {
            thisWindow.height = tempHeight;
        }
        else
        {
            thisWindow.height += (tempHeight - thisWindow.height) * 0.3;
        }

        resizeAlign();
    } // end function


    /**
	 * 
	 * @param event
	 */
    private function draw(event:Event = null):Void
    {
        trace("BNativeWindow | draw()");
        var borderAndPaddingWidth:Int = padding + Std.int(_drawElement.style.borderWidth);

        _drawElement.width = thisWindow.width - padding * 2;
        _drawElement.height = thisWindow.height - padding * 2;
        _drawElement.x = padding;
        _drawElement.y = padding;

        // draw the titleBar
        _titleBar.width = thisWindow.width - borderAndPaddingWidth * 2;
        _titleBar.height = _titleBarHeight + _titleBar.style.borderBottomWidth;
        titleBar.x = borderAndPaddingWidth;
        titleBar.y = borderAndPaddingWidth;

        //
        _content.x = borderAndPaddingWidth;
        _content.y = _titleBar.height + borderAndPaddingWidth;

        //
        contentMask.x = borderAndPaddingWidth;
        contentMask.y = _titleBar.height + borderAndPaddingWidth;
        contentMask.width = thisWindow.width - borderAndPaddingWidth * 2;
        contentMask.height = thisWindow.height - _titleBar.height - borderAndPaddingWidth * 2;

        //
        panelBounds.width = Std.int(contentMask.width);
        panelBounds.height = Std.int(contentMask.height);

    } // end function


    //************************************* FUNCTIONS ******************************************


    /**
	 * 
	 */
    private function initialize(bounds:Rectangle = null):Void
    {
        // set the scale mode to 'no scale' so that the application does not change scale when resizing
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT; // set the alignment to the top left


        // set some essentail NativeWindow properties
        thisWindow.bounds = bounds != null ? bounds : new Rectangle(0, 0, 800, 600);
        thisWindow.maxSize = new Point(NativeWindow.systemMaxSize.x, NativeWindow.systemMaxSize.y);
        //this.minSize = new Point(300, 300);


        // create and add assets
        container = new Sprite();
        thisWindow.stage.addChild(container);


        // drawing element for styling
        _drawElement = new BElement();
        _drawElement.style.backgroundColor = 0x000000;
        _drawElement.style.backgroundOpacity = 1;
        _drawElement.style.borderColor = 0x00CCFF;
        _drawElement.style.borderOpacity = 0.8;
        _drawElement.style.borderWidth = 2;
        _drawElement.x = padding;
        _drawElement.y = padding;
        container.addChild(_drawElement);


        // titleBar
        _titleBar = new BTitleBar(container, padding, padding, super.title);
        _titleBar.width = thisWindow.width - cast(_drawElement.style.borderWidth) * 2 - padding * 2;
        _titleBar.height = 30;
        _titleBar.focusEnabled = false;


        // resize grabbers
        _resizeGrabberTL = new Sprite();
        _resizeGrabberTR = new Sprite();
        _resizeGrabberBL = new Sprite();
        _resizeGrabberBR = new Sprite();
        _resizeGrabberTE = new Sprite();
        _resizeGrabberBE = new Sprite();
        _resizeGrabberLE = new Sprite();
        _resizeGrabberRE = new Sprite();

        container.addChild(_resizeGrabberTL);
        container.addChild(_resizeGrabberTR);
        container.addChild(_resizeGrabberBL);
        container.addChild(_resizeGrabberBR);
        container.addChild(_resizeGrabberTE);
        container.addChild(_resizeGrabberBE);
        container.addChild(_resizeGrabberLE);
        container.addChild(_resizeGrabberRE);


        // initialize window buttons
        closeButton = new BLabelButton();
        minimizeButton = new BLabelButton();
        maximizeButton = new BLabelButton();

        closeButton.setStateColors(0x00000000, 0xCC0000, 0xFF6666, 0x000000, 0x0099CC, 0x00CCFF, 0x006699, 0x0099CC);
        minimizeButton.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x0099CC, 0x00CCFF, 0x006699, 0x0099CC);
        maximizeButton.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x0099CC, 0x00CCFF, 0x006699, 0x0099CC);

        closeButton.setStateAlphas(0, 1, 1, 1, 0, 0, 0, 0);
        minimizeButton.setStateAlphas(0, 1, 1, 1, 0, 0, 0, 0);
        maximizeButton.setStateAlphas(0, 1, 1, 1, 0, 0, 0, 0);


        // icons
        xIcon = new Bitmap(Assets.getBitmapData("graphics/x icon 01 10x10.png"));
        minimizeIcon = new Bitmap(Assets.getBitmapData("graphics/minimize icon 01 10x10.png"));
        maximizeIcon = new Bitmap(Assets.getBitmapData("graphics/maximize icon 01 10x10.png"));
        windowIcon = new Bitmap(Assets.getBitmapData("graphics/window icon 01 10x10.png"));

        closeButton.icon = xIcon;
        minimizeButton.icon = minimizeIcon;
        maximizeButton.icon = maximizeIcon;


        // title text
        activatedTF = new TextFormat("Calibri", 16, _titleTextColor, false);
        deactivatedTF = new TextFormat("Calibri", 16, _titleTextColor, false);


        // content
        _content = new Sprite();
        _content.x = padding;
        _content.y = padding + _titleBar.height;

        contentMask = new Shape();
        contentMask.graphics.beginFill(0xFF00FF, 1);
        contentMask.graphics.drawRect(0, 0, 100, 100);
        contentMask.graphics.endFill();
        contentMask.x = padding;
        contentMask.y = padding + _titleBar.height;
        container.addChild(contentMask);
        _content.mask = contentMask;


        // add assets to container
        container.addChild(closeButton);
        //container.addChild(minimizeButton);
        //container.addChild(maximizeButton);
        container.addChild(_content);

        if(thisWindow.maximizable)
        {
            container.addChild(maximizeButton);
        }
        if(minimizable)
        {
            container.addChild(minimizeButton);
        }

        // testing
        panelBounds = new BPanelBounds(_content);

        //
        titleBarMode = BTitleBarMode.COMPACT_TEXT;
        drawResizeGrabber();
        draw();
        resizeAlign();


        // event handling
        closeButton.addEventListener(MouseEvent.CLICK, closeWindow);
        minimizeButton.addEventListener(MouseEvent.CLICK, minimizeWindow);
        maximizeButton.addEventListener(MouseEvent.CLICK, maximizeWindow);

        _titleBar.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);

        if(thisWindow.resizable)
        {
            _resizeGrabberTL.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
            _resizeGrabberTR.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
            _resizeGrabberBL.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
            _resizeGrabberBR.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
            _resizeGrabberTE.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
            _resizeGrabberBE.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
            _resizeGrabberLE.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
            _resizeGrabberRE.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
            thisWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, resizeAlign);
            thisWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeAlign);

            //thisWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, draw);
            //thisWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, draw);
        }

        initializeCursorEvent();

        // woot the fucks?
        _drawElement.style.addEventListener(BStyleEvent.STYLE_CHANGE, styleChangeHandler);
        _titleBar.style.addEventListener(BStyleEvent.STYLE_CHANGE, styleChangeHandler);

    } // end function


    /**
	 * 
	 */
    private function drawResizeGrabber():Void
    {
        var color:UInt = 0x000000;
        var alpha:Float = 0.01;
        //var alpha:Float = 0.5;

        _resizeGrabberTL.scaleX =
        _resizeGrabberTR.scaleX =
        _resizeGrabberBL.scaleX =
        _resizeGrabberBR.scaleX =
        _resizeGrabberTE.scaleX =
        _resizeGrabberBE.scaleX =
        _resizeGrabberLE.scaleX =
        _resizeGrabberRE.scaleX = 1;

        _resizeGrabberTL.scaleY =
        _resizeGrabberTR.scaleY =
        _resizeGrabberBL.scaleY =
        _resizeGrabberBR.scaleY =
        _resizeGrabberTE.scaleY =
        _resizeGrabberBE.scaleY =
        _resizeGrabberLE.scaleY =
        _resizeGrabberRE.scaleY = 1;


        _resizeGrabberTL.graphics.clear();
        _resizeGrabberTR.graphics.clear();
        _resizeGrabberBL.graphics.clear();
        _resizeGrabberBR.graphics.clear();
        _resizeGrabberTE.graphics.clear();
        _resizeGrabberBE.graphics.clear();
        _resizeGrabberLE.graphics.clear();
        _resizeGrabberRE.graphics.clear();

        if(_windowShape == BShape.RECTANGULAR)
        {
            var grabbersWidth:Int = Std.int(thisWindow.width - padding * 2);
            var grabbersHeight:Int = Std.int(thisWindow.height - padding * 2);

            _resizeGrabberTL.graphics.beginFill(color, alpha);
            _resizeGrabberTR.graphics.beginFill(color, alpha);
            _resizeGrabberBL.graphics.beginFill(color, alpha);
            _resizeGrabberBR.graphics.beginFill(color, alpha);
            _resizeGrabberTE.graphics.beginFill(color, alpha);
            _resizeGrabberBE.graphics.beginFill(color, alpha);
            _resizeGrabberLE.graphics.beginFill(color, alpha);
            _resizeGrabberRE.graphics.beginFill(color, alpha);

            _resizeGrabberTL.graphics.drawRect(0, 0, resizeGrabberThickness, resizeGrabberThickness);
            _resizeGrabberTR.graphics.drawRect(0, 0, resizeGrabberThickness, resizeGrabberThickness);
            _resizeGrabberBL.graphics.drawRect(0, 0, resizeGrabberThickness, resizeGrabberThickness);
            _resizeGrabberBR.graphics.drawRect(0, 0, resizeGrabberThickness, resizeGrabberThickness);
            _resizeGrabberTE.graphics.drawRect(0, 0, grabbersWidth, resizeGrabberThickness);
            _resizeGrabberBE.graphics.drawRect(0, 0, grabbersWidth, resizeGrabberThickness);
            _resizeGrabberLE.graphics.drawRect(0, 0, resizeGrabberThickness, grabbersHeight);
            _resizeGrabberRE.graphics.drawRect(0, 0, resizeGrabberThickness, grabbersHeight);

            _resizeGrabberTL.graphics.endFill();
            _resizeGrabberTR.graphics.endFill();
            _resizeGrabberBL.graphics.endFill();
            _resizeGrabberBR.graphics.endFill();
            _resizeGrabberTE.graphics.endFill();
            _resizeGrabberBE.graphics.endFill();
            _resizeGrabberLE.graphics.endFill();
            _resizeGrabberRE.graphics.endFill();


            _resizeGrabberTL.x = padding - resizeGrabberThickness;
            _resizeGrabberTL.y = padding - resizeGrabberThickness;
            _resizeGrabberTR.x = thisWindow.width - padding;
            _resizeGrabberTR.y = padding - resizeGrabberThickness;
            _resizeGrabberBL.x = padding - resizeGrabberThickness;
            _resizeGrabberBL.y = thisWindow.height - padding;
            _resizeGrabberBR.x = thisWindow.width - padding;
            _resizeGrabberBR.y = thisWindow.height - padding;

            _resizeGrabberTE.x = padding;
            _resizeGrabberTE.y = padding - resizeGrabberThickness;
            _resizeGrabberBE.x = padding;
            _resizeGrabberBE.y = thisWindow.height - padding;
            _resizeGrabberLE.x = padding - resizeGrabberThickness;
            _resizeGrabberLE.y = padding;
            _resizeGrabberRE.x = thisWindow.width - padding;
            _resizeGrabberRE.y = padding;

        }
        else if(_windowShape == BShape.CIRCULAR)
        {
            var radius:Float = thisWindow.width / 2 - padding;
            var segmentAngle:Float = Math.PI / 40;

            _resizeGrabberTL.x = thisWindow.width / 2;
            _resizeGrabberTR.x = thisWindow.width / 2;
            _resizeGrabberBL.x = thisWindow.width / 2;
            _resizeGrabberBR.x = thisWindow.width / 2;
            _resizeGrabberTE.x = thisWindow.width / 2;
            _resizeGrabberBE.x = thisWindow.width / 2;
            _resizeGrabberLE.x = thisWindow.width / 2;
            _resizeGrabberRE.x = thisWindow.width / 2;

            _resizeGrabberTL.y = thisWindow.width / 2;
            _resizeGrabberTR.y = thisWindow.width / 2;
            _resizeGrabberBL.y = thisWindow.width / 2;
            _resizeGrabberBR.y = thisWindow.width / 2;
            _resizeGrabberTE.y = thisWindow.width / 2;
            _resizeGrabberBE.y = thisWindow.width / 2;
            _resizeGrabberLE.y = thisWindow.width / 2;
            _resizeGrabberRE.y = thisWindow.width / 2;

            _resizeGrabberTL.graphics.lineStyle(resizeGrabberThickness, color, alpha);
            _resizeGrabberTR.graphics.lineStyle(resizeGrabberThickness, color, alpha);
            _resizeGrabberBL.graphics.lineStyle(resizeGrabberThickness, color, alpha);
            _resizeGrabberBR.graphics.lineStyle(resizeGrabberThickness, color, alpha);
            _resizeGrabberTE.graphics.lineStyle(resizeGrabberThickness, color, alpha);
            _resizeGrabberBE.graphics.lineStyle(resizeGrabberThickness, color, alpha);
            _resizeGrabberLE.graphics.lineStyle(resizeGrabberThickness, color, alpha);
            _resizeGrabberRE.graphics.lineStyle(resizeGrabberThickness, color, alpha);


            _resizeGrabberTL.graphics.moveTo(thisWindow.width / 2 - padding, 0);
            _resizeGrabberTR.graphics.moveTo(thisWindow.width / 2 - padding, 0);
            _resizeGrabberBL.graphics.moveTo(thisWindow.width / 2 - padding, 0);
            _resizeGrabberBR.graphics.moveTo(thisWindow.width / 2 - padding, 0);
            _resizeGrabberTE.graphics.moveTo(thisWindow.width / 2 - padding, 0);
            _resizeGrabberBE.graphics.moveTo(thisWindow.width / 2 - padding, 0);
            _resizeGrabberLE.graphics.moveTo(thisWindow.width / 2 - padding, 0);
            _resizeGrabberRE.graphics.moveTo(thisWindow.width / 2 - padding, 0);

            for(i in 1...11)
            {
                /* calculation:
				 * full circle = 2PI
				 * 8 grabbers
				 * 10 lines per grabber
				 * ... 2PI/ (8 * 10) = 2PI/80 = PI/40
				 */
                _resizeGrabberTL.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
                _resizeGrabberTR.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
                _resizeGrabberBL.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
                _resizeGrabberBR.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
                _resizeGrabberTE.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
                _resizeGrabberBE.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
                _resizeGrabberLE.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
                _resizeGrabberRE.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
            }

        }

    } // end function


    /**
	 * 
	 */
    private function initializeCursorEvent():Void
    {
        _titleBar.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
        _titleBar.addEventListener(MouseEvent.ROLL_OUT, changeCursor);


        if(resizable)
        {
            _resizeGrabberTL.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
            _resizeGrabberTR.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
            _resizeGrabberBL.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
            _resizeGrabberBR.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
            _resizeGrabberTE.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
            _resizeGrabberBE.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
            _resizeGrabberLE.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
            _resizeGrabberRE.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
            _resizeGrabberTL.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
            _resizeGrabberTR.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
            _resizeGrabberBL.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
            _resizeGrabberBR.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
            _resizeGrabberTE.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
            _resizeGrabberBE.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
            _resizeGrabberLE.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
            _resizeGrabberRE.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
        }
    } // end function


    /**
	 * 
	 * @param _width
	 * @param _height
	 * @param animate
	 */
    public function resize(_width:Int, _height:Int, animate:Bool = true):Void
    {
        // check to see if window is open
        if(!thisWindow.closed)
        {
            if(animate)
            {

                var timer:Timer = new Timer(1000 / 60, 20);

                timer.addEventListener(TimerEvent.TIMER, timerResizeHandler);
                timer.start();
                tempWidth = _width;
                tempHeight = _height;
            }
            else
            {
                //super.width = _width;
                //super.height = _height;
                thisWindow.width = _width;
                thisWindow.height = _height;
                resizeAlign();
            }
        }
    } // end function


    // ************************************************* SET AND GET **************************************************


    private function get_titleBar():BTitleBar
    {
        return _titleBar;
    }


    private function get_titleTextColor():UInt
    {
        return cast(activatedTF.color);
    }

    private function set_titleTextColor(value:UInt):UInt
    {
        return activatedTF.color = value;
    }


    private function get_titleBarHight():Float
    {
        return _titleBar.height;
    }


    private function get_titleBarMode():BTitleBarMode
    {
        return _titleBarMode;
    }

    private function set_titleBarMode(value:BTitleBarMode):BTitleBarMode
    {
        _titleBarMode = value;
        _titleBar.mode = _titleBarMode;

        if(_titleBarMode != BTitleBarMode.NONE)
        {
            closeButton.visible = true;
            maximizeButton.visible = true;
            minimizeButton.visible = true;

            if(_titleBarMode != BTitleBarMode.MINIMAL)
            {

                closeButton.icon = xIcon;
                maximizeButton.icon = maximizeIcon;
                minimizeButton.icon = minimizeIcon;
            }

        }


        switch(_titleBarMode)
        {
            case BTitleBarMode.COMPACT_TEXT:
                _titleBarHeight = 30;

            case BTitleBarMode.COMPACT_ICON:
                _titleBarHeight = 40;

            case BTitleBarMode.FULL_TEXT:
                _titleBarHeight = 48;

            case BTitleBarMode.FULL_ICON:
                _titleBarHeight = 48;

            case BTitleBarMode.MINIMAL:
                _titleBarHeight = 10;

                closeButton.icon = null;
                maximizeButton.icon = null;
                minimizeButton.icon = null;

            case BTitleBarMode.NONE:
                _titleBar.scaleY = 0; // scale is changed so the the height becomes 0 and makes the content position change when drawn
                _titleBar.visible = false;

                closeButton.visible = false;
                maximizeButton.visible = false;
                minimizeButton.visible = false;

        } // end switch


        closeButton.setSize(_titleBarHeight, _titleBarHeight);
        maximizeButton.setSize(_titleBarHeight, _titleBarHeight);
        minimizeButton.setSize(_titleBarHeight, _titleBarHeight);


        draw();
        return _titleBarMode;
    }


    private function get_bMenu():BMenu
    {
        return _bMenu;
    }

    private function set_bMenu(value:BMenu):BMenu
    {
        if(_bMenu != null)
        {
            trace("This window already has a menu.");
            return _bMenu;
        }
        _bMenu = value;
        _bMenu.display(container.stage, padding, padding);
        return _bMenu;
    }


    private function get_backgroundDrag():Bool
    {
        return _backgroundDrag;
    }

    private function set_backgroundDrag(value:Bool):Bool
    {
        _backgroundDrag = value;
        if(value)
        {
            _drawElement.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
        }
        else
        {
            if(_drawElement.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                _drawElement.removeEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
            }
        }
        return _backgroundDrag;
    }


    private function get_windowShape():BShape
    {
        return _windowShape;
    }

    private function set_windowShape(value:BShape):BShape
    {
        _windowShape = value;

        if(value == BShape.RECTANGULAR)
        {

            // redraw mask


            // redraw grabbers
            _resizeGrabberTL.rotation = 0;
            _resizeGrabberTR.rotation = 0;
            _resizeGrabberBL.rotation = 0;
            _resizeGrabberBR.rotation = 0;
            _resizeGrabberTE.rotation = 0;
            _resizeGrabberBE.rotation = 0;
            _resizeGrabberLE.rotation = 0;
            _resizeGrabberRE.rotation = 0;
        }
        else if(value == BShape.CIRCULAR)
        {

            // redraw mask


            // redraw grabbers
            _resizeGrabberTL.rotation = -360 / 16 * 7;
            _resizeGrabberTR.rotation = -360 / 16 * 3;
            _resizeGrabberBL.rotation = 360 / 16 * 5;
            _resizeGrabberBR.rotation = 360 / 16 * 1;
            _resizeGrabberTE.rotation = -360 / 16 * 5;
            _resizeGrabberBE.rotation = 360 / 16 * 3;
            _resizeGrabberLE.rotation = 360 / 16 * 7;
            _resizeGrabberRE.rotation = -360 / 16 * 1;
        }

        drawResizeGrabber();
        draw();
        resizeAlign();
        return _windowShape;
    }


    private function get_content():DisplayObjectContainer
    {
        return _content;
    }


    /******************************* native windows overrides *************************************/

    #if flash
	private function set_menu(value:NativeMenu):Void
	{
		trace("You may want to use the borris.display.BNativeMenu class instead of the flash.display.NativeMenu class.");
		super.menu = value;
	}

	private function set_title(value:String):Void
	{
		super.title = value;
		_titleBar.title = value;
		draw();
	}
	
	private function get_title():String
	{
		return _titleBar.title;
	}
	#end

    private function get_style():BStyle
    {
        return _drawElement.style;
    }

    private function set_style(value:BStyle):BStyle
    {
        _drawElement.style = value;
        _drawElement.style.link = container;
        _drawElement.style.values = value.values;
        //dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE, this));
        return _drawElement.style;
    }


}
#end