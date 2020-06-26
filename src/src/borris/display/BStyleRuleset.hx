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
    //public var selector:BStyleSelector;
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
        //update();
    } // end function


    /**
    *
    */
    public function update(selector:BStyleSelector = null):Void
    {
        /* NOTE:
         * Loop though the BStyle.styles array
         * get their 'link' object (the BElement they are linked to)
         * find all 'x' types selectors (element then class, then id) (and of the selector name)
         * set their style properties to that of the declaration block
         * update the styles/elements
         */

        /*
         * Update all/only the elements of that selector. (using an array of elements)
         */

        trace("updating!");
        /*
         *
         */
        function setStyleToDecloration(style:BStyle):Void
        {
            // loop though all the instance fields
            for(styleProperty in Type.getInstanceFields(Type.getClass(declarationBlock)))
            {
                // get the value of the field
                var propertyValue = Reflect.getProperty(declarationBlock, styleProperty);
                //trace("Property | " + styleProperty + ": " + propertyValue);
                //trace(styleProperty + ": " + Reflect.hasField(declarationBlock, styleProperty));

                if(Reflect.hasField(style, styleProperty)) //  && styleProperty.substring(0, 4) == "set_"
                {
                    trace(styleProperty + ": " + Reflect.getProperty(style, styleProperty));

                    // if propertyValue is not null or not NaN
                    // set style object property to propertyValue

                    //trace("PropertyValue Tyle: " + Type.typeof(propertyValue));

                    if(Std.is(propertyValue, Float))
                    {
                        if(!Math.isNaN(propertyValue))
                        {
                            Reflect.setProperty(style, styleProperty, propertyValue);
                        }
                    } // end if
                    else if(Std.is(propertyValue, String))
                    {
                        // TODO do better validation of string
                        Reflect.setProperty(style, styleProperty, propertyValue);
                    } // end if

                    // trace(styleProperty + ": " + Reflect.getProperty(style, styleProperty) + "\n");
                } // end if

            } // end for
        } // end function

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
                        setStyleToDecloration(bElement.style);
                    } // end if
                } // end if
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
