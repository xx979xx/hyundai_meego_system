/**
 * FileName: NonAVMain.qml
 * Author: WSH
 * Time: 2012-02-23
 *
 * Description: 2012-02-23 Initial Crated by WSH
 */

import Qt 4.7
import "../component/system/DH" as MSystem
import "../component/QML/DH" as MComp
import "../component/Info" as MInfo
import "../component/Info/CarSetting" as MCarSetting
import "../component/Info/Driving" as MDriving
import "../component/Info/Height" as MHeight
import "../component/Climate" as MClimate
import "../component/SeatControl" as MSeatControl
import "../component/Info/JavaScript/InfoOperation.js" as MInfoOperation
// MERGE_NONAV
//import "../subapp" as MBlack
//import QmlStatusBarWidget 1.0

MComp.MAppMain{
    id: idAppMain //idInfoMain
    width:systemInfo.lcdWidth; height:systemInfo.lcdHeight
    focus : true
    x:0
    y:0

    property string imgFolderAutocare : imageInfo.imgFolderAutocare
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderInfo : imageInfo.imgFolderInfo
    property string imgFolderClimate : imageInfo.imgFolderClimate
    property string imgFolderSeatControl: imageInfo.imgFolderSeatControl

    //--------------- Car Image Info(Property) #
    property int imgBigCarX: 202
    property int imgBigCarY: 372-systemInfo.statusBarHeight
    property string imgBigCarSource: imgFolderInfo+"car.png"

    //--------------- Selected State(Property) #
    property string lastHeightState : "init"//"NormalStop"
    property string lastDrivingState : "init" //Normal"
    property string drivingMode: ""

    MSystem.ColorInfo    { id: colorInfo }
    MInfo.InfoImageInfo  { id: imageInfo }
    MSystem.SystemInfo   { id: systemInfo }
    MInfo.InfoStringInfo { id: stringInfo }



    //--------------- First Main Screen #
    property string selectedMainScreen: "AppInfo_Start"
    function currentAppStateID() { return MInfoOperation.currentStateID(); }
    function preSelectedMainScreen() { return uiListener.popScreen(); }
    function setPreSelectedMainScreen() { uiListener.pushScreen(idAppMain.state); console.debug(" ##### PUSH SCREEN  idAppMain.state :"+idAppMain.state);}
    function setAppMainScreen(mainScreen, saveCurrentScreen)
    {
        if( idAppMain.state !== mainScreen)
            MInfoOperation.setPropertyChanges(mainScreen, saveCurrentScreen);
    }

//    function gotoBackScreen() { MInfoOperation.backKeyProcessing(); }

//    //--------------- Loading completed (First Focus) #
//    Component.onCompleted:{
////        console.log("setAppMainScreen");
////        setAppMainScreen(selectedMainScreen, true);
//        idAppMain.state=selectedMainScreen;

//    }

    onStateChanged:{
        switch(idAppMain.state){
     //   case "InfoMenuMain":                 idInfoMenuMain.forceActiveFocus(); break;
            case "InfoDrivingMain":              idInfoDrivingMain.forceActiveFocus();break;
            case "ClimateMain":                 idClimateAppMain.forceActiveFocus();  break;
            case "SeatControlMain":         idSeatMain.forceActiveFocus();break;

            default:  idClimateAppMain.forceActiveFocus(); break;
        } // End switch
        console.debug(" # [InfoMain][onStateChanged] idAppMain.state :"+idAppMain.state);
    }
    Keys.forwardTo: idInfoMainArea;
//    Keys.onPressed:{
//        switch( event.key )
//        {
//            case Qt.Key_Left:
//            case Qt.Key_Right:
//            case Qt.Key_Up:
//            case Qt.Key_Down:
//            case Qt.Key_Return:
//            {
//                console.log("Keys.onPressed in NonAVMain " + uiListener.getTopApp());
//                switch(uiListener.getTopApp())
//                {
//                    case 1:
//                    {
//                        idInfoDrivingMain.focus=true
//                        idInfoDrivingMain.forceActiveFocus()
//                        forwardTo:idInfoDrivingMain
//                        event.accepted=true;
//                        break;
//                    }
//                    case 2:
//                    {
//                        idClimateAppMain.focus=true
//                        idClimateAppMain.forceActiveFocus()
//                        forwardTo:idClimateAppMain
//                        event.accepted=true;
//                        break;
//                    }
//                    case 3:
//                    {
//                        idSeatMain.focus=true
//                        idSeatMain.forceActiveFocus()
//                        forwardTo:idSeatMain
//                        event.accepted=true;
//                        break;
//                    }
//                }
//            }break;
//        }
//    }
//    Keys.onReleased:{
//        switch( event.key )
//        {
//            case Qt.Key_Left:
//            case Qt.Key_Right:
//            case Qt.Key_Up:
//            case Qt.Key_Down:
//            case Qt.Key_Return:
//            {
//                console.log("Keys.onReleased in NonAVMain"+ uiListener.getTopApp());
//                switch(uiListener.getTopApp())
//                {
//                    case 1:
//                    {
//                        idInfoDrivingMain.focus=true
//                        idInfoDrivingMain.forceActiveFocus()
//                        forwardTo:idInfoDrivingMain
//                        break;
//                    }
//                    case 2:
//                    {
//                        idClimateAppMain.focus=true
//                        idClimateAppMain.forceActiveFocus()
//                        forwardTo:idClimateAppMain
//                        break;
//                    }
//                    case 3:
//                    {
//                        idSeatMain.focus=true
//                        idSeatMain.forceActiveFocus()
//                        forwardTo:idSeatMain
//                        break;
//                    }
//                }

//            }break;
//        }
//    }

    //--------------- Info Background Image #
    Rectangle {
        y: systemInfo.statusBarHeight
        height: systemInfo.lcdHeight-systemInfo.statusBarHeight
//        source: imgFolderAutocare+"autocare_bg.png"
        color: "transparent"
    } // End Image

    //--------------- APP LOADER #
    //FocusScope{
    MComp.MComponent{
        id: idInfoMainArea
        //focus: true
        Loader {id: idInfoDrivingMain; y: systemInfo.statusBarHeight }
//        Loader {id: idClimateAppMain; y: 0}
        Loader {id: idSeatMain; y:0 }

        MClimate.DHAVN_AppFATC_main {
            id:idClimateAppMain
            y:0
            visible: true
            focus: true
        }

        Component.onCompleted: {
            console.log(" complete NonAVMain.qml !!!!!!!!!!!!!!")
        }

//        Keys.onPressed:
//        {
//            switch( event.key )
//            {
//            case Qt.Key_Left:
//            case Qt.Key_Right:
//            case Qt.Key_Up:
//            case Qt.Key_Down:
////            case Qt.Key_Return:
//            {
//                console.log("Keys.onPressed in inInfoMain ");
//                //event.accepted=true;

//                }


//            }break;
//            }
//        }
//        Keys.onReleased:
//        {
//            switch( event.key )
//            {
//            case Qt.Key_Left:
//            case Qt.Key_Right:
//            case Qt.Key_Up:
//            case Qt.Key_Down:
//            case Qt.Key_Return:
//            {
//                console.log("Keys.onPressed in inInfoMain ");
//                //event.accepted=true;



//            }break;
//            }
//        }
    }

    // WSH
    Connections{
        target: canMethod
        onDrivingStateChanged:{
            console.log(" # [InfoMain][Connections][onDrivingStateChanged] ")
            if(canDB.C_DrivingModeState==="1"){idAppMain.drivingMode = "Normal" }
            else if(canDB.C_DrivingModeState==="2"){ idAppMain.drivingMode = "Sports" }
            else if(canDB.C_DrivingModeState==="3"){ idAppMain.drivingMode = "ECO" }
            else if(canDB.C_DrivingModeState==="4"){ idAppMain.drivingMode = "Snow" }
        } // End onDrivingStateChanged


    } // End Connections

    Connections{
        target: uiListener
        onEntryValue:{
            //statuBar.visible = true
//            enum {
//                ENTRY_BLACK_SCREEN =0,
//                ENTRY_DRIVING_MODE =1,
//                ENTRY_CLIMATE_MODE =2
//                ENTRY_SEATCONTROL_MODE =2            3
//            };

            if(entryPoint == 1 ){ // ENTRY_DRIVING_MODE
                uiListener.autoTest_athenaSendObject();
                setAppMainScreen("InfoDrivingMain", false);
                //uiListener.setTopApp(entryPoint);
            }else if(entryPoint == 2 ){ // ENTRY_CLIMATE_MODE
                uiListener.autoTest_athenaSendObject();
                setAppMainScreen("ClimateMain", false);
                //uiListener.setTopApp(entryPoint);
            }else if(entryPoint == 3 ){ // ENTRY_SEATCONTROL_MODE
                uiListener.autoTest_athenaSendObject();
                setAppMainScreen("SeatControlMain", false);
                //uiListener.setTopApp(entryPoint);
            }

        }
    }

} // End MAppMain
