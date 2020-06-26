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

package borris.display;

import openfl.display.GradientType;

/**
 * ...
 * 
 * @author Rohaan Allport
 * @creation-date 06/01/2015 (dd/mm/yyyy)
 */
class BGradient
{
    /**
	 * The Type of BGradient. (linear or radial)
	 */
    //public var type(get, never):String;
    public var type(get, never):GradientType;

    /**
	 * The angle of the gradient.
	 */
    public var angle(get, never):Float;

    /**
	 * The colors in the gradient.
	 */
    public var colors(get, never):Array<UInt>;

    /**
	 * The alphas of the colors.
	 */
    public var alphas(get, never):Array<Float>;

    /**
	 * 
	 */
    public var ratios(get, never):Array<Int>;


    private var _type:GradientType = GradientType.LINEAR;
    private var _angle:Float = 0;
    private var _colors:Array<UInt>;
    private var _alphas:Array<Float>;
    private var _ratios:Array<Int>;


    /**
	 * Creates a new BGradient instance.
	 * 
	 * @param	colors
	 * @param	alphas
	 * @param	ratios
	 * @param	type
	 * @param	angle
	 */
    public function new(colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int> = null, type:String = "linear", angle:Float = 0)
    {
        _type = type;
        _angle = angle;
        _colors = colors;
        _alphas = alphas;
        //_ratios = ratios;
        _ratios = (ratios != null) ? ratios : [0, 255];
    }


    //**************************************** SET AND GET ******************************************

    private function get_type():GradientType
    {
        return _type;
    }


    private function get_angle():Float
    {
        return _angle;
    }


    private function get_colors():Array<UInt>
    {
        return _colors;
    }


    private function get_alphas():Array<Float>
    {
        return _alphas;
    }


    private function get_ratios():Array<Int>
    {
        return _ratios;
    }

}

