/**
 * /BT/Common/PopupLoader/DDPopupTextWithDeviceName_15MY.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/Javascript/operation.js" as MOp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MPopup
{
    id: idPopupTextContainer
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    /* property */
    property bool black_opacity: true
    property string popupFirstText: ""
    property string popupFirstBtnText: ""

    property bool clicked: false

    // SIGNALS
    signal popupFirstBtnClicked();
    signal hardBackKeyClicked();
    signal timerEnd();

    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idPopupTextContainer.visible) {
            idPopupHidePopup.start()
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onVisibleChanged: {
        if(true == idPopupTextContainer.visible) {
            idPopupHidePopup.start()
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        } else {
            idPopupHidePopup.stop()
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }


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

        MButton {
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
                idButton1.forceActiveFocus();
                popupFirstBtnClicked();
            }
        }

        Text {
            id: idText1
            text: popupFirstText
            x: 78
            width: 654
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.WordWrap
        }
    }

    Timer {
        id: idPopupHidePopup
        /* IQS_15My 연결실패 팝업 자동 Hide 타이머
         * 문구 짧게 변경되면서 10초에서 5초로 변경됨
           -> ITS 0265662
         */
        interval: 10000
        repeat: false

        onTriggered: {
            timerEnd();
            // 10초 타이머
            console.log("\n\n\n\n\n10초 타이머 발생")
            // 자동 연결중 팝업 출력을 위해 주석처리
            //MOp.hidePopup()
        }
    }
}
/* EOF */
