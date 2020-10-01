/**
 * FileName: DHRadioRdsMain.qml
 * Author: HYANG
 * Time: 2012-06
 *
 * - Initial Created by HYANG
 * - 20120727 Modified by qutiguy : for interaction with controller(Qt source code)
 * - 20130130 Modified by qutiguy : for implementation changed UX Scenario based on 2012.12.14
 */


import Qt 4.7
import "../component/system/DH" as MSystem
import "../component/QML/DH" as MComp
import "../component/Radio/RDS" as MRadio
import "../component/Radio/RDS/JavaScript/RadioRdsOperation.js" as MOperation
// 20130428 by qutiguy - use statusbar plugin.
import QmlStatusBar 1.0

MComp.MAppMain {

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MRadio.RadioRdsStringInfo{ id: stringInfo }

    id: idAppMain
    x: 0; y: 0 //+ 47
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight +93
    focus: true

    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderGeneral: imageInfo.imgFolderGeneralForPremium //KSW 130731 for premium UX

// 20130222 - added by qutiguy - to sync stationlist
    property bool   requestStopSearchforStationList: false
    //dg.jin 20150630 Seek stop When enter preset list
    property bool   requestStopSearchforPresetList: false
    signal sigLaunchStation(string mode);
    signal sigOptionMenuTimer(); //KSW 131024 [ITS][195847][major] oneDepth menu closed before to do close twodepth menu.

    //****************************** # First Main Screen #
    property string selectedMainScreen: "AppRadioRdsMain"
    function currentAppStateID() { return MOperation.currentStateID(); }
    function preSelectedMainScreen() {console.log("mFlowStack.pop()");return UIListener.popScreen(); }
    function setPreSelectedMainScreen() { UIListener.pushScreen(idAppMain.state); }
    function setAppMainScreen(mainScreen, saveCurrentScreen) { MOperation.setPropertyChanges(mainScreen, saveCurrentScreen); }
    function gotoBackScreen() { MOperation.backKeyProcessing(); }

    property real globalSelectedFmFrequency: 87.5    //# Variant frequency (FM)
    property real globalSelectedAmFrequency: 531    //# Variant frequency (MW)
//    property string globalSelectedBand: "FM"  //stringInfo.strRDSBandFm      //# Band tab ("FM"|"AM")
    property int globalSelectedBand: 0x01  //0x01 : FM,  0x03 : AM

    property int frequenyCalculatorValue: 0
    property real startFmFrequency: 87.5        //# Variant frequency FM start value
    //dg.jin 20140912 EU AM range change 522 - 1620 -> 531 - 1602 for KH
    property real startAmFrequency: (UIListener.getRadioRegionCode() == 0) ? 531 : 522         //# Variant frequency MW start value  //dg.jin 20150707 add guam
    property real endFmFrequency: 108.0         //# Variant frequency FM end value
    //dg.jin 20140912 EU AM range change 522 - 1620 -> 531 - 1602 for KH
    property real endAmFrequency: (UIListener.getRadioRegionCode() == 0) ? 1602 : 1620          //# Variant frequency MW end value  //dg.jin 20150707 add guam
    property real stepFmFrequency: 0.1 //0.05          //# Variant frequency FM step value
    property real stepAmFrequency: 9            //# Variant frequency MW step value
    property int  preset_Num     : 12

    // Property for RDS settings and status.
    property bool menuTaFlag    : QmlController.rdssettingsTP             //# TA On/Off of OptionMenu
    //KSW 130806 Fixed it, problem do not update rt text.
    property bool menuInfoFlag  : QmlController.rdsrtonoff               //# Info On/Off of OptionMenu
    property bool menuNewsFlag  : QmlController.rdssettingsNews            //# News On/Off of OptionMenu
    property bool menuRegionFlag : false //: QmlController.rdssettingsRegion == 0x00? false:true          //# Region On/Off of OptionMenu

    // Property for Radio status.
    property bool menuScanFlag     : ((QmlController.searchState == 0x06) || (QmlController.searchState == 0x07))?true:false

    property bool b_presetsavemode : false      //# if true : prsetsavemove , false : presetviewmode
    property int engineerMode    : 0
//// 20130513 added by qutiguy - state of engine.
    property int currentViewState    : UIListener.VIEWSTATE

    property bool bForceDefaultFocus : false //KSW 140107 ITS/219032

    signal initStationList(); //for sending signal to prepare station list

    ////////////////////////////////////////////////////////////////
    // 2012.11.09 Added by qutiguy for binding property.
    ////////////////////////////////////////////////////////////////
    /// Show Debug Screen
    property bool debugMode    : false
    /// Get Current Band
    property int currentBand : QmlController.radioBand
    /// Get Current Frequency
    property string currentFrequency : QmlController.radioFreq
    /// Get Current SearchState
    property int currentSearchState : QmlController.searchState
    /// Get Current PresetIndex
    property int currentPresetIndex : (QmlController.radioBand==1)?QmlController.presetIndexFM1:(QmlController.radioBand==2)?QmlController.presetIndexFM2:QmlController.presetIndexAM
    /// Get Current StationName
    property string currentStationName : QmlController.boradcastName
    /// Get Current ApplicationState
    property int currentApplicationState : QmlController.AppState
    /// Get Current EngineerMode
    property int currentEngineerModeState : QmlController.engModePage

    ////////////////////////////////////////////////////////////////
    // 2012.11.09 Added by qutiguy for binding property.
    ////////////////////////////////////////////////////////////////
    /// Get Current PICode
    property int currentPICode : QmlController.picode
    /// Get Current PSName
    property string currentPSName : QmlController.rdspsname
    /// Get Current PTYName
    property string currentPTYName : QmlController.rdsptyname
    /// Get Current PTYType
    property int currentPTYType : QmlController.rdsptytype
    /// Get Current RText
    property string currentRText : QmlController.rdsrt


    property int cursor_am_position;
    property int cursor_fm_position;

    property bool   drsShow     : false // JSH 130501 added
    property bool   selectedSoundSetting : false

    //2013.10.30 added by qutiguy : ITS 0198898
    signal          pressCancelSignal();    // JSH 130906


    //function to check whether display the PSN or not.
    function enablePSNameDisplay(){
            if(globalSelectedBand == 0x03)
                return false;
            else{
                if((QmlController.rdspsname == null) || (QmlController.rdspsname  == ""))
                    return false;
                else
                    return true;
            }
        }
    //function to check whether display the PresetIndex or not.
    function enablePresetIndexDisplay(){
             if(globalSelectedBand == 0x03){
                 if(QmlController.presetIndexAM == 0)
                     return false;
                 else
                    return (QmlController.presetIndexAM <= preset_Num)?true:false
             }
             else{
                 if(QmlController.presetIndexFM1 == 0)
                     return false;
                 else
                    return (QmlController.presetIndexFM1 <= preset_Num)?true:false
             }
        }

    //function to display pty name via pty number.
    function getptyname(index)
    {
        var result;
        switch(index)
        {
        case 0:
            result = stringInfo.strRDSPtyAll;
            break;
        case 1:
            result = stringInfo.strRDSPtyNews;
            break;
        case 2:
            result = stringInfo.strRDSPtyCurrentAffairs;
            break;
        case 3:
            result = stringInfo.strRDSPtyInfomation;
            break;
        case 4:
            result = stringInfo.strRDSPtySport;
            break;
        case 5:
            result = stringInfo.strRDSPtyEducation;
            break;
        case 6:
            result = stringInfo.strRDSPtyDrama;
            break;
        case 7:
            result = stringInfo.strRDSPtyCulture;
            break;
        case 8:
            result = stringInfo.strRDSPtyScience;
            break;
        case 9:
            result = stringInfo.strRDSPtyVaried;
            break;
        case 10:
            result = stringInfo.strRDSPtyPopMusic;
            break;
        case 11:
            result = stringInfo.strRDSPtyRockMusic;
            break;
        case 12:
            result = stringInfo.strRDSPtyEasyListeningMusic;
            break;
        case 13:
            result = stringInfo.strRDSPtyLightClassicalMusic;
            break;
        case 14:
            result = stringInfo.strRDSPtySeriousClassicalMusic;
            break;
        case 15:
            result = stringInfo.strRDSPtyOtherMusic;
            break;
        case 16:
            result = stringInfo.strRDSPtyWeather;
            break;
        case 17:
            result = stringInfo.strRDSPtyFinance;
            break;
        case 18:
            result = stringInfo.strRDSPtyChildrensProgram;
            break;
        case 19:
            result = stringInfo.strRDSPtySocialAffairs;
            break;
        case 20:
            result = stringInfo.strRDSPtyReligion;
            break;
        case 21:
            result = stringInfo.strRDSPtyPhoneIn;
            break;
        case 22:
            result = stringInfo.strRDSPtyTravle;
            break;
        case 23:
            result = stringInfo.strRDSPtyLeisure;
            break;
        case 24:
            result = stringInfo.strRDSPtyJazzMusic;
            break;
        case 25:
            result = stringInfo.strRDSPtyCountryMusic;
            break;
        case 26:
            result = stringInfo.strRDSPtyNationalMusic;
            break;
        case 27:
            result = stringInfo.strRDSPtyOldiesMusic;
            break;
        case 28:
            result = stringInfo.strRDSPtyFolkMusic;
            break;
        case 29:
            result = stringInfo.strRDSPtyDocumentary;
            break;
        case 30:
            result = stringInfo.strRDSPtyAlarmText;
            break;
        case 31:
            result = stringInfo.strRDSPtyAlarm;
            break;
        case 32:
            result = stringInfo.strRDSAM; //added by Michael Kim 2013.04.04 for New UX
            break;
        }
        return result;
    }

    //function to display pty name via pty number.
    function getptyimage(index)
    {
        var result;
        switch(index)
        {
//        case 0: //KSW 130731 for premium UX
//            result = "pty/ico_fm.png"
//            break; //added by Michael Kim 2013.04.04 for New UX
        case 1:
            result = "pty/ico_pty_01.png"
            break;
        case 2:
        case 7:
        case 19:
        case 29:
            result = "pty/ico_pty_02.png"
            break;
        case 3:
            result = "pty/ico_pty_03.png"
            break;
        case 4:
            result = "pty/ico_pty_04.png"
            break;
        case 5:
            result = "pty/ico_pty_05.png"
            break;
        case 6:
            result = "pty/ico_pty_06.png"
            break;
        case 8:
            result = "pty/ico_pty_07.png"
            break;
        case 9:
            result = "pty/ico_pty_08.png"
            break;
        case 10:
            result = "pty/ico_pty_09.png"
            break;
        case 11:
            result = "pty/ico_pty_10.png"
            break;
        case 12:
        case 15:
        case 26:
        case 27:
            result = "pty/ico_pty_11.png"
            break;
        case 13:
        case 14:
            result = "pty/ico_pty_12.png"
            break;
        case 16:
            result = "pty/ico_pty_13.png"
            break;
        case 17:
            result = "pty/ico_pty_14.png"
            break;
        case 18:
            result = "pty/ico_pty_15.png"
            break;
        case 20:
            result = "pty/ico_pty_16.png"
            break;
        case 21:
            result = "pty/ico_pty_17.png"
            break;
        case 22:
            result = "pty/ico_pty_18.png"
            break;
        case 23:
            result = "pty/ico_pty_19.png"
            break;
        case 24:
            result = "pty/ico_pty_20.png"
            break;
        case 25:
            result = "pty/ico_pty_21.png"
            break;
        case 28:
            result = "pty/ico_pty_22.png"
            break;
        case 30:
        case 31:
            result = "pty/ico_pty_23.png"
            break;
//KSW 130731 for premium UX
//        case 32:
//            result = "pty/ico_am.png" //modified by Michael Kim 2013.04.04 for New UX
        default:
            result = "ico_radio.png"
            break;
        }
        return  result;
    }

    //function to launch the station list.
    function launchStationList(mode){

        console.log("//////////////////////////////////////// launchStationList " + mode);

        //dg.jin 20150331 Seek stop When enter station list
        if(requestStopSearchforStationList == true)
        {
            return;
        }
        if(QmlController.searchState != 0){
            requestStopSearchforStationList = true;
            QmlController.setIsTpSearching(false);
            QmlController.seekstop();
            return;
        }

        requestStopSearchforStationList = false;
        QmlController.setBlockedStation(true);
        QmlController.getStationListModel();
         //131117-1 [ITS][208492][comment]
        if(QmlController.sortType == 1){
            QmlController.setSortType(3);
            QmlController.setSortType(1);
        }
        else if(QmlController.sortType == 3){ //dg.jin 20141006 RU field issue
            QmlController.setSortType(1);
            QmlController.setSortType(3);
        }

        if(mode == "from_main") // launch from title bar button.
            setAppMainScreen( "AppRadioRdsStationList" , true);
        else // launch from option menu.
            setAppMainScreen( "AppRadioRdsStationList" , true);
    }

    //function to finish the station list.
    function finishStationList(){
        QmlController.setBlockedStation(false);
    }

//20130107 Added by qutiguy - go back to the main screen.
    function initRadioScreen(){
        console.log("[[[[[[[[ initRadioScreen ]]]]]]]]")
        switch(idAppMain.state){
        //case "AppRadioRdsOptionMenuSortBy": KSW 130924 [EU][ITS][187673][major] - move to under
        case "AppRadioRdsOptionMenuRegion":
        case "PopupRadioRdsTa": //KSW 131122-1
               gotoBackScreen();
               break;
        case "AppRadioRdsOptionMenuSortBy": //KSW 130924 [EU][ITS][187673][major] about screen error(station list changed to main screen.)
        case "AppRadioRdsOptionMenuStationList":
        case "PopupRadioRdsLoading":
                gotoBackScreen();
        case "AppRadioRdsStationList":
                gotoBackScreen();
        }
        setAppMainScreen("AppRadioRdsMain", true)
    }

    //KSW 130821 [ITS][184466] close option menu when BG -> FG
    function closeOptionMenu(){
        console.log("[[[[[[[[ closeOptionMenu ]]]]]]]]")
        if(idAppMain.state == "AppRadioRdsOptionMenu"
        ||idAppMain.state == "AppRadioRdsOptionMenuSortBy"
        ||idAppMain.state == "AppRadioRdsOptionMenuRegion"
        ||idAppMain.state == "AppRadioRdsOptionMenuStationList")
            gotoBackScreen();
    }

    /*KSW 140327 refer comment
    * region 010 total step 410 1 step 5
    * region 000 total step 210 1 step 10
    */
    onGlobalSelectedFmFrequencyChanged:{
        cursor_fm_position = (((idAppMain.globalSelectedFmFrequency * 100)-8750) * 1152/(410*5)) ;
    }
    onGlobalSelectedAmFrequencyChanged:{
        cursor_am_position = (((idAppMain.globalSelectedAmFrequency - 522) / 9) * (1126/122) + 24) ;
    }
    onGlobalSelectedBandChanged:{
        if(globalSelectedBand == 0x01)
            cursor_fm_position = (((idAppMain.globalSelectedFmFrequency * 100)-8750) * 1152/(410*5)) ;
        else
            cursor_am_position = (((idAppMain.globalSelectedAmFrequency - 522) / 9) * (1126/122) + 24) ;
    }
    onMenuTaFlagChanged:{
        console.log("[[[[[[[[[[[[[[[[[[[menuTaFlag changed ]]]]]]]]]]]]]]]]]]] " + menuTaFlag);
    }
    onMenuInfoFlagChanged:{
        console.log("[[[[[[[[[[[[[[[[[[[menuInfoFlag changed ]]]]]]]]]]]]]]]]]]] " + menuInfoFlag);
    }
    onMenuNewsFlagChanged:{
        console.log("[[[[[[[[[[[[[[[[[[[menuNewsFlag changed ]]]]]]]]]]]]]]]]]]] " + menuNewsFlag);
    }
    onSigLaunchStation:{
        console.log("[[[[[[[[[[[[[[[[[[[ onSigLaunchStation ]]]]]]]]]]]]]]]]]]] " + mode);
        launchStationList(mode);
    }

    //KSW 131024 [ITS][195847][major] oneDepth menu closed before to do close twodepth menu.
    onSigOptionMenuTimer:{
        console.log("[[[[[[[[[[[[[[[[[[[  onSigOptionMenuTimer ]]]]]]]]]]]]]]]]]]] ");//in TwoDepth
    }

    //KSW 140113-1 ITS/219475
    onB_presetsavemodeChanged:{
        console.log("[[[[[[[[[[[[[[[[[[[ is presetsavemode ]]]]]]]]]]]]]]]]]]] " + b_presetsavemode);
        QmlController.setIsSaveAsPreset(b_presetsavemode);
    }

    //****************************** # Loading completed (First Focus) #
    Component.onCompleted:{
        setAppMainScreen(selectedMainScreen, true);
    }

//    onStateChanged: {
//        switch(idAppMain.state){
//        case "AppRadioRdsMain":                      idRadioRdsMain.forceActiveFocus(); break;
//        case "AppRadioRdsOptionMenu":                idRadioRdsOptionMenu.forceActiveFocus(); break;
//        case "AppRadioRdsStationList":               idRadioRdsStationList.forceActiveFocus(); break;
//        case "AppRadioRdsOptionMenuStationList":     idRadioRdsOptionMenuStationList.forceActiveFocus(); break;
//        case "AppRadioRdsOptionMenuSortBy":          idRadioRdsOptionMenuSortBy.forceActiveFocus(); break;
//        case "AppRadioRdsOptionMenuRegion":          idRadioRdsOptionMenuRegion.forceActiveFocus(); break;
//        case "AppRadioRdsPresetList":                idRadioRdsPresetList.forceActiveFocus(); break;
//            //        case "PopupRadioRdsPreset":                 idRadioRdsPopupPreset.forceActiveFocus(); break;
//            //        case "PopupRadioRdsTpStation":              idRadioRdsPopupTpStation.forceActiveFocus(); break;
//            //        case "PopupRadioRdsTraffic":                idRadioRdsPopupTraffic.forceActiveFocus(); break;
//        case "PopupRadioRdsLoading":                idRadioRdsPopupLoading.forceActiveFocus(); break;

//        default: console.debug("=== onStateChanged : idAppMain.state == "+idAppMain.state); break;
//        }
//    }

    onBeep:QmlController.playAudioBeep();

    // 20130428 modified by qutiguy - statusbar plugin.
    //****************************** # Status Bar Plugin#
    QmlStatusBar{
        id: statusBar
        x: 0
        y: 0
        z: 1
        width: 1280
        height: 93
        homeType:"button"
        middleEast: false
        visible:true
    }
    //KSW 131210
    Rectangle { // statusbar Dim , JSH 131104
        id:statusBarDim
        visible: ((idRadioRdsPopupLoading.visible || idRadioRdsPopupTa.visible) && (!idAppMain.systemPopupShow)) ? true : false
        width: systemInfo.lcdWidth
        height: 93
        color: colorInfo.black
        opacity: 0.6
        z: 1
        MouseArea{
            anchors.fill: parent;
        }
    }
    //****************************** # ChannelList Background Image #
    Image{
        x: 0; y: 0//-systemInfo.statusBarHeight
//20121205 change bgimage
//        source: imgFolderGeneral+"bg.png"
        //source: imgFolderGeneral+"bg_type_a.png"
        source: imgFolderGeneral+"bg_main.png"
    }

    //****************************** # APP LOADER #
    FocusScope{
        id: idRadioRdsMainArea
        objectName: "MainArea"; // JSH 130418 added
        focus: true
        x: 0;
        Loader {id: idRadioRdsMain;  y: 93; }
        Loader {id: idRadioRdsOptionMenu; y: 91; source : "../component/Radio/RDS/RadioRdsOptionMenu.qml"; visible : false;} //dg.jin 20140902 ITS 0243389 full focus issue for KH 93->91
        Loader {id: idRadioRdsStationList; y: 93;} 
        Loader {id: idRadioRdsOptionMenuStationList; y: 91;visible : false;} //dg.jin 20140902 ITS 0243389 full focus issue for KH 93->91
        Loader {id: idRadioRdsOptionMenuSortBy; y: 91;visible : false;} //dg.jin 20140902 ITS 0243389 full focus issue for KH 93->91
        Loader {id: idRadioRdsOptionMenuRegion; y: 91; source : "../component/Radio/RDS/RadioRdsOptionMenuRegion.qml"; visible : false;} //dg.jin 20140902 ITS 0243389 full focus issue for KH 93->91
        //        Loader {id: idRadioRdsPresetList; y: 93; }
        Loader {id: idRadioRdsPresetListFM; y: 93; }
        Loader {id: idRadioRdsPresetListAM; y: 93; }
        //        Loader {id: idRadioRdsPopupPreset; y: 0;}
        //        Loader {id: idRadioRdsPopupTpStation; y: 0;}
        //        Loader {id: idRadioRdsPopupTraffic; y: 0; }
        Loader {id: idRadioRdsPopupLoading; y: 93; visible: false;}//KSW 131210 add visible default
        //        Loader {id: idRadioRdsPopupPresetWarning; y: 93 }
        Loader {id: idRadioRdsPopupSaved; y: 93 ; visible: false  }
        Loader {id: idRadioRdsPopupTa; y: 93 ; visible: false;}
        Loader {id: idRadioENGModeMain; y: 93}//systemInfo.statusBarHeight }  // JSH 120406
    }
    ///////////////////////////////////////////////////////////////////////
    Connections{
        target: QmlController
        onEngModeDisPlay:{
            if(engModeOnOff && (idAppMain.state != "AppRadioRdsENGMode"))
                setAppMainScreen("AppRadioRdsENGMode", true);
            else if(idAppMain.state == "AppRadioRdsENGMode" && engModeOnOff == 0)
                gotoBackScreen();
        }

        onChangeSearchState: {
            if( value == 0){
                if(requestStopSearchforStationList == true){
                    requestStopSearchforStationList = false; //dg.jin 20150331 Seek stop When enter station list
                    launchStationList(false);
                }
                else  if(requestStopSearchforPresetList == true){
                    //dg.jin 20150630 Seek stop When enter preset list
                   requestStopSearchforPresetList = false;
                   setAppMainScreen("AppRadioRdsPresetList" , true);
                }
            }
        }
// 20130418 modified by qutiguy - when pressed soundsettings & go to BG
        onChangeAppState:{
            //console.log("+++++++++++onChangeAppState+++++++++++++++")
            if((QmlController.getAppState() == 0x01) && idAppMain.selectedSoundSetting){
                if(idAppMain.state == "AppRadioRdsOptionMenu")
                    gotoBackScreen();
                idAppMain.selectedSoundSetting = false;
            } //end if
        }// end onChangeAppState
    }
    Connections{
        target: UIListener
//20130201 modified by qutiguy - signal for FG Event to go main screen or keep current screen
        onSigEventRequestFG:{
            console.log("[[[[[[[[ onSigEventRequestFG = ]]]]]]]]" + value)
            if(!value)
// 20130107 modified by qutiguy - call the function.
                initRadioScreen();
        //KSW 130821 [ITS][184466] close option menu when BG -> FG
        //KSW 131217 [ITS][215966] if temporalMote flag is ture, then don't close submenu
//            else
//                closeOptionMenu();
        }
        onSignalShowSystemPopup:{
            console.log("[[[[[[[[ onSignalShowSystemPopup ]]]]]]]]");
            if(idRadioRdsPopupLoading.visible)
            {
                //KSW 131028 [ITS][198566][minor] remember last AM freq after refresh.
                if(QmlController.getIsRefreshing() == true)
                    QmlController.setForceSeekStop(true);
                QmlController.stopRefresh();
            }

            //20141017 dg.jin systempopup hide option menu
            if(idRadioRdsOptionMenuSortBy.visible || idRadioRdsOptionMenuRegion.visible || idRadioRdsStationList.visible || idRadioRdsOptionMenuStationList.visible)
                idAppMain.optionMenuHide();

            idAppMain.focusOn = false;
            idAppMain.systemPopupShow = true; //dg.jin 20140901 ITS 247202 focus issue
        }
        onSignalHideSystemPopup:{
            console.log("[[[[[[[[ onSignalHideSystemPopup ]]]]]]]]");
            idAppMain.focusOn = true;
            idAppMain.systemPopupShow = false; //dg.jin 20140901 ITS 247202 focus issue
        }
// 2013.11.05 Removed by qutiguy do not used
//        onSignalRDSSEEKNext:{
//            console.log("[[[[[[[[ onSignalRDSSEEKNext = ]]]]]]]]" + mode);
//            if(mode == 0){
//            }else{
//                wheelLeftKeyPressed();
//            }
//        }
//        onSignalRDSSEEKPrev:{
//            console.log("[[[[[[[[ onSignalRDSSEEKPrev = ]]]]]]]]" + mode);
//            if(mode == 0){
//                wheelRightKeyPressed();
//            }else{

//            }
//        }
//        onSignalRDSSWRCNext:{
//            console.log("[[[[[[[[ onSignalRDSSWRCNext = ]]]]]]]]" + mode);
//            if(mode == 0){
//                wheelLeftKeyPressed();
//            }else{
//            }
//        }
//        onSignalRDSSWRCPrev:{
//            console.log("[[[[[[[[ onSignalRDSSWRCPrev = ]]]]]]]]" + mode);
//            if(mode == 0){
//                wheelRightKeyPressed();
//            }else{
//            }
//        }
        onSignalRDSTuneDial:{
            console.log("[[[[[[[[ onSignalRDSTuneDial = ]]]]]]]]" + direction);
            if(direction < 0){
                wheelLeftKeyPressed();
            }else{
                wheelRightKeyPressed();
            }
        }
        onSignalRDSClosePopup:{
            console.log("[[[[[[[[ onSignalRDSClosePopup = ]]]]]]]]");
            if(UIListener.VIEWSTATE == 4) //optionmenu
            {
                //// to do close optionmenu
                ;
            }else if(UIListener.VIEWSTATE == 5) //popup
            {
                //// to do close popup
                gotoBackScreen();
            }

        }
        onDrsShowSignal        :{ drsShow = show} // JSH 130501 added
        onSignalRDSTaPopup:{
            console.log("[[[[[[[[ onSignalRDSTAPopup = ]]]]]]]]");
            //KSW 131122-1
            if(idAppMain.state == "PopupRadioRdsTa")
            {
                console.log(">> already local TA popping.");
                return ;
            }

            setAppMainScreen("PopupRadioRdsTa", true);  //KSW 131119-1
        }
    }
    ////////////////////////////////////////////////////////////////////////
    //End Added by qutiguy 0612 for debugging
    function simulator_Seek(){
        for (var i = 0; i < 20.00 ; i=i+0.05){
            idAppMain.globalSelectedFmFrequency = 87.50 + i;
        }
    }
    //debugging screen
    Rectangle {
        id: idDebugScreen
        x:0;y:0 + 93;
        width: 200 ;height: 640
        color : "yellow"
        opacity: 0.7
        radius : 0.1
        visible: false//idAppMain.debugMode
        Item{
            id: idDebugScreenItem
            x:0;y:0;
            Grid{
                rows: 40
                spacing: 2
                Text {text: "//// RADIO INFO //// "}
                Text {text: "currentBand        = " + idAppMain.currentBand}
                Text {text: "currentFrequency   = " + idAppMain.currentFrequency}
                Text {text: "currentSearchState = " + idAppMain.currentSearchState}
                Text {text: "currentPresetIndex = " + idAppMain.currentPresetIndex}
                Text {text: "currentStationName = " + idAppMain.currentStationName}
                Text {text: "currentAppState    = " + idAppMain.currentApplicationState}
                Text {text: "currentEngModeState= " + idAppMain.currentEngineerModeState}
                Text {text: "//// RDS DATA //// "}
                Text {text: "currentPICode  = " + idAppMain.currentPICode}
                Text {text: "currentPSName  = " + idAppMain.currentPSName}
                Text {text: "currentPTYName = " + idAppMain.currentPTYName}
                Text {text: "currentPTYType = " + idAppMain.currentPTYType}
                Text {text: "currentRText   = " + idAppMain.currentRText}
                Text {text: "currentBand    = " + idAppMain.currentBand}
                Text {text: "currentView    = " + idAppMain.currentViewState}
                Text {text: "rdsPage    = " + QmlController.isRdsEngMode} //KSW 140220
                Text {text: "Simulator(Seek) "
                    MouseArea{
                        id : idSIMULATOR
                        property bool simsearchmode : true
                        anchors.fill: parent
                        onClicked:{
                            if (idSIMULATOR.simsearchmode == true)
                                QmlController.simulator_make_actions();
                            else
                                QmlController.simulator_stop();
                            idSIMULATOR.simsearchmode = !idSIMULATOR.simsearchmode;
                        }
                    }
                }
                Text {text: "DetailedFunctions "
                    MouseArea{
                        anchors.fill: parent
                        onClicked:idDebugFunctionScreen.visible = true
                    }
                }

                Text {text: "TA Popup "
                    MouseArea{
                        anchors.fill: parent
                        onClicked: setAppMainScreen("PopupRadioRdsTa",false);
                    }
                }
                //KSW 140220
                Text {
                    text: "RDS_EngMode - Page 1"
                    font.pixelSize: 20
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("RDS_EngMode Page 1");
                            QmlController.setRdsEngMode(true);
                            QmlController.setEngModePage(0);
                            QmlController.diagnosticInfoRequest(5,0x01);
                        }
                    }
                }
                Text {
                    text: "RDS_EngMode Page 2"
                    font.pixelSize: 20
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("RDS_EngMode Page 2");
                            QmlController.setRdsEngMode(true);
                            QmlController.setEngModePage(1);
                            QmlController.diagnosticInfoRequest(1,0x01);
                        }
                    }
                }
                Text {
                    text: "RDS_EngMode Page 3"
                    font.pixelSize: 20
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("RDS_EngMode Page 3");
                            QmlController.setRdsEngMode(true);
                            QmlController.setEngModePage(2);
                            QmlController.diagnosticInfoRequest(4,0x01);
                        }
                    }
                }

                Text {text: "//// CLOSE ////"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: idAppMain.debugMode = false
                    }
                }
            }//End Grid
        }//End Item - idDebugScreenItem
    }//End Rectangle -idDebugScreen

    Rectangle{
        id: idDebugFunctionScreen
        x:idDebugScreen.width;y:0 + 93;
        width: 200 ;height: 640
        color : "lightyellow"
        opacity: 0.7
        radius : 0.1
        visible: false
        Item{
            id: idDebugFunctionScreenItem
            x:0;y:0;
            Grid{
                rows: 40
                spacing: 2
                Text {text: "//// FUNCTION INFO //// "}
                Text {text: "GetPresetList "
                    MouseArea{
                        anchors.fill: parent
                        onClicked:QmlController.simulator_function(1);
                        /* Argument
                          1. getPresetList
                          2. RDS-getStationList
                        */
                    }
                }
                Text {text: "GetStationList "
                    font.pixelSize: 20
                    MouseArea{
                        anchors.fill: parent
                        onClicked:QmlController.simulator_function(2);
                        /* Argument
                          1. getPresetList
                          2. RDS-getStationList
                        */
                    }
                }
                Text {text: "Info Start(TA)"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.sendEventInfoStart(0x00, "HelloTA");
                    }
                }
                Text {text: "Info Start(News)"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.sendEventInfoStart(0x01, "HelloNews");
                    }
                }
//                Text {text: "Tune Dn"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: UIListener.sigTuneDial(-1);
//                    }
//                }
                Text {text: "MP AutoTest - EVT_MP_GET_FREQUENCY_REQ"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.testMPAutoTestEvent(1);
                    }
                }
                Text {text: "MP AutoTest - EVT_MP_FM_FREQ_FIX_REQ"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.testMPAutoTestEvent(2);
                    }
                }
                Text {text: "MP AutoTest - EVT_MP_AM_FREQ_FIX_REQ"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.testMPAutoTestEvent(3);
                    }
                }
                Text {text: "MP AutoTest - EVT_MP_TA_ON_REQ"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.testMPAutoTestEvent(4);
                    }
                }
                Text {text: "MP AutoTest - EVT_MP_TA_OFF_REQ"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.testMPAutoTestEvent(5);
                    }
                }
                Text {text: "MP AutoTest - EVT_MP_RDS_PS_NAME_REQ"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.testMPAutoTestEvent(6);
                    }
                }
                Text {text: "Go First"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.triggerGoFirstStationList();
                    }
                }
                Text {text: "Go Last"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.triggerGoLastStationList();
                    }
                }
                Text {text: "Band Toggle"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if( currentBand == 1)
                                UIListener.changeBandViaExternalMenu(0x03);
                            else
                                UIListener.changeBandViaExternalMenu(0x01);
                        }
                    }
                }
                Text {
                    text: "영어"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("check_1111_Change Language");
                            UIListener.simulator_ChangeLanguage(0x07);
                        }
                    }
                }
                Text {
                    text: "한국"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("check_1111_Change Language");
                            UIListener.simulator_ChangeLanguage(0x02);
                        }
                    }
                }
                Text {text: "//// CLOSE ////"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: idDebugFunctionScreen.visible = false
                    }
                }
            }//End Grid
        }//End Item - idDebugScreenItem
    }//End Rectangle -idDebugFunctionScreen
}
