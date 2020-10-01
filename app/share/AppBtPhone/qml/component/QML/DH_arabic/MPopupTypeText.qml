/**
 * /QML/DH_arabic/MPopupTypeText.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


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

        onPopupTextFocusSet: {
            if(true == idPopupTextContainer.visible) {
                idButton1.forceActiveFocus();
                popupBackGroundBlack = black_opacity
            }
        }
    }

    onVisibleChanged: {
        if(true == idPopupTextContainer.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onPopupBtnCntChanged: {
        idButton1.forceActiveFocus();
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
            x: 18
            y: 18
            width: 295
            height: popupBtnCnt == 1 ? 268 : popupBtnCnt == 2 ? 134 : 116
            focus: true

            bgImageZ: 1
            bgImage:        popupBtnCnt == 1 ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png" : (popupBtnCnt == 2) ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_04_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_04_n.png"
            bgImagePress:   popupBtnCnt == 1 ? ImagePath.imgFolderPopup + "btn_type_a_01_p.png" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_02_p.png" : ImagePath.imgFolderPopup + "btn_type_b_04_p.png"
            bgImageFocus:   popupBtnCnt == 1 ? ImagePath.imgFolderPopup + "btn_type_a_01_f.png" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_02_f.png" : ImagePath.imgFolderPopup + "btn_type_b_04_f.png"

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       popupBtnCnt == 1 ? 246 - 18 : popupBtnCnt == 2 ? 251 - 18 : popupBtnCnt == 3 ? 246 + 12 - 18 : 248 + 12 - 18
            fgImageY:       popupBtnCnt == 1 ? 99 : popupBtnCnt == 2 ? 32 : 26
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton1.activeFocus

            firstText: popupFirstBtnText
            firstTextX: 26
            firstTextY: popupBtnCnt == 1 ? 116 : popupBtnCnt == 2 ? 49 : 41
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextElide: ""
            firstTextWrap: "Text.WordWrap"

            onClickOrKeySelected: {
                idButton1.forceActiveFocus();
                popupFirstBtnClicked();
            }

            onWheelLeftKeyPressed: {
                if(1 == popupBtnCnt) {
                    idButton1.forceActiveFocus();
                } else {
                    idButton2.forceActiveFocus();
                }
            }
        }

        MButton {
            id: idButton2
            x: 18
            y: popupBtnCnt == 2 ? 152 : 134
            width: 295
            height: popupBtnCnt == 2 ? 134 : 110
            visible: popupBtnCnt > 1

            bgImageZ: 1
            bgImage:        popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_03_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_05_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_05_n.png"
            bgImagePress:   popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_03_p.png" : ImagePath.imgFolderPopup + "btn_type_b_05_p.png"
            bgImageFocus:   popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_03_f.png" : ImagePath.imgFolderPopup + "btn_type_b_05_f.png"

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       popupBtnCnt == 2 ? 251 - 18 : 248 - 18
            fgImageY:       popupBtnCnt == 2 ? 32 : 25
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton2.activeFocus

            firstText: popupSecondBtnText
            firstTextX: 26
            firstTextY: popupBtnCnt == 2 ? 49 : 41
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextElide: ""
            firstTextWrap: "Text.WordWrap"

            onClickOrKeySelected: {
                idButton2.forceActiveFocus();
                popupSecondBtnClicked();
            }

            onWheelRightKeyPressed: idButton1.forceActiveFocus();
            onWheelLeftKeyPressed: {
                if(true == idButton3.visible) {
                    idButton3.forceActiveFocus();
                } else {
                    idButton2.forceActiveFocus();
                }
            }
        }

        MButton {
            id: idButton3
            x: 18
            y: 244
            width: 295
            height: 117
            visible: popupBtnCnt > 2

            bgImageZ: 1
            bgImage:         (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_06_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_06_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_b_06_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_b_06_f.png"

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       240
            fgImageY:       26
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton3.activeFocus

            firstText: popupThirdBtnText
            firstTextX: 26
            firstTextY: 41
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextElide: ""
            firstTextWrap: "Text.WordWrap"

            onClickOrKeySelected: {
                idButton3.forceActiveFocus();
                popupThirdBtnClicked();
            }

            onWheelRightKeyPressed: idButton2.focus = true
        }

        Text {
            id: idText1
            text: popupFirstText
            x: 361
            y: popupLineCnt == 1 ? 152 - 18 : popupLineCnt == 2 ? 130 : popupLineCnt == 3 ? 108 : 173
            width: ("popup_search_while_driving" == popupState)? 654:677 //654 가이드 상의 넓이 임의의 넓이 677
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            wrapMode: Text.WordWrap
        }

        Text {
            id: idText2
            text: popupSecondText
            x: 361
            y: popupLineCnt == 2 ? 130 + popupTextSpacing : popupLineCnt == 3 ? 108 + popupTextSpacing : 86 + popupTextSpacing
            width: 677 //654 가이드 상의 넓이 임의의 넓이 677
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            visible: popupLineCnt > 1
            wrapMode: Text.WordWrap
        }

        Text {
            id: idText3
            text: popupThirdText
            x: 361;
            y: popupLineCnt == 3 ? 108 + popupTextSpacing + popupTextSpacing : 86 + popupTextSpacing + popupTextSpacing
            width: 677 //654 가이드 상의 넓이 임의의 넓이 677
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            visible: popupLineCnt > 2
            wrapMode: Text.WordWrap
        }
    }
}
/* EOF */
