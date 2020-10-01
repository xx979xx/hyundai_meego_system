import Qt 4.7

//System Import
import "../component/system/DH" as MSystem
import "../component/QML/DH" as MComp
//Local Import
import "../component/XM/common" as XMCommon
import "../component/XM/JavaScript/Operation.js" as MOperation
import "../component/XM/JavaScript/XMAudioOperation.js" as XMOperation
import QmlStatusBar 1.0

//Apply MAppMain - 2012.03.08
MComp.MAppMain {
    id: idAppMain
    x: 0; y: 0
    width:systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    XMCommon.StringInfo { id: stringInfo }

    //****************************** # First Main Screen #
    function currentAppStateID() { return MOperation.currentStateID(); }
    function preSelectedMainScreen() { return UIListener.popScreen(); }
    function setPreSelectedMainScreen() { UIListener.pushScreen(idAppMain.state); }
    function setAppMainScreen(mainScreen, saveCurrentScreen) { MOperation.setPropertyChanges(mainScreen, saveCurrentScreen); }
    function gotoHomeScreen() {UIListener.HandleHomeKey(); }
    function gotoFirstScreen() {MOperation.toFirstScreen(); }
    function closePopupAndOptionMenu() {MOperation.closePopupAndOptionMenu(); }
    function gotoBackScreen(bTouchBack) { MOperation.backKeyProcessing(bTouchBack); }

    property string selectedMainScreen: "AppRadioMain"
    property string prevScreeID : ""
    property string preMainScreen: ""
    property bool isFullScreen: false
    property bool gDriverRestriction: false

    property int    gCategoryIndex : 0
    property int    gChannelIndex : 0
    property int    gChannelSelectIndex : 0
    property int    gLeagueAlertIndex : 0
    property int    gTeamIndex : 0
    property int    gTeamAlertIndex : 0
    property bool   gTeamCheck : false
    property int    gFavoriteSongIndex : 0
    property int    gFavoriteArtistIndex : 0
    property int    gFavoriteDeleteIndex : 0
    property int    gGameZoneIndex : 0
    property int    gEPGCategoryIndex : 0
    property int    gEPGChannelIndex : 0
    property int    gEPGProgramIndex : 0
    property int    gListSkipIndex : 0
    property int    gGameZoneCatIndex : 0
    property int    gGameZoneChnIndex : 0
    property int    gFFavoritesBandIndex : 0
    property int    gFFavoritesBandContIndex : 0
    property bool   isSettings : false
    property int    sxm_list_skipcount : 0
    property string sxm_list_currcat : stringInfo.sSTR_XMRADIO_All_CHANNELS
    property bool   isDragByTouch : false
    property bool isSkipChannelListEmpty: false

    property string gSXMMode                : "LiveMode"    //"InstantReplay"
    property string gSXMPlayMode            : "Play"        //"Pause"
    property string gSXMScan                : "Normal"      //"Scan"
    property string gSXMPresetScan          : "Normal"      //"PresetScan"
    property string gSXMSetTeam             : "LEAGUE"      //"TEAM"
    property string gSXMSetTeamAlert        : "ALERT"       //"TEAMCHECK"
    property string gSXMFavoriteList        : "SONG"        //"ARTIST"
    property string gSXMFavoriteDelete      : "LIST"        //"DELETE"
    property string gSXMEPGMode             : "PROGRAM"     //"CATEGORY"
    property string gSXMENGMode             : "ENGNORMAL"   //"ENGDATA"
    property string gSXMListMode            : "LIST"        //"SKIP"
    property string gSXMSaveAsPreset        : "FALSE"       //"TRUE"
    property string gSXMEditPresetOrder     : "FALSE"       //"TRUE"
    property string gSXMFavoirtesBand       : "song"        //"artist"

    //****************************** # Signal for OptionMenu Open/Close #
    signal optionMenuAllHide();
    signal optionMenuAllOff();
    signal optionMenuSubOpen();
    signal optionMenuSubClose();
    signal presetOrderDisabled();
    signal presetOrderDisabledByBackKey();
    signal presetOrderDisabledAndChangeOrder();
    signal selectAll();
    signal selectAllcancelandok();
    signal categoryLockClicked();
    signal alertcheckimagesiganl(int selectedIndex);
    signal disableInteractive();
    signal presetScanFont();
    signal cancelInstantBtnImag();
    signal checkInstantPlayStausMenu();
    signal releaseTouchPressed();
    signal pressAndHoldResetFlag();
    signal downKeyLongListDownOperation(bool bDownLong);

    Connections{
        target: UIListener
        onRetranslateUi: {
            LocTrigger.retrigger();
            stringInfo.retranslateUi();
        }
        onScanTimerStop: {
            console.log("scanTimerStop - emit receive");
            XMOperation.scanTimerStop();
        }
        onEngineeringModeDynamics: {
            console.log("engineeringModeDynamics - emit receive");
            XMOperation.engineeringModeDynamics(b_status);
        }
        onDealerModeDynamics: {
            console.log("onDealerModeDynamics - emit receive");
            XMOperation.dealerModeDynamics(b_status);
        }
        onTagStatusChanged: {
            console.log("tagStatusChanged - emit receive");
            idAppMain.optionMenuAllOff();
            XMOperation.tagStatusChanged(m_status, filecount);
        }
        onInstantReplayWarning: {
            console.log("instantReplayWarning - emit receive");
            XMOperation.instantReplayWarning();
        }
        onSxmDataRequestToGameZone: {
            console.log("sxmDataRequestToGameZone - emit receive");
            XMOperation.sxmDataRequestToGameZone();
        }
        onGotoFirstScreen: {
            console.log("gotoFirstScreen - emit receive");
            idAppMain.gotoFirstScreen();
        }
        onSetPreviousPresetSaveAndOrderStop: {
            console.log("setPreviousPresetSaveAndOrderStop - emit receive");
            XMOperation.setPreviousPresetSaveAndOrderStop();
            idAppMain.presetOrderDisabled();
        }
        onClosePopupAndOptionMenu: {
            console.log("closePopupAndOptionMenu - emit receive");
            idAppMain.closePopupAndOptionMenu();
        }
        onSetFocusToXMAudioList:{
            console.log("onSetFocusToXMAudioList");
            MOperation.setFocusToXMAudioList();
        }
        onPopupXMSubscriptionUpdated: {
            idAppMain.closePopupAndOptionMenu();
            XMOperation.popupXMSubscriptionUpdated();
        }
        onSetTeamCheckInvalid: {
            console.log("Set Team Check Invalid");
            XMOperation.setTeamCheckInvalid(szTeamName);
        }
        onBtConnectStatus: {
            console.log("BT Connect Status Changed");
            XMOperation.btConnectStatus(b_status);
        }
        onCategoryLockClicked: {
            console.log("Category Lock Clicked");
            idAppMain.categoryLockClicked();
        }
        onSetAdvisoryMessage: {
            console.log("Set Advisory Message");
            XMOperation.setAdvisoryMessage(szChnNum);
        }

        //System Popup Focus issue
        onSignalShowSystemPopup:{
            console.log("signalShowSystemPopup ############################## : "+ idAppMain.state+" "+idAppMain.focusOn+" "+idRadioMain.focus+" "+idRadioMain.activeFocus);

            if(idRadioMain.focus == false){
                if (idAppMain.state == "AppRadioMain") {
                    idRadioMain.forceActiveFocus();
                }
            }

            if (idAppMain.state == "PopupDRSWarning1Line") {
                idAppMain.gotoFirstScreen();
            }

            idAppMain.closePopupAndOptionMenu();
            idAppMain.focusOn = false;
            idAppMain.presetScanFont();

            if(idAppMain.gSXMEditPresetOrder == "TRUE")
                idAppMain.presetOrderDisabledAndChangeOrder();
        }
        onSignalHideSystemPopup:{
            console.log("signalHideSystemPopup @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ : "+ idAppMain.state+" "+idAppMain.focusOn+" "+idRadioMain.focus+" "+idRadioMain.activeFocus);

            idAppMain.focusOn = true;
            idAppMain.presetScanFont();
        }
        onSetHideSystemPopup:{
            console.log("setHideSystemPopup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% : "+ idAppMain.state+" "+idAppMain.focusOn+" "+idRadioMain.focus);

            if(idAppMain.focusOn == false)
            {
                idAppMain.focusOn = true;
                idAppMain.presetScanFont();
            }
        }

        //Driver Restriction
        onDriverRestrictionFlag: {
            idAppMain.gDriverRestriction = bDriverRestriction;
            console.log("XMAudioGameZone:: driverRestrictionFlag = "+bDriverRestriction+" idAppMain.state="+idAppMain.state);

            if (bDriverRestriction)
            {
                if ( (idAppMain.state == "AppRadioGameZone") || (idAppMain.state == "AppRadioGameSet") || (idAppMain.state == "AppRadioGameActive") ||
                        ((idRadioGameSet.visible == true) && ((idAppMain.state == "PopupRadioWarning1Line") || (idAppMain.state == "PopupRadioWarning2Line"))) )
                {
                    // Local Popup check
                    if(idAppMain.state == "PopupRadioWarning1Line" || idAppMain.state == "PopupRadioWarning2Line")
                        idAppMain.closePopupAndOptionMenu();

                    // System Popup check
                    //                    if(UIListener.HandleGetShowPopupFlag() == true)
                    //                        UIListener.HandleSystemPopupClose();
                }
            }
        }
    }

    //****************************** # Background Image #
    Image{
        x: 0
        y: 0
        source: imageInfo.imgFolderGeneral+"bg_main.png"
    }

    QmlStatusBar {
        id: statusBar
        x: 0; y: 0//-systemInfo.statusBarHeight;
        width: 1280; height: 93
        homeType: "button"
        middleEast: false
        visible: isFullScreen?false:true
    }

    //****************************** # APP LOADER #
    Item{
        id: idSXMRadioMainArea
        x: 0
        y: systemInfo.statusBarHeight

        /* Main and Sub-Main */
        Loader {id: idRadioMain}
        Loader {id: idRadioList}
        Loader {id: idRadioSearch}
        Loader {id: idRadioGameZone}
        Loader {id: idRadioFavorite}
        Loader {id: idRadioGameSet}
        Loader {id: idRadioGameActive}
        Loader {id: idRadioEPG}
        Loader {id: idRadioFeaturedFavorites}
        Loader {id: idRadioEngineering}
        Loader {id: idRadioDealerMode}
        Loader {id: idRadioFavoriteActive}
    }

    Item {
        id: idSXMRadioPopupArea
        x: 0
        y: systemInfo.statusBarHeight

        /* PopUp */
        Loader {id: idRadioPopupAddToFavorite}
        Loader {id: idRadioPopupDim1Line}
        Loader {id: idRadioPopupDim2Line}
        Loader {id: idRadioPopupDim1Line5Second}
        Loader {id: idRadioPopupWarning1Line}
        Loader {id: idRadioPopupWarning2Line}
        Loader {id: idRadioPopupDRSWarning1Line}
        Loader {id: idRadioPopupIRWarning2Line}
        Loader {id: idRadioPopupMsg1Line}
        Loader {id: idRadioPopupAlert}
        Loader {id: idRadioPopupEPGInfo2Btn}
        Loader {id: idRadioPopupEPGInfo3Btn}
        Loader {id: idRadioPopupSubscriptionStatus}
        Loader {id: idRadioPopupEPGInfoPreservedProgram}
        Loader {id: idRadioPopupAdvisory1Line}
    }

    Item {
        id: idSXMRadioOptionMenu
        x: 0
        y: systemInfo.statusBarHeight

        /* Option Menu */
        Loader {id: idRadioOptionMenu}
        Loader {id: idRadioOptionMenuSub}
        Loader {id: idRadioDeleteMenu}
        Loader {id: idRadioCancelMenu}
        Loader {id: idRadioListMenu}
        Loader {id: idRadioEPGMenu}
    }

    //****************************** # Loading completed (First Focus) #
    Component.onCompleted:{
        setAppMainScreen(selectedMainScreen, true);
    }

    onStateChanged: {
        UIListener.autoTest_athenaSendObject();

        switch(idAppMain.state){
            /* Main and Sub-Main */
        case "AppRadioMain":                    idRadioMain.forceActiveFocus(); break;
        case "AppRadioList":                    idRadioList.forceActiveFocus(); break;
        case "AppRadioSearch":                  idRadioSearch.forceActiveFocus(); break;
        case "AppRadioGameZone":                idRadioGameZone.forceActiveFocus(); break;
        case "AppRadioFavorite":                idRadioFavorite.forceActiveFocus(); break;
        case "AppRadioGameSet":                 idRadioGameSet.forceActiveFocus(); break;
        case "AppRadioGameActive":              idRadioGameActive.forceActiveFocus(); break;
        case "AppRadioEPG":                     idRadioEPG.forceActiveFocus(); break;
        case "AppRadioFeaturedFavorites":       idRadioFeaturedFavorites.forceActiveFocus(); break;
        case "AppRadioEngineering":             idRadioEngineering.forceActiveFocus(); break;
        case "AppRadioDealerMode":              idRadioDealerMode.forceActiveFocus(); break;
        case "AppRadioFavoriteActive":          idRadioFavoriteActive.forceActiveFocus(); break;
            /* PopUp */
        case "PopupRadioAddToFavorite":         idRadioPopupAddToFavorite.forceActiveFocus(); break;
        case "PopupRadioDim1Line":              idRadioPopupDim1Line.forceActiveFocus(); break;
        case "PopupRadioDim2Line":              idRadioPopupDim2Line.forceActiveFocus(); break;
        case "PopupRadioDim1Line5Second":       idRadioPopupDim1Line5Second.forceActiveFocus(); break;
        case "PopupRadioWarning1Line":          idRadioPopupWarning1Line.forceActiveFocus(); break;
        case "PopupRadioWarning2Line":          idRadioPopupWarning2Line.forceActiveFocus(); break;
        case "PopupDRSWarning1Line":            idRadioPopupDRSWarning1Line.forceActiveFocus();break;
        case "PopupRadioIRWarning2Line":        idRadioPopupIRWarning2Line.forceActiveFocus(); break;
        case "PopupRadioMsg1Line":              idRadioPopupMsg1Line.forceActiveFocus(); break;
        case "PopupRadioAlert":                 idRadioPopupAlert.forceActiveFocus(); break;
        case "PopupRadioEPGInfo2Btn":           idRadioPopupEPGInfo2Btn.forceActiveFocus(); break;
        case "PopupRadioEPGInfo3Btn":           idRadioPopupEPGInfo3Btn.forceActiveFocus(); break;
        case "PopupRadioSubscriptionStatus":    idRadioPopupSubscriptionStatus.forceActiveFocus(); break;
        case "PopupRadioEPGInfoPreservedProgram": idRadioPopupEPGInfoPreservedProgram.forceActiveFocus(); break;
        case "PopupRadioAdvisory1Line":         idRadioPopupAdvisory1Line.forceActiveFocus(); break;
            /* Option Menu */
        case "AppRadioOptionMenu":              idRadioOptionMenu.forceActiveFocus(); break;
        case "AppRadioOptionMenuSub":           idRadioOptionMenuSub.forceActiveFocus(); break;
        case "AppRadioFavDeleteMenu":           idRadioDeleteMenu.forceActiveFocus(); break;
        case "AppRadioFavCancelMenu":           idRadioCancelMenu.forceActiveFocus(); break;
        case "AppRadioListMenu":                idRadioListMenu.forceActiveFocus(); break;
        case "AppRadioEPGMenu":                 idRadioEPGMenu.forceActiveFocus(); break;

        default:  console.debug("== onStateChanged : idAppMain.state == "+idAppMain.state); break;
        }
    }

    onBeep: {
        UIListener.HandleBeep();
    }

    onGSXMPresetScanChanged: {
        if(gSXMPresetScan == "PresetScan" && idRadioMain.visible)
            idRadioMain.item.setFocusPresetScan();
    }

    onGSXMScanChanged: {
        if(gSXMScan == "Scan" && idRadioMain.visible)
            idRadioMain.item.setFocusScanAllChannels();
    }
}
