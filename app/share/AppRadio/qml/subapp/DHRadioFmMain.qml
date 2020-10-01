/**
 * FileName: DHRadioFmMain.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */

import Qt 4.7
import "../component/system/DH" as MSystem
import "../component/QML/DH" as MComp
import "../component/Radio/FM" as MRadio
import "../component/Radio/FM/JavaScript/RadioOperation.js" as MOperation
// 20130428 by qutiguy - use statusbar plugin.
import QmlStatusBar 1.0

MComp.MAppMain {

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MRadio.RadioStringInfo{ id: stringInfo }

    id: idAppMain
    x: 0; y: 0 //+ 47
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight +93
    focus: true

    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    //****************************** # First Main Screen #
    property string selectedMainScreen: "AppRadioMain"
    function currentAppStateID() { return MOperation.currentStateID(); }
    function preSelectedMainScreen() {return UIListener.popScreen(); }
    function setPreSelectedMainScreen() { UIListener.pushScreen(idAppMain.state); }
    function setAppMainScreen(mainScreen, saveCurrentScreen) {
        MOperation.setPropertyChanges(mainScreen, saveCurrentScreen);
        UIListener.setQmlDisplyaMode(mainScreen); // JSH 130910
    }
    function gotoBackScreen() { MOperation.backKeyProcessing(); }

    property real globalSelectedFmFrequency: 87.5    //# Variant frequency (FM)
    property real globalSelectedAmFrequency: 531    //# Variant frequency (AM)
    property string globalSelectedBand: ""//"FM1"//stringInfo.strRadioBandFm1   //# Band tab ("FM1"|"FM2"|"AM")
    property string fmFrequencyDialFocusBand: ""

    property real startFmFrequency: 87.5        //# Variant frequency FM start value
    property real startAmFrequency: 531         //# Variant frequency AM start value
    property real endFmFrequency: 108.0         //# Variant frequency FM end value
    property real endAmFrequency: 1602          //# Variant frequency AM end value
    property real stepFmFrequency: 0.1          //# Variant frequency FM step value
    property real stepAmFrequency: 9            //# Variant frequency AM step value
    property int  preset_Num     : 12


    property bool    menuPresetScanFlag : (QmlController.searchState == 0x07)
    property bool    menuScanFlag       : (QmlController.searchState == 0x06)
    //property string  strStereoIcon      : QmlController.stereomode
    property bool    menuAutoTuneFlag   : (QmlController.searchState == 0x05)
    property bool    buttonSaveFlag     : true          //# Save button On/Off
    property bool    modelLoadOn        : false         //firstBootCheck     : false
    property bool    doNotUpdate        : false         // JSH 130131 focus do not update

    ////////////////////////////////////////////////////////////////
    // JSH 120306
    property int engineerMode    : 0
    property bool touchAni           : false  // JSH 130422 added
    property int alreadySaved   : -1
    property string toastMessage: ""
    ////////////////////////////////////////////////////////////////
    //**********************************# Arrow of MVisualCue
    property bool arrowUp           : true
    property bool arrowDown         : true
    property bool arrowLeft         : true
    property bool arrowRight        : true

//    property bool presetSaveEnabled : false // JSH 121121 , preset list save button on /off
//    property bool presetEditEnabled : false // JSH 121121 , preset list Edit button on /off

    /// Show Debug Screen
    property bool debugMode    : false

    property string hdr : "CHINESS_HDR"
    property string hdb : "CHINESS_HDB"
    property bool   drsShow     : false // JSH 130501 added
    property bool   globalMenuAnimation : idRadioOptionMenu.item.menuAnimation
    property bool   selectedSoundSetting : false
    property int    displayState: 0         //dg.jin 20140731 ITS 244683 , 0 : non , 1 : BG , 2 : FG
    signal          pressCancelSignal();// JSH 130906
    //// 2013.12.29 added by qutiguy - ITS 0210488 : set VR Status
    property bool isActiveVR : false;
    signal checkVRStatus();
    ////

    //****************************** # Loading completed (First Focus) #
    Component.onCompleted:{
        setAppMainScreen(selectedMainScreen, true);
        alreadySaved = 0;
    }
    //// 2013.12.29 added by qutiguy - ITS 0210488 : set VR Status
    onCheckVRStatus : {
        if(idAppMain.isActiveVR)
            UIListener.sendEventUISHtoCloseVR();
    }
    ////
    onStateChanged: {
        switch(idAppMain.state){
        case "AppRadioMain":               idRadioMain.forceActiveFocus(); break;
        case "AppOptionMenu":              idRadioOptionMenu.forceActiveFocus(); break;
        //case "PopupRadioPreset":           idRadioPopupPreset.forceActiveFocus(); break; // JSH 121121 , popup preset List Delete
        case "PopupRadioDimAcquiring":     idRadioPopupDimAcquiring.forceActiveFocus(); break;
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
        middleEast: false;
        visible:true
/*
    eCVInvalid      = -1,
    eCVKorea        =  0,
    eCVNorthAmerica =  1,
    eCVChina        =  2,
    eCVGeneral      =  3,
    eCVMiddleEast   =  4,
    eCVEuropa       =  5,
    eCVCanada       =  6,
    eCVInvalidMax   =  7
*/
    }
//    Rectangle { // statusbar Dim , JSH 131104
//        id:statusBarDim
//        visible: idRadioPopupPresetWarning.visible ? true : false
//        width: systemInfo.lcdWidth
//        height: 93
//        color: colorInfo.black
//        opacity: 0.6
//        z: 1
//    }
    //****************************** # ChannelList Background Image #
    Image{
        y: 0//-systemInfo.statusBarHeight
        source: imgFolderGeneral+"bg_main.png"//"bg_type_b.png"//"bg.png"
    }

    //****************************** # APP LOADER #
    FocusScope{
        id: idRadioMainArea
        objectName: "MainArea"; // JSH 130418 added
        focus: true        
        //        Loader {id: idRadioMain;        y: 0 ; source: "../component/Radio/FM/RadioMain.qml"       ; visible: false }
        Loader {id: idRadioMain;        y: 93 ; visible: false }
        //        Loader {id: idRadioOptionMenu;  y: 0 ; source: "../component/Radio/FM/RadioOptionMenu.qml" ; visible: false }
        Loader {id: idRadioOptionMenu;  y: 91 ; visible: false } //dg.jin 20140902 ITS 0243389 full focus issue for KH 93->91
        //Loader {id: idRadioPopupPreset; y: 0 ; visible: false}//systemInfo.statusBarHeight }// JSH 121121 , popup preset List Delete
        Loader {id: idRadioENGModeMain; y: 93 ; visible: false}//systemInfo.statusBarHeight }  // JSH 120406
        Loader {id: idRadioPopupPresetWarning; y: 93 ; visible: false}
        //        Loader {id: idRadioPopupDimAcquiring; y: 0 ; source: "../component/Radio/FM/Popup/RadioPopupDimAcquiring.qml"; visible: false  }
        Loader {id: idRadioPopupDimAcquiring; y: 93 ; visible: false  }

    }
    Connections{
        target: UIListener
        onLoadQML:{ // JSH 120810 Boot Time
            //idRadioOptionMenu.source  = "../component/Radio/FM/RadioOptionMenu.qml" //  JSH 130338 Delete
            modelLoadOn  = true;    //firstBootCheck    = true;                      // first boot
        }
        /////////////////////////////////////////////////////////////////////////
        ////////// Popup Close
        onSigTuneDial:{
            //console.log("[DHRadioFmMain.qml] onSigTuneDial ")
            popupClose(true);
        }
        /////////////////////////////////////////////////////////////////////////
    }
    //20130201 modified by qutiguy - signal for FG Event to go main screen or keep current screen
    Connections{
        target: UIListener
        onSigEventRequestFG:{
            console.log(">>>>>>>>>>>>>>>>>>>>onSigEventRequestFG>>>>>>>>>>>>>>>>",value)
            if(!value){
                ////////////////////////////////////////////////////////////////////////
                // JSH 131018 Modify
                //popupClose(false);
                if(idRadioPopupPresetWarning.visible    ) {gotoBackScreen();}
                else if(idRadioPopupDimAcquiring.visible) {gotoBackScreen();}
                else if(idRadioOptionMenu.visible)        {
                    if(idRadioOptionMenu.item.menuAnimation)
                        gotoBackScreen();//idRadioHdOptionMenu.item.menuAnimation = false;
                }
                else if(idAppMain.presetSaveEnabled)        {gotoBackScreen();}
                else if(idAppMain.presetEditEnabled)        {gotoBackScreen();}
                ////////////////////////////////////////////////////////////////////////
            }
            else //dg.jin 20140731 ITS 244683
                displayState = 3;
        }
        onSignalShowSystemPopup:{ // JSH 130328
            if(idRadioPopupPresetWarning.visible)     {gotoBackScreen();}
            else if(idRadioPopupDimAcquiring.visible) {gotoBackScreen();}
            else if(idRadioOptionMenu.visible)        {idAppMain.optionMenuHide();} //20141017 dg.jin systempopup hide option menu
            idAppMain.focusOn = false;
        }
        onSignalHideSystemPopup:{ // JSH 130328
            idAppMain.focusOn = true;
        }
        onDrsShowSignal         :   { drsShow = show }                  // JSH 130501 added
        onPopupClose            :   {                                   // JSH 130828
            switch(cl){
            case 1:
                //if(idRadioPopupDimAcquiring.visible)
                //    gotoBackScreen();
                break;
            default: idAppMain.popupClose(true);  break; // JSH 130827 ITS[0186856]
            }
        }
        //// 2013.12.29 added by qutiguy - ITS 0210488 : set VR Status
        onSignalActiveVR : {
            isActiveVR = value;
            console.log("[CHECK_12_29] onSignalActiveVR::isActiveVR  = " + isActiveVR);
            console.log("[CHECK_12_29] onSignalActiveVR::value  = " + value);
        }
        ////

    }
    Connections{
        target: QmlController
        onEngModeDisPlay:{
            if(engModeOnOff && (idAppMain.state != "AppRadioENGMode"))
                setAppMainScreen("AppRadioENGMode", true);
            else if(idAppMain.state == "AppRadioENGMode" && engModeOnOff == 0){
                gotoBackScreen();
            }
        }
        /////////////////////////////////////////////////////////////////////////
        ////////// Popup Close
        onChangeSearchState: {
            //console.log(" HJIGKS: [DHRadioFmMain.qml] onChangeSearchState value :" + value );
            if(value){
                popupClose(!(value > 2 && value < 8));//popupClose();
                idAppMain.initMode() // JSH 130717 Fixed bug
            }
        }
        onChangeAudioCHset:{
            //console.log("+++++++++++++onChangeAudioCHset+++++++++++++++")
            if(QmlController.getAudioCHset() != QmlController.getRadioBand()+1){popupClose(false);}
        }
        /////////////////////////////////////////////////////////////////////////
// 20130418 modified by qutiguy - when pressed soundsettings & go to BG
        onChangeAppState:{
            //console.log("+++++++++++onChangeAppState+++++++++++++++")
            if((QmlController.getAppState() == 0x01) && idAppMain.selectedSoundSetting){
                if(idRadioOptionMenu.visible)        {gotoBackScreen();}
                idAppMain.selectedSoundSetting = false;
            }
        }
    }
    function popupClose(hk){
        //console.log("+++++++++++popupClose(hk)+++++++++++++++")
        if(idRadioPopupPresetWarning.visible        && (!hk)) {gotoBackScreen();}
        else if(idRadioPopupDimAcquiring.visible)             {gotoBackScreen();}
        //else if(idRadioPopupPreset.visible)       {gotoBackScreen();}// JSH 121121 , popup preset List Delete
        else if(idRadioOptionMenu.visible)        {
            if(idRadioOptionMenu.item.menuAnimation)
                idRadioOptionMenu.item.menuAnimation = false;//gotoBackScreen();
        }
        else if(idAppMain.presetSaveEnabled)      {gotoBackScreen();}//idAppMain.presetSaveEnabled = false}
        else if(idAppMain.presetEditEnabled)      {gotoBackScreen();}//idAppMain.presetEditEnabled = false}
    }
    //****************************** # Item Model #
    // JSH 121121 , popup preset List Delete
    //    ListModel{
    //        id: idPresetPopupModel
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //        ListElement{presetPopupText: "Empty";}
    //    }

    ///////////////////////////////////////

    //debugging screen
    Rectangle {
        id: idDebugScreen
        x:0;y:0 + 93;
        width: 120;height: 600
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
//                Text {
//                    text: "Scan"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: QmlController.scanFreq();
//                    }
//                }
//                Text {
//                    text: "SeekUp"
//                    MouseArea{
//                        anchors.fill: parent
//                        //                            onClicked: QmlController.seekup();
//                        onClicked: QmlController.setChannel(3);
//                    }
//                }
//                Text {
//                    text: "SeekDown"
//                    MouseArea{
//                        anchors.fill: parent
//                        //                            onClicked: QmlController.seekdown();
//                        onClicked: QmlController.setChannel(4);
//                    }
//                }
//                Text {
//                    text: "BSM"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: QmlController.setBSM();
//                    }
//                }
//                Text {
//                    text: "Scan Preset"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: QmlController.scanPreset();
//                    }
//                }
//                Text {
//                    text: "Test Jog wheel (10)"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: UIListener.test_jog_wheel(10);
//                    }
//                }
//                Text {
//                    text: "Test Jog wheel (-10)"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: UIListener.test_jog_wheel(-10);
//                    }
//                }
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
                Text {text: "--------------------"}
                Text {
                    text: "External DTC"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: UIListener.startExternalDTC();
                    }
                }
                Text {text: "--------------------"}
//                Text {
//                    text: "Simulator Search"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: QmlController.simulator_make_actions();
//                    }
//                }
//                Text {
//                    text: "Simulator Stop"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: QmlController.simulator_stop();
//                    }
//                }
//                Text {text: "MP AutoTest - EVT_MP_GET_FREQUENCY_REQ"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: UIListener.testMPAutoTestEvent(1);
//                    }
//                }
//                Text {text: "MP AutoTest - EVT_MP_FM_FREQ_FIX_REQ"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: UIListener.testMPAutoTestEvent(2);
//                    }
//                }
//                Text {text: "MP AutoTest - EVT_MP_AM_FREQ_FIX_REQ"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: UIListener.testMPAutoTestEvent(3);
//                    }
//                }
//                Text {text: "MP AutoTest - EVT_MP_TA_ON_REQ"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: UIListener.testMPAutoTestEvent(4);
//                    }
//                }
//                Text {text: "MP AutoTest - EVT_MP_TA_OFF_REQ"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: UIListener.testMPAutoTestEvent(5);
//                    }
//                }
//                Text {text: "MP AutoTest - EVT_MP_RDS_PS_NAME_REQ"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: UIListener.testMPAutoTestEvent(6);
//                    }
//                }
//                Text {
//                    text: "First Boot"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: UIListener.firstBoot();
//                    }
//                }
                Text {
                    text: "printSharedMemory"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: QmlController.printPresetListfromSharedMemory();
                    }
                }
                Text {text: "--------------------"}
                //Text {
                //    text: "DisplayMode = " + UIListener.SENDMODE
                //    MouseArea{
               //         anchors.fill: parent
               //         onClicked: {
               //             console.log("[[[[[[Change DisplayMode before]]]]]]",UIListener.SENDMODE);
               //             if(UIListener.SENDMODE > 3)
               //                 UIListener.SENDMODE = 0;
               //             else
               //                 UIListener.SENDMODE += 1
               //             console.log("[[[[[[Change DisplayMode after]]]]]]",UIListener.SENDMODE);
               //             parent.text = "DisplayMode = " + UIListener.SENDMODE
                //        }
                //    }
                //}
//                Text {
//                    text: "Set Location 서울"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: QmlController.locationChanged(0x01, 0xFF);
//                    }
//                }
//                Text {
//                    text: "Set Location 부산"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: QmlController.locationChanged(0x0b, 0xFF);
//                    }
//                }
                Text {
                    text: "Set Location 대구"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: QmlController.locationChanged(0x0e, 0xFF);
                    }
                }
//                Text {
//                    text: "Set Location 충주"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: QmlController.locationChanged(0x07, 0x03);
//                    }
//                }
//                Text {
//                    text: "Set Location where I am"
//                    MouseArea{
//                        anchors.fill: parent
//                        onClicked: QmlController.locationChanged();
//                    }
//                }
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
