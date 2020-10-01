/**
 * FileName : DABStationListSubMenu.qml
 * Author: DaeHyungE
 * Time: 2012-07-05
 *
 * - 2012-07-05 Initial Crated by DaeHyungE
 */
import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation

MComp.MOptionMenu {
    id : idDabStationListSubMenu

    menuDepth: "TwoDepth"

    Component.onCompleted: {
        stringNameSetting();
    }

    linkedModels: idDABStationgListSubMenuModel

    ListModel {
        id : idDABStationgListSubMenuModel
    }

    onRadio0Click: {
        console.log("[QML] DABStationListSubMenu.qml : Ensemble")
        idAppMain.optionMenuAllHide();
        reqSortingByEnsemble();
        //gotoStationList();
    }

    onRadio1Click: {
        console.log("[QML] DABStationListSubMenu.qml : Alphabet")
        idAppMain.optionMenuAllHide();
        regSortingByAlphabet();
        //gotoStationList();
    }

    onRadio2Click: {
        console.log("[QML] DABStationListSubMenu.qml : PTY")
        idAppMain.optionMenuAllHide();
        regSortingByPty();       
        // gotoStationList();
    }

    onClickMenuKey: {
        console.log("[QML] DABStationListSubMenu.qml : onClickMenuKey Clicked")
        idAppMain.optionMenuAllHide();
        //gotoBackScreen();
    }

    onBackKeyPressed: {
        console.log("[QML] DABStationListSubMenu.qml : onBackKeyPressed Clicked")
        idAppMain.optionMenuSubClose();
        // gotoBackScreen();
    }    
    onOptionMenuFinished:
    {
        console.log("[QML] DABStationListSubMenu.qml : onOptionMenuFinished ")
        idAppMain.optionMenuAllHide();
        //  if(visible){
        //  gotoBackScreen();
        //  gotoBackScreen();
        //  }
    }

    onLeftKeyMenuClose: {
        idAppMain.optionMenuSubClose();
    }

    //******************************# Connetions
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
    function stringNameSetting() {
        var data  = {"name" : stringInfo.strStationMenu_Ensemble, "opType":"radioBtn"};
        var data1 = {"name" : stringInfo.strStationMenu_Station, "opType":"radioBtn"};
        var data2 = {"name" : stringInfo.strStationMenu_PTY, "opType":"radioBtn"};

        idDABStationgListSubMenuModel.clear();
        idDABStationgListSubMenuModel.append(data);
        idDABStationgListSubMenuModel.append(data1);
        idDABStationgListSubMenuModel.append(data2);
    }
}

