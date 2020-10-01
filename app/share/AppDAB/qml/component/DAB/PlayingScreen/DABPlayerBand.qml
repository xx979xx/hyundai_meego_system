/**
 * FileName: DABPlayerBand.qml
 * Author: HYANG
 * Time: 2013-01-21
 *
 * - 2013-01-21 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MBand {
    id : idDABPlayerBand

    focus : true
    tabBtnFlag              : true
    tabBtnCount             : 3
    subBtnFlag              : true
    menuBtnFlag             : true
    reserveBtnFlag          : true
    selectedBand            : stringInfo.strPlayer_DAB
    tabBtnText              : stringInfo.strPlayer_FM
    tabBtnText2             : stringInfo.strPlayer_AM
    tabBtnText3             : stringInfo.strPlayer_DAB   
    subBtnText              : stringInfo.strPlayer_List
    menuBtnText             : stringInfo.strPlayer_Menu
    reserveBtnFgImage           : imageInfo.imgIcoList
    reserveBtnFgImageActive     : imageInfo.imgIcoList
    reserveBtnFgImageFocus      : imageInfo.imgIcoList
    reserveBtnFgImageFocusPress : imageInfo.imgIcoList
    reserveBtnFgImagePress      : imageInfo.imgIcoList

    signalImgFlag           : m_bIsServiceNotAvailable
    signalImg               : imageInfo.imgIcoNoSignal
    signalImgX              : 670
    signalImgY              : 114 - systemInfo.statusBarHeight 

    onTabBtn1Clicked : {
        console.log("[QML] DABPlayerBand.qml : FM Button Clicked")
        idTab1Focus.bgImageFocus = idDABPlayerBand.tabBtnPress
        UIListener.HandleFMKey();
    }
    onTabBtn1SelectkeyReleased:{
        idTab1Focus.bgImageFocus = idDABPlayerBand.tabBtnFocus
    }

    onTabBtn2Clicked : {
        console.log("[QML] DABPlayerBand.qml : AM Button Clicked")
        idTab2Focus.bgImageFocus = idDABPlayerBand.tabBtnPress
        UIListener.HandleAMKey();
    }

    onTabBtn2SelectkeyReleased: {
        idTab2Focus.bgImageFocus = idDABPlayerBand.tabBtnFocus
    }

    onTabBtn3Clicked : {
        console.log("[QML] DABPlayerBand.qml : DAB Button Clicked")
        idDABPlayerBand.focus = true;
        idDABPlayerBand.giveForceFocus(3)
        if(m_bListScanningOn)   MDabOperation.CmdReqScan();
        else if(m_bPresetScanningOn)   MDabOperation.CmdReqPresetScan();
    }

    onReserveBtnClicked: {
        console.log("[QML] DABPlayerBand.qml : onReserveBtnClicked (Preset)")
        m_bIsSaveAsPreset = false;
        setAppMainScreen("DabPresetList", false);
        if(m_bListScanningOn)   MDabOperation.CmdReqScan();
    }

    onSubBtnClicked: {
        console.log("[QML] DABPlayerBand.qml : onSubBtnClicked (List)")
        setAppMainScreen("DabStationList", false);
        if(m_bListScanningOn)   MDabOperation.CmdReqScan();
    }    

    onMenuBtnClicked: {
        console.log("[QML] DABPlayerBand.qml : onMenuBtnClicked")
        if(idAppMain.m_bViewMode)
        {
            console.log("[QML] DABPlayerMain.qml : modeChange")
            cmdReqModeChange(false);
        }
        if(m_bListScanningOn || m_bPresetScanningOn)  idDABPlayerBand.giveForceFocus(3);
        else  idDABPlayerBand.giveForceFocus("reserveBtn");

        setAppMainScreen("DabPlayerOptionMenu", true);        
    }

    onBackBtnClicked: {
        console.log("[QML] DABPlayerBand.qml : onBackBtnClicked :: inputMode = " +  idAppMain.inputMode)
        UIListener.HandleBackKey(idAppMain.inputMode);
    }

    onVisibleChanged: {
        idDABPlayerBand.focus = true;
        if(m_bListScanningOn || m_bPresetScanningOn)  idDABPlayerBand.giveForceFocus(3);
        else  idDABPlayerBand.giveForceFocus("reserveBtn");
    }
}
