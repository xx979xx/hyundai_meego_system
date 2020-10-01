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

    //DEPRECATED property int popupTextSpacing: 44
    property string popupFirstText: ""
    property string popupSecondText: ""
    //DEPRECATED property alias popupThirdText: idText3.text

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 2
    //DEPRECATED property int popupLineCnt: 2

    property bool clickCheck: false

    // SIGNALS
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal popupThirdBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idPopupTextContainer.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onVisibleChanged: {
        if(true == idPopupTextContainer.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked()
    }


    /* Widgets */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: black_opacity ? 0.6 : 1
    }

    Image {
        source: popupBgImage
        x: 93
        y: popupBgImageY
        width: popupBgImageWidth
        height: popupBgImageHeight

        MButton {
            id: idButton1
            x: 18
            y: 18
            width: 295
            height: popupBtnCnt == 1 ? 268 : popupBtnCnt == 2 ? 134 : 116

            bgImage:        popupBtnCnt == 1 ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png" : popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png" : popupBtnCnt == 3 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_04_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_04_n.png" : popupBtnCnt == 4 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_07_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_07_n.png" : ""
            bgImagePress:   popupBtnCnt == 1 ? ImagePath.imgFolderPopup + "btn_type_a_01_p.png" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup+"btn_type_b_04_p.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup + "btn_type_b_07_p.png" : ""
            bgImageFocus:   popupBtnCnt == 1 ? ImagePath.imgFolderPopup + "btn_type_a_01_f.png" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup+"btn_type_b_04_f.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup + "btn_type_b_07_f.png" : ""
            focus: true

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       popupBtnCnt == 1 ? 251 - 25 : popupBtnCnt == 2 ? 257 - 25 : popupBtnCnt == 3 ? 246 + 12 - 25 : 248 + 13 - 25
            fgImageY:       popupBtnCnt == 1 ? 99 : popupBtnCnt == 2 ? 32 : 26
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton1.activeFocus

            firstText: popupFirstBtnText
            firstTextX: 52
            firstTextY: popupBtnCnt == 1 ? 116 : popupBtnCnt == 2 ? 49 : 41
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

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

            bgImage:        popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_03_n.png" : popupBtnCnt == 3 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_05_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_05_n.png" : ""
            bgImagePress:   popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_03_p.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup + "btn_type_b_05_p.png" : ""
            bgImageFocus:   popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_03_f.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup + "btn_type_b_05_f.png" : ""

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       popupBtnCnt == 1 ? 251 - 25 : popupBtnCnt == 2 ? 257 - 25 : popupBtnCnt == 3 ? 246 + 12 - 25 : 248 + 13 - 25
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

        Column {
            x: 361
            y: 0
            width: 654

            spacing: 12
            height: idText1.height + idText2.height + 12

            anchors.verticalCenter: parent.verticalCenter

            Component.onCompleted: {
                /* paintedHeight를 이용해 높이를 정해주지 않으면 vertical center로 정렬되지 않음
                 * paintedHeight가 정확하게 설정되는 시점은 onCompleted()
                 */
                height = idText1.height + idText2.paintedHeight + 12;
            }

            Text {
                id: idText1
                text: popupFirstText
                x: 0
                width: 654
                height: 32
                font.pointSize: 32
                font.family: stringInfo.fontFamilyBold    //"HDB"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.subTextGrey
                elide: Text.ElideRight
            }

            Text {
                id: idText2
                text: popupSecondText
                x: 0
                width: 654
                height: idText2.paintedHeight
                font.pointSize: 32
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.subTextGrey
                wrapMode: Text.WordWrap

                onTextChanged: {
                    if("" != idText2.text) {
                        parent.height = idText1.height + idText2.paintedHeight + 12;
                    }
                }
            }
        }
    }
}
/* EOF */
