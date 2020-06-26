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
 * 
 * @author Rohaan Allport
 * @creation-date  (dd/mm/yyyy)
 */
class BListItem extends BLabelButton
{
	/**
	 * Gets or sets an Object that represents the data that is associated with a component.
	 */
    public var data(get, set):Dynamic;

    // set and get
    private var _data:Dynamic;
    
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BList component instance.
     *
     * @param	label The text label for the component.
	 * @param	data that is associated with the component.
     */
    public function new(label:String = "", data:Dynamic = null)
    {
        _data = data;
        super(null, 0, 0, label);
    }
    
    
    //************************************* FUNCTIONS ******************************************
    
    
    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();
        
        _autoSize = false;
        toggle = true;
    }  // end function initialize  
    
    
    //***************************************** SET AND GET *****************************************
   
	
    private function get_data():Dynamic
    {
        return _data;
    }
	
    private function set_data(value:Dynamic):Dynamic
    {
        _data = value;
        return value;
    }
}


