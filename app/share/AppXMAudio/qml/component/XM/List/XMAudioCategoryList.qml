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
    id: idRadioCategoryList
    x: 0; y: 0

    //****************************** # Preperty #
    property alias aLISTCategoryModel: idLISTCategoryListView
    property int listCategoryListCount: idLISTCategoryListView.count
    property int overListCategoryContentCount: 0
    property bool movementStartedListCategoryFlag: false

    //****************************** # CategoryList ListView #
    MComp.MListView{
        id: idLISTCategoryListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: CATEGORYList

        delegate: XMMComp.MListLeftDelegate{
            id: idMListLeftDelegate

            mChListFirstText: index == 0 ? stringInfo.sSTR_XMRADIO_All_CHANNELS : CatName
        }

        onContentYChanged: { overListCategoryContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedListCategoryFlag = false;
            if(!visible)
                stopListCategoryTimer();

            if(visible == true)
            {
                if (PLAYInfo.CategoryLock)
                {
                    var nIndex = UIListener.doCheckCurrentItem(1);
                    aLISTCategoryModel.positionViewAtIndex(nIndex, ListView.Center);
                    aLISTCategoryModel.currentIndex = nIndex;
                    sxm_list_catindex = nIndex;
                }
                else
                {
                    aLISTCategoryModel.positionViewAtIndex(0, ListView.Center);
                    aLISTCategoryModel.currentIndex = 0;
                    sxm_list_catindex = 0;
                }
            }
            else
            {
                sxm_list_catindex = -1;
            }
        }
        onMovementStarted: { movementStartedListCategoryFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idLISTCategoryListView.visible && movementStartedListCategoryFlag)
                {
                    if ((gSXMListMode != "SKIP") && (idAppMain.state == "AppRadioList") && (idRadioCategoryList.listCategoryListCount > 0))
                    {
                        changeChannelListCategory(aLISTCategoryModel.currentIndex);
                        idRadioCategoryList.forceActiveFocus();
                    }

                    movementStartedListCategoryFlag = false;
                }
            }
        }


        onUpKeyLongListUp: {
            if(aLISTCategoryModel.count == 0) return;
            if(aLISTCategoryModel.currentIndex > 0) onLISTCategoryListLeft(aLISTCategoryModel.currentIndex);
        }
        onDownKeyLongListDown: {
            if(aLISTCategoryModel.count == 0) return;
            if(aLISTCategoryModel.currentIndex < (aLISTCategoryModel.count - 1)) onLISTCategoryListRight(aLISTCategoryModel.currentIndex);
        }
    }

    //****************************** # Round Scroll #
    MComp.MRoundScroll{
        id: idMRoundScroll
        x: 582
        y: 196 - systemInfo.headlineHeight
        scrollWidth: 46
        scrollHeight: 491
        listCountOfScreen: 6
        moveBarPosition: getCategoryListMoveBarPosition()
        listCount: aLISTCategoryModel.count
        visible: (aLISTCategoryModel.count > 6)
    }

    //****************************** # Functions #
    function getCategoryListMoveBarPosition()
    {
        var posionValue;
        var moveBarHeightTemp;
        moveBarHeightTemp = (idMRoundScroll.scrollHeight / idMRoundScroll.listCount) * idMRoundScroll.listCountOfScreen;

        if( moveBarHeightTemp < 40)
            posionValue = (491/aLISTCategoryModel.count * 0.91998)*overListCategoryContentCount;
        else
            posionValue = (491/aLISTCategoryModel.count * 0.97298)*overListCategoryContentCount;

        return posionValue;
    }

    function changeChannelListCategory(currentIdx)
    {
        gCategoryIndex =  currentIdx;
        console.log("### gCategoryIndex Item Clicked 0 ###", gCategoryIndex);

        sxm_list_curlist = "left";
        sxm_list_chnindex = 0;
        sxm_list_catindex = currentIdx;

        setListCategory(UIListener.HandleCategorySelect(currentIdx));
        setChannelListReset();
    }

    function changeChannelListCategoryPos(currentIdx)
    {
        gCategoryIndex =  currentIdx;
        console.log("### gCategoryIndex Item Clicked 1 ###", gCategoryIndex);

        sxm_list_curlist = "left";
        sxm_list_chnindex = 0;
        sxm_list_catindex = currentIdx;

        setListCategory(UIListener.HandleCategorySelect(currentIdx));
    }


    function onLISTCategoryListLeft(currIndex)
    {
        if(aLISTCategoryModel.flicking || aLISTCategoryModel.moving)    return;
        if((aLISTCategoryModel.currentIndex == 0) && aLISTCategoryModel.count<7)    return;

        var nNextIndex = currIndex - 1;
        if(nNextIndex<0) nNextIndex = aLISTCategoryModel.count-1;

        aLISTCategoryModel.currentIndex = nNextIndex;
        changeListCategoryTimer.restart();
        if(aLISTCategoryModel.currentIndex<overListCategoryContentCount)
        {
            var n = (aLISTCategoryModel.currentIndex - (6-((overListCategoryContentCount-aLISTCategoryModel.currentIndex)%6)));
            aLISTCategoryModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aLISTCategoryModel.positionViewAtIndex((aLISTCategoryModel.currentIndex - (aLISTCategoryModel.currentIndex-overListCategoryContentCount)%6), ListView.Beginning);
        }
    }

    function onLISTCategoryListRight(currIndex)
    {
        if(aLISTCategoryModel.flicking || aLISTCategoryModel.moving)    return;
        if((aLISTCategoryModel.currentIndex == (aLISTCategoryModel.count-1)) && aLISTCategoryModel.count<7) return;

        var nNextIndex = currIndex + 1;
        if(nNextIndex >= aLISTCategoryModel.count) nNextIndex = 0;

        aLISTCategoryModel.currentIndex = nNextIndex;
        changeListCategoryTimer.restart();
        if(aLISTCategoryModel.currentIndex<overListCategoryContentCount)
        {
            aLISTCategoryModel.positionViewAtIndex((aLISTCategoryModel.currentIndex - (aLISTCategoryModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aLISTCategoryModel.positionViewAtIndex((aLISTCategoryModel.currentIndex - (aLISTCategoryModel.currentIndex-overListCategoryContentCount)%6), ListView.Beginning);
        }
    }

    function stopListCategoryTimer()
    {
        if(changeListCategoryTimer.running == true)
            changeListCategoryTimer.stop();
    }

    function changeListCategoryList()
    {
        if(changeListCategoryTimer.running == true)
        {
            changeListCategoryTimer.stop();
            idRadioListQml.changeCategoryInChannelListByTimer = true;
            changeChannelListCategory(aLISTCategoryModel.currentIndex);
        }
    }
}
