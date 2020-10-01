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

    property real rScrollCenterValue: 0
    property bool bScrollEnabled: true

    property int leftCount: ( rScrollCurrentValue < 0 ) ? (10 + rScrollCurrentValue) : 10
    property int rightCount: ( rScrollCurrentValue >= 0 ) ? rScrollCurrentValue : 0


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
        if( rScrollCurrentValue < rScrollValueMax ){
            if( rScrollCurrentValue >= 0){
                rightCount += rScrollValueStep
                EngineListener.printLogMessage("incrementValue: rightCount:" +rightCount)
                EngineListener.printLogMessage("incrementValue: leftCount:" +leftCount)
            }
            else{
                leftCount += rScrollValueStep
                EngineListener.printLogMessage("incrementValue: leftCount:" +leftCount)
                EngineListener.printLogMessage("incrementValue: rightCount:" +rightCount)
            }

            rScrollCurrentValue += rScrollValueStep
            EngineListener.printLogMessage("incrementValue: rScrollCurrentValue:" +rScrollCurrentValue)
            switchPressed()
        }
    }

    function decrementValue()
    {
        if( rScrollCurrentValue > rScrollValueMin ){
            if( rScrollCurrentValue <= 0 ){
                leftCount -= rScrollValueStep
                EngineListener.printLogMessage("decrementValue: leftCount:" +leftCount)
                EngineListener.printLogMessage("decrementValue: rightCount:" +rightCount)
            }
            else if( rScrollCurrentValue > 0 ){
                rightCount -= rScrollValueStep
                EngineListener.printLogMessage("decrementValue: leftCount:" +leftCount)
                EngineListener.printLogMessage("decrementValue: rightCount:" +rightCount)
            }

            rScrollCurrentValue -= rScrollValueStep
            EngineListener.printLogMessage("decrementValue: rScrollCurrentValue:" +rScrollCurrentValue)
            switchPressed()
        }
    }

    function calc_Left_SliderBar( mouseValue )
    {
        if( mouseValue < 25){
            leftCount = 0;
        }
        else{
            leftCount = ( mouseValue / 25 )

        }
        setValueText( 10 - leftCount, false )
        switchPressed()
        EngineListener.printLogMessage("calc_Left_SliderBar: " )

    }

    function calc_Right_SliderBar( mouseValue )
    {
        var calcValue = mouseValue - 253
        //console.log("calcValue: "+ calcValue)
        if( calcValue < 25 ){
            rightCount = 1
        }
        else{
           rightCount = calcValue / 25
        }
        //console.log("calc_Right_SliderBar: rightCount: " + rightCount)
        setValueText( rightCount , true )
        switchPressed()
        EngineListener.printLogMessage("calc_Right_SliderBar: " )

    }

    function setValueText( inputValue , isPlus)
    {
        if(isPlus){
            rScrollCurrentValue =  inputValue
        }
        else{
            if( inputValue == 0)
                rScrollCurrentValue =  inputValue
            else
                rScrollCurrentValue = -inputValue
        }
        EngineListener.printLogMessage("setValueText: " )
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

                }
            }
        }
    }


    /** --- Object property --- */
    width: scroll.width
    height: pointer.height



    Image{
        id: minusImg
        x: 0
        //y: 141 - 61 - 3
        y: -24
        source: HM.const_URL_IMG_GENERAL_SOUND_MINUS_BG
    }

    Image{
        id: plusImg
        x: 200 + 102 + 188;
        //y: 141 - 61 - 3
        y: -24
        source: HM.const_URL_IMG_GENERAL_SOUND_PLUS_BG
    }


    Text{
        id: valueTxt
        text: (rScrollCurrentValue <= 0) ? rScrollCurrentValue : "+"+rScrollCurrentValue
        color: HM.const_ACTIVITY_SCROLL_TEXT_COLOR_BRIGHT_GREY
        x: 200;
        //y: 141 - 61 - 3
        y: -40
        font.pointSize: 30
        width: 102
        font.family: HM.const_ACTIVITY_SCROLL_TEXT_FONT_FAMILY
        horizontalAlignment: Text.AlignHCenter
        //            style: isVideoMode && (!isBrightEffectShow) ? Text.Outline : Text.Sunken
        //            styleColor: "black"

    }

    //width: 567
    //height: 141
    //x: 0; y: 0



    Item{
        id: sliderArea
        //x: 14
        //y: 141 - 37 - 4
        width: 502
        height: 28


        Row {
            id: leftSliderBar
            x: 0
            y: 4

            Repeater {
                id: leftSlider
                model: 10
                Rectangle{
                    id: leftSliderIcon
                    width: 25
                    height: 24
                    color: "black"
                    opacity: 1

                    Image{
                        id: sliderBg

                        source: getLeftSliderImg()

                        function getLeftSliderImg()
                        {

                            if( leftCount == 0){
                                if( bFocused )
                                    return HM.const_URL_IMG_GENERAL_SOUND_SLIDER_BG_F
                                else
                                    return HM.const_URL_IMG_GENERAL_SOUND_SLIDER_BG_S
                            }
                            else{
                                if( leftCount > index ){
                                    return HM.const_URL_IMG_GENERAL_SOUND_SLIDER_BG_N
                                }
                                else{
                                    if( bFocused )
                                        return HM.const_URL_IMG_GENERAL_SOUND_SLIDER_BG_F
                                    else
                                        return HM.const_URL_IMG_GENERAL_SOUND_SLIDER_BG_S
                                }
                            }

                        }
                    }


                }

            }
        }

        Image{
            id: sliderCenter
            x: 225 + 24
            y: 0
            source: HM.const_URL_IMG_GENERAL_SCREEN_SLIDER_CENTER
        }

        Row {

            id: rightSliderBar
            x: 225 + 24 + 4
            y: 4
            Repeater {
                id: rightSlider
                model: 10
                Rectangle{
                    id: rightsliderIcon
                    width: 25
                    height: 24
                    color: "black"
                    opacity: 1

                    Image{
                        id: sliderFBG
                        source : getRightSliderImg()

                        function getRightSliderImg()
                        {
                            if( rightCount == 0){
                                return HM.const_URL_IMG_GENERAL_SOUND_SLIDER_BG_N
                            }
                            else{
                                if( rightCount > index ){
                                    if( bFocused )
                                        return HM.const_URL_IMG_GENERAL_SOUND_SLIDER_BG_F
                                    else
                                        return HM.const_URL_IMG_GENERAL_SOUND_SLIDER_BG_S
                                }
                                else{
                                    return HM.const_URL_IMG_GENERAL_SOUND_SLIDER_BG_N
                                }
                            }
                        }

                    }


                }

            }
        }

        MouseArea{
            enabled: bScrollEnabled
            anchors.fill: parent
            beepEnabled: false

            onPressed:{
                //console.log("onPressed: " + mouse.x)
                EngineListener.printLogMessage("onPressed:" )
                if( mouse.x >= 0 && mouse.x < 249 ){
                    EngineListener.printLogMessage("onPressed: 1" )
                    rightCount = 0;
                    calc_Left_SliderBar( mouse.x )

                }
                else if( mouse.x > 249 && mouse.x <= 253){
                    EngineListener.printLogMessage("onPressed: 2" )
                    leftCount = 10
                    rightCount = 0
                    setValueText(0, true)
                }
                else if( mouse.x > 253 && mouse.x < 502){
                    EngineListener.printLogMessage("onPressed: 3" )
                    leftCount = 10
                    calc_Right_SliderBar( mouse.x )
                }
                touch()
                EngineListener.printLogMessage("onPressed: 4" )
            }

            onPositionChanged: {
                //console.log("onPositionChanged: " + mouse.x)

                if( SettingsStorage.currentRegion != 1 )
                {
                    if( mouse.x >= 0 && mouse.x < 249 ){
                        rightCount = 0;
                        calc_Left_SliderBar( mouse.x )

                    }
                    else if( mouse.x > 249 && mouse.x <= 253){
                        leftCount = 10
                        rightCount = 0
                        setValueText(0, true)
                    }
                    else if( mouse.x > 253 && mouse.x < 502){
                        leftCount = 10
                        calc_Right_SliderBar( mouse.x )
                    }
                }
            }

            onReleased:
            {
                SettingsStorage.callAudioBeepCommand()
            }
        }

    }


}

