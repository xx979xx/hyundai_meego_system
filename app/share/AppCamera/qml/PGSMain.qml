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

    property string mainViewState : "PGSMain"
    property int focusIndexOfMenu : 0
    property bool bISGoToMainWithBG : true

    function focusedToMenu(idx) {
        switch (idx) {
        case 1:
            pgsAParkBtn.forceActiveFocus();
            break;
        case 2:
            pgsPParkBtn.forceActiveFocus();
            break;
        case 3:
            pgsSettingBtn.forceActiveFocus();
            break;
        default:
            pgsToggleViewBtn.forceActiveFocus();
            break;
        }
    }

    focus:true

    onMainViewStateChanged:{
        if (mainViewState == "PGSMain") {
            idMainView.forceActiveFocus();
            focusedToMenu(focusIndexOfMenu);
        }
        else if (mainViewState == "PopupMain") {
            //console.log("onMainViewStateChanged as PopupMain");
            idTimerPopUpHide.start();
            idPopupMain.forceActiveFocus();
        }
    }

    Component.onCompleted:{
        idMainView.forceActiveFocus();
        pgsToggleViewBtn.forceActiveFocus();
        UIListener.SendAutoTestSignal(); //For AutoTest
    }
    function setMainAppScreen(screenName, save) {
        MOp.setMainScreen(screenName,save);
    }

    Transparency {
        anchors.fill: parent
    }

    //top shadow img, alert msg and icon
    Item{
        id: idPGSAlertArea
        width: systemInfo.lcdWidth
        height: 142
        visible: (canDB.PGS_State)? true : false
        x:0; y:0;

        Item {//alert msg and icon
            id:alertItem
            anchors.fill: parent

            Text {
               id: idAlertMsg1
               y: 12+10
               text: stringInfo.alert2txt
               anchors.horizontalCenter: alertItem.horizontalCenter
               color: colorInfo.brightGrey
               font.family: stringInfo.fontName
               font.pointSize : systemInfo.alertFontSize
               style: Text.Outline; styleColor: "black"
            }

        }

    } //End idPGSAlertArea


    //idMainView
    MComp.MComponent {
        id:idMainView
        visible: (mainViewState=="PGSMain" && canDB.PGS_State)? true : false
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        clip:true
        focus:true
        enableClick: false;

        //PGS Menus
        Item {
            id: pgsMenus
            x:(cppToqml.IsCompactPGSMode)? 903 : 7
            y:(cppToqml.IsCompactPGSMode)? 612 : 613
            width:systemInfo.lcdWidth; height:102
            visible: (canDB.PGS_State==2 || canDB.PGS_State==8) ? true : false

            Row {
                x:0; y:0
                layoutDirection: (cppToqml.IsArab)? Qt.RightToLeft : Qt.LeftToRight
                spacing:4

                MComp.MButton {
                    id: pgsToggleViewBtn
                    width:(cppToqml.IsCompactPGSMode)? 370 : 314
                    height: (cppToqml.IsCompactPGSMode)? 102 : 101
                    focus: true
                    bgImage: (cppToqml.IsCompactPGSMode)? systemInfo.imageInternal+"btn_topview_n.png" : systemInfo.imageInternal+"btn_park_l_n.png"
                    bgImagePress: (cppToqml.IsCompactPGSMode)? systemInfo.imageInternal+"btn_topview_p.png" : systemInfo.imageInternal+"btn_park_l_p.png"
                    bgImageActive: bgImagePress
                    bgImageFocus: (cppToqml.IsCompactPGSMode)? systemInfo.imageInternal+"btn_topview_f.png" : systemInfo.imageInternal+"btn_park_l_f.png"
                    firstText: (canDB.IsTopView)? stringInfo.pgsBtn2txt : stringInfo.pgsBtn1txt
                    firstTextSize: systemInfo.btnFontSize

                    onClickOrKeySelected: {
                        if (canDB.IsTopView) {
                            canCon.changePGSMenu(5);
                        }
                        else {
                            canCon.changePGSMenu(6);
                        }
                        focusIndexOfMenu=0;
                    }

                    KeyNavigation.left: {
                        if (cppToqml.IsArab)
                            pgsAParkBtn
                        else
                            pgsToggleViewBtn
                    }
                    KeyNavigation.right: {
                        if (cppToqml.IsCompactPGSMode)
                            pgsToggleViewBtn
                        else if (cppToqml.IsArab)
                            pgsToggleViewBtn
                        else
                            pgsAParkBtn
                    }
                    onWheelLeftKeyPressed: {
                        if (cppToqml.IsCompactPGSMode)
                            pgsToggleViewBtn.forceActiveFocus()
                        else if (cppToqml.IsArab)
                            pgsAParkBtn.forceActiveFocus()
                        else
                            pgsToggleViewBtn.forceActiveFocus()
                    }
                    onWheelRightKeyPressed: {
                        if (cppToqml.IsCompactPGSMode)
                            pgsToggleViewBtn.forceActiveFocus()
                        else if (cppToqml.IsArab)
                            pgsToggleViewBtn.forceActiveFocus()
                        else
                            pgsAParkBtn.forceActiveFocus()
                    }
                }

                //Straight (Angle) Parking Btn
                MComp.MButton {
                    id: pgsAParkBtn
                    width: 314; height: 101
                    fgImageWidth: width
                    fgImageHeight: height
                    bgImage: systemInfo.imageInternal+"btn_park_l_n.png"
                    bgImagePress: systemInfo.imageInternal+"btn_park_l_p.png"
                    bgImageActive: bgImagePress
                    bgImageFocus: systemInfo.imageInternal+"btn_park_l_f.png"
                    fgImage:systemInfo.imageInternal+ "ico_park_l_01.png"
                    visible : cppToqml.IsCompactPGSMode? false : true

                    onClickOrKeySelected: {
                        canCon.changePGSMenu(2);
                        focusIndexOfMenu=1;
                    }

                    KeyNavigation.left: (cppToqml.IsArab)? pgsPParkBtn : pgsToggleViewBtn
                    KeyNavigation.right: (cppToqml.IsArab)? pgsToggleViewBtn : pgsPParkBtn
                    onWheelLeftKeyPressed: (cppToqml.IsArab)? pgsPParkBtn.forceActiveFocus() : pgsToggleViewBtn.forceActiveFocus()
                    onWheelRightKeyPressed: (cppToqml.IsArab)? pgsToggleViewBtn.forceActiveFocus() : pgsPParkBtn.forceActiveFocus()
                }

                //Parallel Parking Btn
                MComp.MButton {
                    id: pgsPParkBtn
                    fgImageWidth: width
                    fgImageHeight: height
                    width: 314; height: 101
                    bgImage: systemInfo.imageInternal+"btn_park_l_n.png"
                    bgImagePress: systemInfo.imageInternal+"btn_park_l_p.png"
                    bgImageActive: bgImagePress
                    bgImageFocus: systemInfo.imageInternal+"btn_park_l_f.png"
                    fgImage:systemInfo.imageInternal+ "ico_park_l_02.png"
                    visible : cppToqml.IsCompactPGSMode? false : true

                    onClickOrKeySelected: {
                        canCon.changePGSMenu(3);
                        focusIndexOfMenu=2;
                    }

                    KeyNavigation.left: (cppToqml.IsArab)? pgsSettingBtn : pgsAParkBtn
                    KeyNavigation.right: (cppToqml.IsArab)? pgsAParkBtn : pgsSettingBtn
                    onWheelLeftKeyPressed: (cppToqml.IsArab)? pgsSettingBtn.forceActiveFocus() : pgsAParkBtn.forceActiveFocus()
                    onWheelRightKeyPressed: (cppToqml.IsArab)? pgsAParkBtn.forceActiveFocus() : pgsSettingBtn.forceActiveFocus()

                }

                MComp.MButton {
                    id: pgsSettingBtn
                    width: 314; height: 101
                    fgImageWidth: width
                    fgImageHeight: height
                    //fgImageX: 0
                    bgImage: systemInfo.imageInternal+"btn_park_l_n.png"
                    bgImagePress: systemInfo.imageInternal+"btn_park_l_p.png"
                    bgImageActive: bgImagePress
                    bgImageFocus: systemInfo.imageInternal+"btn_park_l_f.png"
                    fgImage:systemInfo.imageInternal+ "ico_setting.png"
                    visible: cppToqml.IsCompactPGSMode? false : true

                    onClickOrKeySelected: {
                       canCon.changePGSMenu(4);
                        focusIndexOfMenu=3;
                    }

                    KeyNavigation.left: (cppToqml.IsArab)? pgsSettingBtn : pgsPParkBtn
                    KeyNavigation.right: (cppToqml.IsArab)? pgsPParkBtn : pgsSettingBtn
                    onWheelLeftKeyPressed: (cppToqml.IsArab)? pgsSettingBtn.forceActiveFocus() : pgsPParkBtn.forceActiveFocus()
                    onWheelRightKeyPressed: (cppToqml.IsArab)? pgsPParkBtn.forceActiveFocus() : pgsSettingBtn.forceActiveFocus()
                }

            }// End Row

        }// End PGS Menus

        //Back key -> go to Previous view
        MComp.MButton{
            id: idBackKey
            x: (cppToqml.IsArab)? (systemInfo.lcdWidth-(systemInfo.backKeyX+systemInfo.widthBackKey)) : systemInfo.backKeyX
            y: systemInfo.backKeyY
            width: systemInfo.widthBackKey; height: systemInfo.heightBackKey
            bgImage: systemInfo.bgImageBackKey
            bgImagePress: systemInfo.bgImagePressBackKey
            bgImageFocusPress: bgImagePress
            bgImageFocus: systemInfo.bgImageFocusBackKey

            visible: (canDB.PGS_State==4 || canDB.PGS_State==7) ? true : false

            onClickOrKeySelected: {
                canCon.changePGSMenu(8);
            }

            onBackKeyPressed: {
                //console.log("A back key is pressed..");
                canCon.changePGSMenu(8);
            }

            onVisibleChanged: {
                if (idBackKey.visible) idBackKey.forceActiveFocus();
                else focusedToMenu(focusIndexOfMenu);
            }

        }

        //Parking Guide Message Box
        Rectangle {
            id: idPGSStepMsgBox
            x:0; y:615
            width: systemInfo.lcdWidth; height: 105
            color: "black"
            visible: (canDB.PGS_ParkGuideState==1 || canDB.PGS_ParkGuideState==3 || canDB.PGS_ParkGuideState==6) ? true : false

            Text {
                anchors.centerIn: parent
                width: 980; height: 105
                color: colorInfo.brightGrey
                font.family: stringInfo.fontName
                font.pointSize : systemInfo.alertFontSize//btnFontSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap; textFormat: Text.RichText
                clip: true
                text:  {
                    if (canDB.PGS_ParkGuideState==1) ((cppToqml.IsEnglish)? "<div style=\"line-height:80%\">" : "") +  stringInfo.pgsStepTxt1 + ((cppToqml.IsEnglish)? "</div>" : "");
                    else if (canDB.PGS_ParkGuideState==3) stringInfo.pgsStepTxt2;
                    else if (canDB.PGS_ParkGuideState==6) stringInfo.pgsStepTxt3;
                    else ""
                }


            }
        }

    }

    //idMainViewLoader
    MComp.MComponent {
        id:idMainViewLoader
        y:0
        enableClick: false;
        Loader { id:idPGSSettingMain;       }
        Loader { id:idPopupMain;            }
    } //End idMainViewLoader

    Connections{
        target:canCon
        onPGSPopupShow:{
            //console.log("onPGSPopupShow launched.");
            mainViewState = "PopupMain"
            setMainAppScreen("PopupMain", false)
        }

        onSignalPGStoHUSettingView: {
            mainViewState = "PGSSettingMain"
            setMainAppScreen("PGSSettingMain", false)
        }

        onSignalOutOfSettingView: {
            if (state) {
                bISGoToMainWithBG = false;
            }

            if (!bISGoToMainWithBG && mainViewState!="PGSMain") {
                mainViewState="PGSMain"
                setMainAppScreen("", false)
                bISGoToMainWithBG = true
            }
        }
    }

    Timer {
        id: idTimerPopUpHide
        interval: 3000
        repeat: false
        running: false
        onTriggered: {
            mainViewState="PGSMain"
            setMainAppScreen("", false)
            idMainView.forceActiveFocus()
        }
    }

    Connections {
        target: idPopupMain.item
        onBackFromPopup: {
            mainViewState="PGSMain"
            setMainAppScreen("", false)
        }
    }

    onBeep: {
        UIListener.PlayAudioBeep();
    }

    Connections {
        target: UIListener

        onSignalBGFromUISH: {
            if (mainViewState=="PGSSettingMain") {
                mainViewState="PGSMain"
                setMainAppScreen("", false)
            }
            bISGoToMainWithBG = true;
        }

        onSignalShowShutter: {
            idCameraLoading.visible = true;
            idDHLogo.visible = false;
            focusedToMenu(0);
            //if (decoderWindow.visible) decoderWindow.forceActiveFocus();
        }

        onSignalShowSystemPopup: {
           if (mainViewState=="PopupMain") backFromPopup();
           idAppMain.focus = false;
        }
        onSignalHideSystemPopup: {
            idAppMain.forceActiveFocus();
            focusedToMenu(focusIndexOfMenu);
        }

        onShowLogo: {
            idCameraLoading.visible = false;
            idDHLogo.visible = true;
        }

        onHideLogo: {
            idDHLogo.visible = false;
        }

        onChangePGSViewText: {
            if (bIsSmallFont) { //(pgsToggleViewBtn.txtPaintedWidth > pgsToggleViewBtn.width) {
                pgsMenus.x = 883;
                pgsToggleViewBtn.width = 390;
                pgsToggleViewBtn.firstTextSize = 30;
            }
            else {
                pgsMenus.x = 903;
                pgsToggleViewBtn.width = 370;
                pgsToggleViewBtn.firstTextSize = systemInfo.btnFontSize;
            }
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
                pgsToggleViewBtn.forceActiveFocus();
            }
        }

        Connections {
            target: decoderWindow.item
            onCloseWindow: decoderWindow.visible = false;
        }
    }
    */

    Item {
        id: idShortWideMenu
        visible:  false; focus: false
    }

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
