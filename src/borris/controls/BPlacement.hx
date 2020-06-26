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


/**
 * The BPlacement enum defines constants for the values of the placement related properties of BUIComponents such as: 
 * <ul>
 * 	<li>BLabelButton.iconPlacement (and BLabelButton sub classes)</li>
 * 	<li>BLabelButton.labelPlacement (and BLabelButton sub classes)</li>
 * 	<li>BComboBox.listPlacement</li>
 * 	<li>BNumericStepper.buttonPlacement</li>
 * 	<li>BSlider.labelPlacement</li>
 * 	<li>BRangeSlider.labelPlacement</li>
 * </ul>
 * 
 * BLabelButton sub classes include:
 * <ul>
 * 	</i>BButton</li>
 * 	</i>BCheckBox</li>
 * 	</i>BRadioButton</li>
 * 	</i>BIconRadioButton</li>
 * </ul>
 * 
 * @author Rohaan Allport
 * @creation-date 11/11/2015 (dd/mm/yyyy)
 */
@:enum 
abstract BPlacement(String)
{
    /**
	 * The object appears to the left.
	 */
    var LEFT = "left";
    
    /**
	 * The object appears to the right.
	 */
    var RIGHT = "right";
    
    /**
	 * The object appears at the top.
	 */
    var TOP = "top";
    
    /**
	 * The object appears at the bottom.
	 */
    var BOTTOM = "bottom";
    
    /**
	 * The object appears at the center.
	 */
    var CENTER = "center";
    
    /**
	 * The object appears at the top left.
	 */
    var TOP_LEFT = "topLeft";
    
    /**
	 * The object appears at the bottom left.
	 */
    var BOTTOM_LEFT = "bottomLeft";
    
    /**
	 * The object appears at the top right.
	 */
    var TOP_RIGHT = "topRight";
    
    /**
	 * The object appears at the bottom right.
	 */
    var BOTTOM_RIGHT = "bottomRight";
	
	/**
	 * The objects are alinged in a horizontal fashion.
	 */
    var HORIZONTAL = "horizontal";
	
	/**
	 * The objects are alinged in a vertical fashion.
	 */
    var VERTICAL = "vertical";

	
}

