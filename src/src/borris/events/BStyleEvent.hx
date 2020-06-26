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

package borris.events;


import borris.display.BStyleRuleset;
import borris.display.BStyleSelector;
import borris.display.BStyleDeclarationBlock;
import borris.display.BStyle;

import openfl.display.DisplayObjectContainer;
import openfl.events.Event;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 09/03/2016 (dd/mm/yyyy)
 */
class BStyleEvent extends Event
{
    /**
     * [read-only] gets the owner DisplayObjectContainer for the BStyle object.
     * This property is set when the BStyleEvent is instantiated and cannot be changed.
     *
     * @see BUIComponent.style
     * @see BElement.style
     *
     * @private make setter eventually
     */
    public var styleLink(get, never):DisplayObjectContainer;

    // constants
    public static inline var DECLARATION_CHANGE:String = "declarationChange";
    public static inline var DECLARATION_BLOCK_CHANGE:String = "declarationBlockChange";
    public static inline var SELECTOR_CHANGE:String = "selectorChange";
    public static inline var STYLE_CHANGE:String = "styleChange";
    public static inline var STYLE_CLEAR:String = "styleClear";
    //public static const SET:String = "set";
    //public static const REMOVE:String = "remove";

    // TODO make these only getters
    public var property:String;
    public var selector:BStyleSelector;
    public var declorationBlock:BStyleDeclarationBlock;
    public var reluSet:BStyleRuleset;


    //private var _styleOwner:DisplayObjectContainer;


    //public function new(type:String, styleOwner:DisplayObjectContainer)
    public function new(type:String, property:String = null, selector:BStyleSelector = null, declorationBlock:BStyleDeclarationBlock = null, ruleSet:BStyleRuleset = null)
    {
        super(type, false, false);

        this.property = property;
        this.selector = selector;
        this.declorationBlock = declorationBlock;
        this.reluSet = ruleSet;
    }


    private function get_styleLink():DisplayObjectContainer
    {
        return cast((target), BStyle).link;
    }

} // end class

