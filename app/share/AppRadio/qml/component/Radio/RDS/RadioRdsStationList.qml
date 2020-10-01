/**
 * FileName: RadioRdsStationList.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */

import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idRadioRdsStationList
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight-systemInfo.titleAreaHeight+systemInfo.contentTopMargin
    focus: true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }

    //****************************** # ChannelList Background Image #
    Image{
        y: -systemInfo.statusBarHeight //0 //KSW 140120 for KH
        //20130910 change bg image.
        //        source: imgFolderGeneral+"bg_type_a.png"
        source: imgFolderGeneral+"bg_main.png"

    }
//20130107 added by qutiguy - station list view 30' limited show
    //--------------------- Timer Info(Property) #
    property int timerCount : 1;
    property int timerMaxCount : 15;
    property bool bMaualTune : false; //KSW 131230-3 ITS/217596
    property bool bMaualTunePress : false; //dg.jin 20141007 band tune press issue
    signal signalCloseStationListView();
    signal signalRestartTimerStationList();

    Timer{
        id : idRDSStationListViewTimer
        interval: 1000
        repeat: true;

        onTriggered:{
            if(timerCount == timerMaxCount){
                finishTimer();
                return;
            }
            timerCount++;
            console.log(" [RadioRdsStationList][idRDSStationListViewTimer][onTriggered] " + timerCount);

        }
        function startTimer()
        {
            timerCount = 1;
            idRDSStationListViewTimer.restart()
        }
        function finishTimer()
        {
            idRDSStationListViewTimer.stop()
            signalCloseStationListView();
        }
        function resetTimer(){
            timerCount = 1;
        }
    } // End Timer
    //--------------------- Visible change(Function) #
    onVisibleChanged: {
        console.log(" [RadioRdsStationList][idRadioRdsStationList][onVisibleChanged] " + idRadioRdsStationList.visible)
        if(visible) {
            // 2013.09.30 modified by qutiguy - EU/ISV/C/91895
            //            idRadioRdsStationList.focus = true
            idRadioRdsStationListView.forceActiveFocus();
            idRDSStationListViewTimer.startTimer()
        }
        else {
            idRDSStationListViewTimer.stop()
        }
    }
    //--------------------- Focus change(Function) #
    onActiveFocusChanged: {
        console.log(" [RadioRdsStationList][idRadioRdsStationList][onActiveFocusChanged] " )
        if(activeFocus) { idRDSStationListViewTimer.startTimer() }
        else { idRDSStationListViewTimer.stop() }
    }
    onSignalRestartTimerStationList:{idRDSStationListViewTimer.startTimer()}
    onAnyKeyReleased: {idRDSStationListViewTimer.startTimer()}
    onSignalCloseStationListView:{
        gotoBackScreen();
    }

    //KSW 131230-3 ITS/217596
    Connections{
        target: UIListener

        onSignalIsManualTune: {
            console.log(" [RadioRdsStationList][idRadioRdsStationList][onSignalIsManualTune] " +bIsManualTune)
            bMaualTune = bIsManualTune;
        }

        //dg.jin 20141007 band tune press issue
        onSignalIsManualTunePress: {
            bMaualTunePress = bIsManualTunePress;
        }

        onSignalStationListClose: {
            idRDSStationListViewTimer.stop();
            signalCloseStationListView();
        }
    }

    //****************************** # Title Band #
    MComp.MBand{
        id: idMBand
        x: 0; y: 0

        tabBtnCount: 0
        titleText: stringInfo.strRDSMenuStationList  //"Station List"      
        menuBtnFlag: true
        tunePress: bMaualTunePress //dg.jin 20141007 band tune press issue
        menuBtnText: stringInfo.strRDSMenuMenu  //"Menu"

        // 2013.09.30 modified by qutiguy - EU/ISV/C/91895
        onMenuBtnClicked: { idMBand.giveForceFocus("menuBtn"); idRadioRdsStationListView.forceActiveFocus(); setAppMainScreen( "AppRadioRdsOptionMenuStationList" , true); }
        onBackBtnClicked: { idMBand.giveForceFocus("backBtn"); gotoBackScreen() }

        focus : (idRadioRdsStationListView.modelTotCount < 1)
        KeyNavigation.down: (idRadioRdsStationListView.modelTotCount > 0)?idRadioRdsStationListView:idMBand;

        // 2013.09.30 added by qutiguy - EU/ISV/C/91895
        Component.onCompleted: idMBand.giveForceFocus("menuBtn")

        //KSW 131230-3 ITS/217596
        Keys.onPressed: {
            if(bMaualTune != true)
            {
                console.log("=========================>key bypass");
                return;
            }
            switch(event.key){
                case Qt.Key_Semicolon:{
                    //console.log("=========================>Key_Semicolon");
                    idRadioRdsStationListView.forceActiveFocus();
                    break;
                }
                case Qt.Key_Apostrophe:{
                    //console.log("=========================>Key_Apostrophe");
                    idRadioRdsStationListView.forceActiveFocus();
                    break;
                }
                default:
                    break;
            }
        }
    }

    //****************************** # StationList Content #
    RadioRdsStationListView{
        id: idRadioRdsStationListView
        x: 0; y: systemInfo.titleAreaHeight
        focus: (modelTotCount > 0)

        KeyNavigation.up: idMBand.giveForceFocus("backBtn") //KSW 131230-3 ITS/217596
    }

    //****************************** # Menu Open when clicked I, L, Slash key #
    onClickMenuKey: setAppMainScreen( "AppRadioRdsOptionMenuStationList" , true);

    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed: gotoBackScreen()

//    function countStationListItem(){
//        console.log("idRadioRdsStationListView.modelTotCount",idRadioRdsStationListView.modelTotCount);
//    }
//    Component.onCompleted: {console.log(" >>>>>> 0. StationList Component.onCompleted.........................");countStationListItem();}
//    onShowFocusChanged: { console.log(" >>>>>> 1. StationList onShowFocusChanged.........................");}
//    onActiveFocusChanged: { console.log(" >>>>>> 2. StationList onActiveFocusChanged.........................");countStationListItem()}
//    onFocusChanged: { console.log(" >>>>>> 3. StationList onFocusChanged.........................");}
//    onVisibleChanged: { console.log(" >>>>>> 4. StationList onVisibleChanged.........................visible = ", idRadioRdsStationList.visible);}
//    onAnyKeyReleased:{console.log(" >>>>>> 5. StationList onAnyKeyReleased.........................");}
}

