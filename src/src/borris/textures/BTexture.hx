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

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 27/11/201 (dd/mm/yyyy)
 */
class BTexture
{
    public var frame(get, null):Rectangle;
    //public var transformationMatrix(get, null):Matrix;
    public var width(get, null):Float;
    public var height(get, null):Float;
    //public var nativeWidth(get, null):Float;
    //public var nativeHeight(get, null):Float;
    //public var scale(get, null):Float;


    private static var _bitmaps:Array<Bitmap> = [];
    private static var _bitmapDatas:Array<BitmapData> = [];

    @:allow(borris.textures)
    private var _region:Rectangle;

    @:allow(borris.textures)
    private var _bitmap:Bitmap;
    @:allow(borris.textures)
    private var _bitmapData:BitmapData;
    @:allow(borris.textures)
    private var _name:String;
    @:allow(borris.textures)
    private var _frame:Rectangle = null;
    //private var _transformationMatrix:Matrix;
    @:allow(borris.textures)
    private var _width:Float = 0;
    @:allow(borris.textures)
    private var _height:Float = 0;
    @:allow(borris.textures)
    private var _nativeWidth:Float = 0;
    @:allow(borris.textures)
    private var _nativeHeight:Float = 0;
    @:allow(borris.textures)
    private var _scale:Float = 1;
    @:allow(borris.textures)
    private var _pivotX:Float;
    @:allow(borris.textures)
    private var _pivotY:Float;


    @:allow(borris.textures)
    private function new()
    {

    }


    //**************************************** HANDLERS *********************************************


    //**************************************** FUNCTIONS ********************************************


    /*public static function fromBitmap(bitmap:Bitmap):BTexture
	{
		_bitmaps.push(bitmap);
		_bitmapDatas.push(bitmap.bitmapData);
		
		var texture:BTexture = new BTexture();
		
		texture._bitmap = bitmap;
		texture._bitmapData = bitmap.bitmapData.;
		
		texture.frame = null;
		texture.transformationMatrix = bitmap.transform.matrix;
		texture.width = bitmap.width;
		texture.height = bitmap.height;
		//texture.nativeWidth = bitmap.na
		//texture.nativeHeight = bitmap
		texture.scale = bitmap.scaleX = bitmap.scaleY;
		
		return texture;
	} // end */


    public static function fromBitmapData(bitmapData:BitmapData):BTexture
    {
        _bitmapDatas.push(bitmapData);


        var texture:BTexture = new BTexture();

        texture._bitmapData = bitmapData;

        texture.frame = null;
        //texture.transformationMatrix = ;
        texture.width = bitmapData.width;
        texture.height = bitmapData.height;
        //texture.nativeWidth = bitmap.na
        //texture.nativeHeight = bitmap
        //texture.scale = bitmap.scaleX = bitmap.scaleY;

        return texture;
    } // end


    /**
	 * 
	 * @param	texture
	 * @return
	 */
    public static function createBitmap(texture:BTexture):Bitmap
    {
        var bitmap:Bitmap = new Bitmap(texture._bitmapData);
        texture._bitmap = bitmap;
        _bitmaps.push(bitmap);

        //bitmap.scrollRect = texture._frame;
        bitmap.scrollRect = texture._region;
        bitmap.x = 0;
        bitmap.y = 0;
        bitmap.rotation = 0;
        bitmap.scaleX = bitmap.scaleY = 1;

        return bitmap;
    } // end

    #if !flash
    /**
	 * 
	 * @param	texture
	 * @return
	 */
    public static function createTilemap(bitmapData:BitmapData):Tilemap
    {
        //TODO update this
        var tileset:Tileset = new Tileset(bitmapData);
        tileset.addRect(bitmapData.rect);

        //var layer:TilemapLayer = new TilemapLayer (tileset);

        var tilemap:Tilemap = new Tilemap(bitmapData.width * 5, bitmapData.height * 5);
        //tilemap.add.addLayer (layer);


        var tile = new Tile();
        //layer.addTile (tile);
        tile = new Tile();
        tile.x = 600;
        //tile.y = 200;
        //layer.addTile (tile);

        return tilemap;
    } // end function
    #end

    /*public static function createFrameAnimation(textures:Array<BTexture>):BFrameAnimation
	{
		
	} // end function*/


    //**************************************** SET AND GET ******************************************


    private function get_frame():Rectangle
    {
        return _frame;
    }

    /*private function get_transformationMatrix():Matrix
	{
		return _transformationMatrix;
	}*/

    private function get_width():Float
    {
        return _width;
    }

    private function get_height():Float
    {
        return _height;
    }

    /*private function get_nativeWidth():Float
	{
		return _nativeWidth;
	}
	
	function get_nativeHeight():Float 
	{
		return _nativeHeight;
	}
	
	function get_scale():Float 
	{
		return _scale;
	}*/


}