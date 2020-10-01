/**
 * FileName: RadioOptionMenu.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MOptionMenu{
    id: idMEpgMenu
    x: 0; y:0; z: 10

    property string szEpgChnID : ""

    //****************************** # Item Model #
    linkedModels: ListModel { id : idRadioEPGMenuModel }

    //****************************** # Item Clicked #
    onMenu0Click: {
        console.log(">>>>>>>>>>>>>  Now Listening")
        XMOperation.setPreviousScanStop();
        idMEpgMenu.offOptionMenu()
        setAppMainScreen("AppRadioMain", false);
    }
    onMenu1Click: {
        console.log(">>>>>>>>>>>>>  Category list")
        idMEpgMenu.offOptionMenu()
        XMOperation.onEPGCategoryMode();
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("XMAudioEPGMenu - BackKey Clicked");
        idMEpgMenu.hideOptionMenu();
    }
    /* CCP Menu Key */
    onClickMenuKey: {
        console.log("XMAudioEPGMenu - MenuKey Clicked");
        idMEpgMenu.hideOptionMenu();
    }

    onOptionMenuFinished:{
        console.log("XMAudioEPGMenu - optionMenuFinished() ")
        idMEpgMenu.hideOptionMenu();
    }

    onLeftKeyMenuClose:{
        console.log("XMAudioEPGMenu - leftKeyMenuClose() ")
        idMEpgMenu.hideOptionMenu();
    }

    function setEPGMenuModelString(){
        var data1 = {"name" : stringInfo.sSTR_XMRADIO_NOW_LISTENING, "opType":""};
        var data2 = {"name" : stringInfo.sSTR_XMRADIO_CATEGORY_LIST, "opType":""};

        idRadioEPGMenuModel.clear();
        idRadioEPGMenuModel.append(data1);
        idRadioEPGMenuModel.append(data2);
    }
}
