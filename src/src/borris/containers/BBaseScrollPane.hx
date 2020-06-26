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

import borris.controls.BOrientation;
import borris.controls.BScrollBar;
import borris.controls.BUIComponent;

import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;


/**
 * The BBaseScrollPane class handles basic scroll pane functionality including events, styling, drawing the mask and background, the layout of scroll bars, and the handling of scroll positions.
 *
 * @author Rohaan Allport
 * @creation-date 24/09/2015 (dd/mm/yyyy)
 */
class BBaseScrollPane extends BUIComponent
{
    /**
	 * [read-only] Gets a reference to the horizontal scroll bar.
	 */
    public var horizontalScrollBar(get, never):BScrollBar;

    /**
	 * [read-only] Gets a reference to the vertical scroll bar.
	 */
    public var verticalScrollBar(get, never):BScrollBar;

    /**
	 * Gets or sets the padding of the content from the edge if the scroll pane.
	 */
    public var contentPadding(get, set):Float;

    // assets
    private var _container:Sprite;
    private var _containerMask:Shape;

    private var _hScrollBar:BScrollBar; //
    private var _vScrollBar:BScrollBar; //


    // other
    private var _contendPadding:Float = 10; // The amount of padding to put around the content in the scroll pane, in pixels. The default value is 0.
    // TODO probably add then to BUIComponent instead
    private var _disabledAlpha:Float = 0.5; // When the enabled property is set to false, interaction with the component is prevented and a white overlay is displayed over the component, dimming the component contents.
    private var _repeatDelay:Float = 1000; // The number of milliseconds to wait after the buttonDown event is first dispatched before sending a second buttonDown event.
    private var _repeatInterval:Float = 100; // The interval, in milliseconds, between buttonDown events that are dispatched after the delay that is specified by the repeatDelay style.


    // set and get
    private var _horizontalLineScrollSize:Float; // Gets or sets a value that describes the amount of content to be scrolled, horizontally, when a scroll arrow is clicked.
    private var _horizontalPageScrollSize:Float; // Gets or sets the count of pixels by which to move the scroll thumb on the horizontal scroll bar when the scroll bar track is pressed.
    private var _horizontalScrollPolicy:String; // Gets or sets a value that indicates the state of the horizontal scroll bar.
    private var _horizontalScrollPosition:Float; // Gets or sets a value that describes the horizontal position of the horizontal scroll bar in the scroll pane, in pixels.
    private var _maxHorizontalScrollPosition:Float; // [read-only] Gets the maximum horizontal scroll position for the current content, in pixels.

    private var _maxVerticalScrollPosition:Float; // [read-only] Gets the maximum vertical scroll position for the current content, in pixels.
    private var _verticalLineScrollSize:Float; // Gets or sets a value that describes how many pixels to scroll vertically when a scroll arrow is clicked.
    private var _verticalPageScrollSive:Float; // Gets or sets the count of pixels by which to move the scroll thumb on the vertical scroll bar when the scroll bar track is pressed.
    private var _verticalScrollPolicy:String; // Gets or sets a value that indicates the state of the vertical scroll bar.
    private var _verticalScrollPosition:Float; // Gets or sets a value that describes the vertical position of the vertical scroll bar in the scroll pane, in pixels.

    private var _useBitmapScrolling:Bool; // When set to true, the cacheAsBitmap property for the scrolling content is set to true; when set to false this value is turned off.


    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        super(parent, x, y);
        initialize();
        setSize(100, 100);
    }


    /**
	 * 
	 * @param	event
	 */
    private function scrollBarChangeHandler(event:Event):Void
    {
        update();
    } // end function


    /**
	 * Handles scrolling via mouse wheel
	 * Calls BScrollBar.doScroll()
	 * 
	 * @param	event
	 */
    private function mouseWheelHandler(event:MouseEvent):Void
    {
        if(_vScrollBar.visible)
        {
            _vScrollBar.doScroll((event.delta >= 1 ? "up" : "down"));
        }
        else if(_hScrollBar.visible)
        {
            _hScrollBar.doScroll((event.delta >= 1 ? "up" : "down"));
        }
    } // end function


    //************************************* FUNCTIONS ******************************************


    /**
	 * @inheritDoc
	 */
    override private function initialize():Void
    {
        super.initialize();

        // initialize assets
        _container = new Sprite();


        _containerMask = new Shape();
        _containerMask.graphics.beginFill(0xFF00FF, 1);
        _containerMask.graphics.drawRect(0, 0, 100, 100);
        _containerMask.graphics.endFill();
        _containerMask.x = 0;
        _containerMask.y = 0;

        _hScrollBar = new BScrollBar(BOrientation.HORIZONTAL, null);
        _hScrollBar.x = 0;
        _hScrollBar.y = _height - _hScrollBar.height;
        _hScrollBar.autoHide = true;

        _vScrollBar = new BScrollBar(BOrientation.VERTICAL, null);
        _vScrollBar.x = _width - _vScrollBar.width;
        _vScrollBar.y = 0;
        _vScrollBar.autoHide = true;

        addChild(_containerMask);
        addChild(_container);
        addChild(_hScrollBar);
        addChild(_vScrollBar);

        // testing
        _container.mask = _containerMask;
        //_container.scrollRect = new Rectangle(50, 50, _width, _height);

        draw();
        update();

        // event handling
        _hScrollBar.addEventListener(Event.CHANGE, scrollBarChangeHandler);
        _vScrollBar.addEventListener(Event.CHANGE, scrollBarChangeHandler);
        addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        super.draw();

        _hScrollBar.visible = (_container.width + contentPadding * 2 > _width);
        _vScrollBar.visible = (_container.height + contentPadding * 2 > _height);


        // position and resize the horizontal scroll bar
        _hScrollBar.x = 0;
        _hScrollBar.y = _height - _hScrollBar.height;
        _hScrollBar.width = (_vScrollBar.visible) ? (_width - _vScrollBar.width) : _width;

        // position and resize the vertical scroll bar
        _vScrollBar.x = _width - _vScrollBar.width;
        _vScrollBar.y = 0;
        _vScrollBar.height = (_hScrollBar.visible) ? (_height - _hScrollBar.height) : _height;


        //
        //hScrollBar.lineScrollSize = 0.1;
        //vScrollBar.lineScrollSize = 0.1;

        //
        _hScrollBar.setThumbPercent((_width - _contendPadding * 2) / _container.width);
        _vScrollBar.setThumbPercent((_height - _contendPadding * 2) / _container.height);


        // testing
        _containerMask.width = _width;
        _containerMask.height = _height;
        //_container.scrollRect.width = _width;
        //_container.scrollRect.height = _height;


        //_vScrollBar.drawNow();
        //_hScrollBar.drawNow();

        update();
    } // end function


    /**
	 * 
	 */
    private function update():Void
    {
        //container.x = hScrollBar.scrollPosition * (containerMask.width - container.width);
        //container.x = hScrollBar.scrollPosition * (containerMask.width - container.width) - (container.getBounds(this).left - container.x);

        //container.y = vScrollBar.scrollPosition * (containerMask.height - container.height);
        //container.y = vScrollBar.scrollPosition * (containerMask.height - container.height) - (container.getBounds(this).top - container.y);

        //var tween:Tween = new Tween(container, "y", Regular.easeInOut, container.y, (vScrollBar.scrollPosition * (containerMask.height - container.height)), 0.3, true);
        //var tween:Tween = new Tween(container, "y", Regular.easeInOut, container.y, (vScrollBar.scrollPosition * (containerMask.height - container.height)), 0.3, true);

        _container.x = _hScrollBar.scrollPosition * (_containerMask.width - (_container.width + _contendPadding * 2)) - (_container.getBounds(this).left - _container.x) + _contendPadding;
        _container.y = _vScrollBar.scrollPosition * (_containerMask.height - (_container.height + _contendPadding * 2)) - (_container.getBounds(this).top - _container.y) + _contendPadding;

        // testing
        //_container.scrollRect.x = _hScrollBar.scrollPosition;
        //_container.scrollRect.y = _vScrollBar.scrollPosition;

    } // end function


    //***************************************** SET AND GET *****************************************


    private function get_horizontalScrollBar():BScrollBar
    {
        return _hScrollBar;
    }


    private function get_verticalScrollBar():BScrollBar
    {
        return _vScrollBar;
    }


    private function set_contentPadding(value:Float):Float
    {
        _contendPadding = value;
        draw();
        return value;
    }

    private function get_contentPadding():Float
    {
        return _contendPadding;
    }
} // end c;ass

