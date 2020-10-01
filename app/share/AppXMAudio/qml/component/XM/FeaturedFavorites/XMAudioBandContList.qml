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
    id: idRadioBandContList
    x: 0; y: 0

    //****************************** # Preperty #
    property alias aFFBandContListModel : idFFBandContListView
    property int featuredFavoritesBandContListCount : idFFBandContListView.count
    property int overFFBandContContentCount: 0
    property bool movementStartedFFBandContFlag: false

    property int scrollEndDifX: 28
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13

    property string ffBandContListModelTextColor: colorInfo.brightGrey
    
    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idFFBandContListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: FFChnList
        delegate: XMMComp.MFeaturedFavoritesRightDelegate{
            id: idMFFListRightDelegate

            mChListFirstText: ChnNum
            mChListSecondText: ChnName

            onClickOrKeySelected: {
                sxm_ffavorites_curlist = "right"
                gFFavoritesBandContIndex =  sxm_ffavorites_bandcontindex
                console.log("### gFFavoritesBandContIndex Item click ###", gFFavoritesBandContIndex)

                XMOperation.setPreviousScanStop();
                idRadioFeaturedFavoritesQml.setFeaturedFavoritesClose();
                setAppMainScreen("AppRadioMain", false);
                FFManager.handleFeaturedFavoritesSelect(gFFavoritesBandContIndex);
            }
        }

        onContentYChanged: { overFFBandContContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedFFBandContFlag = false;
        }
        onMovementStarted: { movementStartedFFBandContFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idFFBandContListView.visible && movementStartedFFBandContFlag)
                {
                    if((idAppMain.state == "AppRadioFeaturedFavorites") && (idRadioBandContList.featuredFavoritesBandContListCount > 0))
                    {
                        if(changeFeaturedFavoritesBandTimer.running == false)
                        {
                            idRadioFeaturedFavoritesDisplay.focus = true
                            idRadioBandContList.focus = true
                        }
                    }

                    movementStartedFFBandContFlag = false;
                }
            }
        }
    }

    //************************ Scroll Bar ***//
    MComp.MScroll {
        id: idFeaturedFavScroll
        scrollArea: aFFBandContListModel;
        x: 1280 - 698 - scrollEndDifX; y: aFFBandContListModel.y + scrollY; z:1
        width: scrollWidth; height: (aFFBandContListModel.height + 20) - scrollY - scrollEndDifY
        visible: aFFBandContListModel.count > 6
    }

    // "No Channels are in this category" Text Display
    Text {
        id: aFFBandContListModelText1
        x: 22; y: 412-166+25-10-(font.pixelSize/2)
        width: 490; height: 32
        text : stringInfo.sSTR_XMRADIO_NO_CHANNEL_AVAIBLE
        font.pixelSize: 32
        font.family : systemInfo.font_NewHDB
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: ffBandContListModelTextColor
        wrapMode: Text.WordWrap
        visible: (aFFBandContListModel.count == 0) ? true : false
    }

    function setFFContListTuneEnter()
    {
        aFFBandContListModel.currentItem.setFFTuneEnterDelegate()
    }
    function setFFContListTuneLeft()
    {
        aFFBandContListModel.currentItem.setFFTuneLeftDelegate()
    }
    function setFFContListTuneRight()
    {
        aFFBandContListModel.currentItem.setFFTuneRightDelegate()
    }

    function onFFBandContListLeft()
    {
        if(aFFBandContListModel.flicking || aFFBandContListModel.moving)    return;
        if((aFFBandContListModel.currentIndex == 0) && aFFBandContListModel.count<7)    return;

        var nNextIndex = aFFBandContListModel.currentIndex - 1;
        if(nNextIndex<0) nNextIndex = aFFBandContListModel.count-1;

        aFFBandContListModel.currentIndex = nNextIndex;
        if(aFFBandContListModel.currentIndex<overFFBandContContentCount)
        {
            var n = (aFFBandContListModel.currentIndex - (6-((overFFBandContContentCount-aFFBandContListModel.currentIndex)%6)));
            aFFBandContListModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aFFBandContListModel.positionViewAtIndex((aFFBandContListModel.currentIndex - (aFFBandContListModel.currentIndex-overFFBandContContentCount)%6), ListView.Beginning);
        }
    }

    function onFFBandContListRight()
    {
        if(aFFBandContListModel.flicking || aFFBandContListModel.moving)    return;
        if((aFFBandContListModel.currentIndex == (aFFBandContListModel.count-1)) && aFFBandContListModel.count<7) return;

        var nNextIndex = aFFBandContListModel.currentIndex + 1;
        if(nNextIndex >= aFFBandContListModel.count) nNextIndex = 0;

        aFFBandContListModel.currentIndex = nNextIndex;
        if(aFFBandContListModel.currentIndex<overFFBandContContentCount)
        {
            aFFBandContListModel.positionViewAtIndex((aFFBandContListModel.currentIndex - (aFFBandContListModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aFFBandContListModel.positionViewAtIndex((aFFBandContListModel.currentIndex - (aFFBandContListModel.currentIndex-overFFBandContContentCount)%6), ListView.Beginning);
        }
    }

    function changeFFBandListIdx(band)
    {
        FFManager.handleFeaturedFavoritesView(band);
        if(aFFBandContListModel.count > 0)
            aFFBandContListModel.currentIndex = 0;
    }

    function onFFBandContInitPos(toTop)
    {
        if(toTop == true)
        {
            onFFBandContPosUpdateIndex(0);
            return;
        }

        var idxSelectChannel = FFManager.handleGetPlayIndexInFeaturedFavorites();
        if(idxSelectChannel >= 0)
            onFFBandContPosUpdateIndex(idxSelectChannel);
        else
            onFFBandContPosUpdate();
    }

    function onFFBandContPosUpdateIndex(currIndex)
    {
        if(aFFBandContListModel.count == 0) return;

        aFFBandContListModel.currentIndex = currIndex;
        aFFBandContListModel.positionViewAtIndex(aFFBandContListModel.currentIndex, (currIndex == 0) ? ListView.Beginning : ListView.Center);
    }

    function onFFBandContPosUpdate()
    {
        if(aFFBandContListModel.count == 0) return;

        var nCurrentIndex = 0;
        if(aFFBandContListModel.currentIndex < 0)
        {
            nCurrentIndex = 0;
            aFFBandContListModel.currentIndex = nCurrentIndex;
        }
        if(aFFBandContListModel.currentIndex >= aFFBandContListModel.count)
        {
            nCurrentIndex = aFFBandContListModel.count-1;
            aFFBandContListModel.currentIndex = nCurrentIndex;
        }

        if(aFFBandContListModel.currentIndex < overFFBandContContentCount)
        {
            aFFBandContListModel.positionViewAtIndex((aFFBandContListModel.currentIndex - (aFFBandContListModel.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            aFFBandContListModel.positionViewAtIndex((aFFBandContListModel.currentIndex - (aFFBandContListModel.currentIndex - overFFBandContContentCount)%6), ListView.Beginning);
        }
    }
}
