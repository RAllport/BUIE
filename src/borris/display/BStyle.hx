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

import haxe.Constraints.Function;

import openfl.display.DisplayObjectContainer;
import openfl.display.Graphics;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix;

import borris.events.BStyleEvent;

// TODO - recalculate gradient matrices

// Use the below for setting style properties.
// TODO use class property and id properties in BElement as selectors, and Reflect api to determine the type of element.
//
// TODO instead of redrawing the whole style/object. maybe mark a property as invalid. then redraw only that section of the style.
//
// TODO Finish BStyleEvent a style dispatches a new STYLE_CHANGE event. the target is that style.
// TODO has a property for style declaration(s) (they was/were changed)
// TODO only this style declarations get updated/redrawn.


// TODO border top, bottom, left and right color.
// TODO add support for box-shadow (use DisplayObject.filters)
// use Bitmap and BitmapData amd BitmapFilter
// TODO add support for background-blend-mode
// TODO add support for background-clip
// TODO add support for background-image
// TODO add support for background-origin
// TODO add support for backgorund-position
// TODO add support for background-repeat
// TODO add support for background-size
//
// TODO add support for filter
// TODO add support for min, max, height and width
// TODO add support for opacity
// TODO add support for outline
// TODO add support for transitions
/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 08/06/2014 (dd/mm/yyyy)
 */
class BStyle extends EventDispatcher implements IBStyleable
{
    /**
	 * [read-only] The DisplayObjectContainer this style belongs to.
	 *
	 * @private Gets or sets the link DisplayObjectContainer of this BStyle object.
	 */
    public var link(get, set):DisplayObjectContainer;

    /* Color Properties */
    // TODO public var color(get, set):Dynamic;
    // TODO public var opacity(get, set):Dynamic;

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

    /**
	*
	*/
    public var values(get, set):Array<Dynamic>;


    //==================================================================================================================
    // PRIVATE VARIABLES
    //==================================================================================================================

    // assets
    private var _container:DisplayObjectContainer;
    private var _canvas:Shape;
    private var _graphics:Graphics;


    // other
    private var _values:Dynamic = { };
    private var _placeHolderFlag:Bool = false; // Flag used to know whether a place holder container was made in the contructor.


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

    // testing
    // static styles array to hold all BStyle object when they are created
    // TODO make this only getter
    public static var styles:Array<BStyle> = new Array<BStyle>();

    public function new(link:DisplayObjectContainer = null)
    {
        super();

        // add the newly create style to the static STYLES array
        styles.push(this);

        //container = link as DisplayObjectContainer;

        // check to see if the link is a regular DisplayObjectContainer or a Sprite.
        if(Std.is(link, Sprite))
        {
            _graphics = cast((link), Sprite).graphics;
            _container = cast(link, DisplayObjectContainer);
        }
        else if(Std.is(link, DisplayObjectContainer))
        {
            _container = cast(link, DisplayObjectContainer);
            _canvas = new Shape();
            _graphics = _canvas.graphics;
            _container.addChild(_canvas);
        }
        else if(link == null)
        {
            _container = new Sprite();
            _graphics = cast((_container), Sprite).graphics;
            _placeHolderFlag = true;
        }


        //NOTE: AS3 code. need to convert to Haxe.
        // populate the _values object with all readable and writable properties
        /*var typeDef:XML = describeType(this);
        var props:Array = [];

        for each(var propXML:XML in typeDef.accessor.(@access == "readwrite"))
        {
            props.push(propXML.@name);
        }

        for each(var prop:String in props)
        {
            _values[prop] = this[prop];
        }*/
        // end AS3 code


        // populate the _values object with all readable and writable properties
        /*for (propXML in typeDef.accessor.(@access == "readwrite"))
		{
			props.push(propXML.att.name);
		}

		for (prop in props)
		{
			//_values[prop] = this[prop];
			//Reflect.setField(_values, Std.string(prop), this[prop]);
		}*/

        // testing
        // eventHandling
        //_container.addEventListener(BStyleEvent.STYLE_CHANGE, styleChangeHandler);


    }


    //**************************************** HANDLERS *********************************************


    /*private function styleChangeHandler(event:BStyleEvent):void
		{
			// clear the graphics
			_graphics.clear();

			// remove the canvas Shape object if there is one.
			// (A canvas is made when the link is just a regular DisplayObjectContainer and not a Sprite)
			if (_canvas)
			{
				_container.removeChild(_canvas);
			} // end if

			// TBH, I don't think I really need this.
			if (_placeHolderFlag)
			{
				_container = null;
			}


			// set the new container
			_container = event.styleOwner;

			// check to see if the container is a regular DisplayObjectContainer or a Sprite.
			if (_container is Sprite)
			{
				_graphics = Sprite(_container).graphics;
				_container = link as DisplayObjectContainer;
			}
			else if (_container is DisplayObjectContainer)
			{
				// keep the previous Shape object so that we dont have to create a new own, and dumb the old one.
				// just use the one we already have.

				//_canvas = new Shape();
				//_graphics = _canvas.graphics;
				_container.addChild(_canvas);
			}

			trace("style change!");

		} // end function styleChangeHandler*/


    //**************************************** FUNCTIONS ********************************************


    /**
	 * Draws the shapes.
	 * Shapes include:
	 * - background
	 * - border
	 * - outine
	 */
    @:allow(borris.managers.BStyleManager)
    private function draw():Void
    {
        // a tonne of ifs, fors and switch-case to set styles

        // Note: Drawing is now done directly on the link

        // set the width and height of the style so that the shapes can be drawn.
        _width = _container.width;
        _height = _container.height;

        // create some varibales for drawing and making sure they are all numeric values.
        var bW:Float = setBorderWidth(_borderWidth);
        var bR:Float = setBorderRadius(_borderRadius); //
        var innerBR:Float = Math.max(bR - (bW * 2), 0); //

        var btw:Float = ((_borderTopWidth != null)) ? setBorderWidth(_borderTopWidth) : bW; // border top width
        var bbw:Float = ((_borderBottomWidth != null)) ? setBorderWidth(_borderBottomWidth) : bW; // border bottom width
        var blw:Float = ((_borderLeftWidth != null)) ? setBorderWidth(_borderLeftWidth) : bW; // border left width
        var brw:Float = ((_borderRightWidth != null)) ? setBorderWidth(_borderRightWidth) : bW; // border right width

        var btlr:Float = ((_borderTopLeftRadius != null)) ? setBorderRadius(_borderTopLeftRadius) : bR; // border top left radius
        var btrr:Float = ((_borderTopRightRadius != null)) ? setBorderRadius(_borderTopRightRadius) : bR; // border top right radius
        var bblr:Float = ((_borderBottomLeftRadius != null)) ? setBorderRadius(_borderBottomLeftRadius) : bR; // border bottom left radius
        var bbrr:Float = ((_borderBottomRightRadius != null)) ? setBorderRadius(_borderBottomRightRadius) : bR; // border bottom right radius


        // I'm not really sure, but these culculations seem good so far.
        var ibtlr:Float = Math.max(btlr - (btw + blw) / 2, 0); // inner border top left radius
        var ibtrr:Float = Math.max(btrr - (btw + brw) / 2, 0); // inner border top right radius
        var ibblr:Float = Math.max(bblr - (bbw + blw) / 2, 0); // inner border bottom left radius
        var ibbrr:Float = Math.max(bbrr - (bbw + brw) / 2, 0); // inner border bottom right radius


        // variables for gradient fills
        //var g:BGradient = null;
        //var matrix:Matrix;

        // variables for bevels
        //var bBs:uint;

        /**
		*
		*/
        /*var makeGradientMatrix:Function = function(style:String):Matrix
            //var makeGradientMatrix:String->Matrix = function(style:String):Matrix
        {
            var matrix:Matrix = new Matrix();

            switch (style)
            {
                // Note: might have to translate the position of the gradient. (last 2 values)

                case "background":
                    matrix.createGradientBox(_width - (bW * 2), _height - (bW * 2), g.angle * Math.PI / 180, 0, 0);

                case "border":
                    matrix.createGradientBox(_width, _height, g.angle * Math.PI / 180, 0, 0);

                case "outline":
                    matrix.createGradientBox(_width + 2, _height + 2, g.angle * Math.PI / 180, 0, 0);
            } // end switch

            return matrix;
        } // end function*/


        /**
		 * Test the color type (uint, string, gradient).
		 *
		 * @see setGraphicsColorByString
		 * Sets the graphics color and alpha.
		 *
		 * Creates and appropriate matrix for style if colorType is Gradient.
		 *
		 * @param	colorType
		 * @param	alpha
		 * @param	style
		 *
		 */
        var testAndSetColorTypeOfStyle:Dynamic->Float->String->Void = function(colorType:Dynamic, alpha:Float, style:String):Void
        {
            if(Std.is(colorType, Int))
            {
                _graphics.beginFill(cast(colorType, Int), alpha);
            }
            else if(Std.is(colorType, String))
            {
                setGraphicsColorByString(_graphics, cast(colorType, String), alpha);
            }
            /*else if(Std.is(colorType, BGradient))
            {
                g = cast(colorType, BGradient);
                _graphics.beginGradientFill(g.type, g.colors, g.alphas, g.ratios, makeGradientMatrix(style));
            }*/
        } // end function

        /*
		 * Started doing code for bevel. Going well but got tired.
		 */
        // starting at the top left
        /*border.graphics.moveTo(bR, 0);
		border.graphics.lineTo(_width - bR, 0);
		border.graphics.lineTo(_width, bR);
		border.graphics.lineTo(_width, _height - bR);
		border.graphics.lineTo(_width - bR, _height);
		border.graphics.lineTo(bR, _height);
		border.graphics.lineTo(0, _height - bR);
		border.graphics.lineTo(0, bR);

		border.graphics.moveTo(bR, bW);
		border.graphics.lineTo(_width - bR, bW);
		border.graphics.lineTo(_width - bW, bR);
		border.graphics.lineTo(_width - bW, _height - bR);
		border.graphics.lineTo(_width - bR, _height - bW);
		border.graphics.lineTo(bR, _height - bW);
		border.graphics.lineTo(bW, _height - bR);
		border.graphics.lineTo(bW, bR);*/


        // clear the graphics
        _graphics.clear();

        // draw the margin


        // draw the border
        testAndSetColorTypeOfStyle(_borderColor, _borderOpacity, "border");
        _graphics.drawRoundRectComplex(0, 0, _width, _height, btlr, btrr, bblr, bbrr);
        _graphics.drawRoundRectComplex(blw, btw, _width - (blw + brw), _height - (btw + bbw), ibtlr, ibtrr, ibblr, ibbrr);

        // draw the background
        testAndSetColorTypeOfStyle(_backgroundColor, _backgroundOpacity, "background");
        _graphics.drawRoundRectComplex(blw, btw, _width - (blw + brw), _height - (btw + bbw), ibtlr, ibtrr, ibblr, ibbrr);

    } // end function


    /**
	 *
	 */
    public function drawNow():Void
    {
        draw();
    } // end function


    /**
	 * Clears all the graphics that were drawn to this style's shapes.
	 */
    public function clear():Void
    {
        _graphics.clear();
    } // end function


    /**
	 * Sets the color of a shape using a string.
	 * There are so many CSS color strongs that it would be insane to add a switch statement for each shape
	 *
	 * @param	shape
	 * @param	color
	 */
    private function setGraphicsColorByString(g:Graphics, color:String, opacity:Float = 1):Void
    {
        //http://www.w3schools.com/cssref/css_colornames.asp

        switch (color)
        {
            case "red":
                g.beginFill(0xFF0000, opacity);

            case "green":
                g.beginFill(0x00FF00, opacity);

            case "blue":
                g.beginFill(0x0000FF, opacity);

            case "yellow":
                g.beginFill(0xFFFF00, opacity);

            case "white":
                g.beginFill(0xFFFFFF, opacity);

            case "black":
                g.beginFill(0x000000, opacity);
        } // end switch


        return;
    } // end function


    /**
	 *
	 *
	 * @param	width
	 * @return
	 */
    private function setBorderWidth(width:Dynamic):Float
    {
        //trace("border width:" + width);
        if(Std.is(width, Float))
        {
            //return try cast(width, Float) catch(e:Dynamic) null;
            return cast(width, Float);
        }
        else if(Std.is(width, String))
        {
            switch (width)
            {
                case "medium":
                    return 3;

                case "thick":
                    return 5;

                case "thin":
                    return 1;
            }
        }

        return 0;
    } // end function


    /**
	 *
	 *
	 * @param	radius
	 * @return
	 */
    private function setBorderRadius(radius:Dynamic):Float
    {
        if(Std.is(radius, Float))
        {
            return Math.max(0, cast(radius, Float));
        }
        else if(Std.is(radius, String))
        {
            var tempstring:String = cast(radius, String);

            //var i:Int = tempstring.search("%");
            var i:Int = tempstring.indexOf("%", 0);

            // FIXME
            if(i >= 0)
            {
                if(i == tempstring.length - 1)
                {
                    var Float:Float = Std.parseFloat(tempstring.substring(0, tempstring.length - 2));
                    return Math.min(_width, _height) * (Float / 100);
                }
                else
                {
                    return 0;
                }
            }
        }

        return 0;
    } // end function


    //TESTING
    public static function setStyleableFromStyleable(to:IBStyleable, from:IBStyleable):Void
    {
        to.backgroundColor = from.backgroundColor;
        to.backgroundOpacity = from.backgroundOpacity;
        to.borderBevel = from.borderBevel;
        to.borderBevels = from.borderBevels;
        to.borderColor = from.borderColor;
        to.borderOpacity = from.borderOpacity;
        to.borderRadius = from.borderRadius;
        to.borderWidth = from.borderWidth;
        to.borderBottomWidth = from.borderBottomWidth;
        to.borderLeftWidth = from.borderLeftWidth;
        to.borderRightWidth = from.borderRightWidth;
        to.borderTopWidth = from.borderTopWidth;
        to.borderBottomLeftRadius = from.borderBottomLeftRadius;
        to.borderBottomRightRadius = from.borderBottomRightRadius;
        to.borderTopLeftRadius = from.borderTopLeftRadius;
        to.borderTopRightRadius = from.borderTopRightRadius;
        to.margin = from.margin;
        to.marginBottom = from.marginBottom;
        to.marginLeft = from.marginLeft;
        to.marginRight = from.marginRight;
        to.marginTop = from.marginTop;
        to.padding = from.padding;
        to.paddingBottom = from.paddingBottom;
        to.paddingLeft = from.paddingLeft;
        to.paddingRight = from.paddingRight;
        to.paddingTop = from.paddingTop;
        to.width = from.width;
        to.height = from.height;
        to.maxWidth = from.maxWidth;
        to.maxHeight = from.maxHeight;
        to.minWidth = from.minWidth;
        to.minHeight = from.minHeight;

    } // end function


    public static function setDefaultStyle(styleable:IBStyleable):Void
    {
        styleable.backgroundColor = null;
        styleable.backgroundOpacity = 1;
        styleable.borderBevel = 0;
        styleable.borderBevels = 1;
        styleable.borderColor = null;
        styleable.borderOpacity = 1;
        styleable.borderRadius = 0;
        styleable.borderWidth = 0;
        styleable.borderBottomWidth = null;
        styleable.borderLeftWidth = null;
        styleable.borderRightWidth = null;
        styleable.borderTopWidth = null;
        styleable.borderBottomLeftRadius = null;
        styleable.borderBottomRightRadius = null;
        styleable.borderTopLeftRadius = null;
        styleable.borderTopRightRadius = null;

        styleable.margin = null;
        styleable.marginBottom = 0;
        styleable.marginLeft = 0;
        styleable.marginRight = 0;
        styleable.marginTop = 0;
        styleable.padding = 0;
        styleable.paddingBottom = 0;
        styleable.paddingLeft = 0;
        styleable.paddingRight = 0;
        styleable.paddingTop = 0;
        styleable.width = 0;
        styleable.height = 0;
        styleable.maxWidth = 0;
        styleable.maxHeight = 0;
        styleable.minWidth = 0;
        styleable.minHeight = 0;
    } // end function


    //**************************************** SET AND GET ******************************************


    private function get_link():DisplayObjectContainer
    {
        return _container;
    }

    private function set_link(value:DisplayObjectContainer):DisplayObjectContainer
    {
        //_container = value;

        // clear the graphics
        _graphics.clear();

        // remove the canvas Shape object if there is one.
        // (A canvas is made when the link is just a regular DisplayObjectContainer and not a Sprite)
        if(_canvas != null)
        {
            _container.removeChild(_canvas);
        } // TBH, I don't think I really need this.    // end if


        if(_placeHolderFlag)
        {
            _container = null;
        } //_container = event.styleOwner;    // set the new container


        _container = value;

        // check to see if the container is a regular DisplayObjectContainer or a Sprite.
        if(Std.is(_container, Sprite))
        {
            _graphics = cast((_container), Sprite).graphics;
            _container = try cast(link, DisplayObjectContainer)
            catch(e:Dynamic) null;
        }
        else if(Std.is(_container, DisplayObjectContainer))
        {
            // keep the previous Shape object so that we dont have to create a new own, and dumb the old one.
            // just use the one we already have.

            //_canvas = new Shape();
            //_graphics = _canvas.graphics;
            _container.addChild(_canvas);
        }
        return value;
    }


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
        _values.backgroundColor = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    private function get_backgroundOpacity():Float
    {
        return _backgroundOpacity;
    }

    private function set_backgroundOpacity(value:Float):Float
    {
        _backgroundOpacity = value;
        _values.backgroundOpacity = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
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
        _values.borderBevel = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    private function get_borderBevels():Int
    {
        return _borderBevels;
    }

    private function set_borderBevels(value:Int):Int
    {
        _borderBevels = value;
        _values.borderBevels = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    private function get_borderColor():Dynamic
    {
        return _borderColor;
    }

    private function set_borderColor(value:Dynamic):Dynamic
    {
        _borderColor = value;
        _values.borderColor = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    private function get_borderOpacity():Float
    {
        return _borderOpacity;
    }

    private function set_borderOpacity(value:Float):Float
    {
        _borderOpacity = value;
        _values.borderOpacity = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    private function get_borderRadius():Dynamic
    {
        return _borderRadius;
    }

    private function set_borderRadius(value:Dynamic):Dynamic
    {
        _borderRadius = value;
        _values.borderRadius = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    private function get_borderWidth():Dynamic
    {
        return _borderWidth;
    }

    private function set_borderWidth(value:Dynamic):Dynamic
    {
        _borderWidth = value;
        _values.borderWidth = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
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
        _values.borderBottomWidth = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
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
        _values.borderLeftWidth = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
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
        _values.borderRightWidth = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
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
        _values.borderTopWidth = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    private function get_borderBottomLeftRadius():Dynamic
    {
        return _borderBottomLeftRadius;
    }

    private function set_borderBottomLeftRadius(value:Dynamic):Dynamic
    {
        _borderBottomLeftRadius = value;
        _values.borderBottomLeftRadius = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    private function get_borderBottomRightRadius():Dynamic
    {
        return _borderBottomRightRadius;
    }

    private function set_borderBottomRightRadius(value:Dynamic):Dynamic
    {
        _borderBottomRightRadius = value;
        _values.borderBottomRightRadius = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    private function get_borderTopLeftRadius():Dynamic
    {
        return _borderTopLeftRadius;
    }

    private function set_borderTopLeftRadius(value:Dynamic):Dynamic
    {
        _borderTopLeftRadius = value;
        _values.borderTopLeftRadius = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    private function get_borderTopRightRadius():Dynamic
    {
        return _borderTopRightRadius;
    }

    private function set_borderTopRightRadius(value:Dynamic):Dynamic
    {
        _borderTopRightRadius = value;
        _values.borderTopRightRadius = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
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
		dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
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
        _values.margin = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_marginBottom():Float
    {
        return _marginBottom;
    }

    private function set_marginBottom(value:Float):Float
    {
        _marginBottom = value;
        _values.marginBottom = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_marginLeft():Float
    {
        return _marginLeft;
    }

    private function set_marginLeft(value:Float):Float
    {
        return _marginLeft = value;

        _marginLeft = value;
        _values.marginLeft = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_marginRight():Float
    {
        return _marginRight;
    }

    private function set_marginRight(value:Float):Float
    {
        return _marginRight = value;

        _marginRight = value;
        _values.marginRight = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_marginTop():Float
    {
        return _marginTop;
    }

    private function set_marginTop(value:Float):Float
    {
        return _marginTop = value;

        _marginTop = value;
        _values.marginTop = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_padding():Dynamic
    {
        return _padding;
    }

    private function set_padding(value:Dynamic):Dynamic
    {
        return _padding = value;

        _padding = value;
        _values.padding = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_paddingBottom():Float
    {
        return _paddingBottom;
    }

    private function set_paddingBottom(value:Float):Float
    {
        return _paddingBottom = value;

        _paddingBottom = value;
        _values.paddingBottom = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_paddingLeft():Float
    {
        return _paddingLeft;
    }

    private function set_paddingLeft(value:Float):Float
    {
        return _paddingLeft = value;

        _paddingLeft = value;
        _values.paddingLeft = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_paddingRight():Float
    {
        return _paddingRight;
    }

    private function set_paddingRight(value:Float):Float
    {
        return _paddingRight = value;

        _paddingRight = value;
        _values.paddingRight = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_paddingTop():Float
    {
        return _paddingTop;
    }

    private function set_paddingTop(value:Float):Float
    {
        _paddingTop = value;
        _values.paddingTop = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_width():Float
    {
        return _width;
    }

    private function set_width(value:Float):Float
    {
        _width = value;
        _values.width = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_height():Float
    {
        return _height;
    }

    private function set_height(value:Float):Float
    {
        _height = value;
        _values.height = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_maxWidth():Float
    {
        return _maxWidth;
    }

    private function set_maxWidth(value:Float):Float
    {
        _maxWidth = value;
        _values.maxWidth = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_maxHeight():Float
    {
        return _maxHeight;
    }

    private function set_maxHeight(value:Float):Float
    {
        _maxHeight = value;
        _values.maxHeight = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_minWidth():Float
    {
        return _minWidth;
    }

    private function set_minWidth(value:Float):Float
    {
        _minWidth = value;
        _values.minWidth = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }

    private function get_minHeight():Float
    {
        return _minHeight;
    }

    private function set_minHeight(value:Float):Float
    {
        _minHeight = value;
        _values.minHeight = value;
        draw();
        dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
        return value;
    }


    //================================================================
    // Other
    //================================================================

    private function get_values():Dynamic
    {
        return _values;
    }

    private function set_values(value:Dynamic):Dynamic
    {
        _values = value;

        //_margin = _values.margin;
        //_padding = _values.padding;
        //_background = _values.background;
        //_backgroundAttachment = _values.backgroundAttachment;
        _backgroundColor = _values.backgroundColor;
        //_backgroundImage = _values.backgroundImage;
        //_backgroundPosition = _values.backgroundPosition;
        //_backgroundRepeat = _values.backgroundRepeat;
        _backgroundOpacity = _values.backgroundOpacity;


        // border
        //_border = _values.border;
        //_borderStyle = _values.borderStyle;
        _borderWidth = _values.borderWidth;
        _borderColor = _values.borderColor;
        _borderRadius = _values.borderRadius;
        _borderOpacity = _values.borderOpacity;

        //_borderBottom = _values.borderBottom;
        _borderBottomColor = _values.borderBottomColor;
        _borderBottomStyle = _values.borderBottomStyle;
        _borderBottomWidth = _values.borderBottomWidth;

        //_borderLeft = _values.borderLeft;
        _borderLeftColor = _values.borderLeftColor;
        _borderLeftStyle = _values.borderLeftStyle;
        _borderLeftWidth = _values.borderLeftWidth;

        //_borderRight = _values.borderRight;
        _borderRightColor = _values.borderRightColor;
        _borderRightStyle = _values.borderRightStyle;
        _borderRightWidth = _values.borderRightWidth;

        //_borderTop = _values.borderTop;
        _borderTopColor = _values.borderTopColor;
        _borderTopStyle = _values.borderTopStyle;
        _borderTopWidth = _values.borderTopWidth;

        _borderBottomLeftRadius = _values.borderBottomLeftRadius;
        _borderBottomRightRadius = _values.borderBottomRightRadius;
        _borderTopLeftRadius = _values.borderTopLeftRadius;
        _borderTopRightRadius = _values.borderTopRightRadius;


        //_color = _values.;
        //_font = _values.;
        //_fontColor = _values.;
        //_fontFamily = _values.;
        //_fontSize = _values.;
        //_fontStyle = _values.;
        //_fontVarient = _values.;
        //_fontWeight = _values.;
        //_textPadding = _values.;


        _borderBevel = _values.borderBevel;
        _borderBevels = _values.borderBevels;


        draw();
        return value;
    }
} // end class

