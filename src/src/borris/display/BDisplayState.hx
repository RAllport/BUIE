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


/**
 * The BDisplayState enum defines constants for "display state" related properties of BUIComponents such as:
 * <ul>
 * 	<li>BPanel.displayState</li>
 * 	<li>BNativeWindow.displayState</li>
 * </ul>
 * 
 * @author Rohaan Allport
 * @creation-date 10/10/2014 (dd/mm/yyyy)
 */
@:enum
abstract BDisplayState(String)
{
    /**
	 * The container is attached to another one.
	 */
    var ATTACHED = "attached";

    /**
	 * 
	 */
    //var DETACHED = "detached";

    /**
	 * The Body of the container is is collapsed.
	 */
    var COLLAPSED = "collapsed";

    /**
	 * Takes up the full width and height of the parent component.
	 */
    var MAXIMIZED = "maximized";

    /**
	 * The container is collapsed to just its icon.
	 */
    var MINIMIZED = "minimized";

    /**
	 * The container acts like a native OS window.
	 */
    var WINDOWED = "windowed";

} // end class


