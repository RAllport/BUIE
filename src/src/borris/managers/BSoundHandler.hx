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

package borris.managers;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date  (dd/mm/yyyy)
 */
class BSoundHandler
{
    public static var soundVolume(get, set):Float;
    public static var musicVolume(get, set):Float;
    public static var soundVolumeOn(get, set):Bool;
    public static var musicVolumeOn(get, set):Bool;
    //public static var currentMusic(get, never):Sound;

    //public static var replayAt:Float;
    //private static var _noVolume:SoundTransform; //
    private static var _soundChan:SoundChannel;
    private static var _soundVol:SoundTransform;
    private static var _musicClass:Dynamic;
    private static var _musicChan:SoundChannel;
    private static var _musicVol:SoundTransform;
    private static var _fadeClass:Dynamic;
    private static var _fadeChan:SoundChannel;
    private static var _fadeVol:SoundTransform;

    // TODO create sounds array to hold all the sounds and music
    private static var _sounds:Array<Dynamic>;
    // TODO
    private static var _currentMusic:Sound;


    private static var _initialized:Bool = false;

    // set and get
    private static var _soundVolume:Float = 1;
    private static var _soundVolumeOn:Bool = true;
    private static var _musicVolume:Float = 1;
    private static var _musicVolumeOn:Bool = true;


    /**
	 * initializes the SoundHandler class. Must
	 */
    public static function initialize():Void
    {
        //noVolume = new SoundTransform();
        //noVolume.volume = 0;
        _soundVol = new SoundTransform();
        _soundVol.volume = 0.4;
        _musicVol = new SoundTransform();
        _musicVol.volume = 1;
        _fadeVol = new SoundTransform();
        _fadeVol.volume = 0;

        soundVolume = 1;
        //soundVolumeOn = true;

        musicVolume = 1;
        musicVolumeOn = true;

        _initialized = true;

    } // end function


    /**
	 * Plays a sound once.
	 * 
	 * @param	sound
	 */
    public static function playSound(sound:Sound):Void
    {
        if(_soundVolumeOn)
        {
            _soundChan = sound.play();
            _soundChan.soundTransform = _soundVol;
        } // end if

    } // end function


    /**
	 * Plays a sound and repeats it.
	 * 
	 * @param	music
	 * @param	muted
	 */
    public static function playMusic(music:Sound, muted:Bool = false):Void
    {
        if(_musicClass == music)
        {
            return;
        }

        if(_musicClass)
        {
            if(_fadeClass)
            {
                _fadeChan.stop();
            }
            //fadeVol.volume = !SD.music || muted ? 0 : 1;
            //fadeVol.volume = muted ? 0 : 1;
            _fadeVol.volume = muted ? 1 : 0;
            _fadeClass = _musicClass;
            _fadeChan = _musicChan;
            _fadeChan.soundTransform = _fadeVol;
        }
        else
        {
            muted = false;
        }

        _musicVol.volume = muted ? 0 : 1;
        _musicClass = music;
        _musicChan = _musicClass.play(0, 9999);
        _musicChan.soundTransform = _musicVol;

        //musicVolumeOn = !muted;

    } // end function


    /**
	 * 
	 * @param	music
	 * @param	time The time in the Sound to start playing the music.
	 * @param	muted
	 */
    // TODO implement playMusicAt function
    public static function playMusicAt(music:Sound, time:Int, muted:Bool = false):Void
    {

    } // end function


    /**
	 * 
	 */
    // TODO implement continueMusic function
    public static function continueMusic():Void
    {

    } // end function


    /**
	 * Pauses the currently playing music
	 */
    // TODO implemenet pauseMusic function
    public static function pauseMusic():Void
    {

    } // end function


    /**
	 * Stops the currently playing music Sound and resets it's playhead.
	 */
    // TODO implement stopMusic function
    public static function stopMusic():Void
    {

    } // end function

    /**
	 * 
	 */
    private static function enterFrame():Void
    {

        if(_musicClass)
        {
            if(musicVolumeOn)
            {
                if(_musicVol.volume < 1)
                {
                    _musicVol.volume += 0.025;
                    _musicChan.soundTransform = _musicVol;
                    trace("increasing volume");
                }
            }
            else if(_musicVol.volume > 0)
            {
                _musicVol.volume -= 0.025;
                _musicChan.soundTransform = _musicVol;
                //trace("decreasing volume");
            }
        }

    } // end function


    //============================================================================================================
    // SET AND GET
    //============================================================================================================


    private static function get_soundVolume():Float
    {
        return _soundVolume;
    }

    private static function set_soundVolume(value:Float):Float
    {
        if(value == _soundVolume)
        {
            return _soundVolume;
        }

        if(value > 1)
        {
            value = 1;
        }
        if(value < 0)
        {
            value = 0;
        }
        _soundVolume = value;

        return _soundVol.volume = _soundVolumeOn ? _soundVolume : 0;

    }


    private static function get_musicVolume():Float
    {
        return _musicVolume;
    }

    private static function set_musicVolume(value:Float):Float
    {
        if(value == _musicVolume)
        {
            return _musicVolume;
        }

        if(value > 1)
        {
            value = 1;
        }
        if(value < 0)
        {
            value = 0;
        }
        _musicVolume = value;

        if(_musicClass)
        {
            _musicVol.volume = _musicVolumeOn ? _musicVolume : 0;
            _musicChan.soundTransform = _musicVol;
            trace("music volume: " + _musicVol.volume);
        }

        return _musicVol.volume;
    }


    private static function get_soundVolumeOn():Bool
    {
        return _soundVolumeOn;
    }

    private static function set_soundVolumeOn(value:Bool):Bool
    {
        _soundVolumeOn = value;

        if(value)
        {
            _soundVol.volume = soundVolume;
        }
        else
        {
            _soundVol.volume = 0;
        }

        return _soundVolumeOn;
    }


    private static function get_musicVolumeOn():Bool
    {
        return _musicVolumeOn;
    }

    private static function set_musicVolumeOn(value:Bool):Bool
    {
        _musicVolumeOn = value;

        if(_musicClass)
        {
            if(value)
            {
                _musicVol.volume = musicVolume;
                _musicChan.soundTransform = _musicVol;
            }
            else
            {
                _musicVol.volume = 0;
                _musicChan.soundTransform = _musicVol;
            }
            //trace("music volume: " + musicVol.volume);
        }

        return _musicVolumeOn;
    }


}