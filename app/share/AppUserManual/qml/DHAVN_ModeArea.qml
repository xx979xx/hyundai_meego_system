import QtQuick 1.1
//import Qt 4.7
import AppEngineQMLConstants 1.0
//import "DHAVN_ModeArea.js" as MODEAREA
import "DHAVN_AppUserManual_Images.js" as Images
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item {
    id: modeArea
    width: Dimensions.const_AppUserManual_MainScreenWidth
    height: 72 //Dimensions.const_AppUserManual_MainScreenHeight

    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property int focus_id: Dimensions.const_AppUserManual_ModeArea_FocusIndex
    property bool focus_visible: ( appUserManual.focusIndex == focus_id  || appUserManual.lockoutMode ) && !disable_popup.visible && !mainFullScreen && !systemPopupVisible
    property int focus_index: Dimensions.const_AppUserManual_ModeArea_MenuBtn
    property int jogCenterPressed: -1
    property bool jogPressed: false
    property bool menuBtnExit: false
    property bool backBtnExit: false
    property bool menuBtnPress: false
    property bool backBtnPress: false

    property string strMenu: EngineListener.getHWType() == 2 ? qsTranslate("main", "STR_MANUAL_MENU_DHPE") : qsTranslate("main", "STR_MANUAL_MENU")
    property string backBtnN: appUserManual.langId == 20 ? Images.const_WIDGET_BB_ME_IMG_NORMAL : Images.const_WIDGET_BB_IMG_NORMAL
    property string backBtnF: appUserManual.langId == 20 ? Images.const_WIDGET_BB_ME_IMG_FOCUS : Images.const_WIDGET_BB_IMG_FOCUSED
    property string backBtnP: appUserManual.langId == 20 ? Images.const_WIDGET_BB_ME_IMG_PRESSED : Images.const_WIDGET_BB_IMG_PRESSED
    property string menuBtnN: Images.const_AppUserManual_Search_Button_Image_N
    property string menuBtnF: Images.const_AppUserManual_Search_Button_Image_F
    property string menuBtnP: Images.const_AppUserManual_Search_Button_Image_P

    signal lostFocus( );

    function setFG()
    {
        console.log("ModeArea.qml :: setFG()")
        menuBtnPress = false
        menuBtnExit = false
        backBtnPress = false
        backBtnExit = false
        jogPressed = false
        jogCenterPressed = false
    }

    function getTouchPress()
    {
        console.log("ModeArea.qml :: getTouchPress()")
        return backBtnPress
    }
    function getJogPress()
    {
        console.log("ModeArea.qml :: getJogPress()")
        return jogPressed
    }

    function setFocusDrsMode()
    {
        console.log("ModeArea.qml :: setFocusDrsMode()")
        focus_index = Dimensions.const_AppUserManual_ModeArea_BackBtn
    }

    function getMenuBtnPressed()
    {
        return menuBtnPress
    }

    function getBackBtnPressed()
    {
        return backBtnPress
    }

    Image {
        id: img_title
        source: Images.const_AppUserManual_BG_Title
    }

    DHAVN_AppUserManual_ScrollText {
        id: txt_title
        anchors.left: parent.left; anchors.leftMargin: appUserManual.langId == 20 ? 464 : 45//appUserManual.countryVariant == 4  ?  405 : 46
        width: 770; height: 70
        scrollingTextMargin: 120        // 꼬리물기로 들어올 Text간 간격
        isScrolling: appUserManual.state == "pdfScreenView"     // PDF 화면인 경우
                && appUserManual.nowFG
                && !appUserManual.lockoutMode                      // 주행규제가 아닌 경우
                && !appUserManual.mainFullScreen        // full 화면이 아닌 경우
                && appUserManual.focusIndex != Dimensions.const_AppUserManual_OptionMenu_FocusIndex         // option menu 보이지 않는 경우
        fontPointSize:  Dimensions.const_AppUserManual_Font_Size_40
        clip: true
        fontFamily: vehicleVariant == 1 ? "KH_HDB" : "DH_HDB"
        fontColor: Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        text: appUserManual.state == "pdfListView" /*|| appUserManual.lockoutMode*/ ?  appUserManual.modeAreaTitle : appUserManual.titleText
        fontBold: false
    }

    Text {
        id: txt_page
        anchors.left: parent.left; anchors.leftMargin: appUserManual.langId == 20  ?  276 +20 : 835
        anchors.top: parent.top; anchors.topMargin: 13
//        x: appUserManual.countryVariant == 4  ? 405 : 835; y: 110 - 12 - 93
        width: 146
        color: Dimensions.const_AppUserManual_ListText_Color_BrightGrey // Dimensions.const_AppUserManual_ListText_Color_Select
        font.pixelSize: Dimensions.const_AppUserManual_Font_Size_30
        font.family: vehicleVariant == 1 ? "KH_HDB" : "DH_HDB"
        wrapMode: Text.WordWrap; textFormat: Text.RichText
        horizontalAlignment:  ( appUserManual.langId == 20 ) ? Text.AlignLeft : Text.AlignRight
        text:  appUserManual.modeAreaPage
        visible: appUserManual.state == "pdfScreenView" && !appUserManual.gotoPageBox && !appUserManual.lockoutMode
    }

    Image {
        id: img_menuBtn
        x: appUserManual.langId == 20  ? 138+3 : Dimensions.const_AppUserManual_ModeArea_MenuBtn_X
        width: 141; height: 72
        source: ( menuBtnPress && !menuBtnExit ) || ( jogPressed && jogCenterPressed == Dimensions.const_AppUserManual_ModeArea_MenuBtn ) ? menuBtnP
                : ( focus_index == Dimensions.const_AppUserManual_ModeArea_MenuBtn && focus_visible && !appUserManual.lockoutMode) ? menuBtnF
                : menuBtnN
        visible: !appUserManual.gotoPageBox
        Text {
            id: txt_menu
            anchors.centerIn: parent
            text: strMenu// qsTranslate("main", "STR_MANUAL_MENU")
            font.pixelSize: Dimensions.const_AppUserManual_Font_Size_30
            color: appUserManual.lockoutMode ? Dimensions.const_AppUserManual_ListText_Color_DisableGrey : Dimensions.const_AppUserManual_ListText_Color_BrightGrey
            font.family: vehicleVariant == 1 ? "KH_HDB" : "DH_HDB"
            wrapMode: Text.WordWrap; textFormat: Text.RichText
        }
        MouseArea {
            id: menuBtnMA
            anchors.fill: parent
            enabled: appUserManual.state != "pdfSearchView" && !appUserManual.lockoutMode && !appUserManual.touchLock
            onPressed: {
                console.log("Modearea.qml :: menuBtnMA onPressed")
                menuBtnPress = true
                menuBtnExit = false
                if ( appUserManual.state == "pdfScreenView" ) {
                    appUserManual.setFullScreenTimer(true)
                }
            }
            onClicked: {
                console.log("Modearea.qml :: menuBtnMA onClicked")
                if ( appUserManual.state == "pdfListView") {
                    appUserManual.launchTouchMenu()
                }
                if ( menuBtnPress && !menuBtnExit && !appUserManual.systemPopupVisible) appUserManual.launchMenu()
                menuBtnPress = false
            }
            onExited: {
                console.log("Modearea.qml :: menuBtnMA onExited")
                menuBtnExit = true
            }
            onReleased: {
                console.log("Modearea.qml :: menuBtnMA onReleased")
                if ( appUserManual.state == "pdfScreenView" ) {
                    appUserManual.setFullScreenTimer(false)
                }
            }
        }
    }
    Image {
        id: img_backBtn
        x: appUserManual.langId == 20  ? 3 : 860 + 138 + 138
        source: ( backBtnPress && !backBtnExit ) || ( jogPressed && jogCenterPressed == Dimensions.const_AppUserManual_ModeArea_BackBtn ) ? backBtnP : ( focus_visible && focus_index == Dimensions.const_AppUserManual_ModeArea_BackBtn ) ? backBtnF : backBtnN
        MouseArea {
            id: backBtnMA
            anchors.fill: parent
            enabled: !appUserManual.touchLock
            onPressed: {
                console.log("Modearea.qml :: backBtnMA Pressed")
                backBtnPress = true
                backBtnExit = false
                if ( appUserManual.state == "pdfScreenView" ) {
                    console.log("Modearea.qml :: backBtnMA onReleased")
                    appUserManual.setFullScreenTimer(true)
                }
            }
            onReleased: {
                console.log("Modearea.qml :: backBtnMA onReleased")
                if ( backBtnPress && !backBtnExit ) {
                    backBtnPress = false
                    appUserManual.handleBackKey( false ,  true , true )
                }
                backBtnPress = false
                if ( appUserManual.state == "pdfScreenView" ) {
                    console.log("Modearea.qml :: backBtnMA onReleased")
                    appUserManual.setFullScreenTimer(false)
                }
            }
            onExited: {
                console.log("Modearea.qml :: backBtnMA onExited")
                backBtnExit = true
            }

        }
    }

    function retranslateUI()
    {
        strMenu = EngineListener.getHWType() == 2 ? qsTranslate("main", "STR_MANUAL_MENU_DHPE") : qsTranslate("main", "STR_MANUAL_MENU")
    }



    Connections
    {
        target: EngineListener

        onRetranslateUi:
        {
            console.log("ModeArea.qml :: RetranslateUi Called.")
            retranslateUI()
        }
    }
    Connections
    {
        target: ( focus_visible || appUserManual.lockoutMode ) ? UIListener : null
        onSignalJogNavigation:
        {
            if ( disable_popup.visible ) return;
            console.log("Modearea.qml :: onSignalJogNavigation")
            switch( arrow )
            {
                case UIListenerEnum.JOG_UP: {
                    console.log("Modearea.qml :: onSignalJogNavigation - JOG_UP")
                    if ( appUserManual.gotoPageBox || appUserManual.lockoutMode )  focus_index = Dimensions.const_AppUserManual_ModeArea_BackBtn
                    if ( status == UIListenerEnum.KEY_STATUS_RELEASED ) {
                        console.log("Modearea.qml :: onSignalJogNavigation - JOG_UP 1")
                         if ( appUserManual.state == "pdfScreenView" ) {
                             if ( appUserManual.mainFullScreen ) appUserManual.setFullScreen(false)         // 주행규제 상태에서 jog up 입력 시 전체화면 해제
                             appUserManual.startTimer()
                         }
                    }
                    break;
                }
                case UIListenerEnum.JOG_CENTER:
                {
                    console.log("Modearea.qml :: onSignalJogNavigation - JOG_CENTER")
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED ) {
                        jogCenterPressed = focus_index
                        jogPressed = true
                        if ( appUserManual.state == "pdfScreenView" ) appUserManual.stopTimer()
                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_RELEASED ) {
                        jogCenterPressed = -1
                        jogPressed = false
                        if ( appUserManual.lockoutMode && appUserManual.state == "pdfScreenView" && appUserManual.mainFullScreen ) {
                            appUserManual.setFullScreen(false)
                        }
                        else if ( focus_index == Dimensions.const_AppUserManual_ModeArea_MenuBtn )
                            appUserManual.launchMenu()
                        else {
                            console.log("Modearea.qml :: onSignalJogNavigation - JOG_CENTER bRRC : " , bRRC)
                            appUserManual.handleBackKey( false , false , !bRRC )
                        }
//                        if ( appUserManual.state == "pdfScreenView" ) appUserManual.startTimer()
                    }
                    else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        jogPressed = false
                    }
                }
                break;
                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    console.log("Modearea.qml :: onSignalJogNavigation - JOG_WHEEL_LEFT")
                    if ( appUserManual.gotoPageBox || appUserManual.lockoutMode ) return;
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED ) {
                        if ( langId == 20 ) {
                            if ( focus_index < 1 )
                                focus_index++
                        }
                        else {
                            if ( focus_index > 0)
                                focus_index--
                        }
                    }
                }
                break;
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    console.log("Modearea.qml :: onSignalJogNavigation - JOG_WHEEL_RIGHT")
                    if ( appUserManual.gotoPageBox || appUserManual.lockoutMode ) return;
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED ) {
                        if ( langId == 20 ) {
                            if ( focus_index > 0)
                                focus_index--
                        }
                        else {
                            if ( focus_index < 1 )
                                focus_index++
                        }
                    }
                }
                break;
                case UIListenerEnum.JOG_DOWN:
                {
                    console.log("Modearea.qml :: onSignalJogNavigation - JOG_DOWN")
                    if ( appUserManual.lockoutMode ) return;
                    if ( status != UIListenerEnum.KEY_STATUS_PRESSED ) return
                    lostFocus()
                }
                break;
            }
        }
    }
}
