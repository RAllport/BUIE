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

import borris.display.BElement;

import motion.Actuate;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;


// TODO Errors: Nested details keeps the conatiner for no reason.
//  TODO content for a detail must be added after inictializing the accordion.
/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 13/10/2014 (dd/mm/yyyy)
 */
class BDetails extends BUIComponent
{
	/**
	 * Gets or sets the text label for the component.
	 * 
	 * @default ""
	 */
    public var label(get, set):String;
	
	/**
	 * 
	 */
    public var opened(get, set):Bool;
	
	/**
	 * 
	 */
    public var indent(get, set):Int;
	
	/**
	 * 
	 */
    public var lineHeight(get, set):Int;
	
	/**
	 * 
	 */
    public var rowHeight(get, set):Int;
	
	/**
	 * 
	 */
    public var columnWidth(get, set):Int;
	
	/**
	 * Container for content added to this details. 
	 * The content is masked, so it is best to add children to content, rather than directly to the details.
	 */
    public var content(get, never):DisplayObjectContainer;

    
    // assets variables
    private var _container:Sprite;  					// A container to hold the items of the details Object  
    private var _button:BLabelButton;
    
    private var _arrowIcon:Shape;  						// An arrow icon that displays to the left of the label. It rotates when the details Object is opened and closed;  
    private var _mk:Shape;  							// A make to mask out overflow of the container from the bottom and right.  
    
    // other
    private var _heightFlag:Bool = false;  				// A flag that's only used to as... ummm meh  
    private var _buttonWidth:Int;
    private var _buttonHeight:Int = 30;
    
    
    // set and get private variables
    private var _label:String;
    private var _open:Bool = false;
    private var _indent:Int = 0;
    private var _lineHeight:Int = 24;
    private var _rowHeight:Int = 24;
    private var _columnWidth:Int = 24;
    private var _tweened:Bool = false;
    
    //protected var _buttonWidth:in
    
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BDetails component instance.
     *
	 * @param	label The text label for the component.
     */
    public function new(label:String = "Label")
    {
        _label = label;
        super(null, 0, 0);
        initialize();
    }
    
    
    ///////////////////////////////////
    // event handlers
    ///////////////////////////////////
    
    
    /**
	 * 
	 * @param	event
	 */
    private function mouseClickHandler(event:MouseEvent):Void
    {
        opened = !opened;  // opened propertie to the oposite value. (see set and get )  
        this.dispatchEvent(new Event(Event.SELECT, true, false));
    } // end function
    
    
    //*************************************** FUNCTIONS **************************************
    
    
    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
		super.initialize();
        
        // initialize asset variables
        _container = new Sprite();
        _container.x = _indent;
        _container.y = _buttonHeight;
        _container.graphics.beginFill(0x000000, 0);
        _container.graphics.drawRect(0, 0, 1, 1);
        _container.graphics.endFill();
        
        // initialize the button;
        _button = new BLabelButton(this, 0, 0, _label);
        _button.autoSize = false;
        _button.textField.x = _buttonHeight;
        _button.setStateColors(0x0000, 0x000000, 0x333333, 0x000000, 0x000000, 0x000000, 0x333333, 0x000000);
        
        // icons
        _arrowIcon = new Shape();
        /*arrowIcon.graphics.beginFill(0xCCCCCC, 1);
		arrowIcon.graphics.moveTo( -2.5, -5);
		arrowIcon.graphics.lineTo(2.5, 0);
		arrowIcon.graphics.lineTo(-2.5, 5);
		arrowIcon.graphics.endFill();
		arrowIcon.mouseEnabled = false;
		arrowIcon.x = 10;
		arrowIcon.y = 10;*/
        
        _arrowIcon.graphics.lineStyle(1, 0xCCCCCC, 1, false, "normal", "none");
        _arrowIcon.graphics.moveTo(-2.5, -5);
        _arrowIcon.graphics.lineTo(2.5, 0);
        _arrowIcon.graphics.lineTo(-2.5, 5);
        _arrowIcon.rotation = 0;
        
        _button.icon = _arrowIcon;
        _button.setIconBounds(_buttonHeight / 2, _buttonHeight / 2);
        
        _mk = new Shape();
        _mk.graphics.beginFill(0xff00ff, 0.5);
        _mk.graphics.drawRect(0, 0, 100, 100);
        _mk.graphics.endFill();
        _mk.x = 0;
        _mk.y = _buttonHeight;
        _mk.height = 0;
        
        _container.mask = _mk;
        
        // add assets to stage
        addChild(_container);
        addChild(_mk);
        
        this.width = 300;
        
        // event handling
        _button.addEventListener(MouseEvent.CLICK, mouseClickHandler);
    } // end function
    
    
    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        //super.draw();
        
        _container.x = _indent;
        _buttonWidth = cast(_width, Int);
        
        // draw skins
        _button.width = _width;
        _button.height = _buttonHeight;
        
        //BElement(button.getSkin("upSkin")).style.backgroundColor = 0x000000;
        cast((_button.getSkin("upSkin")), BElement).style.backgroundOpacity = 1;
        cast((_button.getSkin("upSkin")), BElement).style.borderColor = 0x666666;
        cast((_button.getSkin("upSkin")), BElement).style.borderOpacity = 1;
        cast((_button.getSkin("upSkin")), BElement).style.borderWidth = 2;
        
        //BElement(button.getSkin("overSkin")).style.backgroundColor = 0x000000;
        cast((_button.getSkin("overSkin")), BElement).style.backgroundOpacity = 1;
        cast((_button.getSkin("overSkin")), BElement).style.borderColor = 0x999999;
        cast((_button.getSkin("overSkin")), BElement).style.borderOpacity = 1;
        cast((_button.getSkin("overSkin")), BElement).style.borderWidth = 2;
        
        //BElement(button.getSkin("downSkin")).style.backgroundColor = 0x333333;
        cast((_button.getSkin("downSkin")), BElement).style.backgroundOpacity = 1;
        cast((_button.getSkin("downSkin")), BElement).style.borderColor = 0x666666;
        cast((_button.getSkin("downSkin")), BElement).style.borderOpacity = 1;
        cast((_button.getSkin("downSkin")), BElement).style.borderWidth = 2;
        
        //BElement(button.getSkin("disabledSkin")).style.backgroundColor = 0x666666;
        cast((_button.getSkin("disabledSkin")), BElement).style.backgroundOpacity = 1;
        cast((_button.getSkin("disabledSkin")), BElement).style.borderColor = 0x666666;
        cast((_button.getSkin("disabledSkin")), BElement).style.borderOpacity = 1;
        cast((_button.getSkin("disabledSkin")), BElement).style.borderWidth = 2;
        
        
        _mk.x = 0;
        _mk.y = _buttonHeight;
        _mk.width = _width;
    } // end function
    
    
    /**
	 * @inheritDoc
	 */
    override public function setSize(width:Float, height:Float):Void
    {
        // I was lazy :'D. Same thing anyway
        this.width = width;
        this.height = height;
    } // end function
    
    
    /**
	 * 
	 */
    public function showGrid():Void
    {
        //trace("BDetails | showGrid(): This function does nothing.");
        
    } // end function
    
    
    /**
	 * 
	 * @param	item
	 * @return
	 */
    public function addItem(item:DisplayObject):DisplayObject
    {
        _container.addChild(item);
        draw();
        //trace("container: " + container.height);
        return item;
    } // end function
    
    
    /**
	 * 
	 * @param	item
	 * @param	index
	 * @return
	 */
    public function addItemAt(item:DisplayObject, index:Int):DisplayObject
    {
        _container.addChildAt(item, index);
        draw();
        return item;
    } // end function
    
    
    /**
	 * 
	 * @param	item
	 * @return
	 */
    public function removeItem(item:DisplayObject):DisplayObject
    {
        _container.removeChild(item);
        draw();
        return item;
    } // end function
    
    
    /**
	 * 
	 * @param	item
	 * @param	index
	 * 
	 * @return
	 */
    public function removeItemAt(item:DisplayObject, index:Int):DisplayObject
    {
        _container.addChildAt(item, index);
        draw();
        return item;
    } // end function
    
    
    /**
	 * 
	 * @param	item
	 * @param	x
	 * @param	y
	 * 
	 * @return
	 */
    public function addItemAtPosition(item:DisplayObject, x:Int = 0, y:Int = 0):DisplayObject
    {
        item.x = x;
        item.y = y;
        _container.addChild(item);
        draw();
        return item;
    } // end function
    
    
    /**
	 * 
	 * @param	index
	 * 
	 * @return
	 */
    public function getItemAt(index:Int):DisplayObject
    {
        return _container.getChildAt(index);
    } // end function
    
    
    /**
	 * 
	 * @param	name
	 * 
	 * @return
	 */
    public function getItemByName(name:String):DisplayObject
    {
        return _container.getChildByName(name);
    } // end function
    
    
    /**
	 * 
	 * @param	item
	 * 
	 * @return
	 */
    public function getItemIndex(item:DisplayObject):Int
    {
        return _container.getChildIndex(item);
    } // end function
    
    
    /**
	 * 
	 * @param	point
	 * 
	 * @return
	 */
    public function getItemUnderPoint(point:Point):Array<Dynamic>
    {
        return _container.getObjectsUnderPoint(point);
    } // end function
    
    
    
    //*************************************** SET AND GET **************************************
    
    
    private function get_label():String
    {
        return _label;
    }
    private function set_label(value:String):String
    {
        _label = value;
        _button.label = _label;
        draw();
        return value;
    }
    
    
    private function get_opened():Bool
    {
        return _open;
    }
    private function set_opened(value:Bool):Bool
    {
        _open = value;
        
		if (value) 
        {
            
            addChild(_container);
			Actuate.tween(_arrowIcon, 0.3, { rotation: 90 } );
			Actuate.tween(_mk, 0.3, { height:(height - _buttonHeight) } );
            this.dispatchEvent(new Event(Event.OPEN, true, false));
        }
        else 
        {
            
            Actuate.tween(_arrowIcon, 0.3, { rotation: 0 } );
			Actuate.tween(_mk, 0.3, { height: 0 } ).onComplete(function() { removeChild(_container); } );
            dispatchEvent(new Event(Event.CLOSE, true, false));
        }
        draw();
        
        dispatchEvent(new Event(Event.RESIZE));
        return value;
    }
    
    
    private function get_indent():Int
    {
        return _indent;
    }
    private function set_indent(value:Int):Int
    {
        _indent = value;
        
        _container.x = value;
        return value;
    }
    
    
    private function get_lineHeight():Int
    {
        return _lineHeight;
    }
    private function set_lineHeight(value:Int):Int
    {
        _lineHeight = value;
        draw();
        return value;
    }
    
    
    private function get_rowHeight():Int
    {
        return _rowHeight;
    }
    private function set_rowHeight(value:Int):Int
    {
        _rowHeight = value;
        draw();
        return value;
    }
    
    
    private function get_columnWidth():Int
    {
        return _columnWidth;
    }
    private function set_columnWidth(value:Int):Int
    {
        _columnWidth = value;
        draw();
        return value;
    }
    
    
    private function get_content():DisplayObjectContainer
    {
        return _container;
    }
    
    
    /**
	 * Gets or sets the height of the component. A closed BDetail's height will only be that of its button
	 * 
	 * <p>The height of the BDetails cannot be less than the height of its internal button.</p>
	 * 
	 * @inheritDoc
	 */
	#if flash
	@:getter(height)
	override private function get_height():Float
    {
        if (!_heightFlag) 
        {
            if (_open) 
            {
                _mk.height = _container.height;
                return _height = _container.height + _buttonHeight;
            }
            else 
            {
                return _buttonHeight;
            }
        }  // end if  
        
        if (contains(_container)) 
        {
            return _mk.height + _buttonHeight;
        }
        else 
        {
            return _buttonHeight;
        }
        return _height;
    }
	@:setter(height)
    override private function set_height(value:Float):Void
    {
        _heightFlag = true;
        
        if (value < _buttonHeight) 
        {
            value = _buttonHeight;
        }
        
        _mk.height = value - _buttonHeight;
        super.height = value;
    }
	#else
    override private function get_height():Float
    {
        if (!_heightFlag) 
        {
            if (_open) 
            {
                _mk.height = _container.height;
                return _height = _container.height + _buttonHeight;
            }
            else 
            {
                return _buttonHeight;
            }
        } // end if
        
        if (contains(_container)) 
        {
            return _mk.height + _buttonHeight;
        }
        else 
        {
            return _buttonHeight;
        }
        return _height;
    }
    override private function set_height(value:Float):Float
    {
        _heightFlag = true;
        
        if (value < _buttonHeight) 
        {
            value = _buttonHeight;
        }
        
        _mk.height = value - _buttonHeight;
        super.height = value;
        return value;
    }
	#end 
	
}

