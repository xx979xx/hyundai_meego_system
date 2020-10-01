/**
 * /QML/DH/MPopupTypeText.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MComp.MPopup
{
    id: idPopupTextContainer
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idPopupTextContainer.visible) {
            phoneNumInput = ""
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onVisibleChanged: {
        if(true == idPopupTextContainer.visible) {
            phoneNumInput = ""
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onBackKeyPressed: {
        BtCoreCtrl.invokeHandsfreeCallEndedEventToUISH();
    }


    /* Widgets */
    Rectangle {
        width: parent.width
        height: parent.height

        color: colorInfo.black
        opacity: 0.6
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_a.png"
        x: 93
        y: 208 - systemInfo.statusBarHeight
        width: 1093
        height: 304

        MComp.MButton {
            id: idButton1
            x: 18
            y: 18
            width: 295
            height: 268
            focus: true

            bgImageZ: 1
            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_a_01_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_a_01_f.png"

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       228
            fgImageY:       99
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton1.activeFocus

            firstText: stringInfo.str_Close
            firstTextX: 26
            firstTextY: 116
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
                BtCoreCtrl.invokeHandsfreeCallEndedEventToUISH();

            }
        }

        Text {
            id: idText1
            text: stringInfo.str_Dial_Fail
            x: 361
            y: 152 - 18
            width: 677 //654 가이드 상의 넓이 임의의 넓이 677
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
