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

    property string btnImageSrc_n: systemInfo.imageInternal+"btn_camera_m_n.png"
    property string btnImageSrc_p: systemInfo.imageInternal+"btn_camera_m_p.png"
    property string btnImageSrc_f: systemInfo.imageInternal+"btn_camera_m_f.png"
    property string btnImageSrc_s: systemInfo.imageInternal+"btn_camera_m_s.png"

    //isAVMMode : true;
    focus:true

    onMainViewStateChanged:{
        //console.log("onMainViewStateChanged");
        if (mainViewState == "AVMMain") {
            //console.log("onMainViewStateChanged as AVMMain");
            idMainView.forceActiveFocus();
            idShortWideMenu.visible = false;
            if (canDB.AVM_View==8 || canDB.AVM_View==9) {
                MOp.toggleWideMenus(true);
            }
            else {
                MOp.toggleWideMenus(false);
            }
        }
    }

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

            Keys.onPressed: {
                switch(event.key) {
                    case Qt.Key_Up:
                    case Qt.Key_Down:
                    case Qt.Key_Right:
                    case Qt.Key_Left:
                    case Qt.Key_Minus:
                    case Qt.Key_Colon:
                    case Qt.Key_Enter:
                        if (avmViewWideBtn.isSelected && !idShortWideMenu.visible) {
                            idMenuTimer.stop();
                            idMenuTimer.start();
                        }
                        break;
                }
            }

    //        onReleased: {
    //            if (idShortWideMenu.visible) {
    //                idShortWideMenu.visible = false;
    //                avmViewWideBtn.forceActiveFocus();
    //                MOp.toggleWideMenus(true);
    //            }
    //            else {
    //                if (avmViewWideBtn.isSelected) {
    //                    idMenuTimer.stop();
    //                    idMenuTimer.start();
    //                }
    //            }
    //        }

            //Car Status Icon Area
            Loader {
                id: carStatusIcon
                x:15; y:91
                source: (canDB.CarStatusNo && (canDB.AVM_State!=15) && canDB.AVM_View>1)? "./component/CarStatusIconBox.qml" : ""
            } // End of Car Status Icon

            Item {
                id:shortMenuMouseArea
                anchors.fill: parent
                visible : idShortWideMenu.visible
                focus: false;

                MouseArea {
                    anchors.fill: parent
                    enabled: parent.visible

                    onClicked: {
                        idShortWideMenu.visible = false;
                        restoreViewFocus();
                        idMenuTimer.start();
                    }
                }
            }

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
                    visible: (idShortWideMenu.visible)? false : true
                    layoutDirection: (cppToqml.IsArab)? Qt.RightToLeft : Qt.LeftToRight

                    MComp.MButton {
                        id: avmViewAroundBtn
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: systemInfo.aVMButtonCarWidth
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        //focus: true
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage: systemInfo.imageInternal+ "ico_camera_1.png"
                        buttonName:"AVM_Around"
                        isSelected: (canDB.AVM_View == 2 || canDB.AVM_View == 3) ? true : false

                        onClickOrKeySelected: {
                            if (!avmViewAroundBtn.isSelected) {
                                (canDB.AVM_State == 1) ? canCon.changeAVMMenu(2) : canCon.changeAVMMenu(3);
                            }
                            idMenuTimer.stop();
                        }

                        onKeyOrTouchPressed: {
                            if (avmViewWideBtn.isSelected) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmViewWideBtn.isSelected) idMenuTimer.start();
                        }

                        KeyNavigation.right: (cppToqml.IsArab)? avmViewAroundBtn : avmViewWideBtn
                        KeyNavigation.left: (!cppToqml.IsArab)? avmViewAroundBtn : avmViewWideBtn
                        onWheelLeftKeyPressed: (cppToqml.IsArab)? avmViewWideBtn.forceActiveFocus() : avmViewAroundBtn.forceActiveFocus()
                        onWheelRightKeyPressed: (cppToqml.IsArab)? avmViewAroundBtn.forceActiveFocus() : avmViewWideBtn.forceActiveFocus()

//                        onActiveFocusChanged: {
//                            if (activeFocus) {
//                                focusIndex = 0;
//                            }
//                        }

                    }// End of avmViewAroundBtn

                    MComp.MButton {
                        id: avmViewWideBtn
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: systemInfo.aVMButtonCarWidth
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage:(canDB.AVM_State == 1) ? systemInfo.imageInternal+"ico_camera_6.png" : systemInfo.imageInternal+"ico_camera_2.png"
                        buttonName:"AVM_Wide"
                        isSelected: (canDB.AVM_View == 8 || canDB.AVM_View == 9) ? true : false

                        onClickOrKeySelected: {
                            if (!avmViewWideBtn.isSelected) {
                                (canDB.AVM_State == 1) ? canCon.changeAVMMenu(8) : canCon.changeAVMMenu(9);
                            }
                        }

                        onIsSelectedChanged: {
                            if (isSelected) {
                                MOp.toggleWideMenus(true);
                            }
                            else {
                                MOp.toggleWideMenus(false);
                            }
                        }

                        onKeyOrTouchPressed: {
                            if (avmViewWideBtn.isSelected) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmViewWideBtn.isSelected) idMenuTimer.start();
                        }

                        KeyNavigation.left: (cppToqml.IsArab)? avmViewLeftBtn : avmViewAroundBtn
                        KeyNavigation.right: (cppToqml.IsArab)? avmViewAroundBtn: avmViewLeftBtn
                        onWheelLeftKeyPressed: (cppToqml.IsArab)? avmViewLeftBtn.forceActiveFocus() : avmViewAroundBtn.forceActiveFocus()
                        onWheelRightKeyPressed: (cppToqml.IsArab)? avmViewAroundBtn.forceActiveFocus() : avmViewLeftBtn.forceActiveFocus()

//                        onActiveFocusChanged: {
//                            if (activeFocus) {
//                                focusIndex = 1;
//                            }
//                        }

                    }// End of avmViewWideBtn

                    MComp.MButton {
                        id: avmViewLeftBtn
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: systemInfo.aVMButtonCarWidth
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage: (canDB.AVM_State == 1) ? systemInfo.imageInternal+"ico_camera_7.png" : systemInfo.imageInternal+"ico_camera_3.png"
                        buttonName:"AVM_Left"
                        isSelected: (canDB.AVM_View == 4 || canDB.AVM_View == 5) ? true : false

                        onClickOrKeySelected: {
                            if (!avmViewLeftBtn.isSelected) {
                                (canDB.AVM_State == 1) ? canCon.changeAVMMenu(4) : canCon.changeAVMMenu(5);
                            }
                            idMenuTimer.stop();
                        }

                        onKeyOrTouchPressed: {
                            if (avmViewWideBtn.isSelected) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmViewWideBtn.isSelected) idMenuTimer.start();
                        }

                        KeyNavigation.left: (cppToqml.IsArab)? avmViewRightBtn : avmViewWideBtn
                        KeyNavigation.right: (cppToqml.IsArab)? avmViewWideBtn : avmViewRightBtn
                        onWheelLeftKeyPressed: (cppToqml.IsArab)? avmViewRightBtn.forceActiveFocus() : avmViewWideBtn.forceActiveFocus()
                        onWheelRightKeyPressed:(cppToqml.IsArab)? avmViewWideBtn.forceActiveFocus() : avmViewRightBtn.forceActiveFocus()

//                        onActiveFocusChanged: {
//                            if (activeFocus) {
//                                focusIndex = 2;
//                            }
//                        }

                    }// End of avmViewLeftBtn

                    MComp.MButton {
                        id: avmViewRightBtn
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: systemInfo.aVMButtonCarWidth
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage:(canDB.AVM_State == 1) ? systemInfo.imageInternal+"ico_camera_8.png" : systemInfo.imageInternal+"ico_camera_4.png"
                        buttonName:"AVM_Right"
                        isSelected: (canDB.AVM_View == 6 || canDB.AVM_View == 7) ? true : false

                        onClickOrKeySelected: {
                            if (!avmViewRightBtn.isSelected) {
                                (canDB.AVM_State == 1) ? canCon.changeAVMMenu(6) : canCon.changeAVMMenu(7);
                            }
                            idMenuTimer.stop();
                        }

                        onKeyOrTouchPressed: {
                            if (avmViewWideBtn.isSelected) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmViewWideBtn.isSelected) idMenuTimer.start();
                        }

                        KeyNavigation.left: (cppToqml.IsArab)? avmViewSettingBtn : avmViewLeftBtn
                        KeyNavigation.right: (cppToqml.IsArab)? avmViewLeftBtn : avmViewSettingBtn
                        onWheelLeftKeyPressed: (cppToqml.IsArab)? avmViewSettingBtn.forceActiveFocus() : avmViewLeftBtn.forceActiveFocus()
                        onWheelRightKeyPressed:(cppToqml.IsArab)? avmViewLeftBtn.forceActiveFocus() : avmViewSettingBtn.forceActiveFocus()

//                        onActiveFocusChanged: {
//                            if (activeFocus) {
//                                focusIndex = 3;
//                            }
//                        }

                    }// End of avmViewRightBtn

                    MComp.MButton {
                        id: avmViewSettingBtn
                        width: avmMenuBtnWidth
                        height: avmMenuBtnHeight
                        fgImageWidth: systemInfo.aVMButtonCarWidth
                        fgImageHeight: systemInfo.aVMButtonCarHeight
                        fgImageX: avmMenuFgImgX
                        bgImage: btnImageSrc_n
                        bgImagePress: btnImageSrc_p
                        bgImageActive: btnImageSrc_s
                        bgImageFocus: btnImageSrc_f
                        fgImage:systemInfo.imageInternal+"ico_camera_5.png"
                        buttonName:"AVM_Setup"

                        onClickOrKeySelected: {
                            mainViewState = "AVMSettingMain";
                            setMainAppScreen("AVMSettingMain", false);
                            idMenuTimer.stop();
                        }

                        onKeyOrTouchPressed: {
                            if (avmViewWideBtn.isSelected) idMenuTimer.stop();
                        }

                        onTouchReleased: {
                            if (avmViewWideBtn.isSelected) idMenuTimer.start();
                        }

                        KeyNavigation.left: (cppToqml.IsArab)? avmViewSettingBtn : avmViewRightBtn
                        KeyNavigation.right: (!cppToqml.IsArab)? avmViewSettingBtn : avmViewRightBtn
                        onWheelLeftKeyPressed: (cppToqml.IsArab)? avmViewSettingBtn.forceActiveFocus() : avmViewRightBtn.forceActiveFocus()
                        onWheelRightKeyPressed: (cppToqml.IsArab)? avmViewRightBtn.forceActiveFocus() : avmViewSettingBtn.forceActiveFocus()

//                        onActiveFocusChanged: {
//                            if (activeFocus) {
//                                focusIndex = 4;
//                            }
//                        }

                    }// End of avmViewSettingBtn

                }// End of Row

                //Short menu button for wide view
                MComp.MButton {
                    id: idShortWideMenu
                    x: 454-parent.x; y: 655-parent.y
                    width: 372; height: 62
                    visible : false
                    focus: false;
                    bgImage: systemInfo.imageInternal + "btn_wide_n.png"
                    bgImagePress: systemInfo.imageInternal + "btn_wide_p.png"
                    bgImageActive: systemInfo.imageInternal + "btn_wide_fp.png"
                    bgImageFocus: systemInfo.imageInternal+"btn_wide_f.png"
                    fgImageVisible: false

                    onClickOrKeySelected: {
                        idShortWideMenu.visible = false;
                        restoreViewFocus();
                        idMenuTimer.start();
                    }

                    onVisibleChanged: {
                        if (!visible) {
                            restoreViewFocus();
                        }
                    }

                }

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
                idShortWideMenu.visible = false;
                mainViewState="AVMMain"
                idMainView.forceActiveFocus()
                setMainAppScreen("", false)
                MOp.setAVMMainFocus(false); //avmViewSettingBtn.forceActiveFocus()
            }
        }

        //menu show/hide handler item
        Item {
            id: idMenuShowHide

            Timer {
                id: idMenuTimer
                interval:  5000; running:  false; repeat:  false;
                onTriggered: {
                    idShortWideMenu.visible = true;
                    idShortWideMenu.forceActiveFocus();
                }

            }
        }

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
            avmViewSettingBtn.forceActiveFocus();
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
            else if (iMode>1 && iMode<10) {
                //Rear view modes : 0x02, 4, 6, 8
                //Front view modes : 0x03, 5, 7, 9
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
                    default:
                        focusIndex = 0;
                        break;
                }
                if (mainViewState=="AVMMain") {
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
            if (canDB.AVM_View==8 || canDB.AVM_View==9) {
                idShortWideMenu.visible = false;
                avmViewWideBtn.forceActiveFocus();
                MOp.toggleWideMenus(true);
            }
            else {
                restoreViewFocus();
            }
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
            //console.log("loading AVMMain")
            mainViewState = "AVMMain"
            setMainAppScreen("AVMMain", false)
            idShortWideMenu.visible = false;
            if (canDB.AVM_View==8 || canDB.AVM_View==9) {
                MOp.toggleWideMenus(true);
            }
            else {
                MOp.toggleWideMenus(false);
            }

            idMainView.forceActiveFocus();
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
       source: cv < 3 ? systemInfo.dhLogoBLImageURI : systemInfo.dhLogoNoBLImageURI

       Rectangle {
           id: idBlackScreen
           anchors.fill: parent
           color: "black"
           visible: cppToqml.IsBlackMode
       }
    }

}
