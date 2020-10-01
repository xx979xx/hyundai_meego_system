/**
 * FileName: RadioHdOperation.js
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

function toFirstScreen() {
    idRadioHdMain.visible = false;
    idRadioHdOptionMenu.visible = false;
    //idRadioHdOptionMenuTwo.visible = false;
    idRadioENGModeMain.visible = false;
    idRadioHdPopupPreset.visible = false;
    idRadioHdPopupDimAcquiring.visible = false;
    idRadioHdPopupPresetWarning.visible = false;
    setPropertyChanges("AppRadioHdMain", false);
}

//****************************** # BackKey Processing #
function backKeyProcessing() {
    switch(idAppMain.state)
    {
    case "AppRadioHdMain": {
        if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled){
            idAppMain.presetEditEnabled = false;
            idAppMain.presetSaveEnabled = false;
        }
        else
            UIListener.HandleBackKey(idAppMain.enterType);//UIListener.HandleBackKey();
        break;
    }
    default: setAppMainScreen(preSelectedMainScreen(), false);break;
    }
} // # End backKeyProcessing()

//****************************** # Getting ID of Current State Item (for focus move?) #
function currentStateID()
{
    console.log("currentStateID() : " + idAppMain.state);
    switch(idAppMain.state)
    {
    case "AppRadioHdMain":                 return idRadioHdMain;
    case "AppRadioHdOptionMenu":           return idRadioHdOptionMenu;
    //case "AppRadioHdOptionMenuTwo":           return idRadioHdOptionMenuTwo;
    case "AppRadioHdENGMode":              return idRadioENGModeMain;
    case "PopupRadioHdPreset":             return idRadioHdPopupPreset;
    case "PopupRadioHdDimAcquiring":       return idRadioHdPopupDimAcquiring;
    case "PopupRadioHdPresetWarning":      return idRadioHdPopupPresetWarning;

    default: console.log("currentStateID() ============== Warning!!"); break;
    }
}

//****************************** # PropertyChanges for States ( Changing Main Screen ) #//
function setPropertyChanges(mainScreen, saveCurrentScreen) {
    var beforeTime = 0 // currentMilliseconds();

    if( saveCurrentScreen == true )  setPreSelectedMainScreen();

    switch(idAppMain.state)
    {
    case "AppRadioHdMain":            /*idRadioHdMain.visible = false;*/             break;
    case "AppRadioHdOptionMenu":      idRadioHdOptionMenu.visible           = false; break;
    //case "AppRadioHdOptionMenu":      if(mainScreen!="AppRadioHdOptionMenuTwo") idRadioHdOptionMenu.visible           = false; break;
    //case "AppRadioHdOptionMenuTwo":   idRadioHdOptionMenuTwo.visible        = false; break;
    case "AppRadioHdENGMode":         idRadioENGModeMain.visible            = false; break;
    case "PopupRadioHdPreset":        idRadioHdPopupPreset.visible          = false; break;
    case "PopupRadioHdDimAcquiring":  idRadioHdPopupDimAcquiring.visible    = false; break;
    case "PopupRadioHdPresetWarning": idRadioHdPopupPresetWarning.visible   = false; break;

    default: console.log(" (saveCurrentScreen === true) ============== Error!!"); break;
    }

    console.log("===============================>function setPropertyChanges :: before",idAppMain.state)

    idAppMain.state = mainScreen; // change state
    idAppMain.focus = true;       // Focus for Current Screen

    console.log("===============================>function setPropertyChanges :: after",idAppMain.state)
    //****************************** # Main Screen  #//
    switch(mainScreen)
    {
    case "AppRadioHdMain":{
        if( idRadioHdMain.status == Loader.Null )
            idRadioHdMain.source = "../component/Radio/HD/RadioHdMain.qml";

        idRadioHdMain.visible = true;
        idRadioHdMain.focus = true;
        //        idRadioHdMain.forceActiveFocus();
        idAppMain.blockCueMovement = false; // JSH 130627
        break;
    }
    case "AppRadioHdOptionMenu":{
        if( idRadioHdOptionMenu.status == Loader.Null ){
            if(UIListener.GetCountryVariantFromQML()  == 6) // JSH 131002
                idRadioHdOptionMenu.source = "../component/Radio/HD/RadioCanadaOptionMenu.qml";
            else
                idRadioHdOptionMenu.source = "../component/Radio/HD/RadioHdOptionMenu.qml";
        }

        idRadioHdOptionMenu.visible = true;
        idRadioHdOptionMenu.focus = true;
        //    idRadioHdOptionMenu.forceActiveFocus();
        idAppMain.blockCueMovement = true; // JSH 130627
        break;
    }
//    case "AppRadioHdOptionMenuTwo":{
//        if( idRadioHdOptionMenuTwo.status == Loader.Null )
//            idRadioHdOptionMenuTwo.source = "../component/Radio/HD/RadioHdOptionMenuTowDepth.qml";

//        idRadioHdOptionMenuTwo.visible = true;
//        idRadioHdOptionMenuTwo.focus = true;
//        //    idRadioHdOptionMenuTwo.forceActiveFocus();
//        break;
//    }
    case "AppRadioHdENGMode":{
        if( idRadioENGModeMain.status == Loader.Null )
            idRadioENGModeMain.source = "../component/Radio/ENGMode/ENGModeMain.qml";

        idRadioENGModeMain.visible = true;
        idRadioENGModeMain.focus = true;
        //   idRadioENGModeMain.forceActiveFocus();
        break;
    }
    case "PopupRadioHdPreset":{
        if( idRadioHdPopupPreset.status == Loader.Null )
            idRadioHdPopupPreset.source = "../component/Radio/HD/Popup/RadioHdPopupPreset.qml";

        idRadioHdPopupPreset.visible = true;
        idRadioHdPopupPreset.focus = true;
        //   idRadioHdPopupPreset.forceActiveFocus();
        break;
    }
    case "PopupRadioHdDimAcquiring":{
        if( idRadioHdPopupDimAcquiring.status == Loader.Null )
            idRadioHdPopupDimAcquiring.source = "../component/Radio/HD/Popup/RadioHdPopupDimAcquiring.qml";

        idRadioHdPopupDimAcquiring.visible = true;
//        idRadioHdPopupDimAcquiring.focus = true;
        break;
    }
    case "PopupRadioHdPresetWarning":{
        if( idRadioHdPopupPresetWarning.status == Loader.Null )
            idRadioHdPopupPresetWarning.source = "../component/Radio/HD/Popup/RadioHdPopupPresetWarning.qml";

        idRadioHdPopupPresetWarning.visible = true;
        idRadioHdPopupPresetWarning.focus = true;
        break;
    }
    default:
        break;
    }

    //dg.jin 20150319 process key event after systempopup
    if(idAppMain.state == "PopupRadioHdPresetWarning")
    {
        UIListener.setLocalPopup(true);
    }
    else
    {
        UIListener.setLocalPopup(false);
    }
    
    QmlController.autoTest_athenaSendObject();
}


