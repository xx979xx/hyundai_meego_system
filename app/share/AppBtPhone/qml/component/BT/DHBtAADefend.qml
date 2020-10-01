/*
 * /BT/DHBtAADefend.qml - //2015.10.30 [ITS 0269835,0269836] Android Auto Handling (UX Scenario Changed)
 *
 */

import QtQuick 1.1
import "../QML/DH" as MComp
import "../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../BT/Common/Javascript/operation.js" as MOp

MComp.MComponent
{
    id: idBtAADefend
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    // SIGNALS
    signal popupFirstBtnClicked();
    signal hardBackKeyClicked();

    property bool black_opacity: false

    /* INTERNAL functions */
    function backKeyHandler() {
        idAppMain.mainShowAADefend(false);
    }

    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idBtAADefend.visible) {
            popupBackGroundBlack = black_opacity
        }
    }

    onBackKeyPressed: {
        idBtAADefend.backKeyHandler();
    }

    onActiveFocusChanged: {
        focus = true
        idButton1.forceActiveFocus();
    }

    onVisibleChanged: {

    }

    onPopupFirstBtnClicked: { backKeyHandler(); }
    onHardBackKeyClicked:   { backKeyHandler(); }

    /* Widgets */
    Rectangle {
        width: parent.width
        height: parent.height

        color: colorInfo.black
        opacity: black_opacity ? 0.6 : 1
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_a.png"
        x: 93
        y: 208 - 93
        width: 1093
        height: 304
        focus: true

        MComp.MButton {
            id: idButton1
            x: 780
            y: 18
            width: 295
            height: 268
            focus: true

            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_a_01_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_a_01_f.png"

            fgImage:        ImagePath.imgFolderPopup + "light.png"
            fgImageX:       -2
            fgImageY:       99
            fgImageWidth:   69
            fgImageHeight:  69
            fgImageVisible: true == idButton1.activeFocus

            firstText: stringInfo.str_Ok
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

        Text {
            id: idText1
            text: stringInfo.str_AADefend_Popup_Text
            x: 78
            width: 654
            height: 32
            //[ITS 0272466]
            font.pointSize: (9 == gLanguage || 10 == gLanguage) ?  29 : 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.WordWrap
        }
    }
}
/* EOF */
