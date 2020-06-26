package borris;

import borris.controls.BUIComponent;
import borris.display.BElement;
import borris.display.BStyleDeclarationBlock;
import borris.display.BStyleRuleset;
import borris.display.BStyleSelector;
import borris.display.BStyleSelectorType;



/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 19/09/2018 (dd/mm/yyyy)
 */
class BUIEDemo extends BUIComponent
{
    private var e1:BElement = new BElement();
    private var e2:BElement = new BElement();
    private var e3:BElement = new BElement();
    private var bUIC:BUIComponent = new BUIComponent();


    public function new()
    {
        super();

        createElement();

        // testing
        createStyles();

    }

    /**
    *
    **/
    private function createElement():Void
    {

        e1.x = 100;
        e1.y = 100;
        e1.width = 100;
        e1.height = 100;
        addChild(e1);

        /*e1.style.backgroundColor = 0x666666;
        e1.style.borderColor = 0xFF0000;
        e1.style.borderWidth = 2;
        e1.style.borderRadius = 10;*/
        //e1.style.drawNow();

        e2.x = 300;
        e2.y = 100;
        e2.width = 100;
        e2.height = 100;
        addChild(e2);

        e3.x = 500;
        e3.y = 100;
        e3.width = 100;
        e3.height = 100;
        addChild(e3);

        bUIC.x = 700;
        bUIC.y = 100;
        bUIC.width = 100;
        bUIC.height = 100;
        addChild(bUIC);


    } // end function


    /**
    *
    */
    private function createStyles():Void
    {
        /*
        * NOTE: First create selecters.
        */
        var bButtonSelector = new BStyleSelector(BStyleSelectorType.ELEMENT, "BBaseButton");
        var bElementSelector = new BStyleSelector(BStyleSelectorType.ELEMENT, "BElement");
        var bUIComponentSelector = new BStyleSelector(BStyleSelectorType.ELEMENT, "BUIComponent");
        var bButtonDeclarationBlock = new BStyleDeclarationBlock();

        bButtonDeclarationBlock.backgroundColor = 0x333333;
        bButtonDeclarationBlock.backgroundOpacity = 1;
        bButtonDeclarationBlock.borderColor = 0xFF0000;
        bButtonDeclarationBlock.borderOpacity = 1;
        bButtonDeclarationBlock.borderRadius = 15;
        bButtonDeclarationBlock.borderWidth = 5;
        bButtonDeclarationBlock.borderTopRightRadius = 5;
        bButtonDeclarationBlock.borderLeftWidth = 30;

        /*
         * NOTE: A rulset contains an array of selectors and a declaration block
         */
        var ruleset = new BStyleRuleset([bButtonSelector, bElementSelector, bUIComponentSelector], bButtonDeclarationBlock);


        //bButtonDeclarationBlock.update();
        //ruleset.update();
        //e1.style.drawNow();


        // Class Selector Test
        var class01Selector = new BStyleSelector(BStyleSelectorType.CLASS, "class01");
        var class01DeclarationBlock = new BStyleDeclarationBlock();

        class01DeclarationBlock.backgroundColor = 0x333333;
        class01DeclarationBlock.backgroundOpacity = 1;
        class01DeclarationBlock.borderColor = 0x0000FF;
        class01DeclarationBlock.borderOpacity = 1;
        class01DeclarationBlock.borderRadius = 15;
        class01DeclarationBlock.borderWidth = 5;
        class01DeclarationBlock.borderTopRightRadius = 5;
        class01DeclarationBlock.borderLeftWidth = 30;

        var ruleset02 = new BStyleRuleset([bButtonSelector, bElementSelector, bUIComponentSelector], class01DeclarationBlock);
        //ruleset02.update();

    } // end function

} // end class
