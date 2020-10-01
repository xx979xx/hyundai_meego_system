/**
 * FileName: DABPlayerMain.qml
 * Author: DaeHyungE
 * Time: 2013-01-17
 *
 * - 2012-01-17 Initial Crated by HyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp

MComp.MComponent{
    id : idDabPlayerMain
    x : 0
    y : 0
    width : systemInfo.lcdWidth
    height : systemInfo.subMainHeight
    focus : true
    objectName: "DABPlayerMain"

    //==========================Background Image
    Image {
        id : idStationListBGImg
        y : 0//-systemInfo.statusBarHeight
        source : imageInfo.imgBg_Main
    }

    DABPlayerBand {
        id : idDABPlayerBand
        x : 0
        y : 0
        focus : true
        KeyNavigation.down: (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != "")) ? idDABPlayerView : idDABPlayerBand
    }

    DABPlayerView {
        id : idDABPlayerView
        x : 0
        y : 86 /*179 - systemInfo.statusBarHeight*/
        width : idDabPlayerMain.width
        height : 541
        KeyNavigation.up : idDABPlayerBand
    }

    onClickMenuKey: {
        console.log("[QML] DABPlayerMain.qml : onClickMenuKey")
        if(idAppMain.m_bViewMode)
        {
            console.log("[QML] DABPlayerMain.qml : modeChange")
            cmdReqModeChange(false);
        }

        if(m_bListScanningOn || m_bPresetScanningOn)  idDABPlayerBand.giveForceFocus(3);
        else  idDABPlayerBand.giveForceFocus("reserveBtn");

        setAppMainScreen("DabPlayerOptionMenu", true);       
    }

    onBackKeyPressed: {
        console.log("[QML] DABPlayerMain.qml : onBackKeyPressed :: idAppMain.inputMode = " + idAppMain.inputMode)
        UIListener.HandleBackKey(idAppMain.inputMode);
    }

    onActiveFocusChanged: {
        if(!idDabPlayerMain.activeFocus) idAppMain.pressCancelSignal();
    }

    Connections {
        target : UIListener
        onReqForegroundFromUISH : {
            console.log("[QML] ==> Connections : DABPlayerMain.qml : onRegForegroundFromUISH : idAppMain.state :"+idAppMain.state);
            idDABPlayerBand.focus = true;
            if(m_bListScanningOn || m_bPresetScanningOn)  idDABPlayerBand.giveForceFocus(3);
            else  idDABPlayerBand.giveForceFocus("reserveBtn");
        }
    }

    function bandFocusPosition(){
        if((idAppMain.m_bListScanningOn) || (idAppMain.m_bPresetScanningOn)){ idDABPlayerBand.giveForceFocus(3); }
        else { idDABPlayerBand.giveForceFocus("reserveBtn"); }
    }
}
