import QtQuick 1.1
import Qt.labs.gestures 2.0

import "system" as MSystem
import "component" as MComp
import "system/operation.js" as MOp

import Transparency 1.0

MComp.MAppMain {
    id: idAppMain
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.StringInfo {id:stringInfo}

    property string mainViewState : "AVMMain"
    property int avmMenuBtnWidth : systemInfo.aVMButtonWidth
    property int avmMenuBtnHeight: systemInfo.aVMButtonHeight
    property int avmMenuFgImgX : 0
    property int focusIndex: 0
    property int avmMenuBtnType: 0 // 0: front/rear normal mode(5btns), 1: rear wide(5btns, AutoHide), 2: front wide(6btns, AutoHide), 3: front 2-section(6btns)
    property string btnImageSrc_n: systemInfo.imageInternal+"btn_camera_m_n.png"
    property string btnImageSrc_p: systemInfo.imageInternal+"btn_camera_m_p.png"
    property string btnImageSrc_f: systemInfo.imageInternal+"btn_camera_m_f.png"
    property string btnImageSrc_s: systemInfo.imageInternal+"btn_camera_m_s.png"

    focus:true

    Component.onCompleted:{
        //console.log("Component.onCompleted");
        idMainView.forceActiveFocus();
        avmViewAroundBtn.forceActiveFocus();
        UIListener.SendAutoTestSignal(); //For AutoTest
    }

    function setMainAppScreen(screenName, save) {
        MOp.setMainScreen(screenName,save);
    }

    //Video out
    Transparency {
        anchors.fill: parent
    }

    Item {
        id: idGUIitem

        //Background Rect
        Item {
            transformOrigin: Item.Center
            anchors.fill: parent   //AVM_State 1 : rearOn, AVM_State 2 : frontOn, AVM_State 5 : parkingAssistOn
            visible: (canDB.AVM_State==1 || canDB.AVM_State==2 || canDB.AVM_State==5)? true : false

            Image {
                id: front2sectionBG
                x:0; y:0
                width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
                source: systemInfo.imageInternal+ "bg_camera_half.png"
                visible: (canDB.AVM_View==19)? true : false
            }

            Item {
                id: mainScreen
                x: 9; y: 9
                width: systemInfo.avmMenuBarWidth; height: 597

            }

            //Alert msg
            Item {
                id: idAlertItem
                anchors.horizontalCenter : mainScreen.horizontalCenter
                y: 9
                width : mainScreen.width; height:78
                //visible: (canDB.AVM_DispMsg==58 || canDB.AVM_DispMsg==61 || canDB.AVM_DispMsg==62 || canDB.AVM_DispMsg==63)? true : false

                Text {
                    y:13
                    id: idAlertTxt
                    text: stringInfo.alert2txt
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: colorInfo.brightGrey
                    font.family: stringInfo.fontName
                    font.pointSize: (cppToqml.IsTooLongAlert)? 28 : systemInfo.alertFontSize
                    //font.pointSize : systemInfo.alertFontSize
                    style: Text.Outline; styleColor: "black"
                    z: 2
                }

            }

        } // End of Background

        //idMainView
        MComp.MComponent {
            id:idMainView
            visible: (mainViewState=="AVMMain" && canDB.AVM_View!=15)? true : false //If canDB.AVM_View==15 (0x0F), there is direct AVM video out view mode.
            width: systemInfo.lcdWidth
            height: systemInfo.lcdHeight
            clip:true
            focus:true
            enableClick: false;

            //Car Status Icon Area
            Loader {
                id: carStatusIcon
                x:15; y:91
                source: (canDB.CarStatusNo && canDB.AVM_View>1)? "./component/CarStatusIconBox.qml" : ""
            } // End of Car Status Icon

            Item {
                id:wideViewMouseArea
                anchors.fill: parent
                visible : !avmMenus.visible
                focus: false;

                MouseArea {
                    anchors.fill: parent
                    enabled: parent.visible

                    onClicked: {
                        if (avmMenuBtnType==1 || avmMenuBtnType==2) {
                            avmMenus.visible = true;
                            idMenuTimer.start();
                        }
                    }
                }
            }

//            Keys.onPressed: {
//                //console.log("[idMainView] Keys.onPressed, event.key:" + event.key);
//                switch(event.key) {
//                    case Qt.Key_Up:
//                    case Qt.Key_Down:
//                    case Qt.Key_Right:
//                    case Qt.Key_Left:
//                    case Qt.Key_Minus:
//                    case Qt.Key_Colon:
//                    case Qt.Key_Enter:
//                        //console.log("[idMainView] filter in!!!! event.key:" + event.key + ", avmMenuBtnType:" + avmMenuBtnType + ", avmMenus.visible:" + avmMenus.visible);
//                        if (avmMenuBtnType==1 || avmMenuBtnType==2) {
//                            idMenuTimer.stop();
//                            if (!avmMenus.visible) {
//                                avmMenus.visible = true;
//                            }
//                            idMenuTimer.start();
//                        }
//                        break;
//                }
//            }

            //AVM (rear/front) Menus
            Item {
                id: avmMenus
                visible: (canDB.ShowAVMMainMenu) ? true : false  // calibration view qml is the other one.
                x:systemInfo.avmMenuBarX; y:systemInfo.avmMenuBarY
                width: systemInfo.avmMenuBarWidth; height: systemInfo.avmMenuBarHeight

                onVisibleChanged: {
                    if (visible) {
                        //console.log("avmMenus onVisibleChanged, canDB.AVM_View:" + canDB.AVM_View);
                        idMainView.forceActiveFocus();
                        restoreViewFocus();//MOp.setAVMMainFocus(false);//avmViewAroundBtn.focus= true;
                    }
                }

                Row {
                    id: idAVMMenusRow
                    spacing: 5
                    anchors.centerIn: parent.Center
                    layoutDirection: (cppToqml.IsArab)? Qt.RightToLeft : Qt.LeftToRight

                    MComp.MButton {
                        id: avmViewAroundBtn
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: {
                            if (avmMenuBtnType>1) systemInfo.aVMButtonCarWidthFrontNormal //6btns, wide
                            if (avmMenuBtnType==1) systemInfo.aVMButtonCarWidth2 // 5btns, wide
                            else systemInfo.aVMButtonCarWidth //5btns
                        }
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        //focus: true
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage: {
                            if (avmMenuBtnType>1) systemInfo.imageInternal+ "ico_camera_03_1.png"
                            else if (avmMenuBtnType==1) systemInfo.imageInternal+ "ico_camera_01_1.png"
                            else systemInfo.imageInternal+ "ico_camera_1.png"
                        }
                        buttonName:"AVM_Around"
                        isSelected: (canDB.AVM_View == 2 || canDB.AVM_View == 3) ? true : false

                        onClickOrKeySelected: {
                            if (!avmViewAroundBtn.isSelected) {
                                (canDB.AVM_State == 1) ? canCon.changeAVMMenu(2) : canCon.changeAVMMenu(3);
                            }
                            idMenuTimer.stop();
                        }

                        onKeyOrTouchPressed: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.start();
                        }

                        KeyNavigation.right: (cppToqml.IsArab)? avmViewAroundBtn : avmViewWideBtn
                        KeyNavigation.left: (!cppToqml.IsArab)? avmViewAroundBtn : avmViewWideBtn
                        onWheelLeftKeyPressed: (cppToqml.IsArab)? avmViewWideBtn.forceActiveFocus() : avmViewAroundBtn.forceActiveFocus()
                        onWheelRightKeyPressed: (cppToqml.IsArab)? avmViewAroundBtn.forceActiveFocus() : avmViewWideBtn.forceActiveFocus()

                    }// End of avmViewAroundBtn

                    MComp.MButton {
                        id: avmViewWideBtn
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: {
                            if (avmMenuBtnType>1) systemInfo.aVMButtonCarWidthFrontNormal
                            else if (avmMenuBtnType==1) systemInfo.aVMButtonCarWidth2
                            else systemInfo.aVMButtonCarWidth
                        }
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage:{
                            if (canDB.AVM_State == 2) { //front on
                                if (avmMenuBtnType>1) systemInfo.imageInternal+ "ico_camera_03_2.png"
                                else if (avmMenuBtnType==1) systemInfo.imageInternal+ "ico_camera_01_2.png"
                                else systemInfo.imageInternal+"ico_camera_2.png"
                            }
                            else systemInfo.imageInternal+"ico_camera_6.png" //wide
                        }
                        buttonName:"AVM_Wide"
                        isSelected: (canDB.AVM_View == 8 || canDB.AVM_View == 9) ? true : false

                        onClickOrKeySelected: {
                            if (!avmViewWideBtn.isSelected) {
                                (canDB.AVM_State == 1) ? canCon.changeAVMMenu(8) : canCon.changeAVMMenu(9);
                            }
                        }

                        onKeyOrTouchPressed: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.start();
                        }

                        onIsSelectedChanged: {
                            MOp.toggleWideMenus2(avmMenuBtnType);
                        }

                        KeyNavigation.left: {
                            if (cppToqml.IsArab) {
                                if (avmMenuBtnType>1) avmFront2SectionBtn
                                else avmViewLeftBtn
                            }
                            else {
                                avmViewAroundBtn
                            }
                        }
                        KeyNavigation.right: {
                            if (cppToqml.IsArab) {
                                avmViewAroundBtn
                            }
                            else {
                                if (avmMenuBtnType>1) avmFront2SectionBtn
                                else avmViewLeftBtn
                            }
                        }
                        onWheelLeftKeyPressed: {
                            if (cppToqml.IsArab) {
                                if (avmMenuBtnType>1) avmFront2SectionBtn.forceActiveFocus()
                                else avmViewLeftBtn.forceActiveFocus()
                            }
                            else {
                                avmViewAroundBtn.forceActiveFocus()
                            }
                        }

                        onWheelRightKeyPressed: {
                            if (cppToqml.IsArab) {
                                avmViewAroundBtn.forceActiveFocus()
                            }
                            else {
                                if (avmMenuBtnType>1) avmFront2SectionBtn.forceActiveFocus()
                                else avmViewLeftBtn.forceActiveFocus()
                            }
                        }

                    }// End of avmViewWideBtn

                    MComp.MButton {
                        id: avmFront2SectionBtn
                        visible: (avmMenuBtnType>1) ? true : false
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: systemInfo.aVMButtonCarWidth2 //: systemInfo.aVMButtonCarWidthFrontNormal
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage: systemInfo.imageInternal+"ico_camera_03_3.png" //: systemInfo.imageInternal+"ico_camera_01_3.png"
                        buttonName:"AVM_Front2Section"
                        isSelected: (canDB.AVM_View == 19) ? true : false

                        onClickOrKeySelected: {
                            if (!isSelected) {
                                canCon.changeAVMMenu(10);
                            }
                        }

                        onKeyOrTouchPressed: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.start();
                        }

                        onIsSelectedChanged: {
                            MOp.toggleWideMenus2(avmMenuBtnType);
                        }

                        KeyNavigation.left: (cppToqml.IsArab)? avmViewLeftBtn : avmViewWideBtn
                        KeyNavigation.right: (cppToqml.IsArab)? avmViewWideBtn: avmViewLeftBtn
                        onWheelLeftKeyPressed: (cppToqml.IsArab)? avmViewLeftBtn.forceActiveFocus() : avmViewWideBtn.forceActiveFocus()
                        onWheelRightKeyPressed: (cppToqml.IsArab)? avmViewWideBtn.forceActiveFocus() : avmViewLeftBtn.forceActiveFocus()
                    }

                    MComp.MButton {
                        id: avmViewLeftBtn
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: {
                            if (avmMenuBtnType>1) systemInfo.aVMButtonCarWidthFrontNormal
                            else if (avmMenuBtnType==1) systemInfo.aVMButtonCarWidth2
                            else systemInfo.aVMButtonCarWidth
                        }
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage: {
                            if (canDB.AVM_State == 2) {
                                if (avmMenuBtnType>1) systemInfo.imageInternal+ "ico_camera_03_4.png"
                                else if (avmMenuBtnType==1) systemInfo.imageInternal+ "ico_camera_01_4.png"
                                else systemInfo.imageInternal+"ico_camera_3.png"
                            }
                            else systemInfo.imageInternal+"ico_camera_7.png"
                        }
                        buttonName:"AVM_Left"
                        isSelected: (canDB.AVM_View == 4 || canDB.AVM_View == 5) ? true : false

                        onClickOrKeySelected: {
                            if (!avmViewLeftBtn.isSelected) {
                                (canDB.AVM_State == 1) ? canCon.changeAVMMenu(4) : canCon.changeAVMMenu(5);
                            }
                            idMenuTimer.stop();
                        }

                        onKeyOrTouchPressed: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.start();
                        }

                        KeyNavigation.left: {
                            if (cppToqml.IsArab) {
                                avmViewRightBtn
                            }
                            else {
                                if (avmMenuBtnType>1) avmFront2SectionBtn
                                else avmViewWideBtn
                            }
                        }
                        KeyNavigation.right: {
                            if (cppToqml.IsArab) {
                                if (avmMenuBtnType>1) avmFront2SectionBtn
                                else avmViewWideBtn
                            }
                            else {
                                avmViewRightBtn
                            }
                        }

                        onWheelLeftKeyPressed: {
                            if (cppToqml.IsArab) {
                                avmViewRightBtn.forceActiveFocus()
                            }
                            else {
                                if (avmMenuBtnType>1) avmFront2SectionBtn.forceActiveFocus()
                                else avmViewWideBtn.forceActiveFocus()
                            }
                        }
                        onWheelRightKeyPressed: {
                            if (cppToqml.IsArab) {
                                if (avmMenuBtnType>1) avmFront2SectionBtn.forceActiveFocus()
                                else avmViewWideBtn.forceActiveFocus()
                            }
                            else {
                                avmViewRightBtn.forceActiveFocus()
                            }
                        }

                    }// End of avmViewLeftBtn

                    MComp.MButton {
                        id: avmViewRightBtn
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: {
                            if (avmMenuBtnType>1) systemInfo.aVMButtonCarWidthFrontNormal
                            else if (avmMenuBtnType==1) systemInfo.aVMButtonCarWidth2
                            else systemInfo.aVMButtonCarWidth
                        }
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage: {
                            if (canDB.AVM_State == 2) {
                                if (avmMenuBtnType>1) systemInfo.imageInternal+ "ico_camera_03_5.png"
                                else if (avmMenuBtnType==1) systemInfo.imageInternal+ "ico_camera_01_5.png"
                                else systemInfo.imageInternal+"ico_camera_4.png"
                            }
                            else systemInfo.imageInternal+"ico_camera_8.png"
                        }
                        buttonName:"AVM_Right"
                        isSelected: (canDB.AVM_View == 6 || canDB.AVM_View == 7) ? true : false

                        onClickOrKeySelected: {
                            if (!avmViewRightBtn.isSelected) {
                                (canDB.AVM_State == 1) ? canCon.changeAVMMenu(6) : canCon.changeAVMMenu(7);
                            }
                            idMenuTimer.stop();
                        }

                        onKeyOrTouchPressed: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.start();
                        }

                        KeyNavigation.left: (cppToqml.IsArab)? avmViewSettingBtn : avmViewLeftBtn
                        KeyNavigation.right: (cppToqml.IsArab)? avmViewLeftBtn : avmViewSettingBtn
                        onWheelLeftKeyPressed: (cppToqml.IsArab)? avmViewSettingBtn.forceActiveFocus() : avmViewLeftBtn.forceActiveFocus()
                        onWheelRightKeyPressed:(cppToqml.IsArab)? avmViewLeftBtn.forceActiveFocus() : avmViewSettingBtn.forceActiveFocus()

                    }// End of avmViewRightBtn

                    MComp.MButton {
                        id: avmViewSettingBtn
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: {
                            if (avmMenuBtnType>1) systemInfo.aVMButtonCarWidthFrontNormal
                            else if (avmMenuBtnType==1) systemInfo.aVMButtonCarWidth2
                            else systemInfo.aVMButtonCarWidth
                        }
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage:{
                            if (canDB.AVM_State == 2) { //front on
                                if (avmMenuBtnType>1) systemInfo.imageInternal+ "ico_camera_03_6.png"
                                else if (avmMenuBtnType==1) systemInfo.imageInternal+ "ico_camera_01_6.png"
                                else systemInfo.imageInternal+"ico_camera_5.png"
                            }
                            else systemInfo.imageInternal+"ico_camera_5.png"
                        }
                        buttonName:"AVM_Setup"

                        onClickOrKeySelected: {
                            mainViewState = "AVMSettingMain";
                            setMainAppScreen("AVMSettingMain", false);
                        }

                        onKeyOrTouchPressed: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmMenuBtnType==1 || avmMenuBtnType==2) idMenuTimer.start();
                        }

                        KeyNavigation.left: (cppToqml.IsArab)? avmViewSettingBtn : avmViewRightBtn
                        KeyNavigation.right: (!cppToqml.IsArab)? avmViewSettingBtn : avmViewRightBtn
                        onWheelLeftKeyPressed: (cppToqml.IsArab)? avmViewSettingBtn.forceActiveFocus() : avmViewRightBtn.forceActiveFocus()
                        onWheelRightKeyPressed: (cppToqml.IsArab)? avmViewRightBtn.forceActiveFocus() : avmViewSettingBtn.forceActiveFocus()

                    }// End of avmViewSettingBtn

                }// End of Row

            }//End of avmMenus

        }
        //End of idMainView

        //idMainViewLoader
        MComp.MComponent {
            id:idMainViewLoader
            y:0
            Loader { id:idAVMSettingMain;       }
            Loader { id:idAVMCalibInitMenu;     }
            Loader { id:idAVMCalibCmd;          }

            onBackKeyPressed: {
                mainViewState="AVMMain"
                idMainView.forceActiveFocus()
                setMainAppScreen("", false)
                MOp.setAVMMainFocus2(false); //avmViewSettingBtn.forceActiveFocus()
            }
        }

    }

    Item {
        id: idShortWideMenu
        visible: false;
        focus: false
    }

    function restoreViewFocus() {
        if (focusIndex==1) {
            avmViewWideBtn.forceActiveFocus();
        }
        else if (focusIndex==2) {
            avmViewLeftBtn.forceActiveFocus();
        }
        else if (focusIndex==3) {
            avmViewRightBtn.forceActiveFocus();
        }
        else if (focusIndex==4) {
            avmFront2SectionBtn.forceActiveFocus();
        }
        else {
            avmViewAroundBtn.forceActiveFocus();
        }
    }

    Connections {
        target: canCon
        //qDebug("\t(avmOff=0, rearOn=1, frontOn=2, calibSelectMenuOn=3, calibCmdMainOn=4, parkingAssistOn=5, directOutOn=6)\n");
        onAVMViewModeChanged: {
            if (canDB.AVM_State!=0) {
                changeAVMView();
            }
        }

        onSignalFrontRearViewChanged: {
            if (iMode==0) { // AVM off -> reset focus
                //do nothing for onSignalShowShutter
            }
            else if ((iMode>1 && iMode<10) || iMode==19) {
                //Rear view modes : 0x02, 4, 6, 8
                //Front view modes : 0x03, 5, 7, 9, 0x13(19)
                if (iMode==8) {
                    avmMenuBtnType = 1; //rear wide view
                }
                else if (iMode==9) {
                    avmMenuBtnType = 2; //front wide view
                }
                else if (iMode==19) {
                    avmMenuBtnType = 3; //front 2-section view
                }
                else {
                    avmMenuBtnType = 0; //front/rear normal view
                }
                MOp.toggleWideMenus2(avmMenuBtnType);

                switch(iMode) {
                    case 8:
                    case 9:
                        focusIndex = 1;
                        break;
                    case 4:
                    case 5:
                        focusIndex = 2;
                        break;
                    case 6:
                    case 7:
                        focusIndex = 3;
                        break;
                    case 19: //0x13 - front 2-section view
                        focusIndex = 4;
                        break;
                    default:
                        focusIndex = 0;
                        break;
                }
                if (mainViewState=="AVMMain") {
                    if (!avmMenus.visible) {
                        avmMenus.visible = true;
                    }
                    restoreViewFocus();
                }
            }
        }
    }

    Connections {
        target: idAVMCalibInitMenu.item

        onBackFromCalibMain: {
            mainViewState="AVMMain"
            setMainAppScreen("", false)
            idMainView.forceActiveFocus()
            MOp.setAVMMainFocus(false);
            MOp.toggleWideMenus2(avmMenuBtnType);
        }
    }

    function changeAVMView() {
        if (canDB.AVM_State==3) {
            //console.log("loading AVMCalibInitMenu")
            mainViewState = "AVMCalibInitMenu"
            setMainAppScreen("AVMCalibInitMenu", false)
        }
        else if (canDB.AVM_State==4) {
            //console.log("loading AVMCalibCmd")
            mainViewState = "AVMCalibCmd"
            setMainAppScreen("AVMCalibCmd", false)
        }
        else if (canDB.AVM_State==6) {
            //Direct Video Out
            //console.log("Direct Video Out")
            if (mainViewState!="AVMMain") {
                mainViewState = "AVMMain"
                setMainAppScreen("AVMMain", false)
            }
            idMainView.forceActiveFocus();
        }
        else {
            mainViewState = "AVMMain"
            setMainAppScreen("AVMMain", false)
            idMainView.forceActiveFocus();
            MOp.setAVMMainFocus(false);
        }
    }

    onBeep: {
        UIListener.PlayAudioBeep();
    }

    Connections {
        target: UIListener

//        onSignalBGFromUISH: {
//        }

        onSignalShowShutter: {
            idCameraLoading.visible = true;
            idDHLogo.visible = false;
            //idGUIitem.visible = true;
            //if (decoderWindow.visible) decoderWindow.forceActiveFocus();
        }

        onSignalShowSystemPopup: {
           idAppMain.focus = false;
        }
        onSignalHideSystemPopup: {
            idAppMain.forceActiveFocus();
        }

        onShowLogo: {
            idCameraLoading.visible = false;
            idDHLogo.visible = true;
        }

        onHideLogo: {
            idDHLogo.visible = false;
        }

    }

    Connections {
        target: CamPlayer

        onInvokeAnimation: {
            idCameraLoading.visible = false;
        }
    }

    /*
    Item {
        width: 80; height: 80
        x: parent.width-width
        y: 0

        MouseArea {
            anchors.fill: parent
            onClicked: (decoderWindow.visible)? decoderWindow.visible = false : decoderWindow.visible = true
        }

    }

    MComp.DecoderSettingBar {
        id: decoderWindow;
        width: 620
        height: 160
        x: parent.width-width-10
        y: parent.height-height
        visible: false

        onVisibleChanged: {
            if(visible) {
                decoderWindow.forceActiveFocus();
            }
            else {
                restoreViewFocus();//MOp.setAVMMainFocus(false); //avmViewAroundBtn.forceActiveFocus();
            }
        }

        Connections {
            target: decoderWindow.item
            onCloseWindow: decoderWindow.visible = false;
        }
    }
    */


    MComp.LoadingCamera {
        id: idCameraLoading
        x:0; y:0
        width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
        visible: false
    }

    Image {
       id: idDHLogo
       anchors.fill: parent
       property int cv: UIListener.GetCountryVariantFromQML()
       visible: false
       source: cv < 3 ? systemInfo.dhpeLogoBLImageURI : systemInfo.dhpeLogoNoBLImageURI

       Rectangle {
           id: idBlackScreen
           anchors.fill: parent
           color: "black"
           visible: cppToqml.IsBlackMode
       }
    }

    Timer {
        id: idMenuTimer
        interval:  5000; running:  false; repeat:  false;
        onTriggered: {
            if (avmMenuBtnType==1 || avmMenuBtnType==2) {
                avmMenus.visible = false;
            }
        }

    }

}
