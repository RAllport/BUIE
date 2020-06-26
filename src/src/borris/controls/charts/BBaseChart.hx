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
import borris.controls.BLabel;

import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 24/09/2015 (dd/mm/yyyy)
 */
class BBaseChart extends BCanvas
{
    public var numberLabelsPosition(get, set):String;

    // assets
    private var _canvas:Shape;
    private var _xLabelContainer:Sprite;
    private var _yLabelContainer:Sprite;
    private var _xLabel:BLabel;
    private var _yLabel:BLabel;
    
    
    // style
    private var _chartBackgroundColor:Int = 0x333333;
    private var _chartBorderColor:Int = 0xCCCCCC;

    
    // set and get
    private var _numberLabelsPosition:String;
    private var _data:Array<Float>;
    private var _maximum:Float = 100;
    private var _minimum:Float = 0;
    private var _autoSize:Bool = true;
    private var _labelPrecision:Int = 0;
    
    
	/**
	 * ...
	 * @author Rohaan Allport
	 */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, data:Array<Float> = null)
    {
        _data = data;
        super(parent, x, y);
    }
    
    
    //**************************************** HANDLERS *********************************************
    
    
    //**************************************** FUNCTIONS ********************************************
    
    
    //**************************************** SET AND GET ******************************************
    
    
    private function get_numberLabelsPosition():String
    {
        return _numberLabelsPosition;
    }
	
	private function set_numberLabelsPosition(value:String):String
    {
        _numberLabelsPosition = value;
        
        pan(_panX, _panY);
        return value;
    }
    
    
}

