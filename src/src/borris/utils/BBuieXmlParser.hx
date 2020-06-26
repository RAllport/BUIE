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

package borris.utils;

import borris.controls.*;
import borris.display.BElement;
import Type;
import Xml;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 06/03/2018 (dd/mm/yyyy)
 */
class BBuieXmlParser
{
    /**
     *
     */
    public static function parseBUIEXML(buieXML:Xml):BElement
    {
        var parentElement:BElement;

        for(belementElement in buieXML.elementsNamed("BElement"))
        {
            parentElement = new BElement();

            parentElement.name = belementElement.get("name");

            for(belement in belementElement.elements())
            {

                var type:Class<Dynamic> = Type.resolveClass("borris.controls." + belement.nodeName);
                var bElement = Type.createInstance(type, []);
                trace(type);
                //bElement.name = belement.get("name");
                //bElement.x = Std.parseInt(belement.get("x"));
                //bElement.y = Std.parseInt(belement.get("y"));
                var fields = Type.getInstanceFields(type);
                trace("Label" + fields[fields.indexOf("label")]);

                for(attribute in belement.attributes())
                {
                    trace(attribute);
                    if(Reflect.hasField(bElement, attribute))
                    {
                        Reflect.setField(bElement, attribute, belement.get(attribute));

                    } // end if
                    if(Reflect.hasField(bElement, "set_" + attribute))
                    {
                        //Reflect.setField(bElement, "set_" + attribute, belement.get(attribute));
                        //Reflect.callMethod(bElement, cast(("set_" + attribute), Function), [belement.get(attribute)]);
                    } // end if

                } // end for

                parentElement.addElement(bElement);
            } // end for
        } // end for

        return parentElement;
    }
    // end function


    /**
     *
     */
    /*public static function createXML(buieXML:Xml):Xml
    {
        return new Xml(XmlType.Comment);
    } // end function*/


} // end class
