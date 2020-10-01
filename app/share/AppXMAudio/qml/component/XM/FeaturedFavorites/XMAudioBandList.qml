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
    id: idRadioBandList
    x: 0; y: 0

    //****************************** # Preperty #
    property alias aFFBandListModel: idFFBandListView
    property int featuredFavoritesBandListCount: idFFBandListView.count
    property int overFFBandContentCount: 0
    property bool movementStartedFFBandFlag: false

    //****************************** # CategoryList ListView #
    MComp.MListView{
        id: idFFBandListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        //cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: FFBANDList
        delegate: XMMComp.MFeaturedFavoritesLeftDelegate{
            id: idMFFListLeftDelegate

            mChListFirstText: CatName
        }

        onContentYChanged: { overFFBandContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedFFBandFlag = false;
            if(!visible)
                stopFeaturedFavoritesTimer();
        }
        onMovementStarted: { movementStartedFFBandFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idFFBandListView.visible && movementStartedFFBandFlag)
                {
                    if ((idAppMain.state == "AppRadioFeaturedFavorites") && (idRadioBandList.featuredFavoritesBandListCount > 0))
                    {
                        changeFFBandList(aFFBandListModel.currentIndex, true);
                        idRadioBandList.forceActiveFocus();
                    }

                    movementStartedFFBandFlag = false;
                }
            }
        }

        onUpKeyLongListUp: {
            if(aFFBandListModel.count == 0) return;
            if(aFFBandListModel.currentIndex > 0) onFFBandListLeft(aFFBandListModel.currentIndex)
        }
        onDownKeyLongListDown: {
            if(aFFBandListModel.count == 0) return;
            if(aFFBandListModel.currentIndex < (aFFBandListModel.count - 1)) onFFBandListRight(aFFBandListModel.currentIndex)
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
        moveBarPosition: getFeaturedFavoriteMoveBarPosition()
        listCount: aFFBandListModel.count
        visible: (aFFBandListModel.count > 6)
    }

    onVisibleChanged: {
        if(idRadioBandList.visible)
        {
            aFFBandListModel.currentIndex = 0;
            idAppMain.gFFavoritesBandIndex = 0;
        }
    }

    function getFeaturedFavoriteMoveBarPosition()
    {
        var posionValue;
        var moveBarHeightTemp;
        moveBarHeightTemp = (idMRoundScroll.scrollHeight / idMRoundScroll.listCount) * idMRoundScroll.listCountOfScreen;

        if( moveBarHeightTemp < 40)
            posionValue = (491/aFFBandListModel.count * 0.91998)*overFFBandContentCount;
        else
            posionValue = (491/aFFBandListModel.count * 0.97298)*overFFBandContentCount;

        return posionValue;
    }

    function onFFBandListLeft(currIndex)
    {
        if(aFFBandListModel.flicking || aFFBandListModel.moving)    return;
        if((aFFBandListModel.currentIndex == 0) && aFFBandListModel.count<7)    return;

        var nNextIndex = currIndex - 1;
        if(nNextIndex<0) nNextIndex = aFFBandListModel.count-1;

        aFFBandListModel.currentIndex = nNextIndex;
        changeFeaturedFavoritesBandTimer.restart();
        if(aFFBandListModel.currentIndex<overFFBandContentCount)
        {
            var n = (aFFBandListModel.currentIndex - (6-((overFFBandContentCount-aFFBandListModel.currentIndex)%6)));
            aFFBandListModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aFFBandListModel.positionViewAtIndex((aFFBandListModel.currentIndex - (aFFBandListModel.currentIndex-overFFBandContentCount)%6), ListView.Beginning);
        }
    }

    function onFFBandListRight(currIndex)
    {
        if(aFFBandListModel.flicking || aFFBandListModel.moving)   return;
        if((aFFBandListModel.currentIndex == (aFFBandListModel.count-1)) && aFFBandListModel.count<7)   return;

        var nNextIndex = currIndex + 1;
        if(nNextIndex >= aFFBandListModel.count) nNextIndex = 0;

        aFFBandListModel.currentIndex = nNextIndex;
        changeFeaturedFavoritesBandTimer.restart();
        if(aFFBandListModel.currentIndex<overFFBandContentCount)
        {
            aFFBandListModel.positionViewAtIndex((aFFBandListModel.currentIndex - (aFFBandListModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aFFBandListModel.positionViewAtIndex((aFFBandListModel.currentIndex - (aFFBandListModel.currentIndex-overFFBandContentCount)%6), ListView.Beginning);
        }
    }

    function stopFeaturedFavoritesTimer()
    {
        if(changeFeaturedFavoritesBandTimer.running == true)
            changeFeaturedFavoritesBandTimer.stop();
    }

    function changeFeaturedFavoritesBandList()
    {
        if(changeFeaturedFavoritesBandTimer.running == true)
        {
            changeFeaturedFavoritesBandTimer.stop();
            idRadioFeaturedFavoritesQml.changeBandInFFByTimer = true;
            changeFFBandList(aFFBandListModel.currentIndex, true);
        }
    }
}
