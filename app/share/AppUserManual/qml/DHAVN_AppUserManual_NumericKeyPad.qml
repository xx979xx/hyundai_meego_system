import Qt 4.7

import "DHAVN_AppUserManual_Images.js" as Images
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item
{
    id: numKeyPad
    width: Dimensions.const_AppUserManual_MainScreenWidth
    height: Dimensions.const_AppUserManual_NumericKeyPad_Height

    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property int keypadFocusIndex: 0
    property bool focus_visible: false
    property bool jog_pressed: false
    property bool up1MAPress: false
    property bool up1MAExit: false
    property bool up2MAPress: false
    property bool up2MAExit: false
    property bool up3MAPress: false
    property bool up3MAExit: false
    property bool up4MAPress: false
    property bool up4MAExit: false
    property bool up5MAPress: false
    property bool up5MAExit: false
    property bool up6MAPress: false
    property bool up6MAExit: false
    property bool down6MAPress: false
    property bool down6MAExit: false
    property bool down7MAPress: false
    property bool down7MAExit: false
    property bool down8MAPress: false
    property bool down8MAExit: false
    property bool down9MAPress: false
    property bool down9MAExit: false
    property bool down0MAPress: false
    property bool down0MAExit: false
    property bool delMAPress: false
    property bool delMAExit: false
    property string textNumDel: qsTranslate("main", "STR_MANUAL_NUM_DEL")
    property string textNumOK: qsTranslate("main", "STR_MANUAL_NUM_GO")
    property string inputText: ""

    signal displayText( string text )
    signal gotoPage()
    signal deletePageNumber()

    function centerCanceled()
    {
        console.log("NumericKeyPad.qml :: centerCanceled()")
        jog_pressed = false
    }

    function setFG()
    {
        console.log("NumericKeyPad.qml :: setFG()")
        jog_pressed= false
        up1MAPress= false
        up1MAExit= false
        up2MAPress= false
        up2MAExit= false
        up3MAPress= false
        up3MAExit= false
        up4MAPress= false
        up4MAExit= false
        up5MAPress= false
        up5MAExit= false
        up6MAPress= false
        up6MAExit= false
        down6MAPress= false
        down6MAExit= false
        down7MAPress= false
        down7MAExit= false
        down8MAPress= false
        down8MAExit= false
        down9MAPress= false
        down9MAExit= false
        down0MAPress= false
        down0MAExit= false
        delMAPress= false
        delMAExit= false
    }

    function setKeyboardFocus( visible )
    {
        console.log("NumericKeyPad.qml :: setKeyboardFocus()")
        if ( visible ) {
            focus_visible = true
            if ( appUserManual.langId == 20 ) keypadFocusIndex = 2
            else keypadFocusIndex = 1
        }
        else {
            focus_visible = false
            keypadFocusIndex = -1
        }
//        keypadFocusIndex = 0
    }

    function incrementFocus( jog )
    {
        if ( pagePopUp.visible ) return;
        console.log("NumericKeyPad.qml :: incrementFocus() jog : ",  jog)
        switch ( jog )
        {
            case Dimensions.JOG_WHEEL_RIGHT:
            case Dimensions.JOG_RIGHT: {
                console.log("NumericKeyPad.qml :: incrementFocus() JOG_RIGHT ")
                if ( appUserManual.pageNumberEntered.length == 0 ) {
                    if (  appUserManual.langId == 20 ) {
                        if ( keypadFocusIndex == 11 ) keypadFocusIndex = 2
                        else if ( keypadFocusIndex == 6 ) keypadFocusIndex = 8
                        else ++keypadFocusIndex
                    }
                    else {
                        if ( keypadFocusIndex == 5 ) keypadFocusIndex = 7
                        else if ( keypadFocusIndex == 10 ) keypadFocusIndex = 1
                        else ++keypadFocusIndex
                    }
                }
                else {
                    if ( keypadFocusIndex == 12 ) keypadFocusIndex = 1
                    else ++keypadFocusIndex
                }
            }
            break;
            case Dimensions.JOG_DOWN: {
                console.log("NumericKeyPad.qml :: incrementFocus() JOG_DOWN ")
                if ( !focus_visible ) {
                    focus_visible = true
                    if ( keypadFocusIndex < 1 ) {
                        langId == 20 ? keypadFocusIndex = 2 : keypadFocusIndex = 1
                    }
                    return
                }
                if( keypadFocusIndex < 7 ) {
                    if ( appUserManual.pageNumberEntered.length == 0 && appUserManual.langId != 20 ) {
                        if ( keypadFocusIndex == 5 ) return;
                        else keypadFocusIndex += 6
                    }
                    else if ( appUserManual.pageNumberEntered.length == 0 && appUserManual.langId == 20 ) {
                        if ( keypadFocusIndex == 6 ) return;
                        else keypadFocusIndex += 6
                    }
                    else keypadFocusIndex += 6
                }
            }
                break;
            case Dimensions.JOG_BOTTOM_RIGHT: {
                console.log("NumericKeyPad.qml :: incrementFocus() JOG_BOTTOM_RIGHT ")
                if ( appUserManual.pageNumberEntered.length == 0 && appUserManual.langId != 20 ) {
                    if ( keypadFocusIndex < 4 ) keypadFocusIndex += 7
                }
                else {
                    if( keypadFocusIndex < 6 ) keypadFocusIndex += 7
                }
            }
                break;
            case Dimensions.JOG_BOTTOM_LEFT: {
                console.log("NumericKeyPad.qml :: incrementFocus() JOG_BOTTOM_LEFT ")
                if ( appUserManual.pageNumberEntered.length == 0 && appUserManual.langId == 20 ) {
                    if ( keypadFocusIndex > 3 && keypadFocusIndex < 7 ) keypadFocusIndex += 5
                }
                else {
                    if( keypadFocusIndex > 1 && keypadFocusIndex <= 6 )
                        keypadFocusIndex += 5
                }
            }
                break;
        }
    }

    function decrementFocus( jog )
    {
        if ( pagePopUp.visible ) return;
        console.log("NumericKeyPad.qml :: decrementFocus() jog : ",  jog)
        switch ( jog )
        {
            case Dimensions.JOG_WHEEL_LEFT:
            case Dimensions.JOG_LEFT: {
                console.log("NumericKeyPad.qml :: decrementFocus() JOG_LEFT ")
                if ( appUserManual.pageNumberEntered.length == 0 ) {
                    if (  appUserManual.langId == 20 ) {
                        if ( keypadFocusIndex == 2 ) keypadFocusIndex = 11
                        else if ( keypadFocusIndex == 8 ) keypadFocusIndex = 6
                        else --keypadFocusIndex
                    }
                    else {
                        if ( keypadFocusIndex == 1 ) keypadFocusIndex = 10
                        else if ( keypadFocusIndex == 7 ) keypadFocusIndex = 5
                        else  --keypadFocusIndex
                    }
                }
                else {
                    if( keypadFocusIndex == 1) keypadFocusIndex = 12
                    else --keypadFocusIndex
                }
            }
            break;
            case Dimensions.JOG_UP: {
                console.log("NumericKeyPad.qml :: decrementFocus() JOG_UP ")
                if( keypadFocusIndex > 6 )
                    keypadFocusIndex -= 6
                else {
                    focus_visible = false
                    keypadFocusIndex = 0
                    return true
                }
            }
                break;
            case Dimensions.JOG_TOP_RIGHT: {
                console.log("NumericKeyPad.qml :: decrementFocus() JOG_UP_RIGHT ")
                if ( appUserManual.pageNumberEntered.length == 0 && appUserManual.langId != 20 ) {
                    if ( keypadFocusIndex > 6 && keypadFocusIndex < 11 ) keypadFocusIndex -= 5
                }
                else {
                    if( keypadFocusIndex > 6 && keypadFocusIndex < 12 )
                        keypadFocusIndex -= 5
                }
            }
                break;
            case Dimensions.JOG_TOP_LEFT: {
                console.log("NumericKeyPad.qml :: decrementFocus() JOG_UP_LEFT ")
                if ( appUserManual.pageNumberEntered.length == 0 && appUserManual.langId == 20 ) {
                    if ( keypadFocusIndex > 8 ) keypadFocusIndex -= 7
                }
                else {
                    if( keypadFocusIndex > 7 )
                        keypadFocusIndex -= 7
                }
            }
                break;
        }
        return false
    }

    function updateTextBox( pressed )
    {
        console.log("NumericKeyPad.qml :: updateTextBox()")
        if ( pressed ) {
            jog_pressed = true
            return;
        }
        jog_pressed = false
        if( appUserManual.langId == 20 )
//        if( appUserManual.countryVariant == 4 )
        {
            switch ( keypadFocusIndex )
            {
                case 1:
                if ( appUserManual.pageNumberEntered.length != 0 ) numKeyPad.gotoPage()
                break;
                case 2:
                numKeyPad.displayText(1)
                break;
                case 3:
                numKeyPad.displayText(2)
                break;
                case 4:
                numKeyPad.displayText(3)
                break;
                case 5:
                numKeyPad.displayText(4)
                break;
                case 6:
                numKeyPad.displayText(5)
                break;
                case 7:
                if ( appUserManual.pageNumberEntered.length != 0 ) {
                    numKeyPad.deletePageNumber()
                    if ( appUserManual.pageNumberEntered.length == 0 )  keypadFocusIndex = 2
                }
                break;
                case 8:
                numKeyPad.displayText(6)
                break;
                case 9:
                numKeyPad.displayText(7)
                break;
                case 10:
                numKeyPad.displayText(8)
                break;
                case 11:
                numKeyPad.displayText(9)
                break;
                case 12:
                numKeyPad.displayText(0)
                break;
            }
        }
        else
        {
            if( keypadFocusIndex == 6 )
            {
                if ( appUserManual.pageNumberEntered.length != 0 ) numKeyPad.gotoPage()
            }
            else if( keypadFocusIndex == 12 )
            {
                if ( appUserManual.pageNumberEntered.length != 0 ) {
                    numKeyPad.deletePageNumber()
                    if ( appUserManual.pageNumberEntered.length == 0 )  keypadFocusIndex = 1
                }
            }
            else if( keypadFocusIndex == 11 )
            {
                numKeyPad.displayText( 0 )
            }
            else if( keypadFocusIndex > 5)
            {
                numKeyPad.displayText( keypadFocusIndex -1)
            }
            else
            {
                numKeyPad.displayText( keypadFocusIndex )
            }
        }
    }

    Rectangle {
        id: rect_up1
        anchors.left: parent.left; anchors.top: parent.top
        width: 213; height: 78
        color: "transparent"
        Image {
            id: img_up1
            source: keypadFocusIndex == 1 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_f.png"
                    : "/app/share/images/AppUserManual/btn_direct_n.png"
            visible: appUserManual.langId != 20
        }
        Image {
            source: keypadFocusIndex == 1 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_ok_f.png"
                : appUserManual.pageNumberEntered.length == 0 ?  "/app/share/images/AppUserManual/btn_direct_ok_d.png" :  "/app/share/images/AppUserManual/btn_direct_ok_n.png"
            visible: appUserManual.langId == 20
        }
        Image {
            source: appUserManual.langId == 20 ? "/app/share/images/AppUserManual/btn_direct_ok_p.png" : "/app/share/images/AppUserManual/btn_direct_p.png"
            visible: (up1MAPress && !up1MAExit ) && ( (txt_up1.text == textNumOK && appUserManual.pageNumberEntered.length != 0) || txt_up1.text != textNumOK )
                    || ( jog_pressed && keypadFocusIndex == 1 )
        }
        MouseArea {
            id: up1MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            beepEnabled: appUserManual.langId != 20 || appUserManual.pageNumberEntered.length != 0
            anchors.fill: parent
//            enabled: txt_up1.text != textNumOK || appUserManual.pageNumberEntered.length != 0
            onClicked: {
                if ( txt_up1.text == textNumOK && appUserManual.pageNumberEntered.length == 0 )  {
                    return
                }
                txt_up1.text == textNumOK ? numKeyPad.gotoPage() : numKeyPad.displayText( txt_up1.text )

                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                keypadFocusIndex = 1
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: up1MA onPressed")
                up1MAPress = true
                up1MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: up1MA onReleased")
                up1MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: up1MA onExited")
                up1MAExit = true
            }
        }
        Text {
            id: txt_up1
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? textNumOK : "1"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: appUserManual.langId == 20 ? 36 : Dimensions.const_AppUserManual_Font_Size_46
            color: appUserManual.langId == 20 && appUserManual.pageNumberEntered.length == 0 ? Dimensions.const_AppUserManual_ListText_Color_DisableGrey
                    : Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_up2
        anchors.left: rect_up1.right; anchors.top: parent.top
        width: 213; height: 78
        color: "transparent"
        Image {
            source: keypadFocusIndex == 2 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_f.png" : "/app/share/images/AppUserManual/btn_direct_n.png"
        }
        Image {
            source: "/app/share/images/AppUserManual/btn_direct_p.png"
            visible: (up2MAPress && !up2MAExit ) || ( jog_pressed && keypadFocusIndex == 2 )
        }
        MouseArea {
            id: up2MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            anchors.fill: parent
            onClicked: {
                numKeyPad.displayText( text_up2.text )
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                keypadFocusIndex = 2
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: up2MA onPressed")
                up2MAPress = true
                up2MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: up2MA onReleased")
                up2MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: up2MA onExited")
                up2MAExit = true
            }
        }
        Text {
            id: text_up2
            anchors.centerIn: parent
            text:  appUserManual.langId == 20 ?  "1" :  "2"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: Dimensions.const_AppUserManual_Font_Size_46
            color: Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_up3
        anchors.left: rect_up2.right; anchors.top: parent.top
        width: 213; height: 78
        color: "transparent"
        Image {
            source: keypadFocusIndex == 3 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_f.png" : "/app/share/images/AppUserManual/btn_direct_n.png"
        }
        Image {
            source: "/app/share/images/AppUserManual/btn_direct_p.png"
            visible: (up3MAPress && !up3MAExit )  || ( jog_pressed && keypadFocusIndex == 3 )
        }
        MouseArea {
            id: up3MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            anchors.fill: parent
            onClicked: {
                numKeyPad.displayText( text_up3.text )
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                keypadFocusIndex = 3
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: up3MA onPressed")
                up3MAPress = true
                up3MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: up3MA onReleased")
                up3MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: up3MA onExited")
                up3MAExit = true
            }
        }
        Text {
            id: text_up3
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? "2" :  "3"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: Dimensions.const_AppUserManual_Font_Size_46
            color: Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_up4
        anchors.left: rect_up3.right; anchors.top: parent.top
        width: 213; height: 78
        color: "transparent"
        Image {
            source: keypadFocusIndex == 4 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_f.png" : "/app/share/images/AppUserManual/btn_direct_n.png"
        }
        Image {
            source: "/app/share/images/AppUserManual/btn_direct_p.png"
            visible: (up4MAPress && !up4MAExit ) || ( jog_pressed && keypadFocusIndex == 4)
        }
        MouseArea {
            id: up4MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            anchors.fill: parent
            onClicked: {
                numKeyPad.displayText( text_up4.text )
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                keypadFocusIndex = 4
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: up4MA onPressed")
                up4MAPress = true
                up4MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: up4MA onReleased")
                up4MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: up4MA onExited")
                up4MAExit = true
            }
        }
        Text {
            id: text_up4
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? "3" :  "4"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: Dimensions.const_AppUserManual_Font_Size_46
            color: Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_up5
        anchors.left: rect_up4.right; anchors.top: parent.top
        width: 213; height: 78
        color: "transparent"
        Image {
            source: keypadFocusIndex == 5 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_f.png" : "/app/share/images/AppUserManual/btn_direct_n.png"
        }
        Image {
            source: "/app/share/images/AppUserManual/btn_direct_p.png"
            visible: (up5MAPress && !up5MAExit ) || ( jog_pressed && keypadFocusIndex == 5 )
        }
        MouseArea {
            id: up5MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            anchors.fill: parent
            onClicked: {
                numKeyPad.displayText( text_up5.text )
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                keypadFocusIndex = 5
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: up5MA onPressed")
                up5MAPress = true
                up5MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: up5MA onReleased")
                up5MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: up5MA onExited")
                up5MAExit = true
            }
        }
        Text {
            id: text_up5
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? "4" :  "5"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: Dimensions.const_AppUserManual_Font_Size_46
            color: Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_ok
        anchors.left: rect_up5.right; anchors.top: parent.top
        width: 213; height: 78
        color: "transparent"
        Image {
            source: keypadFocusIndex == 6 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_ok_f.png"
                : appUserManual.pageNumberEntered.length == 0 ?  "/app/share/images/AppUserManual/btn_direct_ok_d.png" :  "/app/share/images/AppUserManual/btn_direct_ok_n.png"
            visible: appUserManual.langId != 20
        }
        Image {
            source: keypadFocusIndex == 6 && !systemPopupVisible && focus_visible  ? "/app/share/images/AppUserManual/btn_direct_f.png" : "/app/share/images/AppUserManual/btn_direct_n.png"
            visible: appUserManual.langId == 20
        }
        Image {
            source: appUserManual.langId == 20 ? "/app/share/images/AppUserManual/btn_direct_p.png" : "/app/share/images/AppUserManual/btn_direct_ok_p.png"
            visible: (up6MAPress && !up6MAExit ) && (  text_up6.text != textNumOK || appUserManual.pageNumberEntered.length != 0 ) || ( jog_pressed && keypadFocusIndex == 6 )
        }
        MouseArea {
            id: up6MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            beepEnabled: appUserManual.langId == 20 || appUserManual.pageNumberEntered.length != 0
            anchors.fill: parent
//            enabled: text_up6.text != textNumOK || appUserManual.pageNumberEntered.length != 0
            onClicked: {
                if ( text_up6.text == textNumOK && appUserManual.pageNumberEntered.length == 0 ) {
                    return
                }
                text_up6.text == textNumOK ? numKeyPad.gotoPage() :  numKeyPad.displayText( text_up6.text )
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                keypadFocusIndex = 6
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: up6MA onPressed")
                up6MAPress = true
                up6MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: up6MA onReleased")
                up6MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: up6MA onExited")
                up6MAExit = true
            }
        }
        Text {
            id: text_up6
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? "5" : textNumOK // "OK"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: appUserManual.langId == 20 ? Dimensions.const_AppUserManual_Font_Size_46 : 36
            color: appUserManual.langId != 20 && appUserManual.pageNumberEntered.length == 0 ? Dimensions.const_AppUserManual_ListText_Color_DisableGrey
                    : Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_down6
        anchors.left: parent.left; anchors.top: parent.top; anchors.topMargin: 78
        width: 213; height: 78
        color: "transparent"
        Image {
            id: img_down6
            source: keypadFocusIndex == 7 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_f.png" : "/app/share/images/AppUserManual/btn_direct_n.png"
            visible: appUserManual.langId != 20
        }
        Image {
            id: img_del
            source: keypadFocusIndex == 7 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_del_f.png"
                : appUserManual.pageNumberEntered.length == 0 ? "/app/share/images/AppUserManual/btn_direct_del_d.png" : "/app/share/images/AppUserManual/btn_direct_del_n.png"
            visible: appUserManual.langId == 20
        }
        Image {
            source: appUserManual.langId == 20 ?  "/app/share/images/AppUserManual/btn_direct_del_p.png" :  "/app/share/images/AppUserManual/btn_direct_p.png"
            visible: (down6MAPress && !down6MAExit ) && ( txt_down6.text != textNumDel || appUserManual.pageNumberEntered.length != 0 )  || ( jog_pressed && keypadFocusIndex == 7 )
        }
        MouseArea {
            id: down6MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            beepEnabled: appUserManual.langId != 20 || appUserManual.pageNumberEntered.length != 0
            anchors.fill: parent
//            enabled: txt_down6.text != textNumDel || appUserManual.pageNumberEntered.length != 0
            onClicked: {
                if ( txt_down6.text == textNumDel && appUserManual.pageNumberEntered.length == 0 ) {
                    return;
                }
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                if ( txt_down6.text == textNumDel ) {
                    numKeyPad.deletePageNumber()
                    if ( appUserManual.pageNumberEntered.length == 0 ) {
                        keypadFocusIndex =  2
                        EngineListener.playAudioBeep()
                    }
                    else keypadFocusIndex = 7
                }
                else {
                    numKeyPad.displayText(txt_down6.text)
                    keypadFocusIndex = 7
                }
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: down6MA onPressed")
                down6MAPress = true
                down6MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: down6MA onReleased")
                down6MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: down6MA onExited")
                down6MAExit = true
            }
        }
        Text {
            id: txt_down6
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? textNumDel :  "6"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: appUserManual.langId == 20 ? 36 : Dimensions.const_AppUserManual_Font_Size_46
            color:  appUserManual.langId == 20 && appUserManual.pageNumberEntered.length == 0 ? Dimensions.const_AppUserManual_ListText_Color_DisableGrey : Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_down7
        anchors.left: rect_down6.right; anchors.top: parent.top; anchors.topMargin: 78
        width: 213; height: 78
        color: "transparent"
        Image {
            id: img_down7
            source: keypadFocusIndex == 8 && !systemPopupVisible && focus_visible  ? "/app/share/images/AppUserManual/btn_direct_f.png" : "/app/share/images/AppUserManual/btn_direct_n.png"
        }
        Image {
            source: "/app/share/images/AppUserManual/btn_direct_p.png"
            visible: (down7MAPress && !down7MAExit ) || ( jog_pressed && keypadFocusIndex == 8 )
        }
        MouseArea {
            id: down7MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            anchors.fill: parent
            onClicked: {
                numKeyPad.displayText(txt_down7.text)
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                keypadFocusIndex = 8
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: down7MA onPressed")
                down7MAPress = true
                down7MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: down7MA onReleased")
                down7MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: down7MA onExited")
                down7MAExit = true
            }
        }
        Text {
            id: txt_down7
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? "6" :  "7"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: Dimensions.const_AppUserManual_Font_Size_46
            color: Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_down8
        anchors.left: rect_down7.right; anchors.top: parent.top; anchors.topMargin: 78
        width: 213; height: 78
        color: "transparent"
        Image {
            id: img_down8
            source: keypadFocusIndex == 9 && !systemPopupVisible && focus_visible  ? "/app/share/images/AppUserManual/btn_direct_f.png" : "/app/share/images/AppUserManual/btn_direct_n.png"
        }
        Image {
            source: "/app/share/images/AppUserManual/btn_direct_p.png"
            visible:  (down8MAPress && !down8MAExit )  || ( jog_pressed && keypadFocusIndex == 9 )
        }
        MouseArea {
            id: down8MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            anchors.fill: parent
            onClicked: {
                numKeyPad.displayText(txt_down8.text)
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                keypadFocusIndex = 9
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: down8MA onPressed")
                down8MAPress = true
                down8MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: down8MA onReleased")
                down8MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: down8MA onExited")
                down8MAExit = true
            }
        }
        Text {
            id: txt_down8
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? "7" :  "8"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: Dimensions.const_AppUserManual_Font_Size_46
            color: Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_down9
        anchors.left: rect_down8.right; anchors.top: parent.top; anchors.topMargin: 78
        width: 213; height: 78
        color: "transparent"
        Image {
            id: img_down9
            source: keypadFocusIndex == 10 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_f.png" : "/app/share/images/AppUserManual/btn_direct_n.png"
        }
        Image {
            source: "/app/share/images/AppUserManual/btn_direct_p.png"
            visible: (down9MAPress && !down9MAExit ) || ( jog_pressed && keypadFocusIndex == 10 )
        }
        MouseArea {
            id: down9MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            anchors.fill: parent
            onClicked: {
                numKeyPad.displayText(txt_down9.text)
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                keypadFocusIndex = 10
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: down9MA onPressed")
                down9MAPress = true
                down9MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: down9MA onReleased")
                down9MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: down9MA onExited")
                down9MAExit = true
            }
        }
        Text {
            id: txt_down9
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? "8" : "9"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: Dimensions.const_AppUserManual_Font_Size_46
            color: Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_down0
        anchors.left: rect_down9.right; anchors.top: parent.top; anchors.topMargin: 78
        width: 213; height: 78
        color: "transparent"
        Image {
            id: img_down0
            source: keypadFocusIndex == 11 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_f.png"
                : appUserManual.langId != 20 && appUserManual.pageNumberEntered.length == 0 ?  "/app/share/images/AppUserManual/btn_direct_d.png"
                : "/app/share/images/AppUserManual/btn_direct_n.png"
        }
        Image {
            source: "/app/share/images/AppUserManual/btn_direct_p.png"
            visible: (down0MAPress && !down0MAExit ) || ( jog_pressed && keypadFocusIndex == 11 )
        }
        MouseArea {
            id: down0MA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            beepEnabled: appUserManual.langId == 20 || appUserManual.pageNumberEntered.length != 0
            anchors.fill: parent
            onClicked: {
                if ( appUserManual.langId != 20 && appUserManual.pageNumberEntered.length == 0 ) return;
                numKeyPad.displayText(txt_down0.text)
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
//                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                keypadFocusIndex = 11
            }
            onPressed: {
                console.log("NumericKeyPad.qml :: down0MA onPressed")
                if ( appUserManual.langId != 20 && appUserManual.pageNumberEntered.length == 0 ) return;
                down0MAPress = true
                down0MAExit = false
            }
            onReleased: {
                console.log("NumericKeyPad.qml :: down0MA onReleased")
                if ( appUserManual.langId != 20 && appUserManual.pageNumberEntered.length == 0 ) return;
                down0MAPress = false
            }
            onExited: {
                console.log("NumericKeyPad.qml :: down0MA onExited")
                if ( appUserManual.langId != 20 && appUserManual.pageNumberEntered.length == 0 ) return;
                down0MAExit = true
            }
        }
        Text {
            id: txt_down0
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? "9" : "0"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize: Dimensions.const_AppUserManual_Font_Size_46
            color: appUserManual.langId != 20 && appUserManual.pageNumberEntered.length == 0 ? Dimensions.const_AppUserManual_ListText_Color_DisableGrey
                : Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }
    Rectangle {
        id: rect_del
        anchors.left: rect_down0.right; anchors.top: parent.top; anchors.topMargin: 78
        width: 213; height: 78
        color: "transparent"
        Image {
            source: keypadFocusIndex == 12 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_del_f.png" :
                appUserManual.pageNumberEntered.length == 0 ? "/app/share/images/AppUserManual/btn_direct_del_d.png" : "/app/share/images/AppUserManual/btn_direct_del_n.png"
            visible: appUserManual.langId != 20
        }
        Image {
            source: keypadFocusIndex == 12 && !systemPopupVisible && focus_visible ? "/app/share/images/AppUserManual/btn_direct_f.png"
                : appUserManual.pageNumberEntered.length == 0 ?  "/app/share/images/AppUserManual/btn_direct_d.png"
                :  "/app/share/images/AppUserManual/btn_direct_n.png"
            visible: appUserManual.langId == 20
        }
        Image {
            source: appUserManual.langId == 20 ? "/app/share/images/AppUserManual/btn_direct_p.png" : "/app/share/images/AppUserManual/btn_direct_del_p.png"
            visible:  (delMAPress && !delMAExit ) && ( txt_del.text != textNumDel || appUserManual.pageNumberEntered.length != 0 ) || ( jog_pressed && keypadFocusIndex == 12 )
        }
        MouseArea {
            id: delMA
            enabled: !appUserManual.lockoutMode && !appUserManual.touchLock
            anchors.fill: parent
            beepEnabled: appUserManual.pageNumberEntered.length != 0
            onClicked: {
                if ( appUserManual.pageNumberEntered.length == 0 ) return;
//                if ( txt_del.text == textNumDel && appUserManual.pageNumberEntered.length == 0 ) {
//                    return;
//                }
                if ( appUserManual.focusIndex != Dimensions.const_AppUserManual_PDF_Screen_FocusIndex ) {
                    console.log("NumericKeyPad.qml :: set PDF Scren FocusIndex ")
                    appUserManual.focusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
                //                    appUserManualPdfScreen.setFocus(false)
                    modeAreaWidget.lostFocus()
                }
                if ( txt_del.text == textNumDel ) {
                    numKeyPad.deletePageNumber()
                    if ( appUserManual.pageNumberEntered.length == 0 ) {
                        keypadFocusIndex = 1
                        EngineListener.playAudioBeep()
                    }
                    else keypadFocusIndex = 12
                }
                else {
                    numKeyPad.displayText(txt_del.text)
                    keypadFocusIndex = 12
                }
            }
            onPressed: {
                if ( appUserManual.langId == 20 && appUserManual.pageNumberEntered.length == 0 ) return;
                console.log("NumericKeyPad.qml :: delMA onPressed")
                delMAPress = true
                delMAExit = false
            }
            onReleased: {
//                if ( appUserManual.langId != 20 && appUserManual.pageNumberEntered.length == 0 ) return;
                console.log("NumericKeyPad.qml :: delMA onReleased")
                delMAPress = false
            }
            onExited: {
//                if ( appUserManual.langId != 20 && appUserManual.pageNumberEntered.length == 0 ) return;
                console.log("NumericKeyPad.qml :: delMA onExited")
                delMAExit = true
            }
        }
        Text {
            id: txt_del
            anchors.centerIn: parent
            text: appUserManual.langId == 20 ? "0" :  textNumDel // "Delete" //"STR_MANUAL_NUM_DEL"
            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pixelSize:  appUserManual.langId == 20 ? Dimensions.const_AppUserManual_Font_Size_46 : 36
            color: appUserManual.pageNumberEntered.length == 0 ? Dimensions.const_AppUserManual_ListText_Color_DisableGrey : Dimensions.const_AppUserManual_ListText_Color_BrightGrey
        }
    }

    function retranslateUI()
    {
        textNumDel= qsTranslate("main", "STR_MANUAL_NUM_DEL")
        textNumOK = qsTranslate("main", "STR_MANUAL_NUM_GO")
        console.log("Numeric.qml :: textNumDel : ", textNumDel)
        console.log("Numeric.qml :: textNumOK : ", textNumOK)
    }

    Connections
    {
        target: EngineListener

        onRetranslateUi:
        {
            console.log("NumericKeyPad.qml :: RetranslateUi Called.")
            retranslateUI()
            if ( countryVariant == 0 && lang != 2 )     {       // 내수, 한글이 아닐 경우
                focus_visible = false
                keypadFocusIndex = -1
            }
            else {
                focus_visible = true
                keypadFocusIndex = 1
            }
        }
    }
}
