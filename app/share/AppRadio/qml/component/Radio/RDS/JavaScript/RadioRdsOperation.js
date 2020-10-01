/**
 * FileName: RadioRdsOperation.js
 * Author: HYANG
 * Time: 2012-06
 *
 * - Initial Created by HYANG
 */

//function toFirstScreen() {
//    idRadioRdsMain.visible = false;
//    idRadioRdsOptionMenu.visible = false;

//    idRadioRdsStationList.visible = false;
//    idRadioRdsOptionMenuStationList.visible = false;
//    idRadioRdsOptionMenuSortBy.visible = false;
//    idRadioRdsOptionMenuRegion.visible = false;

//    idRadioRdsPresetList.visible = false;
//    idRadioENGModeMain.visible = false;
//    //    idRadioRdsPopupPreset.visible = false;
//    //    idRadioRdsPopupTpStation.visible = false;
//    //    idRadioRdsPopupTraffic.visible = false;
//    idRadioRdsPopupLoading.visible = false;
//    //    idRadioRdsPopupPresetWarning.visible = false;
//    idRadioPopupDimAcquiring.visible = false;
//    setPropertyChanges("AppRadioRdsMain", false);
//}

//****************************** # BackKey Processing #
function backKeyProcessing() {
    console.log ("### currentID BackKeyProcessing ### ", idAppMain.state)
    switch(idAppMain.state)
    {
    case "AppRadioRdsMain":{
        UIListener.HandleBackKey(idAppMain.enterType);//UIListener.HandleBackKey();
        break;
    }
    default:{
        setAppMainScreen(preSelectedMainScreen(), false);
        break;
    }

    }
} // # End backKeyProcessing()

//****************************** # Getting ID of Current State Item (for focus move?) #
function currentStateID()
{
    console.log("currentStateID() : " + idAppMain.state);
    switch(idAppMain.state)
    {
    case "AppRadioRdsMain":                 return idRadioRdsMain;
    case "AppRadioRdsOptionMenu":           return idRadioRdsOptionMenu;

    case "AppRadioRdsStationList":          return idRadioRdsStationList;
    case "AppRadioRdsOptionMenuStationList":return idRadioRdsOptionMenuStationList;
    case "AppRadioRdsOptionMenuSortBy":     return idRadioRdsOptionMenuSortBy;
    case "AppRadioRdsOptionMenuRegion":     return idRadioRdsOptionMenuRegion;

    //case "AppRadioRdsPresetList":           return idRadioRdsPresetList;
    case "AppRadioRdsPresetList":
    {
        if(idAppMain.globalSelectedBand == 0x01)
            return idRadioRdsPresetListFM;
        else
            return idRadioRdsPresetListAM;
    }
    case "AppRadioRdsENGMode":              return idRadioENGModeMain;
        //    case "PopupRadioRdsPreset":             return idRadioRdsPopupPreset;
        //    case "PopupRadioRdsTpStation":          return idRadioRdsPopupTpStation;
        //    case "PopupRadioRdsTraffic":            return idRadioRdsPopupTraffic;
    case "PopupRadioRdsLoading":            return idRadioRdsPopupLoading;
    case "PopupRadioRdsTa":              return idRadioRdsPopupTa;
        //case "PopupRadioRdsPresetWarning":      return idRadioRdsPopupPresetWarning;
    case "PopupRadioRdsSaved":      return idRadioRdsPopupSaved;

    default: console.log("currentStateID() ============== Warning!!"); break;
    }
}

//****************************** # PropertyChanges for States ( Changing Main Screen ) #//
function setPropertyChanges(mainScreen, saveCurrentScreen) {
//    is from the function setAppMainScreen( to the state will be change , whether will be save or not )
    console.log("setPropertyChanges () from = " + idAppMain.state + ", to = " + mainScreen);
    var beforeTime = 0 // currentMilliseconds();

    if( saveCurrentScreen == true )  setPreSelectedMainScreen();

    //dg.jin 20141013 list osd start
    if(((idAppMain.state == "AppRadioRdsPresetList") || (idAppMain.state == "AppRadioRdsStationList"))
      && (mainScreen != "AppRadioRdsPresetList") && (mainScreen != "AppRadioRdsStationList"))
    {
       UIListener.sendDataToOSDClear();
    }
    //dg.jin 20141013 list osd end

    switch(idAppMain.state)
    {

    case "AppRadioRdsMain":                    if((mainScreen == "AppRadioRdsStationList") || (mainScreen == "AppRadioRdsPresetList")) idRadioRdsMain.visible = false; break;
    case "AppRadioRdsOptionMenu":              if(mainScreen!="AppRadioRdsOptionMenuRegion") idRadioRdsOptionMenu.visible = false; break;

    case "AppRadioRdsStationList":              if(mainScreen=="AppRadioRdsMain") {idRadioRdsStationList.visible = false; finishStationList(); break;}
    case "AppRadioRdsOptionMenuStationList":    if(mainScreen!="AppRadioRdsOptionMenuSortBy") idRadioRdsOptionMenuStationList.visible = false; break;
    case "AppRadioRdsOptionMenuSortBy":         idRadioRdsOptionMenuSortBy.visible = false; break;
    case "AppRadioRdsOptionMenuRegion":         idRadioRdsOptionMenuRegion.visible = false; break;

    case "AppRadioRdsPresetList":{
        if(mainScreen != "PopupRadioRdsTa")
        {
            if(mainScreen !="PopupRadioRdsSaved")
            {
               // idRadioRdsPresetList.visible = false;
                 if(idAppMain.globalSelectedBand == 0x01)
                 {
                     idRadioRdsPresetListFM.visible = false;
                 }
                 else
                 {
                     idRadioRdsPresetListAM.visible = false;
                 }
            }
            if(b_presetsavemode)
            {
                b_presetsavemode == false;
            }
        }
        break;
    }
    case "AppRadioRdsENGMode":                 idRadioENGModeMain.visible = false; break;
        //    case "PopupRadioRdsPreset":                idRadioRdsPopupPreset.visible = false; break;
        //    case "PopupRadioRdsTpStation":             idRadioRdsPopupTpStation.visible = false; break;
        //    case "PopupRadioRdsTraffic":               idRadioRdsPopupTraffic.visible = false; break;
     case "PopupRadioRdsLoading":               idRadioRdsPopupLoading.visible =  false; break;
     case "PopupRadioRdsTa":               idRadioRdsPopupTa.visible = false; break;
        //case "PopupRadioRdsPresetWarning":         idRadioRdsPopupPresetWarning.visible = false; break;
     case "PopupRadioRdsSaved":      idRadioRdsPopupSaved.visible = false; break;

    default: console.log(" (saveCurrentScreen === true) ============== Error!!"); break;
    }
    //// 2013.11.12 added by qtuiguy : too takes long time  or called twice times so add this codes.
    var previousState = idAppMain.state;
    ////
    idAppMain.state = mainScreen; // change state
    idAppMain.focus = true;       // Focus for Current Screen

    //****************************** # Main Screen  #//
    switch(mainScreen)
    {
    case "AppRadioRdsMain":{
        if( idRadioRdsMain.status == Loader.Null )
            idRadioRdsMain.source = "../component/Radio/RDS/RadioRdsMain.qml";
        //0911 if AppRadio go back through back/home key from any mode.
        finishStationList();
        if (b_presetsavemode)
            b_presetsavemode = false;
        ////

        idRadioRdsMain.visible = true;
        idRadioRdsMain.focus = true;

        break;
    }
    case "AppRadioRdsOptionMenu":{
        if( idRadioRdsOptionMenu.status == Loader.Null )
            idRadioRdsOptionMenu.source = "../component/Radio/RDS/RadioRdsOptionMenu.qml";

        idRadioRdsOptionMenu.visible = true;
        idRadioRdsOptionMenu.focus = true;

        break;
    }

    case "AppRadioRdsStationList":{
        if( idRadioRdsStationList.status == Loader.Null ){
            idRadioRdsStationList.source = "../component/Radio/RDS/RadioRdsStationList.qml";
        }
        //// 2013.11.12 added by qtuiguy : too takes long time  or called twice times so add this codes.
        if(previousState != "AppRadioRdsOptionMenuStationList"){
            console.debug("Previous State = " +  previousState);
            initStationList();
        }
        ////
        idRadioRdsStationList.visible = true;
        idRadioRdsStationList.focus = true;
        break;
    }
    case "AppRadioRdsOptionMenuStationList":{
        if( idRadioRdsOptionMenuStationList.status == Loader.Null )
            idRadioRdsOptionMenuStationList.source = "../component/Radio/RDS/RadioRdsOptionMenuStationList.qml";

        idRadioRdsOptionMenuStationList.visible = true;
        idRadioRdsOptionMenuStationList.focus = true;

        break;
    }
    case "AppRadioRdsOptionMenuSortBy":{
        if( idRadioRdsOptionMenuSortBy.status == Loader.Null )
            idRadioRdsOptionMenuSortBy.source = "../component/Radio/RDS/RadioRdsOptionMenuSortBy.qml";

        idRadioRdsOptionMenuSortBy.visible = true;
        idRadioRdsOptionMenuSortBy.focus = true;
        break;
    }
    case "AppRadioRdsOptionMenuRegion":{
        if( idRadioRdsOptionMenuRegion.status == Loader.Null )
            idRadioRdsOptionMenuRegion.source = "../component/Radio/RDS/RadioRdsOptionMenuRegion.qml";

        idRadioRdsOptionMenuRegion.visible = true;
        idRadioRdsOptionMenuRegion.focus = true;
        break;
    }
    case "AppRadioRdsPresetList":{
        if(idAppMain.globalSelectedBand == 0x01)
        {
             if( idRadioRdsPresetListFM.status == Loader.Null )
                 idRadioRdsPresetListFM.source = "../component/Radio/RDS/RadioRdsPresetListFM.qml";

             idRadioRdsPresetListFM.visible = true
             idRadioRdsPresetListFM.focus = true;
        }
        else
        {
             if( idRadioRdsPresetListAM.status == Loader.Null )
                 idRadioRdsPresetListAM.source = "../component/Radio/RDS/RadioRdsPresetListAM.qml";

             idRadioRdsPresetListAM.visible = true
             idRadioRdsPresetListAM.focus = true;
        }
       // if( idRadioRdsPresetList.status == Loader.Null )
           // idRadioRdsPresetList.source = "../component/Radio/RDS/RadioRdsPresetList.qml";

       // idRadioRdsPresetList.visible = true
        //idRadioRdsPresetList.focus = true;
        break;
    }

    case "AppRadioRdsENGMode":{
        if( idRadioENGModeMain.status == Loader.Null )
            idRadioENGModeMain.source = "../component/Radio/ENGMode/ENGModeMain.qml";

        idRadioENGModeMain.visible = true;
        idRadioENGModeMain.focus = true;
        // idRadioENGModeMain.forceActiveFocus();
        break;
    }
    case "PopupRadioRdsLoading":{
        if( idRadioRdsPopupLoading.status == Loader.Null )
            idRadioRdsPopupLoading.source = "../component/Radio/RDS/Popup/RadioRdsPopupRefreshing.qml";

        idRadioRdsPopupLoading.visible = true;
        idRadioRdsPopupLoading.focus = true;
        break;
    }
    case "PopupRadioRdsSaved":{
        if( idRadioRdsPopupSaved.status == Loader.Null )
            idRadioRdsPopupSaved.source = "../component/Radio/RDS/Popup/RadioRdsPopupSaved.qml";

        idRadioRdsPopupSaved.visible = true;
        idRadioRdsPopupSaved.focus = true;
        break;
    }
    case "PopupRadioRdsTa":{
        if( idRadioRdsPopupTa.status == Loader.Null )
            idRadioRdsPopupTa.source = "../component/Radio/RDS/Popup/RadioRdsPopupTa.qml" ;
        idRadioRdsPopupTa.visible = true;
        idRadioRdsPopupTa.focus = true;
        break;
    }
    default:
        break;
    }
/*
    enum ViewState{
        VIEW_NONE,    //0
        VIEW_MAIN,    //1
        VIEW_PRESETLIST,   //2
        VIEW_STATIONLIST,  //3
        VIEW_OPTIONMENU,   //4
        VIEW_POPUP,        //5
        VIEW_ETC,          //6
    };
*/
    switch(idAppMain.state){
    case "AppRadioRdsMain":{
        UIListener.setViewState(1);
        break;
    }
    case "AppRadioRdsOptionMenu":{
        UIListener.setViewState(4);
        break;
    }
    case "AppRadioRdsStationList":{
        UIListener.setViewState(3);
        break;
    }
    case "AppRadioRdsOptionMenuStationList":{
        UIListener.setViewState(4);
        break;
    }
    case "AppRadioRdsOptionMenuSortBy":{
        UIListener.setViewState(4);
        break;
    }
    case "AppRadioRdsOptionMenuRegion":{
        UIListener.setViewState(4);
        break;
    }
    case "AppRadioRdsPresetList":{
        UIListener.setViewState(2);
        break;
    }
    case "AppRadioRdsENGMode":{
        UIListener.setViewState(6);
        break;
    }
    case "PopupRadioRdsLoading":{
        UIListener.setViewState(5);
        break;
    }
    case "PopupRadioRdsSaved":{
        UIListener.setViewState(5);
        break;
    }
    default:
        UIListener.setViewState(0);
        break;
    }
    //dg.jin 20141013 list osd start
    if(((idAppMain.state == "AppRadioRdsPresetList") || (idAppMain.state == "AppRadioRdsStationList"))
        && ((previousState != "AppRadioRdsPresetList") && (previousState != "AppRadioRdsStationList"))
        && QmlController.searchState)
                UIListener.sendDataToOSD(1);
    //dg.jin 20141013 list osd end
    //// 2013.10.30 added by qutiguy :  ITS 0198898
    idAppMain.pressCancelSignal();
     ////
    QmlController.autoTest_athenaSendObject();
}


