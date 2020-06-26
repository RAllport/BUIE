package borris.display;

import openfl.events.EventDispatcher;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 04/07/2018 (dd/mm/yyyy)
 */
class BStyleSelector extends EventDispatcher
{
    public var type:BStyleSelectorType;
    public var name:String;

    /**
    * Handles precedence and nested elements
    */
    public function new(type:BStyleSelectorType, name:String)
    {
        super();

        this.type = type;
        this.name = name;
        /* NOTE: each time a new selector is created, an array to hold the elements with this selector name should be
         * created. to index them.
         * these arrays are private
         * (eg. and array to hold all BButton elements.
         */
    }

} // end class