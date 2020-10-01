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
    id: idRadioEPGProgramList
    x: 0; y: 0

    //****************************** # Preperty #
    property alias aEPGProgramListModel : idEPGProgramListView
    property alias aEPGProgramListCount : idEPGProgramListView.count
    property int overEPGProgramContentCount: 0
    property bool movementStartedEPGProgramFlag: false;

    property int scrollEndDifX: 28
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13
    property int epgTimeCheck: 0
    property string currCategory: ""

    property string programListModelTextColor: colorInfo.brightGrey
    
    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idEPGProgramListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: EPGList
        delegate: XMMComp.MEPGRightDelegate{
            id: idMEPGRightDelegate

            mChListFirstText: EpgConvertStartTime
            mChListSecondText: EpgConvertEndTime
            mChListThirdText: (EpgLongName == "") ? EpgShortName : EpgLongName
            mChListProgicon: (EpgProgAlert == 1) ? true : false
            mChListSeriesicon: (EpgSeriesAlert == 1) ? true : false

            onClickOrKeySelected: {
                checkEPGListMoving();
                console.log("[QML]XMAudioEPGProgramList::onClickOrKeySelected():: idRadioEPGQml.epglistMovingState")
                if(idRadioEPGQml.epglistMovingState == true) return;

                sxm_epg_curlist = "right"
                gEPGProgramIndex =  sxm_epg_proindex

                EPGInfo.handleSetEpgProgram(gEPGProgramIndex);

                epgTimeCheck = EPGInfo.handleEPGLastTimeCheck(gEPGProgramIndex);
                if (epgTimeCheck == 2)
                {
                    setAppMainScreen("PopupRadioWarning1Line", true);
                    idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_PROGRAM_OFF_AIR);
                    idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(false);
                }
                else if (epgTimeCheck == 1)
                {
                    setAppMainScreen("PopupRadioEPGInfo2Btn", true);
                    idRadioPopupEPGInfo2Btn.item.setEPGInfo2CurrCategory(currCategory);
                }
                else
                {
                    setAppMainScreen("PopupRadioEPGInfo3Btn", true);
                    idRadioPopupEPGInfo3Btn.item.setEPGInfoProgAlert(EPGInfo.handleGetEpgProgramAlert(gEPGProgramIndex));
                    idRadioPopupEPGInfo3Btn.item.setEPGInfo3CurrCategory(currCategory);
                }
            }
        }

        onContentYChanged: { overEPGProgramContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if ((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedEPGProgramFlag = false;
        }
        onMovementStarted: { movementStartedEPGProgramFlag = true; }
        onMovementEnded:{
            if(isSuppportAutoFocusByScroll)
            {
                if(idEPGProgramListView.visible && movementStartedEPGProgramFlag)
                {
                    if((gSXMEPGMode == "PROGRAM") && (idAppMain.state == "AppRadioEPG") && (aEPGProgramListModel.count > 0))
                    {
                        if(changeEPGChannelTimer.running == false)
                            idEPGProgramList.forceActiveFocus();
                    }

                    movementStartedEPGProgramFlag = false;
                }
            }
        }
    }

    //************************ Scroll Bar ***//
    MComp.MScroll {
        id: idEPGProgramScroll
        scrollArea: aEPGProgramListModel;
        x: 1280 - 698 - scrollEndDifX; y: aEPGProgramListModel.y + scrollY; z:1
        width: scrollWidth; height: (aEPGProgramListModel.height + 20) - scrollY - scrollEndDifY
        visible: aEPGProgramListModel.count > 5
    }

    // "No Programs Available on This Channel" Text Display
    Text {
        id: aEPGProgramListModelText
        x: 22; y: 412-166+25-10-(font.pixelSize/2)
        width: 490; height: 32
        text : stringInfo.sSTR_XMRADIO_NO_EPG_PROGRAM
        font.pixelSize: 32
        font.family : systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: programListModelTextColor
        wrapMode: Text.WordWrap
        visible: (aEPGProgramListModel.count == 0) ? true : false
    }

    function onEPGProgramListLeft(currIndex)
    {
        if(aEPGProgramListModel.flicking || aEPGProgramListModel.moving)    return;
        if((aEPGProgramListModel.currentIndex == 0) && aEPGProgramListModel.count<6)    return;

        var nNextIndex = currIndex - 1;
        if(nNextIndex<0) nNextIndex = aEPGProgramListModel.count-1;

        aEPGProgramListModel.currentIndex = nNextIndex;
        if(aEPGProgramListModel.currentIndex<overEPGProgramContentCount)
        {
            var n = (aEPGProgramListModel.currentIndex - (5-((overEPGProgramContentCount-aEPGProgramListModel.currentIndex)%5)));
            aEPGProgramListModel.positionViewAtIndex(n>=0?n:0, ListView.Beginning);
        }
        else
        {
            aEPGProgramListModel.positionViewAtIndex((aEPGProgramListModel.currentIndex - (aEPGProgramListModel.currentIndex-overEPGProgramContentCount)%5), ListView.Beginning);
        }
    }

    function onEPGProgramListRight(currIndex)
    {
        if(aEPGProgramListModel.flicking || aEPGProgramListModel.moving)    return;
        if((aEPGProgramListModel.currentIndex == (aEPGProgramListModel.count-1)) && aEPGProgramListModel.count<6)   return;

        var nNextIndex = currIndex + 1;
        if(nNextIndex >= aEPGProgramListModel.count) nNextIndex = 0;

        aEPGProgramListModel.currentIndex = nNextIndex;
        if(aEPGProgramListModel.currentIndex<overEPGProgramContentCount)
        {
            aEPGProgramListModel.positionViewAtIndex((aEPGProgramListModel.currentIndex - (aEPGProgramListModel.currentIndex%5)), ListView.Beginning);
        }
        else
        {
            aEPGProgramListModel.positionViewAtIndex((aEPGProgramListModel.currentIndex - (aEPGProgramListModel.currentIndex-overEPGProgramContentCount)%5), ListView.Beginning);
        }
    }

    function epgProgramInitCurrenIndex()
    {
        if(aEPGProgramListModel.count > 0)
        {
            sxm_epg_curlist = "right";
            aEPGProgramListModel.currentIndex = 0;
        }
    }

    function onEPGProgramInitPos(toTop)
    {
        if(toTop == true)
        {
            onEPGProgramPosUpdateIndex(0);
            return;
        }
    }

    function onEPGProgramPosUpdateIndex(currIndex)
    {
        if(aEPGProgramListModel.count == 0) return;

        aEPGProgramListModel.currentIndex = currIndex;

        if(aEPGProgramListModel.currentIndex < overEPGProgramContentCount)
        {
            aEPGProgramListModel.positionViewAtIndex((aEPGProgramListModel.currentIndex - (aEPGProgramListModel.currentIndex%5)), ListView.Beginning);
        }
        else
        {
            aEPGProgramListModel.positionViewAtIndex((aEPGProgramListModel.currentIndex - (aEPGProgramListModel.currentIndex - overEPGProgramContentCount)%5), ListView.Beginning);
        }
    }

    function onEPGProgramPosUpdate()
    {
        if(aEPGProgramListModel.count == 0) return;

        var nCurrentIndex = 0;
        if(aEPGProgramListModel.currentIndex < 0)
        {
            nCurrentIndex = 0;
            aEPGProgramListModel.currentIndex = nCurrentIndex;
        }
        if(aEPGProgramListModel.currentIndex >= aEPGProgramListModel.count)
        {
            nCurrentIndex = aEPGProgramListModel.count-1;
            aEPGProgramListModel.currentIndex = nCurrentIndex;
        }

        if(aEPGProgramListModel.currentIndex < overEPGProgramContentCount)
        {
            aEPGProgramListModel.positionViewAtIndex((aEPGProgramListModel.currentIndex - (aEPGProgramListModel.currentIndex%5)), ListView.Beginning);
        }
        else
        {
            aEPGProgramListModel.positionViewAtIndex((aEPGProgramListModel.currentIndex - (aEPGProgramListModel.currentIndex - overEPGProgramContentCount)%5), ListView.Beginning);
        }
    }
}
