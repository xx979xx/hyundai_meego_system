/**
 * /QML/DH_arabic/DDPopupToastWithDeviceName.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MPopup
{
    id: idPopupDim2LineContainer
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    // PROPERTIES
    property string popupName
    property string firstText: ""
    property string secondText: ""
    property string deviceName: ""
    //DEPRECATED property int textLineCount: 1
    property bool black_opacity: true
    property bool ignoreTimer: false

    property bool clicked: false

    // SIGNALS
    signal popupClicked();
    signal popupBgClicked();
    signal hardBackKeyClicked();
    signal timerEnd();


    /* EVENT  handlers */
    Component.onCompleted:{
        if(true == idPopupDim2LineContainer.visible) {
            popupTimer.start();
            popupBackGroundBlack = black_opacity
        }
    }

    Component.onDestruction: {
        popupTimer.stop();
    }

    onVisibleChanged: {
        if(true == idPopupDim2LineContainer.visible) {
            popupTimer.start();
            popupBackGroundBlack = black_opacity
        } else {
            popupTimer.stop();
        }
    }

    onBackKeyPressed: {
        /* 연결 해제, 연결 취소가 완료 되었을 경우 팝업이 사라지고
         * 빈화면 보였다가 홈으로 빠지는 문제 발생으로 HidePopup을 안하도록 한다.
         */
        if(false == ignoreTimer) {
            MOp.hidePopup();
        }

        hardBackKeyClicked();
    }

    onAnyKeyReleased: {
        // Dim 팝업에서 Jog Key 입력 하게 되면 팝업 사라도록 수정
        /* 연결 해제, 연결 취소가 완료 되었을 경우 팝업이 사라지고
         * 빈화면 보였다가 홈으로 빠지는 문제 발생으로 HidePopup을 안하도록 한다.
         */
        if(false == ignoreTimer) {
            MOp.hidePopup();
        }

        hardBackKeyClicked();
        MOp.returnFocus()
    }

    onClickMenuKey: {
        if(false == ignoreTimer) {
            MOp.hidePopup();
        }

        hardBackKeyClicked();
        idMenu.show();
        MOp.returnFocus()
    }


    /* WIDGETS */
    MouseArea {
        anchors.fill: parent
        onClicked: {
            /* 연결 해제, 연결 취소가 완료 되었을 경우 팝업이 사라지고
             * 빈화면 보였다가 홈으로 빠지는 문제 발생으로 HidePopup을 안하도록 한다.
             */
            if(false == ignoreTimer) {
                MOp.hidePopup();
            }

            popupClicked();
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: black_opacity ? 0 : 1
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_c.png"
        x: 250
        y: 454 - systemInfo.statusBarHeight
        width: 780
        height: 208

        MouseArea {
            anchors.fill: parent
            onClicked: {
                /* 연결 해제, 연결 취소가 완료 되었을 경우 팝업이 사라지고
                 * 빈화면 보였다가 홈으로 빠지는 문제 발생으로 HidePopup을 안하도록 한다.
                 */
                if(false == ignoreTimer) {
                    MOp.hidePopup();
                }

                popupClicked();
            }
        }

        Column {
            x: 0
            y: 55
            width: 712
            height: 72      // 36 *2

            spacing: 18
            //DEPRECATED anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: idText1st
                text: firstText
                x: 0
                y: 0
                width: 712
                height: 36
                color: colorInfo.brightGrey
                font.pointSize: 36
                font.family: stringInfo.fontFamilyBold    //"HDR"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: idText2nd
                text: secondText
                x: 0
                width: 712
                height: 36
                color: colorInfo.brightGrey
                font.pointSize: 36
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }
        }
    }

    /* TIMERS */
    Timer {
        id: popupTimer
        interval: 3000
        running: false
        repeat: false

        onTriggered: {
            /* 연결 해제, 연결 취소가 완료 되었을 경우 팝업이 사라지고
             * 빈화면 보였다가 홈으로 빠지는 문제 발생으로 HidePopup을 안하도록 한다.
             */
            if(false == ignoreTimer) {
                MOp.hidePopup();
            }

            timerEnd();
        }
    }
}
/* EOF */
