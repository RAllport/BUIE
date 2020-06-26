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

import motion.Actuate;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.filters.DropShadowFilter;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 19/11/2015 (dd/mm/yyyy)
 */
// TODO give tooltip a delay property
// TODO handle timer, hiding and displaying internally
// TODO see BIRodioButton
class BTooltip extends BUIComponent
{
    /**
	 * Gets or sets the text label for the component. By default, the label text appears on the bottom left of the tooltip.
	 * 
	 * @default ""
	 */
    public var label(get, set):String;

    /**
	 * Gets or sets the tip text for the component. By default, the tip text appears centered on the bottom left of the tooltip.
	 * 
	 * @default ""
	 */
    public var tip(get, set):String;

    /**
	 * 
	 */
    public var displayPosition(get, set):String;

    /**
	 * 
	 */
    public var tooltipMode(get, set):BTooltipMode;

    /**
	 * 
	 */
    public var borderColor(get, set):Int;

    /**
	 * 
	 */
    public var borderThickness(get, set):Int;

    /**
	 * 
	 */
    public var borderTransparency(get, set):Float;

    /**
	 * 
	 */
    public var backgroundColor(get, set):Int;

    /**
	 * 
	 */
    public var backgroundTransparency(get, set):Float;

    /**
	 * 
	 */
    public var padding(get, set):Int;

    /**
	 * 
	 */
    public var arrowHeight(get, set):Int;


    // assets
    private var _container:Sprite;
    private var _labelText:BLabel;
    private var _tipTextField:TextField;
    private var _preview:DisplayObject;
    private var _arrow:Shape;
    private var _border:Shape;
    private var _background:Shape;


    // style
    // TODO style tooltip with BStyle instead
    private var _borderColor:Int = 0xCCCCCC;
    private var _borderThickness:Int = 1;
    private var _borderTransparency:Float = 1;
    private var _backgroundColor:Int = 0x111111;
    private var _backgroundTransparency:Float = 1;
    private var _padding:Int = 5;
    private var _arrowHeight:Int = 12;

    // text stuff
    private var _enabledTF:TextFormat;
    private var _disabledTF:TextFormat;
    private var _disabledTextAlpha:Float = 0.5;


    // other


    // set and get
    private var _label:String; // TODO use BLabel instead
    private var _tipText:String; // TODO use BLabel instead
    private var _displayPosition:String = "bottomRight"; // TODO use BPlacement instead
    //protected var _displayDirection:String = "bottom";
    private var _tooltipMode:BTooltipMode = BTooltipMode.LABEL_ONLY;
    private var _autoSize:Bool = false;


    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BTooltip component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
	 * @param	label The text label for the component.
	 * @param	tipText The helpfull text to be shown by the BTooltip component.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, label:String = "", tipText:String = "")
    {
        _label = label;
        _tipText = tipText;

        super(parent, x, y);
        initialize();
        setSize(200, 200);
    }


    //**************************************** HANDLERS *********************************************


    //**************************************** FUNCTIONS ********************************************

    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();

        //
        _container = new Sprite();
        _arrow = new Shape();
        _border = new Shape();
        _background = new Shape();

        // initialize label
        _labelText = new BLabel(this, _padding, 0, _label);
        _labelText.autoSize = TextFieldAutoSize.LEFT;

        // initialize the text feilds and formats
        _enabledTF = new TextFormat("Calibri", 16, 0xFFFFFF, false);
        _disabledTF = new TextFormat("Calibri", 16, 0xCCCCCC, false);

        // tipText
        _tipTextField = new TextField();
        _tipTextField.text = _tipText;
        _tipTextField.type = TextFieldType.DYNAMIC;
        _tipTextField.selectable = false;
        _tipTextField.x = _padding;
        _tipTextField.y = _labelText.y + _labelText.height;
        _tipTextField.width = _width - _padding * 2;
        _tipTextField.height = _height;
        _tipTextField.setTextFormat(_enabledTF);
        _tipTextField.defaultTextFormat = _enabledTF;
        _tipTextField.mouseEnabled = false;
        //tipText.autoSize = TextFieldAutoSize.NONE;
        _tipTextField.antiAliasType = AntiAliasType.ADVANCED;
        _tipTextField.wordWrap = true;
        //trace("tip text: " + tipText.text);

        // add assets the respective containers
        addChild(_container);
        addChild(_arrow);
        _container.addChild(_border);
        _container.addChild(_background);
        _container.addChild(_labelText);
        _container.addChild(_tipTextField);

        // hide the tooltip by default
        hide();


        #if !neko
        this.filters = [new DropShadowFilter(4, 45, 0x000000, 1, 8, 8, 1, 3, false)];
        #end
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        super.draw();

        // draw the arrow
        _arrow.graphics.clear();
        //arrow.graphics.beginFill(_backgroundColor, _backgroundTransparency);
        //arrow.graphics.lineTo(_arrowHeight, _arrowHeight);
        //arrow.graphics.lineTo( -_arrowHeight, _arrowHeight);

        _arrow.graphics.beginFill(_borderColor, _borderTransparency); // border
        _arrow.graphics.lineTo(_arrowHeight + _borderThickness, _arrowHeight + _borderThickness);
        _arrow.graphics.lineTo(-_arrowHeight - _borderThickness, _arrowHeight + _borderThickness);
        _arrow.graphics.lineTo(0, 0);
        _arrow.graphics.endFill();

        _arrow.graphics.moveTo(0, _borderThickness); // cut out
        _arrow.graphics.lineTo(_arrowHeight, _arrowHeight + _borderThickness);
        _arrow.graphics.lineTo(-_arrowHeight, _arrowHeight + _borderThickness);
        _arrow.graphics.lineTo(0, _borderThickness);

        _arrow.graphics.beginFill(_backgroundColor, _backgroundTransparency); // main color
        _arrow.graphics.moveTo(0, _borderThickness);
        _arrow.graphics.lineTo(_arrowHeight, _arrowHeight + _borderThickness);
        _arrow.graphics.lineTo(-_arrowHeight, _arrowHeight + _borderThickness);
        _arrow.graphics.lineTo(0, _borderThickness);

        _arrow.graphics.endFill();

        // draw the border
        _border.graphics.clear();
        _border.graphics.beginFill(_borderColor, _borderTransparency);
        _border.graphics.drawRect(0, 0, _width, _height);
        _border.graphics.drawRect(_borderThickness, _borderThickness, _width - (_borderThickness * 2), _height - (_borderThickness * 2));
        _border.graphics.endFill();

        // draw the background
        _background.graphics.clear();
        _background.graphics.beginFill(_backgroundColor, _backgroundTransparency);
        _background.graphics.drawRect(_borderThickness, _borderThickness, _width - (_borderThickness * 2), _height - (_borderThickness * 2));
        _background.graphics.endFill();

        /*_style.backgroundColor = 0x111111;
		_style.backgroundOpacity = 1;
		
		_style.borderColor = 0xCCCCCC;
		_style.borderOpacity = 1;
		_style.borderWidth = 1;*/

        //
        _labelText.x = _padding;
        _labelText.y = _padding;
        _labelText.width = _width - _padding * 2;

        //
        positionAssets();
    } // end function


    /**
	 * Display the tooltip.
	 */
    public function display():Void
    {
        Actuate.tween(this, 0.3, {scaleX: 1, scaleY: 1, alpha: 1}).onComplete(function()
        { scaleX = scaleY = 1; alpha = 1; });
    } // end function


    /**
	 * Hide the tooltip.
	 */
    public function hide():Void
    {
        Actuate.tween(this, 0.3, { scaleX: 0, scaleY: 0, alpha: 0 }).onComplete(function()
        { scaleX = scaleY = 0; alpha = 0; visible = false; });
    } // end function


    /**
	 * 
	 */
    private function positionAssets():Void
    {
        //
        switch (_tooltipMode)
        {
            case BTooltipMode.LABEL_ONLY:
                _labelText.visible = true;
                _tipTextField.visible = false;
                if(_preview != null)
                {_preview.visible = false;
                }
                _width = _labelText.width + _padding * 2;
                _height = _labelText.height + _padding * 2;

            case BTooltipMode.TIP_ONLY:
                _labelText.visible = false;
                _tipTextField.visible = true;
                if(_preview != null)
                {_preview.visible = false;
                }
                _width = _tipTextField.width + _padding * 2;
                _height = _tipTextField.height + _padding * 2;

            case BTooltipMode.PREVIEW_ONLY:
                _labelText.visible = false;
                _tipTextField.visible = false;
                if(_preview != null)
                {
                    _preview.visible = true;
                    _width = _labelText.width + _padding * 2;
                    _height = _labelText.height + _padding * 2;
                }

            case BTooltipMode.LABEL_AND_TIP:
                _labelText.visible = true;
                _tipTextField.visible = true;
                if(_preview != null)
                {_preview.visible = false;
                }
                _width = Math.max(_labelText.width, _tipTextField.width) + _padding * 2;
                _height = _labelText.height + _tipTextField.width + _padding * 2;

            case BTooltipMode.LABEL_AND_PREVIEW:
                _labelText.visible = true;
                _tipTextField.visible = false;
                if(_preview != null)
                {_preview.visible = true;
                }
                _width = Math.max(_labelText.width, _preview.width) + _padding * 2;
                _height = _labelText.height + _preview.height + _padding * 2;

            case BTooltipMode.TIP_AND_PREVIEW:
                _labelText.visible = true;
                _tipTextField.visible = false;
                if(_preview != null)
                {_preview.visible = false;
                }
                _width = _labelText.width + _padding * 2;
                _height = _labelText.height + _padding * 2;

            case BTooltipMode.ALL:
                _labelText.visible = true;
                _tipTextField.visible = true;
                if(_preview != null)
                {_preview.visible = true;
                }
                _width = Math.max(Math.max(_labelText.width, _tipTextField.width), _preview.width) + _padding * 2;
                _height = _labelText.height + _tipTextField.height + _preview.height + _padding * 2;
        } // end switch  


        _tipTextField.x = _padding;
        //_tipTextField.y = _labelText.y + _labelText.height;
        _tipTextField.y = _labelText.y + 24;
        _tipTextField.width = _width - _padding * 2;
        //_tipTextField.height = _height - _labelText.height - _padding * 2;
        _tipTextField.height = _height - 24 - _padding * 2;

        if(_preview != null)
        {
            _preview.x = _padding;
            _preview.y = _padding;
            _preview.width = _width - _padding * 2;
            _preview.height = _height - 80;

            _labelText.y = _preview.y + _preview.height;

            // readjust the tip text
            _tipTextField.y = _labelText.y + _labelText.height;
            _tipTextField.height -= _preview.height;
        } //


        switch (_displayPosition)
        {
            case "top":
                _arrow.rotation = 180;

                _container.x = -_container.width / 2;
                _container.y = -_arrowHeight - _container.height;

            case "bottom":
                _arrow.rotation = 0;

                _container.x = -_container.width / 2;
                _container.y = _arrowHeight;

            case "left":
                _arrow.rotation = 90;

                _container.x = -_arrowHeight - _container.width;
                _container.y = -_container.height / 2;

            case "right":
                _arrow.rotation = -90;

                _container.x = _arrowHeight;
                _container.y = -_container.height / 2;

            case "topLeft":
                _arrow.rotation = 180;

                _container.x = _arrowHeight + _padding - _container.width;
                _container.y = -_arrowHeight - _container.height;

            case "topRight":
                _arrow.rotation = 180;

                _container.x = -_arrowHeight - _padding;
                _container.y = -_arrowHeight - _container.height;

            case "bottomLeft":
                _arrow.rotation = 0;

                _container.x = _arrowHeight + _padding - _container.width;
                _container.y = _arrowHeight;

            case "bottomRight":
                _arrow.rotation = 0;

                _container.x = -_arrowHeight - _padding;
                _container.y = _arrowHeight;

            case "leftTop":
                _arrow.rotation = 90;

                _container.x = -_arrowHeight - _container.width;
                _container.y = _arrowHeight + _padding - _container.height;

            case "leftBottom":
                _arrow.rotation = 90;

                _container.x = -_arrowHeight - _container.width;
                _container.y = -_arrowHeight - _padding;

            case "rightTop":
                _arrow.rotation = -90;

                _container.x = _arrowHeight;
                _container.y = _arrowHeight + _padding - _container.height;

            case "rightBottom":
                _arrow.rotation = -90;

                _container.x = _arrowHeight;
                _container.y = -_arrowHeight - _padding;

            case "auto":
        } // end switch

    } // end function


    /**
	 * @inheritDoc
	 */
    override public function setSize(width:Float, height:Float):Void
    {
        super.setSize(width, height);
        positionAssets();
    } // end function

    //**************************************** SET AND GET ******************************************


    private function get_label():String
    {
        return _label;
    }

    private function set_label(value:String):String
    {
        _label = value;
        _labelText.text = value;
        return value;
    }


    private function get_tip():String
    {
        return _tipText;
    }

    private function set_tip(value:String):String
    {
        _tipText = value;
        _tipTextField.text = value;
        return value;
    }


    private function get_displayPosition():String
    {
        return _displayPosition;
    }

    private function set_displayPosition(value:String):String
    {
        _displayPosition = value;
        positionAssets();
        return value;
    }


    private function get_tooltipMode():BTooltipMode
    {
        return _tooltipMode;
    }

    private function set_tooltipMode(value:BTooltipMode):BTooltipMode
    {
        _tooltipMode = value;
        positionAssets();
        return value;
    }


    private function get_borderColor():Int
    {
        return _borderColor;
    }

    private function set_borderColor(value:Int):Int
    {
        _borderColor = value;
        draw();
        return value;
    }


    private function get_borderThickness():Int
    {
        return _borderThickness;
    }

    private function set_borderThickness(value:Int):Int
    {
        _borderThickness = value;
        draw();
        return value;
    }


    private function get_borderTransparency():Float
    {
        return _borderTransparency;
    }

    private function set_borderTransparency(value:Float):Float
    {
        _borderTransparency = value;
        draw();
        return value;
    }


    private function get_backgroundColor():Int
    {
        return _backgroundColor;
    }

    private function set_backgroundColor(value:Int):Int
    {
        _backgroundColor = value;
        draw();
        return value;
    }


    private function get_backgroundTransparency():Float
    {
        return _backgroundTransparency;
    }

    private function set_backgroundTransparency(value:Float):Float
    {
        _backgroundTransparency = value;
        draw();
        return value;
    }


    private function get_padding():Int
    {
        return _padding;
    }

    private function set_padding(value:Int):Int
    {
        _padding = value;
        draw();
        return value;
    }


    private function get_arrowHeight():Int
    {
        return _arrowHeight;
    }

    private function set_arrowHeight(value:Int):Int
    {
        _arrowHeight = value;
        draw();
        return value;
    }


    #if flash
	/**
	 * @inheritDoc
	 */
	@:setter(width)
    override private function set_width(value:Float):Void
    {
        super.width = value;
        positionAssets();
    }
    
    
    /**
	 * @inheritDoc
	 */
	@:setter(height)
    override private function set_height(value:Float):Void
    {
        super.height = value;
        positionAssets();
    }
	#else
    /**
	 * @inheritDoc
	 */
    override private function set_width(value:Float):Float
    {
        super.width = value;
        positionAssets();
        return value;
    }


    /**
	 * @inheritDoc
	 */
    override private function set_height(value:Float):Float
    {
        super.height = value;
        positionAssets();
        return value;
    }
    #end

}

