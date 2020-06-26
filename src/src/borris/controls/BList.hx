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

import borris.containers.BBaseScrollPane;

import motion.Actuate;

import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import openfl.events.MouseEvent;


/**
 * 
 * @author Rohaan Allport
 * @creation-date  (dd/mm/yyyy)
 */
class BList extends BBaseScrollPane
{
	// TODO implement this
    /**
	 * Gets a Boolean value that indicates whether more than one list item can be selected at a time. 
	 * A value of true indicates that multiple selections can be made at one time; 
	 * a value of false indicates that only one item can be selected at one time.
	 * 
	 * @default false
	 */
	public var allowMultipleSelection(get, set):Bool;
    
	/**
	 * Gets or sets the items in the list.
	 * Each item must have a label and data property.
	 */
	public var items(get, set):Array<Dynamic>;
	
	/**
	 * Gets the number of items in the list.
	 */
	public var length(get, never):Int;
    
	/**
	 * Gets the number of rows that are at least partially visible in the list.
	 * 
	 * <p><strong>Note:</strong> This property must be overridden in any class that extends SelectableList.</p>
	 * 
	 * @default 0
	 */
	public var rowCount(get, never):Int;
    
	/**
	 * 
	 */
	public var rowHeight(get, set):Int;
    
	/**
	 * Gets or sets a Boolean value that indicates whether the items in the list can be selected. 
	 * A value of true indicates that the list items can be selected; 
	 * a value of false indicates that they cannot be.
	 * 
	 * @default true
	 */
	public var selectable(get, set):Bool;
    
	/**
	 * Gets or sets the index of the item that is selected in a single-selection list. 
	 * A single-selection list is a list in which only one item can be selected at a time.
	 * 
	 * <p>A value of -1 indicates that no item is selected; if multiple selections are made, 
	 * this value is equal to the index of the item that was selected last in the group of selected items.</p>
	 * 
	 * <p>When ActionScript is used to set this property, the item at the specified index replaces the current selection. 
	 * When the selection is changed programmatically, a change event object is not dispatched.</p>
	 */
	public var selectedIndex(get, set):Int;
    
	/**
	 * Gets or sets an array that contains the items that were selected from a multiple-selection list.
	 * 
	 * <p>To replace the current selection programmatically, you can make an explicit assignment to this property. 
	 * You can clear the current selection by setting this property to an empty array or to a value of undefined. 
	 * If no items are selected from the list of items, this property is undefined.</p>
	 * 
	 * <p>The sequence of values in the array reflects the order in which the items were selected from the multiple-selection list. 
	 * For example, if you click the second item from the list, then the third item, and finally the first item, 
	 * this property contains an array of values in the following sequence: [1,2,0].</p>
	 */
	public var selectedIndices(get, set):Array<Int>;
    
	/**
	 * Gets or sets the item that was selected from a single-selection list. 
	 * For a multiple-selection list in which multiple items are selected, 
	 * this property contains the item that was selected last.
	 * 
	 * <p>If no selection is made, the value of this property is null.</p>
	 */
	public var selectedItem(get, set):Dynamic;
    
	/**
	 * Gets or sets an array that contains the objects for the items that were selected from the multiple-selection list.
	 * 
	 * <p>For a single-selection list, the value of this property is an array containing the one selected item. 
	 * In a single-selection list, the allowMultipleSelection property is set to false.</p>
	 */
	public var selectedItems(get, set):Array<Dynamic>;
    
	/**
	 * Gets or sets whether to automatically adjust the height of the list depending on the 'number of rows to show' and the 
	 */
	public var autoSize(get, set):Bool;
    
	/**
	 * 
	 */
	public var numRowsToShow(get, set):Int;
	
	/**
	 * Gets or sets the items in the list.
	 * Setting will replace all existing items.
	 */
	// TODO implement this
	//public var items(get, set):Array<Dynamic>;
	
    
	// assets
    public var itemClass:Class<BListItem> = BListItem;
    
    
    // style
    private var _rowHeight:Int = 30;
    
    
    // other
	// TODO make currentValue read-only
	private var _currentValue:Dynamic;  //  
    private var _items:Array<Dynamic> = [];  					//  
    private var _tempHeight:Float = 0;  						// A temporary value to hold the height of the list while it is in autoSize state  
    
    
    // set and get
    private var _allowMultipleSelection:Bool;  							// Gets a Boolean value that indicates whether more than one list item can be selected at a time.  
    //protected var _dataProvider:DataProvider;							// Gets or sets the data model of the list of items to be viewed.
    private var _length:Int;  											// [read-only] Gets the number of items in the data provider.  
    //protected var _maxHorizontalScrollPosition:Number;				//
    private var _rowCount:Int = 0;  									// [read-only] Gets the number of rows that are at least partially visible in the list.  
    private var _selectable:Bool;  										// Gets or sets a Boolean value that indicates whether the items in the list can be selected.  
    private var _selectedIndex:Int = -1;  								// Gets or sets the index of the item that is selected in a single-selection list.  
    private var _selectedIndices:Array<Int> = []; 						// Gets or sets an array that contains the items that were selected from a multiple-selection list.  
    private var _selectedItem:Dynamic;  // Gets or sets the item that was selected from a single-selection list.  
    //private var _selectedItem:Dynamic = {Label: "fuck", data: "off!"};  // Gets or sets the item that was selected from a single-selection list.  
    private var _selectedItems:Array<Dynamic> = [];  					// Gets or sets an array that contains the objects for the items that were selected from the multiple-selection list.  
    
    private var _autoSize:Bool = true;  								// Automatically adjust the height of the list depending on the 'number of rows to show' and the  
    private var _numRowsToShow:Int = 5;  								// if auto size, automatically adjust the height of the list to fit the number of rows to show  
    
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BList component instance.
     *
     * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param x The x position to place this component.
     * @param y The y position to place this component.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        super(parent, x, y);
        setSize(200, 200);
    }
    
    
    /**
	 * Called when the user clicks a list item
	 * Sets the clicked item to selected
	 */
    private function mouseClickHandler(event:MouseEvent):Void
    {
		// method 1
        var listItem:BListItem;
        
        for (i in 0..._items.length)
		{
            listItem = cast(_container.getChildAt(i), BListItem);
            listItem.selected = false;
        }
        
        listItem = cast((event.currentTarget), BListItem);
        listItem.selected = true;
        _currentValue = listItem.data;
		_selectedIndex = _container.getChildIndex(listItem);
        _selectedItem = _items[_selectedIndex];
		
		
		// method 2
		//selectedItem = cast(_container.getChildAt(i), BListItem);
		
		dispatchEvent(new Event(Event.CHANGE));
		
    }  // end function houseClickGandler  
    
    
    /**
	 * 
	 * @param event
	 */
    override private function scrollBarChangeHandler(event:Event):Void
    {
        // need to fix this shit
        
        // a methout for round to a multiply of a number
        var pow:Float = Math.pow(10, 6);
        var snap:Float = _numRowsToShow * pow;
        var rounded:Float = Math.round((_vScrollBar.scrollPosition * (_containerMask.height - _container.height)) * pow);
        var snapped:Float = Math.round(rounded / snap) * snap;
        var val:Float = snapped / pow;
        //var moveToValue:int = Math.min(  _rowHeight, val);
        //trace(moveToValue);
        
        //_container.y = _vScrollBar.scrollPosition * (_containerMask.height - _container.height);
        Actuate.tween(_container, 0.3, { y: val} );
        
        // set the scroll position to a more accurate position
        _vScrollBar.scrollPosition = val / (_containerMask.height - _container.height);
    }  // end function scrollBarChangeHandler  
    
    
    
    //************************************* FUNCTIONS ******************************************
    
    
    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        _contendPadding = 0;
        super.initialize();
        
        // initialize assets
        _hScrollBar.visible = false;
        
        _tempHeight = _height;
		
    }  // end function initialize  
    
    
    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        super.draw();
		
        var listItem:BListItem;
        
        //
        if (_autoSize) 
        {
            // set the height of the list to. If the height of all the items is less than
            _height = _numRowsToShow * _rowHeight;
            if (_items.length * _rowHeight > _height) 
            {
                _height = _items.length * _rowHeight;
            }  //  
            
            //_vScrollBar.height = _numRowsToShow * _rowHeight;
            //_vScrollBar.visible = (_items.length > _numRowsToShow);
            _hScrollBar.visible = false;
			// BUG No matter what happens, the _vScrollBar will forever remain visible
			//_vScrollBar.visible = false; 
            if (_vScrollBar.parent != null) _vScrollBar.parent.removeChild(_vScrollBar);
			
            //
            //_vScrollBar.lineScrollSize = 1 / (_items.length - _numRowsToShow);
            
            //
            //_containerMask.height = _numRowsToShow * _rowHeight;
            _containerMask.height = _height;
        }
        // end if auto size
        else 
        {
            if (_tempHeight != 0) 
            {
                _height = _tempHeight;
            }  // set row count to the number of rows that are at least partially visible in the list.  
            
            
            
            _rowCount = Math.ceil(_height / _rowHeight);
            //
            ////_vScrollBar.height = _rowCount * _rowHeight;
            _vScrollBar.visible = (_items.length > _rowCount);
            _hScrollBar.visible = false;
			addChild(_vScrollBar);
            
            //
            _vScrollBar.lineScrollSize = 1 / (_items.length - _rowCount);
        } // end else
        
        // set the item positions and sizes  
        for (i in 0..._items.length)
		{
            listItem = try cast(_container.getChildAt(i), BListItem) catch(e:Dynamic) null;
            listItem.x = 0;
            listItem.y = i * _rowHeight;
            listItem.width = _width;
            listItem.height = _rowHeight;
        } // end for
		
    }  // end function draw  
    
    
    /**
	 * Appends an item to the end of the list of items.
	 * 
	 * <p>An item should contain label and data properties; however, items that contain 
	 * other properties can also be added to the list. By default, the label property 
	 * of an item is used to display the label of the row; the data property is used to 
	 * store the data of the row.</p>
	 * 
	 * @param item The item to be added to the list.
	 *
	 * @return The item that was added.
	 */
    public function addItem(item:Dynamic):Dynamic
    {
		return addItemAt(item, _items.length);
    } // end function
    
    
    /**
	 * Inserts an item into the list at the specified index location. 
	 * The indices of items at or after the specified index location are incremented by 1.
	 * 
	 * @param item The item to be added to the list.
	 * @param index The index at which to add the item.
	 *
	 * @return The item that was added.
	 */
    public function addItemAt(item:Dynamic, index:Int):Dynamic
    {
        _items.insert(index, item);
        
        var listItem:BListItem = Type.createInstance(itemClass, []);
        listItem.y = index * _rowHeight;
        _container.addChildAt(listItem, index);
        listItem.label = item.label == "" ? "Item " + _items.length : item.label;
        listItem.data = item.data;
        
		// NOTE: this is very importants since it changed the index of the listItmes
		listItem.focusEnabled = false; 
		
		if (_items.length == 1)
		{
			_selectedItem = item;
			_selectedIndex = 0;
		} // end 
		
        listItem.addEventListener(MouseEvent.CLICK, mouseClickHandler);
        
        draw();

        return item;
    } // end function
    
    
    /**
	 * Retrieves the item at the specified index.
	 * 
	 * @param index The index of the item to be retrieved.
	 * 
	 * @return The object at the specified index location.
	 */
    public function getItemAt(index:Int):Dynamic
    {
        return _items[index];
    } // end function
    
    
    /**
	 * Removes all items from the list.
	 */
    public function removeAll():Void
    {
		for (i in 0..._container.numChildren)
		{
			_container.getChildAt(i).removeEventListener(MouseEvent.CLICK, mouseClickHandler);
		} // end 
		
        _items = [];
        _container.removeChildren();
		clearSelection();
    } // end function
    
    
    /**
	 * Removes the specified item from the list.
	 * 
	 * @param item The item to be removed.
	 * 
	 * @return The item that was removed.
	 */
    public function removeItem(item:Dynamic):Dynamic
    {
        /*_container.removeChildAt(_items.indexOf(item));
        //_items.splice(_items.indexOf(item), 1);
        _items.remove(item);
        draw();
        return item;*/

		return removeItemAt(_items.indexOf(item));
    } // end function
    
    
    /**
	 * Removes the item at the specified index position. 
	 * The indices of items after the specified index location are decremented by 1.
	 * 
	 * @param index The index of the item in the data provider to be removed.
	 * 
	 * @return The item that was removed.
	 */
    public function removeItemAt(index:Int):Dynamic
    {
		var item:Dynamic = _items[index];
		
		if (_selectedItem == item)
		{
			if (_selectedIndex == 0)
			{
				_selectedIndex = 0;
				_selectedItem = _items[1];
			}
			else
			{
				_selectedIndex = _items.indexOf(item) - 1;
				_selectedItem = _items[_selectedIndex];
			}
			
		} // end if
		
		_container.getChildAt(index).removeEventListener(MouseEvent.CLICK, mouseClickHandler);
        _container.removeChildAt(index);
        _items.splice(index, 1);
        draw();
        
        return item;
    } // end function
    
    
    /**
	 * Replaces the item at the specified index location with another item. 
	 * This method modifies the data provider of the List component. 
	 * If the data provider is shared with other components, 
	 * the data that is provided to those components is also updated.
	 * 
	 * @param item The item to replace the item at the specified index location.
	 * @param index The index position of the item to be replaced.
	 * 
	 * @return The item that was replaced.
	 */
    public function replaceItemAt(item:Dynamic, index:Int):Dynamic
    {
        removeItemAt(index);
        addItemAt(item, index);
        
        return item;
    } // end function
    
    
    // function scrollToIndex
    //
    /*public function scrollToIndex(index:int):void
		{
			
		} // end function scrollToIndex
		
		
		// function scrollToSelected
		// 
		public function scrollToSelected():void
		{
			
		} // end function scrollToSelected
		
		
		// function sortItems
		// 
		public function sortItems(... sortArgs):*
		{
			
		} // end function sortItems
		
		
		// function clearSelcetion
		// 
		public function clearSelcetion():void
		{
			
		} // end function clearSelcetion
		
		
		// function isItemSelected
		// 
		public function isItemSelected(item:Object):Boolean
		{
			
		} // end function isItemSelected*/
    
	
	/**
	 * Clears the currently selected item in the list and sets the selectedIndex property to -1.
	 */
	public function clearSelection():Void
	{
		_selectedIndex = -1;
		_selectedIndices = [];
		_selectedItem = null;
		_selectedItems = [];
		
		for (i in 0..._container.numChildren)
		{
			cast(_container.getChildAt(i), BListItem).selected = false;
		}// end for
	} // end function 


    // TODO impliment this
	/*public function contains(item:Dynamic):Bool
	{
		if (_items.indexOf(item) >= 0)
		{
			return true;
		} // end if
		
		return false;
		
	} // end function 
	*/
	
	
	/**
	 * 
	 * @param	index
	 */
	// TODO impliment this
	/*public function scrollToIndex(index:Int):Void
	{
		
	} // end function*/
	
	
	/**
	 * 
	 */
	// TODO impliment this
	/*public function scrollToSelected():Void
	{
		
	} // end function*/
	
	/**
	 * Validates the selected values to make sure they do not go out of bounds, and are match up.
	 */
	// TODO implement this
	/*private function validateSelection():Void
	{
		
	} // end function
	*/
	
    
    //***************************************** SET AND GET *****************************************
    
	
    private function get_allowMultipleSelection():Bool
    {
        return _allowMultipleSelection;
    }
    private function set_allowMultipleSelection(value:Bool):Bool
    {
        _allowMultipleSelection = value;
        return value;
    }
    
    
	private function get_items():Array<Dynamic>
	{
		return _items;
	}
	
	private function set_items(value:Array<Dynamic>):Array<Dynamic>
	{
		// _items does not have to be set or cleared because removeAll() already clears it, and 
		// addItem pupulates it.
		
		removeAll();
		
		for (item in value)
		{
			addItem(item);
		} // end for 
		
		return _items;
	}
	
	
    private function get_length():Int
    {
        return _items.length;
    }
    
    
    private function get_rowCount():Int
    {
        //return Math.ceil(_height / _rowHeight);
        return _rowCount;
    }
    
    
    private function get_rowHeight():Int
    {
        return _rowHeight;
    }
    private function set_rowHeight(value:Int):Int
    {
        _rowHeight = value;
        draw();
        return value;
    }
    
    
    private function get_selectable():Bool
    {
        return _selectable;
    }
    private function set_selectable(value:Bool):Bool
    {
        _selectable = value;
        
        for (i in 0..._container.numChildren){
            cast((_container.getChildAt(i)), BUIComponent).enabled = value;
        }
        return value;
    }
    
    
    private function get_selectedIndex():Int
    {
        return _selectedIndex;
    }
    private function set_selectedIndex(value:Int):Int
    {
        _selectedIndex = value;
        _selectedIndices = [];
        _selectedIndices.push(value);
		_selectedItem = _items[value]; 
		_selectedItems = [];
		_selectedItems.push(_selectedItem);
        
        for (i in 0..._container.numChildren)
		{
            cast((_container.getChildAt(value)), BListItem).selected = false;
        }
        cast((_container.getChildAt(value)), BListItem).selected = true;
		
        return value;
    }
    
    
    private function get_selectedIndices():Array<Int>
    {
        return _selectedIndices;
    }
    private function set_selectedIndices(value:Array<Int>):Array<Int>
    {
        if (_allowMultipleSelection) 
        {
			// TODO complete this
			//_selectedIndex = ;
            _selectedIndices = value;
            //_selectedItem = ;
			_selectedItems = [];
			
            for (i in 0..._container.numChildren)
			{
                cast((_container.getChildAt(i)), BListItem).selected = false;
            }  // end for  
			
			for (i in 0..._selectedIndices.length)
			{
				cast((_container.getChildAt(_selectedIndices[i])), BListItem).selected = true;
				_selectedItems.push(_items[_selectedIndices[i]]);
			}  // end for  
			
        }
        /*else 
        {
            throw new Error("Multiple selection is not allowed. Set the allowMultipleSelection property to true.");
        }*/
        return value;
    }
    
    
    private function get_selectedItem():Dynamic
    {
        return _selectedItem;
    }
    private function set_selectedItem(value:Dynamic):Dynamic
    {
        _selectedItem = value;
        _selectedItems = [];
		_selectedItems.push(value);
        _selectedIndex = _items.indexOf(value);
        _selectedIndices = [];
        _selectedIndices.push(_selectedIndex);
        
		for (i in 0..._container.numChildren)
		{
            cast((_container.getChildAt(i)), BListItem).selected = false;
        }
        
		cast(_container.getChildAt(_selectedIndex), BListItem).selected = true;
        
        return value;
    }
    
    
    private function get_selectedItems():Array<Dynamic>
    {
        return _selectedItems;
    }
    private function set_selectedItems(value:Array<Dynamic>):Array<Dynamic>
    {
		if (_allowMultipleSelection)
		{
			// TODO complete this
			//_selectedIndex = ;
            _selectedIndices = [];
            //_selectedItem = ;
			_selectedItems = value;
			
            for (i in 0..._container.numChildren)
			{
                cast((_container.getChildAt(i)), BListItem).selected = false;
            }  // end for  
			
			for (i in 0..._selectedItems.length)
			{
				cast((_container.getChildAt(_selectedItems[i])), BListItem).selected = true;
				_selectedIndices.push(_items.indexOf(_selectedItems[i]));
			}  // end for  
			
			
		} // end if
		
        return value;
    }
    
    
    private function get_autoSize():Bool
    {
        return _autoSize;
    }
    private function set_autoSize(value:Bool):Bool
    {
        _autoSize = value;
        if (value) 
        {
            _tempHeight = _height;
        }
        draw();
        return value;
    }
    
    
    private function get_numRowsToShow():Int
    {
        return _numRowsToShow;
    }
    private function set_numRowsToShow(value:Int):Int
    {
        _numRowsToShow = value;
        draw();
        return value;
    }
    
    
	
	
    // OVRRIDES
    
    #if flash
	@:setter(height)
	override private function set_height(value:Float):Void
    {
        super.height = value;
        _tempHeight = value;
    }
	#else
    override private function set_height(value:Float):Float
    {
        super.height = value;
        _tempHeight = value;
        return value;
    }
	#end
}

