/**
 * MPopupTypeContactsFail.qml
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
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property bool clickCheck: false

    property bool black_opacity: true

    // SIGNALS
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeBluetooth.visible) {
            idButton1.forceActiveFocus();
            popupBackGround = black_opacity
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeBluetooth.visible) {
            idButton1.forceActiveFocus();
            popupBackGround = black_opacity
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked()
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: (true == black_opacity) ? 0.6 : 1
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_b.png"
        x: 93
        y: 78
        width: 1093
        height: 379

        MButton {
            id: idButton1
            x: 18
            y: 18
            width: 295
            height: 171

            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_02_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_b_02_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_b_02_f.png"
            focus: true

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 226
            fgImageY: 54
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            onWheelLeftKeyPressed: idButton2.forceActiveFocus()

            firstText: popupFirstBtnText
            firstTextX: 26
            firstTextY: 71
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextElide: "Right"

            onClickOrKeySelected: {
                popupFirstBtnClicked()
            }
        }

        MButton {
            id: idButton2
            x: 18
            y: 189
            width: 295
            height: 171

            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_03_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_b_03_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_b_03_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 226
            fgImageY: 54
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton2.activeFocus

            onWheelRightKeyPressed: idButton1.forceActiveFocus()

            firstText: popupSecondBtnText
            firstTextX: 26
            firstTextY: 71
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextSize: 36
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupSecondBtnClicked()
            }
        }

        Text {
            id: idText1
            text: stringInfo.str_Help_Phonebook_Down_Fail
            x: 361
            y: 70
            width: 663
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            //elide: Text.ElideRight
            wrapMode: Text.WordWrap
        }

        Image {
            x: 398
            y: 188
            source: ImagePath.imgFolderPopup + "divide.png"
        }

        Text {
            id: idText2
            text: {
                switch(UIListener.invokeGetCountryVariant()) {
                  case 0: // Korea
                      //(내수 HMC) stringInfo.str_Web_Korea
                      stringInfo.str_Help_Phonebook_Down_Message + "\n" + stringInfo.url_KOREA
                      break;

                  case 1: // NorthAmerica
                      //(북미) stringInfo.str_Web_USA
                      stringInfo.str_Help_Phonebook_Down_Message + "\n" + stringInfo.url_USA
                      break;

                  default:
                      stringInfo.str_Help_Phonebook_Down_Message
                      break;
                }
            }

            x: 361
            y: 235      //148 + 32 - 16 //229

            width: 663
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            wrapMode: Text.WordWrap
            lineHeight: 0.8
        }
    }
}
/* EOF */