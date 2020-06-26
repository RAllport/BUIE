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

import motion.Actuate;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;


/**
 * The BAccordion class...
 *
 * @author Rohaan Allport
 * @creation-date 13/10/2014 (dd/mm/yyyy)
 */
class BAccordion extends BUIComponent
{
	// TODO implement one open only
	/**
	 * Gets or sets a Boolean value that indicates whether more than one details can be open at a time. 
	 * A value of <code>true</code> indicates that multiple details can be open at one time; 
	 * a value of <code>false</code> indicates that only one details can be open at one time.
	 */
    public var multipleOpens(get, set):Bool;
	
	/**
	 * The array of BDetails objects in this accordian.
	 * 
	 * <p>The array is sorted in display order.</p>
	 */
    public var details(get, never):Array<BDetails>;
	
	/**
	 * [read-only] The number of BDetails Objects this BAccordion contains
	 */
    public var numDetails(get, never):Int;
	
	/**
	 * The minimum width for this accordian.
	 * 
	 * <p>Setting minWidth, will change the accordian width if the current width is smaller than the new minimum
	 * width.</p>
	 */
    public var minWidth(get, set):Float;
	
	
    // constants
    private static inline var DETAILS_TOP_MARGIN:Int = 0;
    private static inline var DETAILS_BOTTOM_MARGIN:Int = 0;
    
	private var _container:Sprite = new Sprite();
    
    // set and get
    private var _multipleOpens:Bool = true;  					// Determines whether this BAccordion Object supports multiple BDetails Objects to be open at the same time.  
    private var _details:Array<BDetails>;  						// [read-only] An array containing the BDetails Objects  
    private var _minWidth:Float = 32;  							//  
    
    
    // other
    private var _targetDetails:BDetails;
    private var _detailsWidth:Float = 200;  					//  
    private var _detailsHeight:Float = 200;  					// I really have no clue why this is here. I just have it here just cuz i can.  
    private var _buttonHeight:Int = 30;
    
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BAccordian component instance.
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
        _details = [];
        
        super(parent, x, y);
		_width = 200;
        
        // event handling
        addEventListener(Event.SELECT, onDetailSelect);
    }
    
    
    //**************************************** HANDLERS *********************************************
    
    /**
     * 
     * @param	event
     */
    private function onDetailSelect(event:Event):Void
    {
        parent.setChildIndex(this, parent.numChildren - 1);
        _targetDetails = try cast(event.target, BDetails) catch(e:Dynamic) null;
        
        // has no use, but somehow prevents the last details from glitching
        /*if (targetDetails != null) 
        {
            var difference:Int = cast targetDetails.height - buttonHeight;
        }*/
        
        var details:BDetails = null;
        var prevDetails:BDetails = null;
        var nextDetails:BDetails = null;
        var detailsY:Int;
		
        for (i in 0..._details.length)
		{
            details = _details[i];
            var curY = 0.0;
			
            if (i < _details.length) 
            {
                nextDetails = _details[i + 1];
            }
            if (i > 0) 
            {
                prevDetails = _details[i - 1];
				//curY = details.y + 0;
                details.y = prevDetails.y + prevDetails.height;
            }
			// for animation  
            if(nextDetails != null) 
            {
                // working up animation
                if (_targetDetails != null) 
                {
                    if(!_targetDetails.opened) 
                    {
                        detailsY = cast details.y + _buttonHeight;
                        
                        if (details.opened && details != _targetDetails) 
                        {
                            detailsY = cast details.y + details.height;
                        }
                        else 
                        {
                            detailsY = cast details.y + _buttonHeight;
                        }
						//details.y = curY;
						Actuate.tween(nextDetails, 0.3, {y: detailsY});
                    }  // working up animation end  
                }
            }
        } // end for  
		
        
        // for animation
        if (_targetDetails != null) 
        {
            for (i in Lambda.indexOf(_details, _targetDetails)..._details.length)
			{
                details = _details[i];
                
                if (i > 0) 
                {
                    prevDetails = _details[i - 1];
                }
                if (i < _details.length) 
                {
                    nextDetails = _details[i + 1];
                }
                
                if (nextDetails != null) 
                {
                    // working down animation
                    if (_targetDetails.opened) 
                    {
                        detailsY = cast details.y + _buttonHeight;
                        
                        if (details.opened && details != _targetDetails) 
                        {
                            detailsY = cast details.y + details.height;
                        }
                        else 
                        {
                            detailsY = cast details.y + _buttonHeight;
                        }
                        var nextDetailsY = nextDetails.y;
						nextDetails.y = detailsY;
						Actuate.tween(nextDetails, 0.3, {y: nextDetailsY});
                    }  // working down animation end  
                }
            }  // end for  
        }
    } // end function
    
    
    //**************************************** FUNCTIONS ********************************************
    
	/**
	 * @inheritDoc
	 */
	override private function initialize():Void
    {
        super.initialize();
		
		_container = new Sprite();
		
		addChild(_container);
    } // end function
	
	
    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        // Note:
        // In this draw function we only adjust the width, and the Y position of the details Objects.
        // The X position is always 0.
        // The width is the width of the details Objects is the width Accordion
        
        
        var details:BDetails;
        var prevDetails:BDetails;
        
        for (i in 0..._details.length)
		{
            details = _details[i];
            details.x = 0;
            details.y = 0;
            
            if (i > 0) 
            {
                prevDetails = _details[i - 1];
                details.y = prevDetails.y + prevDetails.height;
            }
            
            details.width = _width;
        } // end for
    } // end function
    
    
    /**
	 * Sets the component to the specified width and height.
	 * 
	 * <p><strong>Note:</strong> Only the width is changed. The height of the cccordian is determined my the details
	 * that it contains.</p>
	 * 
	 * @inheritDoc
	 */
    override public function setSize(width:Float, height:Float):Void
    {
        // the height of all the detail together when they are closed
        height = Math.max(height, _details.length * 20);
        super.setSize(width, height);
    } // end function
    
    
    /**
	 * Reports whether this accordion contains the specified details.
	 * 
	 * @param	details The BDetails to look up
	 * 
	 * @return true if details is in this accordian.
	 */
    public function containsDetails(details:BDetails):Bool
    {
        return contains(details);
        //return _container.contains(details);
    } // end function
    
    
    /**
	 * Adds a details at the bottom of the accordian.
	 * 
	 * @param	details The BDetails object to add at the bottom of the accordian.
	 * 
	 * @return 
	 */
    public function addDetails(details:BDetails):BDetails
    {
        return addDetailsAt(details, _details.length);
    } // end function
    
    
    /**
	 * Inserts a details at the specified position.
	 * The position is indexed from the top. Set the index parameter to zero to insert the item at the top of the menu.
	 * 
	 * @param	details The details object to insert.
	 * @param	index The (zero-based) position in the accordian at which to insert the details.
	 * 
	 * @return 
	 */
    public function addDetailsAt(details:BDetails, index:Int):BDetails
    {
        // makes the Accordion width the width of the datails Object of the details Object is wider.
        _width = Math.max(_width, details.width);
        
        addChildAt(details, index);
        //_container.addChildAt(details, index);
        details.width = _width;
		_details.insert(index, details);
        
        draw();
        return details;
    } // end function
    
    
    /**
	 * Removes the specified details.
	 * 
	 * @param	details The BDetails object to remove from this accordian.
	 * 
	 * @return The BDetails object removed.
	 */
    public function removeDetails(details:BDetails):BDetails
    {
        removeChild(details);
        //_container.removeChild(details);
        _details.splice(Lambda.indexOf(_details, details), 1);
        draw();
        return details;
    } // end function
    
    
    /**
	 * Removes and returns the details at the specified index.
	 * 
	 * @param	index The (zero-based) position of the details to remove.
	 * 
	 * @return The BDetails object removed.
	 */
    public function removeDetailsAt(index:Int):BDetails
    {
        var details:BDetails = _details[index];
        removeChild(details);
        //_container.removeChild(details);
        _details.splice(index, 1);
        draw();
        return details;
    } // end function
    
    
	/**
	 * Removes all the details in this BAccordion.
	 */
	public function removeAll():Void
	{
		var i:Int = _details.length - 1;
		while (i >= 0)
		{
			removeDetailsAt(i);
			i--;
		} // end while
	} // end function 
	
    /**
	 * Gets the details at the specified index.
	 * 
	 * @param	index The (zero-based) position of the details to return.
	 * 
	 * @return The BDetails object at the specified position in the menu.
	 */
    public function getDetailsAt(index:Int):BDetails
    {
        return _details[index];
    } // end function
    
    
    /**
	 * Gets the details with the specified name.
	 * 
	 * <p><strong>Note:</strong> The name property of details is not assigned by default.</p>
	 * 
	 * @param	name The string to look up.
	 * 
	 * @return The BDetails object with the specified name or null, if no such item exists in the accordian.
	 */
    public function getDetailsByName(name:String):BDetails
    {
        var details:BDetails;
        
        for (i in 0..._details.length)
		{
            details = _details[i];
            if (details.name == name) 
            {
                return details;
            } // end if
        } //  end for
        
        return null;
    } // end function
    
    
    /**
	 * Gets the details with the specified label.
	 * 
	 * <p><strong>Note:</strong> The label property of details is not assigned by default.</p>
	 * 
	 * @param	label The string to look up.
	 * 
	 * @return The BDetails object with the specified label or null, if no such item exists in the accordian.
	 */
    public function getDetailsByLabel(label:String):BDetails
    {
        var details:BDetails;
        
        for (i in 0..._details.length)
		{
            details = _details[i];
            if (details.label == label) 
            {
                trace("found details");
                return details;
            } // end if
        } //  end for
        
        return null;
    } // end function
    
    
    /**
	 * Gets the position of the specified details.
	 * 
	 * @param	details The BDetails object to look up.
	 * 
	 * @return The (zero-based) position of the specified details in this accordian or -1, if the item is not in this
	 * accordian.
	 */
    public function getDetailsIndex(details:BDetails):Int
    {
		if (containsDetails(details)) 
            return Lambda.indexOf(_details, details)
        else 
        return -1;
    } // end function
    
    
    /**
	 * Moves a details to the specified position.
	 * If the details is not already in the accordian, calling this method adds the details to the accordian.
	 * 
	 * @param	details The BDetails object to move.
	 * @param	index The (zero-based) position in the accordian to which to move the details.
	 */
    public function setDetailsIndex(details:BDetails, index:Int):Void
    {
        if (!containsDetails(details)) 
        {
            addDetailsAt(details, index);
            //draw();
            return;
        }
		_details.insert(index, details);
        draw();
    } // end function
    
    
    //******************************************** SET AND GET ******************************************
    
    private function get_multipleOpens():Bool
    {
        return _multipleOpens;
    }
    private function set_multipleOpens(value:Bool):Bool
    {
        _multipleOpens = value;
        return value;
    }
    
    
    private function get_details():Array<BDetails>
    {
        return _details;
    }
    
    
    private function get_numDetails():Int
    {
        return _details.length;
    }
    
    
    private function get_minWidth():Float
    {
        return _minWidth;
    }
    private function set_minWidth(value:Float):Float
    {
        _minWidth = Math.ceil(value);
        return value;
    }
    
    
    //*************************************** SET AND GET OVERRIDES **************************************
    
    
	#if flash
	@:setter(width)
    override private function set_width(value:Float):Void
    {
        // check to see if value, or minWidth is larger, and set it to value.
        value = Math.max(value, minWidth);
        super.width = value;
    }
    
	@:getter(height)
	override private function get_height():Float
    {
        for (i in 0..._details.length)
		{
            _height += _details[i].height;
        }
        
        return _height;
    }
    
	@:setter(height)
    override private function set_height(value:Float):Void
    {
        // the height of all the detail together when they are closed
        value = Math.max(value, _details.length * _buttonHeight);
        super.height = value;
    }
	#else
	override private function set_width(value:Float):Float
    {
        // check to see if value, or minWidth is larger, and set it to value.
        value = Math.max(value, minWidth);
        super.width = value;
        return value;
    }
    
	
	override private function get_height():Float
    {
        for (i in 0..._details.length)
		{
            _height += _details[i].height;
        }
        
        return _height;
    }
    
    override private function set_height(value:Float):Float
    {
        // the height of all the detail together when they are closed
        value = Math.max(value, _details.length * _buttonHeight);
        super.height = value;
        return value;
    }
	#end 
	
}

