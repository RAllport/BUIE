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

import Std;
import borris.containers.BPanel;
import borris.display.BTitleBarMode;
import borris.controls.colorChooserClasses.BColorBar;
import borris.controls.colorChooserClasses.BColorController;

import openfl.display.DisplayObjectContainer;
import openfl.display.GradientType;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 22/01/2016 (dd/mm/yyyy)
 */
class BColorChooserAdvanced extends BColorChooser
{
    // constants
    
    
    // assets
    //tabs
    private var _tabContainer:BPanel;
    private var _gimpTab:BTab = new BTab("Gimp");
    private var _barsTab:BTab = new BTab("Bars");
    private var _hueTab:BTab = new BTab("Hue");
    private var _swatchedTab:BTab = new BTab("Swatches");
    
    // radio buttons
    private var _hueRb:BRadioButton;
    private var _saturationRb:BRadioButton;
    private var _brightnessRb:BRadioButton;
    private var _redRb:BRadioButton;
    private var _greenRb:BRadioButton;
    private var _blueRb:BRadioButton;
    
    // text inputs
    private var _hueInputText:BTextInput;
    private var _satInputText:BTextInput;
    private var _brightnessInputText:BTextInput;
    private var _redInputText:BTextInput;
    private var _greenInputText:BTextInput;
    private var _blueInputText:BTextInput;
    
    // style
    private var _controlWidth:Int = 180;
    private var _barWidth:Int = 10;
    
    
    // other
    private var _canvas:Shape = new Shape();
    
    
    // gimp
    private var _gimpBar:BColorBar;
    private var _ctrl:BColorController;
    private var _hue:UInt = 0;
    private var _saturation:UInt = 0;
    private var _brightness:UInt = 0;
    private var _red:UInt = 0;
    private var _green:UInt = 0;
    private var _blue:UInt = 0;
    private var _selectedRBIndex:Int = 0;
    
    
    
    // set and get
    //protected var _changeImmediately:Boolean = true;
    //protected var _alphaEnabled:Boolean = false;
    //protected var _alpha:Number = 1;
    //protected var _alphaBar:BColorBar;
    //protected var _alphaMap:BitmapData;
    //protected var _alphaTile:AlphaTile;
    //protected var _alphaValue:InputText;
    
    
	/**
	 * Creates a new BColorChooserAdvanced component instance.
	 * 
	 * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will
	 * have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels.
     * This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels.
     * This value is calculated from the top.
	 * @param	value The color value to give this BColorChooserAdvanced
	 */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0, value:Int = 0xFF0000)
    {
        super();
        // constructor
        super(parent, x, y, value);
        
        // FIXME trace("RGB to HSB: " + Std.string(rgbTohsb(255, 200, 100)));
    } // end function
    
    
    //**************************************** HANDLERS *********************************************
    
    
    /**
	 * Shows the color spectrum.
	 * Called when the user clicks the swatch.
	 * 
	 * @param	event
	 */
    override private function showSpectrum(event:MouseEvent):Void
    {
        
        
    } // end function
    
    
    /**
	 * Hides the color specturm.
	 * Called when the user clicks anywhere on stage
	 * 
	 * @param	event
	 */
    override private function hideSpectrum(event:MouseEvent):Void
    {
        
        
    } // end function
    
    
    /**
	 * 
	 * 
	 * @param	event
	 */
    private function showWindow(event:MouseEvent):Void
    {
        _swatch.addEventListener(MouseEvent.MOUSE_DOWN, hideWindow);
        //event.stopImmediatePropagation();
        //tabContainer.activate();
        _tabContainer.x = this.x;
        _tabContainer.y = this.y + 30;
        if (_tabContainer.active) 
        {
            _tabContainer.close();
        }
        else 
        {
            _tabContainer.activate();
        }
    } // end function
    
    
    /**
     * 
     * @param	event
     */
    private function hideWindow(event:MouseEvent):Void
    {
        _swatch.removeEventListener(MouseEvent.MOUSE_DOWN, hideWindow);
        _tabContainer.close();
    } // end function
    
    
    /**
     * 
     * @param	event
     */
    private function onRadioButtonClick(event:MouseEvent):Void
    {
        //trace(BRadioButton(event.target).group.getRadioButtonIndex(event.target as BRadioButton));
        _selectedRBIndex = cast((event.target), BRadioButton).group.getRadioButtonIndex(try cast(event.target, BRadioButton) catch(e:Dynamic) null);
        
        
        
        // set m, ratios and alphas
        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(_barWidth, _controlWidth, Math.PI / 2, 0, 0);
        
        var colors:Array<UInt> = [];
        var ratios:Array<Int> = [0, 255];
        var alphas:Array<Float> = [1, 1];
        
        
        switch (_selectedRBIndex)
        {
            case 0:
                matrix.createGradientBox(_barWidth, _controlWidth, -Math.PI / 2, 0, 0);
                colors = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
                ratios = [];
                alphas = [];
                var part:Float = 0xFF / (colors.length - 1);
                
                for (i in 0...colors.length){
                    ratios.push(Std.int(part * i));
                    alphas.push(1);
                }
            
            case 1:
                colors = [0x000000, 0x000000];
                updateSaturation();
            
            case 2:
                colors = [0xFFFFFF, 0x000000];
            
            case 3:
                colors = [0xFF0000, 0x000000];
            
            case 4:
                colors = [0x00FF00, 0x000000];
            
            case 5:
                colors = [0x0000FF, 0x000000];
        } // end switch
        
        
        
        
        _canvas.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
        _canvas.graphics.drawRect(0, 0, _barWidth, _controlWidth + 1);
        
        // draw the to gimpBar
        _gimpBar.bitmapData.draw(_canvas);
    } // end function
    
    
    /**
	 * 
	 * @param	event
	 */
    private function onHueChange(event:Event):Void
    {
        update();
    } // end function
    
    
    /**
     * 
     * @param	event
     */
    private function onCtrlChange(event:Event):Void
    {
        /*switch (selectedRBIndex) 
			{
				case 0:  
					saturation = ctrl.valueX; 
					brightness = ctrl.valueY; 
					//_HSVupdated(); 
					break;
				
				case 1:  
					brightness = ctrl.valueX; 
					hue = ctrl.valueY; 
					//_HSVupdated(); 
					break;
				
				case 2:  
					hue = ctrl.valueX; 
					saturation = ctrl.valueY; 
					//_HSVupdated(); 
					break;
				
				case 3:  
					blue = ctrl.valueX * 255; 
					green = ctrl.valueY * 255; 
					//_RGBupdated(); 
					break;
				
				case 4:  
					red = ctrl.valueX * 255; 
					blue = ctrl.valueY * 255; 
					//_RGBupdated(); 
					break;
				
				default: 
					green = ctrl.valueX * 255; 
					red = ctrl.valueY * 255; 
					//_RGBupdated(); 
					break;
			} // end switch 
			//_updateColors(true, false);
			//_chooser.browseColorChoiceEx(value);*/
        
        
        update();
    } // end function
    
    
    
    //**************************************** FUNCTIONS ********************************************
    
    
    /**
	 * @inheritDoc
	 */
    override private function initialize():Void
    {
        super.initialize();
        
        _swatch.removeEventListener(MouseEvent.MOUSE_DOWN, showSpectrum);
        
        // initialize assets
        _tabContainer = new BPanel();
        _tabContainer.titleBarMode = BTitleBarMode.NONE;
        _tabContainer.minimizable = false;
        _tabContainer.maximizable = false;
        _tabContainer.draggable = false;
        _tabContainer.resizable = false;
        _tabContainer.minSize = new Point(240, 220);
        _tabContainer.x = this.x;
        _tabContainer.y = this.y + 30;
        _tabContainer.resize(480, 300, false);
        this.parent.addChild(_tabContainer);
        //trace("tab container stage width: " + tabContainer.stage.stageWidth);
        
        var tabGroup:BTabGroup = new BTabGroup("adv color chooser tabs");
        tabGroup.addTab(_gimpTab);
        tabGroup.addTab(_barsTab);
        tabGroup.addTab(_hueTab);
        tabGroup.addTab(_swatchedTab);
        tabGroup.parent = _tabContainer.content;
        tabGroup.setContentSize(420, 220);
        
        _hueRb = new BRadioButton(_gimpTab.content, 130, 10, "H:", true);
        _saturationRb = new BRadioButton(_gimpTab.content, 130, 40, "S:");
        _brightnessRb = new BRadioButton(_gimpTab.content, 130, 70, "B:");
        _redRb = new BRadioButton(_gimpTab.content, 130, 110, "R:");
        _greenRb = new BRadioButton(_gimpTab.content, 130, 140, "G:");
        _blueRb = new BRadioButton(_gimpTab.content, 130, 170, "B:");
        
        // make a radio button group
        var gimpRbGroup:BRadioButtonGroup = new BRadioButtonGroup("gimp rb group");
        gimpRbGroup.addRadioButton(_hueRb);
        gimpRbGroup.addRadioButton(_saturationRb);
        gimpRbGroup.addRadioButton(_brightnessRb);
        gimpRbGroup.addRadioButton(_redRb);
        gimpRbGroup.addRadioButton(_greenRb);
        gimpRbGroup.addRadioButton(_blueRb);
        //gimpRbGroup.selection = hueRb;
        _hueRb.selected = true;
        
        _hueInputText = new BTextInput(_gimpTab.content, 190, 10, "100");
        _hueInputText.width = 50;
        _hueInputText.height = 24;
        _hueInputText.restrict = "0-9";
        _hueInputText.maxChars = 3;
        
        _satInputText = new BTextInput(_gimpTab.content, 190, 40, "100");
        _satInputText.width = 50;
        _satInputText.height = 24;
        _satInputText.restrict = "0-9";
        _satInputText.maxChars = 3;
        
        _brightnessInputText = new BTextInput(_gimpTab.content, 190, 70, "100");
        _brightnessInputText.width = 50;
        _brightnessInputText.height = 24;
        _brightnessInputText.restrict = "0-9";
        _brightnessInputText.maxChars = 3;
        
        _redInputText = new BTextInput(_gimpTab.content, 190, 110, "255");
        _redInputText.width = 50;
        _redInputText.height = 24;
        _redInputText.restrict = "0-9";
        _redInputText.maxChars = 3;
        
        _greenInputText = new BTextInput(_gimpTab.content, 190, 140, "255");
        _greenInputText.width = 50;
        _greenInputText.height = 24;
        _greenInputText.restrict = "0-9";
        _greenInputText.maxChars = 3;
        
        _blueInputText = new BTextInput(_gimpTab.content, 190, 170, "255");
        _blueInputText.width = 50;
        _blueInputText.height = 24;
        _blueInputText.restrict = "0-9";
        _blueInputText.maxChars = 3;
        
        var alphaSlider:BSlider = new BSlider(BOrientation.VERTICAL, _tabContainer.content, 390, 40);
        alphaSlider.height = _controlWidth;
        alphaSlider.snapInterval = 1;
        
        var alphaNs:BNumericStepper = new BNumericStepper(_tabContainer.content, 350, 240);
        alphaNs.editable = true;
        alphaNs.minimum = 0;
        alphaNs.maximum = 100;
        //alphaNs.setSize(60, 24);
        alphaNs.buttonPlacement = BPlacement.HORIZONTAL;
        
        
        
        
        // set m, ratios and alphas
        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(_barWidth, _controlWidth, -Math.PI / 2, 0, 0);
        
        var colors:Array<UInt> = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
        var part:Float = 0xFF / (colors.length - 1);
        var ratios:Array<Int> = [];
        var alphas:Array<Float> = [];
        
        for (i in 0...colors.length)
        {
            ratios.push(Std.int(part * i));
            alphas.push(1);
        } // end for
        
        
        
        _canvas.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
        _canvas.graphics.drawRect(0, 0, _barWidth, _controlWidth + 1);
        
        _gimpBar = new BColorBar(_gimpTab.content, 100, 10, _barWidth, _controlWidth);
        _gimpBar.bitmapData.draw(_canvas);
        _gimpBar.valueXY(0.5, 1);
        
        _ctrl = new BColorController(_gimpTab.content, -100, 10, _controlWidth, _controlWidth);
        //ctrl.bitmapData.fillRect(ctrl.bitmapData.rect, 0xff0000ff);
        
        
        update();
        
        //ctrl.addEventListener(Event.CHANGE, function(event:Event):void
        /*gimpBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				//trace(ctrl.bitmapData.getPixel(BColorController(event.currentTarget).valueX * (controlWidth - 1), BColorController(event.currentTarget).valueY * -controlWidth + controlWidth).toString(16));
				//trace(gimpBar.bitmapData.getPixel(BColorController(event.currentTarget).valueX * barWidth, BColorController(event.currentTarget).valueY * -controlWidth + controlWidth).toString(16));
				trace(gimpBar.hexValue);
			});*/
        
        
        // add assets to respective containers
        
        
        
        // event handling
        _swatch.addEventListener(MouseEvent.MOUSE_DOWN, showWindow);
        _hueRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
        _saturationRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
        _brightnessRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
        _redRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
        _greenRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
        _blueRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
        _gimpBar.addEventListener(Event.CHANGE, onHueChange);
        _ctrl.addEventListener(Event.CHANGE, onCtrlChange);
    } // end function
    
    
    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        super.draw();
    } // emd function
    
    
    /**
	 * Updates the hue, saturation, brightness, red ccolor channel, green color channel, blue color channel, 
	 * alpha channel, and full ARGB color value.
	 */
    private function update():Void
    {
        // draw the ctrl BColorController
        var colorGrad:Shape = new Shape();
        var lightGrad:Shape = new Shape();
        var lightMatrix:Matrix = new Matrix();
        
        colorGrad.graphics.beginFill(_gimpBar.value, 1);
        colorGrad.graphics.drawRect(0, 0, 200, 200);
        lightMatrix.createGradientBox(_controlWidth, _controlWidth, Math.PI / 2, 0, 0);
        
        var m2:Matrix = new Matrix();
        m2.createGradientBox((_controlWidth - 1), _controlWidth);
        lightGrad.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], [1, 0], [0, 255], m2);
        lightGrad.graphics.drawRect(0, 0, _controlWidth, _controlWidth);
        
        lightGrad.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [0, 1], [0, 255], lightMatrix);
        lightGrad.graphics.drawRect(0, 0, _controlWidth, _controlWidth);
        
        //ctrl.bitmapData.fillRect(ctrl.bitmapData.rect, gimpBar.value);
        _ctrl.bitmapData.draw(colorGrad);
        _ctrl.bitmapData.draw(lightGrad);
        
        
        
        
        // calculate the hue (0-360), saturation (0-100) and brightness (0-100)
        _hue = Std.int(_gimpBar.valueY * 360);
        _saturation = Std.int(_ctrl.valueX * 100);
        _brightness = Std.int(_ctrl.valueY * 100);
        
        // separate the color channels
        //var alpha:uint = (colorValue >> 24) & 0xFF;  	// Isolate the Alpha channel
        _red = (_ctrl.value >> 16) & 0xFF;  // Isolate the Red channel  
        _green = (_ctrl.value >> 8) & 0xFF;  // Isolate the Green channel  
        _blue = _ctrl.value & 0xFF;  // Isolate the Blue channel  
        
        // update the text inputs
        _hueInputText.text = Std.string(_hue);
        _satInputText.text = Std.string(_saturation);
        _brightnessInputText.text = Std.string(_brightness);
        _redInputText.text = Std.string(_red);
        _greenInputText.text = Std.string(_green);
        _blueInputText.text = Std.string(_blue);
        
        _inputText.text = Std.string(_ctrl.value);
        
        // draw the swatch
        _swatch.graphics.clear();
        _swatch.graphics.beginFill(0xFFFFFF);
        _swatch.graphics.drawRect(0, 0, 20, 20);
        _swatch.graphics.beginFill(_ctrl.value);
        _swatch.graphics.drawRect(1, 1, 18, 18);
        _swatch.graphics.endFill();
    } // end function
    
    
    /**
	 * 
	 */
    private function updateHue():Void
    {
        
        
    } // end function
    
    
    /**
	 * 
	 */
    private function updateSaturation():Void
    {
        // set m, ratios and alphas
        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(_controlWidth, _controlWidth, 0, 0, 0);
        
        var colors:Array<UInt> = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
        var part:Float = 0xFF / (colors.length - 1);
        var ratios:Array<Int> = [];
        var alphas:Array<Float> = [];
        
        for (i in 0...colors.length){
            ratios.push(Std.int(part * i));
            alphas.push(1);
        } // draw the ctrl BColorController
        
        
        
        
        
        var colorGrad:Shape = new Shape();
        var lightGrad:Shape = new Shape();
        var lightMatrix:Matrix = new Matrix();
        
        colorGrad.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
        colorGrad.graphics.drawRect(0, 0, _controlWidth, _controlWidth);
        lightMatrix.createGradientBox(_controlWidth, _controlWidth, Math.PI / 2, 0, 0);
        
        var m2:Matrix = new Matrix();
        m2.createGradientBox((_controlWidth - 1), _controlWidth);
        lightGrad.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0x000000], [-_gimpBar.valueY + 1, 1], [0, 255], lightMatrix);
        lightGrad.graphics.drawRect(0, 0, _controlWidth, _controlWidth);
        
        _ctrl.bitmapData.draw(colorGrad);
        _ctrl.bitmapData.draw(lightGrad);
    } // end function
    
    
    /**
	 * 
	 */
    private function updateBrightness():Void
    {
        
        
    } // end function
    
    
    /**
	 * 
	 */
    private function updateRed():Void
    {
        
        
    } // end function
    
    
    /**
	 * 
	 */
    private function updateGreen():Void
    {
        
        
    } // end function
    
    
    /**
	 * 
	 */
    private function updateBlue():Void
    {
        
        
    } // end function
} // end class



/**
 * Class for hsbTorgb
 */
@:final class ClassForHsbTorgb
{

    /**
     * Convert HSV (hue, saturation, brightness) to RGB (red, green, blue)
     *
     * @param	h
     * @param	s
     * @param	b
     * @return
     */
    private function hsbTorgb(h:Float, s:Float, b:Float):Int
    {
        // FIXME var ht:Float = (h - Std.int(h) + Std.int(h < 0)) * 6;
        var ht:Float = 0;
        var hi:Int = Std.int(ht);
        var vt:Float = b * 255;
        
        /*switch(hi)
        {
            // FIXME case 0:return 0xff000000 | (vt << 16) | (Std.int(vt * (1 - (1 - ht + hi) * s)) << 8) | Std.int(vt * (1 - s));
            // FIXME case 1:return 0xff000000 | (vt << 8) | (Std.int(vt * (1 - (ht - hi) * s)) << 16) | Std.int(vt * (1 - s));
            // FIXME case 2:return 0xff000000 | (vt << 8) | Std.int(vt * (1 - (1 - ht + hi) * s)) | (Std.int(vt * (1 - s)) << 16);
            // FIXME case 3:return 0xff000000 | vt | (Std.int(vt * (1 - (ht - hi) * s)) << 8) | (Std.int(vt * (1 - s)) << 16);
            // FIXME case 4:return 0xff000000 | vt | (Std.int(vt * (1 - (1 - ht + hi) * s)) << 16) | (Std.int(vt * (1 - s)) << 8);
            // FIXME case 5:return 0xff000000 | (vt << 16) | Std.int(vt * (1 - (ht - hi) * s)) | (Std.int(vt * (1 - s)) << 8);
        } // end function*/
        
        return 0;
    }

    public function new()
    {
    }
} // end class


/**
 * Class for rgbTohsb
 */
@:final class ClassForRgbTohsb
{
    
    
    /**
 * Convert RGB (red, green, blue) values to HSV (hue, saturation, brightness)
 * 
 * @param	r
 * @param	g
 * @param	b
 * @return
 */
    private function rgbTohsb(r:Int, g:Int, b:Int):Int
    {
        // h:12bit,s:10bit,v:8bit
        var max:Int = Std.int(Math.max(Math.max(r, g), b));
        var min:Int = Std.int(Math.min(Math.min(r, g), b));
        var sv:Int;
        
        
        
        if (max == min) 
            return max;
        
        sv = (Std.int((max - min) * 1023 / max) << 8) | max;
        
        if (b == max) 
            return (Std.int((r - g) * 682.6666666666666 / (max - min) + 2730.6666666666665) << 18) | sv;
        
        if (g == max) 
            return (Std.int((b - r) * 682.6666666666666 / (max - min) + 1365.3333333333332) << 18) | sv;
        
        if (g >= b) 
            return (Std.int((g - b) * 682.6666666666666 / (max - min)) << 18) | sv;
        
        return (Std.int(4096 + (g - b) * 682.6666666666666 / (max - min)) << 18) | sv;
    }

    public function new()
    {
    }
} // end class



