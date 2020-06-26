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

import borris.controls.datePickerClasses.BDateCell;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.text.TextFormat;
import openfl.utils.Timer;


typedef Months = {
    var label:String;
    var data:Int;
}

/**
 * The Date picker class allows you to pick a date and highlights the current date using a calendar UI.
 * 
 * @author Rohaan Allport
 * @creation-date 01/30/2016 (dd/mm/yyyy)
 */
class BDatePicker extends BUIComponent
{
	/**
	 * Gets the current day.
	 */
    public var currentDay(get, never):String;
    
	/**
	 * Gets the current date.
	 */
	public var currentDate(get, never):Int;
    
	/**
	 * Gets the current month.
	 */
	public var currentMonth(get, never):String;
    
	/**
	 * Gets the current year.
	 */
	public var currentYear(get, never):Int;

	
    // constants
    private static var WEEK_DAYS:Array<String> = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    private static var MONTHS:Array<Months> = [
        {label: "January", data: 0}, 
        {label: "February",data:1}, 
        {label: "March",data:2}, 
        {label: "April", data:3}, 
        {label: "May", data:4}, 
        {label: "June", data:5}, 
        {label: "July", data:6}, 
        {label: "August", data:7}, 
        {label: "September", data:8}, 
        {label: "October", data:9}, 
        {label: "November", data: 10}, 
        {label: "December", data: 11}
		];
    // TODO modify for leap years
	private static var DAYS_OF_MONTHS:Array<Int> = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    
    
    // assets
    private var _monthPickerCB:BComboBox;  				// Combobox to pick a month.  
    private var _yearPickerNS:BNumericStepper;  		// Numeric stepper to pick a year.  
    
    private var _cellDaysContainer:Sprite;
    private var _cellMonthsContainer:Sprite;
    private var _cellYearsContainer:Sprite;
    
    private var _currentTimeLabel:BLabel;
    private var _currentDateLabel:BLabel;
    
    
    // style
	// TODO make these setters and getters?
    public var cellWidth:Int = 40;
    public var cellHeight:Int = 40;
    public var cellPadding:Int = 2;
    
    private var _currentTimeTF:TextFormat;
    private var _currentDateTF:TextFormat;
    
    
    // other
    private var _dateCells:Array<Dynamic> = new Array<Dynamic>();
    private var _currentDateTime:Date = Date.now();
    private var _firstDay:Date = Date.now();
    private var _firstDayColumn:Int = Date.now().getDay();
    private var _maxDays:Int;
    
    
    // set and get
    private var _currentDay:String;
    private var _currentDate:String;
    private var _currentMonth:String;
    private var _currentYear:Int;
    
    private var _selectedDay:String;
    private var _selectedMonth:String;
    private var _selectedYear:Int;
    
    private var _showCurrentTime:Bool = false;
    private var _showCurrentDate:Bool = false;
    
    
    
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
		_firstDay = new Date(_currentDateTime.getFullYear(), _currentDateTime.getMonth(), 1, 0, 0, 0);
		_firstDayColumn = _firstDay.getDay();
		
        super(parent, x, y);
		initialize();
        setSize((cellWidth + cellPadding) * 7 + 20 - cellPadding, 470);
    }


    //**************************************** HANDLERS *********************************************


    /**
	 * 
	 * @param	event
	 */
    private function pickMonth(event:Event):Void
    {
		var month:Int = cast((event.currentTarget), BComboBox).selectedItem.data;
		_firstDay = new Date(_currentDateTime.getFullYear(), month, 1, 0, 0, 0);
        monthsSetup();
    } // end function
    
    
    /**
	 * 
	 * 
	 * @param	event
	 */
    private function pickYear(event:Event):Void
    {
        var year:Int = Std.int(cast(event.target, BNumericStepper).value);
		_firstDay = new Date(year, _currentDateTime.getMonth(), 1, 0, 0, 0);
        monthsSetup();
    } // end function
    
    
    /**
	 * 
	 */
    private function onTick(event:TimerEvent):Void
    {
        var currentTime:Date = Date.now();
        
        var hours:Int = currentTime.getHours();
        var minutes:Int = currentTime.getMinutes();
        var seconds:Int = currentTime.getSeconds();
        
        var day:Int = currentTime.getDay();
        var month:Int = currentTime.getMonth();
        var date:Int = currentTime.getDate();
        var year:Int = currentTime.getFullYear();
        
        // set P.M/A.M
        var pm_amString:String;
        hours >= (12) ? pm_amString = "P.M":pm_amString = "A.M";
        
        // Set hour to 12 if the current time is in the hour or 12:00a.m
        // and set hpur to hour-12 if it is passed 12:00p.m (12 hr clock conversion)
        if (hours == 0) 
        {
            hours = 12;
        }
        // Set the text objects to the date values
        else if (hours > 12) 
        {
            hours -= 12;
        }
        
        
        
        hours < (10) ? _currentTimeLabel.text = "0" + Std.string(hours):_currentTimeLabel.text = Std.string(hours);
        minutes < (10) ? _currentTimeLabel.text += ":0" + Std.string(minutes):_currentTimeLabel.text += ":" + Std.string(minutes);
        seconds < (10) ? _currentTimeLabel.text += ":0" + Std.string(seconds):_currentTimeLabel.text += ":" + Std.string(seconds);
        _currentTimeLabel.text += "   " + pm_amString;
        
        _currentDateLabel.text = WEEK_DAYS[day] + ", " + MONTHS[month].label + " " + Std.string(date) + ", " + Std.string(year);
    } // end function
    
    
    
    //**************************************** FUNCTIONS ********************************************
    
    
    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();
        
        style.backgroundColor = 0x333333;
        style.backgroundOpacity = 0.7;

        // initialize assets
        // containers
        _cellDaysContainer = new Sprite();
        _cellMonthsContainer = new Sprite();
        _cellYearsContainer = new Sprite();
        
        _cellDaysContainer.y =
        _cellMonthsContainer.y =
        _cellYearsContainer.y = 140;
        
        _currentTimeLabel = new BLabel(this, 10, 10, "Current Time");
        _currentTimeLabel.textField.setTextFormat(new TextFormat("Roboto", 28, 0xFFFFFF, false));
        _currentTimeLabel.textField.defaultTextFormat = new TextFormat("Roboto", 28, 0xFFFFFF, false);
        _currentTimeLabel.width = 400;
        _currentTimeLabel.height = 50;
        
        _currentDateLabel = new BLabel(this, 10, 50, "Current Date");
        _currentDateLabel.textField.setTextFormat(new TextFormat("Roboto", 18, 0x3399CC, false));
        _currentDateLabel.textField.defaultTextFormat = new TextFormat("Roboto", 18, 0x3399CC, false);
        _currentDateLabel.width = 400;
        _currentDateLabel.height = 30;
        
        
        _monthPickerCB = new BComboBox(this, 10, 90);
        _monthPickerCB.listPlacement = BPlacement.BOTTOM;
        _monthPickerCB.setSize((cellWidth + cellPadding) * 7 - cellPadding, 40);
        for (i in 0...MONTHS.length)
		{
            _monthPickerCB.dropdown.addItem(MONTHS[i]);
        } // end for
        
        _yearPickerNS = new BNumericStepper(this, 10, 430);
        _yearPickerNS.buttonPlacement = BPlacement.HORIZONTAL;
        _yearPickerNS.editable = false;
        _yearPickerNS.setSize((cellWidth + cellPadding) * 7 - cellPadding, 40);
        _yearPickerNS.maximum = _currentDateTime.getFullYear() + 100;
        _yearPickerNS.minimum = _currentDateTime.getFullYear() - 100;
        _yearPickerNS.maxChars = 4;
        _yearPickerNS.value = _currentDateTime.getFullYear();
		// TODO find out why!
		#if (neko || cpp)
		_yearPickerNS.maximum = 2037;
        _yearPickerNS.minimum = 1970;
		#end
		
        
        
        makeDateCellGrid(10, 30);
        makeDaysLabels(10, 0);
        monthsSetup();
        _monthPickerCB.selectedIndex = _currentDateTime.getMonth();
        
        
        // add assets to respective containers
        addChildAt(_cellDaysContainer, 0);
        addChildAt(_cellMonthsContainer, 0);
        addChildAt(_cellYearsContainer, 0);


        // other
        var ticker:Timer = new Timer(1000);
        ticker.addEventListener(TimerEvent.TIMER, onTick);
        ticker.start();
        
        
        // event handling
        _monthPickerCB.addEventListener(Event.CHANGE, pickMonth);
        _yearPickerNS.addEventListener(Event.CHANGE, pickYear);
    } // end function

    
    /**
	 * Creates the cells for the date picker (42 cells, 6 rows, 7 columns), positions them
	 * and adds then to the date picker.
	 * 
	 * @param	x The x position to start the gird within the cells' parent container.
	 * @param	y The y position to start the gird within the cell's parent container.
	 */
    private function makeDateCellGrid(x:Int, y:Int):Void
    {
        var dateCell:BDateCell;
        
        for (i in 0...6)
		{
            for (j in 0...7)
			{
                dateCell = new BDateCell(_cellDaysContainer, (x + (cellWidth + cellPadding) * j), (y + (cellHeight + cellPadding) * i));
                dateCell.setSize(cellWidth, cellHeight);
                
                // put all date cells into and array for refrence
                _dateCells.push(dateCell);
            } // end for
        } // end for
    } // end function
    
    
    /**
	 * Creates the 7 "day labels" to be placed above the date cells.
	 * 
	 * @param	x The x position to start the labels within their parent container.
	 * @param	y The y position to start the labels within their parent container.
	 */
    private function makeDaysLabels(x:Float, y:Float):Void
    {
        //Add week day names
        for (i in 0...7)
		{
            var label:BLabel = new BLabel(_cellDaysContainer, (x + (cellWidth + cellPadding) * i), y, Std.string(WEEK_DAYS[i]).substring(0, 3));
        }
    } // end function
    
    
    /**
	 * Calls the arrangeDates(), prevMonthDates(), and nextMonthDates() functions.
	 */
    private function monthsSetup():Void
    {
        arrangeDates();
        prevMonthDates();
        nextMonthDates();
    } // ends function
    
    
    /**
	 * 
	 */
    private function arrangeDates():Void
    {
        var dateCell:BDateCell;
        
		//get column number for first day of the month
        if (_firstDay.getDay() == 0) 
        {
            //when last date of previous month is on saturday then move to second row
            _firstDayColumn = _firstDay.getDay() + 7;
        }
        else 
        {
            _firstDayColumn = _firstDay.getDay();
        }  
        
		//get max days for current month w.r.t leap year if any  
        _maxDays = _firstDay.getFullYear() % 4 == 0 && _firstDay.getMonth() == 1 ? 29 : DAYS_OF_MONTHS[_firstDay.getMonth()];
        
        //put dates for current month
        for (i in 0..._maxDays)
		{
            dateCell = _dateCells[_firstDayColumn + i];
            dateCell.label = Std.string((i + 1));
            dateCell.state = "currentMonth";
            
            // Highlight today
            if (_firstDay.getFullYear() == _currentDateTime.getFullYear() && _firstDay.getMonth() == _currentDateTime.getMonth()) 
            {
                if (dateCell.label == Std.string((_currentDateTime.getDate()))) 
                {
                    dateCell.state = "currentDay";
                }
            }
        } // end for
    } // end function
    
    
    /**
	 * Formats the cells that belong to the previous month by changing their state.
	 */
    private function prevMonthDates():Void
    {
        var dateCell:BDateCell;
        
        var prevMonthFirstDay:Date = new Date(_firstDay.getFullYear(), _firstDay.getMonth(), _firstDay.getDate() - 1, 0, 0, 0);
        
        var i:Int = _firstDayColumn - 1;
        while (i >= 0)
		{
            dateCell = _dateCells[i];
            
            dateCell.label = Std.string((prevMonthFirstDay.getDate() - ((_firstDayColumn - 1) - i)));
            dateCell.state = "normal";
            i--;
        } // end for
    } // end function
    
    
    /**
	 * Formats the cells that belong to the next month by changing their state.
	 */
    private function nextMonthDates():Void
    {
        var dateCell:BDateCell;
        
        for (i in 1...(42 - _maxDays - (_firstDayColumn - 1)))
		{
            dateCell = _dateCells[(_firstDayColumn - 1) + i + _maxDays];
            
            dateCell.label = Std.string(i);
            dateCell.state = "normal";
        } // end for
    } // end function
    
    
    
    //*************************************** SET AND GET **************************************
    
    
    private function get_currentDay():String
    {
        return WEEK_DAYS[_currentDateTime.getDay()];
    }
    
    
    private function get_currentDate():Int
    {
        return _currentDateTime.getDate();
    }
    
    
    private function get_currentMonth():String
    {
        /*var currentMonth:String;
			
			switch(currentDateTime.getMonth())
			{
				case 0:
					break;
			} // end switch
			*/
        return MONTHS[_currentDateTime.getMonth()].label;
    }
    
    
    private function get_currentYear():Int
    {
        return _currentDateTime.getFullYear();
    }
	
	// TODO implement selected values. eg selcedtedDate, selectedMonth, selectedDay, selectedYear etc...
	
	
} // end class

