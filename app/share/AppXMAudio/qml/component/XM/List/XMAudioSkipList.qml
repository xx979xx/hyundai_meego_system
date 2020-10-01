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
    id: idRadioSkipListQml
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.contentAreaHeight
    focus : true

    //****************************** # Preperty #
    property alias aLISTSkipListModel: idLISTSkipListView
    property int listSkipListCount: idLISTSkipListView.count
    property int overListSkipContentCount: 0
    property bool movementStartedListSkipFlag: false
    property bool clickOrKeySelectedFlag: false

    property int scrollEndDifX: 23
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13
    property int selectedSkipItem: 0

    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idLISTSkipListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: CHANNELList

        delegate: XMMComp.MSkipDelegate{
            id: idMSkipDelegate

            mChListFirstText : ChnNum
            mChListSecondText : ChnName
            bChListThirdText : ChnSkip

            onClickOrKeySelected: {
                if(gSXMListMode != "SKIP")
                {
                    setListForceFocusCategoryList();
                    return;
                }

                gListSkipIndex =  selectedSkipItem
                if(movementStartedListSkipFlag == true)
                {
                    aLISTSkipListModel.isSuppportAutoFocusByScroll = false;
                    clickOrKeySelectedFlag = true;
                }

                if((idAppMain.sxm_list_currcat == stringInfo.sSTR_XMRADIO_All_CHANNELS) && (gListSkipIndex == 0 || gListSkipIndex == 1))
                {
                    console.log("### All Channels index 0 or 1 exclusive skip ###", gListSkipIndex)
                }
                else
                {
                    if(UIListener.HandleGetChannelSkipOnOff(gListSkipIndex) == true)
                        idAppMain.sxm_list_skipcount = UIListener.HandleSetChannelSkipOnOff(gListSkipIndex, false);
                    else
                        idAppMain.sxm_list_skipcount = UIListener.HandleSetChannelSkipOnOff(gListSkipIndex, true);
                }
            }
        }

        onContentYChanged: { overListSkipContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedListSkipFlag = false;
        }
        onMovementStarted: { movementStartedListSkipFlag = true; }
        onMovementEnded: {
            if ((gSXMListMode == "SKIP") && (idAppMain.state == "AppRadioList") && (idRadioSkipListQml.listSkipListCount > 0))
            {
                if((clickOrKeySelectedFlag == true) && (movementStartedListSkipFlag == true))
                {
                    aLISTSkipListModel.currentIndex = gListSkipIndex;
                    aLISTSkipListModel.positionViewAtIndex(aLISTSkipListModel.currentIndex, ListView.Beginning);
                }

                clickOrKeySelectedFlag = false;
                movementStartedListSkipFlag = false;
                aLISTSkipListModel.isSuppportAutoFocusByScroll = true;
                idLISTSkipListView.forceActiveFocus();
            }
        }
    }

    //************************ Scroll Bar ***//
    MComp.MScroll {
        id: idSkipListScroll
        scrollArea: aLISTSkipListModel;
        x: parent.x + parent.width - scrollEndDifX; y: aLISTSkipListModel.y + scrollY; z:1
        width: scrollWidth; height: aLISTSkipListModel.height - scrollY - scrollEndDifY
        visible: aLISTSkipListModel.count > 6
    }

    function onLISTSkipListLeft(currIndex)
    {
        if(aLISTSkipListModel.flicking || aLISTSkipListModel.moving)    return;
        if((aLISTSkipListModel.currentIndex == 0) && aLISTSkipListModel.count<7)    return;

        var nNextIndex = currIndex - 1;
        if(nNextIndex<0) nNextIndex = aLISTSkipListModel.count-1;

        aLISTSkipListModel.currentIndex = nNextIndex;
        if(aLISTSkipListModel.currentIndex<overListSkipContentCount)
        {
            var n = (aLISTSkipListModel.currentIndex - (6-((overListSkipContentCount-aLISTSkipListModel.currentIndex)%6)));
            aLISTSkipListModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aLISTSkipListModel.positionViewAtIndex((aLISTSkipListModel.currentIndex - (aLISTSkipListModel.currentIndex-overListSkipContentCount)%6), ListView.Beginning);
        }
    }

    function onLISTSkipListRight(currIndex)
    {
        if(aLISTSkipListModel.flicking || aLISTSkipListModel.moving)    return;
        if((aLISTSkipListModel.currentIndex == (aLISTSkipListModel.count-1)) && aLISTSkipListModel.count<7) return;

        var nNextIndex = currIndex + 1;
        if(nNextIndex >= aLISTSkipListModel.count) nNextIndex = 0;

        aLISTSkipListModel.currentIndex = nNextIndex;
        if(aLISTSkipListModel.currentIndex<overListSkipContentCount)
        {
            aLISTSkipListModel.positionViewAtIndex((aLISTSkipListModel.currentIndex - (aLISTSkipListModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aLISTSkipListModel.positionViewAtIndex((aLISTSkipListModel.currentIndex - (aLISTSkipListModel.currentIndex-overListSkipContentCount)%6), ListView.Beginning);
        }
    }
}
