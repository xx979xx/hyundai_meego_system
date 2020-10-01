/**
 * FileName: DABInfoEPGMain.qml
 * Author: DaeHyungE
 * Time: 2013-01-24
 *
 * - 2013-01-24 Initial Created by DaeHyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent{
    id: idDabInfoEPGMain
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true
    objectName: "DABEPGList"

    property bool seekPrevLongKeyPressed : idAppMain.seekPrevLongKeyPressed;
    property bool seekNextLongKeyPressed : idAppMain.seekNextLongKeyPressed;
    property int leftSelectedIndex       : 0
    property int ensembleNameCount       : 0
    property string epgFocusPosition: "ServiceList"
    property bool isExist : false
    property bool epgChannelTimerRunning: false

    //******************************# Background Image
    Image {
        y: 0//-systemInfo.statusBarHeight
        source: imageInfo.imgBg_Main
    }

    ListModel {
        id : idServiceNameListModel
    }

    ListModel {
        id : idEPGListModel
    }

    //******************************# EPG Band
    DABInfoEPGBand{
        id: idDabInfoEPGBand
        x: 0; y: 0
        KeyNavigation.down : idDabInfoEPGMain.focusMovefromBand()
    }

    function focusMovefromBand(){
        if(idDabInfoEPGMainLeft.listCountZeroCheck() == true) return idDabInfoEPGBand
        else return idDabInfoEPGMainRight
    }

    //#****************************** Left/Right Background Image
    Image {
        x: 0; y: 166 - systemInfo.statusBarHeight
        source: epgFocusPosition == "ServiceList" ? imageInfo.imgBgMenu_L : ""
    }

    Image {
        y: 166 - systemInfo.statusBarHeight
        source: epgFocusPosition == "SettingContents" ? imageInfo.imgBgMenu_R : ""
    }

    //******************************# Left/Right Background Image
    Image {
        id: idEPGLeftBgImg
        x:0; y: systemInfo.titleAreaHeight;
        source: epgFocusPosition == "ServiceList" ? imageInfo.imgBgMenu_L_S : ""
    }

    DABInfoEPGMainRight {
        id : idDabInfoEPGMainRight
        x : 708-9
        y : systemInfo.titleAreaHeight;
        width : 572
        height : 554
        KeyNavigation.left : idDabInfoEPGMainLeft
        KeyNavigation.up: idDabInfoEPGBand
        onActiveFocusChanged: {
            // console.log("[QML] DABInfoEPGContents.qml : idDabInfoEPGMainRight - onActiveFocusChanged ")
            if(idDabInfoEPGMainRight.activeFocus){
                epgFocusPosition = "SettingContents"
                if(changeEPGChannelTimer.running == true ) {
                    epgChannelTimerRunning = true;
                }
            }
        }
    }

    Image {
        id: idEPGRightBgImg
        x: 585; y: systemInfo.titleAreaHeight;
        source: epgFocusPosition == "SettingContents" ? imageInfo.imgBgMenu_R_S : ""
    }

    DABInfoEPGMainLeft {
        id: idDabInfoEPGMainLeft
        x: 0; y: systemInfo.titleAreaHeight;
        width: 695; height: 554
        focus: true
        KeyNavigation.right: idDabInfoEPGMainRight.listCountZeroCheck() == true ? idDabInfoEPGMainLeft : idDabInfoEPGMainRight
        KeyNavigation.up: idDabInfoEPGBand
        onActiveFocusChanged: {
            if(idDabInfoEPGMainLeft.activeFocus) epgFocusPosition = "ServiceList"
        }
    }

    MComp.MVisualCue{
        id: idMVisualCue
        x: 560; y: 358-systemInfo.statusBarHeight
        arrowUpFlag : idDabInfoEPGBand.activeFocus ? false : true
        arrowDownFlag : idDabInfoEPGBand.activeFocus ? (idDabInfoEPGMainLeft.listCountZeroCheck() == true) ? false : true : false
        arrowLeftFlag : (idDabInfoEPGMainRight.activeFocus) ? true : false
        arrowRightFlag : (idDabInfoEPGMainLeft.activeFocus) ? idDabInfoEPGMainRight.listCountZeroCheck() == true ? false : true : false
    }

    Timer {
        id: changeEPGChannelTimer
        interval: 250
        running: false
        repeat: false
        onTriggered: changeEPGChannelListFast()
    }

    function stopEPGChannelTimer()
    {
        console.log("[QML] DABInfoEPGMain.qml :: stopEPGChannelTimer :: changeEPGChannelTimer.running = " + changeEPGChannelTimer.running);
        if(changeEPGChannelTimer.running == true)
            changeEPGChannelTimer.stop();
    }

    function changeEPGChannelListFast()
    {
        console.log("[QML] DABInfoEPGMain.qml :: changeEPGChannelListFast :: changeEPGChannelTimer.running = " + changeEPGChannelTimer.running);
        if(changeEPGChannelTimer.running == true)
        {
            changeEPGChannelTimer.stop();
            idDabInfoEPGMainLeft.screenChangedListMove();
        }
    }

    onBackKeyPressed: {
        console.log("[QML] DABInfoEPGMain.qml : onBackKeyPressed")
        gotoBackScreen();
    }

    onSeekPrevKeyReleased : {
        console.log("[QML] DABInfoEPGMain.qml : onSeekPrevKeyReleased")
        gotoMainScreen()
    }

    onSeekNextKeyReleased : {
        console.log("[QML] DABInfoEPGMain.qml : onSeekNextKeyReleased")
        gotoMainScreen()
    }

    onSeekPrevLongKeyPressedChanged: {
        console.log("[QML] DABInfoEPGMain.qml : onSeekPrevLongKeyPressedChanged :: visible = " + idDabInfoEPGMain.visible)
        if(idDabInfoEPGMain.visible)
            gotoMainScreen()
    }

    onSeekNextLongKeyPressedChanged: {
        console.log("[QML] DABInfoEPGMain.qml : onSeekNextLongKeyPressedChanged :: visible = " + idDabInfoEPGMain.visible)
        if(idDabInfoEPGMain.visible)
            gotoMainScreen()
    }

    onVisibleChanged: {
        console.log("[QML] DABInfoEPGMain.qml : onVisibleChanged :: visible = " + idDabInfoEPGMain.visible)
        if(idDabInfoEPGMainLeft.listCountZeroCheck() == true) idDabInfoEPGBand.focus = true;
        else idDabInfoEPGMainLeft.focus = true

        if(!idDabInfoEPGMain.visible)
        {
            stopEPGChannelTimer();
        }
    }

    Connections {
        target : idAppMain
        onReqEPGListBySelectDate :{
            console.log("[QML] DABInfoEPGMain.qml : Connections => onReqEPGListBySelectDate:")
            leftSelectedIndex = 0;
            ensembleNameCount = 0;
            idServiceNameListModel.clear();
            idEPGListModel.clear();
            m_xCurrentDate = selectDate
            DABListener.getCurrentServiceEPGList(selectDate);
        }
    }

    Connections {
        target : DABController
        onLoadEPGListBySelect :{
            console.log("[QML] DABInfoEPGMain.qml : Connections => onLoadEPGListBySelect: visible = " + visible)
            if(visible)
            {
                if(isEpgPopupExist()){
                    initialize()
                    if(idDabInfoEPGMain.isExist)
                    {
                        idDabInfoEPGMain.focus = true;
                        idDabInfoEPGMainLeft.focus = true;
                        idDabInfoEPGMainLeft.forceActiveFocus()
                    }
                    else
                    {
                        idDabInfoEPGBand.focus = true;
                        idDabInfoEPGBand.forceActiveFocus()
                    }
                }
            }
        }
    }

    function focusPositionSetting(){
        if(idAppMain.state == "DabInfoEPGMain"){
            if(idDabInfoEPGMainLeft.listCountZeroCheck() == true) idDabInfoEPGBand.focus = true;
            else {
                 idDabInfoEPGMainLeft.focus = true;
            }
        }
    }

    function initialize()
    {
        console.log("[QML] DABInfoEPGMain.qml : initialize")
        leftSelectedIndex = 0;
        ensembleNameCount = 0;
        idServiceNameListModel.clear();
        idEPGListModel.clear();
        DABListener.getCurrentServiceEPGList(todayDate());
    }

    function todayDate()
    {
        console.log("[QML] DABInfoEPGBand.qml : todayDate")
        var today = new Date();
        var day = Qt.formatDate(today, "dd")
        var month = Qt.formatDate(today, "MM")
        var year = Qt.formatDate(today, "yy")
        var dayName = Qt.formatDate(today, "ddd")

        m_sSelectEPGDate = day + "-" + month + "-" + year + ", " + dayName
        m_xCurrentDate = today;
        return today;
    }

    function isEpgPopupExist()
    {
        if(idDabInfoEPGDateListPopup.visible || idDabInfoEPGDescPopup.visible
          || idDabInfoEPGPreservePopup.visible || idDabInfoEPGPreserveFullPopup.visible)
            return false;
        return true;
    }
}
