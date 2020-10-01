/**
 * FileName: XMAudioOptionMenuSub.qml
 * Author: HYANG
 * Time: 2013-06-05
 *
 * - 2013-06-05 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MOptionMenu{
    id: idRadioOptionMenuSub

    //****************************** # SXM Radio - property #
    property string inputMode  : idAppMain.inputMode
    property bool artistsongalert : false

    menuDepth: "TwoDepth"
    menu0Enabled : (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true
    menu1Enabled : (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true
    menu2Enabled : (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true
    menu3Enabled : (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true
    gArtistSongAlert : artistsongalert

    //****************************** # Item Model #
    linkedModels:  ListModel { id: idRadioOptionMenuSubModel }

    //****************************** # Item Clicked #
    onMenu0Click: {
        console.log(">>>>>>>>>>>>>  Favorites")
        XMOperation.setPreviousScanStop();
        idAppMain.optionMenuAllOff();
        idAppMain.gSXMFavoirtesBand = "song";
        setAppMainScreen("AppRadioFavorite", false);
        XMOperation.onFavoriteList();
    }
    onDimCheck1Click: {
        console.log(">>>>>>>>>>>>>  Favorites Alert - Check Click Enable")
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        onSetArtistSongAlert(true);
        ATSeek.handleSetAlertOnOff(true);

        //disappear OptionMenu
        idAppMain.optionMenuAllHide();
    }
    onDimUncheck1Click: {
        console.log(">>>>>>>>>>>>>  Favorites Alert - Check Click Disable")
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        onSetArtistSongAlert(false);
        ATSeek.handleSetAlertOnOff(false);

        //disappear OptionMenu
        idAppMain.optionMenuAllHide();
    }
    onMenu2Click: {
        console.log(">>>>>>>>>>>>>  Save as preset")
        XMOperation.setPreviousScanStop();

        //Preset Save Button
        XMOperation.setPresetSaveFlag(true);

        idAppMain.optionMenuAllHide();
        XMOperation.setForceFocusEnterPresetOrderOrSave();
    }
    onMenu3Click: {
        console.log(">>>>>>>>>>>>>  Recoder Presets")
        XMOperation.setPreviousScanStop();

        //Edit Preset Order
        XMOperation.setPresetOrderFlag(true);

        idAppMain.optionMenuAllHide();
        XMOperation.setForceFocusEnterPresetOrderOrSave();
    }
    onMenu4Click: {
        console.log(">>>>>>>>>>>>>  Subscription Status")
        idAppMain.optionMenuAllOff();
        setAppMainScreen("PopupRadioSubscriptionStatus", true);
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("XMAudioOptionMenuSub - BackKey Clicked");
        idAppMain.optionMenuSubClose();
    }
    /* CCP Menu Key */
    onClickMenuKey: {
        console.log("XMAudioOptionMenuSub - MenuKey Clicked");
        idAppMain.optionMenuAllHide();
    }

    onOptionMenuFinished:{
        console.log("XMAudioOptionMenuSub - optionMenuFinished() ")
        idAppMain.optionMenuAllHide();
    }

    onLeftKeyMenuClose:{
        console.log("XMAudioOptionMenuSub - leftKeyMenuClose() ")
        idAppMain.optionMenuSubClose();
    }

    function onSetArtistSongAlert(b_status)
    {
        artistsongalert = b_status;
    }

    function setOptionMenuModelString(){
        var data1 = {"name" : stringInfo.sSTR_XMRADIO_FAVORITES, "opType":""};
        var data2 = {"name" : stringInfo.sSTR_XMRADIO_FAVORITES_ALERT, "opType":"dimCheck"};
        var data3 = {"name" : stringInfo.sSTR_XMRADIO_SAVE_AS_PRESET, "opType":""};
        var data4 = {"name" : stringInfo.sSTR_XMRADIO_REORDER_PRESETS, "opType":""};
        var data5 = {"name" : stringInfo.sSTR_XMRADIO_SUBSCRIPTION_STATUS, "opType":""};

        idRadioOptionMenuSubModel.clear();
        idRadioOptionMenuSubModel.append(data1);
        idRadioOptionMenuSubModel.append(data2);
        idRadioOptionMenuSubModel.append(data3);
        idRadioOptionMenuSubModel.append(data4);
        idRadioOptionMenuSubModel.append(data5);
    }
}
