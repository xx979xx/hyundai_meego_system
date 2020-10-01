/**
 * FileName: DmbOpertation.js
 * Author: jyjeon
 * Time: 2011-09-07 13:47
 *
 * Description: Collection of JavaScript Function for DMB
 *
 *
 *
 */

//channel search
function CmdReqChannelScan()
{
    //console.log("[DmbOperation] CmdReqChannelScan Called.");
    CommParser.cmdReqChannelScan();
}

//select channel
function CmdReqChannelChange(ChName)
{
    CommParser.cmdReqChannelChange(ChName);
}

//########## DMB preset Channel Management ##########
//cmd Preset check on
function CmdReqChannelSelete(ChName)
{
//    console.log("[DmbOperation] CmdReqChannelSelete: " + ChName);
    CommParser.cmdReqChannelSelete(ChName);
}

//cmd Preset check off
function CmdReqChannelUnselete(ChName)
{
//    console.log("[DmbOperation] cmdReqChannelUnselete: " + ChName);
    CommParser.cmdReqChannelUnselete(ChName);
}

//cmd Preset check on
function CmdReqChannelSeleteAll()
{
//    console.log("[DmbOperation] CmdReqChannelSeleteAll");
    CommParser.cmdReqChannelSeleteAll();
}

//cmd Preset check all
function CmdReqChannelUnseleteAll()
{
//    console.log("[DmbOperation] cmdReqChannelUnseleteAll");
    CommParser.cmdReqChannelUnseleteAll();
}


//cmd Add Preset List
function CmdReqPresetAdd(ChName)
{
//    console.log("[DmbOperation] CmdReqPresetAdd: " + ChName);
    CommParser.cmdReqPresetAdd(ChName);
}

//cmd delete preset List
function CmdReqPresetDelete(ChName)
{
//    console.log("[DmbOperation] CmdReqPresetDelete");
    CommParser.cmdReqPresetDelete(ChName);
}

//########## DMB Disaster Message List Edit ##########
//cmd check on
function CmdReqAMASMessageSelete(Message)
{
//    console.log("[DmbOperation] CmdReqAMASMessageSelete");
    CommParser.cmdReqAMASMessageSelete(Message);
}

//cmd check off
function CmdReqAMASMessageUnselete(Message)
{
//    console.log("[DmbOperation] CmdReqAMASMessageUnselete: " + Message);
    CommParser.cmdReqAMASMessageUnselete(Message);
}

//cmd check on all
function CmdReqAMASMessageSeleteAll()
{
//    console.log("[DmbOperation] CmdReqAMASMessageSeleteAll");
    CommParser.cmdReqAMASMessageSeleteAll();
}

//cmd check off all
function CmdReqAMASMessageUnseleteAll()
{
//    console.log("[DmbOperation] CmdReqAMASMessageUnseleteAll");
    CommParser.cmdReqAMASMessageUnseleteAll();
}

//cmd cancel delete all off
function cmdReqAMASMessageCancelDeleteAll()
{
//    console.log("[DmbOperation] cmdReqAMASMessageCancelDeleteAll");
    CommParser.cmdReqAMASMessageCancelDeleteAll();
}

//cmd delete Disaster List : if Message is null, delete all check(false) item
function CmdReqAMASMessageDelete(Message)
{
//    console.log("[DmbOperation] CmdReqAMASMessageDelete : " + Message);
    CommParser.cmdReqAMASMessageDelete(Message);
}

//cmd delete Disaster List : if Message is null, delete all check(false) item
function cmdReqAMASMessageDeleteAll()
{
//    console.log("[DmbOperation] cmdReqAMASMessageDeleteAll " );
    CommParser.cmdReqAMASMessageDeleteAll();
}

//cmd sort Disaster List
function CmdReqAMASMessageSort(sortItem)
{
//    console.log("[DmbOperation] CmdReqAMASMessageSort, SortItem: " + sortItem);
    CommParser.cmdReqAMASMessageSort(sortItem);
}

//cmd get count for Disaster List # by WSh (121212)
function CmdReqAMASMessageRowCount()
{
//    console.log("[DmbOperation] CmdReqAMASMessageRowCount");
    return CommParser.cmdReqAMASMessageRowCount();
}

//########## DMB Play service  ##########
//cmd Mute Play
function CmdReqPlayMuteOn()
{
//    console.log("[DmbOperation] cmdReqPlayMuteOn");
    CommParser.cmdReqPlayMuteOn()
}

function CmdReqPlayMuteOff()
{
//    console.log("[DmbOperation] cmdReqPlayMuteOff");
    CommParser.cmdReqPlayMuteOff()
}

//cmd Play Stop
function CmdReqPlayStop()
{
//    console.log("[DmbOperation] cmdReqPlayStop");
    CommParser.cmdReqPlayStop()
}

/*---------------------------------------------*/
/* Milliseconds Check Function For Perfomance  */
/*---------------------------------------------*/
// Call for Interval Milliseconds
function intervalMilliseconds(before, after) {
    return after - before;
}

// Call for Getting Milliseconds
function currentMilliseconds() {
    return (new Date()).getTime();
}
/*---------------------------------------------*/

//function toFirstScreen() {
//    //App
//    idDmbPlayerMain.visible = false;
//    idDmbDisasterMain.visible = false;
//    idDmbDisasterEdit.visible = false;
//    idDmbENGModeMain.visible = false;

//    //OptionMenu
//    idDmbPlayerOptionMenu = false;
//    idDmbDisasterOptionMenu = false;
//    idDmbDisasterEditOptionMenu = false;

//    //Popup
//    idPopupSearching.visible = false;
//    idPopupSearched.visible = false;
//    idPopupListEmpty.visible = false;
//    idPopupChannelDeleteConfirm = false;
//    idPopupDisasterInformation.visible = false;
//    idPopupDisasterDeleteConfirm.visible = false;
//    idPopupDisasterDeleteAllConfirm.visible = false;
//    idPopupDisasterDeleting.visible = false;
    
//    //Dim Popup
//    idDimPopupDeleted.visible = false;
//    idDimPopupSetFullScreen.visible = false;

//    setPropertyChanges("AppDmbPlayer", false);
//}

function backKeyProcessing() {
//    console.log("================== [backKeyProcessing] idAppMain.state: "+idAppMain.state)
    switch(idAppMain.state)
    {
    case "AppDmbPlayer":{
        EngineListener.HandleBackKey(UIListener.getCurrentScreen());
        break;
    }
    case "PopupListEmpty":{
        setAppMainScreen(preSelectedMainScreen(), false);
        break;
    }
    case "PopupSearched":
    case "PopupSearching":
    case "PopupDeleted":
    {
        setAppMainScreen(preSelectedMainScreen(), false);

        if(idAppMain.state == "PopupDeleted" && idAppMain.isMainDeletedPopup == false) break;

        if(idAppMain.isENGMode == false)
        {
            if(idAppMain.state == "AppDmbPlayer" && idAppMain.presetListModel.rowCount() == 0){
                setAppMainScreen("PopupListEmpty", true);
            }
        }
        break;
    }

    default:{
        setAppMainScreen(preSelectedMainScreen(), false);

//        if(idAppMain.state == "AppDmbPlayer" && idAppMain.presetListModel.rowCount() == 0){
//            setAppMainScreen("PopupListEmpty", true);
//        }
        break;
    }
    }
}

// Getting ID of Current State Item
function currentStateID()
{
    //console.log("currentStateID() : " + idAppMain.state);

    var logMsg = "[QML] currentStateID : " + idAppMain.state;

    EngineListener.printLogMessge(logMsg);

    switch(idAppMain.state)
    {
    //App
    case "AppDmbPlayer":                    return idDmbPlayerMain;
    case "AppDmbDisaterList":               return idDmbDisasterMain;
    case "AppDmbDisaterListEdit":           return idDmbDisasterEdit;
    case "AppDmbENGMode":                   return idDmbENGModeMain;

    //OptionMenu
    case "AppDmbPlayerOptionMenu":          return idDmbPlayerOptionMenu;
    case "AppDmbDisasterOptionMenu":        return idDmbDisasterOptionMenu;
    case "AppDmbDisasterEditOptionMenu":    return idDmbDisasterEditOptionMenu;

    //Popup
    case "PopupSearching":                  return idPopupSearching;
    case "PopupSearched":                   return idPopupSearched;
    case "PopupListEmpty":                  return idPopupListEmpty;
    case "PopupChannelDeleteConfirm":       return idPopupChannelDeleteConfirm;
    case "PopupDisasterInfomation":         return idPopupDisasterInformation;
    case "PopupDisasterDeleteConfirm":      return idPopupDisasterDeleteConfirm;
    case "PopupDisasterDeleteAllConfirm":   return idPopupDisasterDeleteAllConfirm;
    case "PopupDisasterDeleting":           return idPopupDisasterDeleting;
    
    //Dim Popup
    case "PopupDeleted":                    return idDimPopupDeleted;
    case "PopupSetFullScreen":              return idDimPopupSetFullScreen;
    default: console.log("currentStateID() ============== Warning!!"); break;
    }
    return "";
}

// PropertyChanges for States ( Changing Main Screen )
function setPropertyChanges(mainScreen, saveCurrentScreen) {
    var beforeTime = currentMilliseconds();

    if(mainScreen == idAppMain.state)
    {
        return;
    }

    if( saveCurrentScreen == true )
    {
        setPreSelectedMainScreen();
        switch(idAppMain.state)
        {
        //App
        case "AppDmbPlayer":                    if(mainScreen=="AppDmbENGMode")idDmbPlayerMain.visible = false; break;
        case "AppDmbDisaterList":               /*idDmbDisasterMain.visible = false;*/ break;
        case "AppDmbDisaterListEdit":           /*idDmbDisasterEdit.visible = false;*/ break;
        case "AppDmbENGMode":                 if(mainScreen !="PopupSearching") idDmbENGModeMain.visible = false; break;

        //OptionMenu
        case "AppDmbPlayerOptionMenu":          if(idAppMain.state!="AppDmbPlayerOptionMenu")idDmbPlayerOptionMenu.visible = false; break;
        case "AppDmbDisasterOptionMenu":        idDmbDisasterOptionMenu.visible = false; break;
        case "AppDmbDisasterEditOptionMenu":    idDmbDisasterEditOptionMenu.visible = false; break;

        //Popup
        case "PopupSearching":                  idPopupSearching.visible = false; break;
        case "PopupSearched":                   idPopupSearched.visible = false; break;
        case "PopupListEmpty":                  idPopupListEmpty.visible = false; break;
        case "PopupChannelDeleteConfirm":       idPopupChannelDeleteConfirm.visible = false; break;
        case "PopupDisasterInfomation":         idPopupDisasterInformation.visible = false; break;
        case "PopupDisasterDeleteConfirm":      idPopupDisasterDeleteConfirm.visible = false; break;
        case "PopupDisasterDeleteAllConfirm":   idPopupDisasterDeleteAllConfirm.visible = false; break;
        case "PopupDisasterDeleting":           idPopupDisasterDeleting.visible = false; break;
        
	//Dim Popup
        case "PopupDeleted":                    idDimPopupDeleted.visible = false; break;
        case "PopupSetFullScreen":              idDimPopupSetFullScreen.visible = false; break;
        default: console.log(" (saveCurrentScreen === true) ============== Error!!"); break;
        }
    }
    else
    {
        switch(idAppMain.state)
        {
        //App
        case "AppDmbPlayer":                    idDmbPlayerMain.visible = false; break;
        case "AppDmbDisaterList":               idDmbDisasterMain.visible = false; break;
        case "AppDmbDisaterListEdit":           idDmbDisasterEdit.visible = false; break;
        case "AppDmbENGMode":                   idDmbENGModeMain.visible = false; break;

        //OptionMenu
        case "AppDmbPlayerOptionMenu":          idDmbPlayerOptionMenu.visible  = false; break;
        case "AppDmbDisasterOptionMenu":        idDmbDisasterOptionMenu.visible = false; break;
        case "AppDmbDisasterEditOptionMenu":    idDmbDisasterEditOptionMenu.visible = false; break;

        //Popup
        case "PopupSearching":                  idPopupSearching.visible = false; break;
        case "PopupSearched":                   idPopupSearched.visible = false; break;
        case "PopupListEmpty":                  idPopupListEmpty.visible = false; break;
        case "PopupChannelDeleteConfirm":       idPopupChannelDeleteConfirm.visible = false; break;
        case "PopupDisasterInfomation":         idPopupDisasterInformation.visible = false; break;
        case "PopupDisasterDeleteConfirm":      idPopupDisasterDeleteConfirm.visible = false; break;
        case "PopupDisasterDeleteAllConfirm":   idPopupDisasterDeleteAllConfirm.visible = false; break;
        case "PopupDisasterDeleting":           idPopupDisasterDeleting.visible = false; break;

        //Dim Popup
        case "PopupDeleted":                    idDimPopupDeleted.visible = false; break;
        case "PopupSetFullScreen":              idDimPopupSetFullScreen.visible = false; break;
        default: console.log(" (saveCurrentScreen === false) ============== Error!!"); break;
        }
    }

    idAppMain.state = mainScreen; // change state

    // Focus for Current Screen
    idAppMain.focus = true;

    switch(mainScreen)
    {
    //App
    case "AppDmbPlayer":{
        if( idDmbPlayerMain.status == Loader.Null ){
            idDmbPlayerMain.source = "../component/Dmb/DmbPlayer/DHDmbPlayerMain.qml";
            idDmbPlayerMain.visible = true;
            idDmbPlayerMain.focus = true;

// Set state : NoSignal # by WSH(121127)
//            if(idDmbPlayerMain.item.playerList.count == 0){
//                setAppMainScreen("PopupListEmpty", true);
//            }
        }
        else{
            idDmbPlayerMain.visible = true;
            idDmbPlayerMain.focus = true;
            setVisibleQML()
        }

//        EngineListener.setShowOSDFrontRear(false);
        break;
    }
    case "AppDmbDisaterList":{
        if( idDmbDisasterMain.status == Loader.Null )
            idDmbDisasterMain.source = "../component/Dmb/DmbDis/DHDmbDisasterMain.qml";

        idDmbDisasterMain.visible = true;
        idDmbDisasterMain.focus = true;

        EngineListener.setShowOSDFrontRear(true);

        break;
    }
    case "AppDmbDisaterListEdit":{
        if( idDmbDisasterEdit.status == Loader.Null )
            idDmbDisasterEdit.source = "../component/Dmb/DmbDis/DHDmbDisasterEdit.qml";

        idDmbDisasterEdit.visible = true;
        idDmbDisasterEdit.focus = true;

        EngineListener.setShowOSDFrontRear(true);
        break;
    }
    case "AppDmbENGMode":{
        if( idDmbENGModeMain.status == Loader.Null )
            idDmbENGModeMain.source = "../component/Dmb/ENGMode/ENGModeMain.qml";

        idDmbENGModeMain.visible = true;
        idDmbENGModeMain.focus = true;
        break;
    }

    //OptionMenu
    case "AppDmbPlayerOptionMenu":{
        if( idDmbPlayerOptionMenu.status == Loader.Null )
            idDmbPlayerOptionMenu.source = "../component/Dmb/DmbPlayer/DmbPlayerOptionMenu.qml";

        idDmbPlayerOptionMenu.visible = true;
        idDmbPlayerOptionMenu.focus = true;
        break;
    }

    case "AppDmbDisasterOptionMenu":{
        if( idDmbDisasterOptionMenu.status == Loader.Null )
            idDmbDisasterOptionMenu.source = "../component/Dmb/DmbDis/DmbDisasterOptionMenu.qml";

        idDmbDisasterOptionMenu.visible = true;
        idDmbDisasterOptionMenu.focus = true;
        break;
    }

    case "AppDmbDisasterEditOptionMenu":{
        if( idDmbDisasterEditOptionMenu.status == Loader.Null )
            idDmbDisasterEditOptionMenu.source = "../component/Dmb/DmbDis/DmbDisasterEditOptionMenu.qml";

        idDmbDisasterEditOptionMenu.visible = true;
        idDmbDisasterEditOptionMenu.focus = true;
        break;
    }

    //Popup
    case "PopupSearching":{
        if( idPopupSearching.status == Loader.Null )
            idPopupSearching.source = "../component/Dmb/Popup/DmbPopupSearching.qml";

        idPopupSearching.visible = true;
        idPopupSearching.focus = true;
        EngineListener.setShowOSDFrontRear(false);
        CommParser.onFullScan();
        break;
    }
    case "PopupSearched":{
        if( idPopupSearched.status == Loader.Null )
            idPopupSearched.source = "../component/Dmb/Popup/DmbPopupSearched.qml";

        idPopupSearched.visible = true;
        idPopupSearched.focus = true;
        break;
    }
    case "PopupListEmpty":{
        if( idPopupListEmpty.status == Loader.Null )
            idPopupListEmpty.source = "../component/Dmb/Popup/DmbPopupListEmpty.qml";

        idPopupListEmpty.visible = true;
        idPopupListEmpty.focus = true;
        break;
    }
    case "PopupChannelDeleteConfirm":{
        if( idPopupChannelDeleteConfirm.status == Loader.Null )
            idPopupChannelDeleteConfirm.source = "../component/Dmb/Popup/DmbPopupChannelDeleteConfirm.qml";

        idPopupChannelDeleteConfirm.visible = true;
        idPopupChannelDeleteConfirm.focus = true;
        break;
    }
    case "PopupDisasterInfomation":{
        if( idPopupDisasterInformation.status == Loader.Null )
            idPopupDisasterInformation.source = "../component/Dmb/Popup/DmbPopupDisasterInformation.qml";

        idPopupDisasterInformation.visible = true;
        idPopupDisasterInformation.focus = true;        
        break;
    }
    case "PopupDisasterDeleteConfirm":{
        if( idPopupDisasterDeleteConfirm.status == Loader.Null )
            idPopupDisasterDeleteConfirm.source = "../component/Dmb/Popup/DmbPopupDisasterDeleteConfirm.qml";

        idPopupDisasterDeleteConfirm.visible = true;
        idPopupDisasterDeleteConfirm.focus = true;
        break;
    }
    case "PopupDisasterDeleteAllConfirm":{
        if( idPopupDisasterDeleteAllConfirm.status == Loader.Null )
            idPopupDisasterDeleteAllConfirm.source = "../component/Dmb/Popup/DmbPopupDisasterDeleteAllConfirm.qml";

        idPopupDisasterDeleteAllConfirm.visible = true;
        idPopupDisasterDeleteAllConfirm.focus = true;
        break;
    }
    case "PopupDisasterDeleting":{
        if( idPopupDisasterDeleting.status == Loader.Null )
            idPopupDisasterDeleting.source = "../component/Dmb/Popup/DmbPopupDisasterDeleting.qml";

        idPopupDisasterDeleting.visible = true;
        idPopupDisasterDeleting.focus = true;
        break;
    }

    //Dim Popup
    case "PopupDeleted":{ // Deleted Popup for Disaster
        if( idDimPopupDeleted.status == Loader.Null )
            idDimPopupDeleted.source = "../component/Dmb/Popup/DmbDimPopupDeleted.qml";

        idDimPopupDeleted.visible = true;
        idDimPopupDeleted.focus = true;
        break;
    }
    case "PopupSetFullScreen":{
        if( idDimPopupSetFullScreen.status == Loader.Null )
            idDimPopupSetFullScreen.source = "../component/Dmb/Popup/DmbDimPopupSetFullScreen.qml";

        idDimPopupSetFullScreen.visible = true;
        idDimPopupSetFullScreen.focus = true;
        break;
    }

    default:{
        //exception : GO TO frist screen
        idAppMain.state = "AppDmbPlayer";

        if( idDmbPlayerMain.status == Loader.Null ){
            idDmbPlayerMain.source = "../component/Dmb/DmbPlayer/DHDmbPlayerMain.qml";
            idDmbPlayerMain.visible = true;
            idDmbPlayerMain.focus = true;

            if(idAppMain.presetListModel.rowCount() == 0){
                setAppMainScreen("PopupListEmpty", true);
            }
        }
        else{
            idDmbPlayerMain.visible = true;
            idDmbPlayerMain.focus = true;
        }
        break;
    }

    }
    var afterTime = currentMilliseconds();
//    console.log(mainScreen + " LoadingTime : " + intervalMilliseconds(beforeTime, afterTime) + " msecs");
}

function setVisibleQML(){
    idDmbDisasterMain.visible = false
    idDmbDisasterEdit.visible = false
}

function getAlarmPriority(AlarmPriority){
    switch(AlarmPriority){
        case 0: return stringInfo.strDmbDis_List_Priority_Unknown
        case 1: return stringInfo.strDmbDis_List_Priority_Normal
        case 2: return stringInfo.strDmbDis_List_Priority_High
        case 3: return stringInfo.strDmbDis_List_Priority_Urgent
        default: return stringInfo.strDmbDis_List_Priority_Unknown
    }
}

function getVerticalAlignment(textVAlignment)
{
    switch(textVAlignment)
    {
        case "Top" : { return Text.AlignTop; break; }
        case "Bottom" : { return Text.AlignBottom; break; }
        case "Center" : { return Text.AlignVCenter; break; }
        default:
        {
//            console.log(" MButton_funtion getVerticalAlignment()::textVAlignment Error ========================>> ")
            return Text.AlignVCenter;
            break;
        }
    }
}

function getHorizontalAlignment(textHAlignment)
{
    switch(textHAlignment)
    {
        case "Right" : { return Text.AlignRight; break; }
        case "Left" : { return Text.AlignLeft; break; }
        case "Center" : { return Text.AlignHCenter; break; }
        default:
        {
//            console.log(" MButton_funtion getHorizontalAlignment()::textHAlignment Error ========================>> ")
            return Text.AlignHCenter;
            break;
        }
    }
}

function getTextElide(textElide)
{
    switch(textElide)
    {
        case "Right" : { return Text.ElideRight; break; }
        case "Left" : { return Text.ElideLeft; break; }
        case "Center" : { return Text.ElideMiddle; break; }
        case "None" : { return Text.ElideNone; break; }
        default:
        {
//            console.log(" MButton_funtion getTextElide()::textElide Error ========================>> ")
            return Text.ElideNone;
            break;
        }
    }
}

