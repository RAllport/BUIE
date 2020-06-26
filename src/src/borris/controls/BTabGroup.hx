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

import borris.display.BTitleBarMode;

import haxe.ds.ArraySort;

import motion.Actuate;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 18/01/2016 (dd/mm/yyyy)
 */
class BTabGroup extends EventDispatcher
{
    /**
	 * Gets or sets whether the tabs can be dragged and re-ordered physically with a mouse.
	 */
    public var draggable(get, set):Bool;

    /**
	 * Gets the instance name of the tab.
	 */
    public var name(get, never):String;

    /**
	 * Gets the number of tabs in this tab group.
	 */
    public var numTabs(get, never):Int;

    /**
	 * Gets or sets the DisplayObjectContainer in which the tabs and their content should be contained.
	 */
    public var parent(get, set):DisplayObjectContainer;

    /**
	 * Gets or sets a reference to the tab that is currently selected from the tab group.
	 */
    public var selection(get, set):BTab;

    /**
	 * 
	 */
    public var separatorWidth(get, set):Int;

    /**
	 * 
	 */
    public var tabMode(get, set):BTitleBarMode;

    /**
	 * 
	 */
    public var tabs(get, never):Array<BTab>;


    // assets
    @:allow(borris.controls.BTab)
    private var _container:Sprite;
    private var _mask:DisplayObject;


    // style
    private var _separatorColor:Int = 0xCCCCCC;
    private var _separatorWidth:Int = 1;
    private var _separatorTransparancy:Float = 1;

    //other
    private var _iconFlag:Bool = false;

    // set and get
    @:allow(borris.controls.BTab)
    private var _tabs:Array<BTab>;
    private var _name:String;
    private var _selection:BTab;
    private var _draggable:Bool = false;
    private var _tabHeight:Float = 30;
    private var _tabMode:BTitleBarMode = BTitleBarMode.FULL_ICON;


    /**
     * Creates a new BTabGroup component instance.
     *
     * @param	name The name of the BTabGroup
     */
    public function new(name:String)
    {
        super();
        _container = new Sprite();

        _name = name;
        _tabs = [];

        tabMode = _tabMode;
    }


    //**************************************** HANDLERS *********************************************

    /**
	 * 
	 * @param	event
	 */
    private function mouseClickHandler(event:MouseEvent):Void
    {
        switchTab(cast(event.currentTarget, BTab));
    } // end function


    /**
	 * 
	 * @param	event
	 */
    public function dragTab(event:MouseEvent = null):Void
    {
        var tab:BTab = cast(event.currentTarget, BTab);

        // bring this tab to the top of the display list
        _container.setChildIndex(tab, _container.numChildren - 1);

        ArraySort.sort(_tabs, function(a, b):Int
        {
            if(a.x > b.x)
                return 1;
            else if(a.x < b.x)
                return -1
            else
                return 0;
        });

        //
        tab.startDrag(false, new Rectangle(0, tab.y, _container.width - tab.width, 0));
    } // end function


    /**
	 * 
	 * @param	event
	 */
    public function dropTab(event:MouseEvent = null):Void
    {
        var tab:BTab = cast(event.currentTarget, BTab);

        tab.stopDrag();

        ArraySort.sort(_tabs, function(a, b):Int
        {
            if(a.x > b.x)
                return 1;
            else if(a.x < b.x)
                return -1
            else
                return 0;
        });

        _tabs[0].x = 0;

        for(i in 0..._tabs.length)
        {
            if(i > 0)
            {
                _tabs[i].x = _tabs[i - 1].x + _tabs[i - 1].width;
            }
        }
    } // end function


    //**************************************** FUNCTIONS ********************************************


    /**
	 * 
	 * @param	tab
	 */
    @:allow(borris.controls.BTab)
    private function clear(tab:BTab):Void
    {
        // TODO rethink this
        for(i in 0..._tabs.length)
        {
            if(_tabs[i] != tab)
            {
                _tabs[i].selected = false;
            }
            //_tabs[i].selected = false;
        }
        //_tabs.remove(tab);
    } // end function


    /**
	 * Updates the position of the tabs
	 */
    @:allow(borris.controls.BTab)
    private function update():Void
    {
        //
        if(parent != null)
        {
            setContentSize(Math.round(parent.width), Math.round(parent.height));
        } // end if  

        var tab:BTab = null;
        var prevTab:BTab = null;

        for(i in 0..._tabs.length)
        {
            tab = _tabs[i];
            tab.x = 0;
            tab.y = 0;
            tab.height = _tabHeight;
            tab.width = if(_iconFlag) _tabHeight
            else tab.width;
            tab.content.content.y = _tabHeight + _separatorWidth;

            if(i > 0)
            {
                prevTab = _tabs[i - 1];
                tab.x = prevTab.x + prevTab.width;
                tab.x = prevTab.x + prevTab.width;
            }
        } // end for


        // TODO make container a BUIComponent and use it's style object
        _container.graphics.clear();
        _container.graphics.beginFill(_separatorColor, _separatorTransparancy);
        // TODO find another way to draw the tab separater
        _container.graphics.drawRect(0, _tabHeight - 1, tab.content.width, _separatorWidth);
        _container.graphics.endFill();
    } // end function


    /**
	 * Adds a tab at the bottom of the group.
	 * Adds a tab to the internal tab array for use with 
	 * tab group indexing, which allows for the selection of a single tab
	 * in a group of tabs. This method is used automatically by tabs, 
	 * but can also be manually used to explicitly add a tab to a group.
	 * 
	 * @param	tab The BTab instance to be added to the current tab group.
	 */
    // TODO use addTabAt()
    public function addTab(tab:BTab):Void
    {
        // if the group name of the button is not the name of this array, then change its group name
        if(tab.group != this)
        {
            if(tab.group != null)
            {
                tab.group.removeTab(tab);
            }
            tab.group = this;
            _tabs.push(tab);
        }

        if(_tabs.length == 1)
        {
            _selection = tab;
        }
        if(tab.selected)
        {
            selection = tab;
        }

        _container.addChild(tab);
        update();

        tab.addEventListener(MouseEvent.CLICK, mouseClickHandler);
        draggable = _draggable;
    } // function


    /**
	 * Inserts a tab at the specified position.
	 * 
	 * @param	tab The BTab instance to be added to the current tab group.
	 * @param	index The (zero-based) position in the group at which to insert the tab.
	 */
    public function addTabAt(tab:BTab, index:Int):Void
    {
        // if the group name of the button is not the name of this array, then change its group name
        if(tab.group != this)
        {
            if(tab.group != null)
            {
                tab.group.removeTab(tab);
            }
            tab.group = this;
            _tabs.insert(index, tab);
        }

        if(tab.selected)
        {
            selection = tab;
        }

        _container.addChildAt(tab, index);
        update();

        tab.addEventListener(MouseEvent.CLICK, mouseClickHandler);
        draggable = _draggable;
    } // end function


    /** 
	 * Clears the Tab instance from the internal list of tabs.
	 * 
	 * @param	tab The BTab instance to remove.
	 *
	 * @return  The BTab object removed.
	 */
    public function removeTab(tab:BTab):BTab
    {
        // remove the event listeners from the tab
        tab.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
        tab.removeEventListener(MouseEvent.MOUSE_DOWN, dragTab);
        tab.removeEventListener(MouseEvent.MOUSE_UP, dropTab);
        tab.removeEventListener(MouseEvent.ROLL_OUT, dropTab);


        // create a temporary tab
        var tempTab:BTab = null;

        // make sure the tab is not the left most tab.
        // find the tab to the left. If none, find the tab to the right
        if(Lambda.indexOf(_tabs, tab) > 0)
        {
            var leftTab:BTab = _tabs[Lambda.indexOf(_tabs, tab) - 1];
            tempTab = leftTab;
        }
        else
        {
            var rightTab:BTab = _tabs[Lambda.indexOf(_tabs, tab) + 1];
            tempTab = rightTab;
        }
        /*else
		{
			// if no tabs -__-"
		}*/

        _container.removeChild(tab);
        _container.removeChild(tab.content.content.parent);

        switchTab(tempTab);

        _tabs.splice(Lambda.indexOf(_tabs, tab), 1);

        for(i in 0..._tabs.length)
        {
            _tabs[0].x = 0;
            if(i > 0)
            {
                _tabs[i].x = _tabs[i - 1].x + _tabs[i - 1].width;
            }
        }
        return tab;
    } // end function


    /**
	 * Removes and returns the tab at the specified index.
	 * 
	 * @param	index The (zero-based) position of the tab to remove.
	 * 
	 * @return The BTab object removed.
	 */
    public function removeTabAt(index:Int):BTab
    {
        // TODO complete removeTabAt()
        return null;
    } // end function


    /**
	 * Retrieves the BTab component at the specified index location.
	 * 
	 * @param	index The index of the BTab component in the BTabGroup component, where the index of the first component is 0.
	 * 
	 * @return The specified BTab component.
	 */
    public function getTabAt(index:Int):BTab
    {
        return _tabs[index];
    } // end function


    /**
	 * Returns the index of the specified BTab instance.
	 * 
	 * @param	tab The BTab instance to locate in the current BTabGroup.
	 * 
	 * @return The index of the specified BTab component, or -1 if the specified BTab was not found.
	 */
    public function getTabIndex(tab:BTab):Int
    {
        return Lambda.indexOf(_tabs, tab);
    } // end function


    /**
	 * 
	 * 
	 * @param	tab
	 */
    public function switchTab(tab:BTab):Void
    {
        if(_selection == tab)
        {
            return;
        }

        for(tab in tabs)
        {
            cast(tab, BTab).content.content.parent.visible = false;
        }
        _selection.content.content.parent.visible = true;
        tab.content.content.parent.visible = true;

        var prevIndex:Int = Lambda.indexOf(_tabs, _selection);
        var newIndex:Int = Lambda.indexOf(_tabs, tab);
        var difference:Int = prevIndex - newIndex;

        // TODO fix initial position of tab content before tweening
        if(difference > 0)
        {
            Actuate.tween(tab.content.content.parent, 0.3, {alpha: 1, x: 0});
            Actuate.tween(_selection.content.content.parent, 0.3, {alpha: 0, x: 500});// .onComplete(function(){ _selection.content.content.parent.visible = false; });
        }
        else
        {
            Actuate.tween(tab.content.content.parent, 0.3, {alpha: 1, x: 0});
            Actuate.tween(_selection.content.content.parent, 0.3, {alpha: 0, x: -500});//.onComplete(function(){ _selection.content.content.parent.visible = false; });
        }

        // set all tabs to not selected  
        for(i in 0..._tabs.length)
        {
            _tabs[i].selected = false;
        } // end for  

        tab.selected = true;
        _selection = tab;
        _container.setChildIndex(tab, _container.numChildren - 1);
    } // end function


    /**
	 * 
	 */
    // TODO rethink this
    public function disableAll():Void
    {
        var i:Int = _tabs.length - 1;
        while(i >= 0)
        {
            _tabs[i].tabChildren = _tabs[i].tabEnabled = _tabs[i].mouseChildren = _tabs[i].mouseEnabled = false;
            _tabs[i].alpha = 0.5;
            i--;
        } // end for
    } // end function


    /**
	 * 
	 */
    // TODO rethink this
    public function enableAll():Void
    {
        var i:Int = _tabs.length - 1;
        while(i >= 0)
        {
            _tabs[i].tabChildren = _tabs[i].tabEnabled = _tabs[i].mouseChildren = _tabs[i].mouseEnabled = true;
            _tabs[i].alpha = 1;
            i--;
        } // end for
    } // end function


    /**
	 * 
	 */
    public function setContentSize(width:Int, height:Int):Void
    {
        for(tab in tabs)
        {
            tab.setContentSize(width, height);
        } // end for
    } // end function


    //**************************************** SET AND GET ******************************************


    private function get_draggable():Bool
    {
        return _draggable;
    }

    private function set_draggable(value:Bool):Bool
    {
        _draggable = value;

        if(value)
        {
            for(tab in tabs)
            {
                cast(tab, BTab).addEventListener(MouseEvent.MOUSE_DOWN, dragTab);
                cast(tab, BTab).addEventListener(MouseEvent.MOUSE_UP, dropTab);
                cast(tab, BTab).addEventListener(MouseEvent.MOUSE_OUT, dropTab);
            }
        }
        else
        {
            for(tab in tabs)
            {
                cast(tab, BTab).removeEventListener(MouseEvent.MOUSE_DOWN, dragTab);
                cast(tab, BTab).removeEventListener(MouseEvent.MOUSE_UP, dropTab);
                cast(tab, BTab).removeEventListener(MouseEvent.MOUSE_OUT, dropTab);
            }
        }
        return value;
    }


    private function get_name():String
    {
        return _name;
    }


    private function get_numTabs():Int
    {
        return _tabs.length;
    }


    private function get_parent():DisplayObjectContainer
    {
        return _container.parent;
    }

    private function set_parent(value:DisplayObjectContainer):DisplayObjectContainer
    {
        value.addChild(_container);
        update();
        return value;
    }


    private function get_selection():BTab
    {
        return _selection;
    }

    private function set_selection(value:BTab):BTab
    {
        //_selection = value;
        switchTab(value);
        return value;
    }


    private function get_separatorWidth():Int
    {
        return _separatorWidth;
    }

    private function set_separatorWidth(value:Int):Int
    {
        _separatorWidth = value;
        update();
        return value;
    }


    private function get_tabMode():BTitleBarMode
    {
        return _tabMode;
    }

    private function set_tabMode(value:BTitleBarMode):BTitleBarMode
    {
        _tabMode = value;
        _iconFlag = false;

        switch (_tabMode)
        {
            case BTitleBarMode.COMPACT_TEXT, MINIMAL, NONE:
                _tabHeight = 30;

            case BTitleBarMode.COMPACT_ICON:
                _tabHeight = 40;
                _iconFlag = true;

            case BTitleBarMode.FULL_TEXT:
                _tabHeight = 30;

            case BTitleBarMode.FULL_ICON:
                _tabHeight = 48;
                _iconFlag = true;

        } // end switch  


        for(tab in _tabs)
        {
            switch(_tabMode)
            {
                case BTitleBarMode.COMPACT_TEXT, MINIMAL, NONE:
                    tab.button.labelPlacement = BPlacement.CENTER;
                    tab.button.icon.visible = false;

                case BTitleBarMode.COMPACT_ICON:
                    tab.button.iconPlacement = BPlacement.CENTER;
                    tab.button.textField.visible = false;

                case BTitleBarMode.FULL_TEXT:
                    tab.button.labelPlacement = BPlacement.LEFT;
                    tab.button.iconPlacement = BPlacement.RIGHT;
                    tab.button.icon.visible = false;

                case BTitleBarMode.FULL_ICON:
                    tab.button.labelPlacement = BPlacement.TOP;
                    tab.button.iconPlacement = BPlacement.BOTTOM;
                    tab.button.icon.visible = false;

            } // end switch
        } // end for


        //update();

        return _tabMode;
    }


    private function get_tabs():Array<BTab>
    {
        return _tabs;
    }

}

