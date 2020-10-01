/**
 * FileName: DmbPlayerOptionMenu.qml
 * Author: WSH
 * Time: 2012-12-28 12:10
 *
 * - 2012-12-28 Deleted Move Preset
 * - 2013-01-04 RallBack (Revision : 2508)
 * - 2013-01-04 Modified property
 *   : idDmbPlayerOptionMenu.menu2Dimmed = false => idDmbPlayerOptionMenu.menu2Enabled = true
 * - 2013-01-04 Deleted Move Preset
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

//**************************************** Dmb Player OptionMenu
MComp.MOptionMenu{
    id:idDmbPlayerOptionMenu
    focus: true

    linkedModels: ListModel{
        id: idMenuListModel
        ListElement{ name: "Channel Search"; opType: ""}
        ListElement{ name: "Move Channel"; opType: ""}
        ListElement{ name: "Delete Channel"; opType: ""}        
        ListElement{ name: "Disaster Broadcasting List"; opType: ""}        
        ListElement{ name: "Screen Setting"; opType: ""}
        ListElement{ name: "Sound Setting"; opType: ""}
        ListElement{ name: "Full Screen Display"; opType: ""}
    }
    onMenu0Click:{ //"Channel Search"
//        setAppMainScreen("PopupSearching", false)
        EngineListener.setPopupSearching()
    }
    onMenu1Click:{ //"Move Channel"        
        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
            presetEditEnabled = true
        }
        else
        {
            EngineListener.selectOptionMenuByIndex(0);
        }

        //console.debug(" [QML] ======================== [DmbPlayerOptionMenu] onMenu1Click, presetEditEnabled =",presetEditEnabled)
    }
    onMenu2Click:{ //"Delete Channel";

        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
            setAppMainScreen("PopupChannelDeleteConfirm", true);
        }
        else
        {
            EngineListener.selectOptionMenuByIndex(8);
            idAppMain.dmbListPageInit(CommParser.m_iPresetListIndex)
        }

    }
    onMenu3Click:{ //"Disaster Broadcasting List"
        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen();
            setAppMainScreen("AppDmbDisaterList", true);
        }
        else
        {
            EngineListener.selectOptionMenuByIndex(2);
        }
    }

    onMenu4Click:{ //"Screen Setting"
        idAppMain.isSettings = true;
	
        var isJogMode;
        if(inputMode == "touch") isJogMode = false
        else if(inputMode == "jog") isJogMode = true

        EngineListener.CmdScreenSetting(UIListener.getCurrentScreen(), isJogMode);

    }
    onMenu5Click:{ //"Sound Setting"
        idAppMain.isSettings = true;
	
        var isJogMode;
        if(inputMode == "touch") isJogMode = false
        else if(inputMode == "jog") isJogMode = true
        EngineListener.CmdSoundSetting(UIListener.getCurrentScreen(), isJogMode);
        //gotoBackScreen()
    }

    onMenu6Click:{ //"Full Screen Display"
        gotoBackScreen()
        CommParser.m_bIsFullScreen = true
//        setAppMainScreen("PopupSetFullScreen", false);
    }

    onClickMenuKey: idDmbPlayerOptionMenu.hideOptionMenu();
    onBackKeyPressed: idDmbPlayerOptionMenu.hideOptionMenu();

    onVisibleChanged: {
        //console.log("[QML][idDmbPlayerOptionMenu][onVisibleChanged] visible : " + visible)
        var logMsg = "[QML][idDmbPlayerOptionMenu][onVisibleChanged] visible : " + visible;
        EngineListener.printLogMessge(logMsg);

        if(visible == true){
            chkMovePreset()
            chkDeletePresetList()
            chkScreenSetting();
            //chKDisasterInfoList()
            idAppMain.isSettings = false;
        }
        else
        {
            if(idAppMain.upKeyLongPressed == true ){
                idAppMain.upKeyLongPressed = false;
                EngineListener.m_bOptionMenuOpen = false;
            }
            if(idAppMain.downKeyLongPressed == true ){
                idAppMain.downKeyLongPressed = false;
                EngineListener.m_bOptionMenuOpen = false;
            }
        }
    }

    // # OptionMenu - Move Channel  # by WSH 130131
    function chkMovePreset(){
        if(presetListModel.rowCount() > 1)
            idDmbPlayerOptionMenu.menu1Enabled = true
        else
            idDmbPlayerOptionMenu.menu1Enabled = false
    } // End Function

    function chkScreenSetting(){
//        if(idAppMain.drivingRestriction == true)
//        {
//            idDmbPlayerOptionMenu.menu4Enabled = false;
//        }
//        else
//        {
//            idDmbPlayerOptionMenu.menu4Enabled = true;
//        }
    } // End Function

    // # OptionMenu - Delete Channel  # by WSH 121205
    function chkDeletePresetList(){
        var i;

        //console.log("############# [DmbPlayerOptionMenu][chkDeletePresetList()] 000 rowCount " + idAppMain.presetListModel.rowCount())

        if(CommParser.m_iPresetListIndex == -1 /*|| idAppMain.presetListModel.rowCount() == 0*/)
        {
            idDmbPlayerOptionMenu.menu2Enabled = false
        }
        else
        {
            idDmbPlayerOptionMenu.menu2Enabled = true
        }
    } // End Function

/*
    // # OptionMenu - Disaster Disaster Broadcasting List
    function chKDisasterInfoList(){
        var listCount = MDmbOperation.CmdReqAMASMessageRowCount();

        if(listCount > 0)
            idDmbPlayerOptionMenu.menu3Enabled = true
        else
            idDmbPlayerOptionMenu.menu3Enabled = false
    }
*/

    function setModelString(){
        var i;
        for(i = 0; i < idMenuListModel.count; i++)
        {
            //console.log("["+i+"]:" + idMenuListModel.get(i).name);
            switch(i){
            case 0:{
                idMenuListModel.get(i).name = stringInfo.strPlayer_Option_Search
                break;
            }
            case 1:{
                idMenuListModel.get(i).name = stringInfo.strPlayer_Option_MoveChannel
                break;
            }
            case 2:{
                idMenuListModel.get(i).name = stringInfo.strPlayer_Option_DeleteChannel
                break;
            }
            case 3:{
                idMenuListModel.get(i).name = stringInfo.strPlayer_Option_DisasterInfo
                break;
            }
            case 4:{
                idMenuListModel.get(i).name = stringInfo.strPlayer_Option_ScreenSetting
                break;
            }
            case 5:{
                idMenuListModel.get(i).name = stringInfo.strPlayer_Option_SoundSetting
                break;
            }
            case 6:{
                idMenuListModel.get(i).name = stringInfo.strPlayer_Option_Fullscreen
                break;
            }
            default:
                break;
            }
        }
    }

    // Loading Completed!!
    Component.onCompleted: {
        setModelString()
        chkMovePreset()
        chkDeletePresetList()
        chkScreenSetting()
        //chKDisasterInfoList()
    }

    onSeekPrevKeyReleased:  {
        if(idAppMain.state == "AppDmbPlayerOptionMenu")
        {
            EngineListener.moveGoToMainScreen()
        }

        idAppMain.dmbSeekPrevKeyPressed()
    }
    onSeekNextKeyReleased:  {
        if(idAppMain.state == "AppDmbPlayerOptionMenu")
        {
            EngineListener.moveGoToMainScreen()
        }

        idAppMain.dmbSeekNextKeyPressed()
    }
    onTuneLeftKeyPressed:  {
        if(idAppMain.state == "AppDmbPlayerOptionMenu")
        {
            EngineListener.moveGoToMainScreen()
        }

        idAppMain.dmbTuneLeftKeyPressed()
    }
    onTuneRightKeyPressed: {
        if(idAppMain.state == "AppDmbPlayerOptionMenu")
        {
            EngineListener.moveGoToMainScreen()
        }

        idAppMain.dmbTuneRightKeyPressed()
    }

    onTuneEnterKeyPressed:{

        if(idAppMain.state != "AppDmbPlayerOptionMenu") return;

        if(EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == true && EngineListener.m_ScreentSettingMode == true))
        {
            EngineListener.SetExternal()
            return;
        }
    }

    Connections{
        target: EngineListener
        onRetranslateUi:{
            setModelString()
            linkedCurrentItem.setPaintedWidth();
        }

        onDmbReqBackground:{
            //console.debug("================> [DmbPlayerOptionMenu][onDmbReqPreBackground] idAppMain.state = "+idAppMain.state)
            if(idAppMain.state == "AppDmbPlayerOptionMenu"){
                gotoBackScreen()                
            }
            idAppMain.isSettings = false;
        }

        onModeDRSChanged:
        {
//            if(EngineListener.m_DRSmode && EngineListener.IsShowDRSMode(UIListener.getCurrentScreen()))
//            {
//                idDmbPlayerOptionMenu.menu4Enabled = false;
//            }
//            else
//            {
//                idDmbPlayerOptionMenu.menu4Enabled = true;
//            }
        }

        onSendCompleteSettingEvent:{
            idAppMain.isSettings = false;
        }

    }
}
