package borris.display;


/**
 * ...
 *
 * @author Rohaan Allport
 * @creation-date 19/09/2018 (dd/mm/yyyy)
 */
interface IBStyleable
{
    //public var (get, set):Dynamic;

    //==================================================================================================================
    // A
    //==================================================================================================================
    /*public var alignContent(get, set):Dynamic;
    public var alignItems(get, set):Dynamic;
    public var alignSelf(get, set):Dynamic;
    public var all(get, set):Dynamic;
    public var animation(get, set):Dynamic;
    public var animationDelay(get, set):Dynamic;
    public var animationDirection(get, set):Dynamic;
    public var animationDuration(get, set):Dynamic;
    public var animationFillMode(get, set):Dynamic;
    public var animationIterationCount(get, set):Dynamic;
    public var animationName(get, set):Dynamic;
    public var animationPlayState(get, set):Dynamic;
    public var animationTimingFunction(get, set):Dynamic;*/

    //==================================================================================================================
    // b
    //==================================================================================================================

    //public var backfaceVisibility(get, set):Dynamic;
    //public var backgroundAttachment(get, set):Dynamic;
    //public var backgroundBlendMode(get, set):Dynamic;
    //public var backgroundClip(get, set):Dynamic;
    public var backgroundColor(get, set):Dynamic;
    //public var backgroundImage(get, set):Dynamic;
    //public var backgroundOrigin(get, set):Dynamic;
    //public var backgroundPosition(get, set):Dynamic;
    //public var backgroundRepeat(get, set):Dynamic;
    //public var backgroundSize(get, set):Dynamic;
    public var backgroundOpacity(get, set):Float;           // extra property

    //public var border(get, set):Dynamic;
    //public var borderBottom(get, set):Dynamic;
    public var borderBottomLeftRadius(get, set):Dynamic;
    public var borderBottomRightRadius(get, set):Dynamic;
    //public var borderBottomStyle(get, set):Dynamic;
    public var borderBottomWidth(get, set):Dynamic;
    //public var borderCollapse(get, set):Dynamic;
    public var borderColor(get, set):Dynamic;
    //public var borderImage(get, set):Dynamic;
    //public var borderImageOutset(get, set):Dynamic;
    //public var borderImageRepeat(get, set):Dynamic;
    //public var borderImageSlice(get, set):Dynamic;
    //public var borderImageSource(get, set):Dynamic;
    //public var borderImageWidth(get, set):Dynamic;
    //public var borderLeft(get, set):Dynamic;
    //public var borderLeftColor(get, set):Dynamic;
    //public var borderLeftStyle(get, set):Dynamic;
    public var borderLeftWidth(get, set):Dynamic;
    public var borderRadius(get, set):Dynamic;
    //public var borderRight(get, set):Dynamic;
    //public var borderRightColor(get, set):Dynamic;
    //public var borderRightStyle(get, set):Dynamic;
    public var borderRightWidth(get, set):Dynamic;
    //public var borderSpacing(get, set):Dynamic;
    //public var borderStyle(get, set):Dynamic;
    //public var borderTop(get, set):Dynamic;
    //public var borderTopColor(get, set):Dynamic;
    public var borderTopLeftRadius(get, set):Dynamic;
    public var borderTopRightRadius(get, set):Dynamic;
    //public var borderTopStyle(get, set):Dynamic;
    public var borderTopWidth(get, set):Dynamic;
    public var borderWidth(get, set):Dynamic;

    public var borderBevel(get, set):Dynamic;               // extra property
    public var borderBevels(get, set):Int;                  // extra property
    public var borderOpacity(get, set):Float;               // extra property

    /*public var bottom(get, set):Float;
    public var boxDecorationBreak(get, set):Dynamic;
    public var boxShadow(get, set):Dynamic;
    public var boxSizing(get, set):Dynamic;
    public var breakAfter(get, set):Dynamic;
    public var breakBefore(get, set):Dynamic;
    public var breakInside(get, set):Dynamic;*/

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
} // end interface
