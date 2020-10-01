/**
 * FileName: RadioHdOptionMenu.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */
import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp
MComp.MOptionMenu{
    id: idRadioHdOptionMenu
    focus: true
    //****************************** # Item Model #
    linkedModels:  idRadioHdOptionMenuModel
    linkedDelegate:  Component{RadioHdOptionMenuDelegate{id:idRadioOptionMenuDelegate}}

    property bool menuInfoButton : idAppMain.menuInfoFlag
    property bool menuLoad        : false

    menu4Enabled : !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
    menu5Enabled : ((QmlController.radioDisPlayType > 0) || (QmlController.radioBand == 0x03)) && menuLoad ? false : true
    onMenu5EnabledChanged: {
        var prevIndex = idRadioHdOptionMenu.linkedCurrentIndex
        idRadioHdOptionMenu.linkedCurrentIndex = 5
        if(menuInfoButton && menu5Enabled)
            idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "on"
        else
            idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "off"
        idRadioHdOptionMenu.linkedCurrentIndex = prevIndex
    }
    onMenuInfoButtonChanged : {
        /////////////////////////////////////////////////////////////////
        // 121218
        var prevIndex = idRadioHdOptionMenu.linkedCurrentIndex
        idRadioHdOptionMenu.linkedCurrentIndex = 5

        if(menuInfoButton)
            idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "on"
        else
            idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "off"

        idRadioHdOptionMenu.linkedCurrentIndex = prevIndex
        /////////////////////////////////////////////////////////////////
    }

    onMenu0Click: {
        console.log(">>>>>>>>>>>>>  Save as preset Click")
        if(idAppMain.presetEditEnabled) // JSH 130724 ITS[0181432] Issue
            return ;

        if( QmlController.searchState )
            QmlController.seekstop();

        menuAnimation = false; //gotoBackScreen();                   //JSH 121121 option menu close
        idAppMain.presetSaveEnabled = true; //JSH 121121 preset list save button enable
    } // End Click
    onMenu1Click: {
        console.log(">>>>>>>>>>>>>  Preset Scan")

        menuAnimation = false; //idAppMain.gotoBackScreen();
        QmlController.setsearchState(0x07);//scanPreset(); //JSH 120614

    } // End Click
    onMenu2Click: {
        console.log(">>>>>>>>>>>>>  Scan")
        menuAnimation = false; //idAppMain.gotoBackScreen();
        QmlController.setsearchState(0x06);//scanFreq(); //JSH 120614
    } // End Click

    onMenu3Click: {
        console.log(">>>>>>>>>>>>>  Edit Preset Order")
        if(idAppMain.presetSaveEnabled) // JSH 130724 ITS[0181432] Issue
            return ;

        if( QmlController.searchState ) // JSH 130625 added
            QmlController.seekstop();

        menuAnimation = false; //gotoBackScreen()
        idAppMain.presetEditEnabled = true;

    } // End Click

    onMenu4Click: {
        console.log(">>>>>>>>>>>>>  Auto Store")

        menuAnimation = false; //idAppMain.gotoBackScreen();
        QmlController.setsearchState(0x05);//setBSM(); //JSH 120614
    } // End Click

    onDimCheck5Click: {
        menuAnimation = false; //idAppMain.gotoBackScreen(); // JSH 130324
        ///////////////////////////////////////////////////////
        //  JSH 130402 delete [AM , HD Info Delete]
        if(QmlController.radioBand == 0x01){
            idAppMain.fmInfoFlag = true;
            idAppMain.menuInfoFlag = true;
            QmlController.infoSendToMICOM(1); // JSH 130904
        }
        //else if(QmlController.radioBand == 0x03)
        //    idAppMain.amInfoFlag = true;
        ///////////////////////////////////////////////////////
        idRadioHdOptionMenuModel.setProperty(5, "check", menuInfoFlag) // JSH 131107
        console.log(">>>>>>>>>>>>>  Info ON ", menuInfoFlag)
    }
    onDimUncheck5Click: {
        menuAnimation = false; //idAppMain.gotoBackScreen(); // JSH 130324
        ///////////////////////////////////////////////////////
        //  JSH 130402 delete [AM , HD Info Delete]
        if(QmlController.radioBand == 0x01){
            idAppMain.fmInfoFlag    = false;
            idAppMain.menuInfoFlag  = false;
            QmlController.infoSendToMICOM(0); // JSH 130904
        }
        //else if(QmlController.radioBand == 0x03)
        //    idAppMain.amInfoFlag = false;
        ///////////////////////////////////////////////////////
        idRadioHdOptionMenuModel.setProperty(5, "check", menuInfoFlag) // JSH 131107
        console.log(">>>>>>>>>>>>>  Info OFF ", menuInfoFlag)
    }


    onMenu6Click: {
        console.log(">>>>>>>>>>>>>  Sound Setting Click")
        idAppMain.selectedSoundSetting = true;
        UIListener.launchSettingSound();
    } // End Clickp

    //****************************** # Menu Close when clicked I, L, Slash key && Left Key #
    onClickMenuKey: {
        if(idAppMain.state == "AppRadioHdOptionMenu")
             menuAnimation = false; // JSH 130418 added menuAnimation  //gotoBackScreen()
    }
    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed:  menuAnimation = false; // JSH 130418 added menuAnimation  //gotoBackScreen()

    //****************************** # Item Model #
    ListModel {
        id: idRadioHdOptionMenuModel
        ////////////////////////////////////////////////////////////////////////////////
        //JSH 131127 Modify
        ListElement { name: "Save as Preset";   opType: "";         check:false}
        ListElement { name: "Preset Scan";      opType: "";         check:false}
        ListElement { name: "All Channel Scan"; opType: "";         check:false}
        ListElement { name: "Edit Preset Order";opType: "";         check:false}
        ListElement { name: "Auto Store";       opType: "";         check:false}
        ListElement { name: "Radio Text";       opType: "dimCheck"; check:false} //"Info"
        ListElement { name: "Sound Setting";    opType: "";         check:false}
        //        ListElement { name: "Save as Preset";opType: ""}
        //        ListElement { name: "Preset Scan";opType: ""}
        //        ListElement { name: "All Channel Scan";opType: ""}
        //        ListElement { name: "Edit Preset Order";opType: ""}
        //        ListElement { name: "Auto Store";opType: ""}
        //        ListElement { name: "Radio Text"; opType: "dimCheck"}
        //        ListElement { name: "Sound Setting";opType: ""}
        ////////////////////////////////////////////////////////////////////////////////
    }
    //****************************** # TimeOut or Dim click #
    onOptionMenuFinished:if(idAppMain.state == "AppRadioHdOptionMenu") menuAnimation = false;

    //****************************** # Translation #
        function setModelString(){
            idRadioHdOptionMenuModel.get(0).name = stringInfo.strHDMenuSaveAsPreset
        //// 2013.11.27 modified by qutiguy - ITS 0211644
        if(QmlController.searchState == 0x07)
            idRadioHdOptionMenuModel.get(1).name = stringInfo.strHDRadioMenuStopScan
        else
            idRadioHdOptionMenuModel.get(1).name = stringInfo.strHDMenuPresetScan
        if(QmlController.searchState == 0x06)
            idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDRadioMenuStopScan
        else
            idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDMenuScan
        ////
            idRadioHdOptionMenuModel.get(3).name = stringInfo.strHDMenuEditPresetOrder
            idRadioHdOptionMenuModel.get(4).name = stringInfo.strHDMenuAutoStore
            idRadioHdOptionMenuModel.get(5).name = stringInfo.strHDMenuInfo
            idRadioHdOptionMenuModel.get(6).name = stringInfo.strHDMenuSoundSetting
        }
        Component.onCompleted: {setModelString();menuLoad = true}
        onVisibleChanged: { // JSH 130222
            if(visible){
                ////////////////////////////////////////////////////////////////
                // Info ON/OFF
                idRadioHdOptionMenu.linkedCurrentIndex = 5

                if(QmlController.radioBand == 0x01){
                    //menu6Enabled    = QmlController.getRadioDisPlayType() ? false : true;
                    menuInfoButton  = QmlController.getRadioDisPlayType() ? false : idAppMain.fmInfoFlag;
                }
                else if(QmlController.radioBand == 0x03){
                    //menu6Enabled    = false;
                    menuInfoButton  = idAppMain.amInfoFlag;
                }

                if(menuInfoButton)
                    idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "on"
                else
                    idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "off"

                idRadioHdOptionMenuModel.setProperty(idRadioHdOptionMenu.linkedCurrentIndex, "check", menuInfoButton) // JSH 131127

                // Focus no.1 selected
                idRadioHdOptionMenu.linkedCurrentIndex = 0//prevIndex
            }
        }
        Connections{
            target: UIListener
            onRetranslateUi: {
                setModelString()
            }
        }
        //////////////////////////////////////////////////////////////////////
        // JSH 131126
        Connections{
            target : QmlController
            onChangeSearchState:{
                if(value == 0x06){
                    idRadioHdOptionMenuModel.get(1).name = stringInfo.strHDMenuPresetScan
                    idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDRadioMenuStopScan;
                }
                else if(value == 0x07){
                    idRadioHdOptionMenuModel.get(1).name = stringInfo.strHDRadioMenuStopScan;
                    idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDMenuScan
                }else{
                    idRadioHdOptionMenuModel.get(1).name = stringInfo.strHDMenuPresetScan
                    idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDMenuScan
                }
            }
        }
        //////////////////////////////////////////////////////////////////////
} // End MOptionMenu
