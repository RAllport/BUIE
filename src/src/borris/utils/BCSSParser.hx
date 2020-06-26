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

package borris.utils;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 05/03/2018 (dd/mm/yyyy)
 */
import Array;
class BCSSParser
{
    /*
    - identifiers: none = element, # = id, . = class
    - comma means grouped, no comma means nested
    - crurler brackets means styles block
    - semi colon means end style
    - colon means value;
     */

    /*
    Pseudocode:
    - remove all comments and invalid code
    - make sense of CSS string
        - collect all elements, ids, and classes (selectors)
        - collect all styles
            - check for important!
    - loop through all BElements
        - get the classes amd ids
        - set all values to BStyles

     */

    private static var _css:String = "
    bButton {
        width: 96px;
        height: 32px;
        border-radius: 2px;
        color: #ffffff;
        background-color: #00CCFF;
    }

    .test {

    }

    #id-test {

    }

    ";
    //private static var _selectors:Array<Dynamic> = [];
    private static var _selectors:Array<String> = [];
    private static var _styleBlocks:Array<Dynamic> = [];


    public static function parseCSS(css:String = null):Void
    {
        css = _css;

        // TODO remove all comments and invalid code


        // collect all elements, ids, and classes (selectors)
        var currentOpenCurlyBraceIndex:Int = 0;
        var previousOpenCurlyBraceIndex:Int = 0;
        var currentCloseCurlyBraceIndex:Int = 0;
        var previousCloseCurlyBraceIndex:Int = 0;


        _selectors.push(css.substring(0, css.indexOf("{", 0)));
        _selectors.push(css.substring(css.indexOf("}", 0) + 1, css.indexOf("{", css.indexOf("}", 0) + 1)));

        // while not at end
        /*while(select)
        {
            css.substring(css.indexOf("", 0), css.indexOf("{", 0));
        } // end for*/

        trace("Selectors: \n");
        for(selector in _selectors)
        {
            trace(selector + "\n");
        } // end for
    } // end function

} // end class
