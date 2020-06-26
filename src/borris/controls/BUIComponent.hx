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

package borris.controls;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.InteractiveObject;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;

import borris.display.BElement;
import borris.display.BStyle;


//--------------------------------------
//  Class description
//--------------------------------------
/**
 * The BUIComponent class is the base class for all visual components.
 *
 * @author Rohaan Allport
 * @creation-date 08/06/2014 (dd/mm/yyyy)
 */
class BUIComponent extends BElement
{
    /**
     * Gets or sets a value that indicates whether the component can accept user interaction.
     * A value of <code>true</code> indicates that the component can accept user interaction;
	 * a value of <code>false</code> indicates that it cannot.
     *
     * <p>If you set the <code>enabled</code> property to <code>false</code>, the color of the
     * container is dimmed and user input is blocked (with the exception of the Label and ProgressBar components).</p>
     */
    public var enabled(get, set):Bool;

    /**
     * Gets or sets a Boolean value that indicates whether the component can receive focus.
	 * A value of <code>true</code> indicates that it can
     * receive focus; a value of <code>false</code> indicates that it cannot.
     *
     * <p>If this property is <code>false</code>, focus is transferred to the first
     * parent whose <code>mouseFocusEnabled</code> property is set to <code>true</code>.</p>
     */
    public var focusEnabled(get, set):Bool;

    /**
     * Gets or sets a Boolean value that indicates whether the component can receive focus
     * after the user clicks it. A value of <code>true</code> indicates that it can
     * receive focus; a value of <code>false</code> indicates that it cannot.
     *
     * <p>If this property is <code>false</code>, focus is transferred to the first
     * parent whose <code>mouseFocusEnabled</code> property is set to <code>true</code>.</p>
     */
    public var mouseFocusEnabled(get, set):Bool;


    // assets
    private var _uiFocusRect:DisplayObject;

    // other
    private var _isFocused:Bool = false;
    private var _initialized:Bool = false;
    private var _focusPadding:Int = 3;

    // set and get
    private var _enabled:Bool = true;
    private var _focusEnabled:Bool = true;  		//
    //private var _focusManager:Boolean;
    private var _mouseFocusEnabled:Bool;  			// (Doesn't do anything. not here nor in fl.core.UIComponent)



    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BUIComponent component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will
     * have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels.
     * This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels.
     * This value is calculated from the top.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        super();

        // testing
        focusEnabled = _focusEnabled;  // seems to be working
        /*_uiFocusRect = new BElement();  // seems to be working
        cast(_uiFocusRect, BElement).style.backgroundColor = 0x000000;
		cast(_uiFocusRect, BElement).style.backgroundOpacity = 0;
		cast(_uiFocusRect, BElement).style.borderColor = 0x0099CC;
		cast(_uiFocusRect, BElement).style.borderWidth = 2;
		cast(_uiFocusRect, BElement).style.borderOpacity = 1;
		cast(_uiFocusRect, BElement).style.borderRadius = 8;*/

        move(cast(x, Int), cast(y, Int));
        //draw();

        if (parent != null)
        {
            parent.addChild(this);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        } // end if
        else
        {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        } // end else

        _style = new BStyle(this);

        // testing
        //BStyleManager.unRegisterBUIComponent(this);

        //addEventListener(BStyleEvent.CHANGE, styleChangeHandler);
    }


    //**************************************** HANDLERS *********************************************


    /**
	 * Initailizes the component when it is added to a stage.
	 * Draws the component, and removes the Event.ADDED_TO_STAGE listener
	 */
    private function onAddedToStage(event:Event):Void
    {
        if (!_initialized)
        {
            initialize();
        }
        draw();
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    } // end function


    /**
	 *
	 */
    private function focusInHandler(event:FocusEvent):Void
    {
        //if (try cast(event.target, DisplayObject) catch(e:Dynamic) null == this)
        if (cast(event.target, DisplayObject) == this)
        {
            drawFocus(true);
            _isFocused = true;
            if (this.parent != null)
            {
                this.parent.setChildIndex(this, this.parent.numChildren - 1);
                //trace("changing index");
            }
        }
    } // end function


    /**
	 *
	 */
    private function focusOutHandler(event:FocusEvent):Void
    {
        drawFocus(false);
        _isFocused = false;
    } // end function


    /**
	 *
	 */
    private function keyDownHandler(event:KeyboardEvent):Void
    {
        // You must override this function if your component accepts focus

    } // end function


    /**
	 *
	 */
    private function keyUpHandler(event:KeyboardEvent):Void
    {
        // You must override this function if your component accepts focus
    } // end function


    /**
	 * Draws the component after being flagged as invalid.
	 */
    private function onInvalidate(event:Event):Void
    {
        draw();
        removeEventListener(Event.ENTER_FRAME, onInvalidate);
    } // end function


    //**************************************** FUNCTIONS ********************************************


    /**
	 * Sets <code>initialized</code> variable to true.
	 */
    private function initialize():Void
    {
        //trace("BUIComponent | initialize().");
        _initialized = true;
    } // end function


    /**
	 * Draws the BElement object using the BStyle properties
	 */
    override private function draw():Void
    {
        // TODO complete below
        // classes that extend BUIComponent should deal with each possible invalidated property
        // common values include all, size, enabled, styles, state
        // draw should call super or validate when finished updating
        // examle:
        /*if(isInvalid(InvalidationType.SIZE, InvalidationType.STYLES))
		{
			if(isFocused && focusManager.showFocusIndicator)
			{
				drawFocus(true);
			}
		}
		validate();*/

        _style.drawNow();

    } // end function


    /**
	 * @param	focused
	 */
    private function drawFocus(focused:Bool):Void
    {
        if (focused)
        {
            if (_uiFocusRect == null)
                return;

            //_uiFocusRect.x = -_focusPadding;
            //_uiFocusRect.y = -_focusPadding;
            // testing
            _uiFocusRect.x = getBounds(this).left -_focusPadding;
            _uiFocusRect.y = getBounds(this).top -_focusPadding;
            _uiFocusRect.width = _width + (_focusPadding * 2);
            _uiFocusRect.height = height + (_focusPadding * 2);

            // using the super.addChildAt() ensure code does not break when overriding addChildAt()
            super.addChildAt(_uiFocusRect, 0);
        }
        else
        {
            if (_uiFocusRect != null && contains(_uiFocusRect))
            {
                // using the super.removeChildAt() ensure code does not break when overriding removeChild()
                super.removeChild(_uiFocusRect);
            }
        }
    } // end function


    // Initiates an immediate draw operation, without invalidating everything as <code>invalidateNow</code> does.
    /**
	 * Initiates an immediate draw operation.
	 *
	 */
    public function drawNow():Void
    {
        draw();
    } // end function


    /**
     * Marks a property as invalid and redraws the component on the
     * next frame unless otherwise specified.
     */
    // TODO optimize this
    #if flash
    private function invalidate():Void
    #else
    override public function invalidate():Void
        #end
    {
        addEventListener(Event.ENTER_FRAME, onInvalidate);
    } // end function


    /**
	 * Retrieves the object that currently has focus.
	 */
    public function getFocus():InteractiveObject
    {
        if (stage != null)
        {
            return stage.focus;
        }
        return null;
    } // end function


    /**
	 * Sets the focus to this component.
	 */
    public function setFocus():Void
    {
        if (stage != null)
        {
            stage.focus = this;
        }
    } // end function


    /**
	 * Moves the component to the specified position within its parent.
	 * This has the same effect as changing the component location by setting its x and y properties.
	 * Calling this method triggers the ComponentEvent.MOVE event to be dispatched.
	 *
	 * @param	x The x coordinate value that specifies the position of the component within its parent,
	 * 			in pixels. This value is calculated from the left.
	 * @param	y The y coordinate value that specifies the position of the component within its parent,
	 * 			in pixels. This value is calculated from the top.
	 */
    public function move(x:Int, y:Int):Void
    {
        this.x = x;
        this.y = y;
        //dispatchEvent(new ComponentEvent(ComponentEvent.MOVE));

    } // end function


    /**
	 * Sets the component to the specified width and height.
	 *
	 * @param	width The width of the component, in pixels.
	 * @param	height The height of the component, in pixels.
	 */
    public function setSize(width:Float, height:Float):Void
    {
        _width = width;
        _height = height;
        //draw();
        invalidate();
        dispatchEvent(new Event(Event.RESIZE));
    } // end function



    //**************************************** SET AND GET ******************************************


    private function get_enabled():Bool
    {
        return _enabled;
    }
    private function set_enabled(value:Bool):Bool
    {
        _enabled = value;
        mouseEnabled = mouseChildren = value;
        tabEnabled = tabChildren = value;
        //(value) ? alpha = 1 : alpha = 0.5;
        alpha = value ? 1 : 0.5;
        return value;
    }


    private function get_focusEnabled():Bool
    {
        return _focusEnabled;
    }
    private function set_focusEnabled(value:Bool):Bool
    {
        _focusEnabled = value;
        if(value)
        {
            tabEnabled = true;
            addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
            addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
            addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
        }
        else
        {
            tabEnabled = false;
            removeEventListener(FocusEvent.FOCUS_IN, focusInHandler);
            removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
            removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
        }
        return value;
    }


    private function get_mouseFocusEnabled():Bool
    {
        return _mouseFocusEnabled;
    }
    private function set_mouseFocusEnabled(value:Bool):Bool
    {
        _mouseFocusEnabled = value;
        return value;
    }


    /*
	 * Sets the parent of the component.
	 */
    // BUG cannot access identifyer for write. just crashes in neko
    /*private function set_parent(value:DisplayObjectContainer):DisplayObjectContainer
    {
        if (parent != null)
            parent.removeChild(this);

        value.addChild(this);
        return value;
    }*/

    //*************************************** SET AND GET OVERRIDES **************************************

    // NOTE invalidate() fixed BFlexBox stretch

    #if flash
	/**
	 * Gets or sets the width of the component, in pixels.
	 *
	 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
	 */
	@:getter(width)
	override private function get_width():Float
    {
        return _width * scaleX;
		//return Math.max(_width, getBounds(this).width);
    }

	@:setter(width)
    override private function set_width(value:Float):Void
    {
        _width = Math.ceil(value);
        //draw();
		invalidate();
        dispatchEvent(new Event(Event.RESIZE));
    }


    /**
	 * Gets or sets the height of the component, in pixels.
	 *
	 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
	 */
	@:getter(height)
    override private function get_height():Float
    {
        return _height * scaleY;
		//return Math.max(_height, getBounds(this).height);
    }

	@:setter(height)
    override private function set_height(value:Float):Void
    {
        _height = Math.ceil(value);
        //draw();
		invalidate();
        dispatchEvent(new Event(Event.RESIZE));
    }


    /**
	 * Gets or sets the x coordinate that represents the position of the component along the x axis within its parent container.
	 * This value is described in pixels and is calculated from the left.
	 */
	@:setter(x)
    private function set_x(value:Float):Void
    {
        super.x = Std.int(value);
    }


    /**
	 * Gets or sets the y coordinate that represents the position of the component along the y axis within its parent container.
	 * This value is described in pixels and is calculated from the top.
	 */
	@:setter(y)
    private function set_y(value:Float):Void
    {
        super.y = Std.int(value);
    }
	#else
    /**
	 * Gets or sets the width of the component, in pixels.
	 *
	 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
	 */
    override private function get_width():Float
    {
        return _width * scaleX;
        //return Math.max(_width, getBounds(this).width);
    }
    override private function set_width(value:Float):Float
    {
        _width = Math.ceil(value);
        //draw();
        invalidate();
        dispatchEvent(new Event(Event.RESIZE));
        return value;
    }


    /**
	 * Gets or sets the height of the component, in pixels.
	 *
	 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
	 */
    override private function get_height():Float
    {
        return _height * scaleY;
        //return Math.max(_height, getBounds(this).height);
    }
    override private function set_height(value:Float):Float
    {
        _height = Math.ceil(value);
        //draw();
        invalidate();
        dispatchEvent(new Event(Event.RESIZE));
        return value;
    }



    /**
	 * Gets or sets the x coordinate that represents the position of the component along the x axis within its parent
	 * container.
	 * This value is described in pixels and is calculated from the left.
	 */
    override private function set_x(value:Float):Float
    {
        super.x = Std.int(value);
        return value;
    }


    /**
	 * Gets or sets the y coordinate that represents the position of the component along the y axis within its parent
	 * container.
	 * This value is described in pixels and is calculated from the top.
	 */
    override private function set_y(value:Float):Float
    {
        super.y = Std.int(value);
        return value;
    }

    #end
}



