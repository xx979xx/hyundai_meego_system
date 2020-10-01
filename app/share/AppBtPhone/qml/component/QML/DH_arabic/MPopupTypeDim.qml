/**
 * MPopupTypeDim.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MPopup
{
    id: bt_Popup_Dim_1Line
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    // PROPERTIES
    //DEPRECATED property string popupName
    property alias firstText: firstLine.text
    property alias secondText: secondLine.text
    //DEPRECATED property int textLineCount: 1
    property bool black_opacity: true
    property bool ignoreTimer: false
    property bool clickCheck: false

    // SIGNALS
    signal popupClicked();
    signal popupBgClicked();
    signal hardBackKeyClicked();
    signal timerEnd();


    /* EVENT  handlers */
    Component.onCompleted:{
        if(true == bt_Popup_Dim_1Line.visible) {
            popupTimer.start();
        }
        popupBackGround = black_opacity
    }

    onVisibleChanged: {
        if(true == bt_Popup_Dim_1Line.visible) {
            popupTimer.start();
            popupBackGround = black_opacity
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
    }

    onClickMenuKey: {
        if(false == ignoreTimer) {
            MOp.hidePopup();
        }

        hardBackKeyClicked();
        idMenu.show();
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

        Text {
            id: firstLine
            x: 34
            y: ("popup_Bt_Add_Favorite" == popupState)? 103 - 30 : 103 - 18
            width: 712
            height: 36
            color: colorInfo.brightGrey
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            //lineHeight: 0.75
        }

        Text {
            id: secondLine
            x: 34
            y: 103 - 30 + 36 + 5
            width: 712
            height: 36
            color: colorInfo.brightGrey
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            //lineHeight: 0.8
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
