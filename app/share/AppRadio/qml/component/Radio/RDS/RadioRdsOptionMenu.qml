/**
 * FileName: RadioRdsOptionMenu.qml
 * Author: HYANG
 * Time: 2012-07
 *
 * - 2012-07 Initial Created by HYANG
 */
// modified by qutiguy - implement new GUI for RDS Radio based on UX scenario 2012.12.14
import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MOptionMenu{
    id: idRadioRdsOptionMenu
    focus: true

    property int activeFocusCheckFlag : 0
    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }

    linkedModels: {
        if(globalSelectedBand == 0x01) idRadioRdsFmOptionMenuModel
        else if(globalSelectedBand == 0x03) idRadioRdsMwOptionMenuModel
    }
    linkedDelegate:  Component{RadioRdsOptionMenuDelegate{id:idRadioRdsOptionMenuDelegate}}

    //****************************** # Station List #
    onMenu0Click:{        
//        launchStationList();
//        setAppMainScreen( "AppRadioRdsStationList" , false);
        gotoBackScreen();
        //20141013 dg.jin changed station list store
        if(globalSelectedBand == 0x01)
        {
            QmlController.loadStationlists(); //KSW 140205-1
            //KSW 140210
            if( QmlController.fileCheck("/app/data/AppRadio/","RDS_StationList.ini") == true)
            {
                QmlController.setIsStoreStationLists(true); //KSW 140211
                QmlController.command_system("rm -rf /app/data/AppRadio/RDS_StationList.ini");
            }
        }
        else
        {
            QmlController.loadStationlistsAM(); //KSW 140205-1
            if( QmlController.fileCheck("/app/data/AppRadio/","RDS_StationListAM.ini") == true)
            {
                QmlController.setIsStoreStationLists(true); //KSW 140211
                QmlController.command_system("rm -rf /app/data/AppRadio/RDS_StationListAM.ini");
            }
        }

        sigLaunchStation("from_menu");
    }

    //****************************** # Preset List #
    onMenu1Click: {
        gotoBackScreen();

        //dg.jin 20150630 Seek stop When enter preset list
        if(requestStopSearchforPresetList == true)
        {
            return;
        }
        if(QmlController.searchState != 0){
            requestStopSearchforPresetList = true;
            QmlController.setIsTpSearching(false);
            QmlController.seekstop();
            return;
        }
        requestStopSearchforPresetList = false;

        setAppMainScreen("AppRadioRdsPresetList" , true);
    } // End Click

    //****************************** # Save as Preset #
    onMenu2Click: {
        gotoBackScreen();
        b_presetsavemode = true;
        option_save_preset();
    } // End Click

    //****************************** # All Channel Scan #
    onMenu3Click: {
        option_scan();
    } // End Click

    //****************************** # Preset Scan #
    onMenu4Click: {
        option_preset_scan();
    } // End Click

    //****************************** # Info Setting # check button
    onDimCheck5Click: {
        if(globalSelectedBand == 0x01){
            //QmlController.rdsrtonoff = true;
            QmlController.setRDSRTOnOff(true); //KSW 130724 Fixed settings info should not have been maintained.
            gotoBackScreen();
            console.log(">>>>>>>>>>>>> Info off -> on")
        }
    } // End Click

    onDimUncheck5Click: {
        if(globalSelectedBand == 0x01){
//            QmlController.rdsrtonoff = false;
            QmlController.setRDSRTOnOff(false); //KSW 130724 Fixed settings info should not have been maintained.
            gotoBackScreen();
            console.log(">>>>>>>>>>>>> Info on -> off")
        }
    } // End Click

    //****************************** # Sound Setting # AM
    onMenu5Click: {
        if(globalSelectedBand == 0x03){
            option_sound_setting();
            console.log(">>>>>>>>>>>>> Info off -> on")
        }
    } // End Click

// 20130418 removed by qutiguy - spec changed. News does not used.
//    //****************************** # News Setting # check button
//    onDimCheck6Click: {
//        if(globalSelectedBand == 0x01){
//            QmlController.rdssettingsNews = true;
//            gotoBackScreen();
//            console.log(">>>>>>>>>>>>> News off -> on")
//        }
//    } // End Click
//    onDimUncheck6Click: {
//        if(globalSelectedBand == 0x01){
//            QmlController.rdssettingsNews = false;
//            gotoBackScreen();
//            console.log(">>>>>>>>>>>>> News on -> off")
//        }
//    } // End Click

    //****************************** # Region #
    onMenu6Click: {
        if(globalSelectedBand == 0x01){
            setAppMainScreen( "AppRadioRdsOptionMenuRegion" , true);
        }
    } // End Click

    //****************************** # Sound Setting # FM
    onMenu7Click: {
        if(globalSelectedBand == 0x01){
            option_sound_setting();
        }
    } // End Click

    //****************************** # Menu Open when clicked I, L, Slash key #
    onClickMenuKey: if(visible) menuAnimation = false;//gotoBackScreen() // JSH 130418 added menuAnimation
    onLeftKeyPressed: menuAnimation = false;//gotoBackScreen() // JSH 130418 added menuAnimation

    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed: menuAnimation = false;//gotoBackScreen() // JSH 130418 added menuAnimation

    //****************************** # OptionMenu Timer #
    onOptionMenuFinished: {
        //KSW 131024 [ITS][195847][major] oneDepth menu closed before to do close twodepth menu.
        //console.log("KSW AppRadioRdsOptionMenu onOptionMenuFinished == " ,idAppMain.state)
        if(idAppMain.state != "AppRadioRdsOptionMenu")
            return;
        if(visible) menuAnimation = false;
    }
    //****************************** # Item Model #
    ListModel { //# FM
        id: idRadioRdsFmOptionMenuModel
        ListElement { name: "Station List"; opType:""}
        ListElement { name: "Preset List"; opType:""}
        ListElement { name: "Save as Preset"; opType:""}
        ListElement { name: "All Channel Scan"; opType:""}
        ListElement { name: "Preset Scan"; opType:""}
        ListElement { name: "Info"; opType: "dimCheck"}
// 20130418 removed by qutiguy - spec changed. News does not used.
//        ListElement { name: "News"; opType: "dimCheck"}
        ListElement { name: "Region"; opType:"subMenu"}
        ListElement { name: "Sound Setting"; opType:""}
    }
    ListModel { //# MW
        id: idRadioRdsMwOptionMenuModel     
        ListElement { name: "Station List"; opType:""}       
        ListElement { name: "Preset List"; opType:""}
        ListElement { name: "Save as Preset"; opType:""}
        ListElement { name: "All Channel Scan"; opType:""}
        ListElement { name: "Preset Scan"; opType:""}
        ListElement { name: "Sound Setting"; opType:""}
    }


    //****************************** #
    onVisibleChanged: {
// 20130428 removed by qutiguy - to init index 0
//        var temp = idRadioRdsOptionMenu.linkedCurrentIndex

        if(idAppMain.globalSelectedBand == 0x01){
            //****************************** # RT On/Off #
            idRadioRdsOptionMenu.linkedCurrentIndex = 5
            if(idRadioRdsOptionMenu.linkedCurrentItem == null){
                idRadioRdsOptionMenu.linkedCurrentIndex = 0
                return;
            }
            //if(QmlController.rdsrtonoff) //KSW 130724 Fixed settings info should not have been maintained.
            if(QmlController.getRDSRTOnOff())
                idRadioRdsOptionMenu.linkedCurrentItem.dimCheckFlag = "on"
            else
                idRadioRdsOptionMenu.linkedCurrentItem.dimCheckFlag = "off"

// 20130418 removed by qutiguy - spec changed. News does not used.
//            //****************************** # News On/Off #
//            idRadioRdsOptionMenu.linkedCurrentIndex = 6
//            if(idRadioRdsOptionMenu.linkedCurrentItem == null){
//                idRadioRdsOptionMenu.linkedCurrentIndex = 0
//                return;
//            }
//            if(QmlController.rdssettingsNews)
//                idRadioRdsOptionMenu.linkedCurrentItem.dimCheckFlag = "on"
//            else
//                idRadioRdsOptionMenu.linkedCurrentItem.dimCheckFlag = "off"

        }
// 20130428 removed by qutiguy - to init index 0
        idRadioRdsOptionMenu.linkedCurrentIndex = 0;
    }
    /////////////////////////////////////////////////////////////////


    //****************************** # Translation #
    function setModelString(){
        if(globalSelectedBand != 0x03){
            idRadioRdsFmOptionMenuModel.get(0).name = stringInfo.strRDSMenuStationList;
            idRadioRdsFmOptionMenuModel.get(1).name = stringInfo.strRDSMenuPresetList;
            idRadioRdsFmOptionMenuModel.get(2).name = stringInfo.strRDSMenuSaveAsPreset;
            //// 2013.11.27 modified by qutiguy - ITS 0211644
            if(QmlController.searchState == 0x06)
                idRadioRdsFmOptionMenuModel.get(3).name = stringInfo.strRDSMenuStopScan;
            else
                idRadioRdsFmOptionMenuModel.get(3).name = stringInfo.strRDSMenuScan;
            if(QmlController.searchState == 0x07)
                idRadioRdsFmOptionMenuModel.get(4).name = stringInfo.strRDSMenuStopScan;
            else
                idRadioRdsFmOptionMenuModel.get(4).name = stringInfo.strRDSMenuPresetScan;
//            idRadioRdsFmOptionMenuModel.get(3).name = stringInfo.strRDSMenuScan;
//            idRadioRdsFmOptionMenuModel.get(4).name = stringInfo.strRDSMenuPresetScan;
            ////
            idRadioRdsFmOptionMenuModel.get(5).name = stringInfo.strRDSMenuInfo;
// 20130418 removed by qutiguy - spec changed. News does not used.
//            idRadioRdsFmOptionMenuModel.get(6).name = stringInfo.strRDSMenuNews;
            idRadioRdsFmOptionMenuModel.get(6).name = stringInfo.strRDSMenuRegion;
            idRadioRdsFmOptionMenuModel.get(7).name = stringInfo.strRDSMenuSoundSetting;
        }
        else if(globalSelectedBand == 0x03){
            idRadioRdsMwOptionMenuModel.get(0).name = stringInfo.strRDSMenuStationList;
            idRadioRdsMwOptionMenuModel.get(1).name = stringInfo.strRDSMenuPresetList;
            idRadioRdsMwOptionMenuModel.get(2).name = stringInfo.strRDSMenuSaveAsPreset;
            //// 2013.11.27 modified by qutiguy - ITS 0211644
            if(QmlController.searchState == 0x06)
                idRadioRdsMwOptionMenuModel.get(3).name = stringInfo.strRDSMenuStopScan;
            else
                idRadioRdsMwOptionMenuModel.get(3).name = stringInfo.strRDSMenuScan;
            if(QmlController.searchState == 0x07)
                idRadioRdsMwOptionMenuModel.get(4).name = stringInfo.strRDSMenuStopScan;
            else
                idRadioRdsMwOptionMenuModel.get(4).name = stringInfo.strRDSMenuPresetScan;
//            idRadioRdsMwOptionMenuModel.get(3).name = stringInfo.strRDSMenuScan;
//            idRadioRdsMwOptionMenuModel.get(4).name = stringInfo.strRDSMenuPresetScan;
            ////
            idRadioRdsMwOptionMenuModel.get(5).name = stringInfo.strRDSMenuSoundSetting;
        }
    }

    Component.onCompleted: setModelString()

    onLinkedModelsChanged: setModelString()
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
                if(globalSelectedBand != 0x03){
                    idRadioRdsFmOptionMenuModel.get(4).name = stringInfo.strRDSMenuPresetScan
                    idRadioRdsFmOptionMenuModel.get(3).name = stringInfo.strRDSMenuStopScan;
                }if(globalSelectedBand == 0x03){
                    idRadioRdsMwOptionMenuModel.get(4).name = stringInfo.strRDSMenuPresetScan
                    idRadioRdsMwOptionMenuModel.get(3).name = stringInfo.strRDSMenuStopScan;
                }
            }
            else if(value == 0x07){
                if(globalSelectedBand != 0x03){
                    idRadioRdsFmOptionMenuModel.get(4).name = stringInfo.strRDSMenuStopScan;
                    idRadioRdsFmOptionMenuModel.get(3).name = stringInfo.strRDSMenuScan
                }if(globalSelectedBand == 0x03){
                    idRadioRdsMwOptionMenuModel.get(4).name = stringInfo.strRDSMenuStopScan;
                    idRadioRdsMwOptionMenuModel.get(3).name = stringInfo.strRDSMenuScan
                }
            }else{
                if(globalSelectedBand != 0x03){
                    idRadioRdsFmOptionMenuModel.get(4).name = stringInfo.strRDSMenuPresetScan;
                    idRadioRdsFmOptionMenuModel.get(3).name = stringInfo.strRDSMenuScan
                }if(globalSelectedBand == 0x03){
                    idRadioRdsMwOptionMenuModel.get(4).name = stringInfo.strRDSMenuPresetScan;
                    idRadioRdsMwOptionMenuModel.get(3).name = stringInfo.strRDSMenuScan
                }
            }
        }
    }
    //////////////////////////////////////////////////////////////////////

    //****************************** # Functions #
    function option_save_preset() {
        //dg.jin 20150630 Seek stop When enter preset list
        if(requestStopSearchforPresetList == true)
        {
            return;
        }
        if(QmlController.searchState != 0){
            requestStopSearchforPresetList = true;
            QmlController.setIsTpSearching(false);
            QmlController.seekstop();
            return;
        }
        requestStopSearchforPresetList = false;

        setAppMainScreen("AppRadioRdsPresetList" , true);
    }

    function option_scan(){
        //KSW 140107 ITS/219032
        if(idAppMain.menuScanFlag == true)
            idAppMain.bForceDefaultFocus = true;

        QmlController.setsearchState(0x06);
        gotoBackScreen();
    }

    function option_preset_scan() {
        //KSW 140107 ITS/219032
        if(idAppMain.menuScanFlag == true)
            idAppMain.bForceDefaultFocus = true;

        QmlController.setsearchState(0x07);
        gotoBackScreen();
    }
    function option_auto_store() {
        QmlController.setsearchState(0x05);
        gotoBackScreen();
    }
    function option_sound_setting() {
        //KSW 131116-1 [ITS][209634][minor]
//        QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
//        QmlController.seekstop();
        idAppMain.selectedSoundSetting = true;
        UIListener.launchSettingSound();
    }
}
