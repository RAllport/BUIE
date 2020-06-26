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
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;

/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 27/11/201 (dd/mm/yyyy)
 */
class BFrameAnimation extends Sprite
{
    public var currentFrame(get, set):Int;
    public var currentTime(get, set):Float;
    public var fps(get, set):Float;
    public var isComplete(get, null):Bool;
    public var isPlaying(get, null):Bool;
    public var loop(get, set):Bool;
    public var numFrames(get, null):Int;
    public var totalTime(get, null):Float;
    public var pivotX(get, set):Float;
    public var pivotY(get, set):Float;

    public var usePivot:Bool = true;


    private var _textures:Array<BTexture>;
    private var _rects:Rectangle;
    private var _bitmap:Bitmap;
    private var _frameCounter:Int = 0;
    private var _pivotX:Float = 0;
    private var _pivotY:Float = 0;

    private var _xs:Array<Float> = [];
    private var _ys:Array<Float> = [];

    private var _currentFrame:Int = 0;
    private var _currentTime:Float = 0;
    private var _fps:Float;
    private var _isComplete:Bool = false;
    private var _isPlaying:Bool = true;
    private var _loop:Bool;
    private var _numFrames:Int = 0;
    private var _totalTime:Float = 0;


    public function new(textures:Array<BTexture>, fps:Float = 30, usePivot:Bool = true)
    {
        super();

        _fps = fps;
        this.usePivot = usePivot;

        if(textures[0]._bitmap != null)
        {
            for(texture in textures)
            {
                texture._bitmap = textures[0]._bitmap;
                _xs.push(texture.frame != null ? -texture.frame.x : 0);
                _ys.push(texture.frame != null ? -texture.frame.y : 0);
            }
        }
        else
        {
            var bitmap:Bitmap = new Bitmap(textures[0]._bitmapData);
            for(texture in textures)
            {
                texture._bitmap = bitmap;
                _xs.push(texture.frame != null ? -texture.frame.x : 0);
                _ys.push(texture.frame != null ? -texture.frame.y : 0);
            } // end for
        } // end else

        _textures = textures;

        _bitmap = textures[0]._bitmap;
        _bitmap.scrollRect = textures[0]._region;

        //
        if(!Math.isNaN(textures[0]._pivotX))
        {
            _pivotX = textures[0]._pivotX;
            _pivotY = textures[0]._pivotY;
        } // end if

        //
        addChild(_bitmap);

        // event handling
        //addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        /*var defaultHandler:Bool = false;
		if (defaultHandler)
		{
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		} // end if */

    }


    //**************************************** HANDLERS *********************************************


    /*private function onAddedToStage(event:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		//_fps = stage.frameRate;
	} // end function*/


    private function enterFrameHandler(event:Event):Void
    {
        //update();
    } // end function


    //**************************************** FUNCTIONS ********************************************


    /*public function addFrame(texture:BTexture, sound:Sound = null, duration:Float = -1):Void
	{
		
	} // end function 
	
	
	public function addFrameAt(frameNumber:Int, texture:BTexture, sound:Sound = null, duration:Float = -1):Void
	{
		
	} // end function 
	
	
	public function removeFrameAt(frameNumber:Int, texture:BTexture, sound:Sound = null, duration:Float = -1):Void
	{
		
	} // end function 
	
	
	public function advanceTime(time:Float):Void
	{
		
	} // end function 
	
	
	public function setFrameAction(frameNumber:Int, action:Dynamic):Void
	{
		
	} // end function 
	
	
	public function removeFrameAction(frameNumber:Int):Void
	{
		
	} // end function 
	
	
	public function getFrameAction(frameNumber:Int):Void
	{
		
	} // end function 
	
	
	public function setFrameDuration(frameNumber:Int, duration:Float):Float
	{
		
	} // end function 
	
	
	public function getFrameDuration(frameNumber:Int):Float
	{
		
	} // end function 
	
	
	public function setFrameSound(frameNumber:Int, sound:Sound):Sound
	{
		
	} // end function 
	
	
	public function getFrameSound(frameNumber:Int):Sound
	{
		
	} // end function 
	
	
	public function getFrameTexture(frameNumber:Int, texture:BTexture):BTexture
	{
		
	} // end function 
	
	
	public function getFrameTexture(frameNumber:Int):BTexture
	{
		
	} // end function */


    /**
	 * Starts playback. Moves the playhead in the timeline
	 * 
	 * The animation must be added to an animator.
	 */
    public function play():Void
    {
        _isPlaying = true;
    } // end function


    /**
	 * Pauses playback.
	 */
    public function pause():Void
    {
        _isPlaying = false;

        //_bitmap.scrollRect = _textures[_currentFrame]._region;
        if(usePivot)
        {
            _bitmap.x = _xs[_currentFrame] - _pivotX;
            _bitmap.y = _ys[_currentFrame] - _pivotY;
        }
        else
        {
            _bitmap.x = _xs[_currentFrame];
            _bitmap.y = _ys[_currentFrame];
        }
    } // end function


    /**
	 * Stops playback and resets <code>currentFrame</code> to zero.
	 */
    public function stop():Void
    {
        _currentFrame = 0;
        _currentTime = 0;
        _isPlaying = false;
        _bitmap.scrollRect = _textures[_currentFrame]._region;
    } // end function


    /**
	 * Reverses the order of all frames, making the clip run from end to start. 
	 * 
	 * Makes sure that the currently visible frame stays the same.
	 */
    public function reverseFrames():Void
    {
        _textures.reverse();
        _xs.reverse();
        _ys.reverse();
    } // end function */


    /**
	 * updates the animation.
	 * 
	 * Called BAnimator.update();
	 */
    public function update():Void
    {
        if(_isPlaying)
        {
            _frameCounter++;
            if(_frameCounter >= stage.frameRate / _fps)
            {
                _frameCounter = 0;
                _currentFrame++;
            } // end if

            /*if (_currectFrame > _textures.length - 1)
			{
				_isComplete = true;
				if (_loop)
				{
					_currectFrame = 0;
					_isComplete = false;
				}
				
			}*/

            if(_loop)
            {
                if(_currentFrame > _textures.length - 1)
                {
                    _currentFrame = 0;
                }
                if(_currentFrame >= _textures.length - 1)
                {
                    _isComplete = true;
                }
                else
                {
                    _isComplete = false;
                }
            }
            else
            {
                if(_currentFrame >= _textures.length - 1)
                {
                    _currentFrame = _textures.length - 1;
                    _isComplete = true;
                }
                else
                {
                    _isComplete = false;
                }

            } //

            //trace("is complete: " + _isComplete);
            //trace(this.name + " | current frame: " + _currectFrame);
            _bitmap.scrollRect = _textures[_currentFrame]._region;
            if(usePivot)
            {
                _bitmap.x = _xs[_currentFrame] - _pivotX;
                _bitmap.y = _ys[_currentFrame] - _pivotY;
            }
            else
            {
                _bitmap.x = _xs[_currentFrame];
                _bitmap.y = _ys[_currentFrame];
            }

        } // end if

    } // end function


    //**************************************** SET AND GET ******************************************


    private function get_currentFrame():Int
    {
        return _currentFrame;
    }

    private function set_currentFrame(value:Int):Int
    {
        _currentFrame = value;
        _bitmap.scrollRect = _textures[_currentFrame]._region;

        if(_currentFrame < _textures.length - 1)
        {
            _isComplete = false;
        }
        else
        {
            _isComplete = true;
        }

        if(usePivot)
        {
            _bitmap.x = _xs[_currentFrame] - _pivotX;
            _bitmap.y = _ys[_currentFrame] - _pivotY;
        }
        else
        {
            _bitmap.x = _xs[_currentFrame];
            _bitmap.y = _ys[_currentFrame];
        }

        return _currentFrame;
    }


    private function get_currentTime():Float
    {
        return _currentTime;
    }

    private function set_currentTime(value:Float):Float
    {
        return _currentTime = value;
    }


    private function get_fps():Float
    {
        return _fps;
    }

    private function set_fps(value:Float):Float
    {
        return _fps = value;
    }


    private function get_isComplete():Bool
    {
        return _isComplete;
    }


    private function get_isPlaying():Bool
    {
        return _isPlaying;
    }


    private function get_loop():Bool
    {
        return _loop;
    }

    private function set_loop(value:Bool):Bool
    {
        return _loop = value;
    }


    private function get_numFrames():Int
    {
        //return _numFrames;
        return _textures.length;
    }


    private function get_totalTime():Float
    {
        return _totalTime;
    }


    private function get_pivotX():Float
    {
        return _pivotX;
    }

    private function set_pivotX(value:Float):Float
    {
        return _pivotX = value;
    }


    private function get_pivotY():Float
    {
        return _pivotY;
    }

    private function set_pivotY(value:Float):Float
    {
        return _pivotY = value;
    }


}