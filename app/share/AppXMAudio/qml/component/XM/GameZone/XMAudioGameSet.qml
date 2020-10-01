/**
 * FileName: XMAudioGameSet.qml
 * Author: HYANG
 * Time: 2013-06-16
 *
 * - 2013-06-16 Initial Created by HYANG
 */

import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MComponent {
    id: idRadioGameSetQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    //************************************************************************* # Property, State #
    state: (idAppMain.gDriverRestriction == false) ? "SETTEAM" : "SETTEAMDRIVERRESTRICTION"

    property string sxm_setteam_curlist : "left" //"right"
    property string sxm_setteam_curleague : "NFL"
    property string sxm_setteam_curteam : ""
    property int    sxm_setteam_leagueindex : 0
    property int    sxm_setteam_teamindex : 0
    property bool   sxm_setteam_teamcheck : false
    property bool   sxm_setteam_leaguealert : false
    property bool   sxm_setteam_alert : false
    property Item topBand: idRadioGameSetBand

    property string gameAlertMemoryUseColor: colorInfo.blue

    //****************************** # SXM Radio - Title area #
    MComp.MBigBand {
        id: idRadioGameSetBand
        x: 0; y: 0

        //****************************** # Tab button OFF #
        tabBtnFlag: true
        tabBtnCount: 3
        tabBtnText: stringInfo.sSTR_XMRADIO_LIVE
        tabBtnText2: stringInfo.sSTR_XMRADIO_SET_TEAM
        tabBtnText3: stringInfo.sSTR_XMRADIO_ACTIVE
        selectedBand: stringInfo.sSTR_XMRADIO_SET_TEAM
        tabBtnSendTextSize: XMOperation.checkFranceLanguage();

        reserveBtnFlag: true
        reserveBtnText: stringInfo.sSTR_XMRADIO_ALERT
        alertBtnFlag: true
        reserveBtnFgImage: sxm_setteam_alert ? imageInfo.imgFolderGeneral+"checkbox_check.png" : imageInfo.imgFolderGeneral+"checkbox_uncheck.png"
        reserveBtnFgImagePress: sxm_setteam_alert ? imageInfo.imgFolderGeneral+"checkbox_check.png" : imageInfo.imgFolderGeneral+"checkbox_uncheck.png"

        Text {
            id: idGameAlertMemoryUse
            text: ""
            x: 828; y: 18
            width: 95; height: 30
            font.pixelSize: 30
            font.family : systemInfo.font_NewHDB
            lineHeight: 0.75
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: gameAlertMemoryUseColor
            visible: true
        }

        //****************************** # button clicked or key selected #
        onTabBtn1Clicked: {
            stopGameSetLeagueListTimerOnly();
            giveForceFocus(2);
            setAppMainScreen("AppRadioGameZone", false);
        }
        onTabBtn2Clicked: {
            giveForceFocus(2);
        }
        onTabBtn3Clicked: {
            stopGameSetLeagueListTimerOnly();
            giveForceFocus(2);
            setAppMainScreen("AppRadioGameActive", false);
        }

        onReserveBtnClicked: {
            if(sxm_setteam_alert == true)
            {
                sxm_setteam_alert = false
                SPSeek.handleSetGameOnOff(false);
            }
            else
            {
                sxm_setteam_alert = true
                SPSeek.handleSetGameOnOff(true);
            }
        }

        onBackBtnClicked: {
            giveForceFocus(2);
            setGameSetClose();
            setAppMainScreen( "AppRadioMain" , false);
        }

        Keys.onPressed: {
            if(event.key == Qt.Key_Down)
            {
                if(idAppMain.gDriverRestriction == true)
                {
                    idRadioGameSetBand.focus = true;
                }
                else
                {
                    if((idRadioGameSetLeagueList.setTeamLeagueListCount == 0) && (idRadioGameSetTeamList.setTeamTeamListCount == 0))
                        idRadioGameSetBand.focus = true;
                    else
                        changeFocusToTeamList();
                }
            }
        }
    }

    function resetGameMemoryUse()
    {
        idGameAlertMemoryUse.text = "";
        idGameAlertMemoryUse.text += SPSeek.handleGetGameAlertCount() + "/50";
    }

    //****************************** # SXM Radio - Display Area #
    MComp.MComponent{
        id: idRadioGameSetAlertDisplay
        focus: true

        //****************************** # Background Image #
        Image{
            x: 0; y: systemInfo.titleAreaHeight; z: 0
            visible: true
            Image{
                source: imageInfo.imgFolderGeneral+"bg_menu_l.png"
                visible: (sxm_setteam_curlist == "left") ? true : false
            }
            Image {
                source: imageInfo.imgFolderGeneral+"bg_menu_r.png"
                visible: (sxm_setteam_curlist == "left") ? false : true
            }
        }
        Image{
            x: 0; y: systemInfo.titleAreaHeight; z: 0
            visible : true
            Image{
                x: 0; y: 0; z:1
                source: imageInfo.imgFolderGeneral+"bg_menu_l_s.png"
                visible: (sxm_setteam_curlist == "left") ? true : false
            }
            Image {
                x:585; y:0; z:5
                source: imageInfo.imgFolderGeneral+"bg_menu_r_s.png"
                visible: (sxm_setteam_curlist == "left") ? false : true
            }
        }

        //****************************** # League List #
        XMAudioGameSetLeagueList{
            id: idRadioGameSetLeagueList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9
            width: 585; height: systemInfo.contentAreaHeight-20
            focus: true

            Keys.onPressed: {
                if(event.key == Qt.Key_Right)
                {
                    if(idRadioGameSetTeamList.setTeamTeamListCount > 0)
                    {
                        if(idRadioGameSetLeagueList.movementStartedSetTeamLeagueFlag == true)
                            idRadioGameSetLeagueList.movementStartedSetTeamLeagueFlag = false;

                        stopGameSetLeagueListTimer();
                    }
                    else
                    {
                        idRadioGameSetAlertDisplay.focus = true;
                        idRadioGameSetTeamList.focus = true;
                    }
                }
            }
            onActiveFocusChanged: { if(idRadioGameSetLeagueList.activeFocus) sxm_setteam_curlist = "left"; }
        }

        //****************************** # Team List #
        XMAudioGameSetTeamList {
            id: idRadioGameSetTeamList
            x: 698; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9
            width: systemInfo.lcdWidth-698; height: systemInfo.contentAreaHeight-20

            KeyNavigation.left: idRadioGameSetLeagueList
            onActiveFocusChanged: { if(idRadioGameSetTeamList.activeFocus) sxm_setteam_curlist = "right"; }
        }

        //****************************** # Visual Cue - list #
        MComp.MVisualCue{
            id: idMVisualCue
            x: 560; y: 357-systemInfo.statusBarHeight; z: 10
            arrowUpFlag: idRadioGameSetLeagueList.activeFocus || idRadioGameSetTeamList.activeFocus ? true:false
            arrowDownFlag: idRadioGameSetBand.activeFocus ? (idRadioGameSetLeagueList.setTeamLeagueListCount == 0) ? false : true : false
            arrowRightFlag: idRadioGameSetLeagueList.activeFocus ? (idRadioGameSetTeamList.setTeamTeamListCount == 0) ? false : true : false
            arrowLeftFlag: idRadioGameSetTeamList.activeFocus ? true:false
        }
    }

    MComp.MComponent{
        id: idRadioGameSetDriverRestrictionDisplay

        //Driver Restriction
        XMAudioGameSetDriverRestriction {
            id: idRadioGameSetDriverRestrictionList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
        }
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        setGameSetClose();
        setAppMainScreen( "AppRadioMain" , false);
    }
    /* CCP Home Key */
    onHomeKeyPressed: {
        setGameSetClose();
        UIListener.HandleHomeKey();
    }

    onVisibleChanged: {
        if(visible)
        {
            if(idAppMain.gDriverRestriction == true)
            {
                idRadioGameSetBand.giveForceFocus(2);
                idRadioGameSetBand.focus = true;
            }
            else
            {
                idRadioGameSetBand.tabBtnSendTextSize = XMOperation.checkFranceLanguage();

                if((idRadioGameSetLeagueList.setTeamLeagueListCount == 0) && (idRadioGameSetTeamList.setTeamTeamListCount == 0))
                {
                    idRadioGameSetBand.focus = true;
                }
                else
                {
                    resetGameMemoryUse();
                    sxm_setteam_leagueindex = 0;
                    changeSetTeamLeague(sxm_setteam_leagueindex);
                    idRadioGameSetLeagueList.aSETTEAMLeagueListModel.currentIndex = 0;
                    idRadioGameSetLeagueList.aSETTEAMLeagueListModel.positionViewAtIndex(0, ListView.Beginning);
                    idRadioGameSetAlertDisplay.focus = true
                    idRadioGameSetLeagueList.focus = true
                }
            }
        }
    }

    onStateChanged: {
        if(!visible) return;

        if(idAppMain.gDriverRestriction == true)
        {
            if(!idRadioGameSetBand.activeFocus)
                idRadioGameSetBand.giveForceFocus(7);
            idRadioGameSetBand.focus = true;
        }
    }

    Connections{
        target: UIListener
        onGameZoneMemoryUse: {
            resetGameMemoryUse();
        }
    }

    //****************************** # Function #
    function setGameSetClose()
    {
        idRadioGameSet.visible = false;
        idRadioGameSetLeagueList.stopSetTeamLeagueTimer();
        UIListener.HandleSetTuneKnobKeyOperation(0);
        UIListener.HandleSetSeekTrackKeyOperation(0);
    }

    function stopGameSetLeagueListTimer()
    {
        idRadioGameSetLeagueList.stopSetTeamLeagueTimer();
        if(idRadioGameSetLeagueList.aSETTEAMLeagueListModel.currentIndex != sxm_setteam_leagueindex)
        {
            sxm_setteam_leagueindex = idRadioGameSetLeagueList.aSETTEAMLeagueListModel.currentIndex;
            changeSetTeamLeague(sxm_setteam_leagueindex);
        }
        changeFocusToTeamList();
    }

    function stopGameSetLeagueListTimerOnly()
    {
        idRadioGameSetLeagueList.stopSetTeamLeagueTimer();
    }

    function changeSetTeamLeague(idxLeague)
    {
        sxm_setteam_leagueindex = idxLeague;
        sxm_setteam_teamindex = 0;
        idRadioGameSetTeamList.setLeagueChanged(idxLeague);
        changeFocusToTeamListReset();
    }

    function changeFocusToTeamListReset()
    {
        idRadioGameSetTeamList.onSetTeamTeamInitPos(true);
    }

    function changeFocusToTeamList()
    {
        if((idRadioGameSetLeagueList.setTeamLeagueListCount == 0) && (idRadioGameSetTeamList.setTeamTeamListCount == 0))
        {
            idRadioGameSetBand.focus = true;
        }
        else
        {
            if(idRadioGameSetTeamList.setTeamTeamListCount > 0)
            {
                idRadioGameSetTeamList.onSetTeamTeamPosUpdate();

                idRadioGameSetAlertDisplay.focus = true;
                idRadioGameSetTeamList.forceActiveFocus();
            }
            else
            {
                idRadioGameSetAlertDisplay.focus = true;
                idRadioGameSetLeagueList.forceActiveFocus();
            }
        }
    }

    function onSetGameAlert(bStatus)
    {
        sxm_setteam_alert = bStatus;
    }

    //************************************************************************* # Timer #
    Timer {
        id: changeSetTeamLeagueTimer
        interval: 250
        running: false
        repeat: false
        onTriggered: idRadioGameSetLeagueList.changeSetTeamLeagueList();
    }
    
    states: [
        State{
            name: "SETTEAM"
            PropertyChanges{target: idRadioGameSetDriverRestrictionDisplay; opacity: 0;}
            PropertyChanges{target: idRadioGameSetAlertDisplay; opacity: 1;}
        },
        State{
            name: "SETTEAMDRIVERRESTRICTION"
            PropertyChanges{target: idRadioGameSetAlertDisplay; opacity: 0;}
            PropertyChanges{target: idRadioGameSetDriverRestrictionDisplay; opacity: 1;}
        }
    ]

    transitions: [
        Transition{
            ParallelAnimation{ PropertyAnimation{properties: "opacity"; duration: 0; easing.type: "InCubic"} }
        }
    ]
}
