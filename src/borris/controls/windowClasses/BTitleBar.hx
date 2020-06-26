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

package borris.controls.windowClasses;

import borris.controls.BUIComponent;
import borris.display.BTitleBarMode;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.text.TextFieldAutoSize;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 18/02/2016 (dd/mm/yyyy)
 */
class BTitleBar extends BUIComponent
{
    /**
	 *
	 */
    public var buttons(get, set):Array<BLabelButton>;

    /**
	 * Gets or sets the text title for the component. By default, the title text appears to the left of the title bar.
	 *
	 * @default ""
	 */
    public var title(get, set):String;

    /**
	 *
	 */
    public var icon(get, set):Class<Dynamic>;

    /**
	 *
	 */
    public var mode(get, set):BTitleBarMode;

    /**
	 * A reference to the internal label component.
	 */
    public var label(get, never):BLabel;

    // assets
    private var _container:Sprite;
    private var _titleLabel:BLabel;
    private var _dotsLabel:BLabel;
    private var _dotsIcon:DisplayObject;
    private var _containerMask:Shape;

    // other
    private var _buttonsWidth:Int = 0; // the width of the buttons and icons in the the titlebar. used for calucating the title text width
    private var _textWidth:Int = 0;


    // set and get
    private var _titleBarMode:BTitleBarMode = BTitleBarMode.COMPACT_TEXT; // The mode of the title bar. 4 modes in total. minimal (3 dots), compact (text or icon), full (text and icon)
    //protected var _titleBarHeight:int; 							// [read-only] The height of the title bar after calculating the titleBar height and mode, etc
    private var _buttons:Array<BLabelButton> = new Array<BLabelButton>();
    private var _icon:Class<Dynamic>;


    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, title:String = "")
    {
        super(parent, x, y);
        initialize();
        //setSize(100, 24);

        // initialize assets
        _container = new Sprite();
        _container.mouseEnabled = false;
        _container.tabEnabled = false;


        _titleLabel = new BLabel(_container, _height, _height / 2, title);
        _titleLabel.autoSize = TextFieldAutoSize.LEFT;

        _dotsLabel = new BLabel(_container, _width / 2, _height / 2, "...");
        _dotsLabel.autoSize = TextFieldAutoSize.LEFT;

        _dotsIcon = new Bitmap(Assets.getBitmapData("graphics/more icon 01 24x24.png"));

        _containerMask = new Shape();
        _containerMask.graphics.beginFill(0xff00ff, 1);
        _containerMask.graphics.drawRect(0, 0, 100, 100);
        _containerMask.graphics.endFill();
        _container.mask = _containerMask;

        // set mode after all assest are created.
        mode = _titleBarMode;
        _textWidth = Math.round(_titleLabel.width);

        // add assets to repective containers
        _container.addChild(_dotsIcon);
        addChild(_container);
        addChild(_containerMask);

        _style.backgroundColor = 0x006699;
        _style.backgroundOpacity = 1;
        _style.borderColor = 0x00CCFF;
        _style.borderOpacity = 0.8;
        _style.borderWidth = 0;

        _style.borderTopWidth = 0;
        _style.borderLeftWidth = 0;
        _style.borderRightWidth = 0;
        _style.borderBottomWidth = 1;

    }


    //**************************************** HANDLERS *********************************************


    //**************************************** FUNCTIONS ********************************************


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        //trace("BTitleBar | draw()");

        _titleLabel.x = _height;
        _titleLabel.y = _height / 2 - _titleLabel.height / 2;

        //dotsText.x = _width - dotsText.width;
        //dotsText.y = _height / 2 - dotsText.height / 2;

        _dotsIcon.x = _width / 2 - _dotsIcon.width / 2;
        _dotsIcon.y = _height / 2 - _dotsIcon.height / 2;


        // change the width of the title text lable id the buttons are getting too close
        if(_width - cast(_style.borderWidth, Int) * 2 <= _textWidth + _buttonsWidth)
        {
            _dotsLabel.x = _width - _dotsLabel.width - (_buttons.length) * _height;
            _dotsLabel.y = _titleLabel.y;
            _dotsLabel.visible = true;
            _titleLabel.autoSize = TextFieldAutoSize.NONE;
            _titleLabel.width = _width - cast(_style.borderWidth, Int) * 2 - _buttonsWidth;
        }
        else
        {
            _dotsLabel.visible = false;
            _titleLabel.autoSize = TextFieldAutoSize.LEFT;
        } // end else  

        // position the buttons
        /*for (i in 0..._buttons.length)
		{
            _buttons[i].x = _width - (i + 1) * (_height - cast(_style.borderBottomWidth, Int));
        } // end for*/

        _containerMask.width = Math.round(_width);
        _containerMask.height = Math.round(_height);

        super.draw();
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function initialize():Void
    {
        super.initialize();
    } // end function

    //**************************************** SET AND GET ******************************************


    private function get_buttons():Array<BLabelButton>
    {
        return _buttons;
    }

    private function set_buttons(value:Array<BLabelButton>):Array<BLabelButton>
    {
        //var buttonHeight:int = _height - int(_style.borderBottomWidth);

        if(_buttons.length > 0)
        {
            for(i in 0..._buttons.length)
            {
                if(_container.contains(_buttons[i]))
                    _container.removeChild(_buttons[i]);
            }
        } // end for

        _buttons = value;

        for(i in 0..._buttons.length)
        {
            _buttons[i].move(Math.round(_width - (i + 1) * _height), 0);
            _buttons[i].setSize(_height, _height);
            _container.addChild(_buttons[i]);
        } // end for

        // calculate buttons' width  
        _buttonsWidth = Math.round(_height * (_buttons.length + 1) + _dotsLabel.width);
        return value;
    }


    private function get_title():String
    {
        return _titleLabel.text;
    }

    private function set_title(value:String):String
    {
        _titleLabel.text = value;
        _textWidth = Math.round(_titleLabel.width);
        return value;
    }


    private function get_icon():Class<Dynamic>
    {
        return _icon;
    }

    private function set_icon(value:Class<Dynamic>):Class<Dynamic>
    {
        _icon = Type.createInstance(value, []);
        var ic:DisplayObject = try cast(_icon, DisplayObject)
        catch(e:Dynamic) null;
        ic.width = _height;
        ic.height = _height;
        ic.x = ic.y = Std.parseFloat(_style.borderWidth);
        return value;
    }


    private function get_mode():BTitleBarMode
    {
        return _titleBarMode;
    }

    private function set_mode(value:BTitleBarMode):BTitleBarMode
    {
        _titleBarMode = value;

        //var buttonHeight:int = _height - int(_style.borderBottomWidth);

        if(_titleBarMode != BTitleBarMode.NONE)
        {
            scaleY = 1;
            visible = true;

            if(_titleBarMode != BTitleBarMode.MINIMAL)
            {
                _titleLabel.visible = true;
                _dotsLabel.visible = true;
                _dotsIcon.visible = false;
            }
        } // end if


        switch (_titleBarMode)
        {
            case BTitleBarMode.COMPACT_TEXT:
                _height = 30;

            case BTitleBarMode.COMPACT_ICON:
                _height = 40;

            case BTitleBarMode.FULL_TEXT:
                _height = 30;

            case BTitleBarMode.FULL_ICON:
                _height = 48;

            case BTitleBarMode.MINIMAL:
                _height = 10;
                _titleLabel.visible = false;
                _dotsLabel.visible = false;
                _dotsIcon.visible = true;

            case BTitleBarMode.NONE:
                scaleY = 0; // scale is changed so the the height becomes 0 and makes the content position change when drawn
                visible = false;

                _titleLabel.visible = false;
                _dotsLabel.visible = false;
        } // end switch  


        // calculate buttons' width
        _buttonsWidth = Math.round(_height * (_buttons.length + 1) + _dotsLabel.width);
        //buttonsWidth = buttonHeight * (_buttons.length + 1) + dotsText.width;

        draw();
        return value;
    }


    private function get_label():BLabel
    {
        return _titleLabel;
    }
}

