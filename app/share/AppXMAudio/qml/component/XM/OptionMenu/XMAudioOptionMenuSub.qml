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
    menu4Enabled : (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true
    menu5Enabled : (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : true
    gArtistSongAlert : artistsongalert

    //****************************** # Item Model #
    linkedModels:  ListModel { id: idRadioOptionMenuSubModel }

    //****************************** # Item Clicked #
    onMenu0Click: {
        console.log(">>>>>>>>>>>>>  Featured Favorites")
        idAppMain.optionMenuAllOff();

        if (FFManager.handleFFCount() == 0)
        {
            setAppMainScreen("PopupRadioWarning1Line", true);
            idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_NO_FEATURED_FAVORITE);
            idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(false);
        }
        else
        {
            XMOperation.setPreviousScanStop();
            setAppMainScreen("AppRadioFeaturedFavorites", false);
        }
    }
    onMenu1Click: {
        console.log(">>>>>>>>>>>>>  Favorites")
        XMOperation.setPreviousScanStop();
        idAppMain.optionMenuAllOff();
        idAppMain.gSXMFavoirtesBand = "song";
        setAppMainScreen("AppRadioFavorite", false);
        XMOperation.onFavoriteList();
    }
    onDimCheck2Click: {
        console.log(">>>>>>>>>>>>>  Favorites Alert - Check Click Enable")
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        onSetArtistSongAlert(true);
        ATSeek.handleSetAlertOnOff(true);

        //disappear OptionMenu
        idAppMain.optionMenuAllHide();
    }
    onDimUncheck2Click: {
        console.log(">>>>>>>>>>>>>  Favorites Alert - Check Click Disable")
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        onSetArtistSongAlert(false);
        ATSeek.handleSetAlertOnOff(false);

        //disappear OptionMenu
        idAppMain.optionMenuAllHide();
    }

    onMenu3Click: {
        console.log(">>>>>>>>>>>>>  Save as preset")
        XMOperation.setPreviousScanStop();

        //Preset Save Button
        XMOperation.setPresetSaveFlag(true);

        idAppMain.optionMenuAllHide();
        XMOperation.setForceFocusEnterPresetOrderOrSave();
    }
    onMenu4Click: {
        console.log(">>>>>>>>>>>>>  Recoder Presets")
        XMOperation.setPreviousScanStop();

        //Edit Preset Order
        XMOperation.setPresetOrderFlag(true);

        idAppMain.optionMenuAllHide();
        XMOperation.setForceFocusEnterPresetOrderOrSave();
    }
    onMenu5Click: {
        console.log(">>>>>>>>>>>>>  Game Zone")
        XMOperation.setPreviousScanStop();
        idAppMain.optionMenuAllOff();

        setAppMainScreen("AppRadioGameZone", false);
    }
    onMenu6Click: {
        console.log(">>>>>>>>>>>>>  Subscription Status")
        idAppMain.optionMenuAllOff();
        setAppMainScreen("PopupRadioSubscriptionStatus", true);
    }
    onMenu7Click: {
        console.log(">>>>>>>>>>>>>  Go to SiriusXM Data")
        UIListener.HandleSXMDataKey();
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
        var data1  = {"name" : stringInfo.sSTR_XMRADIO_FEATURED_FAVORITE, "opType":""};
        var data2 = {"name" : stringInfo.sSTR_XMRADIO_FAVORITES, "opType":""};
        var data3 = {"name" : stringInfo.sSTR_XMRADIO_FAVORITES_ALERT, "opType":"dimCheck"};
        var data4 = {"name" : stringInfo.sSTR_XMRADIO_SAVE_AS_PRESET, "opType":""};
        var data5 = {"name" : stringInfo.sSTR_XMRADIO_REORDER_PRESETS, "opType":""};
        var data6 = {"name" : stringInfo.sSTR_XMRADIO_GAME_ZONE, "opType":""};
        var data7 = {"name" : stringInfo.sSTR_XMRADIO_SUBSCRIPTION_STATUS, "opType":""};
        var data8 = {"name" : stringInfo.sSTR_XMRADIO_GO_TO_SIRIUSXM_DATA, "opType":""};

        idRadioOptionMenuSubModel.clear();
        idRadioOptionMenuSubModel.append(data1);
        idRadioOptionMenuSubModel.append(data2);
        idRadioOptionMenuSubModel.append(data3);
        idRadioOptionMenuSubModel.append(data4);
        idRadioOptionMenuSubModel.append(data5);
        idRadioOptionMenuSubModel.append(data6);
        idRadioOptionMenuSubModel.append(data7);
        idRadioOptionMenuSubModel.append(data8);
    }
}
