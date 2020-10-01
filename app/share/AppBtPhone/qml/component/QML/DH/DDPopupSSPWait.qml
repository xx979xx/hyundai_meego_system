/**
 * /QML/DH/DDPopupSSPWait.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MPopup
{
    id: idPopupSSPWaitContainer
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property string popupFirstText: ""
    property string popupFirstSubText: ""

    property string popupSecondText: ""

    property string popupThirdText: ""

    property string popupFirstBtnText: ""
    property int    popupBtnCount: 0

    property bool black_opacity: true


    // SIGNALS
    signal popupFirstBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idPopupSSPWaitContainer.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onVisibleChanged: {
        if(true == idPopupSSPWaitContainer.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: black_opacity ? 0.6 : 1
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_b.png"
        x: 93
        y: 171 - systemInfo.statusBarHeight
        width: 1093
        height: 379

        MButton {
            id: idButton1
            x: 780
            y: 18
            width: 295
            height: 343
            focus: 1 == popupBtnCount
            visible: 1 == popupBtnCount
            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_b_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_01_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_b_01_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_b_01_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: -2
            fgImageY: 136
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            firstText: popupFirstBtnText
            firstTextX: 52
            firstTextY: 153
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextElide: "Right"

            onClickOrKeySelected: {
                popupFirstBtnClicked();
            }
        }

        Text {
            id: idText1
            text: stringInfo.str_Passkey_Popup + " : "
            x: 69
            y: 71
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
        }

        Text {
            id: idTextSub1
            text: sspOk
            anchors.left: idText1.right
            y: 71
            width: 663 - idText1.paintedWidth
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideRight
        }


        Text {
            id: idText2
            text: stringInfo.str_Device_Name_Popup + " : "
            x: 69
            y: 123
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
        }

        Text {
            id: idTextSub2
            text: sspDeviceName
            anchors.left: idText2.right
            y: 123
            width: 663 - idText2.paintedWidth
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideRight
        }


        Image {
            id: popupLineImage
            source: ImagePath.imgFolderPopup + "divide.png"
            x: 47
            y: 188
        }

        Text {
            id: idText3
            text: stringInfo.str_Device_Ssp_Wait
            x: 69
            y: 254
            width: 663
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: colorInfo.subTextGrey
            wrapMode: Text.WordWrap
            lineHeight: 5 == gLanguage || 9 == gLanguage || 13 == gLanguage || 14 == gLanguage || 19 == gLanguage || gLanguage == 21 || gLanguage == 22 || gLanguage == 8 ? 0.8 : 1
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }
}
/* EOF */
