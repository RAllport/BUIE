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

import borris.containers.BPanel;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 19/03/2016 (dd/mm/yyyy)
 */
class BPanelBounds
{
    /**
	 * Gets or sets the container that this PanelBounds is registered in.
	 */
    public var container(get, set):DisplayObjectContainer;

    /**
	 * Gets or sets the padding of the PanelBounds.
	 */
    public var padding(get, set):Int;

    /**
	 * Gets or sets the x coordinate of the top-left corner of the PanelBounds.
	 */
    public var x(get, set):Int;

    /**
	 * Gets or sets the y coordinate of the top-left corner of the PanelBounds.
	 */
    public var y(get, set):Int;

    /**
	 * Gets or sets the width of the PanelBounds, in pixels.
	 */
    public var width(get, set):Int;

    /**
	 * Gets or sets the height of the PanelBounds, in pixels.
	 */
    public var height(get, set):Int;

    /**
	 * [read-only] The width of the bounderies, in pixels.
	 */
    public var innerWidth(get, never):Int;

    /**
	 * [read-only] The height of the bounderies, in pixels.
	 */
    public var innerHeight(get, never):Int;

    /**
	 * [read-only] The y coordinate of the top of the border bounderies.
	 * This is the sum of the y and padding properties.
	 */
    public var top(get, never):Int;

    /**
	 * [read-only] The y coordinate of the bottom of the border bounderies.
	 * This is the sum of the y and height properties minus the padding property.
	 */
    public var bottom(get, never):Int;

    /**
	 * [read-only] The y=x coordinate of the left of the border bounderies.
	 * This is the sum of the x and padding properties.
	 */
    public var left(get, never):Int;

    /**
	 * [read-only] The x coordinate of the right of the border bounderies.
	 * This is the sum of the x and width properties minus the padding property.
	 */
    public var right(get, never):Int;

    /**
	 * [read-only]
	 */
    public var snappedPanels(get, never):Array<BPanel>;

    /**
	 * [read-only]
	 */
    public var numPanels(get, never):Int;

    /**
	 * Gets or sets the thickness of the boundery edges.
	 *
	 * <p>The Edges are used for snappable panels as a way to snap to the boundery. They cannot be seen by the user.</p>
	 *
	 * @default 5
	 */
    public var edgeThickness(get, set):Int;


    // assets
    private var _container:DisplayObjectContainer;
    
    @:allow(borris.containers)
    private var topleftEdge:Sprite;
    @:allow(borris.containers)
    private var topRightEdge:Sprite;
    @:allow(borris.containers)
    private var bottomLeftEdge:Sprite;
    @:allow(borris.containers)
    private var bottomRightEdge:Sprite;
    @:allow(borris.containers)
    private var topEdge:Sprite;
    @:allow(borris.containers)
    private var bottomEdge:Sprite;
    @:allow(borris.containers)
    private var leftEdge:Sprite;
    @:allow(borris.containers)
    private var rightEdge:Sprite;
    
    
    // other
    
    
    // set and get
    private var _padding:Int = 0;
    private var _x:Int = 0;
    private var _y:Int = 0;
    private var _width:Int = 0;
    private var _height:Int = 0;
    
    private var _snappedPanels:Array<BPanel> = new Array<BPanel>();
    private var _snappedPanelVars:Array<Dynamic> = new Array<Dynamic>();
    
    private var _edgeThickness:Int = 5;  // The thickness of the resize grabbers. It would be wise to change this on mobile devices, or when a touch event is detected.  
    
    
    
    public function new(container:DisplayObjectContainer)
    {
        // contructor code
        _container = container;
        
        // assets
        
        // resize grabbers
        topleftEdge = new Sprite();
        topRightEdge = new Sprite();
        bottomLeftEdge = new Sprite();
        bottomRightEdge = new Sprite();
        topEdge = new Sprite();
        bottomEdge = new Sprite();
        leftEdge = new Sprite();
        rightEdge = new Sprite();
        
        
        // add assets to respective containers
        _container.addChild(topleftEdge);
        _container.addChild(topRightEdge);
        _container.addChild(bottomLeftEdge);
        _container.addChild(bottomRightEdge);
        _container.addChild(topEdge);
        _container.addChild(bottomEdge);
        _container.addChild(leftEdge);
        _container.addChild(rightEdge);
        
        //graphics.beginFill(0xff0000, 0.5);
        //graphics.drawRect(0, 0, 100, 100);
        
        drawEdges();
        draw();
    }
    
    
    //**************************************** FUNCTIONS ********************************************
    
    
    /**
	 * Draws the edges.
	 */
    private function drawEdges():Void
    {
        var color:Int = 0x00FF00;
        var alpha:Float = 0;
        
        topleftEdge.scaleX =
                topRightEdge.scaleX =
                        bottomLeftEdge.scaleX =
                                bottomRightEdge.scaleX =
                                        topEdge.scaleX =
                                                bottomEdge.scaleX =
                                                        leftEdge.scaleX =
                                                                rightEdge.scaleX =
                                                                        
                                                                        topleftEdge.scaleY =
                                                                                topRightEdge.scaleY =
                                                                                        bottomLeftEdge.scaleY =
                                                                                                bottomRightEdge.scaleY =
                                                                                                        topEdge.scaleY =
                                                                                                                bottomEdge.scaleY =
                                                                                                                        leftEdge.scaleY =
                                                                                                                                rightEdge.scaleY = 1;
        
        topleftEdge.alpha =
                topRightEdge.alpha =
                        bottomLeftEdge.alpha =
                                bottomRightEdge.alpha =
                                        topEdge.alpha =
                                                bottomEdge.alpha =
                                                        leftEdge.alpha =
                                                                rightEdge.alpha = alpha;
        
        topleftEdge.graphics.clear();
        topRightEdge.graphics.clear();
        bottomLeftEdge.graphics.clear();
        bottomRightEdge.graphics.clear();
        topEdge.graphics.clear();
        bottomEdge.graphics.clear();
        leftEdge.graphics.clear();
        rightEdge.graphics.clear();
        
        
        var grabbersWidth:Int = _width - _padding * 2;  //  
        var grabbersHeight:Int = _height - _padding * 2;  //  
        
        topleftEdge.graphics.beginFill(color, 1);
        topRightEdge.graphics.beginFill(color, 1);
        bottomLeftEdge.graphics.beginFill(color, 1);
        bottomRightEdge.graphics.beginFill(color, 1);
        topEdge.graphics.beginFill(color, 1);
        bottomEdge.graphics.beginFill(color, 1);
        leftEdge.graphics.beginFill(color, 1);
        rightEdge.graphics.beginFill(color, 1);
        
        topleftEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
        topRightEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
        bottomLeftEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
        bottomRightEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
        topEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
        bottomEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
        leftEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
        rightEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
        
        topleftEdge.graphics.endFill();
        topRightEdge.graphics.endFill();
        bottomLeftEdge.graphics.endFill();
        bottomRightEdge.graphics.endFill();
        topEdge.graphics.endFill();
        bottomEdge.graphics.endFill();
        leftEdge.graphics.endFill();
        rightEdge.graphics.endFill();
    } // end function
    
    
    /**
	 * 
	 */
    private function draw():Void
    {
        // resize grabbers
        topleftEdge.x = _padding;
        topleftEdge.y = _padding;
        topRightEdge.x = _width - _padding - _edgeThickness;
        topRightEdge.y = _padding;
        bottomLeftEdge.x = _padding;
        bottomLeftEdge.y = _height - _padding - _edgeThickness;
        bottomRightEdge.x = _width - _padding - _edgeThickness;
        bottomRightEdge.y = _height - _padding - _edgeThickness;
        
        topEdge.x = _padding + _edgeThickness;
        topEdge.y = _padding;
        bottomEdge.x = _padding + _edgeThickness;
        bottomEdge.y = _height - _padding - _edgeThickness;
        leftEdge.x = _padding;
        leftEdge.y = _padding + _edgeThickness;
        rightEdge.x = _width - _padding - _edgeThickness;
        rightEdge.y = _padding + _edgeThickness;
        
        topEdge.width = _width - (_padding * 2) - (_edgeThickness * 2);
        bottomEdge.width = _width - (_padding * 2) - (_edgeThickness * 2);
        leftEdge.height = _height - (_padding * 2) - (_edgeThickness * 2);
        rightEdge.height = _height - (_padding * 2) - (_edgeThickness * 2);
    } // end function
    
    
    /**
	 * 
	 */
    @:allow(borris.containers)
    private function contains(panel:BPanel):Bool
    {
        return (Lambda.indexOf(_snappedPanels, panel) >= 0);
    } // end function
    
    /**
	 * 
	 * @param	panel
	 */
    @:allow(borris.containers)
    private function addSnappedPanel(panel:BPanel, snappedPosition:String):Void
    {
        /*if (!contains(panel))
			{
				
				
			} // end if*/
        
        _snappedPanelVars.push({
                    panel:panel,
                    snapPosition:snappedPosition,

                });
        _snappedPanels.push(panel);
    } // end function
    
    /**
	 * 
	 * @param	panel
	 */
    @:allow(borris.containers)
    private function removeSnappedPanel(panel:BPanel):Void
    {
        
        if (contains(panel)) 
        {
            _snappedPanels.splice(Lambda.indexOf(_snappedPanels, panel), 1);
            _snappedPanelVars.splice(Lambda.indexOf(_snappedPanels, panel), 1);
        }  // end if  
    } // end function
    
    
    /**
	 * 
	 * @param	
	 */
    @:allow(borris.containers)
    private function getPanelAt(index:Int):BPanel
    {
        return _snappedPanels[index];
    } // end function
    
    
    @:allow(borris.containers)
    private function getSnappedPosition(panel:BPanel):String
    {
        if (contains(panel)) 
        {
            return try cast(_snappedPanelVars[Lambda.indexOf(_snappedPanels, panel)].snapPosition, String) catch(e:Dynamic) null;
        }
        
        return "";
    } // end function
    
    /**
	 * 
	 */
    /*internal function forEachPanel(callBack:Function):void
		{
			var panel:BPanel;
			
			for(var i:int = 0; i < numPanels; i++)
			{
				panel = getPanelAt(i);
				callBack();
			} // end 
			
		} // end function forEachPanel*/
    
    
    //**************************************** SET AND GET ******************************************
    

    private function get_container():DisplayObjectContainer
    {
        return _container;
    }
    
    private function set_container(value:DisplayObjectContainer):DisplayObjectContainer
    {
        _container = container;
        
        _container.addChild(topleftEdge);
        _container.addChild(topRightEdge);
        _container.addChild(bottomLeftEdge);
        _container.addChild(bottomRightEdge);
        _container.addChild(topEdge);
        _container.addChild(bottomEdge);
        _container.addChild(leftEdge);
        _container.addChild(rightEdge);
        return value;
    }
    

    private function get_padding():Int
    {
        return _padding;
    }
    
    private function set_padding(value:Int):Int
    {
        _padding = value;
        draw();
        return value;
    }
    

    private function get_x():Int
    {
        return _x;
    }
    
    private function set_x(value:Int):Int
    {
        _x = value;
        draw();
        return value;
    }
    

    private function get_y():Int
    {
        return _y;
    }
    
    private function set_y(value:Int):Int
    {
        _y = value;
        draw();
        return value;
    }
    

    private function get_width():Int
    {
        return _y;
    }
    
    private function set_width(value:Int):Int
    {
        _width = value;
        draw();
        return value;
    }
    

    private function get_height():Int
    {
        return _height;
    }
    
    private function set_height(value:Int):Int
    {
        _height = value;
        draw();
        return value;
    }
    

    private function get_innerWidth():Int
    {
        return _width - _padding * 2;
    }
    

    private function get_innerHeight():Int
    {
        return _height - _padding * 2;
    }
    

    private function get_top():Int
    {
        return _y + _padding;
    }
    

    private function get_bottom():Int
    {
        return _y + _height - _padding;
    }
    

    private function get_left():Int
    {
        return _x + _padding;
    }
    

    private function get_right():Int
    {
        return _x + _width - _padding;
    }
    

    private function get_snappedPanels():Array<BPanel>
    {
        return _snappedPanels;
    }
    

    private function get_numPanels():Int
    {
        return _snappedPanels.length;
    }
    

    private function get_edgeThickness():Int
    {
        return _edgeThickness;
    }
    
    private function set_edgeThickness(value:Int):Int
    {
        _edgeThickness = value;
        drawEdges();
        draw();
        return value;
    }

} // end class

