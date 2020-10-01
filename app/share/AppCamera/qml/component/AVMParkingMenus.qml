import QtQuick 1.1
import "../system" as MSystem

MComponent {

    MSystem.SystemInfo { id: systemInfo }

    width: systemInfo.avmMenuBarWidth; height: 96+9+9

    Component.onCompleted: {
        idGBtn1.forceActiveFocus();
        UIListener.SendAutoTestSignal(); //For AutoTest
    }

    Row {
        spacing:8
        anchors.centerIn: parent.Center
        layoutDirection: (cppToqml.IsArab)? Qt.RightToLeft : Qt.LeftToRight

        MButton {
            id: idGBtn1
            width: systemInfo.avmParkingButtonWidth; height: systemInfo.aVMButtonHeight
            fgImageWidth: width
            fgImageHeight: height
            bgImage:systemInfo.imageInternal+"btn_park_n.png"
            bgImagePress:systemInfo.imageInternal+"btn_park_p.png"
            bgImageActive:bgImagePress
            bgImageFocus: systemInfo.imageInternal+"btn_park_f.png"
            fgImage:systemInfo.imageInternal+ "ico_park_01.png"

            onClickOrKeySelected: {
                canCon.selectAVMParkingAssist(1);
            }

            KeyNavigation.right: idGBtn2
            onWheelRightKeyPressed: idGBtn2.forceActiveFocus()
        }

        MButton {
            id: idGBtn2
            width: systemInfo.avmParkingButtonWidth; height: systemInfo.aVMButtonHeight
            focus : true
            fgImageWidth: width
            fgImageHeight: height
            bgImage:systemInfo.imageInternal+"btn_park_n.png"
            bgImagePress:systemInfo.imageInternal+"btn_park_p.png"
            bgImageActive:bgImagePress
            bgImageFocus: systemInfo.imageInternal+"btn_park_f.png"
            fgImage:systemInfo.imageInternal+ "ico_park_02.png"

            onClickOrKeySelected: {
                canCon.selectAVMParkingAssist(2);
            }

            KeyNavigation.left:idGBtn1
            KeyNavigation.right: idGBtn3
            onWheelLeftKeyPressed: idGBtn1.forceActiveFocus()
            onWheelRightKeyPressed: idGBtn3.forceActiveFocus()
        }

        MButton {
            id: idGBtn3
            width: systemInfo.avmParkingButtonWidth; height: systemInfo.aVMButtonHeight
            focus : true
            fgImageWidth: width
            fgImageHeight: height
            bgImage:systemInfo.imageInternal+"btn_park_n.png"
            bgImagePress:systemInfo.imageInternal+"btn_park_p.png"
            bgImageActive:bgImagePress
            bgImageFocus: systemInfo.imageInternal+"btn_park_f.png"
            fgImage:systemInfo.imageInternal+ "ico_park_03.png"

            onClickOrKeySelected: {
                canCon.selectAVMParkingAssist(3);
            }

            KeyNavigation.left:idGBtn2
            KeyNavigation.right: idGBtn4
            onWheelLeftKeyPressed: idGBtn2.forceActiveFocus()
            onWheelRightKeyPressed: idGBtn4.forceActiveFocus()
        }

        MButton {
            id: idGBtn4
            width: systemInfo.avmParkingButtonWidth; height: systemInfo.aVMButtonHeight
            focus : true
            fgImageWidth: width
            fgImageHeight: height
            bgImage:systemInfo.imageInternal+"btn_park_n.png"
            bgImagePress:systemInfo.imageInternal+"btn_park_p.png"
            bgImageActive:bgImagePress
            bgImageFocus: systemInfo.imageInternal+"btn_park_f.png"
            fgImage:systemInfo.imageInternal+ "ico_park_04.png"

            onClickOrKeySelected: {
                canCon.selectAVMParkingAssist(4);
            }

            KeyNavigation.left:idGBtn3
            KeyNavigation.right: idGBtn5
            onWheelLeftKeyPressed: idGBtn3.forceActiveFocus()
            onWheelRightKeyPressed: idGBtn5.forceActiveFocus()
        }

        MButton {
            id: idGBtn5
            width: systemInfo.avmParkingButtonWidth; height: systemInfo.aVMButtonHeight
            focus : true
            fgImageWidth: width
            fgImageHeight: height
            bgImage:systemInfo.imageInternal+"btn_park_n.png"
            bgImagePress:systemInfo.imageInternal+"btn_park_p.png"
            bgImageActive:bgImagePress
            bgImageFocus: systemInfo.imageInternal+"btn_park_f.png"
            fgImage:systemInfo.imageInternal+ "ico_park_end.png"

            onClickOrKeySelected: {
                canCon.informParkingAssistBTNSelect();
            }

            KeyNavigation.left:idGBtn4
            onWheelLeftKeyPressed: idGBtn4.forceActiveFocus()
        }

    }

}
