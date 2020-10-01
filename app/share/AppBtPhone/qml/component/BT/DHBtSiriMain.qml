/*
 * /BT/BtSiriMain.qml
 *
 */
import QtQuick 1.1
import "../QML/DH" as MComp
import "../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idBtSiriMain
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    /* Connections */
    /* [ITS 0233155]
    Connections {
        target: idAppMain

        onSigHideSiri: {
            btn_siri_cancel.focus = false
            btn_siri_speak.focus = true
        }
    }
    */

    /* INTERNAL functions */
    function backKeyHandler() {
        BtCoreCtrl.invokeSiriStopFromKeyHandler();
        MOp.hideSiriView(false);
    }


    /* EVENT handlers */
    onBackKeyPressed: {
        idBtSiriMain.backKeyHandler();
    }

    // [ITS 0233155]
    Component.onCompleted: {
        if(true == idBtSiriMain.visible) {
            btn_siri_speak.forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if(true == idBtSiriMain.visible) {
            btn_siri_speak.forceActiveFocus();
        }
    }

    onActiveFocusChanged: {
        if(true == idBtSiriMain.activeFocus) {
            btn_siri_speak.forceActiveFocus();
        } else {
            btn_siri_cancel.focus = false
            btn_siri_speak.focus = true
        }
    }

/*DEPRECATED
    onHomeKeyPressed: {
        UIListener.invokePostHomeKey();
        // BtCoreCtrl.invokeSiriStop();
    }
DEPRECATED*/


    /* WIDGETS */
    Rectangle {
        anchors.fill: parent
        color: "Black"
    }

    Image {
        source: ImagePath.imgFolderSiri + "bg_siri.png"
        x: 0
        y: 0
        width: systemInfo.lcdWidth
        height: 627

        Text {
            text: "Siri"
            x: 158
            y: 231
            width: 310
            height: 150
            font.pointSize: 150
            font.family: stringInfo.fontFamilyBold    //"HDB"
            color: colorInfo.brightGrey
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Image {
            source: ImagePath.imgFolderSiri + "bg_btn.png"
            x: 540
            y: 98
        }

        Image {
            source: ImagePath.imgFolderSiri + "bg_light_01.png"
            x: 564
            y: 98
            visible: btn_siri_speak.activeFocus
        }

        Image {
            source: ImagePath.imgFolderSiri + "ico_light.png"
            x: 594
            y: 229
            visible: btn_siri_speak.activeFocus
        }

        Image {
            source: ImagePath.imgFolderSiri + "bg_light_02.png"
            x: 588
            y: 152
            visible: btn_siri_cancel.activeFocus
        }

        Image {
            source: ImagePath.imgFolderSiri + "ico_light.png"
            x: 597
            y: 313
            visible: btn_siri_cancel.activeFocus
        }

        // SPEAK button
        MComp.MButton {
            id: btn_siri_speak
            x: 706
            y: 314 - 93
            width: 398
            height: 82
            focus: true

            bgImage:        ImagePath.imgFolderSiri + "btn_speak_n.png"
            bgImagePress:   ImagePath.imgFolderSiri + "btn_speak_p.png"
            bgImageFocus:   ImagePath.imgFolderSiri + "btn_speak_f.png"

            firstText: stringInfo.str_Speak
            firstTextColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextX: 20
            firstTextY: 24      //42 - 18
            firstTextWidth: 358
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"

            onClickOrKeySelected: {
                qml_debug("btn_siri_speak, onClickOrKeySelected: BtCoreCtrl.invokeSiriStart() call")
                BtCoreCtrl.invokeSiriSpeak();
            }

            KeyNavigation.right: btn_siri_cancel
            onWheelRightKeyPressed: { btn_siri_cancel.focus = true; }
        }

        // CANCEL button
        MComp.MButton {
            id: btn_siri_cancel
            x: 706
            y: 314 - 93 + 88
            width: 398
            height: 82

            bgImage:        ImagePath.imgFolderSiri + "btn_speak_n.png"
            bgImagePress:   ImagePath.imgFolderSiri + "btn_speak_p.png"
            bgImageFocus:   ImagePath.imgFolderSiri + "btn_speak_f.png"

            firstText: stringInfo.str_Bt_Siri_Cancel
            firstTextColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextX: 20
            firstTextY: 24      //42 - 18
            firstTextWidth: 358
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"

            onClickOrKeySelected: {
                qml_debug("btn_siri_cancel, onClickOrKeySelected: popScreen() call");
                //DEPRECATED BtCoreCtrl.invokeSiriCancel();
                idBtSiriMain.backKeyHandler();
            }

            KeyNavigation.left: btn_siri_speak
            onWheelLeftKeyPressed: { btn_siri_speak.focus = true }
        }

        // Bottom guide message
        Text {
            text: stringInfo.str_Siri_Use_Message
            x: 22
            y: 532  //552    //663 - 93 - 18
            width: 1237
            height: 36
            font.pointSize: 36
            font.family: stringInfo.fontFamilyBold    //"HDB"
            color: colorInfo.dimmedGrey
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            lineHeight: 0.5
       }
    }
}
/* EOF */
