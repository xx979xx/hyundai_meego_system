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
    id: idRadioFavoriteActiveList
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.contentAreaHeight

    //****************************** # Preperty #
    property alias aFavoritesActiveListModel : idFAVORITESActiveListView
    property int favoriteActiveListCount: idFAVORITESActiveListView.count
    property int overFavoritesActiveContentCount: 0
    property bool movementStartedFavoritesActiveFlag: false

    property int scrollEndDifX: 23
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13
    property int rowPageOver: 6

    property string favoritesActiveListModelTextColor: colorInfo.brightGrey
    
    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idFAVORITESActiveListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: ATSEEKChn
        delegate: XMMComp.MFavoriteActiveDelegate{
            id: idMFavoriteActiveDelegate

            mListFirstText : AlertInfo
            mListSecondText : ChnNum
            mListThirdText : ChnName
            nListIconType : AlertType
        }

        onContentYChanged: { overFavoritesActiveContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if((idRadioFavoriteActiveList.visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedFavoritesActiveFlag = false;
        }
        onMovementStarted: { movementStartedFavoritesActiveFlag = true }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idFAVORITESActiveListView.visible && movementStartedFavoritesActiveFlag)
                {
                    if((idAppMain.state == "AppRadioFavoriteActive") && (idRadioFavoriteActiveList.favoriteActiveListCount > 0))
                    {
                        idRadioFavoriteActiveList.forceActiveFocus();
                    }

                    movementStartedFavoritesActiveFlag = false;
                }
            }
        }

        onCountChanged: {
            if(idRadioFavoriteActiveList.visible == false) return;

            if(aFavoritesActiveListModel.count > 0)
            {
                onFavoritesActivePosUpdate();

                //focus change from Band to Active list if one added
                if((idRadioFavoriteActiveBand.focus == true) && (idRadioFavoriteActiveList.activeFocus == false))
                {
                    idRadioFavoriteActiveDisplay.focus = true;
                    idRadioFavoriteActiveList.focus = true;
                    idRadioFavoriteActiveList.forceActiveFocus();
                }
                if((idRadioFavoriteActiveList.focus == true) && (idRadioFavoriteActiveList.activeFocus == false))
                {
                    idRadioFavoriteActiveDisplay.focus = true;
                    idRadioFavoriteActiveList.focus = true;
                    idRadioFavoriteActiveList.forceActiveFocus();
                }
            }
            else
            {
                if((idRadioFavoriteActiveBand.focus == false) && (idRadioFavoriteActiveList.activeFocus == false))
                {
                    idRadioFavoriteActiveDisplay.focus = false;
                    idRadioFavoriteActiveBand.forceActiveFocus();
                }
            }
        }
    }

    //****************************** # Scroll Bar #
    MComp.MScroll {
        id: idFavoriteDeleteScroll
        scrollArea: aFavoritesActiveListModel;
        x: parent.x + parent.width - scrollEndDifX; y: aFavoritesActiveListModel.y + scrollY; z:1
        width: scrollWidth; height: aFavoritesActiveListModel.height - scrollY - scrollEndDifY
        visible: aFavoritesActiveListModel.count > 6
    }

    // "No Channels are in this category" Text Display
    Text {
        id: aFavoritesActiveListModelText1
        x: 40; y: 442-166-5-(font.pixelSize/2)
        width: 1200; height: 32
        font.pixelSize: 32
        font.family : systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: favoritesActiveListModelTextColor
        text : stringInfo.sSTR_XMRADIO_NO_CHANNEL_AVAIBLE
        visible: (aFavoritesActiveListModel.count == 0) ? true : false
    }

    function onFavoritesActiveListLeft()
    {
        if(aFavoritesActiveListModel.flicking || aFavoritesActiveListModel.moving)   return;
        aFavoritesActiveListModel.moveOnPageByPage(rowPageOver, false);
    }

    function onFavoritesActiveListRight()
    {
        if(aFavoritesActiveListModel.flicking || aFavoritesActiveListModel.moving)   return;
        aFavoritesActiveListModel.moveOnPageByPage(rowPageOver, true);
    }

    function onInitFavoritesActive()
    {
        if(aFavoritesActiveListModel.count > 0)
        {
            aFavoritesActiveListModel.positionViewAtIndex(0, ListView.Beginning);
            aFavoritesActiveListModel.currentIndex = 0;
        }
    }

    function onFavoritesActivePosUpdate()
    {
        if(aFavoritesActiveListModel.count == 0) return;

        var nCurrentIndex = 0;
        if(aFavoritesActiveListModel.currentIndex < 0)
        {
            nCurrentIndex = 0;
            aFavoritesActiveListModel.currentIndex = nCurrentIndex;
        }
        if(aFavoritesActiveListModel.currentIndex >= (aFavoritesActiveListModel.count))
        {
            nCurrentIndex = aFavoritesActiveListModel.count-1;
            aFavoritesActiveListModel.currentIndex = nCurrentIndex;
        }

        aFavoritesActiveListModel.positionViewAtIndex(aFavoritesActiveListModel.currentIndex, ListView.Contain);
    }
}
