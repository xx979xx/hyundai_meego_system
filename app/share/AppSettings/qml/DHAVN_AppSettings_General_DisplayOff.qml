import QtQuick 1.1
import com.settings.variables 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Resources.js" as RES
import "Components/RearScreenOffButton"

DHAVN_AppSettings_FocusedItem{
    id: displayOffMain
    name: "DisplayOffMain"

    width: 570
    height: 720-166
    anchors.top:parent.top
    anchors.left: parent.left

    default_x: 0
    default_y: 0
    focus_x: 0
    focus_y: 0

    property bool initFocus: false

    property alias rearone:img1.source
    property alias reartwo:img2.source

    /*
    eCVInvalid      = -1,
    eCVKorea        =  0,
    eCVNorthAmerica =  1,
    eCVChina        =  2,
    eCVGeneral      =  3,
    eCVMiddleEast   =  4,
    eCVEuropa       =  5,
    eCVCanada       =  6,
    eCVRussia       =  7,
    eCVInvalidMax   =  8
    */

    //added for Rear Seat Control Spec Update
    function checkRearMonitor()
    {
        if(EngineListener.dcSwapped)
        {
            //added for ITS 248636 Rear Seat Control UI Issue
            EngineListener.printLogMessage("[RSC_Disp]Swap Case: " + currentTargetScreen + UIListener.getCurrentScreen());
            if(currentTargetScreen == 1 && currentTargetScreen == UIListener.getCurrentScreen())
            {
                EngineListener.printLogMessage("Del RSC at Rear Disp.");
                return false;
            }
            else
            {
                return true;
            }
        }
        else
        {
            //added for ITS 248636 Rear Seat Control UI Issue
            EngineListener.printLogMessage("[RSC_Disp]NorMal Case: " + currentTargetScreen + UIListener.getCurrentScreen());
            if(currentTargetScreen == 2 && currentTargetScreen == UIListener.getCurrentScreen())
            {
                EngineListener.printLogMessage("Del RSC at Rear Disp.");
                return false;
            }
            else
            {
                return true;
            }
        }

    }
        //added for Rear Seat Control Spec Update

    function getPadOnImage()
    {
        switch(SettingsStorage.currentRegion)
        {
        case 0:
        case 1:
        case 6:
        case 2:
            return RES.const_URL_IMG_SETTINGS_TURNOFF_PAD_ON_KR

        case 3:
        case 4:
        case 5:
        case 7:
            return RES.const_URL_IMG_SETTINGS_TURNOFF_PAD_ON_EU
        }
    }

    Text{
        id: displayOffTitleText
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 34
        anchors.left:parent.left
        width: 477

        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_TURN_OFF")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_BRIGHT_GREY
        font.family: EngineListener.getFont(false)
        font.pointSize: 30
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        //visible: SettingsStorage.rearRRCVariant //added for Rear Seat Control Spec Update
    }

    Image{
        id: img

        anchors.top: parent.top
        anchors.topMargin: (SettingsStorage.rearRRCVariant && checkRearMonitor()) ? 67 : 107/*143*/ //added for Rear Seat Control Spec Update
        anchors.left:  parent.left
        anchors.leftMargin: 56

        source: SettingsStorage.rearRRCVariant ? RES.const_URL_IMG_SETTINGS_TURNOFF_BACKGROUND : RES.const_URL_IMG_SETTINGS_TURNOFF_BACKGROUND_RRC_OFF

        Image{
            id: img1
            x:38
            y:108
            source: SettingsStorage.LeftRearScreen ?
                        getPadOnImage() : RES.const_URL_IMG_SETTINGS_TURNOFF_PAD_OFF
        }

        Image{
            id: img2
            x:290
            y:108
            source: SettingsStorage.RightRearScreen ?
                        getPadOnImage() : RES.const_URL_IMG_SETTINGS_TURNOFF_PAD_OFF
        }

        Text{
            id: captiontext
            anchors.top: parent.top
            anchors.topMargin: (SettingsStorage.rearRRCVariant && checkRearMonitor()) ? 200 : 255 //added for Rear Seat Control Spec Update
            anchors.left:  parent.left
            anchors.leftMargin: -17
            width: 508

            text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_TURN_OFF_INFO")) + LocTrigger.empty
            color: HM.const_COLOR_TEXT_BRIGHT_GREY
            font.family: EngineListener.getFont(false)
            font.pointSize: (lineCount > 3) ? 22:24
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            lineHeightMode: lineCount > 1 ? Text.FixedHeight : Text.ProportionalHeight
            lineHeight: (lineHeightMode == Text.FixedHeight) ? ((lineCount > 3) ? 28:30) : 1
        }
    }


    DHAVN_AppSettings_RearScreenOffButton{
        id: rearScreenButton
        name: "RearScreenLeftButton"
        anchors.top: parent.top
        anchors.topMargin:(SettingsStorage.rearRRCVariant && checkRearMonitor()) ? 71 : 111 //added for Rear Seat Control Spec Update
        anchors.left: parent.left
        anchors.leftMargin:55
        bExecuteMoveJogRight: false

        focus_x: 0
        focus_y: 0

        function buttonClicked(){
            if (SettingsStorage.LeftRearScreen) {
                EngineListener.NotifyApplication( Settings.DB_KEY_REAR_ON, 0, "", UIListener.getCurrentScreen() )
                SettingsStorage.LeftRearScreen = false
            } else {
                EngineListener.NotifyApplication( Settings.DB_KEY_REAR_ON, 1, "", UIListener.getCurrentScreen() )
                SettingsStorage.LeftRearScreen = true
            }
        }

        onRearOn:
        {
            displayOffMain.rearone = getPadOnImage()
        }

        onRearOff:
        {
            displayOffMain.rearone = RES.const_URL_IMG_SETTINGS_TURNOFF_PAD_OFF
        }

        onClicked:
        {
            displayOffMain.hideFocus()
            displayOffMain.setFocusHandle(0,0)
            displayOffMain.showFocus()

            buttonClicked()
        }

        onJogWheelRight:
        {
            displayOffMain.hideFocus()
            displayOffMain.setFocusHandle(1,0)
            displayOffMain.showFocus()
        }

        onJogClicked:
        {
            buttonClicked()
        }

        onFocus_visibleChanged:
        {
            /*
            if(SettingsStorage.rearRRCVariant && EngineListener.isAccStatusOn)
            {
                rootGeneral.setVisualCue(true, true, true, false)
                visualCue.longkey_other = true
            }
            else
                rootGeneral.setVisualCue(true, false, true, false)
            */
            //modify for ITS 248591 Rear Seat Menu Visual Cue Issue
            if(SettingsStorage.rearRRCVariant && EngineListener.isAccStatusOn)
            {
                if(checkRearMonitor())
                {
                    rootGeneral.setVisualCue(true, true, true, false)
                    visualCue.longkey_other = true
                }
                else
                {
                   rootGeneral.setVisualCue(true, false, true, false)
                   visualCue.longkey_other = true
                }
            }
            else
                rootGeneral.setVisualCue(true, false, true, false)
        }
    }

    DHAVN_AppSettings_RearScreenOffButtonOne{
        id: rearScreenButton1
        name: "RearScreenRightButton"
        anchors.top: parent.top
        anchors.topMargin:(SettingsStorage.rearRRCVariant && checkRearMonitor()) ? 71 : 111 //added for Rear Seat Control Spec Update
        anchors.left: rearScreenButton.left
        anchors.leftMargin:241

        focus_x: 1
        focus_y: 0

        function buttonClicked()
        {
            if (SettingsStorage.RightRearScreen) {
                EngineListener.NotifyApplication( Settings.DB_KEY_REAR_ON,2,"",UIListener.getCurrentScreen())
                SettingsStorage.RightRearScreen = false
            } else {
                EngineListener.NotifyApplication( Settings.DB_KEY_REAR_ON,3,"",UIListener.getCurrentScreen())
                SettingsStorage.RightRearScreen = true
            }
        }

        onRearOn:
        {
            displayOffMain.reartwo = getPadOnImage()
        }
        onRearOff:
        {
            displayOffMain.reartwo = RES.const_URL_IMG_SETTINGS_TURNOFF_PAD_OFF
        }

        onClicked:
        {
            displayOffMain.hideFocus()
            displayOffMain.setFocusHandle(1,0)
            displayOffMain.showFocus()

            buttonClicked()
        }

        onJogWheelLeft:
        {
            displayOffMain.hideFocus()
            displayOffMain.setFocusHandle(0,0)
            displayOffMain.showFocus()
        }

        onJogLeft:
        {
            displayOffMain.hideFocus()
            displayOffMain.moveFocusHandle(-1,0)
        }

        onJogClicked:
        {
            buttonClicked()
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
            {
                //modify for ITS 248591 Rear Seat Menu Visual Cue Issue
                if(SettingsStorage.rearRRCVariant && EngineListener.isAccStatusOn)
                {
                    if(checkRearMonitor())
                    {
                        rootGeneral.setVisualCue(true, true, true, false)
                        visualCue.longkey_other = true
                    }
                    else
                    {
                       rootGeneral.setVisualCue(true, false, true, false)
                       visualCue.longkey_other = true
                    }
                }
                else
                    rootGeneral.setVisualCue(true, false, true, false)
            }
        }
    }
}
