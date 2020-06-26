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

package borris.controls;

import borris.display.BElement;

import motion.Actuate;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.utils.Timer;


//--------------------------------------
//  Class description
//--------------------------------------
/**
 * The BBaseButton class is the base class for all button components, defining properties and methods that are common
 * to all buttons.
 * This class handles drawing states and the dispatching of button events.
 *
 * @author Rohaan Allport
 * @creation-date 11/04/2015 (dd/mm/yyyy)
 */
class BBaseButton extends BUIComponent
{
    // assets
    // TODO change skins to DisplayObject or CLASS<DisplayObject> (or dynamic for both)
    private var _upSkin:DisplayObject; // The up skin of this details Object.
    private var _overSkin:DisplayObject; // The over skin of this details Object.
    private var _downSkin:DisplayObject; // The down skin of this details Object.
    private var _disabledSkin:DisplayObject; // The disabled skin of this details Object.

    private var _selectedUpSkin:DisplayObject;
    private var _selectedOverSkin:DisplayObject;
    private var _selectedDownSkin:DisplayObject;
    private var _selectedDisabledSkin:DisplayObject;


    // other
    private var _states:Array<DisplayObject>;
    private var _drawFlag:Bool = true;
    private var _currentState:DisplayObject;
    private var _stateTimer:Timer = new Timer(300);

    // set and get
    // TODO create auto repeat functions. See BNumericStepper and BScrollBar
    //protected var _autoRepaet:Boolean;		//

    private var _upColor:Int = 0x222222;
    private var _overColor:Int = 0x0099CC;
    private var _downColor:Int = 0x003366;
    private var _disabledColor:Int = 0x111111;

    private var _selectedUpColor:Int = 0x0099CC;
    private var _selectedOverColor:Int = 0x00CCFF;
    private var _selectedDownColor:Int = 0x003366;
    private var _selectedDisabledColor:Int = 0x0099CC;

    private var _upAlpha:Float = 1;
    private var _overAlpha:Float = 1;
    private var _downAlpha:Float = 1;
    private var _disabledAlpha:Float = 0.5;

    private var _selectedUpAlpha:Float = 1;
    private var _selectedOverAlpha:Float = 1;
    private var _selectedDownAlpha:Float = 1;
    private var _selectedDisabledAlpha:Float = 1;


    //--------------------------------------
    //  Constructor
    //--------------------------------------
    /**
     * Creates a new BBaseButton component instance.
     *
     * @param	parent The parent DisplayObjectContainer of this component. If the value is null the component will
     * have no initail parent.
     * @param	x The x coordinate value that specifies the position of the component within its parent, in pixels.
     * This value is calculated from the left.
     * @param	y The y coordinate value that specifies the position of the component within its parent, in pixels.
     * This value is calculated from the top.
     */
    public function new(parent:DisplayObjectContainer = null, x:Float = 0, y:Float = 0)
    {
        super(parent, x, y);
        initialize();
        setSize(100, 24);
        //draw();

        changeState(_upSkin);
    }


    //**************************************** HANDLERS *********************************************


    /**
	 * @param	event 
	 */
    private function mouseHandler(event:MouseEvent):Void
    {
        // if the button is not enabled set the disabeled skins and skip everything
        if(!enabled)
        {
            changeState(_disabledSkin);

            return;
        } // end if  

        switch (event.type)
        {
            case MouseEvent.MOUSE_OVER:
                changeState(_overSkin);

            case MouseEvent.MOUSE_OUT:
                changeState(_upSkin);

            case MouseEvent.MOUSE_DOWN:
                changeState(_downSkin);

            case MouseEvent.MOUSE_UP:
                changeState(_overSkin);
        } // end switch
    } // end function


    //**************************************** FUNCTIONS ********************************************


    /**
	 * Initailizes the component by creating assets, setting properties and adding listeners.
	 */
    override private function initialize():Void
    {
        super.initialize();

        // initialize the skins
        _upSkin = new BElement();
        _overSkin = new BElement();
        _downSkin = new BElement();
        _disabledSkin = new BElement();

        _selectedUpSkin = new BElement();
        _selectedOverSkin = new BElement();
        _selectedDownSkin = new BElement();
        _selectedDisabledSkin = new BElement();


        addChild(_upSkin);
        addChild(_overSkin);
        addChild(_downSkin);
        addChild(_disabledSkin);

        addChild(_selectedUpSkin);
        addChild(_selectedOverSkin);
        addChild(_selectedDownSkin);
        addChild(_selectedDisabledSkin);


        //
        buttonMode = true;
        useHandCursor = true;
        mouseChildren = false;


        // add the state skins to the state array
        _states = [_upSkin, _overSkin, _downSkin, _disabledSkin, _selectedUpSkin, _selectedOverSkin, _selectedDownSkin, _selectedDisabledSkin];

        // event handling
        addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
        addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
        addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
    } // end function


    /**
	 * @inheritDoc
	 */
    override private function draw():Void
    {
        if(!_drawFlag)
        {
            _style.clear();
            _width = getBounds(this).width;
            _height = getBounds(this).height;
            return;
        } // end if

        super.draw();

        _upSkin.width =
        _overSkin.width =
        _downSkin.width =
        _disabledSkin.width =
        _selectedUpSkin.width =
        _selectedOverSkin.width =
        _selectedDownSkin.width =
        _selectedDisabledSkin.width = _width;

        _upSkin.height =
        _overSkin.height =
        _downSkin.height =
        _disabledSkin.height =
        _selectedUpSkin.height =
        _selectedOverSkin.height =
        _selectedDownSkin.height =
        _selectedDisabledSkin.height = _height;


        cast((_upSkin), BElement).style.backgroundColor = _upColor;
        cast((_upSkin), BElement).style.backgroundOpacity = _upAlpha;

        cast((_overSkin), BElement).style.backgroundColor = _overColor;
        cast((_overSkin), BElement).style.backgroundOpacity = _overAlpha;

        cast((_downSkin), BElement).style.backgroundColor = _downColor;
        cast((_downSkin), BElement).style.backgroundOpacity = _downAlpha;

        cast((_disabledSkin), BElement).style.backgroundColor = _disabledColor;
        cast((_disabledSkin), BElement).style.backgroundOpacity = _disabledAlpha;

        cast((_selectedUpSkin), BElement).style.backgroundColor = _selectedUpColor;
        cast((_selectedUpSkin), BElement).style.backgroundOpacity = _selectedUpAlpha;

        cast((_selectedOverSkin), BElement).style.backgroundColor = _selectedOverColor;
        cast((_selectedOverSkin), BElement).style.backgroundOpacity = _selectedOverAlpha;

        cast((_selectedDownSkin), BElement).style.backgroundColor = _selectedDownColor;
        cast((_selectedDownSkin), BElement).style.backgroundOpacity = _selectedDownAlpha;

        cast((_selectedDisabledSkin), BElement).style.backgroundColor = _selectedDisabledColor;
        cast((_selectedDisabledSkin), BElement).style.backgroundOpacity = _selectedDisabledAlpha;

        /*cast((_upSkin), BElement).style.drawNow();
        cast((_overSkin), BElement).style.drawNow();
        cast((_downSkin), BElement).style.drawNow();
        cast((_disabledSkin), BElement).style.drawNow();
        cast((_selectedUpSkin), BElement).style.drawNow();
        cast((_selectedOverSkin), BElement).style.drawNow();
        cast((_selectedDownSkin), BElement).style.drawNow();
        cast((_selectedDisabledSkin), BElement).style.drawNow();*/

    } // end function


    /**
	 * Changes the state of the component.
	 * 
	 * @param	state
	 */
    private function changeState(state:DisplayObject):Void
    {
        for(i in 0..._states.length)
        {
            var tempState:DisplayObject = _states[i];

            if(state == tempState)
            {
                Actuate.tween(state, 0.3, { alpha: 1});
                _currentState = state;
            }
            else
            {
                //Actuate.tween(state, 0.3, { alpha: 0.1 } );
                tempState.alpha = 0;
            }
        } //    // end for


        Actuate.timer(0.3).onComplete(
            function():Void
            {
                for(i in 0..._states.length)
                {
                    var tempState:DisplayObject = _states[i];
                    tempState.alpha = 0;

                    if(state == tempState)
                    {
                        tempState.alpha = 1;

                    }
                } // end for
            }
        );

    } // end function


    /**
	 * Set the color of the desired state of the component (up, over, down, disabled, selected up, selected over,
	 * seleced down, and selected disabled)
	 * Passing in a value that is negative will keep the color the same.
	 * This will allow you to skip over states and only change the colors of the states you want.
	 */
    public function setStateColors(upColor:Int, overColor:Int = -1, downColor:Int = -1, disabeledColor:Int = -1,
                                   selectedUpColor:Int = -1, selectedOverColor:Int = -1, selectedDownColor:Int = -1,
                                   selectedDisabledColor:Int = -1):Void
    {
        // TODO may not need temp color. just set it back to itself. eg _upColor = upColor > -1 ? upColor : _upColor;
        // create temporary colors to hold the previous color
        var tempUpColor:Int = _upColor;
        var tempOverColor:Int = _overColor;
        var tempDownColor:Int = _downColor;
        var tempDisabledColor:Int = _disabledColor;
        var tempSelectedUpColor:Int = _selectedUpColor;
        var tempSelectedOverColor:Int = _selectedOverColor;
        var tempSelectedDownColor:Int = _selectedDownColor;
        var tempSelectedDisabledColor:Int = _selectedDisabledColor;

        // check to see if the values passed are 0 or greater (greater than -1).
        // if yes then set the new color.
        // else set the old color
        _upColor = upColor > -1 ? upColor : _upColor;
        _overColor = overColor > -1 ? overColor : _overColor;
        _downColor = downColor > -1 ? downColor : _downColor;
        _disabledColor = disabeledColor > -1 ? disabeledColor : _disabledColor;
        _selectedUpColor = selectedUpColor > -1 ? selectedUpColor : _selectedUpColor;
        _selectedOverColor = selectedOverColor > -1 ? selectedOverColor : _selectedOverColor;
        _selectedDownColor = selectedDownColor > -1 ? selectedDownColor : _selectedDownColor;
        _selectedDisabledColor = selectedDisabledColor > -1 ? selectedDisabledColor : _selectedDisabledColor;

        // redraw the button to apply the changes
        draw();
    } // end function


    /**
	 * Set the color of the desired state of the component.
	 * 
	 */
    public function setStateAlphas(upAlpha:Float, overAlpha:Float, downAlpha:Float, disabeledAlpha:Float,
                                   selectedUpAlpha:Float, selectedOverAlpha:Float, selectedDownAlpha:Float,
                                   selectedDisabledAlpha:Float):Void
    {
        _upSkin.alpha = _upAlpha = upAlpha;
        _overSkin.alpha = _overAlpha = overAlpha;
        _downSkin.alpha = _downAlpha = downAlpha;
        _disabledSkin.alpha = _disabledAlpha = disabeledAlpha;

        _selectedUpSkin.alpha = _selectedUpAlpha = selectedUpAlpha;
        _selectedOverSkin.alpha = _selectedOverAlpha = selectedOverAlpha;
        _selectedDownSkin.alpha = _selectedDownAlpha = selectedDownAlpha;
        _selectedDisabledSkin.alpha = _selectedDisabledAlpha = selectedDisabledAlpha;

        //invalidate();
        draw();
    } // end function


    /**
     * Set the skin of the desired state of the component.
	 * 
     * @param	upSkin
     * @param	overSkin
     * @param	downSkin
     * @param	disabledSkin
     * @param	selectedUpSkin
     * @param	selectedOverSkin
     * @param	selectedDownSkin
     * @param	selectedDisabledSkin
     */
    public function setSkins(upSkin:DisplayObject, overSkin:DisplayObject = null, downSkin:DisplayObject = null,
                             disabledSkin:DisplayObject = null, selectedUpSkin:DisplayObject = null,
                             selectedOverSkin:DisplayObject = null, selectedDownSkin:DisplayObject = null,
                             selectedDisabledSkin:DisplayObject = null):Void
    {
        // if upSkin is null, set the draw flag to true
        if(upSkin == null)
        {
            _drawFlag = true;
            invalidate();
            return;
        } // end if 


        // clear the state styles
        cast((_upSkin), BElement).style.clear();
        cast((_overSkin), BElement).style.clear();
        cast((_downSkin), BElement).style.clear();
        cast((_disabledSkin), BElement).style.clear();
        cast((_selectedUpSkin), BElement).style.clear();
        cast((_selectedOverSkin), BElement).style.clear();
        cast((_selectedDownSkin), BElement).style.clear();
        cast((_selectedDisabledSkin), BElement).style.clear();


        // set drawFlag to false so that the button no longer draws
        _drawFlag = false;


        // remove all skins
        _upSkin.parent.removeChild(_upSkin);
        _overSkin.parent.removeChild(_overSkin);
        _downSkin.parent.removeChild(_downSkin);
        _disabledSkin.parent.removeChild(_disabledSkin);
        _selectedUpSkin.parent.removeChild(_selectedUpSkin);
        _selectedOverSkin.parent.removeChild(_selectedOverSkin);
        _selectedDownSkin.parent.removeChild(_selectedDownSkin);
        _selectedDisabledSkin.parent.removeChild(_selectedDisabledSkin);


        //set skins
        // TODO see if i really need the try catch
        _upSkin = try cast(upSkin, Sprite)
        catch(e:Dynamic) null;
        _overSkin = (overSkin != null) ? try cast(overSkin, Sprite)
        catch(e:Dynamic) null : try cast(upSkin, Sprite)
        catch(e:Dynamic) null;
        _downSkin = (downSkin != null) ? try cast(downSkin, Sprite)
        catch(e:Dynamic) null : try cast(upSkin, Sprite)
        catch(e:Dynamic) null;
        _disabledSkin = (disabledSkin != null) ? try cast(disabledSkin, Sprite)
        catch(e:Dynamic) null : try cast(upSkin, Sprite)
        catch(e:Dynamic) null;
        _selectedUpSkin = (selectedUpSkin != null) ? try cast(selectedUpSkin, Sprite)
        catch(e:Dynamic) null : try cast(upSkin, Sprite)
        catch(e:Dynamic) null;
        _selectedOverSkin = (selectedOverSkin != null) ? try cast(selectedOverSkin, Sprite)
        catch(e:Dynamic) null : try cast(upSkin, Sprite)
        catch(e:Dynamic) null;
        _selectedDownSkin = (selectedDownSkin != null) ? try cast(selectedDownSkin, Sprite)
        catch(e:Dynamic) null : try cast(upSkin, Sprite)
        catch(e:Dynamic) null;
        _selectedDisabledSkin = (selectedDisabledSkin != null) ? try cast(selectedDisabledSkin, Sprite)
        catch(e:Dynamic) null : try cast(upSkin, Sprite)
        catch(e:Dynamic) null;


        // add the skins
        addChild(_upSkin);
        addChild(_overSkin);
        addChild(_downSkin);
        addChild(_disabledSkin);
        addChild(_selectedUpSkin);
        addChild(_selectedOverSkin);
        addChild(_selectedDownSkin);
        addChild(_selectedDisabledSkin);


        // recreate/fill the states array
        _states = [_upSkin, _overSkin, _downSkin, _disabledSkin, _selectedUpSkin, _selectedOverSkin, _selectedDownSkin, _selectedDisabledSkin];
    } // end function


    /**
	 * Gets the skin of the secified state of the component.
	 * (up, over, down, disabled, selected up, selected over, seleced down, and selected disabled)
	 */
    public function getSkin(skin:String):DisplayObject
    {

        switch (skin)
        {
            case "upSkin":
                return _upSkin;

            case "overSkin":
                return _overSkin;

            case "downSkin":
                return _downSkin;

            case "disabledSkin":
                return _disabledSkin;

            case "selectedUpSkin":
                return _selectedUpSkin;

            case "selectedOverSkin":
                return _selectedOverSkin;

            case "selectedDownSkin":
                return _selectedDownSkin;

            case "selectedDisabledSkin":
                return _selectedDisabledSkin;
        } // end switch

        return _upSkin;
    } // end function


    //**************************************** SET AND GET ******************************************

    // autoRepeat
    /*public function set autoRepeat(value:Boolean):void
		{
			_autoRepeat = value;
		}
		
		public function get autoRepeat():Boolean
		{
			return _autoRepeat;
		}*/


    /**
	 * Gets or sets a value that indicates whether the component can accept user input. 
	 * A value of <code>true</code> indicates that the component can accept user input; 
	 * a value of <code>false</code> indicates that it cannot.
	 * 
	 * <p>When this property is set to false, the button is disabled. 
	 * This means that although it is visible, it cannot be clicked. 
	 * This property is useful for disabling a specific part of the user interface.</p>
	 */
    override private function set_enabled(value:Bool):Bool
    {
        super.enabled = value;
        value ? alpha = 1 : alpha = _disabledAlpha;
        value ? changeState(_upSkin) : changeState(_disabledSkin);
        return value;
    }

} // end class

