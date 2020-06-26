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

package borris.utils;

import borris.controls.BUIComponent;

import haxe.Timer;

import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.DropShadowFilter;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.text.TextFieldAutoSize;
import openfl.text.AntiAliasType;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 27/11/2017 (dd/mm/yyyy)
 */
class BStats extends BUIComponent
{
	private var _previousTime:Float;
	private var _frameNumber:Float;
	private var _fpsCount:Float;
	//private var _avgCount:Float;
	private var _fpsValue:Float = 0;
	private var _memoryValue:Float = 0;
	private var _fpsValues:Array<Float> = [0];
	private var _memoryValues:Array<Float> = [0];
	
	private var _fpsTextField:TextField;
	private var _memoryTextField:TextField;
	private var _textFields:Array<TextField> = [];
	private var _textHeight:Int = 15;
	
	private var _screen:Shape = new Shape();
	private var _graph:Shape = new Shape();
	private var _timer:Timer = new Timer(100);
	
	
	private var _extraStats:Array<Dynamic> = [];
	
	
	/**
	 * 
	 */
	public function new() 
	{
		super();
		
		_previousTime = Timer.stamp();
		_frameNumber = 0;
		_fpsCount = 0;
		
		// style UI
		_style.backgroundColor = 0x222222;
		_style.borderColor = 0x222222;
		_style.borderWidth = 5;
		setSize(160, 160);
		
		// create the text fields
		_fpsTextField = makeAndFormatTextField("Memory", 0x0099CC);
		_memoryTextField = makeAndFormatTextField("Memory", 0xFF0000);
		
		
		_screen.graphics.beginFill(0x000000, 1);
		_screen.graphics.drawRect(_style.borderWidth, _style.borderWidth, _width - _style.borderWidth * 2, _height - _style.borderWidth * 2 - _textHeight * 4);
		_screen.graphics.endFill();
		
		// add assets to there respective containers
		addChild(_screen);
		addChild(_graph);
		
		// event handling
		//addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
		addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		filters = [new DropShadowFilter(8, 90, 0x000000, 1, 8, 8, 0.5, 1)];
	}
	
	
	
	
	
	
	//**************************************** HANDLERS *********************************************


	override private function onAddedToStage(event:Event):Void
	{
		super.onAddedToStage(event);
		trace(stage.frameRate);
		var frameRate = stage.frameRate * 2;
		_timer = new Timer(Std.int(1000/frameRate));
		_timer.run = timerHandler;
	} // end function
	
	private function mouseHandler(event:MouseEvent):Void 
	{
		switch(event.type)
		{
			case MouseEvent.MOUSE_DOWN:
				startDrag();
				
			case MouseEvent.MOUSE_UP:
				stopDrag();
			
		} // end switch
		
	} // end function
	
	
	/**
	 * 
	 * @param	event
	 */
	private function timerHandler():Void
	{
		var currentTime:Float = Timer.stamp();
		var deltaTime:Float = (currentTime - _previousTime);
		
		//_fpsCount += deltaTime;
		_frameNumber++;

        // if more than 1 second has passed
		if (deltaTime > 1)
		{
			_fpsValue = (Math.floor((_frameNumber / deltaTime) * 10.0) / 10.0);
			_fpsTextField.text = "FPS: " + _fpsValue;
			_previousTime = currentTime;
			_frameNumber = 0;
			
			_memoryValue = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;
			//_memoryTextField.text = "Memory: " + Math.round(System.totalMemory / (1024 * 1024)) + "\tMB";
			_memoryTextField.text = "Memory: " + _memoryValue + "\tMB";

			// 
			for (extraStat in _extraStats)
			{
				var textField:TextField = extraStat.textField;
				textField.text = extraStat.name + ": " + extraStat.updateValue;
			} // end for
			
		} // end if

		// if more than 1/10 second has passed
		if (deltaTime > 0.1)
		{
			drawStats();
		}

	} // end function enterFrameHandler
	
	
	private function drawStats():Void
	{
		// 
		_fpsValues.push(_fpsValue);
		_memoryValues.push(_memoryValue);
		
		_graph.graphics.clear();
		_graph.graphics.moveTo(5, 5 + 90 - _fpsValue);
		_graph.graphics.lineStyle(1, 0x0099CC);
		var graphLength = Std.int(_fpsValues.length);
		
		for (i in 0...graphLength)
		{
			_graph.graphics.lineTo(5 + i, 5 + 90 -_fpsValues[i]);
			
		} // end for
		
		_graph.graphics.moveTo(5, 5 + 90 - _memoryValue);
		_graph.graphics.lineStyle(1, 0xFF0000);
		//var graphLength = Std.int(_fpsValues.length);
		
		for (i in 0...graphLength)
		{
			_graph.graphics.lineTo(5 + i, 5 + 90 -_memoryValues[i]);
			
		} // end for
		
		
		if (graphLength > _screen.width)
		{
			_fpsValues.shift();
			_memoryValues.shift();
		} // end if
		
		
		// extra
		for (extraStat in _extraStats)
		{
			var newValue = extraStat.updateValue;
			extraStat.values.push(newValue);
			
			_graph.graphics.moveTo(5, 5 + 90 - extraStat.updateValue);
			_graph.graphics.lineStyle(1, extraStat.graphColor);
			
			for (i in 0...graphLength)
			{
				_graph.graphics.lineTo(5 + i, 5 + 90 - extraStat.values[i]);
			} // end for
			
			if (graphLength > _screen.width)
			{
				extraStat.values.shift();
			} // end if
		} // end for
		
	} // end function
	
	
	private function makeAndFormatTextField(name:String, color:UInt = 0xFFFFFF):TextField
	{
		var textHeight:Float = 15;
		var textSize:Int = Std.int(textHeight - 3);
		
		// create a text format 
		var textFormat = new TextFormat("_sans", textSize, color, false);
		
		var textField = new TextField();
		textField.text = name + ": 0";
		textField.type = TextFieldType.DYNAMIC;
		textField.selectable = false;
		textField.width = 100;
		textField.height = textHeight;
		textField.setTextFormat(textFormat);
		textField.defaultTextFormat = textFormat;
		textField.mouseEnabled = false;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.name = name;
		addChild(textField);
		
		_textFields.push(textField);
		textField.x = 0;
		textField.y = _height - textHeight * (4 - _textFields.length + 1);
		
		return textField;
	} // end function
	
	
	public function addNewStat(name:String, updateValue:Float, graphColor:UInt, textColor:UInt = 0xFFFFFF):Void
	{
		var textField = makeAndFormatTextField(name, textColor);
		var values:Array<Float> = [0];
		_extraStats.push({name: name, updateValue: updateValue, graphColor: graphColor, textField: textField, values: values});
		
	} // end function
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}