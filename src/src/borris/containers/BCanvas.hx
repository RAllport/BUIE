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

import borris.controls.BLabel;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

// TODO convert to BUIElement instead os Sprite
/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 12/01/2016 (dd/mm/yyyy)
 */
class BCanvas extends Sprite
{
    // TODO use BStyle object for styling
    public var backgroundColor(get, set):Int;
    public var backgroundTransparency(get, set):Float;
    public var labelColor(get, set):Int;
    public var labelTransparency(get, set):Float;
    public var labelsPosition(get, set):String;
    public var axisLineColor(get, set):Int;
    public var axisLineTransparency(get, set):Float;
    public var axisLineThickness(get, set):Int;
    public var lineColor(get, set):Int;
    public var lineTransparency(get, set):Float;
    public var lineThickness(get, set):Int;
    public var lineSpacing(get, set):Int;
    public var gridSize(get, set):Int;
    public var showGrid(get, set):Bool;
    public var showLabels(get, set):Bool;
    public var panX(get, set):Float;
    public var panY(get, set):Float;
    public var zoom(get, set):Float;


    // assets
    private var _container:Sprite; // container to hold the the grid and canvases
    private var _containerMask:Shape; // the mask for the container

    private var _xLabelsContainer:Sprite; // container for horizontal number labels
    private var _yLabelsContainer:Sprite; // container for vertical number labels

    private var _xLabelMask:Shape; //
    private var _yLabelMask:Shape; //


    private var _background:Shape; // The background of the graph
    private var _grid:Shape; // The canvas for the lines (grid)
    //protected var canvas:Sprite;										// The actual display opject to draw into


    // set and get
    private var _backgroundColor:Int = 0x000000; //
    private var _backgroundTransparency:Float = 1; //

    private var _labelColor:Int = 0xFFFFFF; //
    private var _labelTransparency:Float = 1; //
    private var _labelsPosition:String = "edge"; // The position of the number labels. Either "edge", "origin" or "center"

    private var _axisLineColor:Int = 0xFFFFFF; //
    private var _axisLineTransparency:Float = 0.5; //
    private var _axisLineThickness:Int = 2; //
    private var _lineColor:Int = 0xFFFFFF; //
    private var _lineTransparency:Float = 0.2; //
    private var _lineThickness:Int = 1; //
    private var _lineSpacing:Int = 30; //

    private var _gridSize:Int = 60; //
    private var _showGrid:Bool = true;
    private var _showLabels:Bool = true;

    private var _width:Float = 800; // The width of the graph in pixels
    private var _height:Float = 600; // The height of the graph in pixels
    private var _panX:Float = 0; // The x position of the container to the mask
    private var _panY:Float = 0; // The y position of the container to the mask
    private var _zoom:Float = 1; // The scaling of the container (as percentage)


    /**
     * 
     */
    public function new()
    {
        super();
        initialize();
    }


    //**************************************** HANDLERS *********************************************


    //**************************************** FUNCTIONS ********************************************


    /**
	 * 
	 */
    private function initialize():Void
    {
        // initialize assets
        _container = new Sprite();

        _containerMask = new Shape();
        _containerMask.graphics.beginFill(0xFF00FF, 1);
        _containerMask.graphics.drawRect(0, 0, 100, 100);
        _containerMask.graphics.endFill();

        _xLabelsContainer = new Sprite();
        _yLabelsContainer = new Sprite();

        _xLabelMask = new Shape();
        _xLabelMask.graphics.beginFill(0xFF00FF, 1);
        _xLabelMask.graphics.drawRect(0, 0, 100, 100);
        _xLabelMask.graphics.endFill();

        _yLabelMask = new Shape();
        _yLabelMask.graphics.beginFill(0xFF00FF, 1);
        _yLabelMask.graphics.drawRect(0, 0, 100, 100);
        _yLabelMask.graphics.endFill();

        _background = new Shape();
        _grid = new Shape();


        // add assets to respective containers
        addChild(_background);
        addChild(_container);
        addChild(_containerMask);
        addChild(_xLabelsContainer);
        addChild(_yLabelsContainer);
        addChild(_xLabelMask);
        addChild(_yLabelMask);


        _container.addChild(_grid);

        _container.mask = _containerMask;
        _xLabelsContainer.mask = _xLabelMask;
        _yLabelsContainer.mask = _yLabelMask;


        // draw
        draw();
        drawGrid();
        drawLabels();

        pan(0, 0);
    } // end function


    /**
	 * 
	 */
    private function draw():Void
    {
        _background.graphics.clear();
        _background.graphics.beginFill(_backgroundColor, _backgroundTransparency);
        _background.graphics.drawRect(0, 0, _width, _height);
        _background.graphics.endFill();

        _containerMask.width = _width;
        _containerMask.height = _height;

        _xLabelMask.width = _width;
        _xLabelMask.height = _height;

        _yLabelMask.width = _width;
        _yLabelMask.height = _height;
    } // end function


    /**
	 * 
	 */
    private function drawGrid():Void
    {

        _grid.graphics.clear();
        _grid.graphics.lineStyle(_lineThickness, _lineColor, _lineTransparency, true, "none");

        for(i in 0..._gridSize + 1)
        {
            // draw x lines
            _grid.graphics.moveTo(-_gridSize / 2 * _lineSpacing, -_gridSize / 2 * _lineSpacing + i * _lineSpacing);
            _grid.graphics.lineTo(_gridSize / 2 * _lineSpacing, -_gridSize / 2 * _lineSpacing + i * _lineSpacing);

            // draw y lines
            _grid.graphics.moveTo(-_gridSize / 2 * _lineSpacing + i * _lineSpacing, -_gridSize / 2 * _lineSpacing);
            _grid.graphics.lineTo(-_gridSize / 2 * _lineSpacing + i * _lineSpacing, _gridSize / 2 * _lineSpacing);
        } // draw axis


        _grid.graphics.lineStyle(_axisLineThickness, _axisLineColor, _axisLineTransparency, true, "none");

        // draw X axis
        _grid.graphics.moveTo(-_gridSize / 2 * _lineSpacing, 0);
        _grid.graphics.lineTo(_gridSize / 2 * _lineSpacing, 0);

        // draw Y axis
        _grid.graphics.moveTo(0, -_gridSize / 2 * _lineSpacing);
        _grid.graphics.lineTo(0, _gridSize / 2 * _lineSpacing);
    } // end function


    /**
	 * 
	 */
    private function drawLabels():Void
    {
        var tempTF:TextFormat;

        _xLabelsContainer.removeChildren();
        _yLabelsContainer.removeChildren();

        var numberLabel:BLabel;

        for(i in 0..._gridSize + 1)
        {
            // add x labels
            numberLabel = new BLabel(_xLabelsContainer, (-_gridSize / 2 * _lineSpacing + i * _lineSpacing), 0, Std.string((-_gridSize / 2 + i)));
            numberLabel.autoSize = TextFieldAutoSize.LEFT;

            // change color
            tempTF = numberLabel.textField.getTextFormat();
            tempTF.color = _labelColor;
            numberLabel.textField.setTextFormat(tempTF);


            // add y labels
            numberLabel = new BLabel(_yLabelsContainer, 0, (-_gridSize / 2 * _lineSpacing + i * _lineSpacing), Std.string((_gridSize / 2 - i)));
            numberLabel.autoSize = TextFieldAutoSize.LEFT;

            // change color
            tempTF = numberLabel.textField.getTextFormat();
            tempTF.color = _labelColor;
            numberLabel.textField.setTextFormat(tempTF);
        }

        _xLabelsContainer.alpha = _labelTransparency;
        _yLabelsContainer.alpha = labelTransparency;
    } // end function


    /**
	 * 
	 */
    public function pan(x:Float, y:Float):Void
    {
        _panX = x;
        _panY = y;

        // position the container
        _container.x = _width / 2 + _panX;
        _container.y = _height / 2 + _panY;


        // position the x labels
        _xLabelsContainer.x = _container.x; //- xLabelsContainer.getChildAt(0).height/4;  ;
        _xLabelsContainer.y = _height - _xLabelsContainer.height;

        // position the y labels
        _yLabelsContainer.x = _width - _yLabelsContainer.width;
        _yLabelsContainer.y = _container.y - _yLabelsContainer.getChildAt(0).height / 2;

        if(_labelsPosition == "origin")
        {
            _xLabelsContainer.y = _container.y;
            _yLabelsContainer.x = _container.x;
        }
        else if(_labelsPosition == "edge")
        {
            _xLabelsContainer.y = _height - _xLabelsContainer.height;
            _yLabelsContainer.x = _width - _yLabelsContainer.width;
        }
    } // end function


    //**************************************** SET AND GET ******************************************


    private function get_backgroundColor():Int
    {
        return _backgroundColor;
    }

    private function set_backgroundColor(value:Int):Int
    {
        _backgroundColor = value;
        draw();
        return value;
    }


    private function get_backgroundTransparency():Float
    {
        return _backgroundTransparency;
    }

    private function set_backgroundTransparency(value:Float):Float
    {
        _backgroundTransparency = value;
        draw();
        return value;
    }


    private function get_labelColor():Int
    {
        return _labelColor;
    }

    private function set_labelColor(value:Int):Int
    {
        _labelColor = value;
        drawLabels();
        return value;
    }


    private function get_labelTransparency():Float
    {
        return _labelTransparency;
    }

    private function set_labelTransparency(value:Float):Float
    {
        _labelTransparency = value;
        drawLabels();
        return value;
    }


    private function get_labelsPosition():String
    {
        return _labelsPosition;
    }

    private function set_labelsPosition(value:String):String
    {
        _labelsPosition = value;

        pan(_panX, _panY);
        return value;
    }


    private function get_axisLineColor():Int
    {
        return _axisLineColor;
    }

    private function set_axisLineColor(value:Int):Int
    {
        _axisLineColor = value;
        drawGrid();
        return value;
    }


    private function get_axisLineTransparency():Float
    {
        return _axisLineTransparency;
    }

    private function set_axisLineTransparency(value:Float):Float
    {
        _axisLineTransparency = value;
        drawGrid();
        return value;
    }


    private function get_axisLineThickness():Int
    {
        return _axisLineThickness;
    }

    private function set_axisLineThickness(value:Int):Int
    {
        _axisLineThickness = value;
        drawGrid();
        return value;
    }


    private function get_lineColor():Int
    {
        return _lineColor;
    }

    private function set_lineColor(value:Int):Int
    {
        _lineColor = value;
        drawGrid();
        return value;
    }


    private function get_lineTransparency():Float
    {
        return _lineTransparency;
    }

    private function set_lineTransparency(value:Float):Float
    {
        _lineTransparency = value;
        drawGrid();
        return value;
    }


    private function get_lineThickness():Int
    {
        return _lineThickness;
    }

    private function set_lineThickness(value:Int):Int
    {
        _lineThickness = value;
        drawGrid();
        return value;
    }


    private function get_lineSpacing():Int
    {
        return _lineSpacing;
    }

    private function set_lineSpacing(value:Int):Int
    {
        _lineSpacing = value;
        drawGrid();
        drawLabels();
        return value;
    }


    private function get_gridSize():Int
    {
        return _gridSize;
    }

    private function set_gridSize(value:Int):Int
    {
        _gridSize = Math.ceil(value / 2) * 2;
        drawGrid();
        drawLabels();
        return value;
    }


    private function get_showGrid():Bool
    {
        return _showGrid;
    }

    private function set_showGrid(value:Bool):Bool
    {
        _grid.visible = _showGrid = value;
        return value;
    }


    private function get_showLabels():Bool
    {
        return _showLabels;
    }

    private function set_showLabels(value:Bool):Bool
    {
        _showLabels = value;
        _xLabelsContainer.visible = _showLabels;
        _yLabelsContainer.visible = _showLabels;
        return value;
    }


    private function get_panX():Float
    {
        return _panX;
    }

    private function set_panX(value:Float):Float
    {
        _panX = value;
        pan(_panX, _panY);
        return value;
    }


    private function get_panY():Float
    {
        return _panY;
    }

    private function set_panY(value:Float):Float
    {
        _panY = value;
        pan(_panX, _panY);
        return value;
    }


    private function get_zoom():Float
    {
        return _zoom;
    }

    private function set_zoom(value:Float):Float
    {
        _zoom = value;
        if(_zoom <= 0.1)
        {
            _zoom = 0.1;
        }

        _container.scaleX = _container.scaleY = _zoom;

        for(i in 0..._gridSize + 1)
        {
            cast((_xLabelsContainer.getChildAt(i)), BLabel).x = (-_gridSize / 2 * _lineSpacing + i * _lineSpacing) * _zoom;
            cast((_yLabelsContainer.getChildAt(i)), BLabel).y = (-_gridSize / 2 * _lineSpacing + i * _lineSpacing) * _zoom;
        }
        return value;
    }


    //*************************************** SET AND GET OVERRIDES **************************************


    #if flash
	@:getter(width)
	private function get_width():Float
    {
        return _width;
    }
    
	@:setter(width)
	private function set_width(value:Float):Void
    {
        _width = value;
        draw();
        pan(_panX, _panY);
    }
    
    
	@:getter(height)
    private function get_height():Float
    {
        return _height;
    }
	
	@:setter(height)
	private function set_height(value:Float):Void
    {
        _height = value;
        draw();
        pan(_panX, _panY);
    }
	#else

    override private function get_width():Float
    {
        return _width;
    }

    override private function set_width(value:Float):Float
    {
        _width = value;
        draw();
        pan(_panX, _panY);
        return value;
    }


    override private function get_height():Float
    {
        return _height;
    }

    override private function set_height(value:Float):Float
    {
        _height = value;
        draw();
        pan(_panX, _panY);
        return value;
    }
    #end


}

