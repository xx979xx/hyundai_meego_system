/**
 * /QML/DH/MPopupTypeDisconByPhone.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MPopup
{
    id: idMPopupTypeText
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property bool black_opacity: true
    property alias popupFirstText: idText1.text
    property alias popupSecondText: idText2.text
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    // SIGNALS
    //DEPRECATED signal popupClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idMPopupTypeText.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    /* EVENT handlers */
    onVisibleChanged: {
        if(true == idMPopupTypeText.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width;
        height: parent.height
        color: colorInfo.black
        opacity: black_opacity ? 0.6 : 1
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_a.png"
        x: 93
        y: 115      //208 - 93
        width: 1093
        height: 304

        MButton {
            id: idButton1
            x: 780
            y: 18
            width: 295
            height: 134
            focus: true

            bgImageZ: 1
            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_a_02_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_a_02_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: -7
            fgImageY: 32
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            firstText: popupFirstBtnText
            firstTextX: 52
            firstTextY: 49
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onWheelRightKeyPressed: idButton2.forceActiveFocus();

            onClickOrKeySelected: {
                popupFirstBtnClicked();
            }
        }

        MButton {
            id: idButton2
            x: 780
            y: 152
            width: 295
            height: 134

            bgImageZ: 1
            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_03_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_a_03_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_a_03_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: -7
            fgImageY: 32
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton2.activeFocus

            firstText: popupSecondBtnText
            firstTextX: 52
            firstTextY: 49
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onWheelLeftKeyPressed: idButton1.forceActiveFocus();

            onClickOrKeySelected: {
                popupSecondBtnClicked()
            }
        }

        Item {
            anchors.verticalCenter: parent.verticalCenter
            x: 78
            width: 644
            height: idText1.paintedHeight + idText2.paintedHeight + 10

            Text {
                id: idText1
                width: 654
                font.pointSize: 32
                font.family: stringInfo.fontFamilyBold    //"HDB"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.subTextGrey
                elide: Text.ElideRight
            }

            Text {
                id: idText2
                anchors.bottom: parent.bottom
                anchors.topMargin: 10
                width: 654;
                font.pointSize: 32
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                horizontalAlignment: Text.AlignLeft
                color: colorInfo.subTextGrey
                wrapMode: Text.WordWrap
                lineHeight: 0.9
           }
        }
    }
}
/* EOF */
