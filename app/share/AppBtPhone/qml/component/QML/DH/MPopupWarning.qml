/**
 * MPopupWarning.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MPopup
{
    id: idMPopupTypeWarning
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property bool black_opacity: false

    property string titleText: ""
    property string popupFirstText: ""
    property string popupFirstBtnText: ""

    // SIGNALS
    signal popupFirstBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeWarning.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeWarning.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: (true == black_opacity) ? 0.6 : 1
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_d.png"
        x: 93
        y: 73
        width: 1093
        height: 384

        Item {
            y: 38
            height: 41
            width: 60 + textWarning.paintedWidth
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: idWarningIcon
                source: ImagePath.imgFolderPopup + "ico_warning.png"
                //x: 35

                width: 41
                height: 41
            }

            Text {
                id: textWarning
                text: titleText
                height: 44
                font.pointSize: 44
                font.family: stringInfo.fontFamilyBold    //"HDB"
                color: colorInfo.brightGrey
                verticalAlignment: Text.AlignVCenter
                anchors.left: idWarningIcon.right
                anchors.leftMargin: 19
            }
        }

        Text {
            text: popupFirstText
            x: 78
            y: 210
            width: 654
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.subTextGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }

        MButton {
            id: idButton1
            x: 780
            y: 98
            width: 295
            height: 268
            focus: true

            bgImage: (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png"
            bgImagePress: ImagePath.imgFolderPopup + "btn_type_a_01_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "btn_type_a_01_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: -2
            fgImageY: 99
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: (true == idButton1.activeFocus) ? true : false

            firstText: popupFirstBtnText
            firstTextX: 52
            firstTextY: 116
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupFirstBtnClicked();
            }
        }
    }
}
/* EOF */
