/**
 * FileName: WeatherRadarOptionMenuForType.qml
 * Author: Park Jae Won
 * Time: 2012-07-03 10:48
 *
 * - 2012-04-13 Initial Crated by David
 */

import Qt 4.7

// System Import
import "../../QML/DH" as MComp

FocusScope{
    id:container

    signal optionMenuAddFavorite()
    signal optionMenuReorder()
    signal optionMenuDelete()
    signal optionMenuCalcelDelete()
    signal menuHided();

    property bool checkDRSStatus: idAppMain.isDRSChange

    Keys.onPressed: {
        if(idAppMain.isMenuKey(event)){
            hideMenu();
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            hideMenu();
            event.accepted = true;
        }else{
            event.accepted = true;
        }
    }
    function showMenu()
    {
        if(szMode == "favorite")
        {
            if(idStoreList.listCount == 0)
            {
                idMenu.menu1Enabled = false;
                idMenu.menu2Enabled = false;
            }else
            {
                idMenu.menu1Enabled = true;
                idMenu.menu2Enabled = true;
            }
        }else
        {
            idMenu.menu0Enabled = true;
            idMenu.menu1Enabled = true;
            idMenu.menu2Enabled = true;
        }

        container.focus = true;
        idMenu.showMenu();
    }
    function hideMenu(){
        if(!container.focus){return}
        idMenu.hideMenu();
        menuHided();
    }


    MComp.MOptionMenu{
        id:idMenu
        x:0;y:0
        linkedModels: szMode == "delete" ? listOptionMenuModelForDelete : listOptionMenuModel;

        onMenu0Click: {
            container.hideMenu();

            if(szMode == "delete")
                optionMenuCalcelDelete();
            else
                optionMenuAddFavorite();
        }
        onMenu1Click: {
            container.hideMenu();

            optionMenuReorder();
        }
        onMenu2Click: {
            container.hideMenu();

            optionMenuDelete();
        }
        onOptionMenuFinished: {
            container.hideMenu();
        }
    }
    ListModel {
        id: listOptionMenuModel
        ListElement{name: "Add Favorite"; opType: ""}
        ListElement{name: "Change Row"; opType: ""}
        ListElement{name: "Delete"; opType: ""}
    }
    ListModel {
        id: listOptionMenuModelForDelete
        ListElement{name: "Cancel Delete"; opType: ""}
    }


    //String
    function setModelString(){
        listOptionMenuModel.get(0).name = stringInfo.sSTR_XMDATA_ADDFAVORITE;
        listOptionMenuModel.get(1).name = stringInfo.sSTR_XMDATA_CHANGE_ROW
        listOptionMenuModel.get(2).name = stringInfo.sSTR_XMDATA_DELETE

        listOptionMenuModelForDelete.get(0).name = stringInfo.sSTR_XMDATA_CANCEL_DELETE;
    }

    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }

    onCheckDRSStatusChanged: {
        if(checkDRSStatus == true && idMenu.visible)
        {
            container.hideMenu();
        }
    }
}
