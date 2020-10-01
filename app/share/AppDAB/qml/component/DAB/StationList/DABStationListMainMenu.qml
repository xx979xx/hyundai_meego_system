/**
 * FileName: DABStationList_MainMenu.qml.qml
 * Author: DaeHyungE
 * Time: 2012-07-04
 *
 * - 2012-07-04 Initial Crated by HyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MOptionMenu {
    id : idDabStationListMainMenu

    Component.onCompleted: {
        console.log("[QML] DABStationList_MainMenu.qml : Component.onCompleted")
        stringNameSetting();
    }   

    linkedModels: idDABStationListMenuModel

    ListModel {
        id : idDABStationListMenuModel
    }

    onMenu0Click: {
        console.log("[QML] DABStationListMainMenu.qml : New Listening Clicked")
        idDabStationListMainMenu.offOptionMenu();
        gotoMainScreen()
    }

    onMenu1Click: {
        console.log("[QML] DABStationListMainMenu.qml : Sort by Clicked")
        setAppMainScreen("DabStationListSubMenu", true);
        idAppMain.optionMenuSubOpen();
    }

    onClickMenuKey:
    {
        console.log("[QML] DABStationListMainMenu.qml : onClickMenuKey ")
        idDabStationListMainMenu.hideOptionMenu()
    }

    onBackKeyPressed:
    {
        console.log("[QML] DABPlayerOptionMenu.qml : onClickMenuKey ")
        idDabStationListMainMenu.hideOptionMenu()
    }

    onOptionMenuFinished:
    {
        console.log("[QML] DABStationListMainMenu.qml : onOptionMenuFinished ")
        idDabStationListMainMenu.hideOptionMenu()
    }

    onLeftKeyMenuClose: {
         idDabStationListMainMenu.hideOptionMenu()
    }

    onRightKeySubMenuOpen: {
        setAppMainScreen("DabStationListSubMenu", true);     
        idAppMain.optionMenuSubOpen();
    }


    //******************************# Connections
    Connections {
        target: UIListener
        onRetranslateUi:
        {
            console.log("[QML] DABStationList.qml : onRetranslateUi");
            stringNameSetting();
        }
    }

    // mseok.lee
    Connections {
        target : AppComUIListener
        onRetranslateUi: {
            console.log("[QML] DABStationList.qml : AppComUIListener::onRetranslateUi");
            stringNameSetting();
        }
    }

    //******************************# Funciton
    function stringNameSetting()
    {
        var data  = {"name" : stringInfo.strStationMenu_NowListening, "opType":""};
        var data1 = {"name" : stringInfo.strStationMenu_SortBy, "opType":"subMenu"};

        idDABStationListMenuModel.clear();
        idDABStationListMenuModel.append(data);
        idDABStationListMenuModel.append(data1);
    }
}
