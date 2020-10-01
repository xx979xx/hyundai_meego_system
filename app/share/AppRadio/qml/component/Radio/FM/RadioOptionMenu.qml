/**
 * FileName: RadioOptionMenu.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */
import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MOptionMenu{
    id: idRadioOptionMenu
    focus: true

    RadioStringInfo{ id: stringInfo }

    //****************************** # Item Model #
    linkedModels  : idRadioOptionMenuModel;
    linkedDelegate:  Component{RadioOptionMenuDelegate{id:idRadioOptionMenuDelegate}}
    menu0Enabled : !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)//(!menuSaveButton)
    //menu2Enabled : (!idAppMain.alreadySaved) , JSH 130625 delete

    //****************************** # Item Clicked #
    // JSH 121121 , Change the order of option Menu
    onMenu0Click: {
        console.log("[[[AM/FM Radio OptionMenu index 0]]]");
        option_auto_store();
        //// 2013.12.29 added by qutiguy - ITS 0210488
        idAppMain.checkVRStatus();
        ////
    }
    onMenu1Click: {
        if(idAppMain.presetEditEnabled) // JSH 130724 ITS[0181432] Issue
            return ;
        console.log("[[[AM/FM Radio OptionMenu index 1]]]");
        option_save_preset();
    }
    onMenu2Click: {
        if(idAppMain.presetSaveEnabled) // JSH 130724 ITS[0181432] Issue
            return ;
        console.log("[[[AM/FM Radio OptionMenu index 2]]]");
        option_edit_preset_order();
    }
    onMenu3Click: {
        console.log("[[[AM/FM Radio OptionMenu index 3]]]");
        option_preset_scan();
        //// 2013.12.29 added by qutiguy - ITS 0210488
        idAppMain.checkVRStatus();
        ////
    }
    onMenu4Click: {
        console.log("[[[AM/FM Radio OptionMenu index 4]]]");
        option_scan();
        //// 2013.12.29 added by qutiguy - ITS 0210488
        idAppMain.checkVRStatus();
        ////
    }
    onMenu5Click: {
        console.log("[[[AM/FM Radio OptionMenu index 5]]]");
        option_sound_setting();
    }

    function option_scan(){
        console.log(">>>>>>>>>>>>>  Scan")
        menuAnimation = false; //gotoBackScreen()
        QmlController.setsearchState(0x06);//scanFreq(); //JSH 120614
    } // End Click
    function option_save_preset() {
        console.log(">>>>>>>>>>>>>  Save as preset Click")

        if( QmlController.searchState )
            QmlController.seekstop();

        menuAnimation = false; //gotoBackScreen();                   //JSH 121121 option menu close
        idAppMain.presetSaveEnabled = true; //JSH 121121 preset list save button enable
        /////////////////////////////////////////////////////////
        // JSH 121121 , popup preset List Delete
        //setAppMainScreen( "PopupRadioPreset" , true);
        ////QmlController.presetAppend(QmlController.radioFreq);
        /////////////////////////////////////////////////////////
    } // End Click
    function option_preset_scan() {
        console.log(">>>>>>>>>>>>>  Preset Scan")
        menuAnimation = false; //gotoBackScreen()
        QmlController.setsearchState(0x07);//scanPreset(); //JSH 120614
    } // End Click
    function option_auto_store() {
        console.log(">>>>>>>>>>>>>  Auto Store")
        menuAnimation = false; //gotoBackScreen()
        QmlController.setsearchState(0x05);//setBSM(); //JSH 120614
    } // End Click

    function option_edit_preset_order() { // JSH 121121 , edit preset order added
        console.log(">>>>>>>>>>>>>  Edit Preset Order")

        if( QmlController.searchState ) // JSH 130625 added
            QmlController.seekstop();

        menuAnimation = false; //gotoBackScreen()
        idAppMain.presetEditEnabled = true;
    } // End Click

    function option_sound_setting() {
        console.log(">>>>>>>>>>>>>  Sound Setting")
        //QmlController.playAudioBeep(); // JSH 120827 comment
        //QmlController.seekstop(); //JSH 120614
        idAppMain.selectedSoundSetting = true;
        UIListener.launchSettingSound();
    } // End Click

    //****************************** # Menu Close when clicked I, L, Slash key && Left Key #
    onClickMenuKey:{
        if(idAppMain.state == "AppRadioOptionMenu")
            menuAnimation = false; // JSH 130418 added menuAnimation  // gotoBackScreen()
    }
    //    onLeftKeyPressed:{
    //        if(idAppMain.state == "AppRadioOptionMenu")
    //             menuAnimation = false; // JSH 130418 added menuAnimation  //gotoBackScreen()
    //    }

    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed:  menuAnimation = false; // JSH 130418 added menuAnimation  // gotoBackScreen()

    //****************************** # Item Model #
    ListModel {
        id: idRadioOptionMenuModel
        /////////////////////////////////////////////////////////////
        // JSH 121121 , Change the order of option Menu
        //        ListElement { name: "Scan"; opType: ""}
        //        ListElement { name: "Save as preset"; opType: ""}
        //        ListElement { name: "Preset Scan"; opType: ""}
        //        ListElement { name: "Auto Store"; opType: ""}
        //        ListElement { name: "Sound Setting"; opType: ""}
        ListElement { name: "Auto Store"        ; opType: ""}
        ListElement { name: "Save as preset"    ; opType: ""}
        ListElement { name: "Edit Preset Order" ; opType: ""}
        ListElement { name: "Preset Scan"       ; opType: ""}
        ListElement { name: "All Channel Scan"  ; opType: ""}
        ListElement { name: "Sound Setting"     ; opType: ""}
    }
    //****************************** # TimeOut or Dim click#
    onOptionMenuFinished:if(idAppMain.state == "AppRadioOptionMenu") menuAnimation = false; // JSH 130418 added menuAnimation  //gotoBackScreen()

    //****************************** # Translation #
/* Modified 0621 to add FM1<-> FM2
        function setModelString(){
            idRadioOptionMenuModel.get(0).name = stringInfo.strRadioMenuScan;
            idRadioOptionMenuModel.get(1).name = stringInfo.strRadioMenuSaveAsPreset;
            idRadioOptionMenuModel.get(2).name = stringInfo.strRadioMenuPresetScan;
            idRadioOptionMenuModel.get(3).name = stringInfo.strRadioMenuAutoStore;
            idRadioOptionMenuModel.get(4).name = stringInfo.strRadioMenuSoundSetting;
        }
*/
    function setModelString(){
        /////////////////////////////////////////////////////////////
        // JSH 121121 , Change the order of option Menu
        //        idRadioOptionMenuModel.get(0).name = stringInfo.strRadioMenuScan;
        //        idRadioOptionMenuModel.get(1).name = stringInfo.strRadioMenuSaveAsPreset;
        //        idRadioOptionMenuModel.get(2).name = stringInfo.strRadioMenuPresetScan;
        //        idRadioOptionMenuModel.get(3).name = stringInfo.strRadioMenuAutoStore;
        //        idRadioOptionMenuModel.get(4).name = stringInfo.strRadioMenuSoundSetting;

        idRadioOptionMenuModel.get(0).name = stringInfo.strRadioMenuAutoStore;
        idRadioOptionMenuModel.get(1).name = stringInfo.strRadioMenuSaveAsPreset;
        idRadioOptionMenuModel.get(2).name = stringInfo.strRadioMenuEditPresetOrder;
        //// 2013.11.27 modified by qutiguy - ITS 0211644
        if(QmlController.searchState == 0x07)
            idRadioOptionMenuModel.get(3).name = stringInfo.strRadioMenuStopScan;
        else
            idRadioOptionMenuModel.get(3).name = stringInfo.strRadioMenuPresetScan;
        if(QmlController.searchState == 0x06)
            idRadioOptionMenuModel.get(4).name = stringInfo.strRadioMenuStopScan;
        else
            idRadioOptionMenuModel.get(4).name = stringInfo.strRadioMenuScan;
//        idRadioOptionMenuModel.get(3).name = stringInfo.strRadioMenuPresetScan;
//        idRadioOptionMenuModel.get(4).name = stringInfo.strRadioMenuScan;
        ////
        idRadioOptionMenuModel.get(5).name = stringInfo.strRadioMenuSoundSetting;
    }

        Component.onCompleted: setModelString()
        onVisibleChanged: { // JSH 130222
            if(visible)
                idRadioOptionMenu.linkedCurrentIndex = 0 ; // default Position
        }
        Connections{
            target: UIListener
            onRetranslateUi: {
                setModelString();
            }
        }
        //////////////////////////////////////////////////////////////////////
        // JSH 131020
        Connections{
            target : QmlController
            onChangeSearchState:{
                if(value == 0x06){
                    idRadioOptionMenuModel.get(3).name = stringInfo.strRadioMenuPresetScan
                    idRadioOptionMenuModel.get(4).name = stringInfo.strRadioMenuStopScan;
                }
                else if(value == 0x07){
                    idRadioOptionMenuModel.get(3).name = stringInfo.strRadioMenuStopScan;
                    idRadioOptionMenuModel.get(4).name = stringInfo.strRadioMenuScan
                }else{
                    idRadioOptionMenuModel.get(3).name = stringInfo.strRadioMenuPresetScan
                    idRadioOptionMenuModel.get(4).name = stringInfo.strRadioMenuScan
                }
            }
        }
        //////////////////////////////////////////////////////////////////////
} // # End MOptionMenu





