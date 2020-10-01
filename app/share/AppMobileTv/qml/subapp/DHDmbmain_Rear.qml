/**
 * FileName: DmbTotalChListView.qml
 * Author: WSH
 *
 * - 2013-01-04 // function syncToPresetEditModel() by WSH
 */

import Qt 4.7
import Qt.labs.gestures 2.0

import "../component/system/DH" as MSystem
import "../component/Dmb" as MDmb
import "../component/Dmb/JavaScript/DmbOperation.js" as MDmbOperation
import "../component/QML/DH" as MComp

MComp.MAppMain{
    id: idAppMain
    x:0; y:systemInfo.statusBarHeight //for AppMobileTv(VEXTEngine)
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    viewMode: "big"
    focus: true
    property bool debugOnOff: false;
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
//    property bool isFullScreen : false
    property bool isDLSChannel : false
    property bool drivingRestriction : false //EngineListener.m_DRSmode
    property QtObject presetPopupListModel : idPresetPopupModel
    property QtObject presetListModel: DmbPresetModel1  //preset chList
//    property QtObject totalListModel: DmbChannelModel1
    property bool presetEditEnabled : false //  Preset Order - WSH(130205)

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

    // WSH(130123) ====================== START
    // Fuction of [SEEK]
    function playerMainSeekPrevKeyPressed() {
//        console.debug("=========== playerMainSeekPrevKeyPressed() CommParser.m_iPresetListIndex == "+CommParser.m_iPresetListIndex )
//        console.debug("=========== playerMainSeekPrevKeyPressed() presetListModel.rowCount() == "+presetListModel.rowCount() )

        if(idAppMain.state != "AppDmbPlayer") return

        //            idAppMain.playBeep(); /* Play Beep when Only LongKey */
        if(presetListModel.rowCount() == 0) return

        if(CommParser.m_iPresetListIndex <= 0)
            CommParser.m_iPresetListIndex = presetListModel.rowCount() - 1
        else
            CommParser.m_iPresetListIndex--;

        CommParser.onChannelSelectedByIndex(CommParser.m_iPresetListIndex, false, false);
    } // End playerMainSeekPrevKeyPressed
    function playerMainSeekPrevLongKeyReleased(){
//        console.debug("=========== playerMainSeekPrevLongKeyReleased() CommParser.m_iPresetListIndex == "+CommParser.m_iPresetListIndex )
//        console.debug("=========== playerMainSeekPrevLongKeyReleased() presetListModel.rowCount() == "+presetListModel.rowCount() )
        playerMainSeekPrevKeyPressed()
    } // End playerMainSeekPrevLongKeyReleased
    // Fuction of [TRACK]
    function playerMainSeekNextKeyPressed() {
//        console.debug("=========== playerMainSeekNextKeyPressed() CommParser.m_iPresetListIndex == "+CommParser.m_iPresetListIndex )
//        console.debug("=========== playerMainSeekNextKeyPressed() presetListModel.rowCount() == "+presetListModel.rowCount() )

        if(idAppMain.state != "AppDmbPlayer") return

        //            idAppMain.playBeep(); /* Play Beep when Only LongKey */
        if(presetListModel.rowCount() == 0) return

        if(CommParser.m_iPresetListIndex == presetListModel.rowCount() - 1 )
            CommParser.m_iPresetListIndex = 0;
        else
            CommParser.m_iPresetListIndex++;

        CommParser.onChannelSelectedByIndex(CommParser.m_iPresetListIndex, false, false);
    } // End playerMainSeekNextKeyPressed
    function playerMainSeekNextLongKeyReleased(){
//        console.debug("=========== playerMainSeekNextLongKeyReleased() CommParser.m_iPresetListIndex == "+CommParser.m_iPresetListIndex )
//        console.debug("=========== playerMainSeekNextLongKeyReleased() presetListModel.rowCount() == "+presetListModel.rowCount() )
        playerMainSeekNextKeyPressed()
    } // End playerMainSeekNextLongKeyReleased
    // Fuction of [TRACK]
    function playerMainTuneRightKeyPressed() {
//        console.debug("=========== playerMainTuneRightKeyPressed() CommParser.m_iPresetListIndex == "+CommParser.m_iPresetListIndex )
//        console.debug("=========== playerMainTuneRightKeyPressed() presetListModel.rowCount() == "+presetListModel.rowCount() )
        if(idAppMain.state != "AppDmbPlayer") return

        if(presetListModel.rowCount() == 0) return

        if(CommParser.m_iPresetListIndex == presetListModel.rowCount() - 1 )
            CommParser.m_iPresetListIndex = 0;
        else
            CommParser.m_iPresetListIndex++;

        CommParser.onChannelSelectedByIndex(CommParser.m_iPresetListIndex, false, false);

    } // End playerMainTuneRightKeyPressed

    function playerMainTuneLeftKeyPressed() {
//        console.debug("=========== playerMainTuneLeftKeyPressed() CommParser.m_iPresetListIndex == "+CommParser.m_iPresetListIndex )
//        console.debug("=========== playerMainTuneLeftKeyPressed() presetListModel.rowCount() == "+presetListModel.rowCount() )
        if(idAppMain.state != "AppDmbPlayer") return

        if(presetListModel.rowCount() == 0) return

        if(CommParser.m_iPresetListIndex == 0)
            CommParser.m_iPresetListIndex = presetListModel.rowCount() - 1
        else
            CommParser.m_iPresetListIndex--;

        CommParser.onChannelSelectedByIndex(CommParser.m_iPresetListIndex, false, false);

    } // playerMainTuneLeftKeyPressed
    // WSH(130123) ====================== END

    // Loading Completed!!
    Component.onCompleted: {
        if(presetEditEnabled == true) presetEditEnabled = false //  Preset Order - WSH(130205)
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
        //CommParser.autoTest_athenaSendObject();
        //console.debug("[onStateChanged] idAppMain.state: CommParser.autoTest_athenaSendObject() ")
//        console.debug("[onStateChanged] idAppMain.state: " + idAppMain.state)
        idAppMain.focus = true
        currentAppStateID().focus = true;
    }

    //Send to Qt
    signal cmdLanguageChange()

    //Send to QML
//    signal showDisasterMessage(string popupTitle, string disasterMessage)
    signal showDisasterMessage(int alarmPriority, string popupTitle, string disasterMessage)
    signal totalChannelListCountChanged(int count)
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
        y:0 //PlanB
        // Load for DHDmbPlayerMain.qml
        Loader { id: idDmbPlayerMain }
        // Load for DmbTotalChMain.qml
        Loader { id: idDmbTotalChMain }
        // Load for DmbChMgtMain.qml
        Loader { id: idDmbChMgtMain }
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
        x:0; y:0 //PlanB
        // Load for DmbPlayerOptionMenu.qml
        Loader { id: idDmbPlayerOptionMenu}
        // Load for DmbPlayerSubMenuScreenSize.qml
        Loader { id: idDmbPlayerSubMenuScreenSize}
        // Load for DmbTotalChOptionMenu.qml
        Loader { id: idDmbTotalChOptionMenu}
        // Load for DmbChMgtOptionMenu.qml
        Loader { id: idDmbChMgtOptionMenu}
        // Load for DmbDisasterOptionMenu.qml
        Loader { id: idDmbDisasterOptionMenu}
        // Load for DmbDisasterEditOptionMenu.qml
        Loader { id: idDmbDisasterEditOptionMenu}
    }

    /** POPUP LOADER ******************************/
    Item {
        id: idDmbPopup
        x:0
        y:0 //PlanB
        // Load for DmbPopupSearchRange.qml
        Loader { id: idPopupSearchRange}
        // Load for DmbPopupSearching.qml
        Loader { id: idPopupSearching }
        // Load for DmbPopupSearched.qml
        Loader { id: idPopupSearched }
        // Load for DmbPopupDeleting.qml
        Loader { id: idPopupDeleting }
        // Load for DmbPopupListEmpty.qml
        Loader { id: idPopupListEmpty }
//        // Load for DmbPopupAlreadySetPresetList.qml
//        Loader { id: idPopupAlreadySetPresetList }
        // Load for DmbPopupChannelDeleteAllConfirm.qml
        Loader { id: idPopupChannelDeleteAllConfirm }
        // Load for DmbPopupDisasterInformation.qml
        Loader { id: idPopupDisasterInformation }
        // Load for DmbPopupDisasterDeleteConfirm.qml
        Loader { id: idPopupDisasterDeleteConfirm }
        // Load for DmbPopupDisasterDeleteAllConfirm.qml
        Loader { id: idPopupDisasterDeleteAllConfirm }
        // Load for DmbPopupDisasterDeleting.qml
        Loader { id: idPopupDisasterDeleting }
//        // Load for DmbPopupPreset.qml
//        Loader { id: idPopupPreset }
        // Load for DmbPopupOutReciveArea.qml
        Loader { id: idPopupOutReciveArea }
        // Load for DmbPopupFrequencySearching.qml
        Loader { id: idPopupFrequencySearching }

        //Dim Popup
        // Load for DmbDimPopupDeleted.qml
        Loader { id: idDimPopupDeleted }
        // Load for DmbDimPopupUnsetPresetChannel.qml
        Loader { id: idDimPopupUnsetPresetChannel }
        // Load for DmbDimPopupSetFullScreen.qml
        Loader { id: idDimPopupSetFullScreen }
    }

    ListModel{
        id: idPresetPopupModel
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";}
        ListElement{presetPopupText: "Empty";} //DMB Preset 18
    }

    //Event from CommParser
    Connections{
        target: CommParser
        onChannelSearchCompleted: {
            if(idAppMain.state == "PopupSearching"){
//                console.log("[luna] onChannelSearchCompleted")
                setAppMainScreen("PopupSearched", false)
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
}
