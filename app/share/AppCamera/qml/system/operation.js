function setMainScreen(screenName, save) {
    if (screenName==idAppMain.state) {
        return;
    }
    else
        switch(save) {
        case true:
            switch(idAppMain.state) {
            case "AVMSettingMain": idAVMSettingMain.visible = false; break;
            case "PopupMain": idPopupMain.visible = false; break;
            case "AVMCalibCmd": idAVMCalibCmd.visible = false; break;
            case "PGSSettingMain": idPGSSettingMain.visible = false; break;
            case "AVMCalibInitMenu": idAVMCalibInitMenu.visible = false; break;
            }
            idMainView.forceActiveFocus()
            break;

        case false:
            switch(idAppMain.state) {
            case "AVMSettingMain": idAVMSettingMain.source="" ;break;
            case "PopupMain": idPopupMain.source = ""; break;
            case "AVMCalibCmd": idAVMCalibCmd.source = ""; break;
            case "PGSSettingMain": idPGSSettingMain.source = ""; break;
            case "AVMCalibInitMenu": idAVMCalibInitMenu.source = ""; break;
            }
            idMainView.forceActiveFocus()
        }

        switch(screenName) {
        case "AVMSettingMain":
            idAVMSettingMain.visible = true
            idAVMSettingMain.forceActiveFocus();
            if (idAVMSettingMain.status == Loader.Null)
                idAVMSettingMain.source = (cppToqml.IsDHPE)? "AVMSettings_2section.qml" : "AVMSettings.qml"
            break;
        case "PopupMain":
            idPopupMain.visible = true
            idPopupMain.forceActiveFocus();
            if (idPopupMain.status == Loader.Null)
                idPopupMain.source = "./component/Popup.qml"
            break;
        case "AVMCalibCmd":
            idAVMCalibCmd.visible = true;
            idAVMCalibCmd.forceActiveFocus();
            if (idAVMCalibCmd.status == Loader.Null)
                idAVMCalibCmd.source = "./component/AVMCalibCmd.qml"
            break;
        case "PGSSettingMain":
            idPGSSettingMain.visible = true;
            idPGSSettingMain.forceActiveFocus();
            if (idPGSSettingMain.status == Loader.Null)
                idPGSSettingMain.source = "PGSSettings.qml"
            break;
        case "AVMCalibInitMenu":
            idAVMCalibInitMenu.visible = true;
            idAVMCalibInitMenu.forceActiveFocus();
            if (idAVMCalibInitMenu.status == Loader.Null)
                idAVMCalibInitMenu.source = "./component/AVMCalibInitMenu.qml"
        }
        idAppMain.state = screenName
        UIListener.SendAutoTestSignal(); //For AutoTest
    }
//Menu Screen Operation
function setRightMain(index, save)
{
    if (save) {
        if (index==0) {
            idInitFrontViewLoader.visible = false;
            idInitRearViewLoader.visible = false;
            idGeneralLoader.visible = true;
            if (idGeneralLoader.status == Loader.Null) {
                idGeneralLoader.source = "./component/AVMSetting_General.qml"
            }
        }
        else if (index==1) {
            idGeneralLoader.visible = false;
            idInitRearViewLoader.visible = false;
            idInitFrontViewLoader.visible = true;
            if (idInitFrontViewLoader.status == Loader.Null) {
                idInitFrontViewLoader.source = (cppToqml.IsDHPE)? "./component/AVMSetting_FrontInitView2.qml" : "./component/AVMSetting_FrontInitView.qml"
            }
        }
        else if (index==2) {
            idGeneralLoader.visible = false;
            idInitFrontViewLoader.visible = false;
            idInitRearViewLoader.visible = true;
            if (idInitRearViewLoader.status == Loader.Null) {
                idInitRearViewLoader.source = "./component/AVMSetting_RearInitView.qml"
            }
        }
    }
    else {
        if (index==0) {
            idInitFrontViewLoader.source = "";
            idInitRearViewLoader.source = "";
            if (idGeneralLoader.status == Loader.Null) {
                idGeneralLoader.source = "./component/AVMSetting_General.qml"
            }
        }
        else if (index==1) {
            idGeneralLoader.source = "";
            idInitRearViewLoader.source = "";
            if (idInitFrontViewLoader.status == Loader.Null) {
                idInitFrontViewLoader.source = (cppToqml.IsDHPE)? "./component/AVMSetting_FrontInitView2.qml" : "./component/AVMSetting_FrontInitView.qml"
            }
        }
        else if (index==2) {
            idGeneralLoader.source = "";
            idInitFrontViewLoader.source = "";
            if (idInitRearViewLoader.status == Loader.Null) {
                idInitRearViewLoader.source = "./component/AVMSetting_RearInitView.qml"
            }
        }
    }

    idAVMSettingLeftList.forceActiveFocus();
    idAVMSettingMain.state = index
    UIListener.SendAutoTestSignal(); //For AutoTest
}

function setRightMainFocus(index) {
    if (index==0) idGeneralLoader.forceActiveFocus();
    else if (index==1) idInitFrontViewLoader.forceActiveFocus();
    else if (index==2) idInitRearViewLoader.forceActiveFocus();
}

function setAVMMainFocus(wasFromSetting) {
    //console.log("setAVMMainFocus, canDB.AVM_View:" + canDB.AVM_View);
    if (wasFromSetting) {
        avmViewSettingBtn.forceActiveFocus();
        return;
    }
    else if (canDB.AVM_View == 8 || canDB.AVM_View == 9) avmViewWideBtn.forceActiveFocus();
    else if (canDB.AVM_View == 4 || canDB.AVM_View == 5) avmViewLeftBtn.forceActiveFocus();
    else if (canDB.AVM_View == 6 || canDB.AVM_View == 7) avmViewRightBtn.forceActiveFocus();
    else avmViewAroundBtn.forceActiveFocus();
}

//only for DH_PE
function setAVMMainFocus2(wasFromSetting) {
    //console.log("setAVMMainFocus, canDB.AVM_View:" + canDB.AVM_View);
    if (wasFromSetting) {
        avmViewSettingBtn.forceActiveFocus();
        return;
    }
    else if (canDB.AVM_View == 8 || canDB.AVM_View == 9) avmViewWideBtn.forceActiveFocus();
    else if (canDB.AVM_View == 4 || canDB.AVM_View == 5) avmViewLeftBtn.forceActiveFocus();
    else if (canDB.AVM_View == 6 || canDB.AVM_View == 7) avmViewRightBtn.forceActiveFocus();
    else if (canDB.AVM_View == 19) avmFront2SectionBtn.forceActiveFocus();
    else avmViewAroundBtn.forceActiveFocus();
}

function toggleWideMenus(toWide) {
    if (toWide) {
        idMenuTimer.stop();
        mainScreen.width = 1262;
        idAlertItem.width = 1262;
        avmMenus.width = 1262;
        //idAVMMenusRow.spacing = 8;
        avmMenuBtnWidth = 246;
        avmMenuFgImgX = 43;
        //avmMenus.x = 9;
        idAVMMenusRow.spacing = 8;

        btnImageSrc_n = systemInfo.imageInternal+"btn_camera_s_n.png"
        btnImageSrc_p = systemInfo.imageInternal+"btn_camera_s_p.png"
        btnImageSrc_f = systemInfo.imageInternal+"btn_camera_s_f.png"
        btnImageSrc_s = systemInfo.imageInternal+"btn_camera_s_s.png"

        idMenuTimer.start();
    }
    else {
        idMenuTimer.stop();

        //idAVMMenusRow.spacing = 8;
        mainScreen.width = 790;
        idAlertItem.width = 790;
        avmMenus.width = 790;
        avmMenuBtnWidth = 154;
        avmMenuFgImgX = 0;
        //avmMenus.x = 11;
        idAVMMenusRow.spacing = 5;

        btnImageSrc_n = systemInfo.imageInternal+"btn_camera_m_n.png"
        btnImageSrc_p = systemInfo.imageInternal+"btn_camera_m_p.png"
        btnImageSrc_f = systemInfo.imageInternal+"btn_camera_m_f.png"
        btnImageSrc_s = systemInfo.imageInternal+"btn_camera_m_s.png"
    }
}

//only for DH_PE
function toggleWideMenus2(toWide) {
    if (toWide==1) {
        idMenuTimer.stop();
        mainScreen.width = 1262;
        idAlertItem.width = 1262;
        avmMenus.width = 1262;
        //idAVMMenusRow.spacing = 8;
        avmMenuBtnWidth = 246;
        avmMenuFgImgX = 46;//43;
        //avmMenus.x = 9;
        idAVMMenusRow.spacing = 8;

        btnImageSrc_n = systemInfo.imageInternal+"btn_camera_s_n.png"
        btnImageSrc_p = systemInfo.imageInternal+"btn_camera_s_p.png"
        btnImageSrc_f = systemInfo.imageInternal+"btn_camera_s_f.png"
        btnImageSrc_s = systemInfo.imageInternal+"btn_camera_s_s.png"

        idMenuTimer.start();
    }
    else if (toWide==2) {
        idMenuTimer.stop();
        mainScreen.width = 1262;
        idAlertItem.width = 1262;
        avmMenus.width = 1262;
        //idAVMMenusRow.spacing = 8;
        avmMenuBtnWidth = 202;
        avmMenuFgImgX = 0;
        //avmMenus.x = 9;
        idAVMMenusRow.spacing = 8;

        btnImageSrc_n = systemInfo.imageInternal+"btn_camera_03_n.png"
        btnImageSrc_p = systemInfo.imageInternal+"btn_camera_03_p.png"
        btnImageSrc_f = systemInfo.imageInternal+"btn_camera_03_f.png"
        btnImageSrc_s = systemInfo.imageInternal+"btn_camera_03_s.png"

        idMenuTimer.start();
    }
    else if (toWide==0)  {
        idMenuTimer.stop();
        //idAVMMenusRow.spacing = 8;
        mainScreen.width = 790;
        idAlertItem.width = 790;
        avmMenus.width = 790;

        avmMenuBtnWidth = 154;
        avmMenuFgImgX = 0;
        //avmMenus.x = 11;
        idAVMMenusRow.spacing = 5;

        btnImageSrc_n = systemInfo.imageInternal+"btn_camera_m_n.png"
        btnImageSrc_p = systemInfo.imageInternal+"btn_camera_m_p.png"
        btnImageSrc_f = systemInfo.imageInternal+"btn_camera_m_f.png"
        btnImageSrc_s = systemInfo.imageInternal+"btn_camera_m_s.png"
    }
    else { //3
        idMenuTimer.stop();
        //idAVMMenusRow.spacing = 8;
        mainScreen.width = 790;
        idAlertItem.width = 790;
        avmMenus.width = 790;

        avmMenuBtnWidth = 125;
        avmMenuFgImgX = 0;
        //avmMenus.x = 11;
        idAVMMenusRow.spacing = 8;

        btnImageSrc_n = systemInfo.imageInternal+"btn_camera_01_n.png"
        btnImageSrc_p = systemInfo.imageInternal+"btn_camera_01_p.png"
        btnImageSrc_f = systemInfo.imageInternal+"btn_camera_01_f.png"
        btnImageSrc_s = systemInfo.imageInternal+"btn_camera_01_s.png"
    }
}
