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

import borris.display.BElement;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 13/05/2015 (dd/mm/yyyy)
 */
class BTextInput extends BUIComponent
{
    //public var alwaysShowSelection(get, set):Bool;
    //public var condenseWhite(get, set):Bool;

    /**
	 * Gets or sets a Boolean value that indicates whether the current TextInput component 
	 * instance was created to contain a password or to contain text. 
	 * A value of true indicates that the component instance is a password text field; 
	 * a value of false indicates that the component instance is a normal text field.
	 * 
	 * <p>When this property is set to true, for each character that the user enters into the text field, 
	 * the TextInput component instance displays an asterisk. 
	 * Additionally, the Cut and Copy commands and their keyboard shortcuts are disabled. 
	 * These measures prevent the recovery of a password from an unattended computer.</p>
	 * 
	 * @default false
	 */
    public var displayAsPassword(get, set):Bool;

    /**
	 * Gets or sets a Boolean value that indicates whether the text field can be edited by the user. 
	 * A value of true indicates that the user can edit the text field; 
	 * a value of false indicates that the user cannot edit the text field.
	 * 
	 * @default true;
	 */
    public var editable(get, set):Bool;

    /**
	 * Gets or sets the position of the thumb of the horizontal scroll bar.
	 * 
	 * @default 0
	 */
    public var horizontalScrollPosition(get, set):Int;

    /**
	 * Gets or sets the position of the thumb of the vertical scroll bar.
	 */
    public var verticalScrollPosition(get, set):Int;

    /**
	 * Contains the HTML representation of the string that the text field contains.
	 * 
	 * @default ""
	 */
    public var htmlText(get, set):String;

    /**
	 * Gets the number of characters in a TextInput component.
	 * 
	 * @default 0
	 */
    public var length(get, never):Int;

    /**
	 * Gets or sets the maximum number of characters that a user can enter in the text field.
	 * 
	 * @default 0
	 */
    public var maxChars(get, set):Int;

    /**
	 * Gets a value that describes the furthest position to which the text field can be scrolled to the right.
	 * 
	 * @default 0
	 */
    public var maxHorizontalScrollPosition(get, never):Int;

    /**
	 * Gets a value that describes the furthest position to which the text field can be scrolled to the bottom.
	 * 
	 * @default 0
	 */
    public var maxVerticalScrollPosition(get, never):Int;

    /**
	 * Gets or sets the string of characters that the text field accepts from a user. 
	 * Note that characters that are not included in this string are accepted in the text field if they are entered programmatically.
	 * 
	 * <p>The characters in the string are read from left to right. 
	 * You can specify a character range by using the hyphen (-) character.</p>
	 * 
	 * <p>If the value of this property is null, the text field accepts all characters. 
	 * If this property is set to an empty string (""), the text field accepts no characters.</p>
	 * 
	 * <p>If the string begins with a caret (^) character, 
	 * all characters are initially accepted and succeeding characters in the string are excluded from the set of accepted characters. 
	 * If the string does not begin with a caret (^) character, 
	 * no characters are initially accepted and succeeding characters in the string are included in the set of accepted characters.</p>
	 * 
	 * @default null
	 */
    public var restrict(get, set):String;

    /**
	 * Gets the index value of the first selected character in a selection of one or more characters.
	 * 
	 * <p>The index position of a selected character is zero-based and calculated from the first character that appears in the text area. 
	 * If there is no selection, this value is set to the position of the caret.</p>
	 * 
	 * @default 0
	 */
    public var selectionBeginIndex(get, never):Int;

    /**
	 * Gets the index position of the last selected character in a selection of one or more characters.
	 * 
	 * <p>The index position of a selected character is zero-based and calculated from the first character 
	 * that appears in the text area. If there is no selection, this value is set to the position of the caret.</p>
	 * 
	 * @default 0
	 */
    public var selectionEndIndex(get, never):Int;

    /**
	 * Gets or sets a string which contains the text that is currently in the TextInput component. 
	 * This property contains text that is unformatted and does not have HTML tags. 
	 * To retrieve this text formatted as HTML, use the htmlText property.
	 * 
	 * @default ""
	 */
    public var text(get, set):String;

    /**
	 * A reference to the internal text field of the TextInput component.
	 */
    public var textField(get, never):TextField;

    /**
	 * The height of the text, in pixels.
	 * 
	 * @default 0
	 */
    public var textHeight(get, never):Float;

    /**
	 * The width of the text, in pixels.
	 * 
	 * @default 0
	 */
    public var textWidth(get, never):Float;


    // assets
    private var _upSkin:Sprite; // The up skin of this details Object.
    private var _overSkin:Sprite; // The over skin of this details Object.
    private var _downSkin:Sprite; // The down skin of this details Object.
    private var _disabledSkin:Sprite; // The disabled skin of this details Object.
    private var _focusSkin:Sprite;

    // text stuff
    private var _focusInTF:TextFormat;
    private var _focusOutTF:TextFormat;


    // other
    private var _states:Array<Dynamic>;
    private var _disabledAlpha:Float = 0.5;

    // set and get
    private var _editable:Bool = true; //
    //protected var _imeMode:String;
    private var _textField:TextField;
    private var _textPadding:Float = 0; //


    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BRangeSlider component instance.
	 * 
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x position to place this component.
     * @param	y The y position to place this component.
	 * @param	text The text to be shown by the BTextInput component.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, text:String = "")
    {
        super(parent, x, y);
        setSize(100, 30);
        initialize();
        draw();

        _textField.text = text;
    }

    //************************************* EVENT HANDLERS ******************************************

    /**
	 * 
	 * @param	event
	 */
    private function onChange(event:Event):Void
    {
        event.stopImmediatePropagation();
        dispatchEvent(event);
    } // end function


    /**
	 * 
	 * @param	event
	 */
    private function onEnter(event:KeyboardEvent):Void
    {
        if(event.keyCode == Keyboard.ENTER)
        {
            dispatchEvent(event);
        }
    } // end function


    /**
	 * 
	 * @param	event
	 */
    private function onTextInput(event:TextEvent):Void
    {
        event.stopImmediatePropagation();
        dispatchEvent(event);
    } // end function


    /**
	 * 
	 * @param	event
	 */
    private function mouseHandler(event:MouseEvent):Void
    {

    } // end function


    /**
	 * 
	 * @param	event
	 */
    private function focusHandler(event:FocusEvent):Void
    {
        switch (event.type)
        {
            case FocusEvent.FOCUS_IN:
                if(_editable)
                {
                    changeState(_focusSkin);
                    _textField.setTextFormat(_focusInTF);
                    _textField.defaultTextFormat = _focusInTF;
                }

            case FocusEvent.FOCUS_OUT:
                changeState(_upSkin);
                _textField.setTextFormat(_focusOutTF);
                _textField.defaultTextFormat = _focusOutTF;
        }
    } // end function


    //************************************* FUNCTIONS ******************************************

    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();

        // initialize the skins
        _upSkin = new BElement();
        _overSkin = new BElement();
        _downSkin = new BElement();
        _disabledSkin = new BElement();
        _focusSkin = new BElement();

        // initialize text formats
        // TODO fix defaults
        _focusInTF = new TextFormat("Roboto", 16, 0x000000, false);
        _focusOutTF = new TextFormat("Roboto", 16, 0xCCCCCC, false);
        //_focusInTF = new TextFormat("Roboto", Math.floor(_height * 0.6), 0x000000, false);
        //_focusOutTF = new TextFormat("Roboto", Math.floor(_height * 0.6), 0xCCCCCC, false);

        // initialize the text field
        _textField = new TextField();
        _textField.text = "hehehe";
        _textField.selectable = true;
        _textField.type = TextFieldType.INPUT;
        _textField.x = 2;
        _textField.y = 0;
        //_textField.y = _height / 2 - _textField.height / 2;
        _textField.width = _width - 4;
        _textField.height = _height - 4;
        _textField.setTextFormat(_focusOutTF);
        _textField.defaultTextFormat = _focusOutTF;
        _textField.mouseEnabled = true;
        _textField.autoSize = TextFieldAutoSize.NONE;
        _textField.antiAliasType = AntiAliasType.ADVANCED;

        addChild(_upSkin);
        addChild(_overSkin);
        addChild(_downSkin);
        //addChild(disabledSkin);
        addChild(_focusSkin);
        addChild(_textField);

        // add the state skins to the state array
        _states = [_upSkin, _overSkin, _downSkin, _disabledSkin, _focusSkin];
        changeState(_upSkin);

        // event handling
        _textField.addEventListener(Event.CHANGE, onChange);
        _textField.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
        _textField.addEventListener(TextEvent.TEXT_INPUT, onTextInput);

        addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
        addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
        addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
        addEventListener(FocusEvent.FOCUS_IN, focusHandler);
        addEventListener(FocusEvent.FOCUS_OUT, focusHandler);
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        super.draw();

        //
        _upSkin.width =
        _overSkin.width =
        _downSkin.width =
        _disabledSkin.width =
        _focusSkin.width = _width;

        _upSkin.height =
        _overSkin.height =
        _downSkin.height =
        _disabledSkin.height =
        _focusSkin.height = _height;

        cast((_upSkin), BElement).style.backgroundColor = 0x333333;
        cast((_upSkin), BElement).style.backgroundOpacity = 0.9;
        cast((_upSkin), BElement).style.borderColor = 0xCCCCCC;
        cast((_upSkin), BElement).style.borderOpacity = 0.9;
        cast((_upSkin), BElement).style.borderWidth = 2;

        cast((_overSkin), BElement).style.backgroundColor = 0x666666;
        cast((_overSkin), BElement).style.backgroundOpacity = 0.9;
        cast((_overSkin), BElement).style.borderColor = 0xFFFFFF;
        cast((_overSkin), BElement).style.borderOpacity = 0.9;
        cast((_overSkin), BElement).style.borderWidth = 2;

        /*BElement(downSkin).style.backgroundColor = 0x666666;
			BElement(downSkin).style.backgroundOpacity = 1;
			BElement(downSkin).style.borderColor = 0x666666;
			BElement(downSkin).style.borderOpacity = 1;
			BElement(downSkin).style.borderWidth = 2;
			
			BElement(disabledSkin).style.backgroundColor = 0x666666;
			BElement(disabledSkin).style.backgroundOpacity = 1;
			BElement(disabledSkin).style.borderColor = 0x666666;
			BElement(disabledSkin).style.borderOpacity = 1;
			BElement(disabledSkin).style.borderWidth = 2;*/

        cast((_focusSkin), BElement).style.backgroundColor = 0xFFFFFF;
        cast((_focusSkin), BElement).style.backgroundOpacity = 1;
        cast((_focusSkin), BElement).style.borderColor = 0x999999;
        cast((_focusSkin), BElement).style.borderOpacity = 1;
        cast((_focusSkin), BElement).style.borderWidth = 2;

        // draw text field
        //_textField.displayAsPassword = _displayAsPassword;
        _textField.height = _height - 4;
        _textField.width = _width - 4;
        _focusInTF.size = Math.floor(_height * 0.6);
        _focusOutTF.size = Math.floor(_height * 0.6);
        _textField.x = 2;
        _textField.y = _height / 2 - _textField.height / 2;
    } // end function


    /**
	 * Changes the state of the component.
	 * 
	 * @param	state
	 */
    private function changeState(state:DisplayObject):Void
    {
        for(i in 0..._states.length)
        {
            var tempState:DisplayObject = _states[i];
            tempState.visible = false;

            if(state == tempState)
            {
                tempState.visible = true;
            }
            else
                tempState.visible = false;
        } // end for
    } // end function


    /**
	 * Appends the specified string after the last character that the TextArea contains. 
	 * This method is more efficient than concatenating two strings by using an addition assignment on a text property; 
	 * for example, myTextArea.text += moreText. 
	 * This method is particularly useful when the TextArea component contains a significant amount of content.
	 * 
	 * @param	text The string to be appended to the existing text.
	 */
    public function appendText(text:String):Void
    {
        _textField.appendText(text);
    } // end function


    /**
	 * Sets the range of a selection made in a text area that has focus. 
	 * The selection range begins at the index that is specified by the start parameter, 
	 * and ends at the index that is specified by the end parameter. 
	 * If the parameter values that specify the selection range are the same, 
	 * this method sets the text insertion point in the same way that the caretIndex property does.
	 * 
	 * <p>The selected text is treated as a zero-based string of characters in which the first selected 
	 * character is located at index 0, the second character at index 1, and so on.</p>
	 * 
	 * <p>This method has no effect if the text field does not have focus.</p>
	 * 
	 * @param	beginIndex The index location of the first character in the selection.
	 * @param	endIndex The index location of the last character in the selection.
	 */
    public function setSelection(beginIndex:Int, endIndex:Int):Void
    {
        _textField.setSelection(beginIndex, endIndex);
    } // end function


    //***************************************** SET AND GET *****************************************

    /**
	 * Gets or sets a Boolean value that indicates how a selection is displayed when the text field does not have focus.
	 * 
	 * <p>When this value is set to true and the text field does not have focus, 
	 * Flash Player highlights the selection in the text field in gray. 
	 * When this value is set to false and the text field does not have focus, 
	 * Flash Player does not highlight the selection in the text field.</p>
	 * 
	 * @default false
	 */
    /*private function get_alwaysShowSelection():Bool
    {
        return _textField.alwaysShowSelection;
    }
    private function set_alwaysShowSelection(value:Bool):Bool
    {
        _textField.alwaysShowSelection = value;
        return value;
    }*/


    /**
	 * Gets or sets a Boolean value that indicates whether extra white space is removed from a TextInput component that contains HTML text. 
	 * Examples of extra white space in the component include spaces and line breaks. 
	 * A value of true indicates that extra white space is removed; a value of false indicates that extra white space is not removed.
	 * 
	 * <p>This property affects only text that is set by using the htmlText property; 
	 * it does not affect text that is set by using the text property. 
	 * If you use the text property to set text, the condenseWhite property is ignored.</p>
	 * 
	 * <p>If the condenseWhite property is set to true, you must use standard HTML commands, 
	 * such as <br> and <p>, to place line breaks in the text field.</p>
	 * 
	 * @default false
	 */
    /*private function get_condenseWhite():Bool
    {
        return _textField.condenseWhite;
    }
    private function set_condenseWhite(value:Bool):Bool
    {
        _textField.condenseWhite = value;
        return value;
    }*/


    private function get_displayAsPassword():Bool
    {
        return _textField.displayAsPassword;
    }

    private function set_displayAsPassword(value:Bool):Bool
    {
        _textField.displayAsPassword = value;
        return value;
    }


    private function get_editable():Bool
    {
        return _editable;
    }

    private function set_editable(value:Bool):Bool
    {
        _editable = value;
        //_textField.selectable = value;

        if(value)
        {
            _textField.type = TextFieldType.INPUT;
        }
        else
        {
            _textField.type = TextFieldType.DYNAMIC;
        }
        return value;
    }


    private function get_horizontalScrollPosition():Int
    {
        return _textField.scrollH;
    }

    private function set_horizontalScrollPosition(value:Int):Int
    {
        _textField.scrollH = value;
        return value;
    }


    private function get_verticalScrollPosition():Int
    {
        return _textField.scrollV;
    }

    private function set_verticalScrollPosition(value:Int):Int
    {
        _textField.scrollV = value;
        return value;
    }


    private function get_htmlText():String
    {
        return _textField.htmlText;
    }

    private function set_htmlText(value:String):String
    {
        _textField.htmlText = value;
        return value;
    }


    // imeMode
    /*public function set imeMode(value:String):void
		{
			_imeMode = value;
		}
		
		public function get imeMode():String
		{
			return _imeMode;
		}*/


    private function get_length():Int
    {
        return _textField.length;
    }


    private function get_maxChars():Int
    {
        return _textField.maxChars;
    }

    private function set_maxChars(value:Int):Int
    {
        _textField.maxChars = value;
        return value;
    }


    private function get_maxHorizontalScrollPosition():Int
    {
        return _textField.maxScrollH;
    }


    private function get_maxVerticalScrollPosition():Int
    {
        return _textField.maxScrollV;
    }


    private function get_restrict():String
    {
        return _textField.restrict;
    }

    private function set_restrict(value:String):String
    {
        _textField.restrict = value;
        return value;
    }


    private function get_selectionBeginIndex():Int
    {
        return _textField.selectionBeginIndex;
    }


    private function get_selectionEndIndex():Int
    {
        return _textField.selectionEndIndex;
    }


    private function get_text():String
    {
        return _textField.text;
    }

    private function set_text(value:String):String
    {
        _textField.text = value;
        return value;
    }


    private function get_textField():TextField
    {
        return _textField;
    }


    private function get_textHeight():Float
    {
        return _textField.textHeight;
    }


    private function get_textWidth():Float
    {
        return _textField.textWidth;
    }
}

