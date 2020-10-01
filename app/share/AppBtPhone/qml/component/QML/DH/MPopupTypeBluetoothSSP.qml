/**
 * /QML/DH/MPopupTypeBluetoothSSP.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MPopup
{
    id: idMPopupTypeBluetoothSSP
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
    property string popupFourthText: ""

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""
    property int    popupBtnCount: 0

    property bool black_opacity: true
    property int countDownSSP: 5    // SSP팝업 5초 count down

    // SIGNALS
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();
    signal timerEnd();    // 5초대기 팝업


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeBluetoothSSP.visible) {
            idButton1.forceActiveFocus();

            if("popup_Bt_SSP" == popupState) {
                // 페어링 시 5초대기 팝업 카운트 다운 표시할 때 사용
                countDownSSP = 5;

                // 5초대기 팝업
                idBluetoothPopupTimer.start();
            }
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeBluetoothSSP.visible) {
            idButton1.forceActiveFocus();

            if("popup_Bt_SSP" == popupState) {
                // 페어링 시 5초대기 팝업 카운트 다운 표시할 때 사용
                countDownSSP = 5;

                // 5초대기 팝업
                idBluetoothPopupTimer.start();
            }
        } else {
            idBluetoothPopupTimer.stop();
            countDownSSP = 5;
        }
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: black_opacity ? 0.6 : 1

        onOpacityChanged: {
            if(true == idMPopupTypeBluetoothSSP.visible) {
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
                idBluetoothPopupTimer.stop();
                popupFirstBtnClicked();
            }
        }

        Text {
            id: idText1
            text: popupFirstText + " : "
            x: 69
            y: 71
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideRight
        }

        Text {
            id: idTextSub1
            text: popupFirstSubText
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
            text: popupSecondText + " : "
            x: 69
            y: 123
            //width: 0 == popupBtnCount ? 980 : 663
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideRight
        }

        Text {
            id: idSubText2
            text: popupSecondSubText
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
            source: ImagePath.imgFolderPopup + "divide.png"
            x: popupBtnCount == 0 ? 230 : 69
            y: 188
        }

        Column {
            id: idBottomTextContainer
            x: 69
            y: if(120 > idBottomTextContainer.height) {
                   232
               } else {
                   202
               }

            width: 663
            height: 32

            spacing: 8

            Component.onCompleted: {
                /* paintedHeight를 이용해 높이를 정해주지 않으면 vertical center로 정렬되지 않음
                 * paintedHeight가 정확하게 설정되는 시점은 onCompleted()
                 */
                height = idText3.paintedHeight + 12 + idText4.height;
                console.log("################################################ " + height)
                console.log("################################################ " + idBottomTextContainer.y)
            }

            Text {
                id: idText3
                text: popupThirdText
                x: 0
                y: 0
                //DEPRECATED y: (0 == popupBtnCount) ? 210 : 182
                width: 663
                height: idText3.paintedHeight
                font.pointSize: 32
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                horizontalAlignment: popupBtnCount == 0 ? Text.AlignHCenter : Text.AlignLeft
                color: colorInfo.subTextGrey
                wrapMode: Text.WordWrap

                onTextChanged: {
                    if("" != popupThirdText) {
                        parent.height = idText3.paintedHeight + 12 + idText4.height;
                    }
                }
            }

            Text {
                id: idText4
                text: popupFourthText
                x: 0
                //DEPRECATED y: 300
                width: (0 == popupBtnCount) ? 980 : 663
                height: 32
                font.pointSize: 32
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                horizontalAlignment: (popupBtnCount == 0) ? Text.AlignHCenter : Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.bandBlue //RGB(124,189,255)
                elide: Text.ElideRight
            }
        }
    }

    /* TIMERS */
    Timer {
        id: idBluetoothPopupTimer
        interval: 1000
        running: false
        repeat: true

        onTriggered: {
            if(0 < countDownSSP) {
                console.log("countDownSSP = " + countDownSSP);
                countDownSSP--;
            } else {
                idBluetoothPopupTimer.stop();
                timerEnd();
            }
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }
}
/* EOF */
