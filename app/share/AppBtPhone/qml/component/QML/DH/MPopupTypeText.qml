/**
 * /QML/DH/MPopupTypeText.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MPopup
{
    id: idPopupTextContainer
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property string popupBgImage: (popupBtnCnt < 3) ? ImagePath.imgFolderPopup + "bg_type_a.png" :  ImagePath.imgFolderPopup + "bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: (popupBtnCnt < 3) ? 208 - systemInfo.statusBarHeight : 171 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: (popupBtnCnt < 3) ? 304 : 379

    property bool black_opacity: true

    property int popupTextSpacing: 44
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""
    property string popupThirdBtnText: ""

    property int popupBtnCnt: 2     //# 1 or 2 or 3 or 4
    property int popupLineCnt: 2    //# 1 or 2 or 3 or 4

    property bool clickCheck: false
    property alias popupLineHeight: idText1.lineHeight
    property alias popupBtnLineHeight: idButton1.firstTextLineHeight

    property bool button1Enable : true
    property bool button2Enable : true
    property bool button3Enable : true

    property int popupTextfontSize: idText1.font.pointSize

    //[ITS 0271897 - 핸즈프리 팝업 중, R단 > P단 전환시 팝업 포커스 위치 다름]
    property int buttonFocusPos : 1
    property bool chageBtnFocus : false

    // SIGNALS
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal popupThirdBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idPopupTextContainer.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    Connections {
        target: idAppMain

        /* [자체 이슈]
         * 20자 초과 팝업 시 BT 내부 팝업이 뜬 경우, 다시 20자 초과 팝업 출력 후 BG >> FG 되면 포커스 사라짐 문제
         */
        onPopupTextFocusSet: {
            if(true == idPopupTextContainer.visible) {
                idButton1.forceActiveFocus();
                popupBackGroundBlack = black_opacity
            }
        }

        onSetButtonFocus: {
            idButton1.forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if(true == idPopupTextContainer.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onPopupBtnCntChanged: {
        buttonFocusPos = 1;//[ITS 0271897]
        idButton1.forceActiveFocus();
    }

    //[ITS 0271897]
    onChageBtnFocusChanged: {
        idButton2.forceActiveFocus();
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }


    /* Widgets */
    Rectangle {
        width: parent.width
        height: parent.height

        color: colorInfo.black
        opacity: (true == black_opacity) ? 0.6 : 1
    }

    Image {
        source: popupBgImage
        x: 93
        y: popupBgImageY
        width: popupBgImageWidth
        height: popupBgImageHeight
        focus: true

        MButton {
            id: idButton1
            x: 780
            y: 18
            width: 295
            height: popupBtnCnt == 1 ? 268 : popupBtnCnt == 2 ? 134 : 116
            focus: true

            bgImageZ: 1
            bgImage:        popupBtnCnt == 1 ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png" : popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_04_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_04_n.png"
            bgImagePress:   popupBtnCnt == 1 ? ImagePath.imgFolderPopup + "btn_type_a_01_p.png" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_02_p.png" : ImagePath.imgFolderPopup + "btn_type_b_04_p.png"
            bgImageFocus:   popupBtnCnt == 1 ? ImagePath.imgFolderPopup + "btn_type_a_01_f.png" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_02_f.png" : ImagePath.imgFolderPopup + "btn_type_b_04_f.png"

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       popupBtnCnt == 1 ? -2 : popupBtnCnt == 2 ? -7 : -14
            fgImageY:       popupBtnCnt == 1 ? 99 : popupBtnCnt == 2 ? 32 : 26
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton1.activeFocus

            firstText: popupFirstBtnText
            firstTextX: 51
            firstTextY: popupBtnCnt == 1 ? 116 : popupBtnCnt == 2 ? 49 : 41
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextElide: ""
            firstTextWrap: "Text.WordWrap"

            mEnabled: button1Enable

            onClickOrKeySelected: {
                idButton1.forceActiveFocus();
                popupFirstBtnClicked();
            }

            onWheelRightKeyPressed: {
                if(1 == popupBtnCnt) {
                    idButton1.forceActiveFocus();
                } else {
                    idButton2.forceActiveFocus();
                }
            }
        }

        MButton {
            id: idButton2
            x: 780
            y: popupBtnCnt == 2 ? 152 : 134
            width: 295
            height: popupBtnCnt == 2 ? 134 : 110
            visible: popupBtnCnt > 1

            bgImageZ: 1
            bgImage:        popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_03_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_05_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_05_n.png"
            bgImagePress:   popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_03_p.png" : ImagePath.imgFolderPopup + "btn_type_b_05_p.png"
            bgImageFocus:   popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_03_f.png" : ImagePath.imgFolderPopup + "btn_type_b_05_f.png"

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       popupBtnCnt == 2 ? -7 : -2
            fgImageY:       popupBtnCnt == 2 ? 32 : 26
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton2.activeFocus

            firstText: popupSecondBtnText
            firstTextX: 832 - 780
            firstTextY: popupBtnCnt == 2 ? 49 : 41
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextElide: ""
            firstTextWrap: "Text.WordWrap"

            mEnabled: button2Enable

            onClickOrKeySelected: {
                idButton2.forceActiveFocus();
                popupSecondBtnClicked();
            }

            onWheelLeftKeyPressed: idButton1.forceActiveFocus();
            onWheelRightKeyPressed: {
                if(true == idButton3.visible && true == button3Enable) {
                    idButton3.forceActiveFocus();
                } else {
                    idButton2.forceActiveFocus();
                }
            }
        }

        MButton {
            id: idButton3
            x: 780
            y: 244
            width: 295
            height: 117
            visible: popupBtnCnt > 2

            bgImageZ: 1
            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_06_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_06_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_b_06_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_b_06_f.png"

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       -14
            fgImageY:       26
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton3.activeFocus

            firstText: popupThirdBtnText
            firstTextX: 832 - 780
            firstTextY: 41
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextElide: ""
            firstTextWrap: "Text.WordWrap"

            mEnabled: button3Enable

            onMEnabledChanged: {
                if(false == idButton3.mEnabled) {
                    if(true == idButton3.activeFocus) {
                        idButton2.forceActiveFocus();
                    }
                }
            }

            onClickOrKeySelected: {
                idButton3.forceActiveFocus();
                popupThirdBtnClicked();
            }

            onWheelLeftKeyPressed: idButton2.focus = true
        }

        Text {
            id: idText1
            text: popupFirstText
            x: 78
            y: popupLineCnt == 1 ? 152 - 18 : popupLineCnt == 2 ? 130 : popupLineCnt == 3 ? 108 : 173
            width: ("popup_search_while_driving" == popupState)? 654:677 //654 가이드 상의 넓이 임의의 넓이 677
            height: (22 == gLanguage) ? 30 : 32
            font.pointSize: (22 == gLanguage) ? 30 : ((2 == gLanguage) && ("popup_Bt_PBAP_Not_Support" == popupState))? 34 : 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            wrapMode: Text.WordWrap
        }

        Text {
            id: idText2
            text: popupSecondText
            x: 78
            y: popupLineCnt == 2 ? 130 + popupTextSpacing : popupLineCnt == 3 ? 108 + popupTextSpacing : 86 + popupTextSpacing
            width: 677 //654 가이드 상의 넓이 임의의 넓이 677
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            visible: popupLineCnt > 1
            wrapMode: Text.WordWrap
        }

        Text {
            id: idText3
            text: popupThirdText
            x: 78
            y: popupLineCnt == 3 ? 108 + popupTextSpacing + popupTextSpacing : 86 + popupTextSpacing + popupTextSpacing
            width: 677 //654 가이드 상의 넓이 임의의 넓이 677
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            visible: popupLineCnt > 2
            wrapMode: Text.WordWrap
        }
    }
}
/* EOF */
