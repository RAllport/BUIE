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

package borris;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 02/11/2015 (dd/mm/yyyy)
 */
class BMath
{
    // constants


    //************************************* FUNCTIONS ******************************************


    /**
     * 
     * @param	radians
     * @return
     */
    public static function radiansToDegrees(radians:Float):Float
    {
        return radians * 180 / Math.PI;
    } // end function


    /*public static function radiansToGradians(radians:Number):Number
		{
			return 0;
		} // end 
		*/

    /**
     * 
     * @param	degrees
     * @return
     */
    public static function degreesToRadians(degrees:Float):Float
    {
        return degrees * Math.PI / 180;
    } // end function


    /*public static function degreesToGradians(degrees:Number):Number
		{
			return 0;
		} // end 
		
		
		// 
		// 
		public static function gradiansToRadians(gradians:Number):Number
		{
			return 0;
		} // end 
		
		
		// 
		// 
		public static function gradiansToDegrees(gradians:Number):Number
		{
			return 0;
		} // end 
		*/


    /**
     * 
     * @param	x
     * @return
     */
    public static function factorial(x:Int):Int
    {
        var factorial:Int = 1;
        for(i in 1...x + 1)
        {
            factorial *= i;
        }
        return factorial;
    } // end function


    /**
     * 
     * @param	x
     * @param	base
     * @return
     */
    public static function log(x:Float, base:Float = 10):Float
    {
        return Math.log(x) / Math.log(base);
    } // end function


    /**
     * 
     * @param	x
     * @return
     */
    public static function ln(x:Float):Float
    {
        return Math.log(x);
    } // end function


    /**
     * 
     * @param	a
     * @param	b
     * @return
     */
    public static function nCr(a:Int, b:Int):Float
    {
        //a!/(b!*(a-b)!)
        return factorial(a) / (factorial(b) * factorial(a - b));
    } // end function


    /**
     * 
     * @param	a
     * @param	b
     * @return
     */
    public static function nPr(a:Int, b:Int):Float
    {
        return factorial(a) / factorial(a - b);
    } // end function


    /**
     * 
     * @param	values
     * @return
     */
    public static function mean(values:Array<Float>):Float
    {
        var total:Float = 0;
        for(i in 0...values.length)
        {
            total += values[i];
        } // end for

        return total / values.length;
    } // end function


    /**
	 * Finds the factors in <code>x</code> and returns and array of the factors.
	 * 
	 * @param	x The number 
	 * @return	
	 */
    public static function findFactors(x:Int):Array<Int>
    {
        var factors:Array<Int> = [];

        for(i in 1...x + 1)
        {
            if(x % i == 0)
            {
                factors.push(i);
            } // end if
        } // end for

        return factors;

    } // end function findFactors


    /**
	 * This function finds the first number with <code>x</code> factors and returns an integer array  
	 * of its factors. The last value in the array in the array is the number that has <code>x</code> factors.
	 * This is hella processor intensive the higher you go.
	 * 
	 * @param	x The number of factors.
	 * @return	
	 */
    public static function fistWithXactors(x:Int):Array<Int>
    {
        var number:Int = 0;
        var factors:Array<Int> = [];

        while(factors.length < x)
        {
            factors = findFactors(number++);
        } // end while

        return factors;
    } // end function fistWithXactors


    /**
	 * 
	 * @return
	 */
    public static function toPrecision(value:Float, precision:Int):Float
    {
        var pow = Math.pow(10, precision);
        return Math.round(value * pow) / pow;
    } // end function


    /**
	 * Coordinate rotation
	 * 
	 * @param	x
	 * @param	y
	 * @param	sin
	 * @param	cos
	 * @param	reverse
	 * @return
	 */
    public static function coordinateRotate(x:Float, y:Float, sin:Float, cos:Float, reverse:Bool = false):Dynamic<Float>
    {
        //var result = [0.0, 0.0];
        var result = {x: 0.0, y: 0.0};

        if(reverse)
        {
            result.x = x * cos + y * sin;
            result.y = y * cos - x * sin;
        }
        else
        {
            result.x = x * cos - y * sin;
            result.y = y * cos + x * sin;
        } // end else

        return result;
    }
    // end function

}

