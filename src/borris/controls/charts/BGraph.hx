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

package borris.controls.charts;

import borris.containers.BCanvas;
import borris.equations.BEquation;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 08/11/2015 (dd/mm/yyyy)
 */
class BGraph extends BCanvas
{
    // assets
    private var graphCanvas:Shape;  // The canvas for the graphs  
    
    
    // other
    private var equations:Array<BEquation>;  //  
    private var graphs:Sprite;  //  
    
    
    // set and get
    private var _graphColors:Array<Int> = new Array<Int>();  //  
    private var _graphTransparancies:Array<Float> = new Array<Float>();  //  
    private var _graphThicknesses:Array<Int> = new Array<Int>();  //  
    
    
	/**
	 * ...
	 * @author Rohaan Allport
	 */
    public function new()
    {
        super();
        
    }
    
    
    //**************************************** HANDLERS *********************************************
    
    
	/**
	 * 
	 * @param	event
	 */
    private function changeHandler(event:Event):Void
    {
        drawGraphs();
    } // end function
    
    
    //************************************* FUNCTIONS ******************************************
    
    
	/**
	 * 
	 */
    override private function initialize():Void
    {
        super.initialize();
        
        // initialize assets
        graphCanvas = new Shape();
        graphs = new Sprite();
        
        
        // add assets to respective containers
        _container.addChild(graphCanvas);
        _container.addChild(graphs);
        
        
        // other
        equations = new Array<BEquation>();
        
        
        // draw
        drawGraphs();
    } // end function
    
    
	/**
	 * 
	 */
    override private function draw():Void
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
    private function drawGraphs():Void
    {
        
        graphs.removeChildren();
        
        for (i in 0...equations.length){
            // set equation and properties
            var equation:BEquation = equations[i];
            
            //
            var xPos:Float = (-_lineSpacing * _gridSize / 2);
            equation.x = xPos;
            var yPos:Float = -equation.y;
            
            // set the graphics properties
            var graph:Shape = new Shape();
            graph.graphics.clear();
            graph.graphics.lineStyle(2, 0xFF0000, 1, false, "none");
            graph.graphics.moveTo(xPos, yPos);
            
            //
            for (rangeX in 0..._lineSpacing * _gridSize + 1){
                
                xPos = (rangeX - _gridSize / 2 * _lineSpacing) / _lineSpacing;
                
                //
                equation.x = xPos;
                
                yPos = -equation.y;
                
                graph.graphics.lineTo(xPos * _lineSpacing, yPos * _lineSpacing);
            }  // add the graph to the graphs sprite (_container)    // end for  
            
            
            
            
            graphs.addChild(graph);
        }  // end for  
		
    } // end function
    
    
    /**
     * 
     * @param	equation
     * @return
     */
    public function addEquation(equation:BEquation):BEquation
    {
        equations.push(equation);
        
        drawGraphs();
        
        return equation;
    } // end function
    
    
    /**
     * 
     * @param	equation
     * @param	index
     * @return
     */
    public function addEquationAt(equation:BEquation, index:Int):BEquation
    {
        equations.insert(index, equation);
        drawGraphs();
        return equation;
    } // end function
    
    
	/**
	 * 
	 * @param	equation
	 * @return
	 */
    public function removeEquation(equation:BEquation):BEquation
    {
        equations.splice(Lambda.indexOf(equations, equation), 1);
        drawGraphs();
        return equation;
    } // end function
    
    
	/**
	 * 
	 * @param	index
	 * @return
	 */
    public function removeEquationAt(index:Int):BEquation
    {
        var equation:BEquation = equations[index];
        equations.splice(index, 1);
        drawGraphs();
        return equation;
    } // end function
	
}

