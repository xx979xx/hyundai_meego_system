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
    id: idRadioGameActiveList
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.contentAreaHeight

    //****************************** # Preperty #
    property alias aGAMEActiveListModel: idGAMEActiveListView
    property int gameActiveListCount: idGAMEActiveListView.count
    property int overGameActiveContentCount: 0
    property bool movementStartedGameZoneActiveFlag: false

    property int scrollEndDifX: 23
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13
    property int rowPageOver: 6

    property string gameActiveListViewTextColor: colorInfo.brightGrey
    
    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idGAMEActiveListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: SPSEEKChn
        delegate: XMMComp.MGameActiveListDelegate{
            id: idMGameAcitveDelegate

            mChListFirstText : AlertInfo
            mChListSecondText : ChnNum
            mChListThirdText : ChnName

            onClickOrKeySelected: {
                XMOperation.setPreviousScanStop();
                idRadioGameActiveQml.setGameActiveClose();
                setAppMainScreen("AppRadioMain", false);
                SPSeek.handleSPSeekChannelSelect(selectedAcitveItem);
            }
        }

        onContentYChanged: { overGameActiveContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if((idRadioGameActiveList.visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedGameZoneActiveFlag = false;
        }
        onMovementStarted: { movementStartedGameZoneActiveFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idGAMEActiveListView.visible && movementStartedGameZoneActiveFlag)
                {
                    if ((idAppMain.state == "AppRadioGameActive") && (idRadioGameActiveList.gameActiveListCount > 0))
                    {
                        idRadioGameActiveList.forceActiveFocus();
                    }

                    movementStartedGameZoneActiveFlag = false;
                }
            }
        }

        onCountChanged: {
            if(idRadioGameActiveList.visible == false) return;

            if(aGAMEActiveListModel.count > 0)
            {
                if(idAppMain.gDriverRestriction == true) return;

                onGameActivePosUpdate();

                //focus change from Band to Active list if one added
                if((idRadioGameActiveBand.focus == true) && (idRadioGameActiveList.activeFocus == false))
                {
                    idRadioGameActiveDisplay.focus = true;
                    idRadioGameActiveList.focus = true;
                    idRadioGameActiveList.forceActiveFocus();
                }
                if((idRadioGameActiveList.focus == true) && (idRadioGameActiveList.activeFocus == false))
                {
                    idRadioGameActiveDisplay.focus = true;
                    idRadioGameActiveList.focus = true;
                    idRadioGameActiveList.forceActiveFocus();
                }
            }
            else
            {
                if((idRadioGameActiveBand.focus == false) && (idRadioGameActiveList.activeFocus == false))
                {
                    idRadioGameActiveDisplay.focus = true;
                    idRadioGameActiveBand.forceActiveFocus();
                }
            }
        }
    }

    //************************ Scroll Bar ***//
    MComp.MScroll {
        id: idAcitveListScroll
        scrollArea: aGAMEActiveListModel;
        x: parent.x + parent.width - scrollEndDifX; y: aGAMEActiveListModel.y + scrollY; z:1
        width: scrollWidth; height: aGAMEActiveListModel.height - scrollY - scrollEndDifY
        visible: aGAMEActiveListModel.count > 6
    }

    // "Currently, No game available" Text Display
    Text {
        id: idRadioGameActiveListViewText1
        x: 40; y: 442-166-5-(font.pixelSize/2)
        width: 1200; height: 32
        font.pixelSize: 32
        font.family : systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: gameActiveListViewTextColor
        text : stringInfo.sSTR_XMRADIO_NO_GAME_MESSAGE
        visible: (aGAMEActiveListModel.count == 0) ? true : false
    }

    function onGAMEActiveListLeft()
    {
        if(aGAMEActiveListModel.flicking || aGAMEActiveListModel.moving)    return;
        aGAMEActiveListModel.moveOnPageByPage(rowPageOver, false);
    }

    function onGAMEActiveListRight()
    {
        if(aGAMEActiveListModel.flicking || aGAMEActiveListModel.moving)    return;
        aGAMEActiveListModel.moveOnPageByPage(rowPageOver, true);
    }

    function onInitGameActive()
    {
        if(aGAMEActiveListModel.count > 0)
        {
            aGAMEActiveListModel.positionViewAtIndex(0, ListView.Beginning);
            aGAMEActiveListModel.currentIndex = 0;
        }
    }

    function onGameActivePosUpdate()
    {
        if(aGAMEActiveListModel.count == 0) return;

        var nCurrentIndex = 0;
        if(aGAMEActiveListModel.currentIndex < 0)
        {
            nCurrentIndex = 0;
            aGAMEActiveListModel.currentIndex = nCurrentIndex;
        }
        if(aGAMEActiveListModel.currentIndex >= (aGAMEActiveListModel.count))
        {
            nCurrentIndex = aGAMEActiveListModel.count-1;
            aGAMEActiveListModel.currentIndex = nCurrentIndex;
        }

        aGAMEActiveListModel.positionViewAtIndex(aGAMEActiveListModel.currentIndex, ListView.Contain);
    }
}
