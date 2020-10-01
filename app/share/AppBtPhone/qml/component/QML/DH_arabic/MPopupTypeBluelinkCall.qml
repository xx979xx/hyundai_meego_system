/**
 * MPopupTypeBluetoothCall.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MComponent
{
    id: idMPopupTypeBluetoothCall
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    // PROPERTIES
    property string popupName

    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    // SIGNALS
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal popupThirdBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeBluetoothCall.visible) {
            idButton1.forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeBluetoothCall.visible) {
            // 블루링크 팝업 발생 시 초기 포커스 가도록 수정
            idButton1.forceActiveFocus();
        }
    }

    onClickOrKeySelected: {
        popupBgClicked();
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_b.png"
        x: 93
        y: 171 - systemInfo.statusBarHeight
        width: 1093
        height: 379

        MButton {
            id: idButton1
            x: 18
            y: 18
            width: 295
            height: 171
            focus: true

            bgImageZ: 1
            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_02_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_b_02_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_b_02_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 233
            fgImageY: 54
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            firstText: popupFirstBtnText
            firstTextX: 33
            firstTextY: 71
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupFirstBtnClicked();
            }

            onWheelRightKeyPressed: idButton2.forceActiveFocus();
        }

        MButton {
            id: idButton2
            x: 18
            y: 189
            width: 295
            height: 171

            bgImageZ: 1
            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_03_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_b_03_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_b_03_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 233
            fgImageY: 54
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton2.activeFocus

            firstText: popupSecondBtnText
            firstTextX: 33
            firstTextY: 71
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextSize: 36
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupSecondBtnClicked();
            }

            onWheelLeftKeyPressed: idButton1.forceActiveFocus();
        }

        Image {
            source: ImagePath.imgFolderPopup + "ico_receive.png"
            x: 892
            y: 193
            width: 113
            height: 135
        }

        Text {
            id: idText1
            text: popupFirstText
            x: 361
            y: 191
            width: 499
            height: 60
            font.pointSize: 60
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey

            // 전화번호 출력시 글시가 길어지면 Font Size 줄어드는 부분
            onTextChanged: {
                if(499 > idText1.paintedWidth) {
                    idText1.font.pointSize = 60;
                } else {
                    idText1.font.pointSize = 49;
                    idText1.elide = Text.ElideRight;
                }
            }
        }

        Text {
            id: idText2
            text: popupSecondText
            x: 361
            y: 275
            width: 499
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
        }

        Text {
            id: idText3
            text: popupThirdText
            x: 361
            y: 86
            width: 622
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            wrapMode: Text.WordWrap
        }
    }
}
/* EOF */
