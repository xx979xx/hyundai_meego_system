/**
 * FileName: DHDmbmain.qml
 * Author: WSH
 */

import Qt 4.7
import Qt.labs.gestures 2.0

import "../component/system/DH" as MSystem
import "../component/Dmb" as MDmb
import "../component/Dmb/JavaScript/DmbOperation.js" as MDmbOperation
import "../component/QML/DH" as MComp

MComp.MAppMain{
    id: idAppMain
    x:0; y: 0 //systemInfo.statusBarHeight //for AppMobileTv(VEXTEngine)
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight + 93
    viewMode: "big"
    focus: true

    property string fontsR: "DH_HDR"     //"NewHDR"  -> NewHDR_CN
    property string fontsB: "DH_HDB"     //"NewHDB"  -> NewHDB_CN

    property int languageType: EngineListener.getCurrentLanguageID() // 7 - EN , 2 - KO
    property string lastMainScreen: ""
    // Send signal to [QML]
    signal signalAllTimerOff()
    signal signalKeyTimerOff()
    signal signalScrollTextTimerOff()
    signal signalScrollTextTimerOn()
    signal signalHideOptionMenu()
    signal signalSaveReorderPreset()
    // System Popup
    property bool isSearchCompleted: false
    property bool isHideFirstSignal: false
    property bool isFirstSignal: false
    
    property bool debugOnOff: false;
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    //    property bool isFullScreen : false
    property bool isDLSChannel : false
//    property bool isRadioChannel : false
//    property int changingChInterval: 10000
    property bool drivingRestriction : false //EngineListener.m_DRSmode
    property bool scrollTextTimerChange : false
    property QtObject presetListModel: DmbPresetModel1  //preset chList
    property bool presetEditEnabled : false //  Preset Order - WSH(130205)
    property bool isSettings : false
    property bool isDragItemSelect: false
    property bool iskeyRelease: false
    property string listState: ""
    property bool isMainDeletedPopup: false

    property bool isSelectButton: false

    property bool isPopUpShow: false

    property bool isOnclickedByTouch: false

    property bool isDrag: false

    property bool isENGMode: false

    property bool isDealerMode: false

    property bool isSeekPreLongKey: false
    property bool isSeekNextLongKey: false

    property bool beRefreshList: false

    // Disaster Signal
    signal disasterMsgSelectAll()
    signal disasterMsgUnselectAll()
    signal disasterMsgDelete()

    // HK Signal
    signal goToMainSeekPrevKeyPressed
    signal goToMainSeekNextKeyPressed
    signal goToMainTuneLeftKeyPressed
    signal goToMainTuneRightKeyPressed

    // Fuction of [SEEK]
    function dmbSeekPrevKeyPressed() { goToMainSeekPrevKeyPressed() }

    // Fuction of [TRACK]
    function dmbSeekNextKeyPressed() { goToMainSeekNextKeyPressed() }

    // Fuction of [Tune Left]
    function dmbTuneLeftKeyPressed() { goToMainTuneLeftKeyPressed() }

    // Fuction of [Tune Right]
    function dmbTuneRightKeyPressed() { goToMainTuneRightKeyPressed() }


    // Move for page by page - signal
    signal goToMainListPageLeft
    signal goToMainListPageRight
    signal goToMainListPageInit(int index)

    // Move for page by page - function
    function dmbListPageLeft() { goToMainListPageLeft() }
    function dmbListPageRight() { goToMainListPageRight() }
    function dmbListPageInit(index) { goToMainListPageInit(index) }

    // First Main Screen
    property string selectedMainScreen: "AppDmbPlayer"
    function currentAppStateID() { return MDmbOperation.currentStateID(); }
    function preSelectedMainScreen() { return EngineListener.popScreen(); }
    function setPreSelectedMainScreen() { EngineListener.pushScreen(idAppMain.state); }
    function setAppMainScreen(mainScreen, saveCurrentScreen) { MDmbOperation.setPropertyChanges(mainScreen, saveCurrentScreen); }
    function gotoBackScreen() { MDmbOperation.backKeyProcessing(); }
    function gotoMainScreen()
    {
        for(;idAppMain.state != "AppDmbPlayer";)
        {
            gotoBackScreen();
        }
        if(selectedMainScreen != "AppDmbPlayer")
        {
            setAppMainScreen(selectedMainScreen, true)
            selectedMainScreen = "AppDmbPlayer"
        }
    }

    // Disaster List
    function gotoDisaterListScreen()
    {
        gotoMainScreen();
        setAppMainScreen("AppDmbDisaterList", true);
    }

    // System Popup
    function gotoPreScreen(moveState)
    {
        if(isSearchCompleted == true) isSearchCompleted = false

        for(;idAppMain.state != moveState;)
        {
            gotoBackScreen();
        }
    }

    function checkFirstSignal()
    {
        if(isFirstSignal == true)
        {
            isFirstSignal = false
            return false;
        }
        isFirstSignal = true;
        return true;
    }

    // Loading Completed!!
    Component.onCompleted: {
        if(presetEditEnabled == true) presetEditEnabled = false //  Preset Order - WSH(130205)
//        if(UIListener.getCurrentScreen() == 1)
            setAppMainScreen(selectedMainScreen, false);
    }

    onVisibleChanged: {
        if(visible){  //  Preset Order - WSH(130205)
//            console.debug("=========== [DHDmbmain][onVisibleChanged]== "+presetEditEnabled )
            if(presetEditEnabled == true) presetEditEnabled = false
        } // End if
    }

    onBeep: {
        EngineListener.playAudioBeep();
    }

    onStateChanged:{
//        console.debug("[QML] ============> [DHDmbMain::onStateChanged] idAppMain.state: "+idAppMain.state)
        var stateID=""
        //CommParser.autoTest_athenaSendObject();
        idAppMain.focus = true
        stateID = currentAppStateID();
        if(stateID !="")
        {
            stateID.focus = true;
        }
//        currentAppStateID().focus = true;
    }

    //Send to Qt
    signal cmdLanguageChange()

    //Send to QML
//    signal showDisasterMessage(string disasterInfo, string disasterMessage)
    signal showDisasterMessage(int alarmPriority, string disasterInfo, string disasterMessage, string disasterId)
    signal disasterListCountChanged(int count)
    
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo{ id : colorInfo }
    MDmb.DmbImageInfo{ id: imageInfo }
    MDmb.DmbStringInfo { id: stringInfo }

    /** APP LOADER ******************************/
    Item {
        id: idDmbMainArea
        focus: true
        x:0
        y: systemInfo.statusBarHeight //PlanB
        // Load for DHDmbPlayerMain.qml
        Loader { id: idDmbPlayerMain }
        // Load for DHDmbDisasterMain.qml
        Loader { id: idDmbDisasterMain }
        // Load for DHDmbDisasterEdit.qml
        Loader { id: idDmbDisasterEdit }
        // Load for ENGModeMain.qml
        Loader { id: idDmbENGModeMain }

        //        KeyNavigation.up: idStatusBar
    }

    /** Option Menu LOADER ******************************/
    Item {
        id: idDmbOptionMenu
        x:0; y: systemInfo.statusBarHeight //PlanB
        // Load for DmbPlayerOptionMenu.qml
        Loader { id: idDmbPlayerOptionMenu}
        // Load for DmbDisasterOptionMenu.qml
        Loader { id: idDmbDisasterOptionMenu}
        // Load for DmbDisasterEditOptionMenu.qml
        Loader { id: idDmbDisasterEditOptionMenu}
    }

    /** POPUP LOADER ******************************/
    Item {
        id: idDmbPopup
        x:0
        y: systemInfo.statusBarHeight//PlanB

        // Load for DmbPopupSearching.qml
        Loader { id: idPopupSearching }
        // Load for DmbPopupSearched.qml
        Loader { id: idPopupSearched }
        // Load for DmbPopupListEmpty.qml
        Loader { id: idPopupListEmpty }
        // Load for DmbPopupChannelDeleteConfirm.qml
        Loader { id: idPopupChannelDeleteConfirm }
        // Load for DmbPopupDisasterInformation.qml
        Loader { id: idPopupDisasterInformation }
        // Load for DmbPopupDisasterDeleteConfirm.qml
        Loader { id: idPopupDisasterDeleteConfirm }
        // Load for DmbPopupDisasterDeleteAllConfirm.qml
        Loader { id: idPopupDisasterDeleteAllConfirm }
        // Load for DmbPopupDisasterDeleting.qml
        Loader { id: idPopupDisasterDeleting }

        //Dim Popup
        // Load for DmbDimPopupDeleted.qml
        Loader { id: idDimPopupDeleted }
        // Load for DmbDimPopupSetFullScreen.qml
        Loader { id: idDimPopupSetFullScreen }
    }

    //Event from CommParser
    Connections{
        target: CommParser
        onChannelSearchCompleted: {
            isSearchCompleted = true;

            if(idAppMain.state == "PopupSearching"){
//                console.log("[luna] onChannelSearchCompleted")
                if(idAppMain.presetListModel.rowCount() == 0)
                {
                    if(idAppMain.isENGMode == false)
                    {
                        gotoMainScreen();
                        setAppMainScreen("PopupListEmpty", true);
                    }
                    else
                    {
                        gotoBackScreen();
                    }
                }
                else
                {
                    setAppMainScreen("PopupSearched", false)
                }
            }
//            else{
//                console.log("[luna] onChannelSearchCompleted : Do nothing, ChannelSearching already canceled")
//            }
        }
        onChannelSearchStopped :{
//            console.debug("Searching Channel : stop")
            if(idAppMain.state == "PopupSearching"){
                gotoBackScreen()
            }
        }

        onDmbEngineerMode:{
            setAppMainScreen("AppDmbENGMode", false)
        }
    }

    Connections{
        target: EngineListener

        onModeENGState:{
//            console.debug("-- [onModeENGState] state = " +  engstate + " dealerState = " + dealerState)
            idAppMain.isDealerMode = dealerState;
            if(idAppMain.isENGMode != engstate){
                idAppMain.isENGMode = engstate;
                if(engstate == false)
                {
                    CommParser.onDebugModeOff();
                }
            }
        }

        onModeENGStateClose:{
            if(idAppMain.isENGMode == true){
                idAppMain.isENGMode = false;
                CommParser.onDebugModeOff();
                gotoMainScreen();
                EngineListener.changeFocusAfterEngModeClose();
            }
        }

        onModeDRSChanged:{
//            console.debug("-- [onModeDRSChanged] " +  EngineListener.m_DRSmode)
//            console.debug("-- [onModeDRSChanged currnet screen =>  " +  UIListener.getCurrentScreen())

            if(EngineListener.m_DRSmode && EngineListener.IsShowDRSMode(UIListener.getCurrentScreen())){
//                if(idAppMain.state != "AppDmbPlayer")
//                {
//                    if(idAppMain.state != "PopupSearching" && idAppMain.state != "PopupListEmpty" )
//                        gotoMainScreen()
//                }
                if(idAppMain.state == "AppDmbPlayerOptionMenu"){
                    gotoBackScreen()
                }
                drivingRestriction = true
                signalScrollTextTimerOff();
            }
            else{

                if(drivingRestriction == true &&  idAppMain.state == "AppDmbPlayerOptionMenu")
                {
                    gotoBackScreen()
                }

                drivingRestriction = false
                signalScrollTextTimerOn();
            }

//            idAppMain.dmbListPageInit(CommParser.m_iPresetListIndex)

        }

        onRetranslateUi:{            
            if(languageId == 7/*EN*/) languageType = 7
            else if(languageId == 2/*KO*/) languageType = 2

        }

        onSetGoToBackScreen:{
            idAppMain.gotoBackScreen()
        }

        onSendSignalCloseLocalPopup:{
//            console.log("[QML][onSendSystemPopupOnOff] qmlState : " + qmlState)
            if(qmlState == "PopupDisaster"){
                gotoPreScreen("AppDmbDisaterList")
            }else if(qmlState == "PopupDisasterDeleteAllConfirm"){
                MDmbOperation.CmdReqAMASMessageUnseleteAll()
                disasterMsgUnselectAll()
                gotoBackScreen()
            }
        }

        onSetRearMainScreen:{

            if(UIListener.getCurrentScreen() == 1){
                EngineListener.setAppMainState(idAppMain.state);
            }else if(UIListener.getCurrentScreen() == 2){
//                if(isTempMode == false && isSwapMode == false /*&&
//                        (EngineListener.getAppMainState() == "AppDmbDisaterList" || EngineListener.getAppMainState() == "AppDmbPlayer" || EngineListener.getAppMainState() == "AppDmbDisaterListEdit")*/)
//                    setAppMainScreen(EngineListener.getAppMainState(), false);
//                else
//                    setAppMainScreen(selectedMainScreen, false);

                setAppMainScreen(selectedMainScreen, false);

//                if(isTempMode == false){
//                    if(isSwapMode == true)
//                        setAppMainScreen(EngineListener.getAppMainState(), false);
//                    else
//                        setAppMainScreen(selectedMainScreen, false);
//                }else{
////                    if(EngineListener.getAppMainState() == "AppDmbDisaterList" || EngineListener.getAppMainState() == "AppDmbPlayer" || EngineListener.getAppMainState() == "AppDmbDisaterListEdit")
////                        setAppMainScreen(EngineListener.getAppMainState(), false);
////                    else
//                        setAppMainScreen(selectedMainScreen, false);
//                }
            }
        }
    }

    Connections{
        target: UIListener

        onSignalHideSystemPopup:{
            //console.log(" 1 [SYSTEM HIDE][onSignalHideSystemPopup] ===>> isHideFirstSignal="+isHideFirstSignal+" lastMainScreen="+lastMainScreen +" isSearchCompleted="+isSearchCompleted)
            CommParser.m_bIsSystemPopUpShow=false;
            idAppMain.focusOn = true;
            // Only Work First signal
            if(isHideFirstSignal == true)
            {
                isHideFirstSignal = false
                return;
            }
            isHideFirstSignal = true;

            switch(lastMainScreen)
            {
               case "PopupListEmpty":
               case "AppDmbPlayer":
               {
                   if(idAppMain.presetListModel.rowCount() == 0){
                       setAppMainScreen("PopupListEmpty", true);
                   }
                   break;
               }

//                case "PopupSearching":
//                {
//                    if(isSearchCompleted == true)
//                    {
//                        isSearchCompleted = false
//                        if(idAppMain.presetListModel.rowCount() == 0)
//                        {
//                            gotoMainScreen();
//                            setAppMainScreen("PopupListEmpty", true);
//                        }
//                        return;
//                    }

//                    setAppMainScreen(lastMainScreen, true);
//                    break;
//                }

//                case "PopupDisasterDeleting":
//                {
//                    setAppMainScreen(lastMainScreen, true);
//                    break;
//                }
            }

            lastMainScreen = "AppDmbPlayer";
        }

        onSignalShowSystemPopup:{
            lastMainScreen = idAppMain.state
            CommParser.m_bIsSystemPopUpShow=true;
            //console.log(" 3 [SYSTEM SHOW][onSignalShowSystemPopup] ===>> lastMainScreen="+lastMainScreen +" isSearchCompleted="+isSearchCompleted)
            idAppMain.focusOn = false;
            // Send to all Popup
            signalAllTimerOff()
            if(idAppMain.presetEditEnabled == true && idAppMain.isDragItemSelect == true){
                idAppMain.signalSaveReorderPreset();
            }
            isHideFirstSignal = false;

            switch(lastMainScreen){

                // Go to [PlayerMain]
                case "PopupSearched":
                case "PopupListEmpty":
                case "PopupChannelDeleteConfirm":
//                case "PopupSearching":
                {
                    gotoPreScreen("AppDmbPlayer")
                    break;
                }

                // Timer X, Go to [DisasterList]
                case "PopupDisasterDeleting":
                case "PopupDisasterInfomation":
                case "PopupDisasterDeleteConfirm":
                {
                    //gotoDisasterScreen()
                    //gotoPreScreen("AppDmbDisaterList")
                    EngineListener.closeLocalPopup("PopupDisaster");
                    break;
                }

                case "PopupSearching":
                {
                    CommParser.onScanCancel();
                    if(idAppMain.presetListModel.rowCount() == 0){
                        lastMainScreen = "PopupListEmpty";
                    }
                    gotoPreScreen("AppDmbPlayer")
                    break;
                }
                case "PopupDisasterDeleteAllConfirm":
                {
                    //MDmbOperation.CmdReqAMASMessageUnseleteAll()
                    //disasterMsgUnselectAll()
                    //gotoBackScreen()
                    EngineListener.closeLocalPopup("PopupDisasterDeleteAllConfirm");
                    break;
                }

                // Timer O, Go to BackScreen()
                case "AppDmbPlayerOptionMenu":
                {
                    gotoBackScreen()
                    break;
                }
                case "PopupDeleted":
                {
                    if(idAppMain.isMainDeletedPopup == true)
                    {
                        gotoMainScreen()
                        idAppMain.isMainDeletedPopup = false
                        break;
                    }
                    else
                    {
//                        gotoBackScreen()
                        EngineListener.moveGoToBackScreen()
                        break;
                    }
                }
            } // End switch
        } // End onSignalShowSystemPopup
    }

    onDrivingRestrictionChanged:{
//        console.debug("-- [onDrivingRestrictionChanged] " +  drivingRestriction)
    }
}
