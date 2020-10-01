/**
 * FileName: DHDABMain.qml
 * Author: DaeHyungE
 * Time: 2012-06-26
 *
 * - 2012-06-26 Initial Crated by HyungE
 */

import Qt 4.7
import "../component/system/DH" as MSystem
import "../component/QML/DH" as MComp
import "../component/DAB/Common" as MDabCommon
import "../component/DAB/JavaScript/DabOperation.js" as MDabOperation
import QmlStatusBar 1.0     

MComp.MAppMain {
    id : idAppMain
    x: 0; y: 0

    MSystem.SystemInfo { id : systemInfo }
    MSystem.ColorInfo { id : colorInfo }
    MDabCommon.ImageInfo { id : imageInfo }
    MDabCommon.StringInfo {id : stringInfo }

    width : systemInfo.lcdWidth
    height : systemInfo.lcdHeight + 93

    property string selectedMainScreen : "DABPlayerMain"
    property string fonts_HDR: "DH_HDR"     //"NewHDR"
    property string fonts_HDB: "DH_HDB"     //"NewHDB"

    //DAB Frequency Info
    property string m_sChannelInfo              : DABListener.m_sChannelInfo;
    property string m_sServiceName              : DABListener.m_sServiceName;
    property string m_sEnsembleName             : DABListener.m_sEnsembleName;
    property string m_sFrequencyID              : DABListener.m_sFrequencyID;
    property int    m_iPS                       : DABListener.m_iPS;
    property int    m_iPresetIndex              : DABListener.m_iPresetIndex;
    property string m_sChannelLogo              : DABListener.m_sChannelLogo;
    property int    m_sPtyName                  : DABListener.m_sPtyName;
    property string m_sDLS                      : DABListener.m_sDLS;
    property string m_sSLS                      : DABListener.m_sSLS;
    property bool   m_bEPG                      : DABListener.m_bEPG;
    property bool   m_bViewMode                 : DABListener.m_bViewMode;
    property int    m_iDABGoodCount             : DABListener.m_iDABGoodCount;
    property int    m_iFMtoDABInterval          : DABListener.m_iFMtoDABInterval;
    property int    m_iReqCountDABtoMicom       : DABListener.m_iReqCountDABtoMicom;
    property int    m_iFMSensitivity            : DABListener.m_iFMSensitivity;
    property double m_iFMFrequency              : DABListener.m_iFMFequency;

    property string m_sTitle                    : DABListener.m_sTitle;
    property string m_sArtist                   : DABListener.m_sArtist;
    property bool   m_bSLSOn                    : DABListener.m_bSlideShowOn;
    property int    m_iServiceFollowing         : DABListener.m_iServiceFollowing;
    property bool   m_bIsServiceNotAvailable    : (DABListener.m_sServiceStatus == "Weak")?true:false;

    property bool   m_bEnsembleSeek             : DABListener.m_bEnsembleSeek;

    // DAB Service Icon
    property bool   m_bDABtoDABOn               : false
    property bool   m_bDABtoFMOn                : false
    property bool   m_bListScanningOn           : DABListener.m_bListScanningOn;
    property bool   m_bPresetScanningOn         : DABListener.m_bPresetScanningOn;

    //QOS Information
    property string m_sControllerStatus         : DABListener.m_sControllerStatus;
    property string m_sModuleStatus             : DABListener.m_sModuleStatus;
    property string m_sServiceStatus            : DABListener.m_sServiceStatus;
    property int    m_iCER                      : DABListener.m_iCER;
    property int    m_iSNR                      : DABListener.m_iSNR;
    property int    m_iRSSI                     : DABListener.m_iRSSI;
    property int    m_iCER_sub                  : DABListener.m_iCER_sub;
    property int    m_iSNR_sub                  : DABListener.m_iSNR_sub;
    property int    m_iRSSI_sub                 : DABListener.m_iRSSI_sub;

    // EPG List
    property string m_sProgramTitle             : ""
    property string m_sProgramdDscription       : ""
    property string m_sProgramTime              : ""
    property string m_sButtonName               : ""
    property string m_sProgramServiceName       : ""
    property int    m_sProgramServiceID         : 0
    property int    m_iHour                     : 0
    property int    m_iMinute                   : 0
    property int    m_iSecond                   : 0
    property int    m_iDuration                 : 0
    property bool   m_bIsPreserve               : false
    property string m_sPreservedProgramTitle    : ""
    property int    m_iPreservedServiceID       : 0
    property string m_sEnsembleNameForEPG       : ""
    property bool   m_sProgramInfo              : false    //#INFO > EPG > Right Program Info  (121227)
    property bool   m_bDupReserveCheck          : false    //#KEH (130108)
    property string m_sSelectEPGDate            : ""       //#KEH (130201)
    property date   m_xCurrentDate

    //Preset List
    property bool   m_bIsSaveAsPreset           : false;

    //Driving Requlation
    property bool   m_bIsDrivingRegulation              : false;

    //Traffic Announcement
    property string m_sAnnouncementServiceName          : ""
    property int    m_sAnnouncementFlags                : 0

    //for Debugging
//    property bool   m_bDebugViewOn                      : false;
    property string m_sPicode                           : DABListener.m_sPicode;
    property string m_serviceID                         : DABListener.m_sServiceID;
    property string m_sServiceEvent                     : DABListener.m_sServiceEvent;
    property string m_sChangeFrequencyID                : DABListener.m_sChangeFrequencyID;
    property int    m_iSignalStatus                     : DABListener.m_iSignalStatus;
    property int    m_iFirstEnsembleCount               : DABListener.m_iFirstEnsembleCount;
    property int    m_iSecondEnsembleCount              : DABListener.m_iSecondEnsembleCount;
    property int    m_iThirdEnsembleCount               : DABListener.m_iThirdEnsembleCount;
    property int    m_iPreserveCount                    : DABListener.m_iPreserveCount;
    property int    m_iAnnounceDeleayTime               : DABListener.m_iAnnounceDeleayTime;
    property int    m_iAnnounceTimeout                  : DABListener.m_iAnnounceTimeout;
    property int    m_iServLinkMuteTimeout              : DABListener.m_iServLinkMuteTimeout;
    property string m_sSystemTime                       : DABListener.m_sSystemTime;

    //for ENG Mode
    property int    m_iBitrate                          : DABListener.m_iBitrate;
    property bool   m_bDebugInfo                        : false

    // ==================================================  Signal QML -> DABController.cpp
    signal cmdReqLongSeekUp();
    signal cmdReqListSelected(int count, string type);
    signal cmdReqScan()
    signal cmdReqPresetScan();
    signal cmdSettingSlideShow(bool isOn);
    signal cmdSettingServiceFollowing(int mode);
    signal cmdSettingBandSelection(int mode);
    signal cmdSettingSaveData();
    signal cmdReqPresetSelected(int count);
    signal cmdAddEPGReservation(date currentDate, string serviceName, int serviceID, string title, string description, int hour, int minute, int second, int duration);
    signal cmdAddRemoveEPGReservation(date currentDate, string serviceName, int serviceID, string title, string description, int hour, int minute, int second, int duration);
    signal cmdReqSetCurrentChannelInfo(int serviceID);
    signal cmdCheckExistServiceID(date currentDate, int serviceID, int hour, int minute, int second);
    signal cmdCancelEPGReservation(bool isSystemPopup);
    signal cmdReqSeekCancel();
    signal cmdSetStationListView(bool status);
    signal cmdReqCancelTrafficAnnouncement(bool onOff);
    signal cmdReqCancelAlarmAnnouncement();


    // ================================================== Signal QML -> DABUIListener.cpp
    signal cmdReqUpdatePresetList(int currIndex, int realIndex);
    signal cmdReqModeChange(bool viewMode);


    // ==================================================  Signal QML -> DABAppEngine.cpp
    signal cmdSoundSetting(bool isJogMode);
    signal cmdReqTAStop();
    signal cmdReqAlarmStop();


    // ==================================================  Signal QML -> QML
    signal reqSortingByEnsemble();
    signal regSortingByAlphabet();
    signal regSortingByPty();
    signal reqEPGListBySelectDate(date selectDate);
    signal optionMenuAllHide();
    signal optionMenuSubOpen();
    signal optionMenuSubClose();
    signal pressCancelSignal();
    signal pressCancelJogSignal();

    function setPreSelectedMainScreen()
    {
        UIListener.pushScreen(idAppMain.state);
    }

    function preSelectedMainScreen()
    {
        return UIListener.popScreen();
    }

    function getCurrentStackCount()
    {
        return UIListener.countScreen();
    }

    function setAppMainScreen(mainScreen, saveCurrentScreen)
    {
        MDabOperation.setPropertyChanges(mainScreen, saveCurrentScreen);
    }

    function gotoBackScreen() {
        UIListener.autoTest_athenaSendObject();
        MDabOperation.backKeyProcessing();
    }

    function gotoMainScreen() {
        for(;idAppMain.state != "DABPlayerMain";)
        {
            gotoBackScreen();
            console.debug("=> idAppMain.state :"+idAppMain.state);
        }
    }

    function gotoStationList() {
        for(;idAppMain.state != "DabStationList";)
        {
            gotoBackScreen();
            console.debug("=> idAppMain.state :"+idAppMain.state);
        }
    }

    // Backgraound==============================
    Image {
        x : 0
        y : 0//-systemInfo.statusBarHeight
        source : imageInfo.imgBg_Main
    }

    Item {
        id : idDabMainArea
        x : 0
        y : systemInfo.statusBarHeight
        Loader { id : idDabPlayerMain; visible : false }
        Loader { id : idDabStationList; visible : false }
        Loader { id : idDabPlayerOptionMenu; visible : false }
        Loader { id : idDabStationListMainMenu; visible : false }
        Loader { id : idDabStationListSubMenu; visible : false }
        Loader { id : idDabInfoDLSMain; visible : false }
        Loader { id : idDabInfoSLSMain; visible : false }
        Loader { id : idDabInfoEPGMain; visible : false }
        Loader { id : idDabSetting; visible : false }
        Loader { id : idDabPresetList; visible : false }
        Loader { id : idDabENGModeMain; visible : false }
        Loader { id : idDabENGDealerMode; visible : false }
    } 

    //======================================= StatusBar 
    QmlStatusBar {
        id: statusBar
        x: 0; y: 0
        width: 1280; height: 93
        homeType: "button"        // "none", "button", "text"
        middleEast: false
    }

    Item {
        id : idDabPopup
        x : 0
        y : systemInfo.statusBarHeight
        Loader { id : idDabInfoEPGDescPopup; visible : false }
        Loader { id : idDabInfoEPGPreservePopup; visible : false }
        Loader { id : idDabInfoEPGPreserveFullPopup; visible : false }
        Loader { id : idDabPresetSavedPopup; visible : false }
        Loader { id : idDabInfoEPGDateListPopup; visible : false }
        Loader { id : idDabTAPopup; visible : false }
        Loader { id : idDabInfoEPGPreserveOffAirPopup; visible : false }
    }

    onBeep : {
        console.log("[QML] DHDABMain.qml : onBeep...");
        UIListener.playAudioBeep();
    }

    Component.onCompleted : {
        console.log("[QML] DHDABMain.qml : onCompleted...");
        setAppMainScreen(selectedMainScreen, false);
        UIListener.autoTest_athenaSendObject();
    }

    //======================================= Event From DABAppEnginge
    Connections {
        target : UIListener
        onReqForegroundFromUISH : {
            console.log("[QML] ==> Connections : DHDABMain.qml : onRegForegroundFromUISH : idAppMain.state :"+idAppMain.state + ", bTemporalMode = " + bTemporalMode);
            if(bTemporalMode == false) gotoMainScreen()          
        }

        onDrivingRegulation : {
            console.log("[QML] ==> Connections : DHDABMain.qml : onDrivingRegulation : onOff = " + onOff);
            m_bIsDrivingRegulation = onOff;
        }

        onRetranslateUi: {
            console.log("[QML] ==> Connections : DHDABMain.qml : retranslateUi : " + languageId);
            stringInfo.retranslateUi(languageId);
            LocTrigger.retrigger();
        }

        onSignalShowSystemPopup : {
            console.log("[QML] ==> Connections : DHDABMain.qml : onSignalShowSystemPopup");
            idAppMain.focusOn = false;
        }

        onSignalHideSystemPopup : {
            console.log("[QML] ==> Connections : DHDABMain.qml : onSignalHideSystemPopup");
            idAppMain.focusOn = true;
        }

        onGotoMainScreen :{
            console.log(" [QML] ==> Connections : DHDABMain.qml : onGotoMainScreen");
            gotoMainScreen();
        }

        onDisplayTAPopup :{
            console.log(" [QML] ==> Connections : DHDABMain.qml : onDisplayTAPopup : serviceName = "+ serviceName + ", flags = " + flags + ", onOff = " + onOff + ", idDabTAPopup.visible = " + idDabTAPopup.visible);
            if(onOff)
            {
                if(! idDabTAPopup.visible){
                    m_sAnnouncementServiceName = serviceName;
                    m_sAnnouncementFlags = flags;
                    setAppMainScreen("DabTAPopup", true);
                }
            }
            else if(idDabTAPopup.visible)
            {
                gotoBackScreen();
            }
        }

        onReqStationListFromVR:{
            console.log(" [QML] ==> Connections : DHDABMain.qml : onReqStationListFromVR");
            setAppMainScreen("DabStationList", false);
        }

        onDabEngineerMode:{
            console.log(" [QML] ==> Connections : DHDABMain.qml : onDabEngineerMode");
            setAppMainScreen("DabENGMode", true)
        }

        onDabDealerMode:{
            console.log(" [QML] ==> Connections : DHDABMain.qml : onDabDealerMode");
            setAppMainScreen("DabENGDealerMode", true)
        }
    }
    // mseok.lee
    Connections {
        target : AppComUIListener
        onRetranslateUi: {
            console.log("[QML] ==> Connections : DHDABMain.qml : AppComUIListener::retranslateUi : " + languageId);
            stringInfo.retranslateUi(languageId);
            LocTrigger.retrigger();
        }

        onDrivingRegulation : {
            console.log("[QML] ==> Connections : DHDABMain.qml : AppComUIListener::onDrivingRegulation : onOff = " + onOff);
            m_bIsDrivingRegulation = onOff;
        }

        onReqStationListFromVR:{
            console.log(" [QML] ==> Connections : DHDABMain.qml : AppComUIListener::onReqStationListFromVR");
            setAppMainScreen("DabStationList", false);
        }

        onDisplayTAPopup :{
            console.log(" [QML] ==> Connections : DHDABMain.qml : AppComUIListener::onDisplayTAPopup : serviceName = "+ serviceName + ", flags = " + flags + ", onOff = " + onOff + ", idDabTAPopup.visible = " + idDabTAPopup.visible);
            if(onOff)
            {
                if(! idDabTAPopup.visible){
                    m_sAnnouncementServiceName = serviceName;
                    m_sAnnouncementFlags = flags;
                    setAppMainScreen("DabTAPopup", true);
                }
            }
            else if(idDabTAPopup.visible)
            {
                gotoBackScreen();
            }
        }
    }

    Connections {
        target : AppUIListener
        onDisplayTAPopup :{
            console.log(" [QML] ==> Connections : DHDABMain.qml : AppUIListener::onDisplayTAPopup : serviceName = "+ serviceName + ", flags = " + flags + ", onOff = " + onOff + ", idDabTAPopup.visible = " + idDabTAPopup.visible);
            if(onOff)
            {
                if(! idDabTAPopup.visible){
                    m_sAnnouncementServiceName = serviceName;
                    m_sAnnouncementFlags = flags;
                    setAppMainScreen("DabTAPopup", true);
                }
            }
            else if(idDabTAPopup.visible)
            {
                gotoBackScreen();
            }
        }
    }

    Connections {
        target : DABControllerThird
        onCloseOptionMenu: {
            console.log("[QML] ==> Connections : DHDABMain.qml : DABControllerThird::onCloseOptionMenu :: idAppMain.state = " + idAppMain.state );
            if(idAppMain.state == "DabStationListMainMenu" || idAppMain.state == "DabPlayerOptionMenu" || idAppMain.state == "DabStationListSubMenu")
            {
                idAppMain.optionMenuAllHide();
            }
        }

        onDisplayLinkingIcon : {
            console.log("[QML] ==> Connections : DHDABMain.qml : DABControllerThird::onDisplayLinkingIcon : isDABtoDAB = " + isDABtoDAB + " isDABtoFM = " + isDABtoFM + " isSearching = " + isSearching);
            m_bDABtoDABOn  = isDABtoDAB;
            m_bDABtoFMOn = isDABtoFM;
        }
    }

    Connections {
        target : DABController
        onDisplayLinkingIcon : {
            console.log("[QML] ==> Connections : DHDABMain.qml : onDisplayLinkingIcon : isDABtoDAB = " + isDABtoDAB + " isDABtoFM = " + isDABtoFM + " isSearching = " + isSearching);
            m_bDABtoDABOn  = isDABtoDAB;
            m_bDABtoFMOn = isDABtoFM;
        }

        onAlreadyPreserved : {
            console.log("[QML] ==> Connections : DHDABMain.qml : onAlreadyPreserved ");
            m_sButtonName = stringInfo.strEPGPopup_Cancel;
        }

        onCloseOptionMenu: {
            console.log("[QML] ==> Connections : DHDABMain.qml : onCloseOptionMenu :: idAppMain.state = " + idAppMain.state );
            if(idAppMain.state == "DabStationListMainMenu" || idAppMain.state == "DabPlayerOptionMenu" || idAppMain.state == "DabStationListSubMenu")
            {
                idAppMain.optionMenuAllHide();
            }
        }
    }

    //    =======================================for Debugging
    Rectangle {
        id : idDebugInfoView
        z : 200
        y : 90

        Column {
            id : idDebugInfo1
            x : 50
            y : 70
            Text{text: "[Module Version]"; color: "yellow"; font.pixelSize:20;}
            Text{text: "Bootloader: " + DABListener.m_sBootloaderVer;    color : "white"; font.pixelSize:20;}
            Text{text: "Kernel: " + DABListener.m_sKernelVer;    color : "white"; font.pixelSize:20;}
            Text{text: "Application: " + DABListener.m_sApplicationVer;    color : "white"; font.pixelSize:20;}
            Text{text: "Booting Count: " + DABListener.m_iBootCount;    color : "white"; font.pixelSize:20;}
            Text{text: "[DAB Version]"; color: "yellow"; font.pixelSize:20;}
            Text{text: "Build Version : " + UIListener.m_APP_VERSION;    color : "white"; font.pixelSize:20;}
            Text{text: "Build Date : " + UIListener.m_BUILDDATE;    color : "white"; font.pixelSize:20;}
        }

        Column {
            id : idDebugInfo2
            x : 50
            y : 350
            Text{text: "[QOS Infomation]"; color: "yellow"; font.pixelSize:20;}
            Text{text: "MAIN_CER  : " + MDabOperation.checkCER(m_iCER);color : "white"; font.pixelSize:20;}
            Text{text: "MAIN_SNR  : " + MDabOperation.checSNR(m_iSNR);color : "white"; font.pixelSize:20;}
            Text{text: "MAIN_RSSI : " + MDabOperation.checRSSI(m_iRSSI);color : "white"; font.pixelSize:20;}
            Text{text: "SUB_CER   : " + MDabOperation.checkCERSub(m_iCER_sub);color : "white"; font.pixelSize:20;}
            Text{text: "SUB_SNR   : " + MDabOperation.checSNRSub(m_iSNR_sub);color : "white"; font.pixelSize:20;}
            Text{text: "SUB_RSSI  : " + MDabOperation.checRSSISub(m_iRSSI_sub);color : "white"; font.pixelSize:20;}
            Text{text: "DAB Time : " + m_sSystemTime; color: "yellow"; font.pixelSize:20;}
        }

        Column {
            id : idDebugInfo3
            x : 900
            y : 70
            Text{text: "[Controller Infomation]"; color: "yellow"; font.pixelSize:20;}
            Text{text: "Statue : " + m_sControllerStatus;color : "white"; font.pixelSize:20;}
            Text{text: "Module : " + m_sModuleStatus;color : "white"; font.pixelSize:20;}
            Text{text: "Service : " + MDabOperation.checkService(m_sServiceStatus); color : "white"; font.pixelSize:20;}
            Text{text: "Frequency : " + m_sFrequencyID;color : "white"; font.pixelSize:20;}
            Text{text: "PS        : " + MDabOperation.checkPrimaryService(m_iPS); color : "white";font.pixelSize:20;}
            Text{text: "ServiceID : 0x" + m_serviceID; color : "white"; font.pixelSize:20;}
            Text{text: "EVENT : " + m_sServiceEvent; color : "white"; font.pixelSize:20;}
            Text{text: "DAB-DAB : [" + m_sFrequencyID + "] => [" + m_sChangeFrequencyID + "]"; color : "white";font.pixelSize:20;}
            Text{text: "SignalStatus : " + MDabOperation.checkSignalStatus(m_iSignalStatus); color : "white";font.pixelSize:20;}
            Text{text: "ListCount : [" + m_iThirdEnsembleCount + "] => [" + m_iSecondEnsembleCount + "] => [" + m_iFirstEnsembleCount + "]";color : "white";font.pixelSize:20;}
            Text{text: "ServiceFollowing : " + MDabOperation.checkServiceFolloingStatus(m_iServiceFollowing); color: "white"; font.pixelSize:20;}
            Text{text: "mode      : " + MDabOperation.checkMode(m_bViewMode); color : "white";font.pixelSize:20;}
            Text{text: "GoodCount : " + MDabOperation.checkGoodCount(m_iDABGoodCount); color : "white";font.pixelSize:20;}
            Text{text: "Good Interval : " + MDabOperation.checkIntervalCount(m_iFMtoDABInterval); color : "white";font.pixelSize:20;}
            Text{text: "Request Micom Count : " + MDabOperation.checkReqMicomCount(m_iReqCountDABtoMicom); color : "white";font.pixelSize:20;}
            Text{text: "FM Sensitivity : " + MDabOperation.checkFMSensitivity(m_iFMSensitivity); color : "white";font.pixelSize:20;}
            Text{text: "FM Frequency : " + m_iFMFrequency; color : "white";font.pixelSize:20;}
            Text{text: "FM PICode : 0x" + m_sPicode; color : "white";font.pixelSize:20;}
        }

        Rectangle{
            id:idDebugInfo1Back
            anchors.fill:idDebugInfoView;
            color:"black"
            opacity:0.5
            z: idDebugInfo1.z-1;
            visible:idDebugInfoView.visible
        }

//        visible:m_bDebugViewOn
        visible: idAppMain.m_bDebugInfo
    }
}
