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
    id: idRadioGameZoneChannelList
    x: 0; y: 0

    //****************************** # Preperty #
    property alias aGAMEZONEChannelListModel : idGAMEZONEChannelListView
    property int gameZoneChannelListCount : idGAMEZONEChannelListView.count
    property int overGameZoneChannelContentCount: 0
    property bool movementStartedGameZoneChannelFlag: false

    property int scrollEndDifX: 28
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13

    property string gameZoneChannelListModelTextColor: colorInfo.brightGrey
    
    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idGAMEZONEChannelListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: GAMEZONEChn
        delegate: XMMComp.MGameZoneRightDelegate{
            id: idMGameZoneRightDelegate

            mChListArt: ChnArt
            mChListFirstText: ChnNum
            mChListSecondText: ChnArtist
            mChListThirdText: ChnTitle

            onClickOrKeySelected: {
                gGameZoneChnIndex =  sxm_gamezone_chnindex
                console.log("### gGameZoneChnIndex Item click ###", gGameZoneChnIndex)

                XMOperation.setPreviousScanStop();
                setAppMainScreen("AppRadioMain", false);
                SPSeek.handleGameZoneChannelSelect(gGameZoneChnIndex);
            }
        }

        onContentYChanged: { overGameZoneChannelContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedGameZoneChannelFlag = false;
        }
        onMovementStarted: { movementStartedGameZoneChannelFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idGAMEZONEChannelListView.visible && movementStartedGameZoneChannelFlag)
                {
                    if((idAppMain.state == "AppRadioGameZone") && (idRadioGameZoneChannelList.gameZoneChannelListCount > 0))
                    {
                        if(changeGameZoneCategoryTimer.running == false)
                        {
                            idRadioGameZoneDisplay.focus = true;
                            idRadioGameZoneChannelList.focus = true;
                        }
                    }

                    movementStartedGameZoneChannelFlag = false;
                }
            }
        }

        onCountChanged: {
            if(idRadioGameZoneChannelList.visible == false) return;

            if(aGAMEZONEChannelListModel.count > 0)
            {
                onGameZoneChannelPosUpdate();

                if((idRadioGameZoneChannelList.focus == true) && (idRadioGameZoneChannelList.activeFocus == true || idRadioGameZoneChannelList.activeFocus == false))
                {
                    idRadioGameZoneDisplay.focus = true;
                    idRadioGameZoneChannelList.focus = true;
                    idRadioGameZoneChannelList.forceActiveFocus();
                }
            }
            else
            {
                if(idRadioGameZoneChannelList.activeFocus == false)
                {
                    if(idRadioGameZoneCategoryList.gameZoneCategoryListCount > 0)
                    {
                        if(idAppMain.gDriverRestriction == false)
                        {
                            idRadioGameZoneDisplay.focus = true;
                            idRadioGameZoneCategoryList.focus = true;
                            idRadioGameZoneCategoryList.forceActiveFocus();
                        }
                    }
                    else
                    {
                        idRadioGameZoneDisplay.focus = false;
                        idRadioGameZoneBand.forceActiveFocus();
                    }
                }
            }
        }
    }

    //************************ Scroll Bar ***//
    MComp.MScroll {
        id: idGameZoneScroll
        scrollArea: aGAMEZONEChannelListModel;
        x: 1280-698-scrollEndDifX; y: aGAMEZONEChannelListModel.y + scrollY; z:1
        width: scrollWidth; height: (aGAMEZONEChannelListModel.height + 20) - scrollY - scrollEndDifY
        visible: aGAMEZONEChannelListModel.count > 5
    }

    // "Currently, No game available" Text Display
    Text {
        id: aGAMEZONEChannelListModelText1
        x: 22; y: 442-166-16-(font.pixelSize/2)
        width: 490; height: 32
        text : stringInfo.sSTR_XMRADIO_NO_GAME_MESSAGE
        font.pixelSize: 32
        font.family : systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: gameZoneChannelListModelTextColor
        wrapMode: Text.WordWrap
        visible: (aGAMEZONEChannelListModel.count == 0) ? true : false
    }

    function setGameZoneChListTuneEnter()
    {
        aGAMEZONEChannelListModel.currentItem.setGameZoneTuneEnterDelegate();
    }
    function setGameZoneChListTuneLeft()
    {
        aGAMEZONEChannelListModel.currentItem.setGameZoneTuneLeftDelegate();
    }
    function setGameZoneChListTuneRight()
    {
        aGAMEZONEChannelListModel.currentItem.setGameZoneTuneRightDelegate();
    }

    function onGAMEZONEChannelListLeft()
    {
        if(aGAMEZONEChannelListModel.flicking || aGAMEZONEChannelListModel.moving)   return;
        if((aGAMEZONEChannelListModel.currentIndex == 0) && aGAMEZONEChannelListModel.count<6)
            return;

        var nNextIndex = aGAMEZONEChannelListModel.currentIndex - 1;
        if(nNextIndex<0) nNextIndex = aGAMEZONEChannelListModel.count-1;

        aGAMEZONEChannelListModel.currentIndex = nNextIndex;
        if(aGAMEZONEChannelListModel.currentIndex<overGameZoneChannelContentCount)
        {
            var n = (aGAMEZONEChannelListModel.currentIndex - (5-((overGameZoneChannelContentCount-aGAMEZONEChannelListModel.currentIndex)%5)));
            aGAMEZONEChannelListModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aGAMEZONEChannelListModel.positionViewAtIndex((aGAMEZONEChannelListModel.currentIndex - (aGAMEZONEChannelListModel.currentIndex-overGameZoneChannelContentCount)%5), ListView.Beginning);
        }
    }

    function onGAMEZONEChannelListRight()
    {
        if(aGAMEZONEChannelListModel.flicking || aGAMEZONEChannelListModel.moving)   return;
        if((aGAMEZONEChannelListModel.currentIndex == (aGAMEZONEChannelListModel.count-1)) && aGAMEZONEChannelListModel.count<6)
            return;

        var nNextIndex = aGAMEZONEChannelListModel.currentIndex + 1;
        if(nNextIndex >= aGAMEZONEChannelListModel.count) nNextIndex = 0;

        aGAMEZONEChannelListModel.currentIndex = nNextIndex;
        if(aGAMEZONEChannelListModel.currentIndex<overGameZoneChannelContentCount)
        {
            aGAMEZONEChannelListModel.positionViewAtIndex((aGAMEZONEChannelListModel.currentIndex - (aGAMEZONEChannelListModel.currentIndex%5)), ListView.Beginning);
        }
        else
        {
            aGAMEZONEChannelListModel.positionViewAtIndex((aGAMEZONEChannelListModel.currentIndex - (aGAMEZONEChannelListModel.currentIndex-overGameZoneChannelContentCount)%5), ListView.Beginning);
        }
    }

    function changeCategory(category)
    {
        setGameZoneCategory(SPSeek.handleGameZoneCategorySelect(category));
        if(aGAMEZONEChannelListModel.count > 0)
            aGAMEZONEChannelListModel.currentIndex = 0;
    }

    function onGameZoneChannelInitPos(toTop)
    {
        if(toTop == true)
        {
            onGameZoneChannelPosUpdateIndex(0);
            return;
        }

        var idxSelectChannel = UIListener.HandleGetPlayIndexInGameZone();
        if(idxSelectChannel >= 0)
            onGameZoneChannelPosUpdateIndex(idxSelectChannel);
        else
            onGameZoneChannelPosUpdate();
    }

    function onGameZoneChannelPosUpdateIndex(currIndex)
    {
        if(aGAMEZONEChannelListModel.count == 0) return;

        aGAMEZONEChannelListModel.currentIndex = currIndex;
        aGAMEZONEChannelListModel.positionViewAtIndex(aGAMEZONEChannelListModel.currentIndex, (currIndex == 0) ? ListView.Beginning : ListView.Center);
    }

    function onGameZoneChannelPosUpdate()
    {
        if(aGAMEZONEChannelListModel.count == 0) return;

        var nCurrentIndex = 0;
        if(aGAMEZONEChannelListModel.currentIndex < 0)
        {
            nCurrentIndex = 0;
            aGAMEZONEChannelListModel.currentIndex = nCurrentIndex;
        }
        if(aGAMEZONEChannelListModel.currentIndex >= aGAMEZONEChannelListModel.count)
        {
            nCurrentIndex = aGAMEZONEChannelListModel.count-1;
            aGAMEZONEChannelListModel.currentIndex = nCurrentIndex;
        }

        if(aGAMEZONEChannelListModel.currentIndex < overGameZoneChannelContentCount)
        {
            aGAMEZONEChannelListModel.positionViewAtIndex((aGAMEZONEChannelListModel.currentIndex - (aGAMEZONEChannelListModel.currentIndex%5)), ListView.Beginning);
        }
        else
        {
            aGAMEZONEChannelListModel.positionViewAtIndex((aGAMEZONEChannelListModel.currentIndex - (aGAMEZONEChannelListModel.currentIndex - overGameZoneChannelContentCount)%5), ListView.Beginning);
        }
    }
}
