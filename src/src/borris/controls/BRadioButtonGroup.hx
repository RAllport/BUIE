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

import openfl.events.EventDispatcher;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 20/10/2014 (dd/mm/yyyy)
 */
class BRadioButtonGroup extends EventDispatcher
{
    public var name(get, never):String;
    public var numRadioButtons(get, never):Int;
    public var selection(get, set):BRadioButton;

    
    private var _name:String;
    @:allow(borris.controls)
    private var radioButtons:Array<BRadioButton>;
    private var _selection:BRadioButton;
    
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BRadioButtonGroup component instance.
     *
     * @param	name The name of the BRadioButtonGroup
     */
    public function new(name:String)
    {
        super();
        _name = name;
        radioButtons = [];
    }
    
    //**************************************** HANDLERS *********************************************
    
    
    
    
    //**************************************** FUNCTIONS ********************************************
    
    
    /**
	 * 
	 * @param	radioButton
	 */
    @:allow(borris.controls.BRadioButton)
    private function clear(radioButton:BRadioButton):Void
    {
        for (i in 0...numRadioButtons)
		{
            if (radioButtons[i] != radioButton) 
            {
                radioButtons[i].selected = false;
            }
			//trace("radio " + i + " selected: " + radioButtons[i].selected);
        }
    }  // end function clear  
    
    
    
    /**
	 * Adds a radio button to the internal radio button array for use with 
	 * radio button group indexing, which allows for the selection of a single radio button
	 * in a group of radio buttons.  This method is used automatically by radio buttons, 
	 * but can also be manually used to explicitly add a radio button to a group.
	 * 
	 * @param	radioButton The BRadioButton instance to be added to the current radio button group.
	 */
    public function addRadioButton(radioButton:BRadioButton):Void
    {
        // if the group name of the button is not the name of this array, then change its group name
        if (radioButton.group != this) 
        {
            if (radioButton.group != null) 
            {
                radioButton.group.removeRadioButton(radioButton);
            }
            radioButton.group = this;
            radioButtons.push(radioButton);
        }
        
        if (radioButton.selected) 
        {
            selection = radioButton;
        }
    }  // function addRadioButton  
    
    
    /** 
	 * Clears the RadioButton instance from the internal list of radio buttons.
	 * 
	 * @param	radioButton The BRadioButton instance to remove.
	 */
    public function removeRadioButton(radioButton:BRadioButton):Void
    {
        var i:Int = getRadioButtonIndex(radioButton);
        if (i != -1) 
        {
            radioButtons.splice(i, 1);
        }
        if (_selection == radioButton) 
        {
            _selection = null;
        }
    }  // end  
    
    
    /**
	 * Retrieves the BRadioButton component at the specified index location.
	 * 
	 * @param	index The index of the BRadioButton component in the BRadioButtonGroup component, where the index of the first component is 0.
	 * 
	 * @return The specified BRadioButton component.
	 */
    public function getRadioButtonAt(index:Int):BRadioButton
    {
        return cast((radioButtons[index]), BRadioButton);
    }  // end  
    
    
    /**
	 * Returns the index of the specified BRadioButton instance.
	 * 
	 * @param	radioButton The BRadioButton instance to locate in the current BRadioButtonGroup.
	 * 
	 * @return The index of the specified BRadioButton component, or -1 if the specified BRadioButton was not found.
	 */
    public function getRadioButtonIndex(radioButton:BRadioButton):Int
    {
        return Lambda.indexOf(radioButtons, radioButton);
    }  // end  
    
    
    
    //**************************************** SET AND GET ******************************************
    
    
    /**
	 * Gets the instance name of the radio button.
	 */
    private function get_name():String
    {
        return _name;
    }
    
    
    /**
	 * Gets the number of radio buttons in this radio button group.
	 */
    private function get_numRadioButtons():Int
    {
        return radioButtons.length;
    }
    
    
    /**
	 * Gets or sets a reference to the radio button that is currently selected from the radio button group.
	 */
    private function get_selection():BRadioButton
    {
        return _selection;
    }
    
    private function set_selection(value:BRadioButton):BRadioButton
    {
        
        _selection = value;
        if (value.selected) 
        {
            clear(value);
        }
        value.selected = true;
        return value;
    }
}

