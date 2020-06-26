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

import borris.controls.BUIComponent;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;


/**
 * The BFlexBox component is a container that can flex etc...
 *
 * @author Rohaan Allport
 * @creation-date 08/06/2014 (dd/mm/yyyy)
 */
class BFlexBox extends BUIComponent
{
	/**
	 * Gets and sets the alignment of the flexbox's items.
	 * 
	 * <p>The alignItems property horizontally aligns the flexbox's items when <code>direction</code> is <code>BFlexBox.VERTICAL</code> or 
	 * vertically when <code>direction</code> is <code>BFlexBox.HORIZONTAL</code> 
	 * when the items do not use all available space on the cross-axis.</p>
	 * 
	 * <p>You can use the following constants to set this property:</p>
	 * 
	 * <ul>
	 * 	<li>BFlexBox.START</li>
	 * 	<li>BFlexBox.END</li>
	 * 	<li>BFlexBox.CENTER</li>
	 * 	<li>BFlexBox.SRETCH</li>
	 * @private <li>BFlexBox.BASELINE</li>
	 * </ul>
	 * 
	 * @default BFlexBox.START
	 */
    public var alignItems(get, set):String;
    
	/**
	 * Gets and sets the alignment of all the flexbox's content.
	 * 
	 * <p>The alignContent property modifies the behavior of the wrap property. It is similar to alignItems, 
	 * but instead of aligning flex items, it aligns flex lines.</p>
	 * 
	 * <p>The alignContent property horizontally aligns the flexbox's lines when <code>direction</code> is <code>BFlexBox.VERTICAL</code> or 
	 * vertically when <code>direction</code> is <code>BFlexBox.HORIZONTAL</code> 
	 * when the wrapping to a next line.</p>
	 * 
	 * <p>You can use the following constants to set this property:</p>
	 * 
	 * <ul>
	 * 	<li>BFlexBox.START</li>
	 * 	<li>BFlexBox.END</li>
	 * 	<li>BFlexBox.CENTER</li>
	 * 	<li>BFlexBox.SPACE_BETWEEN</li>
	 * 	<li>BFlexBox.SPACE_AROUND</li>
	 * 	<li>BFlexBox.STRETCH</li>
	 * </ul>
	 * 
	 * @default BFlexBox.START
	 */
	public var alignContent(get, set):String;
    
	/**
	 * Gets or sets the axis of the flexbox, which defines the flow of the flex items (children) of the flexbox.
	 * 
	 * <p>You can use the following constants to set this property:</p>
	 * 
	 * <ul>
	 * 	<li>BFlexBox.HORIZONTAL</li>
	 * 	<li>BFlexBox.VERTICAL</li>
	 * </ul>
	 * 
	 * @default BFlexBox.HORIZONTAL
	 */
	public var direction(get, set):String;
    
	/**
	 * Gets or sets whether how the flex items should be flexed.
	 * 
	 * <p>The flex property specifies the length of the flex item, relative to the rest of the flex items inside the same container.
	 * By default, the flex items will be flexed to be the same dimentions.</p>
	 * 
	 * @see setItemFlex()
	 */
	public var flex(get, set):String;
    
	/**
	 * Gets or sets the justification of the flex items.
	 * 
	 * <p>The justify property horizontally aligns the flexbox's items when the items do not use all available space on the main-axis.</p>
	 * 
	 * <p>You can use the following constants to set this property:</p>
	 * <ul>
	 * 	<li>BFlexBox.START</li>
	 * 	<li>BFlexBox.END</li>
	 * 	<li>BFlexBox.CENTER</li>
	 * 	<li>BFlexBox.SPACE_BETWEEN</li>
	 * 	<li>BFlexBox.SPACE_AROUND</li>
	 * </ul>
	 * 
	 * @default BFlexBox.SPACE_BETWEEN
	 */
	public var justify(get, set):String;
    
	/**
	 * Gets or sets whether the flex items should be wrapped or not.
	 * 
	 * <p>You can use the following constants to set this property:</p>
	 * 
	 * <ul>
	 * 	<li>BFlexBox.NO_WRAP</li>
	 * 	<li>BFlexBox.WRAP</li>
	 * </ul>
	 * 
	 * @default BFlexBox.NO_WRAP
	 */
	public var wrap(get, set):String;
    
	/**
	 * ges or sets the margin of the the floxbox, the space between the edge of the flexbox and flex items.
	 */
	public var margin(get, set):Int;
    
	/**
	 * Gets or sets the horizontal space between each child in the flexbox.
	 */
	public var horizontalSpacing(get, set):Int;
	
	/**
	 * Gets or sets the vertical space between each child in the flexbox.
	 */
    public var verticalSpacing(get, set):Int;
    public var maxSize(get, set):Point;
    public var minSize(get, set):Point;
    public var preferedSize(get, set):Point;
    public var fillWidth(get, set):Bool;
    public var fillHeight(get, set):Bool;
	
	/*
	 * @inheritDoc
	 */
	// TODO perhaps remove this
	public var flexParent(get, set):DisplayObjectContainer;

    
	// constants
    public static inline var HORIZONTAL:String = "horizontal";  		// used for direction property  
    public static inline var VERTICAL:String = "vertical";  			// used for direction property  
    //public static const HORIZONTAL_REVERSE:String = "horizontal";		// used for direction property
    //public static const VERTICAL_REVERSE:String = "vertical";			// used for direction property
    
    public static inline var NO_WRAP:String = "noWrap";  				// used for wrap property  
    public static inline var WRAP:String = "wrap";  					// used for wrap property  
    //public static const WRAP_REVERSE:String = "wrapReverse";			// used for wrap property
    
    public static inline var START:String = "start";  					// used for alignItems, alignContent, justify property  
    public static inline var END:String = "end";  						// used for alignItems, alignContent, justify property  
    public static inline var CENTER:String = "senter";  				// used for alignItems, alignContent, justify property  
    public static inline var SPACE_BETWEEN:String = "spaceBetween";  	// used for alignContent, justify property  
    public static inline var SPACE_AROUND:String = "spaceAround";  		// used for alignContent, justify property  
    public static inline var STRETCH:String = "stretch";  				// used for alignItems, alignContent property  
    //public static const BASELINE:String = "baseline";
    
    public static inline var BOTH:String = "both";  					// used for flex property  
    public static inline var NONE:String = "none";  					// used for flex property  
    
    
    // assets
    private var _container:Sprite = new Sprite();
    
    
    // other
    /**
	 * Force the flexbox to be flexed (stretched) by this container's dimentions.
	 */
    private var _flexParent:DisplayObjectContainer;
    
    
    // set and get
    //private var _display:String = ""; 					// block or inline
    private var _direction:String = HORIZONTAL;
    private var _wrap:String = WRAP;
    private var _justify:String = START;
    private var _alignItems:String = START;
    private var _alignContent:String = START;
    
    private var _flex:String = VERTICAL;  // The flex property for the children.  
    
    private var _margin:Int = 0;
    //private var _spacing:int = 0;
    private var _horizontalSpacing:Int = 0;
    private var _verticalSpacing:Int = 0;
    
    private var _maxSize:Point;
    private var _minSize:Point;
    private var _preferedSize:Point;
    
    private var _fillWidth:Bool;
    private var _fillHeight:Bool;
    
    
    public function new(direction:String = "horizontal", parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        super(parent, x, y);
        initialize();
		
		_direction = direction;
        flexParent = parent;
    }
    
    
    //**************************************** HANDLERS *********************************************
    
    
    /**
	 * @param	event
	 */
    private function resizeHandler(event:Event):Void
    {
        draw();
    } // end function
    
    
    //**************************************** FUNCTIONS ********************************************
    
    
    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();
		addChild(_container);
    } // end function
    
    
    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        
        // set width and height  
        if (_flexParent != null) 
        {
            _width = _flexParent.width;
            _height = _flexParent.height;
        }
        else 
        {
            _width = parent.width;
            _height = parent.height;
        }
        
        
        doJustify();
        doAlignItems();
        //doAlignContent(); // I think I need to finish doWrap() before this can be finished.
        
		// TODO doWrap() breaks justify SPACE_BETWEEN and SPACE_AROUND 
		// TODO doWrap() breaks alignItems SPACE_BETWEEN and SPACE_AROUND 
		doWrap();
        
        super.draw();
    } // end function
    
    
    /**
	 *
	 */
    public function addItem(item:DisplayObject):DisplayObject
    {
        _container.addChild(item);
        //
        if (parent != null) 
            draw();
        
        return item;
    } // end function
    
    
    /**
	 *
	 */
    public function addItemAt(item:DisplayObject, index:Int):DisplayObject
    {
        _container.addChildAt(item, index);
        
        if (parent != null) 
            draw();
        
        return item;
    } // end function
    
    
    /**
	 *
	 */
    public function removeItem(item:DisplayObject):DisplayObject
    {
        _container.removeChild(item);
        draw();
        return item;
    } // end function
    
    
    /**
	 *
	 */
    public function removeItemAt(index:Int):DisplayObject
    {
        var item:DisplayObject = _container.removeChildAt(index);
        draw();
        return item;
    } // end function
    
    
    /**
	 * Sets the amount of flex the flexbox's item (flex item) has.
	 * 
	 * <p>The flex parameter is a string, integer or fraction. <br>
	 * As a string, the it can be set to an integer with a "%" at the end, where the integer is greater than 0 and less then or equal to 100. eg "25%". <br>
	 * As an integer, the flex will be calculated as a ratio to the other flex items on the line. eg. 1. <br>
	 * As a faction
	 * </p>
	 * 
	 * @param	item The item to be flexed.
	 * @param	flex The amount of flex (stretching) the item should have.
	 * 
	 */
    public function setItemFlex(item:DisplayObject, flex:Dynamic):Void
    {
		// TODO finish setItemFlex() function
        if (Std.is(flex, String)) 
        {
            var fs:String = try cast(flex, String) catch(e:Dynamic) null;
        }
        // end if
        else if (Std.is(flex, Float) || Std.is(flex, Int)) 
        {
            var fnt:Float = cast(flex, Float);  // fnt = flex number test  
            
            if (fnt < 0 || fnt > 100) 
            {
                //throw new ArgumentError("As an integer or fraction, the flex parameter must be greater than 0 and less than or equal to 100.");
				trace("As an integer or fraction, the flex parameter must be greater than 0 and less than or equal to 100.");
            }
            else if (fnt < 1)   // fraction  
            {
                // compute
                
                
            }
            // end else if
            else if (fnt >= 1)   // integers  
            {
                // compute
                
            }
        }
    } // end function
    
    
    /**
	 * Controls the position of the flex items.
	 * Controls y property if direction is horizontal and x property if direction is vertical.
	 */
    private function doAlignItems():Void
    {
        var child:DisplayObject;
        var i:Int = 0;
        
        if (_direction == HORIZONTAL) 
        {
            for (i in 0..._container.numChildren){
                child = _container.getChildAt(i);
                
                switch (_alignItems)
                {
                    case START:
                        child.y = 0;
                    
                    case END:
                        child.y = _height - child.height;
                    
                    case CENTER:
                        child.y = _height / 2 - child.height / 2;
                    
                    case STRETCH:
                        child.y = 0;
                        child.height = _height;
                } // end switch  
            } // end for  
        } // enf if
        else if (_direction == VERTICAL) // end if else if
        {
            for (i in 0..._container.numChildren){
                child = _container.getChildAt(i);
                
                switch (_alignItems)
                {
                    case START:
                        child.x = 0;
                    
                    case END:
                        child.x = _width - child.width;
                    
                    case CENTER:
                        child.x = (_width - child.width) / 2;
                    
                    case STRETCH:
                        child.x = 0;
                        child.width = _width;
                } // end switch  
            } // end for  
        }
    } // end function
    
    
    /**
	 * 
	 */
    private function doAlignContent():Void
    {
        
        if (_direction == HORIZONTAL) 
        {
            //_container.x = _margin;
            
            switch (_alignContent)
            {
                case START:
                    _container.y = _margin;
                
                case END:
                    _container.y = _height - _container.height - _margin;
                
                case CENTER:
                    _container.y = _height / 2 - _container.height / 2;
                
                case STRETCH:
                    _container.y = _margin;
                    _container.height = _height - margin * 2;  // not really sure  

                case SPACE_BETWEEN:
                    _container.y = _margin;
                
				case SPACE_AROUND:
                    _container.y = _margin;
                    // ummm
            } // end switch
        } // end if
        else if (_direction == VERTICAL) 
        {
            
            
        } // end else if
    } // end function
    
    
    /**
	 * 
	 */
    private function doJustify():Void
    {
		// TODO complete space between and space around for both horizontal and vertical
		
        var child:DisplayObject;
        var xPos:Int = 0;
        var yPos:Int = 0;
        var childrenWidth:Int = 0;
        var childrenHeight:Int = 0;
        var remainderWidth:Int = 0;
        var remainderHeight:Int = 0;
        
        var i:Int;
        
        // Calculate the total width and height of all the children together.
        for (i in 0..._container.numChildren)
		{
            child = _container.getChildAt(i);
            childrenWidth += Std.int(child.width);
            childrenHeight += Std.int(child.height);
        } // end for
        
        if (_direction == HORIZONTAL) 
        {
            
            // justify START, END, and CENTER
            if (_justify == START || _justify == END || _justify == CENTER) 
            {
                for (i in 0..._container.numChildren){
                    child = _container.getChildAt(i);
                    child.x = xPos;
                    child.y = yPos;
                    xPos += Std.int(child.width + _horizontalSpacing);
                }  // end for  
                
                switch (_justify)
                {
                    case START:
                        _container.x = 0;
                    
                    case END:
                        _container.x = _width - _container.width;
                    
                    case CENTER:
                        _container.x = _width / 2 - _container.width / 2;
                }  // end switch  
            } // end if
            
			
			//**************************************************** flexible spacing
            
            // Calculate the remaining width of the flexbox from the children's total width.
            remainderWidth = Std.int(_width - childrenWidth);
            
            var spacingWidth:Int;
            
            if (_justify == SPACE_BETWEEN) 
            {
                spacingWidth = Std.int(remainderWidth / (_container.numChildren - 1));
                xPos = 0;
                
                for (i in 0..._container.numChildren)
				{
                    child = _container.getChildAt(i);
                    child.x = xPos;
                    child.y = yPos;
                    xPos += Std.int(child.width + spacingWidth);
                }
            } // end if  
            
            if (_justify == SPACE_AROUND) 
            {
                spacingWidth = Std.int(remainderWidth / (_container.numChildren));
                xPos = Std.int(spacingWidth / 2);
                
                for (i in 0..._container.numChildren){
                    child = _container.getChildAt(i);
                    child.x = xPos;
                    child.y = yPos;
                    xPos += Std.int(child.width + spacingWidth);
                }
            }  // end if  
        } // end if
        else if (_direction == VERTICAL) 
        {
            
            // justify START, END, and CENTER
            if (_justify == START || _justify == END || _justify == CENTER) 
            {
                for (i in 0..._container.numChildren)
				{
                    child = _container.getChildAt(i);
                    child.x = xPos;
                    child.y = yPos;
                    yPos += Std.int(child.height + _verticalSpacing);
                } // end for  
                
                switch (_justify)
                {
                    case START:
                        _container.y = 0;
                    
                    case END:
                        _container.y = _height - _container.height;
                    
                    case CENTER:
                        _container.y = _height / 2 - _container.height / 2;
                } // end switch  
            } // end if
            
            //**************************************************** flexible spacing
            
            // Calculate the remaining height of the flexbox from the children's total height.        // end if  
            remainderHeight = Std.int(_height - childrenHeight);
            
            var spacingHeight:Int;
            
            if (_justify == SPACE_BETWEEN) 
            {
                spacingHeight = Std.int(remainderHeight / (_container.numChildren - 1));
                yPos = 0;
                
                for (i in 0..._container.numChildren)
				{
                    child = _container.getChildAt(i);
                    child.x = xPos;
                    child.y = yPos;
                    yPos += Std.int(child.height + spacingHeight);
                }
            } // end if  
            
            if (_justify == SPACE_AROUND) 
            {
                spacingHeight = Std.int(remainderHeight / (_container.numChildren));
                yPos = Std.int(spacingHeight / 2);
                
                for (i in 0..._container.numChildren)
				{
                    child = _container.getChildAt(i);
                    child.x = xPos;
                    child.y = yPos;
                    yPos += Std.int(child.height + spacingHeight);
                }
            } // end if  
        }
    } // end function
    
    
    /**
	 * Controls wrapping
	 * 
	 * called in draw().
	 */
    private function doWrap():Void
    {
        
        if (_wrap == WRAP) 
        {
            var lineArray:Array<Dynamic> = [];
            
            var i:Int;
            var rowWidth:Int = 0;
            var columnHeight:Int = 0;
            var child:DisplayObject;
            
            var xPos:Int = 0;
            var yPos:Int = 0;
            var biggestChildDimention:Int = 0;
            var biggestChild:DisplayObject = null;
            var secondBiggestChild:DisplayObject = null;
            
            
            var i:Int = 0;
            while(i < _container.numChildren)
			{
                child = _container.getChildAt(i);
                lineArray.push(child);
                
                // set the biggest and second biggest child
                if (biggestChild == null) 
                {
                    biggestChild = child;
                    secondBiggestChild = child;
                } // end if
				
                if (direction == HORIZONTAL) 
                {
                    // get the width of the row (what a row should be) by calculating the children width and the spacing
                    rowWidth += Std.int(child.width + _horizontalSpacing);
                    
                    child.x = xPos;
                    child.y = yPos;
                    //xPos += child.width + _horizontalSpacing;
                    xPos = rowWidth;
                    
                    // get the last child on the row
                    // child and lastRowChild may be the same thing
                    //var lastRowChild:DisplayObject = lineArray[lineArray.length - 1];
                    //lastRowChild.x = xPos;
                    //lastRowChild.y = yPos;
                    
                    // update the x position
                    //xPos += lastRowChild.width + _horizontalSpacing;
                    
                    
                    // find the tallest child)
                    if (child.height > biggestChild.height) 
                    {
                        secondBiggestChild = biggestChild;
                        biggestChild = child;
                    } // end if  
                    
                    if (rowWidth > _width) 
                    {
                        if (lineArray.length > 1) 
                        {
                            rowWidth = 0;  // reset row width  
                            xPos = 0;  // reset the x position  
                            lineArray = [];  // reset the array  
                            i--;  // decrement i by 1 so that it picks up the last child as the first child for the new row  
                            
                            // update y position for new row, using the largest child found (or second largest)
                            child != biggestChild ? yPos += Std.int(biggestChild.height + _verticalSpacing) : yPos += Std.int(secondBiggestChild.height + _verticalSpacing);
                            
                            // reset biggest, and second biggest child
                            biggestChild = null;
                            secondBiggestChild = null;
                        } // end if  
                    } // end if  
                } // end if
				else if (_direction == VERTICAL) 
                {
                    // get the width of the row (what a row should be) by calculating the children width and the spacing
                    columnHeight += Std.int(child.height + _verticalSpacing);
                    
                    child.x = xPos;
                    child.y = yPos;
                    //yPos += child.height + _verticalSpacing;
                    yPos = columnHeight;
                    
                    // find the widest child)
                    if (child.width > biggestChild.width) 
                    {
                        secondBiggestChild = biggestChild;
                        biggestChild = child;
                    } // end if  
                    
                    if (columnHeight > _height) 
                    {
                        if (lineArray.length > 1) 
                        {
                            columnHeight = 0;  // reset column height  
                            yPos = 0;  // reset the y position  
                            lineArray = [];  // reset the array  
                            i--;  // decrement i by 1 so that it picks up the last child as the first child for the new row  
                            
                            // update x position for new column, using the largest child found (or second largest)
                            child != biggestChild ? xPos += Std.int(biggestChild.width + _horizontalSpacing) : xPos += Std.int(secondBiggestChild.width + _horizontalSpacing);
                            
                            // reset biggest, and second biggest child
                            biggestChild = null;
                            secondBiggestChild = null;
                        } // end if  
                    } // end if  
                } // end else if
				
				i++;
				
            } // end while
        } // end if  
		
    } // end function
    
    
    /**
	 * 
	 */
    private function calculateMaximumSize():Void
    {
        
        
    }
    
    
    /**
	 * 
	 */
    private function calculateMinimumSize():Void
    {
        
        
    }
    
    
    
    
    //**************************************** SET AND GET ******************************************
    
    
    private function get_alignItems():String
    {
        return _alignItems;
    }
    
    private function set_alignItems(value:String):String
    {
        _alignItems = value;
        doAlignItems();
        return value;
    }
    
    
    private function get_alignContent():String
    {
        return _alignContent;
    }
    
    private function set_alignContent(value:String):String
    {
        _alignContent = value;
        doAlignItems();
        return value;
    }
    
    
    private function get_direction():String
    {
        return _direction;
    }
    
    private function set_direction(value:String):String
    {
        _direction = value;
        draw();
        return value;
    }
    
    
    private function get_flex():String
    {
        return _flex;
    }
    
    private function set_flex(value:String):String
    {
        _flex = value;
        
        if (_flex == HORIZONTAL) 
        {
            _width = parent.width;
            _height = getBounds(this).height;
        }
        else if (_flex == VERTICAL) 
        {
            _width = getBounds(this).width;
            _height = parent.height;
        }
        else if (_flex == BOTH) 
        {
            _width = parent.width;
            _height = parent.height;
        }
        //draw();
        else if (_flex == NONE) 
        {
            _width = getBounds(this).width;
            _height = getBounds(this).height;
        }
        return value;
    }
    
    
    private function get_justify():String
    {
        return _justify;
    }
    
    private function set_justify(value:String):String
    {
        _justify = value;
        draw();
        return value;
    }
    
    
    private function get_wrap():String
    {
        return _wrap;
    }
    
    private function set_wrap(value:String):String
    {
        _wrap = value;
        draw();
        return value;
    }
    
    
    /***************************************************************************/
    
    
    private function get_margin():Int
    {
        return _margin;
    }
    
    private function set_margin(value:Int):Int
    {
        _margin = value;
        draw();
        return value;
    }
    
    
    private function get_horizontalSpacing():Int
    {
        return _horizontalSpacing;
    }
    
    private function set_horizontalSpacing(value:Int):Int
    {
        _horizontalSpacing = value;
        draw();
        return value;
    }
    
    
    private function get_verticalSpacing():Int
    {
        return _verticalSpacing;
    }
    
    private function set_verticalSpacing(value:Int):Int
    {
        _verticalSpacing = value;
        draw();
        return value;
    }
    
    
    private function get_maxSize():Point
    {
        return _maxSize;
    }
    
    private function set_maxSize(value:Point):Point
    {
        _maxSize = value;
        draw();
        return value;
    }
    
    
    private function get_minSize():Point
    {
        return _minSize;
    }
    
    private function set_minSize(value:Point):Point
    {
        _minSize = value;
        draw();
        return value;
    }
    
    
    private function get_preferedSize():Point
    {
        return _preferedSize;
    }
    
    private function set_preferedSize(value:Point):Point
    {
        _preferedSize = value;
        draw();
        return value;
    }
    
    
    private function get_fillWidth():Bool
    {
        return _fillWidth;
    }
    
    private function set_fillWidth(value:Bool):Bool
    {
        _fillWidth = value;
        draw();
        return value;
    }
    
    
    private function get_fillHeight():Bool
    {
        return _fillHeight;
    }
    
    private function set_fillHeight(value:Bool):Bool
    {
        _fillHeight = value;
        draw();
        return value;
    }
    
    
    
    /****************************************************************************/
    
    
	private function get_flexParent():DisplayObjectContainer
	{
		return _flexParent;
	}
	
	private function set_flexParent(value:DisplayObjectContainer):DisplayObjectContainer
    {
        //trace("BFlexBox | Setting parent!");
        if (_flexParent != null) 
        {
            if (_flexParent.hasEventListener(Event.RESIZE)) 
            {
                _flexParent.removeEventListener(Event.RESIZE, resizeHandler);
            } // end if
        } // end if
        
        value.addEventListener(Event.RESIZE, resizeHandler);
        _flexParent = value;
        return value;
    }
	
}

