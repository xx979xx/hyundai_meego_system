/**
 * FileName: XMAudioOptionMenu.qml
 * Author: HYANG
 * Time: 2013-06-05
 *
 * - 2013-06-05 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MOptionMenu{
    id: idRadioOptionMenu
    x: 0; y:0;
    //****************************** # SXM Radio - property #
    property string inputMode  : idAppMain.inputMode
    property bool addtofavorite : true

    menu0Enabled : (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true
    menu1Enabled : addtofavorite
    menu2Enabled : (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true
    menu3Enabled : ((PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_ANTENNA_DISCONNECTED") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_ANTENNA_SHORTED") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_LOSS_OF_SIGNAL") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_ACQUIRING_SIGNAL") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_BUSY")) ? false : (PLAYInfo.TuneStatus == 1 && PLAYInfo.SubAdvisory == "") ? false : true
    menu4Enabled : ((PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_ANTENNA_DISCONNECTED") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_ANTENNA_SHORTED") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_LOSS_OF_SIGNAL") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_ACQUIRING_SIGNAL") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_BUSY")) ? false : (PLAYInfo.TuneStatus == 1 && PLAYInfo.SubAdvisory == "") ? false : true
    menu5Enabled : (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true

    //****************************** # Item Model #
    linkedModels:  ListModel { id: idRadioOptionMenuModel }

    //****************************** # Item Clicked #
    onMenu0Click: {
        console.log(">>>>>>>>>>>>>  Channel List")
        XMOperation.setPreviousScanStop();
        idRadioOptionMenu.offOptionMenu();
        setAppMainScreen("AppRadioList", false);
    }
    onMenu1Click: {
        console.log(">>>>>>>>>>>>>  Add to favorites")
        XMOperation.setPreviousScanStop();
        idRadioOptionMenu.offOptionMenu();
        setAppMainScreen( "PopupRadioAddToFavorite" , true);
    }
    onMenu2Click: {
        console.log(">>>>>>>>>>>>> Program Guide (EPG)")
        XMOperation.setPreviousScanStop();
        idRadioOptionMenu.offOptionMenu();
        setAppMainScreen("AppRadioEPG", false);
    }
    onMenu3Click: {
        console.log(">>>>>>>>>>>>>  Preset Scan")
        console.log("PresetScan Button Click Scan:"+gSXMScan+" PresetScan:"+gSXMPresetScan);

        idRadioOptionMenu.hideOptionMenu();
        if(gSXMPresetScan == "Normal")
        {
            //check Scan
            if(gSXMScan == "Scan")
            {
                gSXMScan = "Normal";
                UIListener.HandleScanAndPresetScanStop();
            }
            UIListener.HandlePresetScanStart();
        }
        else if(gSXMPresetScan == "PresetScan")
        {
            gSXMPresetScan = "Normal";
            UIListener.HandleScanAndPresetScanStop();
        }
    }
    onMenu4Click: {
        console.log(">>>>>>>>>>>>>  All Channel Scan")
        console.log("Scan Button Click Scan:"+gSXMScan+" PresetScan:"+gSXMPresetScan);

        idRadioOptionMenu.hideOptionMenu();
        if(gSXMScan == "Normal")
        {
            //check PresetScan
            if(gSXMPresetScan == "PresetScan")
            {
                gSXMPresetScan = "Normal";
                UIListener.HandleScanAndPresetScanStop();
            }

            gSXMScan = "Scan";
            UIListener.HandleScanStart();
        }
        else if(gSXMScan == "Scan")
        {
            gSXMScan = "Normal";
            UIListener.HandleScanAndPresetScanStop();
        }
    }
    onMenu5Click: {
        console.log(">>>>>>>>>>>>>  Direct Tune")
        XMOperation.setPreviousScanStop();
        idRadioOptionMenu.offOptionMenu();
        setAppMainScreen("AppRadioSearch", false);
    }
    onMenu6Click: {
        console.log(">>>>>>>>>>>>>  Sound Settings")
        var isJogMode;
        if(inputMode == "touch") isJogMode = false
        else if(inputMode == "jog") isJogMode = true
        idAppMain.isSettings = true;

        UIListener.HandleSoundSetting(isJogMode);
    }
    onMenu7Click: {
        console.log(">>>>>>>>>>>>>  More Features")

        setAppMainScreen( "AppRadioOptionMenuSub" , true);
        idAppMain.optionMenuSubOpen();
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("XMAudioOptionMenu - BackKey Clicked");
        idRadioOptionMenu.hideOptionMenu();
    }
    /* CCP Menu Key */
    onClickMenuKey: {
        console.log("XMAudioOptionMenu - MenuKey Clicked");
        idRadioOptionMenu.hideOptionMenu();
    }

    onOptionMenuFinished:{
        console.log("XMAudioOptionMenu - optionMenuFinished() ")
        idRadioOptionMenu.hideOptionMenu();
    }

    onLeftKeyMenuClose:{
        console.log("XMAudioOptionMenu - leftKeyMenuClose() ")
        idRadioOptionMenu.hideOptionMenu();
    }

    onRightKeySubMenuOpen: {
        //console.log("XMAudioOptionMenu - rightKeySubMenuOpen() ")
        setAppMainScreen( "AppRadioOptionMenuSub" , true);
        idAppMain.optionMenuSubOpen();
    }

    Connections{
        target: UIListener
        onInitOptionMenuFlag:{
            console.log("XMAudioOptionMenu Receive initOptionMenuFlag() ")
            if(idAppMain.isSettings)
            {
                idAppMain.isSettings = false;
                idRadioOptionMenu.hideOptionMenu();
            }
        }
    }

    function onSetAddToFavoriteDim(b_status)
    {
        addtofavorite = b_status;
    }

    function setOptionMenuModelString(){
        var data1  = {"name" : stringInfo.sSTR_XMRADIO_CHANNEL_LIST, "opType":""};
        var data2 = {"name" : stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES, "opType":""};
        var data3 = {"name" : stringInfo.sSTR_XMRADIO_PROGRAM_GUIDE, "opType":""};
        var data4 = {"name" : stringInfo.sSTR_XMRADIO_PRESET_SCAN, "opType":""};
        var data5 = {"name" : stringInfo.sSTR_XMRADIO_SCAN_ALL_CHANNELS, "opType":""};
        var data6 = {"name" : stringInfo.sSTR_XMRADIO_DIRECT_TUNE, "opType":""};
        var data7 = {"name" : stringInfo.sSTR_XMRADIO_SOUND_SETTINGS, "opType":""};
        var data8 = {"name" : stringInfo.sSTR_XMRADIO_MORE_FEATURES, "opType":"subMenu"};

        if (gSXMPresetScan == "PresetScan") {
            data4 = {"name" : stringInfo.sSTR_XMRADIO_STOP_SCAN, "opType":""};
        }
        else if (gSXMScan == "Scan") {
            data5 = {"name" : stringInfo.sSTR_XMRADIO_STOP_SCAN, "opType":""};
        }

        idRadioOptionMenuModel.clear();
        idRadioOptionMenuModel.append(data1);
        idRadioOptionMenuModel.append(data2);
        idRadioOptionMenuModel.append(data3);
        idRadioOptionMenuModel.append(data4);
        idRadioOptionMenuModel.append(data5);
        idRadioOptionMenuModel.append(data6);
        idRadioOptionMenuModel.append(data7);
        idRadioOptionMenuModel.append(data8);
    }
}
