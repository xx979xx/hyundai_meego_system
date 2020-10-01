/**
 * FileName: DHRadioHdMain.qml
 * Author: HYANG
 * Time: 2012-3
 *
 * - 2012-03 Initial Created by HYANG
 */

import Qt 4.7
import "../component/system/DH" as MSystem
import "../component/QML/DH" as MComp
import "../component/Radio/HD" as MRadio
import "../component/Radio/HD/JavaScript/RadioHdOperation.js" as MOperation
// 20130428 by qutiguy - use statusbar plugin.
import QmlStatusBar 1.0

MComp.MAppMain {

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MRadio.RadioHdStringInfo{ id: stringInfo }

    id: idAppMain
    x: 0; y: 0 //+ 47
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight +93
    focus: true

    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    //****************************** # First Main Screen #
    property string selectedMainScreen: "AppRadioHdMain"
    function currentAppStateID() { return MOperation.currentStateID(); }
    function preSelectedMainScreen() { return UIListener.popScreen(); }
    function setPreSelectedMainScreen() { UIListener.pushScreen(idAppMain.state); }
    function setAppMainScreen(mainScreen, saveCurrentScreen) {
        MOperation.setPropertyChanges(mainScreen, saveCurrentScreen);
        UIListener.setQmlDisplyaMode(mainScreen); // JSH 130910
    }
    function gotoBackScreen() { MOperation.backKeyProcessing(); }

    property real globalSelectedFmFrequency: 87.5    //# Variant frequency (FM)
    property real globalSelectedAmFrequency: (UIListener.getRadioRegionCode() == 4) ? 531 : 530    //# Variant frequency (AM) //dg.jin 20150707 add guam
    property string globalSelectedBand: "" //"FM1"//stringInfo.strHDBandFm         //# Band tab ("FM"|"AM") => FM1 , FM2

    property real startFmFrequency: 87.5        //# Variant frequency FM start value
    property real startAmFrequency: (UIListener.getRadioRegionCode() == 4) ? 531 : 530         //# Variant frequency AM start value  //dg.jin 20150707 add guam
    property real endFmFrequency: 107.9         //# Variant frequency FM end value
    property real endAmFrequency: (UIListener.getRadioRegionCode() == 4) ?  1701 : 1710          //# Variant frequency AM end value  //dg.jin 20150707 add guam
    property real stepFmFrequency: 0.1          //# Variant frequency FM step value
    property real stepAmFrequency: (UIListener.getRadioRegionCode() == 4) ? 9 : 10           //# Variant frequency AM step value  //dg.jin 20150707 add guam
    property int  preset_Num     : 18

    property bool    menuPresetScanFlag : (QmlController.searchState == 0x07)
    property bool    menuScanFlag       : (QmlController.searchState == 0x06)
    //property string  strStereoIcon      : QmlController.stereomode
    property bool    menuAutoTuneFlag   : (QmlController.searchState == 0x05)

    property bool menuInfoFlag: false           //# Info On/Off of OptionMenu
    property bool menuHdRadioFlag: false
    property bool buttonSaveFlag: true          //# Save button On/Off
    property bool focusState    : true          //#

    //**********************************# Arrow of MVisualCue
    property bool arrowUp: true
    property bool arrowDown: true
    property bool arrowLeft: true
    property bool arrowRight: true
    ////////////////////////////////////////////////////////////////
    // JSH 120306
    property int  engineerMode       : 0
    property bool touchAni           : false  // JSH 130422 added
    property bool hdRadioButton      : false
    property int  textType           : 0        // 0 :: LINKING , 1:: Acquiring Signal…
    //property bool hdRadioRTInfoOnOff : false => menuInfoFlag
    //property bool hdPsdInfo          : fals  => menuHdRadioFlag
    property bool   hdRadioOnOff     : false
    property bool   infoFlag         : false
    property bool   fmInfoFlag       : false    // JSH 130326
    property bool   amInfoFlag       : false    // JSH 130326
    property string toastMessage     : ""
    property string toastMessageSecondText     : ""
    property int   alreadySaved      : -1
    property string strPopupText1    : ""
    property string strPopupText2    : ""
    property string strPopupText3    : ""
    property bool   modelLoadOn      : false //firstBootCheck   : false
    ////////////////////////////////////////////////////////////////
//    property bool presetSaveEnabled : false // JSH 121121 , preset list save button on /off
//    property bool presetEditEnabled : false // JSH 121121 , preset list Edit button on /off
    property bool menuTaggingButton : false // JSH 130417 [optionMenu -> DHRadioHdMain.qml]
    /// Show Debug Screen
    property bool debugMode    : false

    // Debuging value , HWS

    property string dtxtTitle    : "" //"txtTitle"
    property string dtxtArtist   : "" //"txtArtist"
    property string dtxtAlbum    : "" //"txtAlbum"
    property string dpadImagePath: ""
    property string dhdRtText    : ""
    property string dhdSIS       : ""

    property int    acHex       : 0
    property string acStatus    : ""
    property int    currentSps  : 0
    property string currentPty  : ""
    property int    currentSnr  : 0
    property bool   doNotUpdate : false  // JSH 130131 focus do not update
    property string psdTitle    : ""
    property string psdArtist   : ""
    property string psdAlbum    : ""
    property bool   hdSignalPerceive : false
    property bool   drsShow     : false // JSH 130501 added
    property bool   globalMenuAnimation : idRadioHdOptionMenu.item.menuAnimation
    property string rtText          : ""
    property string hdRtText        : ""
    property bool   selectedSoundSetting : false
    //property bool   isCCPMovedWhenSearching : false
    property int    displayState: 0         // JSH 130821 , 0 : non , 1 : BG , 2 : FG
    property int    prevAudioSource : 0;    // JSH 130903
    property int    ptyNum : 0;
    property int    lineNum : 0;
    signal          pressCancelSignal();    // JSH 130906
    //****************************** # Loading completed (First Focus) #
    Component.onCompleted:{
        setAppMainScreen(selectedMainScreen, true);
        alreadySaved = 0;
    }
    onStrPopupText1Changed:{// JSH 120516 , firstContentText Change
        if(strPopupText1 == "")
            return;

        if(idAppMain.state != "AppRadioHdMain") // JSH 130817
            gotoBackScreen();

        setAppMainScreen("PopupRadioHdPresetWarning", true);
    }
    onToastMessageChanged:{
        if(toastMessage == ""){
            if(idAppMain.state == "PopupRadioHdDimAcquiring")
                gotoBackScreen();
        }
    }

    onStateChanged: {
        switch(idAppMain.state){
        case "AppRadioHdMain":               idRadioHdMain.forceActiveFocus();               break;
        case "AppRadioHdOptionMenu":         idRadioHdOptionMenu.forceActiveFocus();         break;
        //case "PopupRadioHdPreset":           idRadioHdPopupPreset.forceActiveFocus();        break;
        case "PopupRadioHdDimAcquiring":     idRadioHdPopupDimAcquiring.forceActiveFocus();  break;  //dg.jin 140515 ITS 0237450 preset list Long pressing focus issue 
        default:  console.debug("=== onStateChanged : idAppMain.state == "+idAppMain.state); break;
        }
    }
    onBeep:QmlController.playAudioBeep(); //JSH 120827

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
    Rectangle { // statusbar Dim , JSH 131104
        id:statusBarDim
        visible: idRadioHdPopupPresetWarning.visible ? true : false
        width: systemInfo.lcdWidth
        height: 93
        color: colorInfo.black
        opacity: 0.6
        z: 1
    }
    //****************************** # ChannelList Background Image #
    Image{
        y: 0 //-systemInfo.statusBarHeight+2
        source: imgFolderGeneral+"bg_main.png"//  "bg_type_b.png"//"bg.png"
    }

    //****************************** # Radio Main #
    FocusScope{
        id: idRadioHdMainArea
        objectName: "MainArea"; // JSH 130418 added
        focus: true
        x: 0;
//        Loader {id: idRadioHdMain;              y: 0    ; source: "../component/Radio/HD/RadioHdMain.qml"                   ; visible: false } // systemInfo.statusBarHeight }
//        Loader {id: idRadioHdOptionMenu;        y: 0    ; source: "../component/Radio/HD/RadioHdOptionMenu.qml"             ; visible: false }
//        Loader {id: idRadioHdPopupPreset;       y: 0    ; source: "../component/Radio/HD/Popup/RadioHdPopupPreset.qml"      ; visible: false } // systemInfo.statusBarHeight }
//        Loader {id: idRadioHdPopupDimAcquiring; y: 0    ; source: "../component/Radio/HD/Popup/RadioHdPopupDimAcquiring.qml"; visible: false } // systemInfo.statusBarHeight }
//        Loader {id: idRadioENGModeMain;         y: 0    ; source: "../component/Radio/ENGMode/ENGModeMain.qml"              ; visible: false } // systemInfo.statusBarHeight }  // JSH 120406
        Loader {id: idRadioHdMain;              y: 93    ; visible: false } // systemInfo.statusBarHeight }
        Loader {id: idRadioHdOptionMenu;        y: 91    ; visible: false } //dg.jin 20140902 ITS 0243389 full focus issue for KH 93->91
        //Loader {id: idRadioHdOptionMenuTwo;     y: 93    ; visible: false } // JSH 130510 Two depth added
        //Loader {id: idRadioHdPopupPreset;       y: 0    ; visible: false } // systemInfo.statusBarHeight }
        Loader {id: idRadioHdPopupDimAcquiring; y: 93    ; visible: false } // systemInfo.statusBarHeight }
        Loader {id: idRadioENGModeMain;         y: 93    ; visible: false } // systemInfo.statusBarHeight }  // JSH 120406
        Loader {id: idRadioHdPopupPresetWarning; y: 93   ; visible: false }
    }
    Connections{
        target: UIListener
        onLoadQML:{ // JSH 120810 Boot Time
            //idRadioHdOptionMenu.source  = "../component/Radio/HD/RadioHdOptionMenu.qml" // JSH 130326 Delete
            QmlController.askHDRadiobuttonONOFF();         // option menu(hdradioonoff button) init
            modelLoadOn = true; //firstBootCheck    = true;                      // first boot
            ////////////////////////////////////////////////
            // JSH 121121 , popup preset List Delete
            //idPresetPopupModel.clear()
            //for(var i=0;preset_Num>i;i++){
            //    idPresetPopupModel.append({"presetPopupText":"Empty"});
            //}
            ////////////////////////////////////////////////
        }
        /////////////////////////////////////////////////////////////////////////
        ////////// Popup Close
        //        onSigTuneDial:{
        //            //console.log("[DHRadioHdMain.qml] onSigTuneDial ")
        //            popupClose();
        //        }
        /////////////////////////////////////////////////////////////////////////
    }
    //20130201 modified by qutiguy - signal for FG Event to go main screen or keep current screen
    Connections{
        target: UIListener
        onSigEventRequestFG:{
            if(!value){
                console.log(">>>>>>>>>>>>>>>>>>>>onSigEventRequestFG>>>>>>>>>>>>>>>>",value)
                ////////////////////////////////////////////////////////////////////////
                // JSH 131018 Modify
                //popupClose(false);
                if(idRadioHdPopupPresetWarning.visible    ) {gotoBackScreen();}
                else if(idRadioHdPopupDimAcquiring.visible) {gotoBackScreen();}
                else if(idRadioHdOptionMenu.visible)        {
                    if(idRadioHdOptionMenu.item.menuAnimation)
                        gotoBackScreen();//idRadioHdOptionMenu.item.menuAnimation = false;
                }
                else if(idAppMain.presetSaveEnabled)        {gotoBackScreen();}
                else if(idAppMain.presetEditEnabled)        {gotoBackScreen();}
                ////////////////////////////////////////////////////////////////////////
            }
            else // JSH 130927
                displayState = 3;
        }
        //KSw 140602
        onSigEventRequestBG : {
            console.log(" ====================================================onSigEventRequestBG");
            idAppMain.pressCancelSignal();
        }

        onSignalShowSystemPopup:{ // JSH 130328
            if(idRadioHdPopupPresetWarning.visible)     {gotoBackScreen();}
            else if(idRadioHdPopupDimAcquiring.visible) {gotoBackScreen();}
            else if(idRadioHdOptionMenu.visible)        {
                //if(idRadioHdOptionMenuTwo.visible)
                //    gotoBackScreen();
                idAppMain.optionMenuHide(); //20141017 dg.jin systempopup hide option menu
            }
            else{ // JSH 130924
                idAppMain.pressCancelSignal();
            }
            idAppMain.focusOn = false;
        }
        onSignalHideSystemPopup:{ // JSH 130328
            idAppMain.focusOn = true;
        }
        onDrsShowSignal         :   { drsShow = show    }               // JSH 130501 added
        onPopupClose            :   {                                   // JSH 130828
            switch(cl){
            case 1:
                if(idRadioHdPopupDimAcquiring.visible)
                    gotoBackScreen();
                break;
            default: idAppMain.popupClose(true);  break; // JSH 130827 ITS[0186856]
            }
        }
    }

    Connections{
        target: QmlController
        onChangeInfoOnOff :{ // JSH 130904
            if(info){
                idAppMain.fmInfoFlag = true;
                idAppMain.menuInfoFlag = true;
            }else{
                idAppMain.fmInfoFlag = false;
                idAppMain.menuInfoFlag = false;
            }
        }
/////////////////////////////////////////////////////////////
//  JSH 140211 DHRadioHdMain -> RadioHdMain Moved
//        onChangeTagButtonEnable : {
//            //////////////////////////////////////////////////////////////////////////////
//            // JSH 130726 => JSH 130819 Modify , ITS [0181797] Issue
//            if(menuTaggingButton && (!enable) && (!QmlController.searchState)){
//                if((!idAppMain.isTouchMode()) && (idRadioHdMain.item.jogFocusState == "Band")){//if(idMBand.children[18].focusImageVisible){
//                    if(QmlController.getRadioDisPlayType() < 2)
//                        idRadioHdMain.item.jogFocusState = "FrequencyDial"
//                    else
//                        idRadioHdMain.item.jogFocusState = "HDDisplay"
//                }
//            }
//            //////////////////////////////////////////////////////////////////////////////
//            menuTaggingButton = enable; // JSH 130417 [optionMenu -> DHRadioHdMain.qml]
//        }
        onEngModeDisPlay:{
            if(engModeOnOff && (idAppMain.state != "AppRadioHdENGMode"))
                setAppMainScreen("AppRadioHdENGMode", true);
            else if(idAppMain.state == "AppRadioHdENGMode" && engModeOnOff == 0)
                gotoBackScreen();
        }
        /////////////////////////////////////////////////////////////////////////
        ////////// Popup Close
        onPopupClose:{popupClose(true);} // JSH 130319 => JSH 130903 [(true) added] , seek up/down , ITS[0184865]
        onChangeSearchState: {
//            console.log(" HJIGKS: [DHRadioHdMain.qml] onChangeSearchState value :" + value );
            console.log(" ====================================================onChangeSearchState");
            if(value){
                popupClose(!(value > 2 && value < 8));
                idAppMain.initMode() // JSH 130717 Fixed bug
            }
        }
        onChangeAudioCHset:{
            //console.log("+++++++++++++onChangeAudioCHset+++++++++++++++",QmlController.getAudioCHset() , QmlController.getRadioBand()+1 , prevAudioSource)

            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // {analog -> hd or hd -> analog , poupClose X => 130903 Modify , ITS[0184865]} => {131025 modify ITS[0198378 , 0198377]}
            //if((QmlController.getAudioCHset() > 5)||(prevAudioSource >5&&(QmlController.getAudioCHset()<5))){
            // analog => HD changed
            if(   (prevAudioSource == QmlController.getAudioEnumNumber(0x01) && band == QmlController.getAudioEnumNumber(0x26))
               || (prevAudioSource == QmlController.getAudioEnumNumber(0x02) && band == QmlController.getAudioEnumNumber(0x27))
               || (prevAudioSource == QmlController.getAudioEnumNumber(0x03) && band == QmlController.getAudioEnumNumber(0x28))){

                prevAudioSource = QmlController.getAudioCHset();
                return;
            }
            // HD => analog changed
            else if(   (prevAudioSource == QmlController.getAudioEnumNumber(0x26) && band == QmlController.getAudioEnumNumber(0x01))
                    || (prevAudioSource == QmlController.getAudioEnumNumber(0x27) && band == QmlController.getAudioEnumNumber(0x02))
                    || (prevAudioSource == QmlController.getAudioEnumNumber(0x28) && band == QmlController.getAudioEnumNumber(0x03))){

                prevAudioSource = QmlController.getAudioCHset();
                return;
            }
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            else if(QmlController.getAudioCHset() != QmlController.getRadioBand()+1){// getAudioCHset(avoff(1) FM(2) AM(4)), getRadioBand(FM(1) AM(3))
                popupClose(false);
            }

            prevAudioSource =  QmlController.getAudioCHset();
        }
// 20130418 modified by qutiguy - when pressed soundsettings & go to BG
        onChangeAppState:{
            //console.log("+++++++++++onChangeAppState+++++++++++++++")
            if((QmlController.getAppState() == 0x01) && idAppMain.selectedSoundSetting){
                if(idRadioHdOptionMenu.visible)        {
                    //if(idRadioHdOptionMenuTwo.visible)
                    //    gotoBackScreen();
                    gotoBackScreen();
                }
                idAppMain.selectedSoundSetting = false;
            }

            // 130821
            // 1. [0] : first boot == non, [1] : BG , [2] : FG , [3] : SigEventRequestFG
            // 2. BG -> FG , 130927 modify

            //if((!displayState) || ((displayState == 2) && (QmlController.getAppState() == 1))){     // JSH 130924 deleted  ITS[0190927]
            if(((displayState == 0) || (displayState == 1)) && (QmlController.getAppState() == 2)){   // JSH 130924 added    ITS[0190927]
                if(QmlController.getPresetIndex(QmlController.radioBand) > 12){
                    if(QmlController.getRadioDisPlayType() < 2)
                        idRadioHdMain.item.jogFocusState = "FrequencyDial"
                    else
                        idRadioHdMain.item.jogFocusState = "HDDisplay"
                }
                else{
                    idRadioHdMain.item.jogFocusState = "PresetList"
                }
            }
            idRadioHdMain.item.children[15].changeListViewPosition(QmlController.getPresetIndex(QmlController.radioBand)-1); // JSH 131125 dynamic test issue
            displayState = QmlController.getAppState();
        }
        /////////////////////////////////////////////////////////////////////////
        // HWS 130118
        onHdRadioPsdUptate:{
            // 0 : clear , 1 : title , 2 : artist , 3 : album , 4:commnet , 5 : Lot ID
            if(type == 0){
                dtxtTitle     = ""
                dtxtArtist    = ""
                dtxtAlbum     = ""
                dhdRtText = ""
                dpadImagePath = "";
            }
            if(type == 0x01)              // Title Name
                dtxtTitle = msg
            else if(type == 0x02)         // Artist Name
                dtxtArtist = msg
            else if(type == 0x03)       // Album Name
                dtxtAlbum = msg
            else if(type == 0x04)         // Comment Text
                dhdRtText = msg
            //else if(type ==0x05)        // Lot ID
        }
        onHdRadioSisUptate:{
            if(type == 0x01)                                                        // short station Name 1
                dhdSIS = msg
            else if((type >= 0x02 && type <= 0x04)&& dhdSIS == "")      // Long  station Name 2 ,ALFN 3, Universal 4
                dhdSIS = msg
            else                                                                    // type == 0x05(clear)
                dhdSIS = msg
        }
        onHdSignalAC:{
            switch(type){
            case 1 :{
                acStatus =""
                if(ac == 0x01)
                    acStatus = "HD Acquired"
                else if(ac == 0x03)
                    acStatus = "SIS Acquired"
                else if(ac == 0x07)
                    acStatus = "Digital Audio Ac"
                else
                    acStatus =""
                acHex = ac
                break;
            }
            case 2:  {
                currentSps  = ac
                break;
            }
            case 3:   {
                currentSnr = ac
                break;
            }
            default:  break;
            }
        }
        onChangePty:{
            currentPty =ptyString
        }
        onDoNotUpdate:{ // JSH 140211
            doNotUpdate = update
        }
        /////////////////////////////////////////////////////////////////////////

    }
    function popupClose(hk){
        console.log("+++++++++++popupClose()+++++++++++++++")
        if(idRadioHdPopupPresetWarning.visible      && (!hk)) {gotoBackScreen();}
        else if(idRadioHdPopupDimAcquiring.visible)           {gotoBackScreen();}
        //else if(idRadioHdPopupPreset.visible)       {gotoBackScreen();}
        else if(idRadioHdOptionMenu.visible)        {
            //if(idRadioHdOptionMenuTwo.visible)
            //    gotoBackScreen();
            if(idRadioHdOptionMenu.item.menuAnimation)
                idRadioHdOptionMenu.item.menuAnimation = false;//gotoBackScreen();
        }
        else if(idAppMain.presetSaveEnabled)        {gotoBackScreen();}//idAppMain.presetSaveEnabled = false}
        else if(idAppMain.presetEditEnabled)        {gotoBackScreen();}//idAppMain.presetEditEnabled = false}
    }
    //****************************** # Item Model #
    //ListModel{id: idPresetPopupModel}  // JSH 121121 , popup preset List Delete

    ////////////////////////////////////////////
    //debugging screen

    Rectangle {
        id: idDebugScreen
        x:0;y:0 + 93;
        width: 300;height: 700
        color : "yellow"
        opacity: 0.7
        radius : 0.1
        visible: false//idAppMain.debugMode
        Item {
            id: idDebugScreenPropery
            x:0;y:0;
            Grid{
                rows: 40
                spacing: 2
                Text {text: "Band          = " + QmlController.radioBand}
                Text {text: "Frequency  = " + QmlController.radioFreq}
                Text {text: "Search       = " + QmlController.searchState}
                Text {text: "p-IndexFM1 = " + QmlController.presetIndexFM1}
                Text {text: "p-IndexFM2 = " + QmlController.presetIndexFM2}
                Text {text: "p-IndexAM  = " + QmlController.presetIndexAM}
                Text {text: "B-Name      = " + QmlController.boradcastName}
                Text {text: "App State    = " + QmlController.AppState}
                Text {text: "--------------------"}
                Text {text: "SIS          = " +dhdSIS }
                Text {text: "Title        = " + dtxtTitle }
                Text {text: "Artist       = " +dtxtArtist }
                Text {text: "Album      = " +dtxtAlbum }
                Text {text: "Ac Status = " + acStatus +"("+ acHex+")"}
                Text {text: "SPS      = " +currentSps }
                Text {text: "PTY      = " +currentPty }
                Text {text: "SNR      = " +currentSnr }
                Text {text: "--------------------"}
                //Text {
                //    text: "Scan"
               //     MouseArea{
               //         anchors.fill: parent
               //         onClicked: QmlController.scanFreq();
               //     }
                //}
                //Text {
                //    text: "SeekUp"
                //    MouseArea{
                //        anchors.fill: parent
                //        onClicked: QmlController.seekup();
                //    }
                //}
                //Text {
                //    text: "SeekDown"
                //    MouseArea{
                //        anchors.fill: parent
                //        onClicked: QmlController.seekdown();
                //    }
                //}
                //Text {
                //    text: "BSM"
                //    MouseArea{
                //        anchors.fill: parent
                //        onClicked: QmlController.setBSM();
                 //   }
                //}
                //Text {
               //     text: "Scan Preset"
               //     MouseArea{
                //        anchors.fill: parent
                //        onClicked: QmlController.scanPreset();
                //    }
                //}
                Text {
                    text: "Test Jog wheel (10)"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {UIListener.setDialFocus(1);UIListener.test_jog_wheel(10);}
                    }
                }
                Text {
                    text: "Test Jog wheel (-10)"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {UIListener.setDialFocus(1);UIListener.test_jog_wheel(-10);}
                    }
                }
                Text {
                    text: "first_Boot"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.firstBoot();
                    }
                }                      
                Text {
                    text: "engModeDisPlayOnOff"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: QmlController.setEngModeDisPlayOnOff(true);
                    }
                }
                Text {
                    text: "psdTitle"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: idAppMain.psdTitle != "" ?  idAppMain.psdTitle = "" : idAppMain.psdTitle = "TTTTEEEEEEE%TTTTTTTTTTTTTTTTTYUUUUUUUUU"
                    }
                }
                Text {
                    text: "rtText"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: idAppMain.rtText == "" ?  idAppMain.rtText = "TTTTEEEEEEE%TTTTTTTTTTTTTTTTTYUUUUUUUUU" : idAppMain.rtText == "TTTTEEEEEEE%TTTTTTTTTTTTTTTTTYUUUUUUUUU" ? idAppMain.rtText = "TTTTEEEEEEE%TTT" : idAppMain.rtText = ""
                    }
                }
                Text {
                    text: "drsShow"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: idAppMain.drsShow  == false ? idAppMain.drsShow = true : idAppMain.drsShow = false
                    }
                }
                //Text {text: "--------------------"}
                //Text {
                //    text: "HDViewTest7"
                //    font.pixelSize: 13
                //    font.family: systemInfo.hdr
                //    MouseArea{
                //        anchors.fill: parent
                //        onClicked: QmlController.setHDRadioViewTest(7);
                //    }
                //}
                //Text {
                //    text: "HDViewTest3"
                //    font.pixelSize: 13
                //    font.family: systemInfo.hdr
                //    MouseArea{
                //        anchors.fill: parent
                //        onClicked: QmlController.setHDRadioViewTest(3);
                //    }
                //}
                //Text {
                //    text: "HDViewSetSIS"
                //    font.pixelSize: 13
                 //   font.family: systemInfo.hdr
                 //   MouseArea{
                 //       anchors.fill: parent
                 //       onClicked: QmlController.setHDRadioViewTest2();
                 //   }
                //}
                //Text {
                //    text: "HDViewMpsTune"
                //    font.pixelSize: 13
                //    font.family: systemInfo.hdr
                //    MouseArea{
                //        anchors.fill: parent
                //        onClicked: QmlController.setHDRadioViewTest(0);
                //    }
                //}
                Text {
                    text: "PTYTest next" + ptyNum
                    font.pixelSize: 13
                    font.family: systemInfo.hdr
                    MouseArea{
                        anchors.fill: parent
                        onClicked: QmlController.ptyStringUpdate(ptyNum++);
                    }
                } 
                //Text {
                //    text: "TestFileLoad " + lineNum 
                //    font.pixelSize: 13
                //    font.family: systemInfo.hdr
                //    MouseArea{
                //        anchors.fill: parent
                //        onClicked: QmlController.setHDRadioViewTestFileLoad(lineNum++);
                //    }
                //}
                Text {
                    text: "Ptynum linenum clear" 
                    font.pixelSize: 13
                    font.family: systemInfo.hdr
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            ptyNum = 0;
                            lineNum = 0;
                        }
                    }
                } 
                Text {text: "--------------------"}
                Text {
                    text: "Close"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: idAppMain.debugMode = false;
                    }
                }
            }
        }
    }
    //End Added by qutiguy 0612 for debugging
}
