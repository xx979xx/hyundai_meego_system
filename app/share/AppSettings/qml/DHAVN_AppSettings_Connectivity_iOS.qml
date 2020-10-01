import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import "Components/ScrollingTicker"
import AppEngineQMLConstants 1.0

DHAVN_AppSettings_FocusedItem{
    id: iOSConnectivity

    state: ""
    name: "Connectivity_iOS"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 699

    default_x: 0
    default_y: 0

    property bool isFirstSelect: false
    property bool isCarPlayPopUpOn: false



    property bool menuCheckStates: (SettingsStorage.iOSSetting == 0) ? true: false
    function init()
    {


    }

    function getCurrentIndex()
    {

        return 0;
    }

    function setState(index)
    {


    }

    function selectMenu()
    {

        SettingsStorage.iOSSetting = 1
        SettingsStorage.SaveSetting( 1, Settings.DB_KEY_IOS_SETTING )
        EngineListener.NotifyApplication(Settings.DB_KEY_IOS_SETTING, 1, "", UIListener.getCurrentScreen())

        EngineListener.printLogMessage("Carplay: setCarPlaySettingValue() : strat --> ")
        SettingsStorage.setCarPlaySettingValue();
        EngineListener.printLogMessage("Carplay: setCarPlaySettingValue()")

    }


    DHAVN_AppSettings_FocusedItem{
        id: content_area
        width: 560
        height: 552

        default_x: 0
        default_y:0
        focus_x: 0
        focus_y: 0

        DHAVN_AppSettings_FocusedItem{
            id: checkboxitem
            width: 560
            height: 90//552

            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12

            focus_x: 0
            focus_y: 0

            property bool pressed: false
            property bool checked: menuCheckStates

            Image{
                id: line_image
                x:9; y:89
                source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
            }

            Image{
                id:checkbox_f_id
                anchors.top: line_image.top
                anchors.topMargin: -90
                anchors.left: line_image.left
                anchors.leftMargin: -9
                source: RES.const_URL_IMG_SETTINGS_B_BG_MENU_TAB_R_FOCUSED
                visible: checkboxitem.focus_visible && !checkboxitem.pressed && !checkbox_p_id.visible
            }

            Image{
                id:checkbox_p_id
                anchors.top: line_image.top
                anchors.topMargin: -90
                anchors.left: line_image.left
                anchors.leftMargin: -9
                source: RES.const_URL_IMG_SETTINGS_B_BG_MENU_TAB_R_PRESSED
                visible: checkboxitem.pressed
            }

            ScrollingTicker {
                id: scrollingTicker
                clip: true
                width: 443
                height: 89
                scrollingTextMargin: 120
                anchors.verticalCenter: line_image.top
                anchors.verticalCenterOffset: -45
                anchors.left: line_image.left
                anchors.leftMargin: 14
                isScrolling: checkboxitem.focus_visible && isParkingMode
                fontPointSize: 40
                fontFamily: EngineListener.getFont(false)
                text: qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY")) + LocTrigger.empty
                fontStyle: Text.Sunken
                fontColor: HM.const_COLOR_BRIGHT_GREY
            }

            Image{
                id: checkboxImage
                anchors.top: line_image.top
                anchors.topMargin: -68
                anchors.left: line_image.left
                anchors.leftMargin: 473
                source: checkboxitem.checked ? RES.const_URL_IMG_SETTINGS_B_CHECKED_S_URL : RES.const_URL_IMG_SETTINGS_B_CHECKED_N_URL
            }

            MouseArea{
                id: mouse_area1
                //anchors.fill: checkboxitem
                //enabled: EngineListener.isAccStatusOn
                x:0
                y:0
                width: 560
                height: 90

                onPressed:
                {
                    checkboxitem.pressed = true
                }

                onReleased:
                {
                    if(checkboxitem.pressed)
                    {
                        checkboxitem.pressed = false

                        parent.hideFocus()
                        parent.setFocusHandle(0,0)
                        parent.showFocus()

                        if(SettingsStorage.iOSSetting == 1)
                        {
                            EngineListener.showPopapInMainArea(Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP, UIListener.getCurrentScreen())
                            isCarPlayPopUpOn = true;


                        }
                        else
                        {
                            selectMenu()

                        }

                    }
                }

                onExited:
                {
                    checkboxitem.pressed = false
                }
            }

            onJogSelected:
            {
                switch( status )
                {
                case UIListenerEnum.KEY_STATUS_PRESSED:
                {
                    checkboxitem.pressed = true
                }
                break
                case UIListenerEnum.KEY_STATUS_RELEASED:
                {
                    if(checkboxitem.pressed)
                    {
                        checkboxitem.pressed = false

                        parent.hideFocus()
                        parent.setFocusHandle(0,0)
                        parent.showFocus()

                        if(SettingsStorage.iOSSetting == 1)
                        {
                            EngineListener.showPopapInMainArea(Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP, UIListener.getCurrentScreen())
                            isCarPlayPopUpOn = true;


                        }
                        else
                        {
                            selectMenu()
                            SettingsStorage.iOSSetting = 1

                        }
                    }
                }
                break

                case UIListenerEnum.KEY_STATUS_CANCELED:
                {
                     checkboxitem.pressed = false
                }
                break
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                    rootConnectivity.setVisualCue(true, false, true, false)
            }
        }



    Text{
        id: appText1
        width: 560//510
        anchors.verticalCenter: parent.top

        anchors.verticalCenterOffset: 310/*367*/
        anchors.left: parent.left
        anchors.leftMargin: 14//60/*14*/
        visible : true
        text: {
                qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY_INFO_1"))+ "\n"
                + qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY_INFO_2"))+ "\n"
                + qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_VR"))+ "\n"
                + qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY_INFO_3"))
                + LocTrigger.empty
        }
        color: APP.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 24
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }





    states: [
        State{
            name: APP.const_APP_SETTINGS_CONNECTIVITY_ANDROID_ONOFF
        }
    ]

    Connections{
        target:SettingsStorage

        onIOSSettingChanged:
        {
            //console.log("called onvolumeRatioChanged :"+SettingsStorage.volumeRatio)
            init()
        }
    }

    Connections{
        target:EngineListener

        onSigConnectedCarMounted:
        {
            EngineListener.printLogMessage("Carplay: onSigConnectedCarMounted:  " + iOSConnectivity.visible )
            if(iOSConnectivity.visible)
            {
                if(isCarPlayPopUpOn)
                {
                    root.backButtonHandler(0)
                }
                root.backButtonHandler(0)
                isCarPlayPopUpOn = false
            }

        }

        onSigConnectedCarPluged:
        {
            EngineListener.printLogMessage("Carplay: onSigConnectedCarPluged:  " + iOSConnectivity.visible )
            if(iOSConnectivity.visible)
            {
                if(isCarPlayPopUpOn)
                {
                    root.backButtonHandler(0)
                }
                root.backButtonHandler(0)
                isCarPlayPopUpOn = false
            }
        }
    }


    Connections{
            target:rootPopUpLoader
            onIsYesCarPlay:
            {
                EngineListener.printLogMessage("Carplay: onIsYesCarPlay ")
                isFirstSelect = false
                var ratioVal = 0
                SettingsStorage.iOSSetting = ratioVal
                SettingsStorage.SaveSetting( ratioVal, Settings.DB_KEY_IOS_SETTING )
                EngineListener.NotifyApplication(Settings.DB_KEY_IOS_SETTING, ratioVal, "", UIListener.getCurrentScreen())
                EngineListener.printLogMessage("Carplay: setCarPlaySettingValue() : strat --> ")
                SettingsStorage.setCarPlaySettingValue();
                EngineListener.printLogMessage("Carplay: setCarPlaySettingValue() : end <-- ")

                EngineListener.setConnectivityPopUpOnOff(false)
                isCarPlayPopUpOn = false
            }
            onIsNoCarPlay:
            {
                EngineListener.printLogMessage("Carplay: onIsNoCarPlay ")
                isFirstSelect = false
                EngineListener.setConnectivityPopUpOnOff(false)
                isCarPlayPopUpOn = false
            }
        }


    }


}












/*
import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: iOSConnectivity

    state: ""
    name: "Connectivity_iOS"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 699

    default_x: 0
    default_y: 0

    property bool isFirstSelect: false
    property bool isCarPlayPopUpOn: false

    function init()
    {
        switch(SettingsStorage.iOSSetting)
        {
        case 0:
            radioList.currentindex = 0
            break
        case 1:
            radioList.currentindex = 1
            break
        }

        if(!focus_visible)
            setState(radioList.currentindex)
    }

    function getCurrentIndex()
    {

        switch(SettingsStorage.iOSSetting)
        {
        case 0: return 0
        case 1: return 1
        }
    }

    function setState(index)
    {

        switch(index)
        {
        case 0: iOSConnectivity.state = HM.const_APP_SETTINGS_CONNECTIVITY_IOS_CARPLAY
            break;
        case 1: iOSConnectivity.state = HM.const_APP_SETTINGS_CONNECTIVITY_IOS_TBD
            break;
        }
    }

    function selectMenu()
    {
        EngineListener.printLogMessage("iOS: radioList.currentindex:" + radioList.currentindex +", isFirstSelect: "+  iOSConnectivity.isFirstSelect )
        if(radioList.currentindex == 0 && iOSConnectivity.isFirstSelect == true )
        {
            EngineListener.printLogMessage("iOS: radioList.currentindex == 0 && isFirstSelect == true"  )
            //EngineListener.showPopapInMainArea(Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP, UIListener.getCurrentScreen())
            //isFirstSelect = false
        }
        else
        {
            var ratioVal = radioList.currentindex
            SettingsStorage.iOSSetting = ratioVal
            SettingsStorage.SaveSetting( ratioVal, Settings.DB_KEY_IOS_SETTING )
            EngineListener.NotifyApplication(Settings.DB_KEY_IOS_SETTING, ratioVal, "", UIListener.getCurrentScreen())

            EngineListener.printLogMessage("Carplay: setCarPlaySettingValue() : strat --> ")
            SettingsStorage.setCarPlaySettingValue();
            EngineListener.printLogMessage("Carplay: setCarPlaySettingValue()")
        }
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 50
        onTriggered:
        {
            EngineListener.printLogMessage("iOS: radioList.currentindex:" + radioList.currentindex +", isFirstSelect: "+  iOSConnectivity.isFirstSelect )
            if(radioList.currentindex == 0 && iOSConnectivity.isFirstSelect == true )
            {
                EngineListener.printLogMessage("iOS: radioList.currentindex == 0 && isFirstSelect == true"  )
                //EngineListener.showPopapInMainArea(Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP, UIListener.getCurrentScreen())
                //isFirstSelect = false
            }
            else
            {
                var ratioVal = radioList.currentindex
                SettingsStorage.iOSSetting = ratioVal
                SettingsStorage.SaveSetting( ratioVal, Settings.DB_KEY_IOS_SETTING )
                EngineListener.NotifyApplication(Settings.DB_KEY_IOS_SETTING, ratioVal, "", UIListener.getCurrentScreen())

                EngineListener.printLogMessage("Carplay: setCarPlaySettingValue() : strat --> ")
                SettingsStorage.setCarPlaySettingValue();
                EngineListener.printLogMessage("Carplay: setCarPlaySettingValue()")
            }
        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_area
        width: 560
        height: 552

        default_x: 0
        default_y:0
        focus_x: 0
        focus_y: 0

        DHAVN_AppSettings_FocusedItem{
            id: radiolistarea
            anchors.top: parent.top
            anchors.left:parent.left
            width:parent.width
            height:parent.height

            default_x:0
            default_y:0
            focus_x: 0
            focus_y: 0

            ListModel{
                id: generalModel

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY_TBD")
                    enable: true
                }
            }


            DHAVN_AppSettings_SI_RadioList_Carplay{
                id: radioList

                property string name: "RadioList"
                property int focus_x: 0
                property int focus_y: 0

                anchors.top: parent.top
                anchors.left: parent.left
                currentindex: getCurrentIndex()

                radiomodel: generalModel
                focus_id: 0
                bInteractive: false
                defaultValueIndex: HM.const_SETTINGS_SOUND_RATIO_DEFAULT_VALUE


                onIndexSelected:
                {
                    EngineListener.printLogMessage("iOS: onIndexSelected: currentIndex: " + radioList.currentindex)
                    EngineListener.printLogMessage("iOS: onIndexSelected:SettingsStorage.iOSSetting:" + SettingsStorage.iOSSetting )

                    if(SettingsStorage.iOSSetting == 1 && radioList.currentindex == 0)
                    {
                        EngineListener.printLogMessage("iOS: isFirstSelect:true")
                        isFirstSelect = true
                        radiolistarea.hideFocus()

                        EngineListener.showPopapInMainArea(Settings.SETTINGS_CONNECTIVITY_CARPLAY_POPUP, UIListener.getCurrentScreen())
                        //radioList.currentindex = 3
                        //radioList.focus_index = 3
                        isCarPlayPopUpOn = true;

                    }
                    else
                    {
                        EngineListener.printLogMessage("iOS: else: onIndexSelected: currentIndex: " + radioList.currentindex)
                        EngineListener.printLogMessage("iOS: else: onIndexSelected:SettingsStorage.iOSSetting:" + SettingsStorage.iOSSetting )

                        if(!isJog)
                        {
                            radiolistarea.hideFocus()
                            radiolistarea.setFocusHandle(0,0)
                            focus_index = nIndex
                            radiolistarea.showFocus()
                        }
                    }


                    selectMenu()
//                    if(menuSelectTimer.running)
//                        menuSelectTimer.restart()
//                    else
//                        menuSelectTimer.start()
                }

                onFocus_indexChanged:
                {

                    if(radioList.focus_index>=0 && radioList.focus_index<=generalModel.count && radioList.focus_visible)
                    {
                        iOSConnectivity.setState(radioList.focus_index)
                    }
                }

                onFocus_visibleChanged:
                {
                    if(radioList.focus_visible)
                    {
                        rootConnectivity.setVisualCue(true, false, true, false)
                        iOSConnectivity.setState(radioList.focus_index)
                    }
                    else
                    {
                        iOSConnectivity.setState(radioList.currentindex)
                    }
                }

                Component.onCompleted:
                {
                    iOSConnectivity.setState(radioList.currentindex)
                }
            }
        }
    }

    Text{
        id: appText1
        width: 510
        anchors.verticalCenter: parent.top

        anchors.verticalCenterOffset: 367
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : iOSConnectivity.state == HM.const_APP_SETTINGS_CONNECTIVITY_IOS_CARPLAY
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 25
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }

    Text{
        id: appText2
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 367
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : iOSConnectivity.state == HM.const_APP_SETTINGS_CONNECTIVITY_IOS_TBD
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_CONNECTIVITY_CARPLAY_INFO_TBD")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 25
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }



    states: [
        State{
            name: HM.const_APP_SETTINGS_CONNECTIVITY_IOS_CARPLAY
        },
        State{
            name: HM.const_APP_SETTINGS_CONNECTIVITY_IOS_TBD
        }
    ]

    Connections{
        target:SettingsStorage

        onIOSSettingChanged:
        {
            EngineListener.printLogMessage("Carplay: onIOSSettingChanged ")
            init()
        }
    }

    Connections{
        target:EngineListener

        onSigConnectedCarMounted:
        {
            EngineListener.printLogMessage("Carplay: onSigConnectedCarMounted:  " + iOSConnectivity.visible )
            if(iOSConnectivity.visible)
            {
                if(isCarPlayPopUpOn)
                {
                    root.backButtonHandler(0)
                }
                root.backButtonHandler(0)
                isCarPlayPopUpOn = false
            }

        }
        onSigIPodConnected:
        {
            EngineListener.printLogMessage("Carplay: onSigIPodConnected:  " + iOSConnectivity.visible )
            if(iOSConnectivity.visible)
            {
                if(isCarPlayPopUpOn)
                {
                    root.backButtonHandler(0)
                }
                root.backButtonHandler(0)
                isCarPlayPopUpOn = false
            }
        }

        onSigiAPConnected:
        {
            EngineListener.printLogMessage("Carplay: onSigiAPConnected:  " + iOSConnectivity.visible)
            if(iOSConnectivity.visible)
            {
                if(isCarPlayPopUpOn)
                {
                    root.backButtonHandler(0)
                }
                root.backButtonHandler(0)
                isCarPlayPopUpOn = false
            }
        }
    }

    Connections{
        target:rootPopUpLoader
        onIsYesCarPlay:
        {
            EngineListener.printLogMessage("Carplay: onIsYesCarPlay ")
            isFirstSelect = false
            var ratioVal = 0
            SettingsStorage.iOSSetting = ratioVal
            SettingsStorage.SaveSetting( ratioVal, Settings.DB_KEY_IOS_SETTING )
            EngineListener.NotifyApplication(Settings.DB_KEY_IOS_SETTING, ratioVal, "", UIListener.getCurrentScreen())
            EngineListener.printLogMessage("Carplay: setCarPlaySettingValue() : strat --> ")
            SettingsStorage.setCarPlaySettingValue();
            EngineListener.printLogMessage("Carplay: setCarPlaySettingValue() : end <-- ")

            radioList.focus_index = 0
            radioList.currentindex = 0
            radiolistarea.hideFocus()
            radiolistarea.setFocusHandle(0,0)
            radiolistarea.showFocus()

            EngineListener.setConnectivityPopUpOnOff(false)
            isCarPlayPopUpOn = false
        }
        onIsNoCarPlay:
        {
            EngineListener.printLogMessage("Carplay: onIsNoCarPlay ")
            isFirstSelect = false
            radioList.currentindex = 1
            radioList.focus_index = 1
            radiolistarea.hideFocus()
            radiolistarea.setFocusHandle(0,0)
            radiolistarea.showFocus()
            EngineListener.setConnectivityPopUpOnOff(false)
            isCarPlayPopUpOn = false
        }
    }
}
*/

