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

import openfl.display.BitmapData;
import openfl.display.DisplayObjectContainer;
import openfl.display.GradientType;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;


/**
 * The BColorChooser component displays a text input and switch button from which the user can select a color.
 * 
 * <p>By default, the component displays a single swatch of color on a square button. When the user clicks this 
 * button, a panel opens to display a rectangular color spectrum.</p>
 * 
 * @author Rohaan Allport
 * @creation-date 14/05/2015 (dd/mm/yyyy)
 */
class BColorChooser extends BUIComponent
{
    /**
	 * Gets or sets a Boolean value that indicates whether the internal text field of the ColorPicker component is0
	 * editable.
	 * A value of <code>true</code> indicates that the internal text field is editable; 
	 * a value of <code>false</code> indicates that it is not.
	 * 
	 * @default true
	 */
    public var editable(get, set):Bool;

    /**
	 * gets or sets whether the internal input text should be displayed.
	 */
    public var showTextField(get, set):Bool;

    /**
	 * Gets the string value of the current color selection.
	 */
    public var hexValue(get, never):String;

    /**
	 * Gets or sets value of the swatch color.
	 */
    public var value(get, set):Int;


    // constants

    // assets
    private var _colorsContainer:Sprite; // The sprite for drawing the color sppectrum into.
    private var _inputText:BTextInput; // The input text located right next to the swatch for manually typin gin a color
    private var _swatch:Sprite; // The main swatch of the color chooser

    // other
    private var _colors:Array<UInt> = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000]; //
    private var _part:Float = 0xFF / 6; //
    private var _ratios:Array<Int> = []; //
    private var _alphas:Array<Float> = []; //
    private var _m:Matrix = new Matrix(); //
    private var _bitmapData:BitmapData; //

    private var _oldColor:Int; //
    private var _tempColor:Int; //


    // set and get
    private var _value:Int = 0xff0000; //


    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BColorChooser component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will
     * have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels.
     * This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels.
     * This value is calculated from the top.
	 * @param	value The color value of the color chooser in hexadecimal.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, value:Int = 0xFF0000)
    {
        // constructor code
        _part = 0xFF / (_colors.length - 1);
        _value = value;

        super(parent, x, y);
        initialize();
        setSize(100, 20);
        draw();
    }


    //**************************************** HANDLERS *********************************************

    /**
	 * Change the swatch color and value when the user changes the text in the input text.
	 */
    private function onInputChange(event:Event):Void
    {
        // prevent processing of event listeners in the current node and event flow
        event.stopImmediatePropagation();

        // set old color to value
        _oldColor = _value;

        // convert text to a number in base 16
        _value = Std.parseInt("0x" + _inputText.text);

        // set input text to uppercase
        _inputText.text = _inputText.text.toUpperCase();

        // redraw the color chooser (although only the swatch needs to redraw)
        draw();

        // dispatch a new change event
        dispatchEvent(new Event(Event.CHANGE));

    } // end onInputChange


    /**
	 * Shows the color spectrum.
	 * Called when the user clicks the swatch.
	 */
    private function showSpectrum(event:MouseEvent):Void
    {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, hideSpectrum);
        event.stopImmediatePropagation();
        _colorsContainer.visible = !_colorsContainer.visible;
    } // end function showSpectrum


    /**
	 * Hides the color specturm.
	 * Called when the user clicks anywhere on stage
	 */
    private function hideSpectrum(event:MouseEvent):Void
    {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, hideSpectrum);
        _colorsContainer.visible = false;
    } // end function hideSpectrum


    /**
	 * Change the visibility for the colors container
	 */
    private function displaySpectrum():Void
    {
        _colorsContainer.visible = !_colorsContainer.visible;
    } // end function displaySpectrum

    /**
	 * Update the swatch color as the mouse moves over the color spectrum.
	 */
    private function updateSwatch(event:MouseEvent):Void
    {
        value = _bitmapData.getPixel(Std.int(_colorsContainer.mouseX), Std.int(_colorsContainer.mouseY));
        dispatchEvent(new Event(Event.CHANGE));
    } // end function updateSwatch


    //************************************* FUNCTIONS ******************************************


    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();

        // initialize text input
        _inputText = new BTextInput(this, 0, 0, "");
        _inputText.width = 50;
        _inputText.height = 20;
        _inputText.restrict = "0123456789ABCDEFabcdef";
        _inputText.maxChars = 6;

        // initialize swatch
        _swatch = new Sprite();
        _swatch.x = 60;
        //swatch.filters = [new DropShadowFilter(2, 45, 0x000000, 1, 4, 4, 1, 1, true)];
        _swatch.tabEnabled = true;

        _colorsContainer = new Sprite();
        _colorsContainer.x = 60;
        _colorsContainer.y = 30;

        //
        value = _value;


        // set m, ratios and alphas
        _m.createGradientBox(250, 180);
        for(i in 0..._colors.length)
        {
            _ratios.push(cast _part * i);
            _alphas.push(1);
        }

        var colorGrad:Shape = new Shape();
        var lightGrad:Shape = new Shape();
        var lightMatrix:Matrix = new Matrix();
        lightMatrix.createGradientBox(250, 180, Math.PI / 2, 0, 0);
        colorGrad.graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, _m);
        colorGrad.graphics.drawRect(0, 0, 250, 180);
        lightGrad.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0x000000, 0x000000], [1, 0, 0, 1], [0, 127, 128, 255], lightMatrix);
        lightGrad.graphics.drawRect(0, 0, 250, 180);


        // add assets and containers the stage
        _colorsContainer.addChild(colorGrad);
        _colorsContainer.addChild(lightGrad);

        //
        addChild(_inputText);
        addChild(_swatch);
        addChild(_colorsContainer);

        //
        _bitmapData = new BitmapData(250, 180);
        _bitmapData.draw(_colorsContainer);

        _colorsContainer.visible = false;

        // event handling
        _inputText.addEventListener(Event.CHANGE, onInputChange);
        _swatch.addEventListener(MouseEvent.MOUSE_DOWN, showSpectrum);
        _colorsContainer.addEventListener(MouseEvent.MOUSE_MOVE, updateSwatch);
    } // end function initialize


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        //_value = 0xff0000;
        super.draw();
        _swatch.graphics.clear();
        _swatch.graphics.beginFill(0xFFFFFF);
        _swatch.graphics.drawRect(0, 0, 20, 20);
        _swatch.graphics.beginFill(_value);
        _swatch.graphics.drawRect(1, 1, 18, 18);
        _swatch.graphics.endFill();
    } // end function draw


    /**
	 * Shows the color palette.
	 */
    public function openPalette():Void
    {
        _colorsContainer.visible = true;
        dispatchEvent(new Event(Event.OPEN));
    } // end function openPalette


    /**
	 * Hides the color palette. 
	 */
    public function closePalette():Void
    {
        _colorsContainer.visible = false;
        dispatchEvent(new Event(Event.CLOSE));
    } // end function closePalette


    //***************************************** SET AND GET *****************************************


    private function get_editable():Bool
    {
        return _inputText.editable;
    }

    private function set_editable(value:Bool):Bool
    {
        _inputText.editable = value;
        return value;
    }


    private function get_showTextField():Bool
    {
        return _inputText.visible;
    }

    private function set_showTextField(value:Bool):Bool
    {
        _inputText.visible = value;
        _swatch.x = (value) ? 60 : 10;
        return value;
    }


    private function get_hexValue():String
    {
        //return Std.string(_value);
        return StringTools.hex(_value);
    }


    private function get_value():Int
    {
        return _value;
    }

    private function set_value(val:Int):Int
    {
        _inputText.text = StringTools.hex(val, 6);
        _value = Std.parseInt("0x" + _inputText.text);

        // redraw the color chooser (although only the swatch needs to redraw)
        draw();
        return _value;
    }

}

