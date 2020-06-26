package borris.display;

import borris.events.BStyleEvent;

import openfl.events.EventDispatcher;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 04/07/2018 (dd/mm/yyyy)
 */
class BStyleDeclarationBlock extends EventDispatcher implements IBStyleable
{
    /* Background Properties */
    public var backgroundColor(get, set):Dynamic;
    public var backgroundOpacity(get, set):Float;

    /* Border Properties */
    public var borderBevel(get, set):Dynamic;
    public var borderBevels(get, set):Int;
    public var borderColor(get, set):Dynamic;
    public var borderOpacity(get, set):Float;
    public var borderRadius(get, set):Dynamic;
    public var borderWidth(get, set):Dynamic;
    public var borderBottomWidth(get, set):Dynamic;
    public var borderLeftWidth(get, set):Dynamic;
    public var borderRightWidth(get, set):Dynamic;
    public var borderTopWidth(get, set):Dynamic;
    public var borderBottomLeftRadius(get, set):Dynamic;
    public var borderBottomRightRadius(get, set):Dynamic;
    public var borderTopLeftRadius(get, set):Dynamic;
    public var borderTopRightRadius(get, set):Dynamic;

    // TODO public var filter(get, set) :Array<Dynamic>;

    /* Basic Box Properties */
    public var margin(get, set):Dynamic;
    public var marginBottom(get, set):Float;
    public var marginLeft(get, set):Float;
    public var marginRight(get, set):Float;
    public var marginTop(get, set):Float;
    public var padding(get, set):Dynamic;
    public var paddingBottom(get, set):Float;
    public var paddingLeft(get, set):Float;
    public var paddingRight(get, set):Float;
    public var paddingTop(get, set):Float;
    public var width(get, set):Float;
    public var height(get, set):Float;
    public var maxWidth(get, set):Float;
    public var maxHeight(get, set):Float;
    public var minWidth(get, set):Float;
    public var minHeight(get, set):Float;


    // background
    //private var _background:Dynamic;
    //private var _backgroundAttachment:Dynamic;
    private var _backgroundColor:Dynamic;// = 0xffffff;
    //private var _backgroundImage:Dynamic;
    //private var _backgroundPosition:Dynamic;
    //private var _backgroundRepeat:Dynamic;
    private var _backgroundOpacity:Float = 1;


    // border
    private var _border:Dynamic;
    private var _borderStyle:Dynamic = "solid";
    private var _borderWidth:Dynamic = 0;
    private var _borderColor:Dynamic;// = 0xff0000;
    private var _borderRadius:Dynamic = 0;
    private var _borderOpacity:Float = 1;

    private var _borderBottom:Dynamic;
    private var _borderBottomColor:Dynamic;
    private var _borderBottomStyle:Dynamic;
    private var _borderBottomWidth:Dynamic;

    private var _borderLeft:Dynamic;
    private var _borderLeftColor:Dynamic;
    private var _borderLeftStyle:Dynamic;
    private var _borderLeftWidth:Dynamic;

    private var _borderRight:Dynamic;
    private var _borderRightColor:Dynamic;
    private var _borderRightStyle:Dynamic;
    private var _borderRightWidth:Dynamic;

    private var _borderTop:Dynamic;
    private var _borderTopColor:Dynamic;
    private var _borderTopStyle:Dynamic;
    private var _borderTopWidth:Dynamic;

    private var _borderBottomLeftRadius:Dynamic;
    private var _borderBottomRightRadius:Dynamic;
    private var _borderTopLeftRadius:Dynamic;
    private var _borderTopRightRadius:Dynamic;


    // text and font *****************************************************************************
    private var _color:Dynamic;
    private var _font:Dynamic;
    //private var _fontColor:Dynamic;
    private var _fontFamily:Dynamic;
    private var _fontSize:Dynamic;
    private var _fontStyle:Dynamic;
    private var _fontVarient:Dynamic;
    private var _fontWeight:Dynamic;
    //private var _textPadding:Number = 5;			// The spacing between the text and the edges of the component, and the spacing between the text and the icon, in pixels. The default value is 5.
    private var _opacity:Float;

    /* Basic Box Properties */
    private var _margin:Dynamic = 0;
    private var _marginBottom:Float = 0;
    private var _marginLeft:Float = 0;
    private var _marginRight:Float = 0;
    private var _marginTop:Float = 0;
    private var _padding:Dynamic = 0;
    private var _paddingBottom:Float = 0;
    private var _paddingLeft:Float = 0;
    private var _paddingRight:Float = 0;
    private var _paddingTop:Float = 0;
    private var _width:Float = 0;
    private var _height:Float = 0;
    private var _maxWidth:Float = 0;
    private var _maxHeight:Float = 0;
    private var _minWidth:Float = 0;
    private var _minHeight:Float = 0;


    // misc
    private var _borderBevel:Dynamic = 0;
    private var _borderBevels:Int = 1;
    private var _theme:Dynamic;

    /**
    * Groups a set of style declaration. (styles)
    */
    public function new()
    {
        super();
    }


    // NOTE: this is never used. I just have it here as a reminder.
    private function update():Void
    {
        // loop though all the instance fields
        for(styleProperty in Type.getInstanceFields(Type.getClass(this)))
        {
            // get the value of the field
            var propertyValue = Reflect.getProperty(this, styleProperty);
            //trace("Property | " + styleProperty + ": " + propertyValue);
            //trace(styleProperty + ": " + Reflect.hasField(declarationBlock, styleProperty));

            var style = new BStyle(); // for testing

            if(Reflect.hasField(style, "set_" + styleProperty))
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


    //==========================
    // COLOR PROPERTIES
    //==========================

    private function get_color():Dynamic
    {
        return _color;
    }

    private function set_color(value:Dynamic):Dynamic
    {
        return _color = value;
    }

    function get_opacity():Dynamic
    {
        return _opacity;
    }

    private function set_opacity(value:Dynamic):Dynamic
    {
        return _opacity = value;
    }


    //==========================
    // BACKGROUND PROPERTIES
    //==========================

    private function get_backgroundColor():Dynamic
    {
        return _backgroundColor;
    }

    private function set_backgroundColor(value:Dynamic):Dynamic
    {
        _backgroundColor = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        //dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE, "backgroundColor", null, this, null));
        return value;
    }


    private function get_backgroundOpacity():Float
    {
        return _backgroundOpacity;
    }

    private function set_backgroundOpacity(value:Float):Float
    {
        _backgroundOpacity = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    //==========================
    // BORDER PROPERTIES
    //==========================

    private function get_borderBevel():Dynamic
    {
        return _borderBevel;
    }

    private function set_borderBevel(value:Dynamic):Dynamic
    {
        _borderBevel = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    private function get_borderBevels():Int
    {
        return _borderBevels;
    }

    private function set_borderBevels(value:Int):Int
    {
        _borderBevels = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    private function get_borderColor():Dynamic
    {
        return _borderColor;
    }

    private function set_borderColor(value:Dynamic):Dynamic
    {
        _borderColor = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    private function get_borderOpacity():Float
    {
        return _borderOpacity;
    }

    private function set_borderOpacity(value:Float):Float
    {
        _borderOpacity = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    private function get_borderRadius():Dynamic
    {
        return _borderRadius;
    }

    private function set_borderRadius(value:Dynamic):Dynamic
    {
        _borderRadius = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    private function get_borderWidth():Dynamic
    {
        return _borderWidth;
    }

    private function set_borderWidth(value:Dynamic):Dynamic
    {
        _borderWidth = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    //==========================
    // INDIVIDUAL BORDER PROPERTIES
    //==========================

    /*public function get borderBottom():Dynamic
		{
			return _borderBottom;
		}

		public function set borderBottom(value:Dynamic):Dynamic
		{
			_borderBottom = value;
			draw();
		}


		/**
		 * Gets or sets
		 */
    /*public function get borderBottomColor():Dynamic
		{
			return _borderBottomColor;
		}

		public function set borderBottomColor(value:Dynamic):Dynamic
		{
			_borderBottomColor = value;
			draw();
		}
		*/

    /*public function get borderBottomStyle():Dynamic
		{
			return _borderBottomStyle;
		}

		public function set borderBottomStyle(value:Dynamic):Dynamic
		{
			_borderBottomStyle = value;
			draw();
		}
		*/

    private function get_borderBottomWidth():Dynamic
    {
        return _borderBottomWidth;
    }

    private function set_borderBottomWidth(value:Dynamic):Dynamic
    {
        _borderBottomWidth = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    /*public function get borderLeft():Dynamic
		{
			return _borderLeft;
		}

		public function set borderLeft(value:Dynamic):Dynamic
		{
			_borderLeft = value;
			draw();
		}
		*/

    /*public function get borderLeftColor():Dynamic
		{
			return _borderLeftColor;
		}

		public function set borderLeftColor(value:Dynamic):Dynamic
		{
			_borderLeftColor = value;
			draw();
		}
		*/

    /*public function get borderLeftStyle():Dynamic
		{
			return _borderLeftStyle;
		}

		public function set borderLeftStyle(value:Dynamic):Dynamic
		{
			_borderLeftStyle = value;
			draw();
		}
		*/

    private function get_borderLeftWidth():Dynamic
    {
        return _borderLeftWidth;
    }

    private function set_borderLeftWidth(value:Dynamic):Dynamic
    {
        _borderLeftWidth = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    /*public function get borderRight():Dynamic
		{
			return _borderRight;
		}

		public function set borderRight(value:Dynamic):Dynamic
		{
			_borderRight = value;
			draw();
		}
		*/

    /*public function get borderRightColor():Dynamic
		{
			return _borderRightColor;
		}

		public function set borderRightColor(value:Dynamic):Dynamic
		{
			_borderRightColor = value;
			draw();
		}
		*/

    /*public function get borderRightStyle():Dynamic
		{
			return _borderRightStyle;
		}

		public function set borderRightStyle(value:Dynamic):Dynamic
		{
			_borderRightStyle = value;
			draw();
		}
		*/

    private function get_borderRightWidth():Dynamic
    {
        return _borderRightWidth;
    }

    private function set_borderRightWidth(value:Dynamic):Dynamic
    {
        _borderRightWidth = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    /*public function get borderTop():Dynamic
		{
			return _borderTop;
		}

		public function set borderTop(value:Dynamic):Dynamic
		{
			_borderTop = value;
			draw();
		}
		*/

    /*public function get borderTopColor():Dynamic
		{
			return _borderTopColor;
		}

		public function set borderTopColor(value:Dynamic):Dynamic
		{
			_borderTopColor = value;
			draw();
		}
		*/

    /*public function get borderTopStyle():Dynamic
		{
			return _borderTopStyle;
		}

		public function set borderTopStyle(value:Dynamic):Dynamic
		{
			_borderTopStyle = value;
			draw();
		}
		*/

    private function get_borderTopWidth():Dynamic
    {
        return _borderTopWidth;
    }

    private function set_borderTopWidth(value:Dynamic):Dynamic
    {
        _borderTopWidth = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    private function get_borderBottomLeftRadius():Dynamic
    {
        return _borderBottomLeftRadius;
    }

    private function set_borderBottomLeftRadius(value:Dynamic):Dynamic
    {
        _borderBottomLeftRadius = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    private function get_borderBottomRightRadius():Dynamic
    {
        return _borderBottomRightRadius;
    }

    private function set_borderBottomRightRadius(value:Dynamic):Dynamic
    {
        _borderBottomRightRadius = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    private function get_borderTopLeftRadius():Dynamic
    {
        return _borderTopLeftRadius;
    }

    private function set_borderTopLeftRadius(value:Dynamic):Dynamic
    {
        _borderTopLeftRadius = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    private function get_borderTopRightRadius():Dynamic
    {
        return _borderTopRightRadius;
    }

    private function set_borderTopRightRadius(value:Dynamic):Dynamic
    {
        _borderTopRightRadius = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }


    //================================================================
    // FILTER
    //================================================================


    private function get_filter():Array<Dynamic>
    {
        //return _container.filters;
        return [];
    }

    private function set_filter(value:Array<Dynamic>):Array<Dynamic>
    {
        /*_container.filters = value;
		_values.filters = cast(value, BitmapFilter);
		dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
		return value;*/

        return [];
    }


    //================================================================
    // BASIC BOX PROPERTIES
    //================================================================

    private function get_margin():Dynamic
    {
        return _margin;
    }

    private function set_margin(value:Dynamic):Dynamic
    {
        _margin = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_marginBottom():Float
    {
        return _marginBottom;
    }

    private function set_marginBottom(value:Float):Float
    {
        _marginBottom = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_marginLeft():Float
    {
        return _marginLeft;
    }

    private function set_marginLeft(value:Float):Float
    {
        _marginLeft = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_marginRight():Float
    {
        return _marginRight;
    }

    private function set_marginRight(value:Float):Float
    {
        _marginRight = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_marginTop():Float
    {
        return _marginTop;
    }

    private function set_marginTop(value:Float):Float
    {
        _marginTop = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_padding():Dynamic
    {
        return _padding;
    }

    private function set_padding(value:Dynamic):Dynamic
    {
        _padding = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_paddingBottom():Float
    {
        return _paddingBottom;
    }

    private function set_paddingBottom(value:Float):Float
    {
        _paddingBottom = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_paddingLeft():Float
    {
        return _paddingLeft;
    }

    private function set_paddingLeft(value:Float):Float
    {
        _paddingLeft = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_paddingRight():Float
    {
        return _paddingRight;
    }

    private function set_paddingRight(value:Float):Float
    {
        _paddingRight = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_paddingTop():Float
    {
        return _paddingTop;
    }

    private function set_paddingTop(value:Float):Float
    {
        _paddingTop = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_width():Float
    {
        return _width;
    }

    private function set_width(value:Float):Float
    {
        _width = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_height():Float
    {
        return _height;
    }

    private function set_height(value:Float):Float
    {
        _height = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_maxWidth():Float
    {
        return _maxWidth;
    }

    private function set_maxWidth(value:Float):Float
    {
        _maxWidth = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_maxHeight():Float
    {
        return _maxHeight;
    }

    private function set_maxHeight(value:Float):Float
    {
        _maxHeight = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_minWidth():Float
    {
        return _minWidth;
    }

    private function set_minWidth(value:Float):Float
    {
        _minWidth = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

    private function get_minHeight():Float
    {
        return _minHeight;
    }

    private function set_minHeight(value:Float):Float
    {
        _minHeight = value;
        dispatchEvent(new BStyleEvent(BStyleEvent.DECLARATION_CHANGE));
        return value;
    }

} // end class
