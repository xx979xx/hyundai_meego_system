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
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

FocusScope {
    id: idRadioChannelList
    x: 0; y: 0

    //****************************** # Preperty #
    property alias aLISTChannelModel: idLISTChannelListView
    property int listChannelListCount: idLISTChannelListView.count
    property int overListChannelContentCount: 0
    property bool movementStartedListChannelFlag: false

    property int scrollEndDifX: 28
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13

    property string playChNum: PLAYInfo.ChnNum

    property string listChannelModelTextColor: colorInfo.brightGrey
    
    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idLISTChannelListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: CHANNELList

        delegate: XMMComp.MListRightDelegate{
            id: idMListRightDelegate

            mChListFirstText: ChnNum
            mChListSecondText: ChnName
            mChListThirdText: ChnSkip

            onClickOrKeySelected: {
                sxm_list_curlist = "right"
                gChannelIndex =  sxm_list_chnindex
                console.log("### gChannelIndex Item click ###", gChannelIndex)

                XMOperation.setPreviousScanStop();
                idRadioListQml.setListClose();
                setAppMainScreen("AppRadioMain", false);
                UIListener.HandleChannelSelect(gChannelIndex);
            }
        }

        onContentYChanged: { overListChannelContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedListChannelFlag = false;

            if(visible == true)
            {
                var nIndex = UIListener.doCheckCurrentItem(2);
                aLISTChannelModel.positionViewAtIndex(nIndex, ListView.Center);
                aLISTChannelModel.currentIndex = nIndex;
            }
        }
        onMovementStarted: { movementStartedListChannelFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idLISTChannelListView.visible && movementStartedListChannelFlag)
                {
                    if ((gSXMListMode != "SKIP") && (idAppMain.state == "AppRadioList") && (idRadioChannelList.listChannelListCount > 0))
                    {
                        if(changeListCategoryTimer.running == false)
                        {
                            idRadioListMainDisplay.focus = true;
                            idRadioCategoryList.focus = false;
                            idRadioChannelList.forceActiveFocus();
                        }
                    }

                    movementStartedListChannelFlag = false;
                }
            }
        }
    }

    //************************ Scroll Bar ***//
    MComp.MScroll {
        id: idListChannelScroll
        scrollArea: aLISTChannelModel;
        x: 1280-698-scrollEndDifX; y: aLISTChannelModel.y + scrollY; z:1
        width: scrollWidth; height: (aLISTChannelModel.height + 20) - scrollY - scrollEndDifY
        visible: aLISTChannelModel.count > 6
    }

    // "No Channels are in this category" Text Display
    Text {
        id: aLISTChannelModelText1
        x: 22; y: 412-166+25-10-(font.pixelSize/2)
        width: 490; height: 32
        text : stringInfo.sSTR_XMRADIO_NO_CHANNEL_AVAIBLE
        font.pixelSize: 32
        font.family : systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: listChannelModelTextColor
        wrapMode: Text.WordWrap
        visible: (aLISTChannelModel.count == 0) ? true : false
    }

//    DEFINES = __SEEK_TRACK_CATEGORY_CHANNEL_FOCUS_MOVE__ in AppXMAudio.pro file
//    onPlayChNumChanged: {
//        if((idRadioList.visible == true) && (idAppMain.gSXMListMode == "LIST"))
//        {
//            sxm_list_currcatindex = UIListener.HandleGetCurrentCategory();
//            if(sxm_list_currcatindex != sxm_list_catindex)
//            {
//                if(!(UIListener.HandleGetShowPopupFlag() == true) && !(idAppMain.state == "PopupRadioWarning1Line"))
//                {
//                    idRadioCategoryList.changeChannelListCategoryPos(sxm_list_currcatindex);
//                    setListForceFocusChannelList();
//                }
//            }
//            else
//            {
//                if(!(idAppMain.state == "PopupRadioWarning1Line"))
//                    setListForceFocusChannelList();
//                else
//                    onListInitPos(false);
//            }
//        }
//    }

    //****************************** # Functions #
    function setChannelListTuneEnter()
    {
        aLISTChannelModel.currentItem.setTuneEnterDelegate()
    }
    function setChannelListTuneLeft()
    {
        aLISTChannelModel.currentItem.setTuneLeftDelegate()
    }
    function setChannelListTuneRight()
    {
        aLISTChannelModel.currentItem.setTuneRightDelegate()
    }

    function onListInitPos(toTop)
    {
        if(toTop == true)
        {
            onListPosUpdateIndex(0);
            return;
        }

        var idxSelectChannel = UIListener.HandleGetPlayIndexInCategory();
        if(idxSelectChannel >= 0)
            onListPosUpdateIndex(idxSelectChannel);
        else
            onListPosUpdate();
    }

    function onListPosUpdateIndex(currIndex)
    {
        if(aLISTChannelModel.count == 0) return;

        aLISTChannelModel.currentIndex = currIndex;
        aLISTChannelModel.positionViewAtIndex(aLISTChannelModel.currentIndex, (currIndex == 0) ? ListView.Beginning : ListView.Center);
    }

    function onListPosUpdate()
    {
        if(aLISTChannelModel.count == 0) return;

        var nCurrentIndex = 0;
        if(aLISTChannelModel.currentIndex < 0)
        {
            nCurrentIndex = 0;
            aLISTChannelModel.currentIndex = nCurrentIndex;
        }
        if(aLISTChannelModel.currentIndex >= aLISTChannelModel.count)
        {
            nCurrentIndex = aLISTChannelModel.count-1;
            aLISTChannelModel.currentIndex = nCurrentIndex;
        }

        if(aLISTChannelModel.currentIndex < overListChannelContentCount)
        {
            aLISTChannelModel.positionViewAtIndex((aLISTChannelModel.currentIndex - (aLISTChannelModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aLISTChannelModel.positionViewAtIndex((aLISTChannelModel.currentIndex - (aLISTChannelModel.currentIndex - overListChannelContentCount)%6), ListView.Beginning);
        }
    }

    function onLISTChannelListLeft()
    {
        if(aLISTChannelModel.flicking || aLISTChannelModel.moving)   return;
        if((aLISTChannelModel.currentIndex == 0) && aLISTChannelModel.count<7)    return;

        var nNextIndex = aLISTChannelModel.currentIndex - 1;
        if(nNextIndex<0) nNextIndex = aLISTChannelModel.count-1;

        aLISTChannelModel.currentIndex = nNextIndex;
        if(aLISTChannelModel.currentIndex<overListChannelContentCount)
        {
            var n = (aLISTChannelModel.currentIndex - (6-((overListChannelContentCount-aLISTChannelModel.currentIndex)%6)));
            aLISTChannelModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aLISTChannelModel.positionViewAtIndex((aLISTChannelModel.currentIndex - (aLISTChannelModel.currentIndex-overListChannelContentCount)%6), ListView.Beginning);
        }
    }

    function onLISTChannelListRight()
    {
        if(aLISTChannelModel.flicking || aLISTChannelModel.moving)  return;
        if((aLISTChannelModel.currentIndex == (aLISTChannelModel.count-1)) && aLISTChannelModel.count<7) return;

        var nNextIndex = aLISTChannelModel.currentIndex + 1;
        if(nNextIndex >= aLISTChannelModel.count) nNextIndex = 0;

        aLISTChannelModel.currentIndex = nNextIndex;
        if(aLISTChannelModel.currentIndex<overListChannelContentCount)
        {
            aLISTChannelModel.positionViewAtIndex((aLISTChannelModel.currentIndex - (aLISTChannelModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aLISTChannelModel.positionViewAtIndex((aLISTChannelModel.currentIndex - (aLISTChannelModel.currentIndex-overListChannelContentCount)%6), ListView.Beginning);
        }
    }
}
