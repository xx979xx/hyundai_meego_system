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
    id: idRadioEPGCategoryList
    x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
    width: systemInfo.lcdWidth; height: systemInfo.contentAreaHeight
    focus: true

    //****************************** # Preperty #
    property alias aEPGCategoryListModel : idEPGCategoryListView
    property int overEPGCategoryContentCount: 0
    property bool movementStartedEPGCategoryFlag: false

    property int scrollEndDifX: 23
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13
    property int selectedEPGCatItem: 0
    property int rowPageOver: 6

    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idEPGCategoryListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: CATEGORYList

        delegate: XMMComp.MEPGCategoryDelegate{
            id: idMEPGCategoryDelegate

            mChListFirstText : index == 0 ? stringInfo.sSTR_XMRADIO_All_CHANNELS : CatName

            onClickOrKeySelected: {
                UIListener.HandleCategorySelect(selectedEPGCatItem);
                if(gEPGCategoryIndex == selectedEPGCatItem)
                {
                    EPGInfo.handleEPGProgramListByChannelIndex(sxm_epg_chnindex);
                }
                else
                {
                    sxm_epg_chnindex = 0;
                    EPGInfo.handleEPGProgramListByChannelIndex(0);
                    setEPGChannel("");
                }

                gEPGCategoryIndex =  selectedEPGCatItem;

                selectEPGMain();
            }
        }

        onContentYChanged: { overEPGCategoryContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedEPGCategoryFlag = false;

            if(idRadioEPGCategoryList.visible)
            {
                if (PLAYInfo.CategoryLock)
                {
                    var nIndex = UIListener.doCheckCurrentItem(1);
                    aEPGCategoryListModel.positionViewAtIndex(nIndex, ListView.Center);
                    aEPGCategoryListModel.currentIndex = nIndex;
                }
                else
                {
                    aEPGCategoryListModel.positionViewAtIndex(0, ListView.Center);
                    aEPGCategoryListModel.currentIndex = 0;
                }
            }
        }
        onMovementStarted: { movementStartedEPGCategoryFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idEPGCategoryListView.visible && movementStartedEPGCategoryFlag)
                {
                    if((gSXMEPGMode == "CATEGORY") && (idAppMain.state == "AppRadioEPG") && (aEPGCategoryListModel.count > 0))
                    {
                        idEPGCategoryListView.forceActiveFocus();
                    }

                    movementStartedEPGCategoryFlag = false;
                }
            }
        }
    }

    //************************ Scroll Bar ***//
    MComp.MScroll {
        id: idEPGCategoryScroll
        scrollArea: aEPGCategoryListModel;
        x: parent.x + parent.width - scrollEndDifX; y: aEPGCategoryListModel.y + scrollY; z: 1
        width: scrollWidth; height: aEPGCategoryListModel.height - scrollY - scrollEndDifY
        visible: aEPGCategoryListModel.count > 6
    }

    function onEPGCategoryListLeft(currIndex)
    {
        if(aEPGCategoryListModel.flicking || aEPGCategoryListModel.moving)    return;
        aEPGCategoryListModel.moveOnPageByPage(rowPageOver, false);
    }

    function onEPGChannelListRight(currIndex)
    {
        if(aEPGCategoryListModel.flicking || aEPGCategoryListModel.moving)    return;
        aEPGCategoryListModel.moveOnPageByPage(rowPageOver, true);
    }
}
