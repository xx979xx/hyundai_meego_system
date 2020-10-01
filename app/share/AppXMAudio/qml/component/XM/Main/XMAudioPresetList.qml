/**
 * FileName: RadioPresetList.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

FocusScope {
    id: idRadioPresetList
    x: 0; y: 0

    property int selectedItem: 0
    property int overPresetContentCount: 0
    property alias presetList: idChListView
    property int idxLastSelected : 0
    property int idxCurrentSelected : 0
    property string playChNum : PLAYInfo.ChnNum
    property int mcontentHeight : 1602
    property bool movementStartedPresetListFlag: false

    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idChListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: PRESETList
        reorderPresetDrag: isDragStarted ? true : false
        isSuppportAutoFocusByScroll: false

        //****************************** # Preset Save and Order #
        property int insertedIndex: -1
        property int selectedIndex:-1;
        property int curIndex:-1;
        property bool isDragStarted: false;
        property bool presetOrder: idAppMain.gSXMEditPresetOrder == "TRUE" ? true : false
        signal itemInitWidth()
        signal itemMoved(int selectedIndex, bool isUp)
        //Behavior on contentY {enabled: idChListView.isDragStarted; NumberAnimation { duration: 0 } }
        //****************************** # Preset Save and Order #

        delegate: MComp.MChListDelegate{
            id: idMPresetListDelegate

            selectedApp: "XMAudio"

            mChListFirstText: ChnArt
            mChListSecondText: ChnNum
            mChListThirdText: ChnName
            mChListForthText: PresetNum

            onChangeRow: {
                var backup_contentY = idChListView.contentY;
                UIListener.HandleChangePresetOrder(fromIndex, toIndex);
                idChListView.contentY = backup_contentY ;
            }
        }

        onContentYChanged: { overPresetContentCount = contentY/(mcontentHeight/count) }
        onMovementStarted: {
            movementStartedPresetListFlag = true;
            flickStartTimer.stop();
        }
        onMovementEnded: {
            if(idAppMain.gSXMEditPresetOrder == "TRUE" && idAppMain.inputModeXM == "jog" && idChListView.isDragStarted == true) return;

            if(movementStartedPresetListFlag == true)
            {
                idxCurrentSelected = idChListView.currentIndex;
                if(idxCurrentSelected >= 0) flickStartTimer.restart();
            }

            movementStartedPresetListFlag = false;
        }

        onPresetOrderChanged: {
            if(presetOrder == true)
            {
                onPresetPosUpdate(0, true);
            }
            else
            {
                idxCurrentSelected = UIListener.HandleGetPresetSelected();
                if(idxCurrentSelected >= 0)
                {
                    if(idChListView.curIndex != idxCurrentSelected)
                        idChListView.curIndex = idxCurrentSelected;
                    onPresetPosUpdate(idxCurrentSelected, true);
                }
            }
        }

        onDownKeyLongListDown : if(idxLastSelected < (idChListView.count - 1)) onPresetDown(idxLastSelected, true);
        onUpKeyLongListUp : if(idxLastSelected>0) onPresetUp(idxLastSelected, true);
    }

    onPlayChNumChanged: {
        //console.log("Preset List -> onPlayChNumChanged ##### Num:"+playChNum);
        onPresetListReInit(true, false);
    }
    onVisibleChanged: {
        if(visible == true)
            onPresetListvisibleReInit(true);
        movementStartedPresetListFlag = false;
    }

    Timer{
        id: flickStartTimer
        interval: 5000; running: true; repeat: false
        onTriggered: {
            //console.log("flickStartTimer -> onTriggered #####################")
            onPresetPosUpdate(idChListView.currentIndex, false);
        }
    }

    //************************ Round Scroll ***//
    MComp.MRoundScroll{
        id: idMRoundScroll
        x: 482
        y: 196 - systemInfo.headlineHeight-6
        scrollWidth: 46
        scrollHeight: 491
        listCountOfScreen: 6
        moveBarPosition: getPresetListMoveBarPosition()
        listCount: idChListView.count
        visible: (idChListView.count > 6)
    }

    Connections {
        target: idAppMain
        onPresetOrderDisabled:{
            if(idChListView.isDragStarted)
            {
                idChListView.isDragStarted = false;
                idChListView.interactive = true;
                idChListView.itemInitWidth();
                idChListView.currentIndex = idChListView.curIndex;
                idChListView.insertedIndex = -1;
                idChListView.curIndex = -1;
            }

            //Send Reorder Preset to SMS
            UIListener.HandleChangePresetOrderSendData();
            UIListener.savePresetList();
        }

        onPresetOrderDisabledByBackKey:{
            if(idChListView.isDragStarted)
            {
                idChListView.isDragStarted = false;
                if(idAppMain.isDragByTouch == true)
                {
                    // do nothing
                }
                else
                {
                    idChListView.interactive = true;
                }
                idChListView.itemInitWidth();
                idChListView.currentIndex = idChListView.curIndex;
                idChListView.insertedIndex = -1;
                idChListView.curIndex = -1;
            }

            //Send Reorder Preset to SMS
            UIListener.HandleChangePresetOrderSendData();
            UIListener.savePresetList();
        }

        onDisableInteractive:{
            if(idChListView.interactive == false)
            {
                idChListView.interactive = true;
            }
        }
    }

    function onSelectPreset(index)
    {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();
        XMOperation.setPreviousScanStop();

        idChListView.currentIndex = index
        idChListView.focus = true

        setPresetSelect(index);
        UIListener.autoTest_athenaSendObject();
    }

    function onSavePreset(index)
    {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();
        XMOperation.setPreviousScanStop();

        var retValue = 0;
        retValue = UIListener.HandleSavePreset(index);

        if(retValue != 2)
        {
            idxLastSelected = index;
            idChListView.currentIndex = index;
            idChListView.focus = true;
            idChListView.forceActiveFocus();
        }

        if(retValue == 1)
            XMOperation.showSavedAsPresetSuccessfully();
        else if(retValue == 2)
        {
            XMOperation.showSavedAsPresetRadioIDChannelNotAvailable();
            idRadioMainDisplay.focus = true;
            idRadioDisplayButton.focus = true;
            idRadioDisplayChannelBtn.focus = true;
        }

        //Cluster Update
        UIListener.onSendXMDataToCluster();
        UIListener.autoTest_athenaSendObject();
    }

    function onPresetListReInit(bForceUpdate, bMenuPosition)
    {
        idxCurrentSelected = UIListener.HandleGetPresetSelected();
        if(idxCurrentSelected >= 0)
        {
            idxLastSelected = idxCurrentSelected;

            if(idChListView.currentIndex != idxCurrentSelected)
                idChListView.currentIndex = idxCurrentSelected;
            if((idChListView.currentItem.activeFocus != true) || (bForceUpdate == true))
            {
                onPresetPosUpdate(idxCurrentSelected, (bMenuPosition == true) ? false : true);
            }
        }
    }

    function onPresetListvisibleReInit(bForceUpdate)
    {
        idxCurrentSelected = UIListener.HandleGetPresetSelected();
        if(idxCurrentSelected >= 0)
        {
            if(idChListView.currentIndex != idxCurrentSelected)
                idChListView.currentIndex = idxCurrentSelected;
            if((idChListView.currentItem.activeFocus != true) || (bForceUpdate == true))
            {
                onPresetPosUpdate(idxCurrentSelected, true);
            }
        }
        else
        {
            idChListView.positionViewAtIndex(0, ListView.Beginning);
        }
    }

    function onPresetUp(currIndex, bDirectTune)
    {
        var nNextIndex = currIndex - 1;
        if(nNextIndex<0) nNextIndex = idChListView.count-1;

        idChListView.currentIndex = nNextIndex;
        if(idChListView.currentIndex<overPresetContentCount)
        {
            idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex%6)), ListView.Beginning);
        }

        if(bDirectTune)
        {
            XMOperation.setPreviousScanStop();
            setPresetSelect(nNextIndex);
        }
    }

    function onPresetDown(currIndex, bDirectTune)
    {
        var nNextIndex = currIndex + 1;
        if(nNextIndex >= idChListView.count) nNextIndex = 0;

        idChListView.currentIndex = nNextIndex;
        if(idChListView.currentIndex<overPresetContentCount)
        {
            idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex%6)), ListView.Beginning);
        }

        if(bDirectTune == true)
        {
            XMOperation.setPreviousScanStop();
            setPresetSelect(nNextIndex);
        }
    }

    function onPresetPosUpdate(currIndex, bNowUpdate)
    {
        if (idChListView.isDragStarted != true)
        {
            if ((UIListener.HandleGetPresetSelected() != -1) || (idAppMain.gSXMSaveAsPreset == "TRUE") || (idAppMain.gSXMEditPresetOrder == "TRUE"))
            {
                idChListView.currentIndex = currIndex;
                if(bNowUpdate)
                {
                    idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex%6)), ListView.Beginning);
                }
                else
                {
                    if(idChListView.currentIndex < overPresetContentCount)
                        idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex%6)), ListView.Beginning);
                    else
                        idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex-overPresetContentCount)%6), ListView.Beginning);
                }
            }
        }
    }

    function setFlickStartTimerStop()
    {
        flickStartTimer.stop();
    }

    function getPresetListMoveBarPosition()
    {
        var posionValue;
        var moveBarHeightTemp;
        moveBarHeightTemp = (idMRoundScroll.scrollHeight / idMRoundScroll.listCount) * idMRoundScroll.listCountOfScreen;

        if( moveBarHeightTemp < 40)
            posionValue = (491/idChListView.count * 0.91998)*overPresetContentCount;
        else
            posionValue = (491/idChListView.count * 0.97298)*overPresetContentCount;

        return posionValue;
    }

    function setPresetSelect(idx)
    {
        idxLastSelected = idx;
        if( !(idAppMain.gSXMSaveAsPreset == "TRUE" || idAppMain.gSXMEditPresetOrder == "TRUE") )
            UIListener.HandlePresetSelect(idx);
    }

    function isSelectedPreset(idx)
    {
        idxCurrentSelected = UIListener.HandleGetPresetSelected();
        return (idxCurrentSelected==idx)?true : false
    }

    function setActiveFocus()
    {
        idxCurrentSelected = UIListener.HandleGetPresetSelected();
        if(idxCurrentSelected < 0)
        {
            onSelectPreset(0)
        }

        idRadioPresetList.focus = true;
        onPresetListReInit(true, false);
    }
}
