/**
 * FileName: DABPlayerOptionMenu.qml
 * Author: DaeHyungE
 * Time: 2013-01-22
 *
 * - 2013-01-22 Initial Crated by HyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation


MComp.MOptionMenu {
    id : idDabPlayerOptionMenu

    objectName: "DABPlayerOptionMenu"
    property string inputMode  : idAppMain.inputMode
    linkedModels: ListModel{ id :idDABMainMenuModel}

    menu2Enabled : (idAppMain.m_sDLS == "") ? false : true
    menu3Enabled : (idAppMain.m_sSLS == "") ? false : true
    menu4Enabled : (idAppMain.m_bEPG == true) ? true : false

    onMenu0Click: {
        console.log("[QML] DABPlayerOptionMenu.qml : Station List Clicked !!")
        if(m_bListScanningOn)   MDabOperation.CmdReqScan();
        idDabPlayerOptionMenu.offOptionMenu();
        setAppMainScreen("DabStationList", false);
    }

    onMenu1Click: {
        console.log("[QML] DABPlayerOptionMenu.qml : Preset List Clicked !!")
        if(m_bListScanningOn)   MDabOperation.CmdReqScan();
        m_bIsSaveAsPreset = false;
        idDabPlayerOptionMenu.offOptionMenu();
        setAppMainScreen("DabPresetList", false);
    }

    onMenu2Click: {
        console.log("[QML] DABPlayerOptionMenu.qml : Text Clicked !!")
        idDabPlayerOptionMenu.offOptionMenu();
        setAppMainScreen("DabInfoDLSMain", false);
    }

    onMenu3Click: {
        console.log("[QML] DABPlayerOptionMenu.qml : Image Clicked !!")
        idDabPlayerOptionMenu.offOptionMenu();
        setAppMainScreen("DabInfoSLSMain", false);
    }

    onMenu4Click: {
        console.log("[QML] DABPlayerOptionMenu.qml : EPG Clicked !!")
        idDabPlayerOptionMenu.offOptionMenu();
        setAppMainScreen("DabInfoEPGMain", false);
    }

    onMenu5Click: {
        console.log("[QML] DABPlayerOptionMenu.qml : Save as Preset Clicked !!")
        if(m_bListScanningOn)   MDabOperation.CmdReqScan();
        idDabPlayerOptionMenu.offOptionMenu();
        m_bIsSaveAsPreset = true;
        setAppMainScreen("DabPresetList", false);
    }

    onMenu6Click: {
        console.log("[QML] DABPlayerOptionMenu.qml : All Channel Scan Clicked !!")
        idDabPlayerOptionMenu.hideOptionMenu();
        MDabOperation.CmdReqScan();
    }

    onMenu7Click: {
        console.log("[QML] DABPlayerOptionMenu.qml : Preset Scan Clicked !!")
        idDabPlayerOptionMenu.hideOptionMenu();
        MDabOperation.CmdReqPresetScan();
    }

    onMenu8Click: {
        console.log("[QML] DABPlayerOptionMenu.qml : DAB Setting Clicked !!")
        idDabPlayerOptionMenu.offOptionMenu();
        setAppMainScreen("DabSetting", false);
    }

    onMenu9Click: {
        console.log("[QML] DABPlayerOptionMenu.qml : Sound Setting Clicked !! : inputMode = " +  inputMode)
        var isJogMode;
        if(inputMode == "jog") isJogMode = true
        else if(inputMode == "jog") isJogMode = true        
        MDabOperation.CmdReqSoundSetting(isJogMode);
    }

    onClickMenuKey:
    {
        console.log("[QML] DABPlayerOptionMenu.qml : onClickMenuKey ")
        idDabPlayerOptionMenu.hideOptionMenu()
    }

    onBackKeyPressed:
    {
        console.log("[QML] DABPlayerOptionMenu.qml : onClickMenuKey ")
        idDabPlayerOptionMenu.hideOptionMenu()
    }

    onOptionMenuFinished:
    {
        console.log("[QML] DABPlayerOptionMenu.qml : onOptionMenuFinished  :: visible = " + idDabPlayerOptionMenu.visible)
        if(idDabPlayerOptionMenu.visible)
            idDabPlayerOptionMenu.hideOptionMenu()
    }

    onLeftKeyMenuClose: {
        idDabPlayerOptionMenu.hideOptionMenu()
    }

    Component.onCompleted: {
        menuNameSetting();
    }

    Connections {
        target: UIListener
        onRetranslateUi:
        {
            menuNameSetting();
        }
    }

    // mseok.lee
    Connections {
        target : AppComUIListener
        onRetranslateUi: {
            menuNameSetting();
        }
    }

    Connections {
        target: DABListener
        onListScanningOnChanged:
        {
            console.log("[QML] DABPlayerOptionMenu.qml : onListScanningOnChanged ")
            // menuNameSetting();
            if(m_bListScanningOn)
                idDABMainMenuModel.get(6).name = stringInfo.strPlayerMenu_StopScan;
            else
                idDABMainMenuModel.get(6).name = stringInfo.strPlayerMenu_ScanAllChannels;
        }

        onPresetScanningOnChanged:
        {
            console.log("[QML] DABPlayerOptionMenu.qml : onPresetScanningOnChanged ")
            // menuNameSetting();
            if(m_bPresetScanningOn)
                idDABMainMenuModel.get(7).name = stringInfo.strPlayerMenu_StopScan;
            else
                idDABMainMenuModel.get(7).name = stringInfo.strPlayerMenu_PresetScan;
        }
    }

    function menuNameSetting()
    {
        var data  = {"name" : stringInfo.strPlayerMenu_StationList, "opType":""};
        var data1 = {"name" : stringInfo.strPlayerMenu_PresetList, "opType":""};
        var data2 = {"name" : stringInfo.strPlayerMenu_Text, "opType":""};
        var data3 = {"name" : stringInfo.strPlayerMenu_Image, "opType":""};
        var data4 = {"name" : stringInfo.strPlayerMenu_EPG, "opType":""};
        var data5 = {"name" : stringInfo.strPlayerMenu_SaveAsPreset, "opType":""};

        if(m_bListScanningOn)
            var data6 = {"name" : stringInfo.strPlayerMenu_StopScan, "opType":""};
        else
            var data6 = {"name" : stringInfo.strPlayerMenu_ScanAllChannels, "opType":""};

        if(m_bPresetScanningOn)
            var data7 = {"name" : stringInfo.strPlayerMenu_StopScan, "opType":""};
        else
            var data7 = {"name" : stringInfo.strPlayerMenu_PresetScan, "opType":""};

        var data8 = {"name" : stringInfo.strPlayerMenu_DabSettings, "opType":""};
        var data9 = {"name" : stringInfo.strPlayerMenu_SoundSettings, "opType":""};

        idDABMainMenuModel.clear();
        idDABMainMenuModel.append(data);
        idDABMainMenuModel.append(data1);
        idDABMainMenuModel.append(data2);
        idDABMainMenuModel.append(data3);
        idDABMainMenuModel.append(data4);
        idDABMainMenuModel.append(data5);
        idDABMainMenuModel.append(data6);
        idDABMainMenuModel.append(data7);
        idDABMainMenuModel.append(data8);
        idDABMainMenuModel.append(data9);
    }
}
