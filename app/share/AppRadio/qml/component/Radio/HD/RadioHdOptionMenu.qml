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
    //property bool menuSaveButton    : idAppMain.alreadySaved == 1 ? true : false // 120917 PresetList HD ICON Number Change Code
    //property bool menuSaveButton    : idAppMain.alreadySaved

    property bool menuInfoButton : idAppMain.menuInfoFlag // 121218 Cover Animation
    property bool menuLoad        : false                 // JSH 130426 added

    menu5Enabled : !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)//!menuSaveButton
    menu6Enabled : ((QmlController.radioDisPlayType > 0) || (QmlController.radioBand == 0x03)) && menuLoad ? false : true
    onMenu6EnabledChanged: {
        var prevIndex = idRadioHdOptionMenu.linkedCurrentIndex
        console.log(">>>>>>>>>>>>>  onMenu6EnabledChanged ", prevIndex)
        idRadioHdOptionMenu.linkedCurrentIndex = 6
        if(menuInfoButton && menu6Enabled)
        {
            idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "on"
        }
        else
        {
            idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "off"
            //dg.jin 20150826 ITS 0267989  focus issue after changed HDRadio Display
            if(prevIndex == 6)
            {
                prevIndex = 7;
                console.log(">>>>>>>>>>>>>  onMenu6EnabledChanged ", prevIndex)
            }
        }
        idRadioHdOptionMenuModel.setProperty(idRadioHdOptionMenu.linkedCurrentIndex, "check", menuInfoButton && menu6Enabled) // JSH 131107
        idRadioHdOptionMenu.linkedCurrentIndex = prevIndex
    }
    onMenuInfoButtonChanged : {
        /////////////////////////////////////////////////////////////////
        // 121218
        var prevIndex = idRadioHdOptionMenu.linkedCurrentIndex
        idRadioHdOptionMenu.linkedCurrentIndex = 6

        if(menuInfoButton)
            idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "on"
        else
            idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "off"
        idRadioHdOptionMenuModel.setProperty(idRadioHdOptionMenu.linkedCurrentIndex, "check", menuInfoButton) // JSH 131107

        idRadioHdOptionMenu.linkedCurrentIndex = prevIndex
        /////////////////////////////////////////////////////////////////
    }

    //****************************** # Item Clicked #
    onDimCheck0Click: {
        if(idAppMain.hdRadioButton == true)
            return;

        idAppMain.initMode();
        menuAnimation = false; //idAppMain.gotoBackScreen(); // JSH 130324
        /////////////////////////////////////////////////////////////////////
        // JSH 130429 [in numerical order] [MChListDelegateOnlyRadio-> menuHdRadioFlag ON/OFF binding]
        QmlController.setHDRadiobutton(true);                       // 1
        idAppMain.hdRadioButton = true                              // 2
        QmlController.changeHDRadioONOFF(idAppMain.hdRadioButton);  // 3
        /////////////////////////////////////////////////////////////////////
        idRadioHdOptionMenuModel.setProperty(0, "check", idAppMain.hdRadioButton)// JSH 131107
        console.log(">>>>>>>>>>>>>  HD Radio ON", idAppMain.hdRadioButton)
    }
    onDimUncheck0Click: {
        if(idAppMain.hdRadioButton == false)
           return;

        idAppMain.initMode();
        menuAnimation = false; //idAppMain.gotoBackScreen(); // JSH 130324
        /////////////////////////////////////////////////////////////////////
        // JSH 130429 [in numerical order] [MChListDelegateOnlyRadio-> menuHdRadioFlag ON/OFF binding]
        QmlController.setHDRadiobutton(false);                      // 1
        idAppMain.hdRadioButton = false                             // 2
        QmlController.changeHDRadioONOFF(idAppMain.hdRadioButton);  // 3
        //QmlController.hdReset(); // JSH 130427 added                // 4 , JSH 130605 deleted [on/off bug]
        UIListener.sendDataToCluster();                             // 4 OSD UPDATE , JSH 131031 ITS[0205305]
        /////////////////////////////////////////////////////////////////////
        //JSH 130705 option menu position
        //        for(var i=0;i < idAppMain.children.length;i++){
        //            if(idAppMain.children[i].objectName == "MainArea"){
        //                for(var j=0;j < idAppMain.children[i].children[0].item.children.length;j++){
        //                    if(idAppMain.children[i].children[0].item.children[j].objectName == "RadioHdPresetList"){
        //                         idAppMain.children[i].children[0].item.children[j].changeListViewPosition(QmlController.getPresetIndex(QmlController.radioBand)-1);
        //                        //console.log("::::::::::::::::::::jjjjjjjjjjjjjjjjjjjjj:::::::::::::::::",idAppMain.children[6].children[0].item.children[j].objectName , j)
        //                    }
        //                }
        //            }
        //        }
        /////////////////////////////////////////////////////////////////////
        idRadioHdOptionMenuModel.setProperty(0, "check", idAppMain.hdRadioButton) // JSH 131107
        console.log(">>>>>>>>>>>>>  HD Radio OFF", idAppMain.hdRadioButton)
    }

//    onMenu1Click: {
//        console.log(">>>>>>>>>>>>>  Tagging")
//        if(!idAppMain.menuTaggingButton)
//            return;

//        QmlController.tagging();
//        //idAppMain.menuTaggingButton = false; // JSH 130523 deleted [Tag Button always enable]
//        idAppMain.gotoBackScreen();
//    }
    onMenu1Click: {
        console.log(">>>>>>>>>>>>>  Save as preset Click")
        if(idAppMain.presetEditEnabled) // JSH 130724 ITS[0181432] Issue
            return ;

        if( QmlController.searchState )
            QmlController.seekstop();

        menuAnimation = false; //gotoBackScreen();                   //JSH 121121 option menu close
        idAppMain.presetSaveEnabled = true; //JSH 121121 preset list save button enable
        /////////////////////////////////////////////////////////
        // JSH 121121 , popup preset List Delete
        //setAppMainScreen( "PopupRadioHdPreset" , true);
        ////QmlController.presetAppend(QmlController.radioFreq);
        /////////////////////////////////////////////////////////
    } // End Click
    onMenu2Click: {
        console.log(">>>>>>>>>>>>>  Preset Scan")

        menuAnimation = false; //idAppMain.gotoBackScreen();
        QmlController.setsearchState(0x07);//scanPreset(); //JSH 120614

    } // End Click
    onMenu3Click: {
        console.log(">>>>>>>>>>>>>  Scan")
        menuAnimation = false; //idAppMain.gotoBackScreen();
        QmlController.setsearchState(0x06);//scanFreq(); //JSH 120614
    } // End Click

    onMenu4Click: {
        console.log(">>>>>>>>>>>>>  Edit Preset Order")
        if(idAppMain.presetSaveEnabled) // JSH 130724 ITS[0181432] Issue
            return ;

        if( QmlController.searchState ) // JSH 130625 added
            QmlController.seekstop();

        menuAnimation = false; //gotoBackScreen()
        idAppMain.presetEditEnabled = true;

    } // End Click

    //onMenu5Click: {
    //    console.log(">>>>>>>>>>>>>  Scan SubMenu")
    //    setAppMainScreen( "AppRadioHdOptionMenuTwo" , true);
    //}
    onMenu5Click: {
        console.log(">>>>>>>>>>>>>  Auto Store")

        menuAnimation = false; //idAppMain.gotoBackScreen();
        QmlController.setsearchState(0x05);//setBSM(); //JSH 120614
    } // End Click

    onDimCheck6Click: {
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
        idRadioHdOptionMenuModel.setProperty(6, "check", menuInfoFlag) // JSH 131107
        console.log(">>>>>>>>>>>>>  Info ON ", menuInfoFlag)
    }
    onDimUncheck6Click: {
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
        idRadioHdOptionMenuModel.setProperty(6, "check", menuInfoFlag) // JSH 131107
        ///////////////////////////////////////////////////////
        console.log(">>>>>>>>>>>>>  Info OFF ", menuInfoFlag)
    }


    onMenu7Click: {
        console.log(">>>>>>>>>>>>>  Sound Setting Click")
        idAppMain.selectedSoundSetting = true;
        UIListener.launchSettingSound();
    } // End Clickp

    //****************************** # Menu Close when clicked I, L, Slash key && Left Key #
    onClickMenuKey: {
        if(idAppMain.state == "AppRadioHdOptionMenu")
             menuAnimation = false; // JSH 130418 added menuAnimation  //gotoBackScreen()
    }
    //    onLeftKeyPressed:{
    //        if(idAppMain.state == "AppRadioHdOptionMenu")
    //            menuAnimation = false; // JSH 130418 added menuAnimation  // gotoBackScreen()
    //    }
    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed:  menuAnimation = false; // JSH 130418 added menuAnimation  //gotoBackScreen()

    //****************************** # Item Model #
    ListModel { //# FM
        id: idRadioHdOptionMenuModel
        ///////////////////////////////////////////////////////////
        // JSH 130820 Modify
        ListElement { name: "HD Radio";         opType: "dimCheck"; check:false}
        ListElement { name: "Save as Preset";   opType: "";         check:false}
        ListElement { name: "Preset Scan";      opType: "";         check:false}
        ListElement { name: "All Channel Scan"; opType: "";         check:false}
        ListElement { name: "Edit Preset Order";opType: "";         check:false}
        ListElement { name: "Auto Store";       opType: "";         check:false}
        ListElement { name: "Radio Text";       opType: "dimCheck"; check:false} //"Info"
        ListElement { name: "Sound Setting";    opType: "";         check:false}
        //        ListElement { name: "HD Radio"; opType: "dimCheck"}
        //        //ListElement { name: "Tagging"; opType: ""}
        //        ListElement { name: "Auto Store";opType: ""}
        //        ListElement { name: "Save as Preset";opType: ""}
        //        ListElement { name: "Edit Preset Order";opType: ""}
        //        ListElement { name: "Preset Scan";opType: ""}
        //        ListElement { name: "All Channel Scan";opType: ""}
        //        //ListElement { name: "Scan";opType: "subMenu"}
        //        ListElement { name: "Radio Text"; opType: "dimCheck"} //"Info"
        //        ListElement { name: "Sound Setting";opType: ""}
        ///////////////////////////////////////////////////////////
    }
    //****************************** # TimeOut or Dim click #
    onOptionMenuFinished:if(idAppMain.state == "AppRadioHdOptionMenu") menuAnimation = false; // JSH 130418 added menuAnimation//gotoBackScreen()

//    Connections {
//        target: QmlController
//        onChagneHdRadioButton:{
//            if(idAppMain.hdRadioButton == onoff)
//                return;

//            idAppMain.hdRadioButton = onoff;
//            QmlController.setHDRadiobutton(idAppMain.hdRadioButton);   // JSH 120214 add

//            var prevIndex = idRadioHdOptionMenu.linkedCurrentIndex
//            idRadioHdOptionMenu.linkedCurrentIndex = 0

//            if(idAppMain.hdRadioButton)
//                idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "on"
//            else
//                idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "off"

//            idRadioHdOptionMenu.linkedCurrentIndex = prevIndex
//        }
//    }
    //****************************** # Translation #
        function setModelString(){
            idRadioHdOptionMenuModel.get(0).name = stringInfo.strHDMenuHdRadio//stringInfo.strHDMenuSoundSetting
            idRadioHdOptionMenuModel.get(1).name = stringInfo.strHDMenuSaveAsPreset//stringInfo.strHDMenuScan
        //// 2013.11.27 modified by qutiguy - ITS 0211644
        if(QmlController.searchState == 0x07)
            idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDRadioMenuStopScan
        else
            idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDMenuPresetScan
        if(QmlController.searchState == 0x06)
            idRadioHdOptionMenuModel.get(3).name = stringInfo.strHDRadioMenuStopScan
        else
            idRadioHdOptionMenuModel.get(3).name = stringInfo.strHDMenuScan
//        idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDMenuPresetScan
//        idRadioHdOptionMenuModel.get(3).name = stringInfo.strHDMenuScan
        ////
            idRadioHdOptionMenuModel.get(4).name = stringInfo.strHDMenuEditPresetOrder//stringInfo.strHDMenuSaveAsPreset
            idRadioHdOptionMenuModel.get(5).name = stringInfo.strHDMenuAutoStore//stringInfo.strHDMenuHdRadio
            idRadioHdOptionMenuModel.get(6).name = stringInfo.strHDMenuInfo
            idRadioHdOptionMenuModel.get(7).name = stringInfo.strHDMenuSoundSetting
        }
        Component.onCompleted: {setModelString();menuLoad = true}
        onVisibleChanged: { // JSH 130222
            if(visible){
                  //var prevIndex = idRadioHdOptionMenu.linkedCurrentIndex

                ////////////////////////////////////////////////////////////////
                // HD Radio ON/OFF
                idRadioHdOptionMenu.linkedCurrentIndex = 0
                idAppMain.hdRadioButton = QmlController.getHDRadiobutton();
                if(idAppMain.hdRadioButton) // idAppMain.hdRadioButton == QmlController.getHDRadiobutton()
                    idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "on"
                else
                    idRadioHdOptionMenu.linkedCurrentItem.dimCheckFlag = "off"
                idRadioHdOptionMenuModel.setProperty(idRadioHdOptionMenu.linkedCurrentIndex, "check", idAppMain.hdRadioButton) // JSH 131107
                ////////////////////////////////////////////////////////////////
                // Info ON/OFF
                idRadioHdOptionMenu.linkedCurrentIndex = 6

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

                idRadioHdOptionMenuModel.setProperty(idRadioHdOptionMenu.linkedCurrentIndex, "check", menuInfoButton) // JSH 131107

                //                ////////////////////////////////////////////////////////////////
                //                // Tag enable , disable JSH 130417 => 130620 delete

                //                //idRadioHdOptionMenu.linkedCurrentIndex = 1
                //                //menu1Enabled = idAppMain.menuTaggingButton

                //                if(menu1Enabled != idAppMain.menuTaggingButton){
                //                    var temp = idAppMain.menuTaggingButton;
                //                    idAppMain.menuTaggingButton = !idAppMain.menuTaggingButton;
                //                    idAppMain.menuTaggingButton = temp;
                //                }
                //                ////////////////////////////////////////////////////////////////

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
        // JSH 131020
        Connections{
            target : QmlController
            onChangeSearchState:{
                if(value == 0x06){
                    idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDMenuPresetScan
                    idRadioHdOptionMenuModel.get(3).name = stringInfo.strHDRadioMenuStopScan;
                }
                else if(value == 0x07){
                    idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDRadioMenuStopScan;
                    idRadioHdOptionMenuModel.get(3).name = stringInfo.strHDMenuScan
                }else{
                    idRadioHdOptionMenuModel.get(2).name = stringInfo.strHDMenuPresetScan
                    idRadioHdOptionMenuModel.get(3).name = stringInfo.strHDMenuScan
                }
            }
        }
        //////////////////////////////////////////////////////////////////////
} // End MOptionMenu
