/**
 * MPopupTypeBluetooth.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MPopup
{
    id: idMPopupTypeBluetooth
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    // PROPERTIES
    property string popupName

    property string popupFirstText: ""
    property string popupFirstSubText: ""
    property string popupSecondText: ""
    property string popupSecondSubText: ""
    property string popupThirdText: ""
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property bool black_opacity: true
    property int popupBtnCnt: 2
    property bool button1Enable : true
    property bool button2Enable : true

    // SIGNALS
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    function textLineHeightChanged() {
        if(190 < idText3.height) {
            idText3.lineHeight = 0.75
        } else {
            idText3.lineHeight = 1
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeBluetooth.visible) {
            idButton1.forceActiveFocus();
            idMPopupTypeBluetooth.textLineHeightChanged();
        }
        popupBackGround = black_opacity
    }

    onVisibleChanged: {
        if(true == idMPopupTypeBluetooth.visible) {
            idButton1.forceActiveFocus();
            idMPopupTypeBluetooth.textLineHeightChanged();
        }
        popupBackGround = black_opacity
    }

    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: black_opacity ? 0.6 : 1

        onOpacityChanged: {
            if(true == idMPopupTypeBluetooth.visible) {
                idButton1.forceActiveFocus();
            }
        }
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_b.png"
        x: 93
        y: 171 - systemInfo.statusBarHeight
        width: 1093
        height: 379
        focus: true

        MButton {
            id: idButton1
            x: 18
            y: 18
            width: 295
            height: 171
            focus: true

            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_02_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_b_02_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_b_02_f.png"

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX: 229
            fgImageY:       54
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton1.activeFocus

            firstText: popupFirstBtnText
            firstTextX: 26
            firstTextY: 71
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
                popupFirstBtnClicked();
            }

            onWheelLeftKeyPressed: {
                if(false == idButton2.mEnabled) {
                    idButton1.forceActiveFocus();
                } else {
                    idButton2.forceActiveFocus();
                }
            }
        }

        MButton {
            id: idButton2
            x: 18
            y: 189
            width: 295
            height: 171
            visible: popupBtnCnt > 1

            bgImageZ: 1
            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_03_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_b_03_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_b_03_f.png"

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       229
            fgImageY:       54
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton2.activeFocus

            firstText: popupSecondBtnText
            firstTextX: 26
            firstTextY: 71
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextElide: ""
            firstTextWrap: "Text.WordWrap"

            mEnabled: button2Enable

            onMEnabledChanged: {
                if(false == idButton2.mEnabled) {
                    if(true == idButton2.activeFocus) {
                        idButton1.forceActiveFocus();
                    }
                }
            }

            onClickOrKeySelected: {
                idButton2.forceActiveFocus();
                popupSecondBtnClicked();
            }

            onWheelRightKeyPressed: idButton1.forceActiveFocus();
        }

        Item {
            x: 361
            y: 71
            width: 663
            height: 32

            Text {
                id: idText1
                text: popupFirstText
                anchors.right: parent.right
                height: 32
                font.pointSize: 32
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.brightGrey
                elide: Text.ElideRight
            }

            Text {
                id: idSubText1
                anchors.right: idText1.left
                text: popupFirstSubText
                height: 32
                font.pointSize: 32
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.brightGrey
            }
        }

        Item {
            x: 361
            y: 123
            width: 663
            height: 32

            Text {
                id: idText2
                text: popupSecondText
                anchors.right: parent.right
                font.pointSize: 32
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.brightGrey
                elide: Text.ElideRight
            }

            Text {
                id: idSubText2
                text: popupSecondSubText
                anchors.right: idText2.left
                font.pointSize: 32
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.brightGrey
            }
        }

        Image {
            source: ImagePath.imgFolderPopup + "divide.png"
            x: 305
            y: 188
        }

        Item {
            id: hiddenItem
            x: 361
            y: 262
            width: 663
            height: 32
        }

        Text {
            id: idText3
            text: popupThirdText
            width: 663
            height: Text.paintedHeight
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            wrapMode: Text.WordWrap
            anchors.verticalCenter: hiddenItem.verticalCenter
            anchors.horizontalCenter: hiddenItem.horizontalCenter

            onTextChanged: {
                idMPopupTypeBluetooth.textLineHeightChanged();
            }
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }
}
/* EOF */
