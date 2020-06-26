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

package borris.equations;

import borris.BMath;


// TODO append function instead of get_equation.push
// TODO insert function. insert(pos, value)
// TODO delete function
// TODO remove
// TODO algebraric epressions
/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 08/11/2015 (dd/mm/yyyy)
 */
class BEquation
{
    public var angularMeasureMode(get, set):String;
    public var equation(get, set):Array<Dynamic>;
    public var result(get, never):Float;
    public var standardNotationPower(get, never):Int;
    public var standardNotationResult(get, never):Float;
    public var stringRepresentation(get, never):String;
    public var x(get, set):Float;
    public var y(get, never):Float;

    // constants
    // angular measure
    public static inline var ANGULAR_MEASURE_DEGREES:String = "degrees";
    public static inline var ANGULAR_MEASURE_RADIANS:String = "radians";


    // other
    private var _finalResult:Float = 0; // the final result/answer
    private var _arrayToCalculate:Array<Dynamic> = []; //


    //  set and get
    private var _angularMeasureMode:String = ANGULAR_MEASURE_DEGREES;
    private var _equation:Array<Dynamic> = []; //
    private var _stringRepresentation:String = ""; // [read-only]

    private var _result:Float = 0; // [read-only]

    private var _standardNotationPower:Int = 0; // [read-only]
    private var _standardNotationResult:Float = 0; // [read-only]

    private var _x:Float = 0; //
    private var _y:Float = 0; // The output of X (same as result)


    /**
	 * Creates a new BEquation instance.
	 * 
	 * @param	equation
	 */
    public function new(equation:Array<Dynamic>)
    {
        super();
        _equation = equation;
        setArrayToCalc();
    }


    //**************************************** HANDLERS *********************************************


    //**************************************** FUNCTIONS ********************************************


    /**
	 * 
	 * @param	bracketArray
	 * @return
	 */
    private function separateBrackets(bracketArray:Array<Dynamic>):Float
    {
        trace("BEquation | Separating brackets...");
        var tempNum:Float = 0;
        var tempArray:Array<Dynamic>;
        var spliced:Array<Dynamic>;
        var bracketsFlag:Bool = false;

        // search for brackets
        var i:Int = 0;
        while(i < bracketArray.length)
        {
            if(bracketArray[i] == ")")
            {

                trace("\nBEquation | Brackets found!");

                var j:Int = i;
                while(j >= 0)
                {
                    if(bracketArray[j] == "(")
                    {
                        tempArray = bracketArray.splice(j + 1, i - (j + 1));
                        trace("BEquation | Equation in brackets: " + tempArray);
                        var _result:Float = operate(tempArray);
                        trace("BEquation | Result (in brackets): " + _result + "\n");
                        spliced = bracketArray.splice(j, 2);
                        bracketArray.insert(j, _result);
                        i = 0;
                    } // end of if
                    j--;
                } // end of for loop j

                bracketsFlag = true;
            } // end of if
            i++;
        }

        /* The loops have now found the brackets, obtained the result inside them.
		 * And has taken out the brackets and placed the result in the array.
		 * Now it will check How big the new equation is.
		 * if it is 2 or greater (eg. root(4) an operation and number) then operate again.
		 * if its less than 2 (eg. a single digit), then the final result has been obtained.
		 */

        if(!bracketsFlag)
        {
            trace("BEquation | No brackets found!");

        }

        // test length of array, if 2 or more, opperate again  
        if(bracketArray.length >= 2)
        {
            tempNum = operate(bracketArray);
        }
        else
        {
            tempNum = _result;
        }

        return tempNum;
    } // end function


    /**
	 * loops though an array multiple times. looks for a
	 * mathematical operation and performs that operation on the numbers
	 * adjacent to it, cuts out the operation and its adjacent number(s)
	 * and replaces them with the new value.
	 * 
	 * @param	array
	 * @return
	 */
    private function operate(array:Array<Dynamic>):Float
    {
        var tempNum:Float = 0;
        var answer:Float = 0;
        var loopTimes:Int = array.length;
        var spliced:Array<Dynamic>;

        var i:Int = 0;

        // convert all numbers with minus signs to minus numbers
        //for (i in 0...loopTimes)
        while(i < loopTimes)
        {
            if(array[i] == "minus")
            {
                tempNum = array[i + 1] * -1;
                spliced = array.splice(i, 2);
                array.insert(i, tempNum);
                if(!Math.isNaN(array[i - 1]))
                {
                    array.insert(i, "add");
                }
                i = 0;
            }
            i++;
        } // end while

        i = 0;
        while(i < loopTimes) // brackets loop
        {
            if(array[i] == "(")
            {
                trace("found open bracket"); // does not trace
                tempNum = separateBrackets(array);
                spliced = array.splice(i, 2);
                array.insert(i, tempNum);
            } // end if
            i++;
        } // end while

        i = 0;
        while(i < loopTimes)
        {
            if(array[i] == "power")
            {
                tempNum = Math.pow(array[i - 1], array[i + 1]);
                spliced = array.splice(i - 1, 3);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            if(array[i] == "square")
            {
                tempNum = Math.pow(array[i - 1], 2);
                spliced = array.splice(i - 1, 2);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            if(array[i] == "cube")
            {
                tempNum = Math.pow(array[i - 1], 3);
                spliced = array.splice(i - 1, 2);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            if(array[i] == "squareRoot")
            {
                tempNum = Math.sqrt(array[i + 1]);
                spliced = array.splice(i, 2);
                array.insert(i, tempNum);
                i = 0;
            }
            if(array[i] == "cubeRoot")
            {
                tempNum = Math.pow(array[i + 1], 1 / 3);
                spliced = array.splice(i, 2);
                array.insert(i, tempNum);
                i = 0;
            }
            if(array[i] == "EXP")
            {
                tempNum = array[i - 1] * Math.pow(10, array[i + 1]);
                spliced = array.splice(i, 2);
                array.insert(i, tempNum);
                i = 0;
            }
            if(array[i] == "xRoot")
            {
                tempNum = Math.pow(array[i + 1], 1 / array[i - 1]);
                spliced = array.splice(i - 1, 3);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            i++;
        }

        i = 0;
        while(i < loopTimes)
        {
            if(array[i] == "factorial")
            {
                tempNum = BMath.factorial(array[i - 1]);
                array.splice(i - 1, 2);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            if(array[i] == "nCr")
            {
                tempNum = BMath.nCr(array[i - 1], array[i + 1]);
                array.splice(i - 1, 3);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            if(array[i] == "nPr")
            {
                tempNum = BMath.nPr(array[i - 1], array[i + 1]);
                array.splice(i - 1, 3);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            i++;
        }

        i = 0;
        while(i < loopTimes)
        {
            if(array[i] == "log")
            {
                tempNum = BMath.log(array[i + 1], array[i - 1]);
                spliced = array.splice(i - 1, 3);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            if(array[i] == "ln")
            {
                tempNum = Math.log(array[i + 1]);
                spliced = array.splice(i, 2);
                array.insert(i, tempNum);
                i = 0;
            }
            i++;
        }

        i = 0;
        while(i < loopTimes) // trigonometry
        {
            if(array[i] == "sin")
            {
                if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
                {
                    tempNum = Math.sin(array[i + 1]);
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
                else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
                {
                    tempNum = Math.sin(array[i + 1] * Math.PI / 180);
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
            }
            if(array[i] == "cos")
            {
                if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
                {
                    tempNum = Math.cos(array[i + 1]);
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
                else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
                {
                    tempNum = Math.cos(array[i + 1] * Math.PI / 180);
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
            }
            if(array[i] == "tan")
            {
                if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
                {
                    tempNum = Math.tan(array[i + 1]);
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
                else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
                {
                    tempNum = Math.tan(array[i + 1] * Math.PI / 180);
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
            } // inverse functions

            if(array[i] == "arcsin")
            {
                if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
                {
                    tempNum = Math.asin(array[i + 1]);
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
                else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
                {
                    tempNum = Math.asin(array[i + 1]) * 180 / Math.PI;
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
            }
            if(array[i] == "arccos")
            {
                if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
                {
                    tempNum = Math.acos(array[i + 1]);
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
                else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
                {
                    tempNum = Math.acos(array[i + 1]) * 180 / Math.PI;
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
            }
            if(array[i] == "arctan")
            {
                if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
                {
                    tempNum = Math.atan(array[i + 1]);
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
                else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
                {
                    tempNum = Math.atan(array[i + 1]) * 180 / Math.PI;
                    spliced = array.splice(i, 2);
                    array.insert(i, tempNum);
                    i = 0;
                }
            }
            i++;
        }

        i = 0;
        while(i < loopTimes) // multiplication and divition loop
        {

            if(array[i] == "multiply")
            {
                tempNum = array[i - 1] * array[i + 1];
                spliced = array.splice(i - 1, 3);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            if(array[i] == "divide")
            {
                tempNum = array[i - 1] / array[i + 1];
                spliced = array.splice(i - 1, 3);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            i++;
        }

        i = 0;
        while(i < loopTimes) // addition and subtraction loop
        {
            if(array[i] == "add")
            {
                tempNum = array[i - 1] + array[i + 1];
                spliced = array.splice(i - 1, 3);
                array.insert(i - 1, tempNum);
                i = 0;
            }
            i++;
        }


        return tempNum;
    } // end function


    /**
	 * 
	 * @return
	 */
    public function calculateAnswer():Float
    {
        setArrayToCalc();

        trace("BEquation | Equation: " + _equation);

        trace("BEquation | Calculating answer...");

        if(_equation.length <= 1)
        {
            _finalResult = _arrayToCalculate[0];
        }
        else
        {
            trace("BEquation | Obtaining result...");
            _finalResult = separateBrackets(_arrayToCalculate);
        }

        var decimal:String = Std.string(_finalResult);
        if(decimal.length > 15 && decimal.indexOf(".", 0) >= 0)
        {
            _finalResult = Math.round(_finalResult * 10000000000000) / 10000000000000;
        }


        // standard notation  
        var tempResult:Float = _finalResult;
        var decimalCount:UInt = 0;

        // keep dividing result by 10 till it's less than 10
        while(tempResult > 10)
        {
            tempResult /= 10;
            decimalCount++;
        }

        _result = _finalResult;
        _standardNotationResult = tempResult;
        _standardNotationPower = decimalCount;

        // empty the equation array so that recalculating is not glitched
        //_equation = [];

        trace("BEquation | Final result: " + _finalResult);
        trace("BEquation | Standard notation result: " + _standardNotationResult);
        trace("BEquation | Standard notation power: " + _standardNotationPower);

        return _finalResult;
    } // end function


    /**
	 * Copies the values of _equation to arrayToCalculate
	 */
    private function setArrayToCalc():Void
    {
        _arrayToCalculate = [];
        for(i in 0..._equation.length)
        {
            _arrayToCalculate.push(_equation[i]);
        }
    } // end function


    //**************************************** SET AND GET ******************************************


    private function set_angularMeasureMode(value:String):String
    {
        _angularMeasureMode = value;
        return value;
    }

    private function get_angularMeasureMode():String
    {
        return _angularMeasureMode;
    }


    private function set_equation(value:Array<Dynamic>):Array<Dynamic>
    {
        _equation = value;
        return value;
    }

    private function get_equation():Array<Dynamic>
    {
        return _equation;
    }


    private function get_result():Float
    {
        return _result;
    }


    private function get_standardNotationPower():Int
    {
        return _standardNotationPower;
    }


    private function get_standardNotationResult():Float
    {
        return _standardNotationResult;
    }


    private function get_stringRepresentation():String
    {
        var string:String = "";

        for(i in 0..._equation.length)
        {
            // if i is a number
            if(Std.is(_equation[i], Float))
            {
                //if (_equation[i] == Math.PI) 
                if(_equation[i] == 3.14159265359)
                {
                    string += "π";
                }
                    //else if (_equation[i] == Math.E)
                else if(_equation[i] == 2.7182818284)
                {
                    string += "e";
                }
                else
                {
                    string += Std.string(_equation[i]);
                }
            }


            if(_equation[i] == "(")
            {string += "(";}
            if(_equation[i] == ")")
            {string += ")";}
            /*if (_equation[i] == "[")		{ string += "["; }
			if (_equation[i] == "]")		{ string += "]"; }
			if (_equation[i] == "{")		{ string += "{"; }
			if (_equation[i] == "}")		{ string += "}"; }*/


            if(_equation[i] == "power")
            {string += "^";}
            if(_equation[i] == "square")
            {string += "²";}
            if(_equation[i] == "cube")
            {string += "³";}
            if(_equation[i] == "squareRoot")
            {string += "√";}
            if(_equation[i] == "cubeRoot")
            {string += "³√";}
            if(_equation[i] == "EXP")
            {string += "EXP";}
            if(_equation[i] == "xRoot")
            {string += "";}

            if(_equation[i] == "factorial")
            {string += "!";}
            if(_equation[i] == "nCr")
            {string += "nCr";}
            if(_equation[i] == "nPr")
            {string += "nPr";}
            if(_equation[i] == "log")
            {string += "log";}
            if(_equation[i] == "ln")
            {string += "ln";}

            if(_equation[i] == "sin")
            {string += "sin";}
            if(_equation[i] == "cos")
            {string += "cos";}
            if(_equation[i] == "tan")
            {string += "tan";}
            if(_equation[i] == "arcsin")
            {string += "sin-¹";}
            if(_equation[i] == "arccos")
            {string += "cos-¹";}
            if(_equation[i] == "arctan")
            {string += "tan-¹";}

            if(_equation[i] == "multiply")
            {string += "×";}
            if(_equation[i] == "divide")
            {string += "÷";}
            if(_equation[i] == "add")
            {string += "+";}
            if(_equation[i] == "minus")
            {string += "-";}

            if(_equation[i] == "X")
            {string += "X";}
            /*if (_equation[i] == "Y")		{ string += "Y"; }
			if (_equation[i] == "k")		{ string += "k"; }
			if (_equation[i] == "m")		{ string += "m"; }
			if (_equation[i] == "c")		{ string += "c"; }*/

        } // end for

        return string;
    }


    private function set_x(value:Float):Float
    {
        _x = value;
        return value;
    }

    private function get_x():Float
    {
        return _x;
    }


    /*public function set y(value:Number):void
		{
			_y = value;
		}*/

    private function get_y():Float
    {
        setArrayToCalc();

        // where ever there is "X", insert value of _X
        for(i in 0..._arrayToCalculate.length)
        {
            if(_arrayToCalculate[i] == "X")
            {
                _arrayToCalculate.splice(i, 1);
                _arrayToCalculate.insert(i, _x);
            }
        }


        //
        _y = separateBrackets(_arrayToCalculate);

        // reset array to calculate
        setArrayToCalc();

        return _y;
    }


} // end class

