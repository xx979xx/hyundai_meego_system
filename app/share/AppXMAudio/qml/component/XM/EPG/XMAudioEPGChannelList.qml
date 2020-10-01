/**
 * FileName: RadioPresetList.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../XM/Delegate" as XMMComp

FocusScope {
    id: idRadioEPGChannelList
    x: 0; y: 0

    //****************************** # Preperty #
    property alias aEPGChannelListModel : idEPGChannelListView
    property alias aEPGChannelListCount : idEPGChannelListView.count
    property int overEPGChannelContentCount: 0
    property bool movementStartedEPGChannelFlag: false;

    property string channelListModelTextColor: colorInfo.brightGrey
    
    //****************************** # CategoryList ListView #
    MComp.MListView{
        id: idEPGChannelListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: CHANNELList

        delegate: XMMComp.MEPGLeftDelegate{
            id: idMEPGLeftDelegate

            mChListFirstText: ChnNum
            mChListSecondText: ChnName
            mChListThirdText: ChnSubscribed
        }

        onContentYChanged: { overEPGChannelContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedEPGChannelFlag = false;
            if(!visible)
                stopEPGChannelTimer();
        }
        onMovementStarted: { movementStartedEPGChannelFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idEPGChannelListView.visible && movementStartedEPGChannelFlag)
                {
                    if((gSXMEPGMode == "PROGRAM") && (idAppMain.state == "AppRadioEPG") && (aEPGChannelListModel.count > 0))
                    {
                        changeEPGChannelList(aEPGChannelListModel.currentIndex);
                        idRadioEPGChannelList.forceActiveFocus();
                    }

                    movementStartedEPGChannelFlag = false;
                }
            }
        }

        onUpKeyLongListUp: {
            if(aEPGChannelListModel.count == 0) return;
            if(aEPGChannelListModel.currentIndex > 0) onEPGChannelListLeft(aEPGChannelListModel.currentIndex)
        }
        onDownKeyLongListDown: {
            if(aEPGChannelListModel.count == 0) return;
            if(aEPGChannelListModel.currentIndex < (aEPGChannelListModel.count - 1)) onEPGChannelListRight(aEPGChannelListModel.currentIndex)
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
        moveBarPosition: getEPGChannelMoveBarPosition()
        listCount: aEPGChannelListModel.count
        visible: (aEPGChannelListModel.count > 6)
    }

    function getEPGChannelMoveBarPosition()
    {
        var posionValue;
        var moveBarHeightTemp;
        moveBarHeightTemp = (idMRoundScroll.scrollHeight / idMRoundScroll.listCount) * idMRoundScroll.listCountOfScreen;

        if( moveBarHeightTemp < 40)
            posionValue = (491/aEPGChannelListModel.count * 0.91998)*overEPGChannelContentCount;
        else
            posionValue = (491/aEPGChannelListModel.count * 0.97298)*overEPGChannelContentCount;

        return posionValue;
    }

    // "No Channels are in this category" Text Display
    Text {
        id: aEPGChannelListModelText
        x: 43; y: 412-166+25-10-(font.pixelSize/2)
        width: 490; height: 32
        text : stringInfo.sSTR_XMRADIO_NO_CHANNEL_AVAIBLE
        font.pixelSize: 32
        font.family : systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: channelListModelTextColor
        wrapMode: Text.WordWrap
        visible: (aEPGChannelListModel.count == 0) ? true : false
    }

    function onEPGChannelListLeft(currIndex)
    {
        if(aEPGChannelListModel.flicking || aEPGChannelListModel.moving)   return;
        if((aEPGChannelListModel.currentIndex == 0) && aEPGChannelListModel.count<7)
            return;

        var nNextIndex = currIndex - 1;
        if(nNextIndex<0) nNextIndex = aEPGChannelListModel.count-1;

        aEPGChannelListModel.currentIndex = nNextIndex;
        changeEPGChannelTimer.restart();
        if(aEPGChannelListModel.currentIndex<overEPGChannelContentCount)
        {
            var n = (aEPGChannelListModel.currentIndex - (6-((overEPGChannelContentCount-aEPGChannelListModel.currentIndex)%6)));
            aEPGChannelListModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aEPGChannelListModel.positionViewAtIndex((aEPGChannelListModel.currentIndex - (aEPGChannelListModel.currentIndex-overEPGChannelContentCount)%6), ListView.Beginning);
        }
    }

    function onEPGChannelListRight(currIndex)
    {
        if(aEPGChannelListModel.flicking || aEPGChannelListModel.moving)   return;
        if((aEPGChannelListModel.currentIndex == (aEPGChannelListModel.count-1)) && aEPGChannelListModel.count<7)
            return;

        var nNextIndex = currIndex + 1;
        if(nNextIndex >= aEPGChannelListModel.count) nNextIndex = 0;

        aEPGChannelListModel.currentIndex = nNextIndex;
        changeEPGChannelTimer.restart();
        if(aEPGChannelListModel.currentIndex<overEPGChannelContentCount)
        {
            aEPGChannelListModel.positionViewAtIndex((aEPGChannelListModel.currentIndex - (aEPGChannelListModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aEPGChannelListModel.positionViewAtIndex((aEPGChannelListModel.currentIndex - (aEPGChannelListModel.currentIndex-overEPGChannelContentCount)%6), ListView.Beginning);
        }
    }

    function stopEPGChannelTimer()
    {
        if(changeEPGChannelTimer.running == true)
            changeEPGChannelTimer.stop();
    }

    function changeEPGChannelListFast()
    {
        if(changeEPGChannelTimer.running == true)
        {
            changeEPGChannelTimer.stop();
            changeEPGChannelList(aEPGChannelListModel.currentIndex);
        }
    }

    function isEPGChannelListUpdatting()
    {
        console.log("[QML]XMAudioEPGChannelList::isEPGChannelListUpdatting() :: changeEPGChannelTimer.running="+ changeEPGChannelTimer.running+" idEPGChannelListView.moving="+idEPGChannelListView.moving+" idEPGChannelListView.flicking="+ idEPGChannelListView.flicking )
        if(changeEPGChannelTimer.running == true || idEPGChannelListView.moving == true || idEPGChannelListView.flicking == true)
        {
            idRadioEPGQml.epglistMovingState = true;
        }
        else
        {
            idRadioEPGQml.epglistMovingState = false;
        }
    }

    function setEPGCurrentChannelListIndex(selected)
    {
        aEPGChannelListModel.currentIndex = sxm_epg_chnindex;
        if(selected)
            aEPGChannelListModel.positionViewAtIndex(sxm_epg_chnindex, ListView.Center);
    }
}
