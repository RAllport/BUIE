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

package;

import borris.BUIEDemo;
import borris.containers.BBaseScrollPane;
import borris.containers.BCanvas;
import borris.containers.BFlexBox;
import borris.containers.BPanel;
import borris.containers.BPanelBounds;
import borris.containers.BScrollPane;
import borris.controls.BBaseButton;
import borris.controls.BButton;
import borris.controls.BComboBox;
import borris.controls.BDatePicker;
import borris.controls.BLabel;
import borris.controls.BLabelButton;
import borris.controls.BList;
import borris.controls.BListItem;
import borris.controls.BOrientation;
import borris.controls.BPlacement;
import borris.controls.BRangeSlider;
import borris.controls.BScrollBar;
import borris.controls.BSlider;
import borris.controls.BTab;
import borris.controls.BTabGroup;
import borris.controls.BToggleButton;
import borris.controls.windowClasses.BTitleBar;
import borris.controls.BUIComponent;
import borris.desktop.BNativeWindow;
import borris.display.BElement;
import borris.display.BElement;
import borris.display.BProgressBarMode;
import borris.display.BStyle;
import borris.display.BTitleBarMode;
import borris.events.BStyleEvent;
import borris.menus.BApplicationMenu;
import borris.menus.BCircleMenu;
import borris.menus.BContextMenu;
import borris.menus.BMenu;
import borris.menus.BMenuItem;
import borris.ui.BMouseCursor;
import borris.utils.BStats;
import borris.utils.BBuieXmlParser;
import borris.utils.BCSSParser;

import motion.Actuate;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.ProgressEvent;
import openfl.events.TextEvent;
import openfl.events.TimerEvent;
import openfl.events.TouchEvent;
import openfl.filters.DropShadowFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;
import openfl.utils.Timer;


// _TODO use color scheme _TODO default colors
// _FIXME CC9900
// _BUG CC0000
// _NOTE: 66CC33

// PLugins:
    // Haxe Toolkit Support
    // CodeGlance
    // Statistic
/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date  (dd/mm/yyyy)
 */
class Main_old extends Sprite
//class Main_old extends lime.app.Application
{
    private var newWindow:BPanel;
    //private var mainWindow:BPanel;
    //private var newWindow2:BPanel;

    // menus
    //private var mainMenu:BApplicationMenu;
    private var mainMenu:BMenu;
    private var rightClickMenu:BContextMenu;
    private var rightClickMenu2:BCircleMenu;
    //private var rightClickMenu2:BCircleMenu;


    public function new()
    {
        super();
        //BCSSParser.parseCSS();
        var _stats:BStats = new BStats();
        //TODO add this back addChild(_stats);

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT; // set the alignment to the top left
        //stage.frameRate = 120;

        /*mainWindow = new BPanel("Main Window");
		addChild(mainWindow);
		mainWindow.activate();
		
		newWindow = new BPanel("New Window");
		addChild(newWindow);
		newWindow.activate();
		
		newWindow2 = new BPanel("New Window 2");
		mainWindow.content.addChild(newWindow2);
		newWindow2.activate();*/

        initialiazeDemo();
        //initializeMenu();
        //initializeButtons();
        //initializePanels();
        //testXML();
        //adrianSucks();


        // testing
        //var window = new lime.ui.Window({width: 500, height: 500});
        //window.create(Application.current);
        // end testing

        //var tf:TextFormat = new TextFormat("Calibri", 16, 0xFFFFFF);
        //var text:TextField = new openfl.text.TextField();

    }

    private function initialiazeDemo():Void
    {
        var demo:BUIEDemo = new BUIEDemo();
        addChild(demo);
    }

    private function initializeMenu():Void
    {
        // make a main menu
        mainMenu = new BApplicationMenu(false);
        //mainMenu = new BContextMenu();
        mainMenu.display(this.stage, 200, 100);
        //newWindow.bMenu = mainMenu;

        var mainMenuFileItem:BMenuItem = new BMenuItem("File", false);
        mainMenuFileItem.keyEquivalentModifiers = [Keyboard.ALTERNATE];
        mainMenuFileItem.keyEquivalent = "A";

        // add items to mainMenu
        mainMenu.addItem(mainMenuFileItem);
        mainMenu.addItem(new BMenuItem("Edit", false));
        mainMenu.addItem(new BMenuItem("View", false));
        mainMenu.addItem(new BMenuItem("Windos", false));
        mainMenu.addItem(new BMenuItem("Help", false));
        mainMenu.addItem(new BMenuItem("", true));

        var submenu2:BContextMenu = new BContextMenu();
        submenu2.addItem(new BMenuItem("Menu Item 1", false));
        submenu2.addItem(new BMenuItem("Menu Item 2", false));
        submenu2.addItem(new BMenuItem("Menu Item 3", false));
        submenu2.addItem(new BMenuItem("Menu Item 4", false));
        submenu2.addItem(new BMenuItem("", true));
        submenu2.addItem(new BMenuItem("Menu Item 5", false));
        submenu2.addItem(new BMenuItem("Menu Item 6", false));

        var submenu3:BContextMenu = new BContextMenu();
        submenu3.addItem(new BMenuItem("Menu Item 1", false));
        submenu3.addItem(new BMenuItem("Menu Item 2", false));
        submenu3.addItem(new BMenuItem("Menu Item 3", false));
        submenu3.addItem(new BMenuItem("Menu Item 4", false));
        submenu3.addItem(new BMenuItem("", true));
        submenu3.addItem(new BMenuItem("Menu Item 5", false));
        submenu3.addItem(new BMenuItem("Menu Item 6", false));

        var editMenu:BContextMenu = new BContextMenu();
        editMenu.addItem(new BMenuItem("Undo", false, true));
        editMenu.addItem(new BMenuItem("Redo", false, false));
        editMenu.addItem(new BMenuItem("", true));
        editMenu.addItem(new BMenuItem("Cut", false, false));
        editMenu.addItem(new BMenuItem("Copy", false, false));
        editMenu.addItem(new BMenuItem("Paste", false, false));
        editMenu.addItem(new BMenuItem("Paste Special", false, false));
        editMenu.addItem(new BMenuItem("Clear", false, false));
        editMenu.addItem(new BMenuItem("", true, false));
        editMenu.addItem(new BMenuItem("Duplicate", false, false));
        editMenu.addItem(new BMenuItem("Select All", false, false));

        editMenu.getItemByLabel("Undo").keyEquivalentModifiers = [Keyboard.ALTERNATE];
        editMenu.getItemByLabel("Undo").keyEquivalent = "z";
        editMenu.getItemByLabel("Redo").keyEquivalentModifiers = [Keyboard.ALTERNATE, Keyboard.SHIFT, Keyboard.CONTROL];
        editMenu.getItemByLabel("Redo").keyEquivalent = "y";
        editMenu.getItemByLabel("Undo").keyEquivalentModifiers = [Keyboard.ALTERNATE, Keyboard.SHIFT, Keyboard.CONTROL];

        var viewMenu:BContextMenu = new BContextMenu();
        viewMenu.addItem(new BMenuItem("Goto", false, true));
        viewMenu.addItem(new BMenuItem("", true));
        viewMenu.addItem(new BMenuItem("Zoom In", false, true));
        viewMenu.addItem(new BMenuItem("Zoom Out", false, true));
        viewMenu.addItem(new BMenuItem("Magnification", false, true));
        viewMenu.addItem(new BMenuItem("", true, false));
        viewMenu.addItem(new BMenuItem("Rulers", false, false));
        viewMenu.addItem(new BMenuItem("Grid", false, false));

        var magnificationSubmenu:BContextMenu = new BContextMenu();
        magnificationSubmenu.addItem(new BMenuItem("Fit in Window", false, true));
        magnificationSubmenu.addItem(new BMenuItem("Center the Stage", false, true));
        magnificationSubmenu.addItem(new BMenuItem("", true));
        magnificationSubmenu.addItem(new BMenuItem("25%", false, true));
        magnificationSubmenu.addItem(new BMenuItem("50%", false, true));
        magnificationSubmenu.addItem(new BMenuItem("100%", false, true));
        magnificationSubmenu.addItem(new BMenuItem("200%", false, false));
        magnificationSubmenu.addItem(new BMenuItem("400%", false, false));
        magnificationSubmenu.addItem(new BMenuItem("800%", false, false));
        magnificationSubmenu.addItem(new BMenuItem("", true, false));
        magnificationSubmenu.addItem(new BMenuItem("Show All", false, false));

        mainMenuFileItem.submenu = submenu2;
        mainMenu.getItemAt(1).submenu = editMenu;
        mainMenu.getItemAt(2).submenu = viewMenu;
        viewMenu.getItemByLabel("Magnification").submenu = magnificationSubmenu;

        submenu2.getItemAt(5).submenu = submenu3;

        // make an arbitray right click menu
        rightClickMenu = new BContextMenu();
        rightClickMenu2 = new BCircleMenu();
        rightClickMenu2.display(this.stage, 700, 400);
        rightClickMenu2.addItem(new BMenuItem("Cuttt", false));
        rightClickMenu2.addItem(new BMenuItem("Copy", false));
        rightClickMenu2.addItem(new BMenuItem("Paste", false));
        //rightClickMenu2.addItem(new BMenuItem("Clear", false));

        var nMI:BMenuItem = new BMenuItem("Menu item test", false);
        nMI.checked = true;
        nMI.enabled = false;
        nMI.keyEquivalentModifiers = [Keyboard.ALTERNATE];
        nMI.keyEquivalent = "A";

        // make a submenu for one of the items in the rightClickMenu
        var submenu1:BContextMenu = new BContextMenu();
        submenu1.addItem(new BMenuItem("Menu Item 1", false));
        submenu1.addItem(new BMenuItem("Menu Item 2", false));
        submenu1.addItem(new BMenuItem("Menu Item 3", false));
        submenu1.addItem(new BMenuItem("Menu Item 4", false));
        submenu1.addItem(new BMenuItem("", true));
        submenu1.addItem(new BMenuItem("Menu Item 5", false));
        submenu1.addItem(new BMenuItem("Menu Item 6", false));


        //var nMI2: BMenuItem = new BMenuItem("Menu item test 2 is a long menu item", false);
        var nMI2:BMenuItem = new BMenuItem("Tooooo long!", false);
        nMI2.checked = true;
        nMI2.enabled = true;
        nMI2.keyEquivalentModifiers = [Keyboard.SHIFT, Keyboard.ALTERNATE];
        nMI2.keyEquivalent = "K";
        nMI2.icon = null;
        nMI2.submenu = submenu1;

        var nMI3:BMenuItem = new BMenuItem("Menu item test 3", false);
        nMI3.checked = false;
        nMI3.enabled = true;
        nMI3.keyEquivalentModifiers = [Keyboard.CONTROL, Keyboard.SHIFT, Keyboard.ALTERNATE];
        nMI3.keyEquivalent = "u";
        //nMI3.icon = new AddIcon();
        //nMI3.icon = new ArrowIcon();
        //nMI3.icon = new EditDeleteIcon();

        rightClickMenu.addItem(new BMenuItem("Cut", false));
        rightClickMenu.addItem(new BMenuItem("Copy", false));
        rightClickMenu.addItem(new BMenuItem("Paste", false));
        rightClickMenu.addItem(new BMenuItem("Delete", false));
        rightClickMenu.addItem(new BMenuItem("", true));
        rightClickMenu.addItem(nMI);
        rightClickMenu.addItemAt(nMI2, 8);
        rightClickMenu.addItemAt(nMI3, 9);
        rightClickMenu.addItem(new BMenuItem("", true));
        rightClickMenu.addItem(new BMenuItem("Last Context Item", false));
        //rightClickMenu.getItemAt(2).addEventListener(Event.SELECT, onBrowse);

        function onBrowse(event:Event):Void
        {
            trace("On File Browse.");

            /*file.browse([new FileFilter("All Files", "*.txt;*.htm;*.html;*.hta;*.htc;*.xhtml"),
				new FileFilter("Text Files", "*.txt"),
				new FileFilter("HTML Documents", "*.htm;*.html;*.hta;*.htc;*.xhtml")
			]);
			file.addEventListener(Event.SELECT, onSelected);*/
        } // end function

        function showRightClickMenu(event:MouseEvent):Void
        {
            rightClickMenu.display(stage, Std.int(event.stageX), Std.int(event.stageY));
        } // end function

        nMI3.addEventListener(MouseEvent.CLICK, onBrowse);
        stage.addEventListener(MouseEvent.RIGHT_CLICK, showRightClickMenu);


    } // end function


    /**
	 * 
	 */
    private function initializeButtons(mainParent:DisplayObjectContainer = null):Void
    {
        if(mainParent == null)
            mainParent = this;

        stage.scaleMode = StageScaleMode.NO_SCALE;



        /*

		
		
		var scrollPane:BScrollPane = new BScrollPane(mainParent, 600, 50);
		scrollPane.setSize(200, 200);
		scrollPane.style.backgroundColor = 0x006699;
		scrollPane.style.backgroundOpacity = 0.5;
		
		var b1:BButton = new BButton(scrollPane.content, 100, -100, "Button 1 borris is badass");
		var b2:BButton = new BButton(scrollPane.content, 100, 200, "Button 1");
		var b3:BButton = new BButton(scrollPane.content, 100, 300, "Button 3");
		var b4:BButton = new BButton(scrollPane.content, 100, 400, "Button 4");
		var b5:BButton = new BButton(scrollPane.content, 350, 500, "Button 5");
		var b6:BButton = new BButton(scrollPane.content, 200, 0, "Button 6");
		var b7:BButton = new BButton(scrollPane.content, 300, 0, "Button 7");
		var b8:BButton = new BButton(scrollPane.content, 400, 0, "Button 8");
		var b9:BButton = new BButton(scrollPane.content, 500, 0, "Button 9");*/

        /*var list:BList = new BList(mainParent, 600, 100);
        list.numRowsToShow = 6;
        list.autoSize = false;
        list.width = 300;
        list.height = 200;
        //list.addItem(new BListItem("this is an item", "data 1"));
        //list.addItem({label: "this is a list item", data: "some data"});
        list.addItem({label: "this is a list item", data: "some data"});
        list.addItemAt({label: "this is an item", data: "data 1"}, 0);
        list.addItem({label: "this is a list item2", data: "some data 2"});
        list.addItem({label: "this is a list item3", data: "some data 3"});
        list.addItem({label: "this is a list item4", data: "some data 4"});
        list.addItem({label: "this is a list item5", data: "some data 5"});
        list.addItem({label: "this is a list item6", data: "some data 6"});
        list.addItem({label: "this is a list item7", data: "some data 7"});
        list.addItem({label: "this is a list item8", data: "some data 8"});
        list.addItem({label: "this is a list item9", data: "some data 9"});
        list.addItem({label: "this is a list item10", data: "some data 10"});
        list.addItem({label: "this is a list item11", data: "some data 11"});
        var li12 = {label: "this is a list item12", data: "some data 12"};
        list.addItem(li12);
        //list.numRowsToShow = 6;
        list.selectedItem = li12;

        list.height = 300;
        list.autoSize = true;
        list.selectedIndex = 2;

        var label:BLabel = new BLabel(mainParent, 1000, 100);
        list.addEventListener(Event.CHANGE,
        function(event:Event):Void
        {
            trace(list.selectedIndex);
            label.text = list.selectedItem.label;

        });

        var comboBox:BComboBox = new BComboBox(mainParent, 400, 100);
        //comboBox.dropdown.width = 300;
        comboBox.dropdown.addItem({label: "this is an item", data: "data 1"});
        comboBox.dropdown.addItem({label: "item 2", data: "data 2"});
        comboBox.dropdown.addItem({label: "item 3", data: "data 3"});
        comboBox.dropdown.addItem({label: "item 4", data: "data 4"});
        comboBox.dropdown.addItem({label: "item 5", data: "data 5"});
        comboBox.dropdown.addItem({label: "item 6", data: "data 6"});
        comboBox.dropdown.addItem({label: "item 7", data: "data 7"});
        comboBox.dropdown.addItem({label: "item 8", data: "data 8"});
        comboBox.dropdown.addItem({label: "item 9", data: "data 9"});
        comboBox.dropdown.addItem({label: "item 10", data: "data 10"});
        comboBox.dropdown.addItem({label: "item 11", data: "data 11"});
        //comboBox.editable = true;
        //comboBox.drawNow();
        //comboBox.setSize(300, 100);
        comboBox.listPlacement = BPlacement.BOTTOM;

        //var numericStepper:BNumericStepper = new BNumericStepper(mainParent, 400, 300);

        var datePicker:BDatePicker = new BDatePicker(mainParent, 700, 100);

        var hSlider:BSlider = new BSlider(BOrientation.HORIZONTAL, mainParent, 100, 500);
        var vSlider:BSlider = new BSlider(BOrientation.VERTICAL, mainParent, 400, 500);

        var hRangeSlider:BRangeSlider = new BRangeSlider(BOrientation.HORIZONTAL, mainParent, 100, 600);
        var vRangeSlider:BRangeSlider = new BRangeSlider(BOrientation.VERTICAL, mainParent, 500, 600);

        hSlider.tickInterval = 10;
        hSlider.snapInterval = 20;
        vSlider.tickInterval = 20;
        vSlider.snapInterval = 10;

        hRangeSlider.tickInterval = 20;
        hRangeSlider.snapInterval = 50;

        vRangeSlider.tickInterval = 10;
        vRangeSlider.snapInterval = 10;

        // create a tab
        var tab1:BTab = new BTab("");
		var tab2:BTab = new BTab("Tab 2 is longer");
		var tab3:BTab = new BTab("Tab 3 is even longer");
		var tab4:BTab = new BTab("Tab 4");
		var tab5:BTab = new BTab("Tab 5");
		
		var tabGroup:BTabGroup = new BTabGroup("tab group 1");
		tabGroup.addTab(tab1);
		tabGroup.addTab(tab2);
		tabGroup.addTab(tab3);
		tabGroup.addTab(tab4);
		tabGroup.addTab(tab5);
		tabGroup.parent = mainParent;
		tabGroup.draggable = true;
		//tabGroup.removeTab(tab4);
		
		tab1.content.content.addChild(new BButton(null, 100, 100));
		tab2.content.content.addChild(new BToggleButton(null, 100, 100, "A toggle button"));
		
		//tab1.button.icon = Assets.;*/
		
		// create a window
		var window1:BPanel = new BPanel("This is a BPanel");
		window1.titleBarMode = BTitleBarMode.COMPACT_TEXT;		// working
		//window1.backgroundDrag = true;						// working
		//window1.maxWidth = 600;								// working
		//window1.minWidth = 200;								// working
		//window1.maxHeight = 400;								// working
		//window1.minHeight = 200;								// working
		//window1.maxSize = new Point(800, 600);				// working
		window1.minSize = new Point(200, 200);					// working
		//window1.closable = false;								// working
		//window1.maximizable = false;							// working
		//window1.minimizable = false;							// working
		//window1.resizable = false;							// working
		window1.collapsible = true;
		window1.x = 500;
		window1.y = 500;
		
		mainParent.addChild(window1);
		var resizePanelButon:BButton = new BButton(window1.content, 100, 100, "Press to resize!");
		resizePanelButon.addEventListener(MouseEvent.CLICK, 
		function(event:MouseEvent):Void
		{
			window1.resize(Math.round(Math.random() * 1000), Math.round(Math.random() * 800)); 
		}
		);
		
		
		var newWindow2:BPanel;
		newWindow2 = new BPanel("New Window 2");
		mainParent.addChild(newWindow2);
		newWindow2.activate();
		


    }


    private function testXML():Void
    {
        var buieXML = Xml.parse(Assets.getText("assets/buieXML/test.xml"));
        var bElement = BBuieXmlParser.parseBUIEXML(buieXML);
        addChild(bElement);
        bElement.style.backgroundColor = 0x003366;
        bElement.style.borderWidth = 2;
        bElement.style.borderColor = 0xff0000;
        //bElement.width = 500;
        //bElement.height = 500;
    } // end function


    private function adrianSucks():Void
    {
        var label1:BLabel = new BLabel(this, 0, 0, "Adrian SUCKS!");
        var label2:BLabel = new BLabel(this, 0, 0, "Guardians of the Galaxy is better than\n Transformers!");
        var label3:BLabel = new BLabel(this, 0, 0, "Adrian is TRIGGERED!");

        var labelArray:Array<BLabel> = [];
        labelArray.push(label1);
        labelArray.push(label2);
        labelArray.push(label3);

        for(label in labelArray)
        {
            label.autoSize = TextFieldAutoSize.LEFT;
        }

        var timer:haxe.Timer = new haxe.Timer(1000);
        timer.run = function():Void
        {
            for(label in labelArray)
            {
                label.x = Math.random() * 1280 - label.width;
                label.y = Math.random() * 720 - label.height;
            }
        } // end function

        //addEventListener();
    } // end function


    private function dennisAss():Void
    {

    } // end function

}
