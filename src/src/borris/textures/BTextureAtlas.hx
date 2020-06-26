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

package borris.textures;

import openfl.display.BitmapData;
import openfl.geom.Rectangle;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 27/11/2017 (dd/mm/yyyy)
 */
class BTextureAtlas
{
    private var _texture:BTexture;
    private var _xml:Xml;
    private var _bitmapData:BitmapData;
    private var _textures:Array<BTexture> = [];
    //private var _regions:Array<Rectangle>;
    private var _names:Array<String>;


    public function new(texture:BTexture, sparrowXML:Xml = null)
    {
        _texture = texture;
        _xml = sparrowXML;
        _bitmapData = _texture._bitmapData;
        parseXML();
    }


    //**************************************** HANDLERS *********************************************


    //**************************************** FUNCTIONS ********************************************


    /**
	 * 
	 */
    private function parseXML():Void
    {
        //for (texture in _xml)
        //for (texture in _xml.elementsNamed("SubTexture"))
        for(texture in _xml.elementsNamed("TextureAtlas"))
        {
            for(subTexture in texture.elementsNamed("SubTexture"))
            {
                var texture:BTexture = new BTexture();

                //texture._bitmap = ;
                texture._bitmapData = _bitmapData;
                texture._name = subTexture.get("name");
                texture._region = new Rectangle(Std.parseFloat(subTexture.get("x")), Std.parseFloat(subTexture.get("y")), Std.parseFloat(subTexture.get("width")), Std.parseFloat(subTexture.get("height")));
                texture._pivotX = Std.parseFloat(subTexture.get("pivotX"));
                texture._pivotY = Std.parseFloat(subTexture.get("pivotY"));

                texture._frame = Math.isNaN(Std.parseFloat(subTexture.get("frameX"))) ? null : new Rectangle(Std.parseFloat(subTexture.get("frameX")), Std.parseFloat(subTexture.get("frameY")), Std.parseFloat(subTexture.get("frameWidth")), Std.parseFloat(subTexture.get("frameHeight")));
                //texture.transformationMatrix = ;
                texture._width = texture._region.width;
                texture._height = texture._region.height;
                //texture.nativeWidth = bitmap.na
                //texture.nativeHeight = bitmap
                //texture.scale = bitmap.scaleX = bitmap.scaleY;
                _textures.push(texture);
            }

        } // end for

    } // end function


    /**
	 * 
	 * @param	name
	 * @param	region
	 * @param	frame
	 */
    public function addRegion(name:String, region:Rectangle, frame:Rectangle = null):Void
    {

    } // end function


    /**
	 * 
	 * @param	name
	 */
    public function removeRegion(name:String):Void
    {

    } // end function


    /**
	 * 
	 * @param	name
	 * @return
	 */
    public function getRegion(name:String):Rectangle
    {
        return new Rectangle();
    } // end function


    /**
	 * 
	 * @param	name
	 * @return
	 */
    public function getTexture(name:String):BTexture
    {
        for(texture in _textures)
        {
            if(texture._name == name)
            {
                return texture;
            } // end if
        } // end for

        return null;
    } // end function


    /**
	 * 
	 * @param	prefix
	 * @return
	 */
    public function getTextures(prefix:String):Array<BTexture>
    {
        var textures:Array<BTexture> = [];

        for(texture in _textures)
        {
            if(StringTools.startsWith(texture._name, prefix))
            {
                textures.push(texture);
            }// end if
        } // end for

        return textures;
    } // end function


    /**
	 * 
	 * @param	prefix
	 * @return
	 */
    public function getNames(prefix:String):Array<String>
    {
        return _names;
    }
    // end function


    //**************************************** SET AND GET ******************************************


}