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

package borris.containers;

#if flash import borris.ui.BMouseCursor; #end
import borris.controls.BLabelButton;
import borris.controls.BPlacement;
import borris.controls.BUIComponent;
import borris.controls.windowClasses.BTitleBar;
import borris.display.BElement;
import borris.display.BTitleBarMode;
import borris.events.BStyleEvent;

import lime.ui.Window;
import lime.ui.MouseCursor;

import motion.Actuate;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.geom.Point;
import openfl.text.TextFormat;
import openfl.utils.Timer;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 21/11/2015 (dd/mm/yyyy)
 */
class BPanel extends BUIComponent
{
    /**
	 * [read-only] A reference to the internal title bar.
	 */
    public var titleBar(get, never):BTitleBar;
    public var titleBarMode(get, set):BTitleBarMode;
    public var titleBarHeight(get, never):Float;
    public var backgroundDrag(get, set):Bool;
    public var content(get, never):DisplayObjectContainer;
    public var title(get, set):String;
    public var active(get, never):Bool;
    public var maxWidth(get, set):Int;
    public var maxHeight(get, set):Int;
    public var minWidth(get, set):Int;
    public var minHeight(get, set):Int;
    public var maxSize(get, set):Point;
    public var minSize(get, set):Point;
    public var maximizable(get, set):Bool;
    public var minimizable(get, set):Bool;
    public var resizable(get, set):Bool;
    public var closeable(get, set):Bool;
    public var draggable(get, set):Bool;
    public var collapsible(get, set):Bool;
    public var panelBounds(get, set):BPanelBounds;


    // static
    private static var _panels:Array<BPanel> = new Array<BPanel>();


    // assets
    private var _drawElement:BElement;
    private var _titleBar:BTitleBar;
    private var _minimizedButton:BLabelButton;

    private var _content:Sprite;
    private var _contentMask:Shape;

    private var _closeButton:BLabelButton;
    private var _minimizeButton:BLabelButton;
    private var _maximizeButton:BLabelButton;
    private var _collapseButton:BLabelButton;
    //private var _contextMenu:BContextMenu;

    // icons
    private var _xIcon:DisplayObject;
    private var _maximizeIcon:DisplayObject;
    private var _minimizeIcon:DisplayObject;
    private var _windowIcon:DisplayObject;
    private var _arrowIcon:DisplayObject;

    // resize grabbers
    private var _resizeGrabberTL:Sprite;
    private var _resizeGrabberTR:Sprite;
    private var _resizeGrabberBL:Sprite;
    private var _resizeGrabberBR:Sprite;
    private var _resizeGrabberTE:Sprite;
    private var _resizeGrabberBE:Sprite;
    private var _resizeGrabberLE:Sprite;
    private var _resizeGrabberRE:Sprite;


    // resizing and mouse variables
    //private var beginMouseX:Int;								// Not actually used for anything.
    //private var beginMouseY:Int;								// Not actually used for anything.
    //private var endMouseX:Int;								// Not actually used for anything.
    //private var endMouseY:Int;								// Not actually used for anything.
    //private var beginMousePoint:Point;						// Not actually used for anything.
    //private var endMousePoint:Point;							// Not actually used for anything.
    //private var mouseIsDown:Bool;								// Not actually used for anything.
    private var _mouseEventTarget:Sprite; //
    private var _registrationPoint:Point = new Point(0, 0);


    // other
    private var _padding:Float = 2; // This is not the same as the BNativeWindow padding, but similar.
    private var _activatedTF:TextFormat; //
    private var _deactivatedTF:TextFormat; //
    private var _tempX:Int; // A holder for previous state x position
    private var _tempY:Int; // A holder for previous state y position
    private var _tempWidth:Int; // A holder for previous state width
    private var _tempHeight:Int; // A holder for previous state height
    private var _resizeToWidth:Int; //
    private var _resizeToHeight:Int; //
    private var _resizeGrabberThickness:Int = 5; // The thickness of the resize grabbers. It would be wise to change this on mobile devices, or when a touch event is detected.

    //private var _resizePosition:String = "";					// The position that the user is resizing the panel from. (topLeft, topRight, left, etc)


    // set and get
    private var _active:Bool; // [read-only]
    private var _alwaysInFroInt:Bool; // Set or get
    private var _closed:Bool; // [read-only]
    private var _displayState:String = "normal"; // [read-only]

    private var _maxSize:Point = new Point(2048, 2048); //
    private var _minSize:Point = new Point(100, 100); //

    private var _maximizable:Bool = true; //
    private var _minimizable:Bool = true; //
    private var _resizable:Bool = true; // Get or set whether this Panel is resizable.
    private var _closeable:Bool = true; // Get or set whether this Panel is closeable.
    private var _draggable:Bool = true; // Get or set whether this Panel is draggable.
    private var _collapsible:Bool = true; // Get or set whether this Panel is collapible.
    private var _panelBounds:BPanelBounds;


    private var _titleTextColor:UInt = 0xFFFFFF;

    //private var _bMenu:BNativeMenu;									//
    private var _backgroundDrag:Bool = false; //

    private var _titleBarMode:BTitleBarMode = BTitleBarMode.MINIMAL; // The mode of the title bar. 4 modes in total. minimal (3 dots), compact (text or icon), full (text and icon)
    private var _titleBarHeight:Int; // [read-only] The height of the title bar after calculating the titleBar height and mode, etc

    // TODO recreate BPanel from scratch
    // TODO change contructor to accomidate for BUIComponent contructor arguments
    // public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, title:String = "")
    public function new(title:String = "")
    {
        super(null, 0, 0);

        // constructor code
        _width = 500;
        _height = 500;

        // assets
        _drawElement = new BElement();
        _drawElement.style.backgroundColor = 0x000000;
        _drawElement.style.backgroundOpacity = 1;
        _drawElement.style.borderColor = 0x00CCFF;
        _drawElement.style.borderOpacity = 0.8;
        _drawElement.style.borderWidth = 2;
        addChild(_drawElement);
        _style = _drawElement.style;

        //
        _titleBar = new BTitleBar(this, 0, 0, title);
        _titleBar.width = _width;
        _titleBar.height = 30;
        _titleBar.focusEnabled = false;

        _minimizedButton = new BLabelButton();
        _minimizedButton.setStateColors(0x000000, 0xFFFFFF, 0xFFFFFF, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000);
        _minimizedButton.setStateAlphas(0.1, 0.4, 0.2, 0, 0, 0, 0, 0);
        cast(_minimizedButton.getSkin("upSkin"), BElement).style.borderBottomWidth =
        cast(_minimizedButton.getSkin("overSkin"), BElement).style.borderBottomWidth =
        cast(_minimizedButton.getSkin("downSkin"), BElement).style.borderBottomWidth =
        cast(_minimizedButton.getSkin("disabledSkin"), BElement).style.borderBottomWidth =
        cast(_minimizedButton.getSkin("selectedUpSkin"), BElement).style.borderBottomWidth =
        cast(_minimizedButton.getSkin("selectedOverSkin"), BElement).style.borderBottomWidth =
        cast(_minimizedButton.getSkin("selectedDownSkin"), BElement).style.borderBottomWidth =
        cast(_minimizedButton.getSkin("selectedDisabledSkin"), BElement).style.borderBottomWidth = 2;
        cast(_minimizedButton.getSkin("upSkin"), BElement).style.borderColor =
        cast(_minimizedButton.getSkin("overSkin"), BElement).style.borderColor =
        cast(_minimizedButton.getSkin("downSkin"), BElement).style.borderColor =
        cast(_minimizedButton.getSkin("disabledSkin"), BElement).style.borderColor =
        cast(_minimizedButton.getSkin("selectedUpSkin"), BElement).style.borderColor =
        cast(_minimizedButton.getSkin("selectedOverSkin"), BElement).style.borderColor =
        cast(_minimizedButton.getSkin("selectedDownSkin"), BElement).style.borderColor =
        cast(_minimizedButton.getSkin("selectedDisabledSkin"), BElement).style.borderColor = 0x3399CC;
        _minimizedButton.setSize(40, 40);

        // BUG display objects under mask does not show
        // content
        _content = new Sprite();

        _contentMask = new Shape();
        _contentMask.graphics.beginFill(0xFF00FF, 1);
        _contentMask.graphics.drawRect(0, 0, 100, 100);
        _contentMask.graphics.endFill();
        _content.mask = _contentMask;


        // initialize Panel buttons
        _closeButton = new BLabelButton();
        _minimizeButton = new BLabelButton();
        _maximizeButton = new BLabelButton();
        _collapseButton = new BLabelButton();

        _closeButton.setStateColors(0x000000, 0xCC0000, 0xFF6666, 0x000000, 0x000000, 0xCC0000, 0xFF6666, 0x000000);
        _minimizeButton.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x000000, 0x00CCFF, 0x999999, 0x000000);
        _maximizeButton.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x000000, 0x00CCFF, 0x999999, 0x000000);
        _collapseButton.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x000000, 0x00CCFF, 0x999999, 0x000000);

        _closeButton.setStateAlphas(0, 0.8, 0.8, 0.8, 0, 0.8, 0.8, 0.8);
        _minimizeButton.setStateAlphas(0, 0.8, 0.8, 0.8, 0, 0.8, 0.8, 0.8);
        _maximizeButton.setStateAlphas(0, 0.8, 0.8, 0.8, 0, 0.8, 0.8, 0.8);
        _collapseButton.setStateAlphas(0, 0.8, 0.8, 0.8, 0, 0.8, 0.8, 0.8);

        _closeButton.iconPlacement =
        _minimizeButton.iconPlacement =
        _maximizeButton.iconPlacement =
        _collapseButton.iconPlacement = BPlacement.CENTER;

        //_closeButton.setSize(30, 30);
        //_minimizeButton.setSize(30, 30);
        //_maximizeButton.setSize(30, 30);
        /*var buttons:Array<BLabelButton> = new Array<BLabelButton>();
		buttons.push(_closeButton);
		buttons.push(_minimizeButton);
		buttons.push(_maximizeButton);
		buttons.push(_collapseButton);
		_titleBar.buttons = [_closeButton, _minimizeButton, _maximizeButton, _collapseButton];*/

        // icons
        _xIcon = new Bitmap(Assets.getBitmapData("graphics/x icon 01 10x10.png"));
        _minimizeIcon = new Bitmap(Assets.getBitmapData("graphics/minimize icon 01 10x10.png"));
        _maximizeIcon = new Bitmap(Assets.getBitmapData("graphics/maximize icon 01 10x10.png"));
        _windowIcon = new Bitmap(Assets.getBitmapData("graphics/window icon 01 10x10.png"));
        //_arrowIcon = new Bitmap(Assets.getBitmapData("graphics/menu arrow icon 01 10x10.png"));
        _arrowIcon = new Sprite();
        var arrowBtm = new Bitmap(Assets.getBitmapData("graphics/menu arrow icon 01 10x10.png"));
        arrowBtm.x = -arrowBtm.width / 2;
        arrowBtm.y = arrowBtm.height / 2;
        arrowBtm.rotation = -90;
        cast(_arrowIcon, DisplayObjectContainer).addChild(arrowBtm);
        _arrowIcon.rotation = 180;

        _closeButton.icon = _xIcon;
        _minimizeButton.icon = _minimizeIcon;
        _maximizeButton.icon = _maximizeIcon;
        _collapseButton.icon = _arrowIcon;


        // resize grabbers
        _resizeGrabberTL = new Sprite();
        _resizeGrabberTR = new Sprite();
        _resizeGrabberBL = new Sprite();
        _resizeGrabberBR = new Sprite();
        _resizeGrabberTE = new Sprite();
        _resizeGrabberBE = new Sprite();
        _resizeGrabberLE = new Sprite();
        _resizeGrabberRE = new Sprite();


        // title text
        _activatedTF = new TextFormat("Calibri", 16, _titleTextColor, false);
        _deactivatedTF = new TextFormat("Calibri", 16, _titleTextColor, false);


        // add assets to respective containers

        addChild(_closeButton);
        addChild(_minimizeButton);
        addChild(_maximizeButton);
        addChild(_collapseButton);
        addChild(_content);
        addChild(_contentMask);

        addChild(_resizeGrabberTL);
        addChild(_resizeGrabberTR);
        addChild(_resizeGrabberBL);
        addChild(_resizeGrabberBR);
        addChild(_resizeGrabberTE);
        addChild(_resizeGrabberBE);
        addChild(_resizeGrabberLE);
        addChild(_resizeGrabberRE);


        //
        titleBarMode = BTitleBarMode.COMPACT_TEXT;
        //snappable = _snappable;


        drawResizeGrabber();
        draw();
        checkWithinBounderies();


        // add the panels to the array
        _panels.push(this);


        // event handling
        _closeButton.addEventListener(MouseEvent.CLICK, mouseHandler);
        _minimizeButton.addEventListener(MouseEvent.CLICK, mouseHandler);
        _maximizeButton.addEventListener(MouseEvent.CLICK, mouseHandler);
        _collapseButton.addEventListener(MouseEvent.CLICK, mouseHandler);

        _titleBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
        _titleBar.addEventListener(MouseEvent.MOUSE_UP, stopDragPanel);

        _resizeGrabberTL.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
        _resizeGrabberTR.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
        _resizeGrabberBL.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
        _resizeGrabberBR.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
        _resizeGrabberTE.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
        _resizeGrabberBE.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
        _resizeGrabberLE.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
        _resizeGrabberRE.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);

        _resizeGrabberTL.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
        _resizeGrabberTR.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
        _resizeGrabberBL.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
        _resizeGrabberBR.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
        _resizeGrabberTE.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
        _resizeGrabberBE.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
        _resizeGrabberLE.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
        _resizeGrabberRE.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);

        initializeCursorEvent();

        // woot the fucks?
        _style.addEventListener(BStyleEvent.STYLE_CHANGE, styleChangeHandler);
        _titleBar.style.addEventListener(BStyleEvent.STYLE_CHANGE, styleChangeHandler);

        //filters = [new DropShadowFilter(0, 0, 0x000000, 1, 8, 8, 1, 1)];

    }


    //**************************************** HANDLERS *********************************************


    override private function onAddedToStage(event:Event):Void
    {
        super.onAddedToStage(event);
        // TODO optimize this
        stage.addEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
        stage.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
    }


    private function styleChangeHandler(event:BStyleEvent):Void
    {
        //draw();
    } // end function


    /**
	 * 
	 * @param	event
	 */
    private function mouseHandler(event:MouseEvent):Void
    {
        //activate();

        // quick fix
        /*if (_panelBounds)
		{
			if (_panelBounds.getSnappedPosition(this) == "")
			{
				activate();
			}
			
		} // end if*/
        orderToFront();

        if(event.currentTarget == _closeButton)
        {
            close();
        }
        else if(event.currentTarget == _maximizeButton)
        {
            trace("display state:" + _displayState);
            if(_displayState == "normal")
            {
                maximize();
            }
            else if(_displayState == "maximized")
            {
                trace("maximized button pressed and state is maximized");
                restore();
            }
            trace("display state:" + _displayState);
        }
        else if(event.currentTarget == _minimizeButton)
        {
            minimize();
        }
        else if(event.currentTarget == _collapseButton)
        {
            if(_displayState == "normal")
            {
                collapse();
            }
            else if(_displayState == "collapsed")
            {
                restoreSize();
            }
        }
        else if(event.currentTarget == _minimizedButton)
        {
            restore();
            orderToFront();
        }
        trace("current target: " + event.currentTarget);

    } // end function


    /**
	 * Drag the Panel by holding the mouse down on the appropriate asset.
	 * 
	 * @param	event
	 */
    private function startDragPanel(event:MouseEvent):Void
    {
        orderToFront();

        this.startDrag();
        // TODO restore the panel automatically when it is in a maximized state and the title bar starts getting dragged
        // BUG When the maximixed button is pressed again, this function is called and stops the normal restoration.
        /*if (_displayState == "maximized")
		{
			_displayState = "normal";
			padding = 10;
			_width = tempWidth;
			_height = tempHeight;
			x = parent.mouseX - _width/2;
			maximizeButton.icon = maximizeIcon;
			
			// testing (needs work)
			restoreSize();
			x = parent.mouseX - _width / 2;
			y = parent.mouseY - _titleBarHeight / 2;
			
			dispatchEvent(new Event(Event.RESIZE, false, false));
			draw();
		}*/
        //dispatchEvent(new BPanelEvent(BPanelEvent.MOVING, false, false);
    } // end function


    /**
	 * Stop dragging the Panel by releasing the mouse from the asset.
	 * 
	 * @param	event
	 */
    private function stopDragPanel(event:MouseEvent):Void
    {
        this.stopDrag();
        //dispatchEvent(new BPanelEvent(BPanelEvent.MOVE, false, false);

        checkWithinBounderies();

    } // end function


    /**
	 * Sets variables and and event listeners for resizing and snapping.
	 * 
	 * @param	event
	 */
    private function startResizePanel(event:MouseEvent):Void
    {
        var resizeGrabber:Sprite = cast(event.currentTarget);

        _mouseEventTarget = resizeGrabber;

        this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        this.dispatchEvent(new Event(Event.RESIZE, false, false));

    } // end function


    /**
	 * 
	 * @param	event
	 */
    private function stopResizePanel(event:MouseEvent = null):Void
    {
        var extra:Int = Std.int(-_padding + _resizeGrabberThickness);

        if(this.hasEventListener(Event.ENTER_FRAME))
            this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

        this.x += _registrationPoint.x;
        this.y += _registrationPoint.y;
        _registrationPoint.x = 0;
        _registrationPoint.y = 0;

        // draw the Panel
        draw();

        checkWithinBounderies();

    } // end function


    /**
	 * 
	 * @param	event
	 */
    private function enterFrameHandler(event:Event):Void
    {
        // some of this can be set in startResizeHandler

        //
        var extra:Int = Std.int((_padding * 2) - _resizeGrabberThickness);

        _width = _resizeGrabberRE.x - _resizeGrabberLE.x + extra; // the width of the Panel
        _height = _resizeGrabberBE.y - _resizeGrabberTE.y + extra; // the height of the Panel

        _registrationPoint.x = 0;
        _registrationPoint.y = 0;

        // Set the panelWidth and panelHeight properties
        // 4 conditions needed to accomodate for all 4 edges of the panel
        if(_mouseEventTarget == _resizeGrabberTR || _mouseEventTarget == _resizeGrabberTL)
        {
            _width = _resizeGrabberTR.x - _resizeGrabberTL.x + extra;
            _height = _resizeGrabberBE.y - _mouseEventTarget.y + extra;
        }
        else if(_mouseEventTarget == _resizeGrabberLE || _mouseEventTarget == _resizeGrabberRE)
        {
            _width = _resizeGrabberRE.x - _resizeGrabberLE.x + extra;
            _height = _resizeGrabberBE.y - _resizeGrabberTE.y + extra;
        }
        else if(_mouseEventTarget == _resizeGrabberTE || _mouseEventTarget == _resizeGrabberBE)
        {
            _width = _resizeGrabberTR.x - _resizeGrabberTL.x + extra;
            _height = _resizeGrabberBE.y - _resizeGrabberTE.y + extra;
        }
        else if(_mouseEventTarget == _resizeGrabberBL || _mouseEventTarget == _resizeGrabberBR)
        {
            _width = _resizeGrabberBR.x - _resizeGrabberBL.x + extra;
            _height = _mouseEventTarget.y - _resizeGrabberTE.y + extra;
        }

        // make sure _width and _height are not greater the or less then the max width/min width and max height/min height
        _width = Math.min(_maxSize.x, _width);
        _width = Math.max(_minSize.x, _width);

        _height = Math.min(_maxSize.y, _height);
        _height = Math.max(_minSize.y, _height);

        // set the mouseEventTarget to the mouse position
        _mouseEventTarget.x = mouseX;
        _mouseEventTarget.y = mouseY;


        // align the assets

        // top resizers
        if(_mouseEventTarget == _resizeGrabberTL || _mouseEventTarget == _resizeGrabberTR || _mouseEventTarget == _resizeGrabberTE)
        {
            _registrationPoint.y = _mouseEventTarget.y - _resizeGrabberThickness;
        }
        // left resizers
        if(_mouseEventTarget == _resizeGrabberTL || _mouseEventTarget == _resizeGrabberLE || _mouseEventTarget == _resizeGrabberBL)
        {
            _registrationPoint.x = _mouseEventTarget.x - _resizeGrabberThickness;
        }
            // right resizers
        else if(_mouseEventTarget == _resizeGrabberTR || _mouseEventTarget == _resizeGrabberRE || _mouseEventTarget == _resizeGrabberBR)
        {
            _registrationPoint.x = 0;
        }
            // bottom resizers
        else if(_mouseEventTarget == _resizeGrabberBL || _mouseEventTarget == _resizeGrabberBE || _mouseEventTarget == _resizeGrabberBR)
        {
            _registrationPoint.y = 0;
        }

        positionAssets();

        //
        //_content.dispatchEvent(new Event(Event.RESIZE));
        dispatchEvent(new Event(Event.RESIZE));

    } // end function


    /**
	 * 
	 * @param	event
	 */
    private function closeTimerHandler(event:TimerEvent):Void
    {
        cast(event.target, Timer).stop();
        cast(event.target, Timer).removeEventListener(TimerEvent.TIMER, closeTimerHandler);
        this.visible = false;

        dispatchEvent(new Event(Event.CLOSE, false, false));

    } // end function


    /**
	 * Change the cursor based on the event type, and event target
	 * 
	 * @param	event
	 */
    private function changeCursor(event:MouseEvent):Void
    {
        var window:lime.ui.Window = lime.app.Application.current.window;
        //var win:Window = new openfl.display.Window();
        // TODO modiffy changeCursor()
        // TODO make custom cursors in BMouseCursor class
        // TODO fix flash cursor switching
        //if(event.type == MouseEvent.MOUSE_OVER)
        if(event.type == MouseEvent.ROLL_OVER)
        {
            if(event.currentTarget == cast(_titleBar, Sprite))
                window.cursor = lime.ui.MouseCursor.MOVE;
            else if(event.currentTarget == _resizeGrabberTL)
                window.cursor = lime.ui.MouseCursor.RESIZE_NWSE;
            else if(event.currentTarget == _resizeGrabberTR)
                window.cursor = lime.ui.MouseCursor.RESIZE_NESW;
            else if(event.currentTarget == _resizeGrabberTE)
                window.cursor = lime.ui.MouseCursor.RESIZE_NS;
            else if(event.currentTarget == _resizeGrabberBL)
                window.cursor = lime.ui.MouseCursor.RESIZE_NESW;
            else if(event.currentTarget == _resizeGrabberBR)
                window.cursor = lime.ui.MouseCursor.RESIZE_NWSE;
            else if(event.currentTarget == _resizeGrabberBE)
                window.cursor = lime.ui.MouseCursor.RESIZE_NS;
            else if(event.currentTarget == _resizeGrabberLE)
                window.cursor = lime.ui.MouseCursor.RESIZE_WE;
            else if(event.currentTarget == _resizeGrabberRE)
                window.cursor = lime.ui.MouseCursor.RESIZE_WE;

        }
        else if(event.type == MouseEvent.MOUSE_OUT)
            window.cursor = lime.ui.MouseCursor.DEFAULT;


        #if flash
		BMouseCursor.initialize();
		if(event.type == MouseEvent.MOUSE_OVER)
		//if(event.type == MouseEvent.ROLL_OVER)
		{
			if (event.currentTarget == cast(_titleBar, Sprite))
				flash.ui.Mouse.cursor = BMouseCursor.MOVE;
			else if (event.currentTarget == _resizeGrabberTL)
				flash.ui.Mouse.cursor = BMouseCursor.RESIZE_TOP_LEFT;
			else if (event.currentTarget == _resizeGrabberTR)
				flash.ui.Mouse.cursor = BMouseCursor.RESIZE_TOP_RIGHT;
			else if (event.currentTarget == _resizeGrabberTE)
				flash.ui.Mouse.cursor = BMouseCursor.RESIZE_TOP;
			else if (event.currentTarget == _resizeGrabberBL)
				flash.ui.Mouse.cursor = BMouseCursor.RESIZE_BOTTOM_LEFT;
			else if (event.currentTarget == _resizeGrabberBR)
				flash.ui.Mouse.cursor = BMouseCursor.RESIZE_BOTTOM_RIGHT;
			else if (event.currentTarget == _resizeGrabberBE)
				flash.ui.Mouse.cursor = BMouseCursor.RESIZE_BOTTOM;
			else if (event.currentTarget == _resizeGrabberLE)
				flash.ui.Mouse.cursor = BMouseCursor.RESIZE_LEFT;
			else if (event.currentTarget == _resizeGrabberRE)
				flash.ui.Mouse.cursor = BMouseCursor.RESIZE_RIGHT;
				
			//flash.ui.Mouse.cursor = flash.ui.MouseCursor.IBEAM;
		}
		else if(event.type == MouseEvent.MOUSE_OUT)
		//else if(event.type == MouseEvent.ROLL_OUT)
			flash.ui.Mouse.cursor = flash.ui.MouseCursor.AUTO;
		#end
    } // end function


    //**************************************** FUNCTIONS ********************************************


    /**
	 * 
	 */
    private function initializeCursorEvent():Void
    {
        _titleBar.addEventListener(MouseEvent.MOUSE_OVER, changeCursor, false, 1);
        #if flash
		_titleBar.addEventListener(MouseEvent.MOUSE_OUT, changeCursor);
		#end


        if(_resizable)
        {
            _resizeGrabberTL.addEventListener(MouseEvent.MOUSE_OVER, changeCursor);
            _resizeGrabberTR.addEventListener(MouseEvent.MOUSE_OVER, changeCursor);
            _resizeGrabberBL.addEventListener(MouseEvent.MOUSE_OVER, changeCursor);
            _resizeGrabberBR.addEventListener(MouseEvent.MOUSE_OVER, changeCursor);
            _resizeGrabberTE.addEventListener(MouseEvent.MOUSE_OVER, changeCursor);
            _resizeGrabberBE.addEventListener(MouseEvent.MOUSE_OVER, changeCursor);
            _resizeGrabberLE.addEventListener(MouseEvent.MOUSE_OVER, changeCursor);
            _resizeGrabberRE.addEventListener(MouseEvent.MOUSE_OVER, changeCursor);
            #if flash
			_resizeGrabberTL.addEventListener(MouseEvent.MOUSE_OUT, changeCursor);
			_resizeGrabberTR.addEventListener(MouseEvent.MOUSE_OUT, changeCursor);
			_resizeGrabberBL.addEventListener(MouseEvent.MOUSE_OUT, changeCursor);
			_resizeGrabberBR.addEventListener(MouseEvent.MOUSE_OUT, changeCursor);
			_resizeGrabberTE.addEventListener(MouseEvent.MOUSE_OUT, changeCursor);
			_resizeGrabberBE.addEventListener(MouseEvent.MOUSE_OUT, changeCursor);
			_resizeGrabberLE.addEventListener(MouseEvent.MOUSE_OUT, changeCursor);
			_resizeGrabberRE.addEventListener(MouseEvent.MOUSE_OUT, changeCursor);
			#end
        }
    } // end function


    /**
	 * Draws the panel.
	 */
    override private function draw():Void
    {
        // check to see if the displayState of the panel is "normal".
        if(_displayState == "normal")
        {
            // make sure _width and _height are not greater than or less than the max width/min width and max height/min height
            _width = Math.min(_maxSize.x, _width);
            _width = Math.max(_minSize.x, _width);

            _height = Math.min(_maxSize.y, _height);
            _height = Math.max(_minSize.y, _height);
        }

        #if html5
		if (_displayState == "collapsed")
		{
			if (_content.parent != null)
			{
				removeChild(_content);
			}
		}
		else
		{
			if (_content.parent == null)
			{
				addChild(_content);
			}
		}
		#end

        // resize grabbers
        _resizeGrabberTL.x = _padding - _resizeGrabberThickness;
        _resizeGrabberTL.y = _padding - _resizeGrabberThickness;
        _resizeGrabberTR.x = _width - _padding;
        _resizeGrabberTR.y = _padding - _resizeGrabberThickness;
        _resizeGrabberBL.x = _padding - _resizeGrabberThickness;
        _resizeGrabberBL.y = _height - _padding;
        _resizeGrabberBR.x = _width - _padding;
        _resizeGrabberBR.y = _height - _padding;

        _resizeGrabberTE.x = _padding;
        _resizeGrabberTE.y = _padding - _resizeGrabberThickness;
        _resizeGrabberBE.x = _padding;
        _resizeGrabberBE.y = _height - _padding;
        _resizeGrabberLE.x = _padding - _resizeGrabberThickness;
        _resizeGrabberLE.y = _padding;
        _resizeGrabberRE.x = _width - _padding;
        _resizeGrabberRE.y = _padding;

        _resizeGrabberTE.width = _width - (_padding * 2);
        _resizeGrabberBE.width = _width - (_padding * 2);
        _resizeGrabberLE.height = _height - (_padding * 2);
        _resizeGrabberRE.height = _height - (_padding * 2);


        //var borderAndPaddingWidth:Int = padding + Int(_drawElement.style.borderWidth);

        _registrationPoint.x = _registrationPoint.y = 0;
        positionAssets();
        _titleBar.height = _titleBarHeight + _titleBar.style.borderBottomWidth;

    } // end function


    private function positionAssets():Void
    {
        // buttons
        _closeButton.x = _registrationPoint.x + _width - _closeButton.width - _padding;
        _closeButton.y = _registrationPoint.y + _padding;
        _maximizeButton.x = _closeButton.x - _maximizeButton.width;
        _maximizeButton.y = _registrationPoint.y + _padding;
        _minimizeButton.x = _maximizeButton.x - _minimizeButton.width;
        _minimizeButton.y = _registrationPoint.y + _padding;
        _collapseButton.x = _minimizeButton.x - _collapseButton.width;
        _collapseButton.y = _registrationPoint.y + _padding;

        //
        _content.x = _registrationPoint.x + _padding;
        _content.y = _registrationPoint.y + _padding + _titleBar.height;

        // mask
        _contentMask.x = _registrationPoint.x + _padding;
        _contentMask.y = _registrationPoint.y + _padding + _titleBar.height;
        _contentMask.width = _width - _padding * 2;
        _contentMask.height = _height - _titleBar.height - _padding * 2;

        //
        _drawElement.width = _width;
        _drawElement.height = _height;
        _drawElement.x = _registrationPoint.x;
        _drawElement.y = _registrationPoint.y;

        _titleBar.width = (_width - cast(_drawElement.style.borderWidth) * 2);
        _titleBar.x = _registrationPoint.x + cast(_drawElement.style.borderWidth);
        _titleBar.y = _registrationPoint.y + cast(_drawElement.style.borderWidth);

    } // end function


    /**
	 * Draws the resize grabbers.
	 * Can be rectangular or circular
	 */
    private function drawResizeGrabber():Void
    {
        var color:UInt = 0x00FF00;
        var alpha:Float = 0;

        _resizeGrabberTL.scaleX =
        _resizeGrabberTR.scaleX =
        _resizeGrabberBL.scaleX =
        _resizeGrabberBR.scaleX =
        _resizeGrabberTE.scaleX =
        _resizeGrabberBE.scaleX =
        _resizeGrabberLE.scaleX =
        _resizeGrabberRE.scaleX =

        _resizeGrabberTL.scaleY =
        _resizeGrabberTR.scaleY =
        _resizeGrabberBL.scaleY =
        _resizeGrabberBR.scaleY =
        _resizeGrabberTE.scaleY =
        _resizeGrabberBE.scaleY =
        _resizeGrabberLE.scaleY =
        _resizeGrabberRE.scaleY = 1;

        _resizeGrabberTL.alpha =
        _resizeGrabberTR.alpha =
        _resizeGrabberBL.alpha =
        _resizeGrabberBR.alpha =
        _resizeGrabberTE.alpha =
        _resizeGrabberBE.alpha =
        _resizeGrabberLE.alpha =
        _resizeGrabberRE.alpha = alpha;

        _resizeGrabberTL.graphics.clear();
        _resizeGrabberTR.graphics.clear();
        _resizeGrabberBL.graphics.clear();
        _resizeGrabberBR.graphics.clear();
        _resizeGrabberTE.graphics.clear();
        _resizeGrabberBE.graphics.clear();
        _resizeGrabberLE.graphics.clear();
        _resizeGrabberRE.graphics.clear();


        var grabbersWidth = _width - _padding * 2; //
        var grabbersHeight = _height - _padding * 2; //

        _resizeGrabberTL.graphics.beginFill(color, 1);
        _resizeGrabberTR.graphics.beginFill(color, 1);
        _resizeGrabberBL.graphics.beginFill(color, 1);
        _resizeGrabberBR.graphics.beginFill(color, 1);
        _resizeGrabberTE.graphics.beginFill(color, 1);
        _resizeGrabberBE.graphics.beginFill(color, 1);
        _resizeGrabberLE.graphics.beginFill(color, 1);
        _resizeGrabberRE.graphics.beginFill(color, 1);

        _resizeGrabberTL.graphics.drawRect(0, 0, _resizeGrabberThickness, _resizeGrabberThickness);
        _resizeGrabberTR.graphics.drawRect(0, 0, _resizeGrabberThickness, _resizeGrabberThickness);
        _resizeGrabberBL.graphics.drawRect(0, 0, _resizeGrabberThickness, _resizeGrabberThickness);
        _resizeGrabberBR.graphics.drawRect(0, 0, _resizeGrabberThickness, _resizeGrabberThickness);
        _resizeGrabberTE.graphics.drawRect(0, 0, grabbersWidth, _resizeGrabberThickness);
        _resizeGrabberBE.graphics.drawRect(0, 0, grabbersWidth, _resizeGrabberThickness);
        _resizeGrabberLE.graphics.drawRect(0, 0, _resizeGrabberThickness, grabbersHeight);
        _resizeGrabberRE.graphics.drawRect(0, 0, _resizeGrabberThickness, grabbersHeight);

        _resizeGrabberTL.graphics.endFill();
        _resizeGrabberTR.graphics.endFill();
        _resizeGrabberBL.graphics.endFill();
        _resizeGrabberBR.graphics.endFill();
        _resizeGrabberTE.graphics.endFill();
        _resizeGrabberBE.graphics.endFill();
        _resizeGrabberLE.graphics.endFill();
        _resizeGrabberRE.graphics.endFill();


        _resizeGrabberTL.x = _padding - _resizeGrabberThickness;
        _resizeGrabberTL.y = _padding - _resizeGrabberThickness;
        _resizeGrabberTR.x = _width - _padding;
        _resizeGrabberTR.y = _padding - _resizeGrabberThickness;
        _resizeGrabberBL.x = _padding - _resizeGrabberThickness;
        _resizeGrabberBL.y = _height - _padding;
        _resizeGrabberBR.x = _width - _padding;
        _resizeGrabberBR.y = _height - _padding;

        _resizeGrabberTE.x = _padding;
        _resizeGrabberTE.y = _padding - _resizeGrabberThickness;
        _resizeGrabberBE.x = _padding;
        _resizeGrabberBE.y = _height - _padding;
        _resizeGrabberLE.x = _padding - _resizeGrabberThickness;
        _resizeGrabberLE.y = _padding;
        _resizeGrabberRE.x = _width - _padding;
        _resizeGrabberRE.y = _padding;


    } // function


    /**
	 * Activates this panel.
	 * - Make the panel visible
	 * - Bring the panel to the front
	 */
    public function activate():Void
    {
        _active = true;
        _closed = false;
        visible = true;
        //alpha = 1;
        //scaleX = scaleY = 1;
        Actuate.tween(this, 0.3, {alpha: 1, scaleX: 1, scaleY: 1});

        orderToFront();

        dispatchEvent(new Event(Event.ACTIVATE, false, false));

    } // end function


    /**
	 * Closes this panel.
	 */
    public function close():Void
    {
        _active = false;
        _closed = true;

        Actuate.tween(this, 0.3, {alpha: 0, scaleX: 0.5, scaleY: 0.5});

        // TODO perhaps use Actuate.tween.onComplete() instead of a timer to close window
        var closeTimer:Timer = new Timer(300, 1);
        closeTimer.addEventListener(TimerEvent.TIMER, closeTimerHandler);
        closeTimer.start();

        //dispatchEvent(new Event(Event.CLOSING, false, false));
        dispatchEvent(new Event("closing", false, false));

    } // end function


    /**
	 * 
	 */
    public function maximize():Void
    {
        // check if panel is maximizable
        if(_maximizable)
        {
            _displayState = "maximized";

            _padding = 0;

            _tempX = Std.int(x);
            _tempY = Std.int(y);
            _tempWidth = Std.int(_width);
            _tempHeight = Std.int(height);


            x = 0;
            y = 0;
            if(root != null)
            {
                resize(cast(root, DisplayObjectContainer).stage.stageWidth, cast(root, DisplayObjectContainer).stage.stageHeight);
            }

            //maximizeButton.icon = windowIcon;
            draw();
            dispatchEvent(new Event(Event.RESIZE, false, false));

            trace("temp X: " + _tempX);
            trace("temp Y: " + _tempY);

        } // end if

    } // end function


    /**
	 * 
	 */
    public function minimize():Void
    {
        // check if panel is minimizable
        if(_minimizable)
        {
            _displayState = "minimized";

            _padding = 0;

            _tempX = Std.int(x);
            _tempY = Std.int(y);
            _tempWidth = Std.int(_width);
            _tempHeight = Std.int(_height);

            resize(Std.int(_minimizedButton.width), Std.int(_minimizedButton.height), true);

            var timer:Timer = new Timer(333, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,
            function(event:TimerEvent):Void
            {
                _drawElement.visible = false;
                _titleBar.visible = false;
                addChild(_minimizedButton);
            });
            timer.start();

            draw();

            dispatchEvent(new Event(Event.RESIZE, false, false));
            _minimizedButton.addEventListener(MouseEvent.CLICK, mouseHandler);

        } // end if

    } // end function


    /**
	 * 
	 * @return
	 */
    public function orderInBackOf(panel:BPanel):Bool
    {
        // check if has a parent
        if(parent != null)
        {
            if(_displayState == "minimized" || _closed)
            {
                return false;
            }

            parent.setChildIndex(this, parent.getChildIndex(panel) - 1);
        }
        else
        {
            return false;
        } // end if else

        return true;

    } // end function


    /**
	 * 
	 * @return
	 */
    public function orderInFrontOf(panel:BPanel):Bool
    {
        // check if has a parent
        if(parent != null)
        {
            if(_displayState == "minimized" || _closed)
            {
                return false;
            }

            parent.setChildIndex(this, parent.getChildIndex(panel) + 1);
        }
        else
        {
            return false;
        } // end if else

        return true;

    } // end function


    /**
	 * 
	 * @return
	 */
    public function orderToBack():Bool
    {
        // check if has a parent
        if(parent != null)
        {
            if(_displayState == "minimized" || _closed)
            {
                return false;
            }

            parent.setChildIndex(this, 0);
        }
        else
        {
            return false;
        } // end if else

        return true;

    } // end function


    /**
	 * 
	 * @return
	 */
    public function orderToFront():Bool
    {
        // check if has a parent
        if(parent != null)
        {
            if(_displayState == "minimized" || _closed)
            {
                return false;
            }

            parent.setChildIndex(this, parent.numChildren - 1);
        }
        else
        {
            return false;
        } // end if else

        return true;

    } // end function


    /**
	 * 
	 */
    private function restoreSize():Void
    {
        orderToFront();
        trace("restoring");
        _displayState = "normal";

        _padding = 2;

        resize(_tempWidth, _tempHeight, true);

        Actuate.tween(_collapseButton.icon, 0.3, {rotation: 180});

        _drawElement.visible = true;
        _titleBar.visible = true;

        _maximizeButton.icon = _maximizeIcon;
        if(_minimizedButton.parent != null)
        {
            _minimizedButton.parent.removeChild(_minimizedButton);
        }

        draw();

        dispatchEvent(new Event(Event.RESIZE, false, false));
        _minimizedButton.removeEventListener(MouseEvent.CLICK, mouseHandler);
    } // end function


    /**
	 * 
	 */
    public function restore():Void
    {
        trace("temp Xr: " + _tempX);
        trace("temp Yr: " + _tempY);
        x = _tempX;
        y = _tempY;

        restoreSize();
    } // end function


    /**
	 * 
	 * @param	width
	 * @param	height
	 * @param	animate
	 */
    public function resize(width:Int, height:Int, animate:Bool = true):Void
    {

        // check to see if window is open
        if(!_closed)
        {
            if(animate)
            {

                var timer:Timer = new Timer(1000 / 60, 20);

                timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):Void
                {
                    if(Math.abs(_resizeToWidth - _width) <= 1)
                    {
                        _width = _resizeToWidth;
                    }
                    else
                    {
                        _width += (_resizeToWidth - _width) * 0.3;
                    }

                    if(Math.abs(_resizeToHeight - _height) <= 1)
                    {
                        _height = _resizeToHeight;
                    }
                    else
                    {
                        _height += (_resizeToHeight - _height) * 0.3;
                    }

                    dispatchEvent(new Event(Event.RESIZE));
                    draw();
                });
                timer.start();
                _resizeToWidth = width;
                _resizeToHeight = height;
            }
            else
            {
                _width = width;
                _height = height;
                draw();
            }
        }
    } // end function


    /*//
	// 
	public function startMove():Bool
	{
		
	} // end 
	
	
	// 
	// 
	public function startResize(edgeOrCorner:String = "BR"):Bool
	{
		
	} // end 
	*/


    /**
	 * 
	 */
    public function collapse():Void
    {
        if(_collapsible)
        {
            _displayState = "collapsed";

            //padding = 0;
            _tempX = Std.int(x);
            _tempY = Std.int(y);
            _tempWidth = Std.int(_width);
            _tempHeight = Std.int(_height);

            resize(Std.int(_width), Std.int(titleBarHeight + _padding * 2));
            //Actuate.tween(this, 0.3, {_width: _width, height: Std.int(titleBarHeight + padding * 2)}); // this actually works lol
            Actuate.tween(_collapseButton.icon, 0.3, {rotation: 0});

            dispatchEvent(new Event(Event.RESIZE));
        }

    } // end function


    /**
	 * Checks to see if the panel is within its bounderies and keeps it within the bounderies.
	 * Also checks the size of the panel and makes sure the panel is not larger than its bounderis.
	 * This will not chaneg the minSize or maxSize properties.
	 */
    private function checkWithinBounderies():Void
    {
        // check if panels has bounderies.
        if(panelBounds != null)
        {
            // test width
            if(_width > panelBounds.innerWidth)
            {
                width = panelBounds.innerWidth;
            }

            // test height
            if(_height > panelBounds.innerHeight)
            {
                height = panelBounds.innerHeight;
            }

            // test left
            if(this.x < panelBounds.left)
            {
                this.x = panelBounds.left;
            } // end if

            // test right
            if(this.x > panelBounds.right - _width)
            {
                this.x = panelBounds.right - _width;
            } // end if

            // test top
            if(this.y < panelBounds.top)
            {
                this.y = panelBounds.top;
            } // end if

            // test bottom
            if(this.y > panelBounds.bottom - _height)
            {
                this.y = panelBounds.bottom - _height;
            } // end if

        } // end if

    } // end function


    //**************************************** SET AND GET ******************************************


    public function get_titleBar():BTitleBar
    {
        return _titleBar;
    }


    public function get_titleTextColor():UInt
    {
        return cast(_activatedTF.color, UInt);
    }

    public function set_titleTextColor(value:UInt):UInt
    {
        _activatedTF.color = value;
        _titleBar.label.textField.setTextFormat(_activatedTF);
        //_titleBar.label.textField.setTextFormat(activatedTF);
        //titleText.setTextFormat(activatedTF);
        //dotsText.setTextFormat(activatedTF);
        return cast(_activatedTF.color, UInt);
    }


    public function get_titleBarHeight():Float
    {
        return _titleBar.height;
    }


    public function get_titleBarMode():BTitleBarMode
    {
        return _titleBarMode;
    }

    public function set_titleBarMode(value:BTitleBarMode):BTitleBarMode
    {
        _titleBarMode = value;
        _titleBar.mode = _titleBarMode;

        if(_titleBarMode != BTitleBarMode.NONE)
        {
            _closeButton.visible = true;
            _maximizeButton.visible = true;
            _minimizeButton.visible = true;
            _collapseButton.visible = true;

            if(_titleBarMode != BTitleBarMode.MINIMAL)
            {
                _closeButton.icon = _xIcon;
                _maximizeButton.icon = _maximizeIcon;
                _minimizeButton.icon = _minimizeIcon;
                _collapseButton.icon = _arrowIcon;
                _collapseButton.setIconBounds(15, 15);

            }
        }


        switch(_titleBarMode)
        {
            case BTitleBarMode.COMPACT_TEXT:
                _titleBarHeight = 30;

            case BTitleBarMode.COMPACT_ICON:
                _titleBarHeight = 40;

            case BTitleBarMode.FULL_TEXT:
                _titleBarHeight = 30;

            case BTitleBarMode.FULL_ICON:
                _titleBarHeight = 48;

            case BTitleBarMode.MINIMAL:
                _titleBarHeight = 10;
                _closeButton.icon = null;
                _maximizeButton.icon = null;
                _minimizeButton.icon = null;
                _collapseButton.icon = null;

            case BTitleBarMode.NONE:
                _closeButton.visible = false;
                _maximizeButton.visible = false;
                _minimizeButton.visible = false;
                _collapseButton.visible = false;

        } // end switch


        _closeButton.setSize(_titleBarHeight, _titleBarHeight);
        _maximizeButton.setSize(_titleBarHeight, _titleBarHeight);
        _minimizeButton.setSize(_titleBarHeight, _titleBarHeight);
        _collapseButton.setSize(_titleBarHeight, _titleBarHeight);

        //buttonsWidth = _titleBarHeight * 5 + dotsText.width;

        draw();
        return _titleBarMode;
    }


    // TODO implement bMenu
    /*
	// bMenu
	public function set_bMenu(value:BNativeMenu):Void
	{
		if (_bMenu)
		{
			trace("This window already has a menu.");
			return;
		}
		_bMenu = value;
		_bMenu.display(container.stage, padding, padding);
	}
	
	public function get_bMenu():BNativeMenu
	{
		return _bMenu;
	}
	
	*/

    public function get_backgroundDrag():Bool
    {
        return _backgroundDrag;
    }

    public function set_backgroundDrag(value:Bool):Bool
    {
        _backgroundDrag = value;
        if(value)
        {
            _drawElement.addEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
            _drawElement.addEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
        }
        else
        {
            if(_drawElement.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                _drawElement.removeEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
            }
            if(_drawElement.hasEventListener(MouseEvent.MOUSE_UP))
            {
                _drawElement.removeEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
            }
        }
        return _backgroundDrag;
    }


    public function get_content():DisplayObjectContainer
    {
        return _content;
    }


    public function get_title():String
    {
        return _titleBar.title;
    }

    public function set_title(value:String):String
    {
        _titleBar.title = value;
        return _titleBar.title;
    }


    public function get_active():Bool
    {
        return _active;
    }


    // alwaysInFront
    /*public function set_alwaysInFront(value:Bool):Void
	{
		_alwaysInFroint = value;
	}
	
	public function get_alwaysInFront():Bool
	{
		return _alwaysInFroint;
	}
	*/


    public function get_maxWidth():Int
    {
        return Std.int(_maxSize.x);
    }

    public function set_maxWidth(value:Int):Int
    {
        _maxSize.x = value;
        _width = Math.min(_maxSize.x, _width);
        draw();
        return Std.int(_maxSize.x);
    }


    public function get_maxHeight():Int
    {
        return Std.int(_maxSize.y);
    }

    public function set_maxHeight(value:Int):Int
    {
        _maxSize.y = value;
        _height = Math.min(_maxSize.y, _height);
        draw();
        return Std.int(_maxSize.y);
    }


    public function get_minWidth():Int
    {
        return Std.int(_minSize.x);
    }

    public function set_minWidth(value:Int):Int
    {
        _minSize.x = value;
        _width = Math.max(_minSize.x, _width);
        draw();
        return Std.int(_minSize.x);
    }


    public function get_minHeight():Int
    {
        return Std.int(_minSize.y);
    }

    public function set_minHeight(value:Int):Int
    {
        _minSize.y = value;
        _height = Math.max(_minSize.y, _height);
        draw();
        return Std.int(_minSize.y);
    }


    public function get_maxSize():Point
    {
        return _maxSize;
    }

    public function set_maxSize(value:Point):Point
    {
        _maxSize = value;
        _width = Math.min(_maxSize.x, _width);
        _height = Math.min(_maxSize.y, _height);
        draw();
        return _maxSize;
    }


    public function get_minSize():Point
    {
        return _minSize;
    }

    public function set_minSize(value:Point):Point
    {
        _minSize = value;
        _width = Math.max(_minSize.x, _width);
        _height = Math.max(_minSize.y, _height);
        draw();
        return _minSize;
    }


    public function get_maximizable():Bool
    {
        return _maximizable;
    }

    public function set_maximizable(value:Bool):Bool
    {
        _maximizable = value;

        if(value)
        {
            _maximizeButton.scaleX = 1;
            _maximizeButton.visible = true;
        }
        else
        {
            _maximizeButton.scaleX = 0;
            _maximizeButton.visible = false;
        }

        draw();
        return _maximizable;
    }


    public function get_minimizable():Bool
    {
        return _minimizable;
    }

    public function set_minimizable(value:Bool):Bool
    {
        _minimizable = value;

        if(value)
        {
            _minimizeButton.scaleX = 1;
            _minimizeButton.visible = true;
        }
        else
        {
            _minimizeButton.scaleX = 0;
            _minimizeButton.visible = false;
        }

        draw();
        return _minimizable;
    }


    public function get_resizable():Bool
    {
        return _resizable;
    }

    public function set_resizable(value:Bool):Bool
    {
        _resizable = value;

        if(value)
        {
            _resizeGrabberTL.mouseEnabled = true;
            _resizeGrabberTR.mouseEnabled = true;
            _resizeGrabberBL.mouseEnabled = true;
            _resizeGrabberBR.mouseEnabled = true;
            _resizeGrabberTE.mouseEnabled = true;
            _resizeGrabberBE.mouseEnabled = true;
            _resizeGrabberLE.mouseEnabled = true;
            _resizeGrabberRE.mouseEnabled = true;
        }
        else
        {
            _resizeGrabberTL.mouseEnabled = false;
            _resizeGrabberTR.mouseEnabled = false;
            _resizeGrabberBL.mouseEnabled = false;
            _resizeGrabberBR.mouseEnabled = false;
            _resizeGrabberTE.mouseEnabled = false;
            _resizeGrabberBE.mouseEnabled = false;
            _resizeGrabberLE.mouseEnabled = false;
            _resizeGrabberRE.mouseEnabled = false;
        }
        return _resizable;
    }


    public function get_closeable():Bool
    {
        return _closeable;
    }

    public function set_closeable(value:Bool):Bool
    {
        _closeable = value;

        if(value)
        {
            _closeButton.scaleX = 1;
            _closeButton.visible = true;
        }
        else
        {
            _closeButton.scaleX = 0;
            _closeButton.visible = false;
        }

        draw();
        return _closeable;
    }


    public function get_draggable():Bool
    {
        return _draggable;
    }

    public function set_draggable(value:Bool):Bool
    {
        _draggable = value;

        if(value)
        {
            _titleBar.mouseEnabled = true;
        }
        else
        {
            _titleBar.mouseEnabled = false;
        }
        return _draggable;
    }


    public function get_collapsible():Bool
    {
        return _collapsible;
    }

    public function set_collapsible(value:Bool):Bool
    {
        _collapsible = value;

        if(value)
        {
            _collapseButton.scaleX = 1;
            _collapseButton.visible = true;
        }
        else
        {
            _collapseButton.scaleX = 0;
            _collapseButton.visible = false;
        }

        draw();
        return _collapsible;
    }


    public function get_panelBounds():BPanelBounds
    {
        return _panelBounds;
    }

    public function set_panelBounds(value:BPanelBounds):BPanelBounds
    {
        _panelBounds = value;
        checkWithinBounderies();
        return _panelBounds;
    }


    /*
	 * overriding to make sure panel is within its bounderies.
	 */
    #if flash
	@:setter(width)
	override public function set_width(value:Float):Void
	{
		super.width = value;
		checkWithinBounderies();
	}
	
	@:setter(height)
	override public function set_height(value:Float):Void
	{
		super.height = value;
		checkWithinBounderies();
	}
	
	@:setter(x)
	override public function set_x(value:Float):Void
	{
		super.x = value;
		checkWithinBounderies();
	}
	
	@:setter(y)
	override public function set_y(value:Float):Void
	{
		super.y = value;
		checkWithinBounderies();
	}
	#else

    override public function set_width(value:Float):Float
    {
        super.width = value;
        checkWithinBounderies();
        return value;
    }

    override public function set_height(value:Float):Float
    {
        super.height = value;
        checkWithinBounderies();
        return value;
    }

    override public function set_x(value:Float):Float
    {
        super.x = value;
        checkWithinBounderies();
        return value;
    }

    override public function set_y(value:Float):Float
    {
        super.y = value;
        checkWithinBounderies();
        return value;
    }
    #end

}
