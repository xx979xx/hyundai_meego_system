/**
 * FileName: InfoOpertation.js
 * Author: WSH
 * Time: 2012-02-22
 *
 * Description: 2012-02-22 Initial Crated by HYANG
 */

//--------------- BackKey Processing #
function backKeyProcessing() {
    console.log(" # [InfoOperation][backKeyProcessing] ")
    switch(idAppMain.state)
    {
        case "InfoDrivingMain":{

            uiListener.HandleBackKey();
            console.log(" # [InfoOperation][InfoMenuMain] Back")
            break;
        }
    } // End switch
        if(uiListener.screenStackEmpty()==true)
            uiListener.HandleBackKey();
        else
            setAppMainScreen(preSelectedMainScreen(), false);
//    default:{
//        setAppMainScreen(preSelectedMainScreen(), false);
//        break;
//    }

} // End backKeyProcessing()

//--------------- Getting ID of Current State Item ( Focus move ) #
function currentStateID(){
    console.debug(" # [InfoOperation] currentStateID() : " + idAppMain.state);
    switch(idAppMain.state)
    {
    //App
    case "InfoDrivingMain":                  return idInfoDrivingMain;
    case "ClimateMain": return idClimateAppMain;
    case "SeatControlMain": return idSeatMain;

    default: console.log(" # [InfoOperation] currentStateID() ============== Warning!!"); break;
    } // End switch
} // End currentStateID()

//--------------- PropertyChanges for States ( Changing Main Screen ) #
function setPropertyChanges(mainScreen, saveCurrentScreen) {
    //var beforeTime = currentMilliseconds();

    //if( saveCurrentScreen == true ) setPreSelectedMainScreen();

    switch(idAppMain.state)
    {
        //App
        case "InfoDrivingMain":              idInfoDrivingMain.visible = false; idInfoDrivingMain.focus=false;break;
        case "ClimateMain":           idClimateAppMain.visible = false; idClimateAppMain.focus=false;break;
        case "SeatControlMain":         idSeatMain.visible = false; idSeatMain.focus=false;break;
    } // End switch

    idAppMain.state = mainScreen; // change state
    idAppMain.focus = true; // Focus for Current Screen

    //--------------- Main Screen #
    switch(mainScreen)
    {
        //App
        case "InfoDrivingMain":{
            console.log(" # [Loader] InfoDrivingMain ========== # ")
            if( idInfoDrivingMain.status == Loader.Null )
                idInfoDrivingMain.source = "../component/Info/Driving/InfoDrivingMain.qml";
            idInfoDrivingMain.visible = true;
            idInfoDrivingMain.focus = true;
            break;
        } // End case
        case "ClimateMain":{
            console.log(" # [Loader] ClimateMain ========== # ")
//            if( idClimateAppMain.status == Loader.Null )
//                idClimateAppMain.source = "../component/Climate/DHAVN_AppFATC_main.qml";
            idClimateAppMain.visible = true;
            idClimateAppMain.focus = true;
            break;
        } // End case
        case "SeatControlMain":{
            console.log(" # [Loader] SeatControlMain ========== # ")
            if( idSeatMain.status == Loader.Null )
                idSeatMain.source = "../component/SeatControl/DHAVN_AppSeatControl_main.qml";
            idSeatMain.visible = true;
            idSeatMain.focus = true;
            break;
        } // End case

        default: break;
    } // End switch

    //var afterTime = currentMilliseconds();
    //console.debug(mainScreen + " LoadingTime : " + intervalMilliseconds(beforeTime, afterTime) + " msecs");
} // End setPropertyChanges(mainScreen, saveCurrentScreen)
function setFont(languageId)
{
    switch(languageId)
    {
        case 3:
        case 4:
        case 5:
        {
            console.log("DFHeiW5-A Font");
        return  "DFHeiW5-A";
        }
        default:
        {
            console.log("HDB Font");
            return "HDB";
        }
    }
}
