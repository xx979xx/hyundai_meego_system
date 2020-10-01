/**
 * FileName: RadioOperation.js
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

function toFirstScreen() {
    idRadioMain.visible = false;
    idRadioOptionMenu.visible = false;

    idRadioENGModeMain.visible = false;
    //idRadioPopupPreset.visible = false;// JSH 121121 , popup preset List Delete
//// 20130607 removed by qutiguy - no use.
//    idRadioPopupPresetFull.visible = false;
//    idRadioPopupPresetWarning.visible = false;
////
    setPropertyChanges("AppRadioMain", false);
}

//****************************** # BackKey Processing #
function backKeyProcessing() {
    switch(idAppMain.state)
    {
    case "AppRadioMain":{
        if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled){
            idAppMain.presetEditEnabled = false;
            idAppMain.presetSaveEnabled = false;
        }
        else
            UIListener.HandleBackKey(idAppMain.enterType);
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
    case "AppRadioMain":                 return idRadioMain;
    case "AppRadioOptionMenu":           return idRadioOptionMenu;
    case "AppRadioENGMode":              return idRadioENGModeMain;
    //case "PopupRadioPreset":             return idRadioPopupPreset; // JSH 121121 , popup preset List Delete
//// 20130607 removed by qutiguy - no use.
//    case "PopupRadioPresetFull":         return idRadioPopupPresetFull;
//    case "PopupPresetWarning":           return idRadioPopupPresetWarning;
////
    case "PopupRadioDimAcquiring":       return idRadioPopupDimAcquiring;


    default: console.log("currentStateID() ============== Warning!!"); break;
    }
}

//****************************** # PropertyChanges for States ( Changing Main Screen ) #//
function setPropertyChanges(mainScreen, saveCurrentScreen) {
    var beforeTime = 0 // currentMilliseconds();

    if( saveCurrentScreen == true )  setPreSelectedMainScreen();

    switch(idAppMain.state)
    {
    case "AppRadioMain":                    /*idRadioMain.visible = false;*/ break;
    case "AppRadioOptionMenu":              idRadioOptionMenu.visible = false; break;
    case "AppRadioENGMode":                 idRadioENGModeMain.visible = false; break;
    //case "PopupRadioPreset":                idRadioPopupPreset.visible = false; break;// JSH 121121 , popup preset List Delete
//// 20130607 removed by qutiguy - no use.
//    case "PopupRadioPresetFull":            idRadioPopupPresetFull.visible = false; break;
//    case "PopupPresetWarning":              idRadioPopupPresetWarning.visible = false; break;
////
    case "PopupRadioDimAcquiring":          idRadioPopupDimAcquiring.visible = false; break;

    default: console.log(" (saveCurrentScreen === true) ============== Error!!"); break;
    }

    idAppMain.state = mainScreen; // change state
    idAppMain.focus = true;       // Focus for Current Screen

    //****************************** # Main Screen  #//
    switch(mainScreen)
    {
    case "AppRadioMain":{
        if( idRadioMain.status == Loader.Null )
            idRadioMain.source = "../component/Radio/GENERAL/RadioMain.qml";

        idRadioMain.visible = true;
        idRadioMain.focus = true;
        idRadioMain.forceActiveFocus();
        idAppMain.blockCueMovement = false; // JSH 130627
        break;
    }
    case "AppRadioOptionMenu":{
        if( idRadioOptionMenu.status == Loader.Null )
            idRadioOptionMenu.source = "../component/Radio/GENERAL/RadioOptionMenu.qml";

        idRadioOptionMenu.visible = true;
        idRadioOptionMenu.focus = true;
        idRadioOptionMenu.forceActiveFocus();
        idAppMain.blockCueMovement = true; // JSH 130627
        break;
    }
    case "AppRadioENGMode":{
        if( idRadioENGModeMain.status == Loader.Null )
            idRadioENGModeMain.source = "../component/Radio/ENGMode/ENGModeMain.qml";

        idRadioENGModeMain.visible = true;
        idRadioENGModeMain.focus = true;
        idRadioENGModeMain.forceActiveFocus();
        break;
    }
    case "PopupRadioDimAcquiring":{
        if( idRadioPopupDimAcquiring.status == Loader.Null )
            idRadioPopupDimAcquiring.source = "../component/Radio/GENERAL/Popup/RadioPopupDimAcquiring.qml";

        idRadioPopupDimAcquiring.visible = true;
        idRadioPopupDimAcquiring.focus = true;
        break;
    }
    default:
        break;
    }
    QmlController.autoTest_athenaSendObject();
}


