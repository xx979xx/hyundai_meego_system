/**
 * FileName: XMAudioGameSetTeamList.qml
 * Author: HYANG
 * Time: 2013-06-16
 *
 * - 2013-06-16 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../XM/Delegate" as XMMComp

FocusScope {
    id: idRadioGameSetTeamList
    x: 0; y: 0

    //****************************** # Preperty #
    property alias aSETTEAMTeamListModel: idSETTEAMTeamListView
    property int setTeamTeamListCount: idSETTEAMTeamListView.count
    property int overSetTeamTeamContentCount: 0
    property bool movementStartedSetTeamTeamFlag: false

    property int scrollEndDifX: 28
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13

    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idSETTEAMTeamListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: GAMETEAMList
        delegate: XMMComp.MSetTeamRightDelegate{
            id: idMSetTeamRightDelegate

            mChListFirstText: GameTeamName + " " + GameTeamNickName
            bChListSecondText: GameTeamCheck

            onClickOrKeySelected: {
                gTeamIndex =  sxm_setteam_teamindex
                console.log("### gTeamIndex Item click ###", gTeamIndex);

                if(SPSeek.handleGetGameTeamCheck(index) == true)
                    SPSeek.handleGameTeamCheck(index, false);
                else
                {
                    if(SPSeek.handleGetGameAlertCount() >= 50)
                    {
                        setAppMainScreen("PopupRadioWarning2Line", true);
                        idRadioPopupWarning2Line.item.onPopupWarning2LineFirst(stringInfo.sSTR_XMRADIO_ALERT_MEMORY_FULL);
                        idRadioPopupWarning2Line.item.onPopupWarning2LineSecond(stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_FULL2);
                        idRadioPopupWarning2Line.item.onPopupWarning2LineWrap(true);
                    }
                    else
                    {
                        SPSeek.handleGameTeamCheck(index, true);
                    }
                }

                resetGameMemoryUse();
            }
        }

        onContentYChanged: { overSetTeamTeamContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedSetTeamTeamFlag = false;
        }
        onMovementStarted: { movementStartedSetTeamTeamFlag = true; }
        onMovementEnded:{
            if(isSuppportAutoFocusByScroll)
            {
                if(idSETTEAMTeamListView.visible && movementStartedSetTeamTeamFlag)
                {
                    if((idAppMain.state == "AppRadioGameSet") && (idRadioGameSetTeamList.setTeamTeamListCount > 0))
                    {
                        if(changeSetTeamLeagueTimer.running == false)
                        {
                            idRadioGameSetAlertDisplay.focus = true;
                            idRadioGameSetTeamList.focus = true;
                        }
                    }

                    movementStartedSetTeamTeamFlag = false;
                }
            }
        }
    }

    //************************ Scroll Bar ***//
    MComp.MScroll {
        id: idGameSetTeamScroll
        scrollArea: aSETTEAMTeamListModel;
        x: 1280 - 698 - scrollEndDifX; y: aSETTEAMTeamListModel.y + scrollY; z:1
        width: scrollWidth; height: (aSETTEAMTeamListModel.height + 20) - scrollY - scrollEndDifY
        visible: aSETTEAMTeamListModel.count > 6
    }

    function onSETEAMTeamListLeft(currIndex)
    {
        if(aSETTEAMTeamListModel.flicking || aSETTEAMTeamListModel.moving)   return;
        if((aSETTEAMTeamListModel.currentIndex == 0) && aSETTEAMTeamListModel.count<7)
            return;

        var nNextIndex = currIndex - 1;
        if(nNextIndex<0) nNextIndex = aSETTEAMTeamListModel.count-1;

        aSETTEAMTeamListModel.currentIndex = nNextIndex;
        if(aSETTEAMTeamListModel.currentIndex<overSetTeamTeamContentCount)
        {
            var n = (aSETTEAMTeamListModel.currentIndex - (6-((overSetTeamTeamContentCount-aSETTEAMTeamListModel.currentIndex)%6)));
            aSETTEAMTeamListModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aSETTEAMTeamListModel.positionViewAtIndex((aSETTEAMTeamListModel.currentIndex - (aSETTEAMTeamListModel.currentIndex-overSetTeamTeamContentCount)%6), ListView.Beginning);
        }
    }

    function onSETTEAMTeamListRight(currIndex)
    {
        if(aSETTEAMTeamListModel.flicking || aSETTEAMTeamListModel.moving)   return;
        if((aSETTEAMTeamListModel.currentIndex == (aSETTEAMTeamListModel.count-1)) && aSETTEAMTeamListModel.count<7)
            return;

        var nNextIndex = currIndex + 1;
        if(nNextIndex >= aSETTEAMTeamListModel.count) nNextIndex = 0;

        aSETTEAMTeamListModel.currentIndex = nNextIndex;
        if(aSETTEAMTeamListModel.currentIndex<overSetTeamTeamContentCount)
        {
            aSETTEAMTeamListModel.positionViewAtIndex((aSETTEAMTeamListModel.currentIndex - (aSETTEAMTeamListModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aSETTEAMTeamListModel.positionViewAtIndex((aSETTEAMTeamListModel.currentIndex - (aSETTEAMTeamListModel.currentIndex-overSetTeamTeamContentCount)%6), ListView.Beginning);
        }
    }

    function setLeagueChanged(idxLeague)
    {
        SPSeek.handleGameLeagueIndexToTeamList(idxLeague);
        if(aSETTEAMTeamListModel.count > 0)
            aSETTEAMTeamListModel.currentIndex = 0;
    }

    function onSetTeamTeamInitPos(toTop)
    {
        if(toTop == true)
        {
            onSetTeamTeamPosUpdateIndex(0);
            return;
        }
    }

    function onSetTeamTeamPosUpdateIndex(currIndex)
    {
        if(aSETTEAMTeamListModel.count == 0) return;

        aSETTEAMTeamListModel.currentIndex = currIndex;

        if(aSETTEAMTeamListModel.currentIndex < overSetTeamTeamContentCount)
        {
            aSETTEAMTeamListModel.positionViewAtIndex((aSETTEAMTeamListModel.currentIndex - (aSETTEAMTeamListModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aSETTEAMTeamListModel.positionViewAtIndex((aSETTEAMTeamListModel.currentIndex - (aSETTEAMTeamListModel.currentIndex - overSetTeamTeamContentCount)%6), ListView.Beginning);
        }
    }

    function onSetTeamTeamPosUpdate()
    {
        if(aSETTEAMTeamListModel.count == 0) return;

        var nCurrentIndex = 0;
        if(aSETTEAMTeamListModel.currentIndex < 0)
        {
            nCurrentIndex = 0;
            aSETTEAMTeamListModel.currentIndex = nCurrentIndex;
        }
        if(aSETTEAMTeamListModel.currentIndex >= aSETTEAMTeamListModel.count)
        {
            nCurrentIndex = aSETTEAMTeamListModel.count-1;
            aSETTEAMTeamListModel.currentIndex = nCurrentIndex;
        }

        if(aSETTEAMTeamListModel.currentIndex < overSetTeamTeamContentCount)
        {
            aSETTEAMTeamListModel.positionViewAtIndex((aSETTEAMTeamListModel.currentIndex - (aSETTEAMTeamListModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aSETTEAMTeamListModel.positionViewAtIndex((aSETTEAMTeamListModel.currentIndex - (aSETTEAMTeamListModel.currentIndex - overSetTeamTeamContentCount)%6), ListView.Beginning);
        }
    }
}
