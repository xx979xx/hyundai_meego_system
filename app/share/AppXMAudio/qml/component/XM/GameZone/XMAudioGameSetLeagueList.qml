/**
 * FileName: XMAudioGameSetLeagueList.qml
 * Author: HYANG
 * Time: 2013-06-16
 *
 * - 2013-06-16 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../XM/Delegate" as XMMComp

FocusScope {
    id: idRadioGameSetLeagueList
    x: 0; y: 0

    //****************************** # Preperty #
    property alias aSETTEAMLeagueListModel: idSETTEAMLeagueListView
    property int setTeamLeagueListCount: idSETTEAMLeagueListView.count
    property int overSetTeamLeagueContentCount: 0
    property bool movementStartedSetTeamLeagueFlag: false

    //****************************** # CategoryList ListView #
    MComp.MListView{
        id: idSETTEAMLeagueListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        //cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: GAMELEAGUEList
        delegate: XMMComp.MSetTeamLeftDelegate{
            id: idMSetTeamLeftDelegate

            mChListFirstText: GameLeagueSName
            bChListSecondText: GameLeagueAlert
        }

        onContentYChanged: { overSetTeamLeagueContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedSetTeamLeagueFlag = false;
            if(!visible)
                stopSetTeamLeagueTimer();
        }
        onMovementStarted: { movementStartedSetTeamLeagueFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idSETTEAMLeagueListView.visible && movementStartedSetTeamLeagueFlag)
                {
                    if ((idAppMain.state == "AppRadioGameSet") && (idRadioGameSetLeagueList.setTeamLeagueListCount > 0))
                    {
                        changeSetTeamLeague(aSETTEAMLeagueListModel.currentIndex);
                        idRadioGameSetLeagueList.forceActiveFocus();
                    }

                    movementStartedSetTeamLeagueFlag = false;
                }
            }
        }

        onUpKeyLongListUp: {
            if(aSETTEAMLeagueListModel.count == 0) return;
            if(aSETTEAMLeagueListModel.currentIndex > 0) onSETTEAMLeagueListLeft(aSETTEAMLeagueListModel.currentIndex)
        }
        onDownKeyLongListDown: {
            if(aSETTEAMLeagueListModel.count == 0) return;
            if(aSETTEAMLeagueListModel.currentIndex < (aSETTEAMLeagueListModel.count - 1)) onSETTEAMLeagueListRight(aSETTEAMLeagueListModel.currentIndex)
        }
    }

    //************************ Round Scroll ***//
    MComp.MRoundScroll{
        id: idMRoundScroll
        x: 582
        y: 196 - systemInfo.headlineHeight
        scrollWidth: 46
        scrollHeight: 491
        listCountOfScreen: 6
        moveBarPosition: getGameSetMoveBarPosition()
        listCount: aSETTEAMLeagueListModel.count
        visible: (aSETTEAMLeagueListModel.count > 6)
    }

    function getGameSetMoveBarPosition()
    {
        var posionValue;
        var moveBarHeightTemp;
        moveBarHeightTemp = (idMRoundScroll.scrollHeight / idMRoundScroll.listCount) * idMRoundScroll.listCountOfScreen;

        if( moveBarHeightTemp < 40)
            posionValue = (491/aSETTEAMLeagueListModel.count * 0.91998)*overSetTeamLeagueContentCount;
        else
            posionValue = (491/aSETTEAMLeagueListModel.count * 0.97298)*overSetTeamLeagueContentCount;

        return posionValue;
    }

    function onSetTeamPosUpdate(currIndex)
    {
        if(aSETTEAMLeagueListModel.count == 0) return;

        aSETTEAMLeagueListModel.currentIndex = currIndex;
        if(aSETTEAMLeagueListModel.currentIndex<overSetTeamLeagueContentCount)
            aSETTEAMLeagueListModel.positionViewAtIndex((aSETTEAMLeagueListModel.currentIndex - (aSETTEAMLeagueListModel.currentIndex%6)), ListView.Beginning);
        else
            aSETTEAMLeagueListModel.positionViewAtIndex((aSETTEAMLeagueListModel.currentIndex - (aSETTEAMLeagueListModel.currentIndex-overSetTeamLeagueContentCount)%6), ListView.Beginning);
    }

    function onSETTEAMLeagueListLeft(currIndex)
    {
        if(aSETTEAMLeagueListModel.flicking || aSETTEAMLeagueListModel.moving)   return;
        if((aSETTEAMLeagueListModel.currentIndex == 0) && aSETTEAMLeagueListModel.count<7)
            return;

        var nNextIndex = currIndex - 1;
        if(nNextIndex<0) nNextIndex = aSETTEAMLeagueListModel.count-1;

        aSETTEAMLeagueListModel.currentIndex = nNextIndex;
        changeSetTeamLeagueTimer.restart();
        if(aSETTEAMLeagueListModel.currentIndex<overSetTeamLeagueContentCount)
        {
            var n = (aSETTEAMLeagueListModel.currentIndex - (6-((overSetTeamLeagueContentCount-aSETTEAMLeagueListModel.currentIndex)%6)));
            aSETTEAMLeagueListModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aSETTEAMLeagueListModel.positionViewAtIndex((aSETTEAMLeagueListModel.currentIndex - (aSETTEAMLeagueListModel.currentIndex-overSetTeamLeagueContentCount)%6), ListView.Beginning);
        }
    }

    function onSETTEAMLeagueListRight(currIndex)
    {
        if(aSETTEAMLeagueListModel.flicking || aSETTEAMLeagueListModel.moving)   return;
        if((aSETTEAMLeagueListModel.currentIndex == (aSETTEAMLeagueListModel.count-1)) && aSETTEAMLeagueListModel.count<7)
            return;

        var nNextIndex = currIndex + 1;
        if(nNextIndex >= aSETTEAMLeagueListModel.count) nNextIndex = 0;

        aSETTEAMLeagueListModel.currentIndex = nNextIndex;
        changeSetTeamLeagueTimer.restart();
        if(aSETTEAMLeagueListModel.currentIndex<overSetTeamLeagueContentCount)
        {
            aSETTEAMLeagueListModel.positionViewAtIndex((aSETTEAMLeagueListModel.currentIndex - (aSETTEAMLeagueListModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aSETTEAMLeagueListModel.positionViewAtIndex((aSETTEAMLeagueListModel.currentIndex - (aSETTEAMLeagueListModel.currentIndex-overSetTeamLeagueContentCount)%6), ListView.Beginning);
        }
    }

    function stopSetTeamLeagueTimer()
    {
        if(changeSetTeamLeagueTimer.running == true)
            changeSetTeamLeagueTimer.stop();
    }

    function changeSetTeamLeagueList()
    {
        if(changeSetTeamLeagueTimer.running == true)
        {
            changeSetTeamLeagueTimer.stop();
            changeSetTeamLeague(aSETTEAMLeagueListModel.currentIndex);
        }
    }
}
