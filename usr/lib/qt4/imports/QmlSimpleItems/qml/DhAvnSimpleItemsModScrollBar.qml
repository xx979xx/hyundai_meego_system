import Qt 4.7
import "DhAvnSimpleItemsModScrollBar.js" as HM
import AppEngineQMLConstants 1.0

 /** Slider background image */
Item
{
    id: slider_bg

    property real rScrollValueMax: 0
    property real rScrollValueMin: 0
    property real rScrollValueStep: 1
    property real rScrollCurrentValue: 0
    property bool bScrollEnabled: true

    /** true - Text is over scrollBar , false - Text is left of the scrollBar. */
    property bool bScrollLocation: true
    /** true - small Type, false - big type */
    property bool bScrollSmall: true
    /** true - picture is present in the background of the text, false - picture is absent */
    property bool bBgTextPng: false
    /** true - small Type, false - big type */
    property bool bScrollCursorSmall: true
    /** true - item is focused, false - not focused */
    property bool bFocused: false
    //should be deletedl

    property int focus_id: -1
    property bool focus_visible: false
    property bool is_focusable: true // read only
    property int focus_index: 0

    /** Signals */
    signal switchPressed()
    signal lostFocus ( int arrow, int focusID )

    function handleJogEvent(jogEvent) { }//empty method for Settings
    function showFocus() { focus_visible = true }
    function hideFocus() { focus_visible = false }
    function setDefaultFocus(arrow)
    {
        if ( bScrollEnabled ) return focus_id
        lostFocus( arrow, focus_id )
        return -1
    }

/* ----------------------------------------------------- */
/* --------- Private methods and variables ------------- */
/* ----------------------------------------------------- */
    property bool bPressed: false
    onRScrollCurrentValueChanged: switchPressed()

    function incrementValue()
    {
        if ( rScrollCurrentValue < rScrollValueMax )
        {
            rScrollCurrentValue += rScrollValueStep
        }
    }

    function decrementValue()
    {
        if ( rScrollCurrentValue > rScrollValueMin )
        {
            rScrollCurrentValue -= rScrollValueStep
        }
    }

    Connections
    {
        target: focus_visible && bScrollEnabled ? UIListener: null
        onSignalJogNavigation:
        {
            
            console.log("[ScrollBar]onSignalJogNavigation arrow=" + arrow)
//modified by aettie.ji 2013.04.30 for Click event deletion (for Focus ->Pressed / for Action -> Released) 
//            if ( status == UIListenerEnum.KEY_STATUS_CLICKED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                switch( arrow )
                {
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                        decrementValue()
                        break
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                        incrementValue()
                        break

                    default:
                        lostFocus( arrow, focus_id )
                }
            }
        }
    }

    /**--- Functions ---*/
    function calc_cur_value( mouse_x_pos  )
    {
        if ( ( mouse_x_pos >= 0 ) &&
             ( mouse_x_pos <= slider_bg.width ) )
        {
            var real_value = mouse_x_pos * ( rScrollValueMax - rScrollValueMin ) /
                             slider.sourceSize.width +
                             rScrollValueMin

            if ( rScrollValueStep )
            {
                var index = Math.round( real_value / rScrollValueStep );
                rScrollCurrentValue = rScrollValueStep * index;
            }
        }
    }

    /** --- Object property --- */
    width: scroll.width
    height: pointer.height
    Image
    {
       id: scroll
       anchors.verticalCenter: parent.verticalCenter
       source: HM.const_URL_IMG_GENERAL_SCREEN_SLIDER_N

       /** Slider image */
       Image
       {
           id: slider

           width: ( ( rScrollCurrentValue - rScrollValueMin ) /
                    ( rScrollValueMax - rScrollValueMin ) *
                    ( sourceSize.width ) )
           fillMode: Image.Tile
           source: HM.const_URL_IMG_GENERAL_SCREEN_SLIDER_S

           Image
           {
               id : pointer
               source : HM.const_URL_IMG_GENERAL_SCREEN_SLIDER_POINTER
               anchors{ verticalCenter: parent.verticalCenter; horizontalCenter: parent.right }
           }
       }
               Text
               {
                  font.pixelSize: HM.const_ACTIVITY_SCROLL_TEXT_PIXEL_SIZE
                  color: HM.const_ACTIVITY_SCROLL_TEXT_COLOR_BRIGHT_GREY
                  width : 44
                  //font.family: HM.const_ACTIVITY_SCROLL_TEXT_FONT_FAMILY
                  font.family: HM.const_ACTIVITY_SCROLL_TEXT_FONT_FAMILY_NEW
                  text: rScrollCurrentValue
                  anchors.left: slider.left
                  anchors.leftMargin :463
                  anchors.verticalCenter: slider.verticalCenter
                  style: Text.Sunken
               }
    }

    MouseArea
    {
        enabled: bScrollEnabled
        anchors.fill: parent
        onPositionChanged: { calc_cur_value( mouseX ) }
        onClicked:{ calc_cur_value( mouseX ) }
    }
}
