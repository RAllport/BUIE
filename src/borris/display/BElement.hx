package borris.display;

import Type;
import openfl.display.Sprite;
import openfl.events.Event;

// TODO Implement 'Pseudo class' functionality. eg 'addPseudoClass(name:String), removePseudoClass(name:String), getPseudoClass(es)()'
/**
 * The BElement is a 'styleable' DisplayObject that can be resized and layed out.
 * Use it for styleable skins and backgrounds.
 * Basically an HTML element.
 *
 * @author Rohaan Allport
 * @creation-date 19/09/2018 (dd/mm/yyyy)
 */
class BElement extends Sprite
{
    /**
	 * Gets or sets the style for this element.
	 */
    public var style(get, set):BStyle;

    private var _width:Float = 0;
    private var _height:Float = 0;
    private var _pseudoClasses:Array<Dynamic> = [];
    private var _style:BStyle;


    // testing
    public var classes(get, set):Array<String>;
    public var element(get, never):String;
    public var id(get, set):String;

    private var _class:Array<String>;
    private var _element:String;
    private var _id:String;
    private var _childElements:Array<BElement> = [];
    // end testing

    public function new()
    {
        super();

        _style = new BStyle(this);

        // get the class name of this class and use it as the element name
        function trimClassName(c:Class<Dynamic>):String
        {
            var name = Type.getClassName(c);

            // 2 different ways to trim the class name
            //name = name.split(".").pop();
            name = name.substring(name.lastIndexOf(".") + 1, name.length);

            return name;
        } // end function

        _element = trimClassName(Type.getClass(this));
    }


    //==================================================================================================================
    // HANDLERS
    //==================================================================================================================

    //==================================================================================================================
    // FUNCTIONS
    //==================================================================================================================


    /**
	 * Draws the BElement object using the BStyle properties
	 */
    private function draw():Void
    {
        // testing
        _style.drawNow();
        /*for(childElement in _childElements)
        {
            // TODO finish this
            childElement.draw();
        } // end for*/

    } // end function


    /**
    *
    */
    // TODO Not yet complete
    public function addPseudoClasses(nameString, style:BStyle = null):Dynamic
    {
        return _pseudoClasses.push({name:name, style:style});
    } // end function


    /**
    *
    */
    // TODO Not yet complete
    public function getPseudoClasses(name:String):Dynamic
    {
        for(state in _pseudoClasses)
        {
            if(state.name == name)
            {
                return state;
            } // end for

        } // end for

        return null;
    } // end function


    /**
    *
    */
    // TODO Not yet complete
    public function removeState(name:String):Dynamic
    {
        for(state in _pseudoClasses)
        {
            if(state.name == name)
            {
                return _pseudoClasses.remove(state);
            } // end for

        } // end for

        return null;
    } // end function


    /**
    *
    **/
    public function addElement(element:BElement):BElement
    {
        _childElements.push(element);
        addChild(element);
        return element;
    } // end function


    /**
    *
    **/
    public function removeElement(element:BElement):BElement
    {
        _childElements.remove(element);
        if(contains(element))
        {removeChild(element);};
        return element;
    } // end function



    //==================================================================================================================
    // SET AND GET
    //==================================================================================================================


    private function get_classes():Array<String>
    {
        return _class;
    }

    private function set_classes(value:Array<String>):Array<String>
    {
        _class = value;
        return _class;
    }

    private function get_element():String
    {
        return _element;
    }

    private function get_id():String
    {
        return _id;
    }

    private function set_id(value:String):String
    {
        _id = value;
        return _id;
    }

    private function get_style():BStyle
    {
        return _style;
    }

    private function set_style(value:BStyle):BStyle
    {
        _style = value;
        _style.link = this;
        //_style.values = value.values;
        _style.drawNow();
        //dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE, this));
        return value;
    }


    #if flash
	/**
	 * Gets or sets the width of the component, in pixels.
	 *
	 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
	 */
	@:getter(width)
	private function get_width():Float
    {
        return _width * scaleX;
    }

	@:setter(width)
    private function set_width(value:Float):Void
    {
        _width = Math.ceil(value);
        draw();
        dispatchEvent(new Event(Event.RESIZE));
    }


    /**
	 * Gets or sets the height of the component, in pixels.
	 *
	 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
	 */
	@:getter(height)
    private function get_height():Float
    {
        return _height * scaleY;
    }

	@:setter(height)
	private function set_height(value:Float):Void
    {
        _height = Math.ceil(value);
        draw();
        dispatchEvent(new Event(Event.RESIZE));
    }
	#else
    /**
	 * Gets or sets the width of the component, in pixels.
	 *
	 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
	 */
    override private function get_width():Float
    {
        return _width * scaleX;
        //return Math.max(_width, getBounds(this).width);
    }
    override private function set_width(value:Float):Float
    {
        _width = Math.ceil(value);
        draw();
        dispatchEvent(new Event(Event.RESIZE));
        return value;
    }


    /**
	 * Gets or sets the height of the component, in pixels.
	 *
	 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
	 */
    override private function get_height():Float
    {
        return _height * scaleY;
        //return Math.max(_height, getBounds(this).height);
    }
    override private function set_height(value:Float):Float
    {
        _height = Math.ceil(value);
        draw();
        dispatchEvent(new Event(Event.RESIZE));
        return value;
    }
    #end


} // end class
