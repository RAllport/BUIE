package borris.display;

import borris.events.BStyleEvent;
import openfl.events.EventDispatcher;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 04/07/2018 (dd/mm/yyyy)
 */
class BStyleRuleset extends EventDispatcher
{
    @:isVar public var selectors(get, set):Array<BStyleSelector>;
    @:isVar public var declarationBlock(get, set):BStyleDeclarationBlock;

    /**
    * Pairs BStyleDeclarationBlocks with BStyleSelectors.
    */
    public function new(?selectors:Array<BStyleSelector>, ?declarationBlock:BStyleDeclarationBlock)
    {
        super();
        this.selectors = selectors;
        this.declarationBlock = declarationBlock;
    }


    /**
    *
    */
    private function declorationChangeHandler(event:BStyleEvent):Void
    {
        update();
    } // end function


    /**
    *
    */
    public function addSelector(selector:BStyleSelector):BStyleSelector
    {
        selectors.push(selector);

        // Update the elements on the selector
        for(style in BStyle.styles)
        {
            var bElement = cast(style.link, BElement);
            //trace("Element: " + bElement.element);

            if(selector.type == BStyleSelectorType.ELEMENT)
            {
                if(bElement.element == selector.name)
                {
                    //trace("Selector: " + selector.name);
                    BStyle.setStyleableFromStyleable(bElement.style, declarationBlock);
                } // end if
            } // end if
            else if(selector.type == BStyleSelectorType.CLASS)
            {
                for(_class in bElement.classes)
                {
                    if(_class == selector.name)
                    {
                        //trace("Selector: " + selector.name);
                        BStyle.setStyleableFromStyleable(bElement.style, declarationBlock);
                    } // end if
                } // end for
            } // end else if
            else if(selector.type == BStyleSelectorType.ID)
            {
                if(bElement.id == selector.name)
                {
                    //trace("Selector: " + selector.name);
                    BStyle.setStyleableFromStyleable(bElement.style, declarationBlock);
                } // end if
            } // end else if

        } // end for

        return selector;
    } // end function


    /**
    *
    */
    public function removeSelector(selector:BStyleSelector):BStyleSelector
    {
        for(style in BStyle.styles)
        {
            var bElement = cast(style.link, BElement);

            if(selector.type == BStyleSelectorType.ELEMENT)
            {
                if(bElement.element == selector.name)
                {
                    //trace("Selector: " + selector.name);
                    BStyle.setDefaultStyle(bElement.style);
                } // end if
            } // end if
            else if(selector.type == BStyleSelectorType.CLASS)
            {
                for(_class in bElement.classes)
                {
                    if(_class == selector.name)
                    {
                        //trace("Selector: " + selector.name);
                        BStyle.setDefaultStyle(bElement.style);
                    } // end if
                } // end for
            } // end else if
            else if(selector.type == BStyleSelectorType.ID)
            {
                if(bElement.id == selector.name)
                {
                    //trace("Selector: " + selector.name);
                    BStyle.setDefaultStyle(bElement.style);
                } // end if
            } // end else if
        } // end for

        return selector;
    } // end function


    /**
    *
    */
    public function update(selector:BStyleSelector = null):Void
    {
        //TODO: This can be optimized
        //
        for(style in BStyle.styles)
        {
            var bElement = cast(style.link, BElement);
            //trace("Element: " + bElement.element);

            for(selector in selectors)
            {
                //trace("Selector: " + selector.name);

                if(selector.type == BStyleSelectorType.ELEMENT)
                {
                    if(bElement.element == selector.name)
                    {
                        //trace("Selector: " + selector.name);
                        BStyle.setStyleableFromStyleable(bElement.style, declarationBlock);
                    } // end if
                } // end if
                else if(selector.type == BStyleSelectorType.CLASS)
                {
                    for(_class in bElement.classes)
                    {
                        if(_class == selector.name)
                        {
                            //trace("Selector: " + selector.name);
                            BStyle.setStyleableFromStyleable(bElement.style, declarationBlock);
                        } // end if
                    } // end for
                } // end else if
                else if(selector.type == BStyleSelectorType.ID)
                {
                    if(bElement.id == selector.name)
                    {
                        //trace("Selector: " + selector.name);
                        BStyle.setStyleableFromStyleable(bElement.style, declarationBlock);
                    } // end if
                } // end else if
            } // end for

        } // end for

    } // end function


    private function get_selectors():Array<BStyleSelector>
    {
        return selectors;
    }

    private function set_selectors(value:Array<BStyleSelector>):Array<BStyleSelector>
    {
        dispatchEvent(new BStyleEvent(BStyleEvent.SELECTOR_CHANGE));
        return this.selectors = value;
    }

    private function get_declarationBlock():BStyleDeclarationBlock
    {
        return declarationBlock;
    }

    private function set_declarationBlock(value:BStyleDeclarationBlock):BStyleDeclarationBlock
    {
        if(value.hasEventListener(BStyleEvent.DECLARATION_CHANGE))
        {
            value.removeEventListener(BStyleEvent.DECLARATION_CHANGE, declorationChangeHandler);
        }
        value.addEventListener(BStyleEvent.DECLARATION_CHANGE, declorationChangeHandler);
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_BLOCK_CHANGE));
        return this.declarationBlock = value;
    }

} // end class