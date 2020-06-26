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
    //public var styleLink(get, never):DisplayObjectContainer;

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



    public function new(type:String, property:String = null, selector:BStyleSelector = null, declorationBlock:BStyleDeclarationBlock = null, ruleSet:BStyleRuleset = null)
    {
        super(type, false, false);

        this.property = property;
        this.selector = selector;
        this.declorationBlock = declorationBlock;
        this.reluSet = ruleSet;
    }


    /*private function get_styleLink():DisplayObjectContainer
    {
        return cast((target), BStyle).link;
    }*/

} // end class

