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

package borris;

import borris.display.BStyleDeclarationBlock;
import borris.display.BStyleSelectorType;
import borris.display.BStyleSelector;
import borris.display.BStyleRuleset;
import borris.controls.BTooltipMode;
import borris.containers.BCanvas;
import borris.containers.BFlexBox;
import borris.containers.BPanel;
import borris.containers.BScrollPane;
import borris.controls.BAccordion;
import borris.controls.BBaseButton;
import borris.controls.BButton;
import borris.controls.BCheckBox;
import borris.controls.BColorChooser;
import borris.controls.BComboBox;
import borris.controls.BDatePicker;
import borris.controls.BDetails;
import borris.controls.BIconRadioButton;
import borris.controls.BLabel;
import borris.controls.BLabelButton;
import borris.controls.BList;
import borris.controls.BNumericStepper;
import borris.controls.BNumericStepperMode;
import borris.controls.BOrientation;
import borris.controls.BPlacement;
import borris.controls.BRadioButton;
import borris.controls.BRadioButtonGroup;
import borris.controls.BRangeSlider;
import borris.controls.BScrollBar;
import borris.controls.BSlider;
import borris.controls.BTab;
import borris.controls.BTabGroup;
import borris.controls.BTextInput;
import borris.controls.BToggleButton;
import borris.controls.BTooltip;
import borris.controls.BUIComponent;
import borris.display.BElement;
import borris.display.BTitleBarMode;
import borris.menus.BApplicationMenu;
import borris.menus.BCircleMenu;
import borris.menus.BContextMenu;
import borris.menus.BMenu;
import borris.menus.BMenuItem;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 08/03/2018 (dd/mm/yyyy)
 */
class BUIEDemo extends BUIComponent
{
    private var tab1:BTab = new BTab("CONTROLS");
    private var tab2:BTab = new BTab("CONTAINERS");
    private var tab3:BTab = new BTab("MANAGERS");
    private var tab4:BTab = new BTab("MENUS");
    private var tab5:BTab = new BTab("TEXTURES");
    private var tab6:BTab = new BTab("UI");
    private var tab7:BTab = new BTab("UTILS");
    private var tabGroup:BTabGroup = new BTabGroup("tab group 1");

    private var controlsContainers:Array<DisplayObjectContainer> = [];


    public function new()
    {
        super();

        // TODO change this later
        setSize(1280, 620);

        createTabs();
        initializeControls();
        initializeContainers();

        // testing
        createStyles();
    }


    /**
    *
    */
    private function createTabs():Void
    {
        tabGroup.addTab(tab1);
        tabGroup.addTab(tab2);
        tabGroup.addTab(tab3);
        tabGroup.addTab(tab4);
        tabGroup.addTab(tab5);
        tabGroup.parent = this;
        tabGroup.draggable = true;

        //tab1.button.icon = new Bitmap(Assets.getBitmapData("graphics/icon-48x48.png", true));

        tab1.content.contentPadding = 0;

    } // end function


    /**
    *
    */
    private function initializeControls():Void
    {
        var list:BList = new BList();

        //list.numRowsToShow = 6;
        //list.autoSize = false;
        list.width = 300;
        //list.height = 200;

        list.addItem({label: "Accordion", data: ""});
        list.addItem({label: "Buttons", data: ""});
        list.addItem({label: "Color Choosers", data: ""});
        list.addItem({label: "Combo Boxes", data: ""});
        list.addItem({label: "Date Pickers", data: ""});
        list.addItem({label: "Labels", data: ""});
        list.addItem({label: "Lists", data: ""});
        list.addItem({label: "Numeric Steppers", data: ""});
        list.addItem({label: "Progress Bar", data: ""});
        list.addItem({label: "Scroll Bars", data: ""});
        list.addItem({label: "Sliders", data: ""});
        list.addItem({label: "Tabs", data: ""});
        list.addItem({label: "Text Input", data: ""});
        list.addItem({label: "Tooltips", data: ""});
        list.addItem({label: "Core", data: ""}); // BElement, BUIComponent, BStyle, BStyleGroup

        //list.addItemAt({label: "this is an item", data: "data 1"}, 0);
        //var li12 = {label: "this is a list item12", data: "some data 12"};
        //list.addItem(li12);
        //list.numRowsToShow = 6;
        //list.selectedItem = li12;

        //list.height = 300;
        list.autoSize = true;
        //list.selectedIndex = 2;

        tab1.content.content.addChild(list);

        for(item in list.items)
        {
            var container:BUIComponent = new BUIComponent();
            container.x = 300;
            container.y = 0;
            //container.width = 100;
            //container.height = 600;
            container.style.backgroundColor = 0xff0000;
            container.style.borderColor = 0x00ff00;
            container.style.borderLeftWidth = 2;
            container.name = item.label + "Container";
            container.visible = false;
            controlsContainers.push(container);
            tab1.content.content.addChild(container);
        } // end for

        list.addEventListener(Event.CHANGE,
        function(event:Event):Void
        {
            for(container in controlsContainers)
            {
                container.visible = false;
                if(cast(event.currentTarget, BList).selectedItem.label + "Container" == container.name)
                {
                    container.visible = true;
                }
            } // end for
        });

        populateControlContainers();

    } // end function


    /**
    *
    */
    private function populateControlContainers():Void
    {
        var accordionContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("AccordionContainer"), DisplayObjectContainer);
        var buttonsContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("ButtonsContainer"), DisplayObjectContainer);
        var colorChooserContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("Color ChoosersContainer"), DisplayObjectContainer);
        var comboBoxContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("Combo BoxesContainer"), DisplayObjectContainer);
        var datePickersContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("Date PickersContainer"), DisplayObjectContainer);
        var labelsContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("LabelsContainer"), DisplayObjectContainer);
        var listsContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("ListsContainer"), DisplayObjectContainer);
        var numericSteppersContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("Numeric SteppersContainer"), DisplayObjectContainer);
        var progressBarContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("Progress BarContainer"), DisplayObjectContainer);
        var scrollBarsContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("Scroll BarsContainer"), DisplayObjectContainer);
        var slidersContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("SlidersContainer"), DisplayObjectContainer);
        var tabsContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("TabsContainer"), DisplayObjectContainer);
        var textInputContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("Text InputContainer"), DisplayObjectContainer);
        var tooltipsContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("TooltipsContainer"), DisplayObjectContainer);
        var coreContainer:DisplayObjectContainer = cast(tab1.content.content.getChildByName("CoreContainer"), DisplayObjectContainer);

        // Accordion
        function accordions():Void
        {
            // make a detail to add to an accordian later
            var details1:BDetails = new BDetails("Details 1");
            details1.name = "the first details";

            // make an accordian and add details to it
            var accordion1:BAccordion = new BAccordion(accordionContainer, 10, 10);

            // many ways to add a BDetails
            accordion1.addDetails(details1);
            accordion1.addDetails(new BDetails("Details 2"));
            accordion1.addDetails(new BDetails("Details 3"));
            accordion1.addDetailsAt(new BDetails("Details 4"), 3);

            // many ways to add items to a BDetails
            details1.addItem(new BBaseButton());
            details1.addItemAt(new BButton(null, 50, 70, "Button 1"), 1);
            details1.addItemAtPosition(new BButton(null, 0, 0, "Button 2"), 50, 100);

            // many ways to get a BDetails from a BAccordion
            accordion1.getDetailsAt(0).addItem(new BButton(null, 100, 130, "Button 3"));
            accordion1.getDetailsByLabel("Details 1").addItem(new BButton(null, 150, 160, "Button 4"));
            accordion1.getDetailsByName("the first details").addItem(new BButton(null, 150, 160, "Button 4"));

            // details can have a custom height
            accordion1.getDetailsAt(1).addItem(new BButton(null, 20, 80, "This BDetails has a custom height"));
            // FIXME accordion1.getDetailsAt(1).height = 150;

            accordion1.getDetailsAt(2).addItem(new BButton(null, 0, 100, "This BDetails has an indent!"));
            accordion1.getDetailsAt(2).indent = 20;

            // details automatically take the height of it's content
            for(row in 0...10)
            {
                for(column in 0...10)
                {
                    accordion1.getDetailsAt(3).addItem(new BButton(null, column * 110, row * 30, ("Button " + row + "-" + column)));
                } // end for
            } // end for

            // and arbitrary 5th BDetails
            accordion1.addDetails(new BDetails("Details 5"));
            accordion1.getDetailsAt(4).addItem(new BButton(null, 10, 30, ("Button 1")));
            // FIXME accordion1.getDetailsAt(3).opened;

        } // end function

        // Buttons
        function buttons():Void
        {
            // many types of buttons

            // BBaseButton has differnt 'states'. "up, over, down, and disabled"
            var baseBUtton:BBaseButton = new BBaseButton(buttonsContainer, 10, 10);

            // BLabelButton has a Label, an icon, and can be 'selected'
            var labelButton:BLabelButton = new BLabelButton(buttonsContainer, 10, 40, "Label Button");
            //labelButton.autoSize = false; // BLabeelButtons can automatically adust to the width of their Label text.
            // TODO make autoSize adjust both the width and height of the label and icon into consideration.
            //labelButton.setSize(200, 50); BLabel button can have a custom size.
            //labelButton.labelPlacement = BPlacement.TOP; // The placement for the Label can be changed.
            // BLabelBUttons can have icons.
            //labelButton.icon = new Bitmap(Assets.getBitmapData("graphics/icon-48x48.png"));
            labelButton.iconPlacement = BPlacement.RIGHT; // The placement of the icon can be changed
            // BLabelButtons can be selected
            labelButton.selected = true;

            var bbutton:BLabelButton = new BButton(buttonsContainer, 10, 70, "B");
            bbutton.autoSize = false;
            bbutton.setSize(32, 32);
            cast(bbutton.getSkin("upSkin"), BElement).style.borderRadius = 16;
            cast(bbutton.getSkin("overSkin"), BElement).style.borderRadius = 16;
            cast(bbutton.getSkin("downSkin"), BElement).style.borderRadius = 16;
            cast(bbutton.getSkin("disabledSkin"), BElement).style.borderRadius = 16;


            var radio1:BRadioButton = new BRadioButton(buttonsContainer, 10, 120, "Radio Button 1");
            var radio2:BRadioButton = new BRadioButton(buttonsContainer, 10, 150, "Radio Button 2");
            var radio3:BRadioButton = new BRadioButton(buttonsContainer, 10, 180, "Radio Button 3");
            var radio4:BRadioButton = new BRadioButton(buttonsContainer, 10, 210, "Radio Button 4");
            radio1.selected = true;
            // make a radio button group
            var radioGroup1:BRadioButtonGroup = new BRadioButtonGroup("radio group 1");
            radioGroup1.addRadioButton(radio1);
            radioGroup1.addRadioButton(radio2);
            radioGroup1.addRadioButton(radio3);
            radioGroup1.addRadioButton(radio4);

            var toggle1:BToggleButton = new BToggleButton(buttonsContainer, 10, 260, "Toggle Button 1");
            var toggle2:BToggleButton = new BToggleButton(buttonsContainer, 10, 290, "Toggle Button 2");

            var checkbox1:BCheckBox = new BCheckBox(buttonsContainer, 10, 340, "Checkbox 1");
            var checkbox2:BCheckBox = new BCheckBox(buttonsContainer, 10, 370, "Checkbox 2");
            var checkbox3:BCheckBox = new BCheckBox(buttonsContainer, 10, 400, "Checkbox 3");
            var checkbox4:BCheckBox = new BCheckBox(buttonsContainer, 10, 430, "Checkbox 4");

            var iRadio1:BIconRadioButton = new BIconRadioButton(buttonsContainer, 10, 480, "Icon Radio Button 1");
            var iRadio2:BIconRadioButton = new BIconRadioButton(buttonsContainer, 40, 480, "Icon Radio Button 2");
            var iRadio3:BIconRadioButton = new BIconRadioButton(buttonsContainer, 10, 510, "Icon Radio Button 3");
            var iRadio4:BIconRadioButton = new BIconRadioButton(buttonsContainer, 40, 510, "Icon Radio Button 4");
            var iRadio5:BIconRadioButton = new BIconRadioButton(buttonsContainer, 10, 540, "Icon Radio Button 5");
            var iRadio6:BIconRadioButton = new BIconRadioButton(buttonsContainer, 40, 540, "Icon Radio Button 6");

            var radioGroup2:BRadioButtonGroup = new BRadioButtonGroup("radio group 2");
            radioGroup1.addRadioButton(iRadio1);
            radioGroup1.addRadioButton(iRadio2);
            radioGroup1.addRadioButton(iRadio3);
            radioGroup1.addRadioButton(iRadio4);
            radioGroup1.addRadioButton(iRadio5);
            radioGroup1.addRadioButton(iRadio6);
        } // end function

        // Color Choosers
        function colorChoosers():Void
        {
            //
            var colorChooser:BColorChooser = new BColorChooser(colorChooserContainer, 10, 10, 0x00ff00);

            //
            // FIXME var colorChooserAdv:BColorChooserAdvanced = new BColorChooserAdvanced(colorChooserContainer, 10, 40, 0xFF0000);

        } // end function

        // Combo Boxes
        function comboBoxes():Void
        {
            // combo boxes have an internal list that drops out.
            var comboBox1:BComboBox = new BComboBox(comboBoxContainer, 10, 10);
            comboBox1.dropdown.addItem({label: "item 1", data: "data 1"});
            comboBox1.dropdown.addItem({label: "item 2", data: "data 2"});
            comboBox1.dropdown.addItem({label: "item 3", data: "data 3"});
            comboBox1.dropdown.addItem({label: "item 4", data: "data 4"});
            comboBox1.dropdown.addItem({label: "item 5", data: "data 5"});
            comboBox1.dropdown.addItem({label: "item 6", data: "data 6"});
            comboBox1.dropdown.addItem({label: "item 7", data: "data 7"});
            comboBox1.dropdown.addItem({label: "item 8", data: "data 8"});
            comboBox1.dropdown.addItem({label: "item 9", data: "data 9"});
            comboBox1.dropdown.addItem({label: "item 10", data: "data 10"});
            comboBox1.listPlacement = BPlacement.BOTTOM;


            // combo boxes can be editable
            var comboBox2:BComboBox = new BComboBox(comboBoxContainer, 10, 110);
            comboBox2.dropdown.addItem({label: "item 1", data: "data 1"});
            comboBox2.dropdown.addItem({label: "item 2", data: "data 2"});
            comboBox2.dropdown.addItem({label: "item 3", data: "data 3"});
            comboBox2.dropdown.addItem({label: "item 4", data: "data 4"});
            comboBox2.dropdown.addItem({label: "item 5", data: "data 5"});
            comboBox2.dropdown.addItem({label: "item 6", data: "data 6"});
            comboBox2.dropdown.addItem({label: "item 7", data: "data 7"});
            comboBox2.dropdown.addItem({label: "item 8", data: "data 8"});
            comboBox2.dropdown.addItem({label: "item 9", data: "data 9"});
            comboBox2.dropdown.addItem({label: "item 10", data: "data 10"});
            // FIXME comboBox2.editable = true;
            comboBox2.listPlacement = BPlacement.BOTTOM;

            // the list can pop out in different locations
            var comboBox3:BComboBox = new BComboBox(comboBoxContainer, 10, 210);
            comboBox3.dropdown.addItem({label: "Center", data: BPlacement.CENTER});
            comboBox3.dropdown.addItem({label: "Top", data: BPlacement.TOP});
            comboBox3.dropdown.addItem({label: "Bottom", data: BPlacement.BOTTOM});
            comboBox3.dropdown.addItem({label: "Left", data: BPlacement.LEFT});
            comboBox3.dropdown.addItem({label: "Right", data: BPlacement.RIGHT});

            comboBox3.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                var comboBox = cast(event.currentTarget, BComboBox);
                comboBox3.listPlacement = comboBox.selectedItem.data;
            });

        } // end function

        // Date Pickers
        function datePickers():Void
        {
            var datePicker:BDatePicker = new BDatePicker(datePickersContainer, 10, 10);
        } // end function

        // Labels
        function labels():Void
        {
            var label:BLabel = new BLabel(labelsContainer, 10, 10, "This is a label");
        } // end function

        // Lists
        function list():Void
        {
            var list:BList = new BList(listsContainer, 10, 10);
            //list.numRowsToShow = 6;
            //list.autoSize = false;
            list.width = 300;
            //list.height = 200;
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
            //list.selectedItem = li12;

            //list.height = 300;
            //list.autoSize = true;
            list.selectedIndex = 2;

            var label:BLabel = new BLabel(listsContainer, 500, 10);
            list.addEventListener(Event.CHANGE,
            function(event:Event):Void
            {
                //trace(list.selectedIndex);
                label.text = list.selectedItem.label;

            });
        } // end function

        // Numeric Steppers
        function numericSteppers():Void
        {
            // numeric steppers allow for numeric input
            var numericStepper1:BNumericStepper = new BNumericStepper(numericSteppersContainer, 10, 10);

            // have a maximum and minimum value
            var numericStepper2:BNumericStepper = new BNumericStepper(numericSteppersContainer, 10, 110);
            numericStepper2.maximum = 5;
            numericStepper2.minimum = -5;

            // numeric stepper step size can be changed.
            var numericStepper3:BNumericStepper = new BNumericStepper(numericSteppersContainer, 10, 210);
            numericStepper3.stepSize = 2;

            // numeric steppers can be non editable
            var numericStepper4:BNumericStepper = new BNumericStepper(numericSteppersContainer, 10, 310);
            numericStepper4.editable = false;

            // the placement of the buttons can me changed
            var numericStepper5:BNumericStepper = new BNumericStepper(numericSteppersContainer, 10, 410);
            numericStepper5.buttonPlacement = BPlacement.TOP;

            //
            var numericStepper6:BNumericStepper = new BNumericStepper(numericSteppersContainer, 10, 510);
            numericStepper6.mode = BNumericStepperMode.PERCENTAGE;


            var comboBox:BComboBox = new BComboBox(numericSteppersContainer, 500, 410);
            comboBox.dropdown.addItem({label: "Top", data: BPlacement.TOP});
            comboBox.dropdown.addItem({label: "Bottom", data: BPlacement.BOTTOM});
            comboBox.dropdown.addItem({label: "Left", data: BPlacement.LEFT});
            comboBox.dropdown.addItem({label: "Right", data: BPlacement.RIGHT});
            comboBox.dropdown.addItem({label: "Vertical", data: BPlacement.VERTICAL});
            comboBox.dropdown.addItem({label: "Horizontal", data: BPlacement.HORIZONTAL});

            comboBox.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                var comboBox:BComboBox = cast(event.currentTarget, BComboBox);
                numericStepper5.buttonPlacement = comboBox.selectedItem.data;
            });

        } // end function

        // Progress Bar
        function progressBar():Void
        {
            var tf:TextFormat = new TextFormat("Roboto", 72, 0xFFFFFF, false);

            var textField:TextField = new TextField();
            textField = new TextField();
            textField.text = "Coming Soon!";
            textField.type = TextFieldType.DYNAMIC;
            textField.selectable = false;
            textField.x = 50;
            textField.y = 50;
            textField.width = _width;
            textField.height = _height;
            textField.setTextFormat(tf);
            textField.defaultTextFormat = tf;
            textField.mouseEnabled = false;

            progressBarContainer.addChild(textField);
        } // end function

        // Scroll Bars
        function scrollBars():Void
        {
            var scrollbar:BScrollBar = new BScrollBar(BOrientation.VERTICAL, scrollBarsContainer, 10, 10);

            var text:TextField = new TextField();
            text.x = 200;
            text.y = 10;
            text.type = TextFieldType.DYNAMIC;
            text.setTextFormat(new TextFormat("Calibri", 14, 0xffffff));
            text.defaultTextFormat = new TextFormat("Calibri", 14, 0xffffff);
            text.multiline = true;
            text.wordWrap = true;
            //text.width = 100;
            text.height = 200;
            text.text = "ufvb;rsirhve;orifhe oifehro giher \ngoirh goir hgowirehgoerig ho ioe \n rhiewrhgoiersvho erhgowrihgo;esi hgo; \n irehgorih voeirhgoiwrehg eorihgoeri \n hgoeri ghowerihg eorgih erogiw \n hrgise hils hrlig uhsergiu \n hrgiluehrg ieurhgi";
            text.text += "nsbdcsadhciasdhc iuhcfoiaweh \nfoiwehfwei hfoiew fhwoeifh  o ihefpowiahf oiaweh foiaehfoiw hef ihewi fhwoeiahf oihf ius hfie";
            scrollBarsContainer.addChild(text);
            scrollbar.scrollTarget = text;
            text.autoSize = TextFieldAutoSize.NONE;
            trace("text height: " + text.height);
            trace("text textHeight: " + text.textHeight);
        } // end function

        // Sliders
        function sliders():Void
        {
            var hSlider:BSlider = new BSlider(BOrientation.HORIZONTAL, slidersContainer, 20, 20);
            var vSlider:BSlider = new BSlider(BOrientation.VERTICAL, slidersContainer, 320, 20);

            var hRangeSlider:BRangeSlider = new BRangeSlider(BOrientation.HORIZONTAL, slidersContainer, 20, 100);
            var vRangeSlider:BRangeSlider = new BRangeSlider(BOrientation.VERTICAL, slidersContainer, 410, 20);

            hSlider.tickInterval = 10;
            hSlider.snapInterval = 20;
            vSlider.tickInterval = 20;
            vSlider.snapInterval = 10;

            hRangeSlider.tickInterval = 20;
            hRangeSlider.snapInterval = 50;

            vRangeSlider.tickInterval = 10;
            vRangeSlider.snapInterval = 10;
        } // end function

        // Tabs
        function tabs():Void
        {
            // tab group 1
            // tabs have a content arean and switch when you click them
            var tabGroup1Container:BUIComponent = new BUIComponent(tabsContainer, 10, 10);
            tabGroup1Container.setSize(600, 100);

            var tab1_1:BTab = new BTab("Tab 1");
            var tab1_2:BTab = new BTab("Tab 2");
            var tab1_3:BTab = new BTab("Tab 3");
            var tab1_4:BTab = new BTab("Tab 4");
            var tab1_5:BTab = new BTab("Tab 5");

            var tabGroup1:BTabGroup = new BTabGroup("tab group 1");
            tabGroup1.addTab(tab1_1);
            tabGroup1.addTab(tab1_2);
            tabGroup1.addTab(tab1_3);
            tabGroup1.addTab(tab1_4);
            tabGroup1.addTab(tab1_5);
            tabGroup1.parent = tabGroup1Container;

            tab1_1.content.style.backgroundColor = 0xFF0000;
            tab1_2.content.style.backgroundColor = 0x00FF00;
            tab1_3.content.style.backgroundColor = 0x0000FF;
            tab1_4.content.style.backgroundColor = 0xFFFF00;
            tab1_5.content.style.backgroundColor = 0x00FFFF;


            // tab group 2
            // tabs adust the the length of their buttons automatically.
            var tabGroup2Container:BUIComponent = new BUIComponent(tabsContainer, 10, 220);
            tabGroup2Container.setSize(600, 100);

            var tab2_1:BTab = new BTab("Tab 1 is long");
            var tab2_2:BTab = new BTab("Tab 2 is longer");
            var tab2_3:BTab = new BTab("Tab 3 is even longer");

            var tabGroup2:BTabGroup = new BTabGroup("tab group 2");
            tabGroup2.addTab(tab2_1);
            tabGroup2.addTab(tab2_2);
            tabGroup2.addTab(tab2_3);
            tabGroup2.parent = tabGroup2Container;


            // tab group 3
            // tabs can have icons
            var tabGroup3Container:BUIComponent = new BUIComponent(tabsContainer, 10, 430);
            tabGroup3Container.setSize(600, 100);

            var tab2_1:BTab = new BTab("Tab 1 is long");
            var tab2_2:BTab = new BTab("Tab 2 is longer");
            var tab2_3:BTab = new BTab("Tab 3 is even longer");

            var tabGroup3:BTabGroup = new BTabGroup("tab group 3");
            tabGroup3.addTab(tab2_1);
            tabGroup3.addTab(tab2_2);
            tabGroup3.addTab(tab2_3);
            tabGroup3.parent = tabGroup3Container;

            tab2_1.button.icon = new Bitmap(Assets.getBitmapData("graphics/icon-48x48.png"));
            tab2_2.button.icon = new Bitmap(Assets.getBitmapData("graphics/icon-48x48.png"));
            tab2_3.button.icon = new Bitmap(Assets.getBitmapData("graphics/icon-48x48.png"));


            // tab group 4
            // tabs can be switched around
            var tabGroup4Container:BUIComponent = new BUIComponent(tabsContainer, 10, 640);
            tabGroup4Container.setSize(600, 100);

            var tab2_1:BTab = new BTab("Tab 1 is long");
            var tab2_2:BTab = new BTab("Tab 2 is longer");
            var tab2_3:BTab = new BTab("Tab 3 is even longer");

            var tabGroup4:BTabGroup = new BTabGroup("tab group 4");
            tabGroup4.addTab(tab2_1);
            tabGroup4.addTab(tab2_2);
            tabGroup4.addTab(tab2_3);
            tabGroup4.parent = tabGroup4Container;
            tabGroup4.draggable = true;


            // tab group 5
            // tabs can be removed
            var tabGroup5Container:BUIComponent = new BUIComponent(tabsContainer, 10, 850);
            tabGroup5Container.setSize(600, 100);

            var tab2_1:BTab = new BTab("Tab 1 is long");
            var tab2_2:BTab = new BTab("Tab 2 is longer");
            var tab2_3:BTab = new BTab("Tab 3 is even longer");

            var tabGroup5:BTabGroup = new BTabGroup("tab group 5");
            tabGroup5.addTab(tab2_1);
            tabGroup5.addTab(tab2_2);
            tabGroup5.addTab(tab2_3);
            tabGroup5.parent = tabGroup5Container;
            //tabGroup5.removeTab(tab4);

        } // end function

        // Text Input
        function textInput():Void
        {
            // BTextInput allows for single line text entry.
            var textInput1 = new BTextInput(textInputContainer, 10, 10, "text input");

            // BTextInput can have restricted characters
            var textInput2 = new BTextInput(textInputContainer, 10, 110, "text input");
            textInput2.restrict = "1234567890";

            // BTextInput can be non editable
            var textInput3 = new BTextInput(textInputContainer, 10, 210, "text input");
            textInput3.editable = false;

            // BTextInput can have a maximum set of characters
            var textInput4 = new BTextInput(textInputContainer, 10, 310, "text input");
            textInput4.maxChars = 10;

            // BTextInput
        } // end function

        // Tooltips
        function tooltips():Void
        {
            //
            var tooltip1 = new BTooltip(tooltipsContainer, 20, 20, "Tooltip 1 label", "Tooltip 1 tip");
            tooltip1.displayPosition = "bottomRight";
            tooltip1.display();

            // change the properties of the tooltip
            var labelTextInput = new BTextInput(tooltipsContainer, 640, 0, tooltip1.label);
            var tipTextInput = new BTextInput(tooltipsContainer, 640, 40, tooltip1.tip);

            var displayComboBox = new BComboBox(tooltipsContainer, 640, 80);
            displayComboBox.dropdown.addItem({label: "Top", data: "top"});
            displayComboBox.dropdown.addItem({label: "Bottom", data: "bottom"});
            displayComboBox.dropdown.addItem({label: "Left", data: "left"});
            displayComboBox.dropdown.addItem({label: "Right", data: "right"});
            displayComboBox.dropdown.addItem({label: "Top Left", data: "topLeft"});
            displayComboBox.dropdown.addItem({label: "Top Right", data: "topRight"});
            displayComboBox.dropdown.addItem({label: "Bottom Left", data: "bottomLeft"});
            displayComboBox.dropdown.addItem({label: "Bottom Right", data: "bottomRight"});
            displayComboBox.dropdown.addItem({label: "Left Top", data: "leftTop"});
            displayComboBox.dropdown.addItem({label: "Left Bottom", data: "leftBottom"});
            displayComboBox.dropdown.addItem({label: "Right Top", data: "rightTop"});
            displayComboBox.dropdown.addItem({label: "Right Bottom", data: "rightBottom"});
            displayComboBox.dropdown.addItem({label: "Auto", data: "auto"});

            // FIXME fix inicial sellected item/index
            displayComboBox.dropdown.selectedIndex = 7;

            var tooltipModeComboBox = new BComboBox(tooltipsContainer, 640, 120);
            tooltipModeComboBox.dropdown.addItem({label: "Label Only", data: BTooltipMode.LABEL_ONLY});
            tooltipModeComboBox.dropdown.addItem({label: "Tip Only", data: BTooltipMode.TIP_ONLY});
            tooltipModeComboBox.dropdown.addItem({label: "Preview Only", data: BTooltipMode.PREVIEW_ONLY});
            tooltipModeComboBox.dropdown.addItem({label: "Label and Tip", data: BTooltipMode.LABEL_AND_TIP});
            tooltipModeComboBox.dropdown.addItem({label: "Label and Preview", data: BTooltipMode.LABEL_AND_PREVIEW});
            tooltipModeComboBox.dropdown.addItem({label: "Tip and Preview", data: BTooltipMode.TIP_AND_PREVIEW});
            tooltipModeComboBox.dropdown.addItem({label: "All", data: BTooltipMode.ALL});


            // event handling
            labelTextInput.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                event.stopImmediatePropagation();
                //tooltip1.label = cast(event.currentTarget, BTextInput).text;
                tooltip1.label = labelTextInput.text;
            });

            tipTextInput.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                event.stopImmediatePropagation();
                //tooltip1.tip = cast(event.currentTarget, BTextInput).text;
                tooltip1.tip = tipTextInput.text;
            });

            displayComboBox.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                var comboBox = cast(event.currentTarget, BComboBox);
                tooltip1.displayPosition = comboBox.selectedItem.data;
            });

            displayComboBox.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                var comboBox = cast(event.currentTarget, BComboBox);
                tooltip1.displayPosition = comboBox.selectedItem.data;
            });

        } // end function

        // Core // BElement, BUIComponent, BStyle, BStyleGroup
        function core():Void
        {
            // BElements are based on HTML elements and Flash's DisplayObject hiearchy
            // BElements can have other BElements within them
            // BElements can be styled similar to HTML elements. They contain a BStyle Object
            // BStyle has many of the same properties found in CSS
            var bElement1:BElement = new BElement();
            bElement1.x = 10;
            bElement1.y = 10;
            bElement1.width = 100;
            bElement1.height = 100;
            coreContainer.addChild(bElement1);

            // give the BElement an initial style
            // FIXME bElement1.style.width = 100;
            // FIXME bElement1.style.height = 100;
            bElement1.style.backgroundColor = 0x0099CC;
            bElement1.style.borderWidth = 2;
            bElement1.style.borderColor = 0xFF0000;
            bElement1.style.borderRadius = 10;

            // change the style in demo
            var widthNumericStepper:BNumericStepper = new BNumericStepper(coreContainer, 500, 10);
            widthNumericStepper.maximum = 500;
            var heightNumericStepper:BNumericStepper = new BNumericStepper(coreContainer, 700, 10);
            heightNumericStepper.maximum = 500;

            var backgroundColorChooser:BColorChooser = new BColorChooser(coreContainer, 500, 110);

            var borderComboBox:BComboBox = new BComboBox(coreContainer, 500, 210);
            borderComboBox.dropdown.addItem({label: "All", data: BPlacement.CENTER});
            borderComboBox.dropdown.addItem({label: "Top", data: BPlacement.TOP});
            borderComboBox.dropdown.addItem({label: "Bottom", data: BPlacement.BOTTOM});
            borderComboBox.dropdown.addItem({label: "Left", data: BPlacement.LEFT});
            borderComboBox.dropdown.addItem({label: "Right", data: BPlacement.RIGHT});

            var borderWidthNumericStepper:BNumericStepper = new BNumericStepper(coreContainer, 500, 310);
            borderWidthNumericStepper.maximum = 100;

            var borderColorChooser:BColorChooser = new BColorChooser(coreContainer, 500, 410);

            var borderTLNumericStepper:BNumericStepper = new BNumericStepper(coreContainer, 500, 510);
            var borderTRNumericStepper:BNumericStepper = new BNumericStepper(coreContainer, 700, 510);
            var borderBLNumericStepper:BNumericStepper = new BNumericStepper(coreContainer, 500, 540);
            var borderBRNumericStepper:BNumericStepper = new BNumericStepper(coreContainer, 700, 540);
            borderTLNumericStepper.maximum =
            borderTRNumericStepper.maximum =
            borderBLNumericStepper.maximum =
            borderBRNumericStepper.maximum = 250;

            var backgroundOpacityNumericStepper = new BNumericStepper(coreContainer, 500, 580);
            backgroundOpacityNumericStepper.maximum = 1;
            backgroundOpacityNumericStepper.stepSize = 0.1;
            backgroundOpacityNumericStepper.value = bElement1.style.backgroundOpacity;

            var borderOpacityNumericStepper = new BNumericStepper(coreContainer, 500, 620);
            borderOpacityNumericStepper.maximum = 1;
            borderOpacityNumericStepper.stepSize = 0.1;
            borderOpacityNumericStepper.value = bElement1.style.borderOpacity;

            // event handling
            widthNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                bElement1.width = widthNumericStepper.value;
            });

            heightNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                bElement1.height = heightNumericStepper.value;
            });

            backgroundColorChooser.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                bElement1.style.backgroundColor = backgroundColorChooser.value;
            });

            borderWidthNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                switch(borderComboBox.selectedItem.data)
                {
                    case BPlacement.CENTER:
                        bElement1.style.borderWidth = borderWidthNumericStepper.value;

                    case BPlacement.TOP:
                        bElement1.style.borderTopWidth = borderWidthNumericStepper.value;

                    case BPlacement.BOTTOM:
                        bElement1.style.borderBottomWidth = borderWidthNumericStepper.value;

                    case BPlacement.LEFT:
                        bElement1.style.borderLeftWidth = borderWidthNumericStepper.value;

                    case BPlacement.RIGHT:
                        bElement1.style.borderRightWidth = borderWidthNumericStepper.value;

                    default:
                        bElement1.style.borderWidth = borderWidthNumericStepper.value;
                } // end switch
            });

            borderColorChooser.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                bElement1.style.borderColor = borderColorChooser.value;
            });

            borderTLNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                bElement1.style.borderTopLeftRadius = borderTLNumericStepper.value;
            });

            borderTRNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                bElement1.style.borderTopRightRadius = borderTRNumericStepper.value;
            });

            borderBLNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                bElement1.style.borderBottomLeftRadius = borderBLNumericStepper.value;
            });

            borderBRNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                bElement1.style.borderBottomRightRadius = borderBRNumericStepper.value;
            });

            backgroundOpacityNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                bElement1.style.backgroundOpacity = backgroundOpacityNumericStepper.value;
            });

            borderOpacityNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                bElement1.style.borderOpacity = borderOpacityNumericStepper.value;
            });

            // BUIComponents are the base for a UI component and inherit BElement class
            // Therefor all BUIComponents can have BElements and BUIComponents within them.
            // BUIComponents handle key functionality of a UI component such as:
            // focus, enabled/disabled and validating
            var bui1:BUIComponent = new BUIComponent(coreContainer, 10, 500);

        } // end function

        // run the functions
        accordions();
        buttons();
        colorChoosers();
        comboBoxes();
        datePickers();
        labels();
        list();
        numericSteppers();
        progressBar();
        scrollBars();
        sliders();
        tabs();
        textInput();
        tooltips();
        core();
    }
    // end function


    private function initializeContainers():Void
    {
        var list:BList = new BList();
        list.width = 300;
        list.addItem({label: "Canvas"});
        list.addItem({label: "Flex Box"});
        list.addItem({label: "Panels"});
        list.addItem({label: "Scroll Pane"});

        tab2.content.content.addChild(list);

        for(item in list.items)
        {
            var container:BUIComponent = new BUIComponent();
            container.x = 300;
            container.y = 0;
            //container.width = 100;
            //container.height = 600;
            container.style.backgroundColor = 0xff0000;
            container.style.borderColor = 0x00ff00;
            container.style.borderLeftWidth = 2;
            container.name = item.label + "Container";
            container.visible = false;
            controlsContainers.push(container);
            tab2.content.content.addChild(container);
        } // end for

        list.addEventListener(Event.CHANGE,
        function(event:Event):Void
        {
            for(container in controlsContainers)
            {
                container.visible = false;
                if(cast(event.currentTarget, BList).selectedItem.label + "Container" == container.name)
                {
                    container.visible = true;
                }
            } // end for
        });

        // BUG crashed in HTML5
        populateContainerContainers();

    } // end function


    public function populateContainerContainers():Void
    {
        var canvasContainer:DisplayObjectContainer = cast(tab2.content.content.getChildByName("CanvasContainer"), DisplayObjectContainer);
        var flexBoxContainer:DisplayObjectContainer = cast(tab2.content.content.getChildByName("Flex BoxContainer"), DisplayObjectContainer);
        var panelsContainer:DisplayObjectContainer = cast(tab2.content.content.getChildByName("PanelsContainer"), DisplayObjectContainer);
        var scrollPaneContainer:DisplayObjectContainer = cast(tab2.content.content.getChildByName("Scroll PaneContainer"), DisplayObjectContainer);


        // Canvas
        function canvas():Void
        {
            //
            var canvas1:BCanvas = new BCanvas();
            canvas1.x = 10;
            canvasContainer.addChild(canvas1);
        } // end function

        // FlexBox
        function flexBox():Void
        {
            var flexParent:BUIComponent = new BUIComponent(null, 0, 0);
            flexParent.setSize(640, 640);
            /*var flexParent:BElement = new BElement();
            flexParent.width = 640;
            flexParent.heigh = 640;*/

            // create a flexbox
            var flexBox:BFlexBox = new BFlexBox(BFlexBox.HORIZONTAL, flexBoxContainer, 10, 10);
            flexBox.flexParent = flexParent;
            flexBox.style.backgroundColor = 0x660000;

            flexBox.direction = BFlexBox.HORIZONTAL;
            flexBox.justify = BFlexBox.SPACE_AROUND;
            flexBox.alignItems = BFlexBox.STRETCH;
            //flexBox.alignContent = BFlexBox.START;
            //flexBox.flex = BFlexBox.WRAP;
            flexBox.wrap = BFlexBox.NO_WRAP;

            flexBox.horizontalSpacing = 20;
            flexBox.verticalSpacing = 20;


            // populate the flexbox
            var bbb1 = new BBaseButton(flexBox, 0, 100);
            var bbb2 = new BBaseButton(flexBox, 150, 100);
            var bbb3 = new BBaseButton(flexBox, 300, 100);
            var bbb4 = new BBaseButton(flexBox, 450, 100);

            bbb1.setSize(80, 80);
            bbb2.setSize(100, 100);
            bbb3.setSize(50, 50);
            bbb4.setSize(80, 80);

            flexBox.addItem(bbb1);
            flexBox.addItem(bbb2);
            flexBox.addItem(bbb3);
            flexBox.addItem(bbb4);


            function makeSprite():Sprite
            {
                var s = new Sprite();
                s.graphics.beginFill(0x00ff00, 1);
                s.graphics.drawRect(0, 0, 100, 100);
                s.graphics.endFill();
                return s;
            }

            flexBox.addItem(makeSprite());
            flexBox.addItem(makeSprite());
            flexBox.addItem(makeSprite());
            flexBox.addItem(makeSprite());
            flexBox.addItem(makeSprite());
            flexBox.addItem(makeSprite());


            // change flexParent size
            var flexParentWidthNumericStepper:BNumericStepper = new BNumericStepper(flexBoxContainer, 800, 10);
            flexParentWidthNumericStepper.maximum = 1000;
            flexParentWidthNumericStepper.stepSize = 5;
            flexParentWidthNumericStepper.value = flexParent.width;
            var flexParentHeightNumericStepper:BNumericStepper = new BNumericStepper(flexBoxContainer, 800, 40);
            flexParentHeightNumericStepper.maximum = 1000;
            flexParentHeightNumericStepper.stepSize = 5;
            flexParentHeightNumericStepper.value = flexParent.height;

            // event handling
            flexParentWidthNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                flexParent.width = flexParentWidthNumericStepper.value;
            });

            flexParentHeightNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                flexParent.height = flexParentHeightNumericStepper.value;
            });
        } // end function

        // Panels
        function panels():Void
        {
            //
            var panel1 = new BPanel("Panel 1");
            panel1.titleBarMode = BTitleBarMode.COMPACT_TEXT;		// working
            //window1.backgroundDrag = true;						// working
            //window1.maxWidth = 600;								// working
            //window1.minWidth = 200;								// working
            //window1.maxHeight = 400;								// working
            //window1.minHeight = 200;								// working
            //window1.maxSize = new Point(800, 600);				// working
            panel1.minSize = new Point(200, 200);					// working
            //window1.closable = false;							// working
            //window1.maximizable = false;							// working
            //window1.minimizable = false;							// working
            //window1.resizable = false;							// working
            panel1.collapsible = true;
            panel1.x = 10;
            panel1.y = 10;

            panelsContainer.addChild(panel1);
            panel1.activate();


            // change the properties of the panel
            var backgroundDragToggleButton = new BToggleButton(panelsContainer, 640, 0, "Background Drag");
            var closeableToggleButton = new BToggleButton(panelsContainer, 640, 40, "Closeable");
            var MaximizableToggleButton = new BToggleButton(panelsContainer, 640, 80, "Maximizable");
            var minimizableToggleButton = new BToggleButton(panelsContainer, 640, 120, "Minimizable");
            var resizableToggleButton = new BToggleButton(panelsContainer, 640, 160, "Resizable");
            var collapsibleToggleButton = new BToggleButton(panelsContainer, 640, 200, "Collapsible");

            backgroundDragToggleButton.selected = panel1.backgroundDrag;
            closeableToggleButton.selected = panel1.closeable;
            MaximizableToggleButton.selected = panel1.maximizable;
            minimizableToggleButton.selected = panel1.minimizable;
            resizableToggleButton.selected = panel1.resizable;
            collapsibleToggleButton.selected = panel1.collapsible;

            var widthNumericStepper = new BNumericStepper(panelsContainer, 640, 240);
            var heightNumericStepper = new BNumericStepper(panelsContainer, 740, 240);
            widthNumericStepper.maximum = Math.POSITIVE_INFINITY;
            heightNumericStepper.maximum = Math.POSITIVE_INFINITY;
            widthNumericStepper.value = panel1.width;
            heightNumericStepper.value = panel1.height;

            var maxWidthNumericStepper = new BNumericStepper(panelsContainer, 640, 280);
            var maxHeightNumericStepper = new BNumericStepper(panelsContainer, 740, 280);
            maxWidthNumericStepper.maximum = Math.POSITIVE_INFINITY;
            maxHeightNumericStepper.maximum = Math.POSITIVE_INFINITY;
            maxWidthNumericStepper.value = panel1.maxWidth;
            maxHeightNumericStepper.value = panel1.maxHeight;

            var minWidthNumericStepper = new BNumericStepper(panelsContainer, 640, 320);
            var minHeightNumericStepper = new BNumericStepper(panelsContainer, 740, 320);
            minWidthNumericStepper.maximum = Math.POSITIVE_INFINITY;
            minHeightNumericStepper.maximum = Math.POSITIVE_INFINITY;
            minWidthNumericStepper.value = panel1.minWidth;
            minHeightNumericStepper.value = panel1.minHeight;

            // labels
            var sizeLabel = new BLabel(panelsContainer, widthNumericStepper.x - 100, widthNumericStepper.y, "Size:");
            var maxSizeLabel = new BLabel(panelsContainer, maxWidthNumericStepper.x - 100, maxWidthNumericStepper.y, "Max Size:");
            var minSizeLabel = new BLabel(panelsContainer, minWidthNumericStepper.x - 100, minWidthNumericStepper.y, "Min Size:");

            // event handling
            backgroundDragToggleButton.addEventListener(MouseEvent.CLICK, function(event:Event):Void
            {
                panel1.backgroundDrag = backgroundDragToggleButton.selected;
            });

            closeableToggleButton.addEventListener(MouseEvent.CLICK, function(event:Event):Void
            {
                panel1.closeable = closeableToggleButton.selected;
            });

            MaximizableToggleButton.addEventListener(MouseEvent.CLICK, function(event:Event):Void
            {
                panel1.maximizable = MaximizableToggleButton.selected;
            });

            minimizableToggleButton.addEventListener(MouseEvent.CLICK, function(event:Event):Void
            {
                panel1.minimizable = minimizableToggleButton.selected;
            });

            resizableToggleButton.addEventListener(MouseEvent.CLICK, function(event:Event):Void
            {
                panel1.resizable = resizableToggleButton.selected;
            });

            collapsibleToggleButton.addEventListener(MouseEvent.CLICK, function(event:Event):Void
            {
                panel1.collapsible = collapsibleToggleButton.selected;
            });

            widthNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                panel1.width = widthNumericStepper.value;
            });

            heightNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                panel1.height = heightNumericStepper.value;
            });

            maxWidthNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                panel1.maxWidth = cast(maxWidthNumericStepper.value);
                //panel1.maxSize.x = maxWidthNumericStepper.value;
                //panel1.maxSize = new Point(maxWidthNumericStepper.value, panel1.maxSize.y);
            });

            maxHeightNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                panel1.maxHeight = cast(maxHeightNumericStepper.value);
                //panel1.maxSize.y = maxHeightNumericStepper.value;
                //panel1.maxSize = new Point(panel1.maxSize.x, maxHeightNumericStepper.value);
            });

            minWidthNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                panel1.minWidth = cast(minWidthNumericStepper.value);
                //panel1.minSize.x = minWidthNumericStepper.value;
                //panel1.minSize = new Point(minWidthNumericStepper.value, panel1.maxSize.y);
            });

            minHeightNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                panel1.minHeight = cast(minHeightNumericStepper.value);
                //panel1.minSize.y = minHeightNumericStepper.value;
                //panel1.minSize = new Point(panel1.maxSize.x, minHeightNumericStepper.value);
            });

        } // end function

        // Scroll Pane
        function scrollPane():Void
        {
            var scrollPane = new BScrollPane(scrollPaneContainer, 50, 0);
            scrollPane.setSize(200, 200);
            scrollPane.style.backgroundColor = 0x006699;
            scrollPane.style.backgroundOpacity = 0.5;

            var b1 = new BButton(scrollPane.content, 100, -100, "position: (100, -100)");
            var b2 = new BButton(scrollPane.content, 100, 200, "(100, 200)");
            var b3 = new BButton(scrollPane.content, 100, 300, "(100, 300)");
            var b4 = new BButton(scrollPane.content, 100, 400, "(100, 400)");
            var b5 = new BButton(scrollPane.content, 350, 500, "(350, 500)");
            var b6 = new BButton(scrollPane.content, 200, 0, "(200, 0)");
            var b7 = new BButton(scrollPane.content, 300, 0, "(300, 0)");
            var b8 = new BButton(scrollPane.content, 400, 0, "(400, 0)");
            var b9 = new BButton(scrollPane.content, 500, 0, "(500, 0)");

            // change the properties of the scroll pane
            var widthNumericStepper = new BNumericStepper(scrollPaneContainer, 640, 0);
            widthNumericStepper.maximum = 1000;
            widthNumericStepper.stepSize = 5;
            widthNumericStepper.value = scrollPane.width;

            var heightNumericStepper = new BNumericStepper(scrollPaneContainer, 750, 0);
            heightNumericStepper.maximum = 1000;
            heightNumericStepper.stepSize = 5;
            heightNumericStepper.value = scrollPane.height;

            var contentPaddingNumericStepper = new BNumericStepper(scrollPaneContainer, 640, 100);
            contentPaddingNumericStepper.maximum = 100;
            contentPaddingNumericStepper.stepSize = 1;
            contentPaddingNumericStepper.value = scrollPane.contentPadding;

            // event handling
            widthNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                scrollPane.width = widthNumericStepper.value;
            });

            heightNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                scrollPane.height = heightNumericStepper.value;
            });

            contentPaddingNumericStepper.addEventListener(Event.CHANGE, function(event:Event):Void
            {
                scrollPane.contentPadding = contentPaddingNumericStepper.value;
            });

        } // end function

        canvas();
        flexBox();
        panels();
        scrollPane();

    } // end function


    private function initializeMenu():Void
    {
        var mainMenu:BMenu;
        var rightClickMenu:BContextMenu;
        var rightClickMenu2:BCircleMenu;

        // make a main menu
        mainMenu = new BApplicationMenu(false);
        //mainMenu = new BContextMenu();
        mainMenu.display(tab4.content.content, 0, 0);
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
    private function createStyles():Void
    {

        var bButtonSelector = new BStyleSelector(BStyleSelectorType.ELEMENT, "BBaseButton");
        var bElementSelector = new BStyleSelector(BStyleSelectorType.ELEMENT, "BElement");
        var bUIComponentSelector = new BStyleSelector(BStyleSelectorType.ELEMENT, "BUIComponent");
        var bButtonDeclarationBlock = new BStyleDeclarationBlock();
        var ruleset = new BStyleRuleset([bButtonSelector, bElementSelector, bUIComponentSelector], bButtonDeclarationBlock);

        //bButtonDeclarationBlock.backgroundColor = 0xFF0000;
        //bButtonDeclarationBlock.backgroundOpacity = 1;
        //bButtonDeclarationBlock.borderColor = 0xFF0000;
        //bButtonDeclarationBlock.borderOpacity = 1;
        //bButtonDeclarationBlock.borderRadius = 15;
        //bButtonDeclarationBlock.borderWidth = 5;

        //bButtonDeclarationBlock.update();
        ruleset.update();
    } // end function

} // end class
