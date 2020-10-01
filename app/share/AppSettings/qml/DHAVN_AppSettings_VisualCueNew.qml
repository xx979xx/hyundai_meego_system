import QtQuick 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_Resources.js" as RES
import "DHAVN_AppSettings_General.js" as APP
Item {
    id: visualCue

    property bool leftArrow: false
    property bool rightArrow: false
    property bool upArrow: false
    property bool downArrow: false

    property bool moved: false

    property bool longkey: false
    property bool longkey_other: true

    property int moveValue: 5
    property int animationDuration: 25

    function pressLeft ()
    {
        if (leftArrow)
        {
            visual_cue_bg.x = 561 //visual_cue_bg.x - moveValue
            leftPressImg.visible = true
            moved = true
        }
    }

    function pressRight ()
    {
        if (rightArrow)
        {
            visual_cue_bg.x = 571 //visual_cue_bg.x + moveValue
            rightPressImg.visible = true
            moved = true
        }
    }

    function pressUp ()
    {
        if (upArrow)
        {
            visual_cue_bg.y = 193 //visual_cue_bg.y - moveValue
            upPressImg.visible = true
            moved = true
        }
    }

    function pressDown ()
    {
        if ((downArrow || longkey) && longkey_other)
        {
            visual_cue_bg.y = 203 //visual_cue_bg.y + moveValue
            downPressImg.visible = true
            moved = true
            longkey = false // add for its 245145
        }
    }

    function releaseLeft ()
    {
        if (moved)
        {
            visual_cue_bg.x = 566 //visual_cue_bg.x + moveValue
            leftPressImg.visible = false
            moved = false
        }
    }

    function releaseRight ()
    {
        if (moved)
        {
            visual_cue_bg.x = 566 //visual_cue_bg.x - moveValue
            rightPressImg.visible = false
            moved = false
        }
    }

    function releaseUp ()
    {
        if (moved)
        {
            visual_cue_bg.y = 198 //visual_cue_bg.y + moveValue
            upPressImg.visible = false
            moved = false
        }
    }

    function releaseDown ()
    {
        if (moved)
        {
            visual_cue_bg.y = 198 //visual_cue_bg.y - moveValue
            downPressImg.visible = false
            moved = false
        }
    }

    Connections{
        //target: visual_cue_bg.visible ? UIListener : null
        target: root
        onVisualCue:
        //onSignalJogNavigation:
        {
            switch ( event )
            {
            case UIListenerEnum.JOG_UP:
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    pressUp()
                }

                if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
                {
                    releaseUp()
                }

                if( status == UIListenerEnum.KEY_STATUS_CANCELED )
                {
                    releaseUp()
                }

                break
            }
            case UIListenerEnum.JOG_RIGHT:
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    pressRight()
                }

                if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
                {
                    releaseRight()
                }

                if( status == UIListenerEnum.KEY_STATUS_CANCELED )
                {
                    releaseRight()
                }

                break
            }
            case UIListenerEnum.JOG_DOWN:
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    pressDown()
                }

                if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
                {
                    releaseDown()
                }

                if( status == UIListenerEnum.KEY_STATUS_CANCELED )
                {
                    releaseDown()
                }

                if( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED )
                {
                    longkey = true
                    pressDown()
                }

                break
            }
            case UIListenerEnum.JOG_LEFT:
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    pressLeft()
                }

                if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
                {
                    releaseLeft()
                }

                if( status == UIListenerEnum.KEY_STATUS_CANCELED )
                {
                    releaseLeft()
                }

                break
            }

            }
        }
    }

    Image{
        id: visual_cue_bg

        x: 566; y: 198
        source: RES.const_URL_IMG_SETTINGS_CUE_CONTROL

        Image{
            x: 22; y: 58
            source: leftArrow ? RES.const_URL_IMG_SETTINGS_CUE_ARROW_LEFT_N : RES.const_URL_IMG_SETTINGS_CUE_ARROW_LEFT_D
        }

        Image{
            id: leftPressImg

            x: 22; y: 58
            visible: false
            source: RES.const_URL_IMG_SETTINGS_CUE_ARROW_LEFT_S
        }

        Image{
            x: 87; y: 58
            source: rightArrow ? RES.const_URL_IMG_SETTINGS_CUE_ARROW_RIGHT_N : RES.const_URL_IMG_SETTINGS_CUE_ARROW_RIGHT_D
        }

        Image{
            id: rightPressImg
            x: 87; y: 58
            visible: false
            source:RES.const_URL_IMG_SETTINGS_CUE_ARROW_RIGHT_S
        }

        Image{
            x: 53; y: 27
            source: upArrow ? RES.const_URL_IMG_SETTINGS_CUE_ARROW_UP_N : RES.const_URL_IMG_SETTINGS_CUE_ARROW_UP_D
        }

        Image{
            id : upPressImg
            x: 53; y: 27
            visible: false
            source: RES.const_URL_IMG_SETTINGS_CUE_ARROW_UP_S
        }

        Image{
            x: 53; y: 92
            source: downArrow ? RES.const_URL_IMG_SETTINGS_CUE_ARROW_DOWN_N : RES.const_URL_IMG_SETTINGS_CUE_ARROW_DOWN_D
        }

        Image{
            id: downPressImg
            x: 53; y: 92
            visible: false
            source: RES.const_URL_IMG_SETTINGS_CUE_ARROW_DOWN_S
        }

        Behavior on x {
            NumberAnimation { duration: animationDuration }
        }
        Behavior on y {
            NumberAnimation { duration: animationDuration }
        }

        MouseArea
        {
            id: launchMapCare
            anchors.fill: parent
            beepEnabled: false

            onPressAndHold:
            {
                //                if( (SettingsStorage.currentRegion == APP.const_SETTINGS_REGION_EUROPA ||
                //                     SettingsStorage.currentRegion == APP.const_SETTINGS_REGION_RUSSIA ) &&
                //                     root.state == APP.const_APP_SETTINGS_MAIN_STATE_SYSTEM && root.bEnableLaunchMapCare)
                //                    EngineListener.launchMapCareEngineeringMode(UIListener.getCurrentScreen());

                // -> modify for mapcare enter at any variant 01/08
                if(root.state == APP.const_APP_SETTINGS_MAIN_STATE_SYSTEM)
                {
                    console.log("[QML] Press and hold at GE variant Visula Cue")

                    EngineListener.launchMapCareEngineeringMode(UIListener.getCurrentScreen());
                    UIListener.ManualBeep() // added for ITS 219794 beep sound
                }
                // <- modify for mapcare enter at any variant 01/08
            }
        }
    }
}
