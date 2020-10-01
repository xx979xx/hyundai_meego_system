/**
 * FileName: DABStationList.qml
 * Author: DaeHyungE
 * Time: 2012-07-02
 *
 * - 2012-07-02 Initial Crated by HyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent {
    id : idDabStationList
    x : 0
    y : 0
    width : systemInfo.lcdWidth
    height : systemInfo.subMainHeight
    focus : true
    objectName: "DABStationList"

    property bool seekPrevLongKeyPressed : idAppMain.seekPrevLongKeyPressed;
    property bool seekNextLongKeyPressed : idAppMain.seekNextLongKeyPressed;
    property bool isMovemented : false

    function initialize()
    {
        console.log("[QML] DABStationList.qml : initialize")    
        idDabStationListView.initialize();        
    }

    //==========================Background Image
    Image {
        id : idStationListBGImg
        y : 0
        source : imageInfo.imgBg_Main
    }   

    DABStationListView {
        id : idDabStationListView
        x : 0
        y : systemInfo.titleAreaHeight
        width : idDabStationListBand.width
        height : 540
        focus : true
        KeyNavigation.up : idDabStationListBand

        property QtObject idStationTimer: idStationTimer
        //******************************# For Timer 15s in StationList
        Timer {
            id: idStationTimer
            interval: 15000
            running: idAppMain.state == "DabStationList" 
            repeat: false
            onTriggered:
            {
                console.log("[QML] DABStitionList.qml : idStationTimer")
                gotoMainScreen()
            }
        }
    }

    DABStationListBand {
        id : idDabStationListBand
        x : 0
        y : 0
        KeyNavigation.down : idDabStationListView
        onTuneLeftKeyPressed: idDabStationListView.focus = true
        onTuneRightKeyPressed: idDabStationListView.focus = true
    }

    onSeekPrevKeyReleased: {      
        if(idAppMain.bSeekPrevKeyReleased == true){
            idDabStationListView.focus = true;
            idDabStationListView.seekPrevKeyReleaseFunc();
        }
        idAppMain.bSeekPrevKeyReleased  = false;
    }

    onSeekNextKeyReleased: {    
        if(idAppMain.bSeekNextKeyReleased == true){
            idDabStationListView.focus = true;
            idDabStationListView.seekNextKeyReleasedFunc();
        }
        idAppMain.bSeekNextKeyReleased  = false;
    }

    onSeekPrevLongKeyPressedChanged: {      
        idDabStationListView.focus = true;
        idDabStationListView.seekPrevLongKeyReleasedFunc(seekPrevLongKeyPressed);
    }

    onSeekNextLongKeyPressedChanged: {    
        idDabStationListView.focus = true;
        idDabStationListView.seekNextLongKeyReleasedFunc(seekNextLongKeyPressed);
    }

    onClickMenuKey: {
        console.log("[QML] DABStationList.qml : onClickMenuKey")    
        if(idDabStationListView.listCountZeroCheck() == true) idDabStationListBand.focus = true;
        else idDabStationListView.focus = true
        setAppMainScreen("DabStationListMainMenu", true);
    }

    onBackKeyPressed: {  
        console.log("[QML] DABStitionList.qml : onBackKeyPressed")
        gotoBackScreen();
    }    

    onVisibleChanged: {
        if(visible){
            idStationTimer.start();
            if(idDabStationListView.listCountZeroCheck() == true) idDabStationListBand.focus = true;
            else idDabStationListView.focus = true
        }
        else{
            idStationTimer.stop();
        }
    }

    onAnyKeyPressed: {
        idStationTimer.restart();
    }

    onActiveFocusChanged: {
        if(!idDabStationList.activeFocus) idAppMain.pressCancelSignal();
    }
}
