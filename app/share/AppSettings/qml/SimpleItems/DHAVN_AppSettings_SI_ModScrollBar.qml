import QtQuick 1.1
import "DHAVN_AppSettings_SI_ModScrollBar.js" as HM
import AppEngineQMLConstants 1.0

/** Slider background image */
Item{
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
    property bool is_focusMovable: true
    property int focus_index: 0

    /** Signals */
    signal touch()
    signal switchPressed()
    signal lostFocus ( int arrow, int focusID )

    function handleJogEvent(jogEvent) { }//empty method for Settings
    function showFocus() { focus_visible = true }
    function hideFocus() { focus_visible = false }
    function setDefaultFocus(arrow)
    {
        if ( bScrollEnabled ) return focus_id
        //console.log("ScrollBar:: function setDefaultFocus(arrow) -> lostFocus( arrow, focus_id )")
        lostFocus( arrow, focus_id )
        return -1
    }

    /* ----------------------------------------------------- */
    /* --------- Private methods and variables ------------- */
    /* ----------------------------------------------------- */
    property bool bPressed: false
    //onRScrollCurrentValueChanged:

    function incrementValue()
    {
        if ( rScrollCurrentValue < rScrollValueMax )
        {
            rScrollCurrentValue += rScrollValueStep
            switchPressed()
        }
    }

    function decrementValue()
    {
        if ( rScrollCurrentValue > rScrollValueMin )
        {
            rScrollCurrentValue -= rScrollValueStep
            switchPressed()
        }
    }

    Connections{
        target: bFocused && bScrollEnabled ? UIListener: null
        onSignalJogNavigation:
        {
            if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
                switch( arrow )
                {
                case UIListenerEnum.JOG_WHEEL_LEFT:
                    decrementValue()
                    break
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                    incrementValue()
                    break

                    /*
                default:
                {
                    console.log("ScrollBar:: lostFocus("+arrow+", focus_id )")
                    lostFocus( arrow, focus_id )
                    break
                }
                */
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
                switchPressed()
            }
        }
    }

    /** --- Object property --- */
    width: scroll.width
    height: pointer.height
    Image{
        id: scroll
        anchors.verticalCenter: parent.verticalCenter
        source: HM.const_URL_IMG_GENERAL_SCREEN_SLIDER

        /** Slider image */
        Image{
            id: slider

            width: ( ( rScrollCurrentValue - rScrollValueMin ) /
                    ( rScrollValueMax - rScrollValueMin ) *
                    ( sourceSize.width ) )
            fillMode: Image.Tile
            source: bFocused ? HM.const_URL_IMG_GENERAL_SCREEN_SLIDER_F : HM.const_URL_IMG_GENERAL_SCREEN_SLIDER_N

            Image{
                id : pointer
                source : bFocused ? HM.const_URL_IMG_GENERAL_SCREEN_POINTER_F : HM.const_URL_IMG_GENERAL_SCREEN_POINTER_N
                anchors{ verticalCenter: parent.verticalCenter; horizontalCenter: parent.right }
            }
        }
        Text{
            font.pointSize: HM.const_ACTIVITY_SCROLL_TEXT_PIXEL_SIZE
            color: HM.const_ACTIVITY_SCROLL_TEXT_COLOR_BRIGHT_GREY
            width : 64
            font.family: HM.const_ACTIVITY_SCROLL_TEXT_FONT_FAMILY
            text: rScrollCurrentValue
            anchors.left: slider.left
            anchors.leftMargin :453
            anchors.verticalCenter: slider.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            style: isVideoMode && (!isBrightEffectShow) ? Text.Outline : Text.Sunken
            styleColor: "black"
        }
    }

    Item{
        id: scrollBarMouseArea
        width: parent.width + 80
        height: parent.height + 40
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: scroll.horizontalCenter

        MouseArea{
            enabled: bScrollEnabled
            anchors.fill: parent
            beepEnabled: false

            onPositionChanged: {
                if ( mouse.x >= -5 && mouse.x <= parent.width )
                {
                    if(mouseX < 40)
                        calc_cur_value( 0 )
                    else if(mouseX > parent.width - 40)
                        calc_cur_value( slider_bg.width )
                    else
                        calc_cur_value( mouseX - 40 )
                }
            }
            onPressed:
            {
                if ( mouse.x >= -5 && mouse.x <= parent.width )
                {
                    if(mouseX < 40)
                        calc_cur_value( 0 )
                    else if(mouseX > parent.width - 40)
                        calc_cur_value( slider_bg.width )
                    else
                        calc_cur_value( mouseX - 40 )

                    touch()
                }
            }
            onReleased:
            {
                SettingsStorage.callAudioBeepCommand()
            }
        }
    }
}
