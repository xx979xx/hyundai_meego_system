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
    id: idMDeleteMenu
    x: 0; y:0; z: 10

    //****************************** # Item Model #
    linkedModels: ListModel { id : idRadioFavoriteDeleteMenuModel }

    //****************************** # Item Clicked #
    onMenu0Click: {
        console.log(">>>>>>>>>>>>>  Delete")
        XMOperation.onFavoriteDelete();
        idMDeleteMenu.offOptionMenu();
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("XMAudioFavoriteDeleteMenu - BackKey Clicked");
        idMDeleteMenu.hideOptionMenu();
    }
    /* CCP Menu Key */
    onClickMenuKey: {
        console.log("XMAudioFavoriteDeleteMenu - MenuKey Clicked");
        idMDeleteMenu.hideOptionMenu();
    }

    onOptionMenuFinished:{
        console.log("XMAudioFavoriteDeleteMenu - optionMenuFinished() ")
        idMDeleteMenu.hideOptionMenu();
    }

    onLeftKeyMenuClose:{
        console.log("XMAudioFavoriteDeleteMenu - leftKeyMenuClose() ")
        idMDeleteMenu.hideOptionMenu();
    }

    function setDeleteMenuModelString(){
        var data1 = {"name" : stringInfo.sSTR_XMRADIO_DELETE, "opType":""};

        idRadioFavoriteDeleteMenuModel.clear();
        idRadioFavoriteDeleteMenuModel.append(data1);
    }
}
