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
    id: idRadioGameZoneCategoryList
    x: 0; y: 0

    //****************************** # Preperty #
    property alias aGAMEZONECategoryListModel : idGAMEZONECategoryListView
    property int gameZoneCategoryListCount: idGAMEZONECategoryListView.count
    property int overGameZoneCategoryContentCount: 0
    property bool movementStartedGameZoneCategoryFlag: false

    //****************************** # CategoryList ListView #
    MComp.MListView{
        id: idGAMEZONECategoryListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        //cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: GAMEZONECat
        delegate: XMMComp.MGameZoneLeftDelegate{
            id: idMGameZoneLeftDelegate

            mChListFirstText: CatName
        }

        onContentYChanged: { overGameZoneCategoryContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedGameZoneCategoryFlag = false;
            if(!visible)
                stopGameZoneCategoryTimer();
        }
        onMovementStarted: { movementStartedGameZoneCategoryFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idGAMEZONECategoryListView.visible && movementStartedGameZoneCategoryFlag)
                {
                    if ((idAppMain.state == "AppRadioGameZone") && (idRadioGameZoneCategoryList.gameZoneCategoryListCount > 0))
                    {
                        changeGameZoneCateogy(aGAMEZONECategoryListModel.currentIndex);
                        idRadioGameZoneCategoryList.forceActiveFocus();
                    }

                    movementStartedGameZoneCategoryFlag = false;
                }
            }
        }

        onUpKeyLongListUp: {
            if(aGAMEZONECategoryListModel.count == 0) return;
            if(aGAMEZONECategoryListModel.currentIndex > 0) onGAMEZONECategoryListLeft(aGAMEZONECategoryListModel.currentIndex)
        }
        onDownKeyLongListDown: {
            if(aGAMEZONECategoryListModel.count == 0) return;
            if(aGAMEZONECategoryListModel.currentIndex < (aGAMEZONECategoryListModel.count - 1)) onGAMEZONECategoryListRight(aGAMEZONECategoryListModel.currentIndex)
        }
    }

    //************************ Round Scroll ***//
    MComp.MRoundScroll{
        id: idMRoundScroll
        x: 582
        y: 196 - systemInfo.headlineHeight
        scrollWidth: 46
        scrollHeight: 491
        listCountOfScreen: 5
        moveBarPosition: getGameZoneMoveBarPosition()
        listCount: aGAMEZONECategoryListModel.count
        visible: (aGAMEZONECategoryListModel.count > 5)
    }

    onVisibleChanged: {
        if(idRadioGameZoneCategoryList.visible)
        {
            aGAMEZONECategoryListModel.currentIndex = 0;
            idAppMain.gGameZoneCatIndex = 0;
        }
    }

    function getGameZoneMoveBarPosition()
    {
        var posionValue;
        var moveBarHeightTemp;
        moveBarHeightTemp = (idMRoundScroll.scrollHeight / idMRoundScroll.listCount) * idMRoundScroll.listCountOfScreen;

        if( moveBarHeightTemp < 40)
            posionValue = (491/aGAMEZONECategoryListModel.count * 0.91998)*overGameZoneCategoryContentCount;
        else
            posionValue = (491/aGAMEZONECategoryListModel.count * 0.97298)*overGameZoneCategoryContentCount;

        return posionValue;
    }

    function onGAMEZONECategoryListLeft(currIndex)
    {
        if(aGAMEZONECategoryListModel.flicking || aGAMEZONECategoryListModel.moving)    return;
        if((aGAMEZONECategoryListModel.currentIndex == 0) && aGAMEZONECategoryListModel.count<6)    return;

        var nNextIndex = currIndex - 1;
        if(nNextIndex<0) nNextIndex = aGAMEZONECategoryListModel.count-1;

        aGAMEZONECategoryListModel.currentIndex = nNextIndex;
        changeGameZoneCategoryTimer.restart();
        if(aGAMEZONECategoryListModel.currentIndex<overGameZoneCategoryContentCount)
        {
            var n = (aGAMEZONECategoryListModel.currentIndex - (5-((overGameZoneCategoryContentCount-aGAMEZONECategoryListModel.currentIndex)%5)));
            aGAMEZONECategoryListModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aGAMEZONECategoryListModel.positionViewAtIndex((aGAMEZONECategoryListModel.currentIndex - (aGAMEZONECategoryListModel.currentIndex-overGameZoneCategoryContentCount)%5), ListView.Beginning);
        }
    }

    function onGAMEZONECategoryListRight(currIndex)
    {
        if(aGAMEZONECategoryListModel.flicking || aGAMEZONECategoryListModel.moving)    return;
        if((aGAMEZONECategoryListModel.currentIndex == (aGAMEZONECategoryListModel.count-1)) && aGAMEZONECategoryListModel.count<6) return;

        var nNextIndex = currIndex + 1;
        if(nNextIndex >= aGAMEZONECategoryListModel.count) nNextIndex = 0;

        aGAMEZONECategoryListModel.currentIndex = nNextIndex;
        changeGameZoneCategoryTimer.restart();
        if(aGAMEZONECategoryListModel.currentIndex<overGameZoneCategoryContentCount)
        {
            aGAMEZONECategoryListModel.positionViewAtIndex((aGAMEZONECategoryListModel.currentIndex - (aGAMEZONECategoryListModel.currentIndex%5)), ListView.Beginning);
        }
        else
        {
            aGAMEZONECategoryListModel.positionViewAtIndex((aGAMEZONECategoryListModel.currentIndex - (aGAMEZONECategoryListModel.currentIndex-overGameZoneCategoryContentCount)%5), ListView.Beginning);
        }
    }

    function stopGameZoneCategoryTimer()
    {
        if(changeGameZoneCategoryTimer.running == true)
            changeGameZoneCategoryTimer.stop();
    }

    function changeGameZoneCategoryList()
    {
        if(changeGameZoneCategoryTimer.running == true)
        {
            changeGameZoneCategoryTimer.stop();
            idRadioGameZoneQml.changeCategoryInGameZoneByTimer = true;
            changeGameZoneCateogy(aGAMEZONECategoryListModel.currentIndex);
        }
    }
}
