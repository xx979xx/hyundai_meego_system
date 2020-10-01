import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Resources.js" as RES
import "SimpleItems"


DHAVN_AppSettings_FocusedItem{
    id: screenAspectRatio

    name: "ScreenAspectratio"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 34

    state: ""

    default_x: 0
    default_y: 0

    function init()
    {
        // index 0 -> enum ASPECT_RATIO_T ASPECT_RATIO_16_9 value = 1
        // index 1 -> enum ASPECT_RATIO_T ASPECT_RATIO_4_3 value = 2
        radioList.currentindex = SettingsStorage.aspectRatio - 1

        if(!focus_visible)
            screenAspectRatio.setFrameImage(radioList.currentindex)
    }

    function setFrameImage(index)
    {
        switch( index )
        {
        case 0:
            photoimage.source = RES.const_URL_IMG_SETTINGS_ASPECT_RATIO_LOGO_FULL
            break
        case 1:
            photoimage.source = RES.const_URL_IMG_SETTINGS_ASPECT_RATIO_LOGO_4_3
            break

        default:
            break
        }
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            // index 0 -> enum ASPECT_RATIO_T ASPECT_RATIO_16_9 value = 1
            // index 1 -> enum ASPECT_RATIO_T ASPECT_RATIO_4_3 value = 2
            SettingsStorage.aspectRatio = radioList.currentindex + 1
            SettingsStorage.SaveSetting( radioList.currentindex+1, Settings.DB_KEY_ASPECT_RADIO );
            EngineListener.NotifySetAspectRatio( radioList.currentindex+1, UIListener.getCurrentScreen() )

            // to Most Manager
            // ASPECT_RATIO_4_3 value 0
            // ASPECT_RATIO_16_9 value 1
            EngineListener.NotifySetAspectRatioChange( 1 - radioList.currentindex );
        }
    }

    DHAVN_AppSettings_SI_RadioList{
        id: radioList

        property int default_x: 0
        property int default_y: 0
        property int focus_x: 0
        property int focus_y: 0

        width:560
        height:552

        anchors.top: parent.top
        anchors.left: parent.left
        currentindex: SettingsStorage.aspectRatio
        radiomodel: myListModelId
        bInteractive: false

        focus_id: 0
        defaultValueIndex: HM.const_SETTINGS_SCREEN_ASPECTRATIO_DEFAULT_VALUE
        onIndexSelected:
        {
            if(!isJog)
            {
                parent.hideFocus()
                parent.setFocusHandle(0,0)
                focus_index= nIndex
                parent.showFocus()
            }

            if( menuSelectTimer.running )
                menuSelectTimer.restart()
            else
                menuSelectTimer.start()

            screenAspectRatio.setFrameImage(radioList.currentindex) //added for ITS 261611 Aspect Ratio Image Issue
        }

        onFocus_indexChanged:
        {
            //added for ITS 261611 Aspect Ratio Image Issue
            //if(radioList.focus_index>=0 && radioList.focus_index<=myListModelId.count && radioList.focus_visible)
            //{
            //    screenAspectRatio.setFrameImage(radioList.focus_index)
            //}
        }

        onFocus_visibleChanged:
        {
            if(radioList.focus_visible)
            {
                rootScreen.setVisualCue(true, false, false, true)
                //screenAspectRatio.setFrameImage(radioList.focus_index)//added for ITS 261611 Aspect Ratio Image Issue
            }
            else
            {
                screenAspectRatio.setFrameImage(radioList.currentindex)
            }
        }

        Component.onCompleted:
        {
            screenAspectRatio.setFrameImage(radioList.currentindex)
        }
    }

    ListModel{
        id: myListModelId

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DISPLAY_ASPECT_RATIO_FULL")
            enable: true
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DISPLAY_ASPECT_RATIO_NORMAL")
            enable: true
        }
    }

    Image{
        id: photoimage
        source: ""
        anchors.top:parent.top
        anchors.topMargin: 420-166
        anchors.left: parent.left
        anchors.leftMargin: 76
    }

    Connections{
        target:SettingsStorage

        onAspectRatioChanged:
        {
            //console.log("setAspectratio.qml : called onAspectRatioChanged :"+SettingsStorage.aspectRatio)
            init();

        }
    }
}
