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

import borris.containers.BScrollPane;
import borris.display.BElement;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;

// TODO fix selected and over state for tabs in html5 and neko
/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 18/01/2016 (dd/mm/yyyy)
 */
class BTab extends BUIComponent
{
    /**
	 * A referance to the BTab's internal button
	 */
    public var button(get, never):BLabelButton;

    /**
	 * A reference to the scroll pane assosiated with this BTab
	 */
    public var content(get, never):BScrollPane;

    /**
	 * The BTabGroup object to which this tab belongs.
	 */
    public var group(get, set):BTabGroup;

    /**
	 * Gets or sets the text label for the component.
	 * 
	 * @default ""
	 */
    public var label(get, set):String;

    /**
	 * Indicates whether a tab is currently selected (true) or deselected (false). 
	 * You can only set this value to true; setting it to false has no effect. 
	 * To achieve the desired effect, select a different tab in the same tab group.
	 * 
	 * @default false
	 */
    public var selected(get, set):Bool;


    // assets
    private var _container:Sprite; // A container to hold the items of the details Object
    private var _button:BLabelButton;

    private var _mk:Shape; // A mask to mask out overflow of the container from the bottom and right.

    // set and get
    private var _group:BTabGroup; // The BTabGroup object to which this RadioButton belongs.
    private var _label:String; //
    private var _content:BScrollPane; // [read-only] the content belonging to this tab


    /**
     * Creates a new BTab component instance.
     *
	 * @param	label The text label for the component.
     */
    public function new(label:String = "Label")
    {
        _label = label;
        super(null, 0, 0);
        initialize();
        setSize(100, 32);
    }


    //**************************************** HANDLERS *********************************************


    /**
	 * Positions and adds the content of this tab when the tab is added to stage.
	 * 
	 * @param	event
	 */
    override private function onAddedToStage(event:Event):Void
    {
        super.onAddedToStage(event);
        // we should do a check here to see if the Tab was added to a BPanelWindow or BPannelAttached2

        //
        _content.x = 0;
        _content.y = this.y + this.height;
        parent.addChild(_content);

        //this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        draw();
    } // end function


    //**************************************** FUNCTIONS ********************************************


    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();

        // initialize asset variables
        _content = new BScrollPane();
        _content.x = 0;
        _content.y = this.y + this.height;
        _content.contentPadding = 10;
        //_content.style.backgroundColor = 0x006699;
        //_content.style.backgroundOpacity = 0.5;

        // initialize the button;
        _button = new BLabelButton(this, 0, 0, _label);
        _button.autoSize = true;
        _button.toggle = true;

        button.filters = [];
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {

        // if autoSize then adjust the width of the button automatically
        if(_button.autoSize)
        {
            if(_button.textField.text != "")
            {
                _width = _button.textField.width + _button.textPadding * 2;
            }
        }

        _button.width = _width;
        _button.height = _height;

        //
        cast((button.getSkin("upSkin")), BElement).style.backgroundColor = 0x000000;
        cast((button.getSkin("upSkin")), BElement).style.backgroundOpacity = 1;
        cast((button.getSkin("upSkin")), BElement).style.borderColor = 0xCCCCCC;
        cast((button.getSkin("upSkin")), BElement).style.borderOpacity = 1;
        cast((button.getSkin("upSkin")), BElement).style.borderWidth = 1;

        cast((button.getSkin("overSkin")), BElement).style.backgroundColor = 0x000000;
        cast((button.getSkin("overSkin")), BElement).style.backgroundOpacity = 1;
        cast((button.getSkin("overSkin")), BElement).style.borderColor = 0xCCCCCC;
        cast((button.getSkin("overSkin")), BElement).style.borderOpacity = 1;
        cast((button.getSkin("overSkin")), BElement).style.borderWidth = 1;
        //cast((button.getSkin("overSkin")), BElement).style.highlightColor = 0x0099CC;
        //cast((button.getSkin("overSkin")), BElement).style.highlightHeight = 4;
        //cast((button.getSkin("overSkin")), BElement).style.highlightOpacity = 1;

        cast((button.getSkin("downSkin")), BElement).style.backgroundColor = 0x333333;
        cast((button.getSkin("downSkin")), BElement).style.backgroundOpacity = 1;
        cast((button.getSkin("downSkin")), BElement).style.borderColor = 0xCCCCCC;
        cast((button.getSkin("downSkin")), BElement).style.borderOpacity = 1;
        cast((button.getSkin("downSkin")), BElement).style.borderWidth = 1;
        //cast((button.getSkin("downSkin")), BElement).style.highlightColor = 0x0099CC;
        //cast((button.getSkin("downSkin")), BElement).style.highlightHeight = 4;
        //cast((button.getSkin("downSkin")), BElement).style.highlightOpacity = 1;

        cast((button.getSkin("disabledSkin")), BElement).style.backgroundColor = 0x000000;
        cast((button.getSkin("disabledSkin")), BElement).style.backgroundOpacity = 1;
        cast((button.getSkin("disabledSkin")), BElement).style.borderColor = 0xCCCCCC;
        cast((button.getSkin("disabledSkin")), BElement).style.borderOpacity = 1;
        cast((button.getSkin("disabledSkin")), BElement).style.borderWidth = 1;

        //
        cast((button.getSkin("selectedUpSkin")), BElement).style.backgroundColor = 0x000000;
        cast((button.getSkin("selectedUpSkin")), BElement).style.backgroundOpacity = 1;
        cast((button.getSkin("selectedUpSkin")), BElement).style.borderColor = 0xCCCCCC;
        cast((button.getSkin("selectedUpSkin")), BElement).style.borderOpacity = 1;
        cast((button.getSkin("selectedUpSkin")), BElement).style.borderWidth = 1;
        cast((button.getSkin("selectedUpSkin")), BElement).style.borderBottomWidth = 0;

        cast((button.getSkin("selectedOverSkin")), BElement).style.backgroundColor = 0x222222;
        cast((button.getSkin("selectedOverSkin")), BElement).style.backgroundOpacity = 1;
        cast((button.getSkin("selectedOverSkin")), BElement).style.borderColor = 0xCCCCCC;
        cast((button.getSkin("selectedOverSkin")), BElement).style.borderOpacity = 1;
        cast((button.getSkin("selectedOverSkin")), BElement).style.borderWidth = 1;
        cast((button.getSkin("selectedOverSkin")), BElement).style.borderBottomWidth = 0;

        cast((button.getSkin("selectedDownSkin")), BElement).style.backgroundColor = 0x555555;
        cast((button.getSkin("selectedDownSkin")), BElement).style.backgroundOpacity = 1;
        cast((button.getSkin("selectedDownSkin")), BElement).style.borderColor = 0xCCCCCC;
        cast((button.getSkin("selectedDownSkin")), BElement).style.borderOpacity = 1;
        cast((button.getSkin("selectedDownSkin")), BElement).style.borderWidth = 1;
        cast((button.getSkin("selectedDownSkin")), BElement).style.borderBottomWidth = 0;

        cast((button.getSkin("selectedDisabledSkin")), BElement).style.backgroundColor = 0x000000;
        cast((button.getSkin("selectedDisabledSkin")), BElement).style.backgroundOpacity = 1;
        cast((button.getSkin("selectedDisabledSkin")), BElement).style.borderColor = 0xCCCCCC;
        cast((button.getSkin("selectedDisabledSkin")), BElement).style.borderOpacity = 1;
        cast((button.getSkin("selectedDisabledSkin")), BElement).style.borderWidth = 1;
        cast((button.getSkin("selectedDisabledSkin")), BElement).style.borderBottomWidth = 0;

        button.setStateColors(0x000000, 0x000000, 0x333333, 0x000000, 0x000000, 0x222222, 0x555555, 0x000000);
    } // end function


    /**
	 * Set the size of the content
	 * @param	width
	 * @param	height
	 */
    @:allow(borris.controls.BTabGroup)
    private function setContentSize(width:Float, height:Float):Void
    {
        _content.width = width;
        _content.height = height;
    } // end function


    //**************************************** SET AND GET ******************************************


    private function get_button():BLabelButton
    {
        return _button;
    }


    private function get_content():BScrollPane
    {
        return _content;
    }


    private function get_group():BTabGroup
    {
        return _group;
    }

    private function set_group(value:BTabGroup):BTabGroup
    {
        _group = value;
        return value;
    }


    private function get_label():String
    {
        return _label;
    }

    private function set_label(value:String):String
    {
        _label = value;
        _button.label = _label;
        draw();
        return value;
    }


    private function get_selected():Bool
    {
        return _button.selected;
    }

    private function set_selected(value:Bool):Bool
    {
        if(button.selected == value)
            return value;

        _button.selected = value;
        _content.enabled = value;
        return value;
    }
}

