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
    id: idEPGmainDisplay
    focus: true;

    //    ListModel{
    //        id: aaa;
    //        ListElement { ChnNum: "1"; ChnName:"1"}
    //        ListElement { ChnNum: "2"; ChnName:"2"}
    //        ListElement { ChnNum: "3"; ChnName:"3"}
    //        ListElement { ChnNum: "4"; ChnName:"4"}
    //        ListElement { ChnNum: "5"; ChnName:"5"}
    //        ListElement { ChnNum: "6"; ChnName:"6"}
    //        ListElement { ChnNum: "7"; ChnName:"7"}
    //    }
    //    ListModel{
    //        id: bbb;
    //        ListElement { EpgConvertStartTime: "12"; EpgConvertEndTime:"01"; EpgLongName: 1; EpgProgAlert:0; EpgSeriesAlert:0}
    //        ListElement { EpgConvertStartTime: "01"; EpgConvertEndTime:"02"; EpgLongName: 2; EpgProgAlert:0; EpgSeriesAlert:0}
    //        ListElement { EpgConvertStartTime: "02"; EpgConvertEndTime:"03"; EpgLongName: 3; EpgProgAlert:0; EpgSeriesAlert:0}
    //        ListElement { EpgConvertStartTime: "03"; EpgConvertEndTime:"04"; EpgLongName: 4; EpgProgAlert:0; EpgSeriesAlert:0}
    //        ListElement { EpgConvertStartTime: "04"; EpgConvertEndTime:"05"; EpgLongName: 5; EpgProgAlert:0; EpgSeriesAlert:0}
    //        ListElement { EpgConvertStartTime: "05"; EpgConvertEndTime:"06"; EpgLongName: 6; EpgProgAlert:0; EpgSeriesAlert:0}
    //        ListElement { EpgConvertStartTime: "06"; EpgConvertEndTime:"07"; EpgLongName: 7; EpgProgAlert:0; EpgSeriesAlert:0}
    //    }
    //    property alias listModel_EPGChannel : aaa
    //    property int epgChannel_ListCount: idEPGChannelList.aEPGChannelListCount
    //    property alias listModel_EPGProgram : bbb
    //    property int epgProgram_ListCount: idEPGProgramList.aEPGProgramListCount

    onVisibleChanged: {
        console.log("EPG MAIN LIST onVisibleChanged visible = " + visible + " , epgChannel_ListCount = " + idEPGChannelList.aEPGChannelListCount);
    }

    //****************************** # SXM Radio - Display Area #
    FocusScope{
        id: idEPGMainListFocus
        focus: true

        //****************************** # Background Image #
        Image{
            x: 0; y: systemInfo.titleAreaHeight; z: 0
            visible: true
            Image{
                source: imageInfo.imgFolderGeneral+"bg_menu_l.png"
                visible: (sxm_epg_curlist == "left") ? true : false
            }
            Image {
                source: imageInfo.imgFolderGeneral+"bg_menu_r.png"
                visible: (sxm_epg_curlist == "left") ? false : true
            }
        }
        Image{
            x: 0; y: systemInfo.titleAreaHeight; z: 0
            visible: true
            Image{
                x: 0; y: 0; z: 1
                source: imageInfo.imgFolderGeneral+"bg_menu_l_s.png"
                visible: (sxm_epg_curlist == "left") ? true : false
            }
            Image {
                x:585; y:0; z: 5
                source: imageInfo.imgFolderGeneral+"bg_menu_r_s.png"
                visible: (sxm_epg_curlist == "left") ? false : true
            }
        }

        //****************************** # Channel List #
        XMAudioEPGChannelList {
            id: idEPGChannelList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9
            width: 585; height: systemInfo.contentAreaHeight-20
            focus: true

            Keys.onPressed: {
                if(event.key == Qt.Key_Right)
                {
                    if(idEPGProgramList.aEPGProgramListCount > 0)
                    {
                        if(idEPGChannelList.movementStartedEPGChannelFlag == true)
                            idEPGChannelList.movementStartedEPGChannelFlag = false;

                        stopEPGChannelListTimer();
                    }
                    else
                    {
                        idEPGMainListFocus.focus = true;
                        idEPGChannelList.focus = true;
                    }
                }
            }
            onActiveFocusChanged: { if(idEPGChannelList.activeFocus) sxm_epg_curlist = "left"; }
        }

        //****************************** # Program List #
        XMAudioEPGProgramList {
            id: idEPGProgramList
            x: 698; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9
            width: systemInfo.lcdWidth-698; height: systemInfo.contentAreaHeight-19
            currCategory: sxm_epg_curcat

            KeyNavigation.left: (idEPGChannelList.aEPGChannelListCount == 0) ? idEPGProgramList : idEPGChannelList
            onActiveFocusChanged: { if(idEPGProgramList.activeFocus) sxm_epg_curlist = "right"; }
        }

        //****************************** # Visual Cue - list #
        MComp.MVisualCue{
            id: idMVisualCue
            x: 560; y: 357-systemInfo.statusBarHeight; z: 10
            arrowUpFlag: (idAppMain.state == "idRadioEPGMenu") ? false : idEPGChannelList.activeFocus || idEPGProgramList.activeFocus ? true:false
            arrowDownFlag: (idAppMain.state == "idRadioEPGMenu") ? false : idRadioEPGBand.activeFocus ? (idEPGChannelList.aEPGChannelListCount == 0) ? false : true : false
            arrowRightFlag: (idAppMain.state == "idRadioEPGMenu") ? false : idEPGChannelList.activeFocus ? (idEPGProgramList.aEPGProgramListCount == 0) ? false : true : false
            arrowLeftFlag: (idAppMain.state == "idRadioEPGMenu") ? false : idEPGProgramList.activeFocus ? true : false
            visible: true
        }
    }

    function changeEPGChannelList(currentIdx)
    {
        sxm_epg_chnindex = currentIdx;
        console.log("### sxm_epg_chnindex Item Clicked ###", sxm_epg_chnindex);

        sxm_epg_curlist = "left";
        setEPGChannel(EPGInfo.handleEPGProgramListByChannelIndex(currentIdx));
        setForceFocusToProgramReset();
    }

    function initEPGMainFocusPosition(selected)
    {
        if(idEPGChannelList.aEPGChannelListCount > 0 && idEPGProgramList.aEPGProgramListCount > 0)
        {
            idEPGMainListFocus.focus = true;
            idEPGChannelList.focus = false;
            idEPGProgramList.focus = true;
            idEPGChannelList.setEPGCurrentChannelListIndex(selected);
            idEPGProgramList.epgProgramInitCurrenIndex();
            idEPGProgramList.forceActiveFocus();
        }
        else
        {
            idEPGMainListFocus.focus = true;
            idEPGChannelList.focus = true;
            idEPGProgramList.focus = false;
            idEPGChannelList.setEPGCurrentChannelListIndex(selected);
            idEPGChannelList.forceActiveFocus();
        }
    }

    function setForceFocusToProgramReset()
    {
        idEPGProgramList.onEPGProgramInitPos(true);
    }

    function setForceFocusToProgram()
    {
        if(idEPGProgramList.aEPGProgramListCount > 0)
        {
            idEPGProgramList.onEPGProgramPosUpdate();

            idEPGMainListFocus.focus = true;
            idEPGChannelList.focus = false;
            idEPGProgramList.focus = true;
            idEPGProgramList.forceActiveFocus();
        }
        else
        {
            idEPGMainListFocus.focus = true;
            idEPGProgramList.focus = false;
            idEPGChannelList.focus = true;
            idEPGChannelList.forceActiveFocus();
        }
    }

    function checkEPGListMoving()
    {
        console.log("[QML]1 epglistMovingState = "+ epglistMovingState)
        idEPGChannelList.isEPGChannelListUpdatting();
        console.log("[QML]2 epglistMovingState = "+ epglistMovingState)
    }

    function stopEPGChannelListTimer()
    {
        idEPGChannelList.stopEPGChannelTimer();
        if(idEPGChannelList.aEPGChannelListModel.currentIndex != sxm_epg_chnindex)
        {
            changeEPGChannelList(idEPGChannelList.aEPGChannelListModel.currentIndex);
            initEPGMainFocusPosition(false);
        }
        else
        {
            setForceFocusToProgram();
        }
    }

    //************************************************************************* # Timer #
    Timer {
        id: changeEPGChannelTimer
        interval: 250
        running: false
        repeat: false
        onTriggered: idEPGChannelList.changeEPGChannelListFast();
    }

    Connections{
        target: UIListener
        onCheckTimeFormatEPG : {
            if(idRadioEPG.visible)
            {
                changeEPGChannelList(sxm_epg_chnindex);
                if(((gSXMEPGMode != "CATEGORY") && (idAppMain.state != "AppRadioEPGMenu")))
                    initEPGMainFocusPosition(false);
            }
        }
    }
}
