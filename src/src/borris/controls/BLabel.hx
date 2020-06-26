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

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;


/**
 * A Label component displays one or more lines of plain or HTML-formatted text that can be formatted for alignment
 * and size. Label components do not have borders and cannot receive focus.
 *
 * @author Rohaan Allport
 * @creation-date 19/10/2014 (dd/mm/yyyy)
 */
class BLabel extends BUIComponent
{
    /**
     * Gets or sets a string that indicates how a label is sized and aligned to fit the value of its text property. 
	 * The following are valid values:
	 * <ul>
	 * <li>TextFieldAutoSize.NONE: The label is not resized or aligned to fit the text.</li>
	 * <li>TextFieldAutoSize.LEFT: The right and bottom sides of the label are resized to fit the text. The left and top sides are not resized.</li>
	 * <li>TextFieldAutoSize.CENTER: The left and right sides of the label resize to fit the text. 
	 * The horizontal center of the label stays anchored at its original horizontal center position.</li>
	 * <li>TextFieldAutoSize.RIGHT: The left and bottom sides of the label are resized to fit the text. The top and right sides are not resized.</li>
	 * </lu>
	 * 
	 * @default TextFieldAutoSize.NONE
     */
    public var autoSize(get, set):String;

    /**
     * Gets or sets a value that indicates whether the text can be selected. 
	 * A value of true indicates that it can be selected; 
	 * a value of false indicates that it cannot.
	 * 
	 * Text that can be selected can be copied from the Label component by the user.
	 * 
	 * @default false
     */
    public var selectable(get, set):Bool;

    /**
     * Gets or sets the plain text to be displayed by the Label component.
	 * 
	 * <p>Note that characters that represent HTML markup have no special meaning in the string and will appear as they were entered.</p>
	 * 
	 * @default "Label"
     */
    public var text(get, set):String;

    /**
     * A reference to the internal text field of the Label component.
     */
    public var textField(get, never):TextField;

    /**
     * Gets or sets a value that indicates whether the text field supports word wrapping. 
	 * A value of true indicates that it does; 
	 * a value of false indicates that it does not.
	 * 
	 * @default false
     */
    public var wordWrap(get, set):Bool;

    // constants


    // assets
    private var _skin:Sprite;


    // text stuff
    private var _textField:TextField;
    private var _enabledTF:TextFormat;
    private var _disabledTF:TextFormat;
    //private var calibriRegular:CalibriRegular = new CalibriRegular();


    // other


    // set and get
    private var _autoSize:String;
    private var _selectable:Bool = false;
    private var _text:String = "";
    private var _wordWrap:Bool = false;


    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BLabel component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x position to place this component.
     * @param	y The y position to place this component.
	 * @param	text The text String to be displayed by the BLabel component.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, text:String = "")
    {
        _autoSize = TextFieldAutoSize.NONE;
        _text = text;

        super(parent, x, y);
        initialize(); // need initialize for neko
        setSize(100, 20);
        //draw();

        this.text = text;

    }


    //************************************* FUNCTIONS ******************************************


    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();
        mouseEnabled = false;
        mouseChildren = false;

        // initialize assets
        // TODO add disabled skin
        _skin = new BElement();

        // initialize the text feilds and formats
        _enabledTF = new TextFormat("Roboto", 16, 0xFFFFFF, false);
        _disabledTF = new TextFormat("Roboto", 16, 0xCCCCCC, false);

        // initialize the text field
        _textField = new TextField();
        _textField.text = _text;
        _textField.type = TextFieldType.DYNAMIC;
        _textField.selectable = false;
        _textField.x = 0;
        _textField.y = 0;
        _textField.width = _width;
        _textField.height = _height;
        _textField.setTextFormat(_enabledTF);
        _textField.defaultTextFormat = _enabledTF;
        _textField.mouseEnabled = false;
        //_textField.autoSize = TextFieldAutoSize.NONE;
        _textField.antiAliasType = AntiAliasType.ADVANCED;

        addChild(_skin);
        addChild(_textField);
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        _skin.width = _width;
        _skin.height = _height;
    } // end function


    /**
	 * @inheritDoc
	 */
    override public function setSize(width:Float, height:Float):Void
    {
        _width = width;
        _height = height;
        _textField.width = width;
        _textField.height = height;
        draw();
    } // end function


    //***************************************** SET AND GET *****************************************


    private function get_autoSize():String
    {
        return _textField.autoSize;
    }

    private function set_autoSize(value:String):String
    {
        _textField.autoSize = value;
        return value;
    }


    private function get_selectable():Bool
    {
        return _textField.selectable;
    }

    private function set_selectable(value:Bool):Bool
    {
        _textField.selectable = value;
        _textField.mouseEnabled = value;
        mouseEnabled = value;
        mouseChildren = value;
        return value;
    }


    private function get_text():String
    {
        return _textField.text;
    }

    private function set_text(value:String):String
    {
        _textField.text = value;
        this.width = _textField.width;
        return value;
    }


    private function get_textField():TextField
    {
        return _textField;
    }


    private function get_wordWrap():Bool
    {
        return _textField.wordWrap;
    }

    private function set_wordWrap(value:Bool):Bool
    {
        _textField.wordWrap = value;
        return value;
    }


    /**
     * @inheritDoc
     */
    #if flash
	@:getter(width)
	override private function get_width():Float
    {
        return _textField.width;
    }
	@:setter(width)
    override private function set_width(value:Float):Void
    {
        _width = value;
        _textField.width = value;
        draw();
    }
	
	
	@:getter(height)
	override private function get_height():Float
    {
        return _textField.height;
    }
	@:setter(height)
    override private function set_height(value:Float):Void
    {
        _width = value;
        _textField.height = value;
        draw();
    }
	#else

    override private function get_width():Float
    {
        return _textField.width;
    }

    override private function set_width(value:Float):Float
    {
        _width = value;
        _textField.width = value;
        draw();
        return value;
    }


    override private function get_height():Float
    {
        return _textField.height;
    }

    override private function set_height(value:Float):Float
    {
        _width = value;
        _textField.height = value;
        draw();
        return value;
    }
    #end

}

