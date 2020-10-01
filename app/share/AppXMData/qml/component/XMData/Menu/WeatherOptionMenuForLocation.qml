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

    signal optionMenuForSearch()
    signal optionMenuForAddFavorite()
    signal optionMenuForReorder()
    signal optionMenuForDelete()
    signal optionMenuForCancelDelete()

    signal menuHided();

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
        if(szMode == "Favorite" && idDeleteFavorite.visible == false)
        {
            if(idMainListLoader.item.listCount == 0)
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
        container.forceActiveFocus();
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
        linkedModels: szMode != "Favorite" ? idOptionMenuModelForLocation : idDeleteFavorite.visible ? idOptionMenuModelForDelete : idOptionMenuModelForFavorite

        onMenu0Click: {
            container.hideMenu();

            if(szMode != "Favorite")
                optionMenuForSearch();
            else if(idDeleteFavorite.visible)
                optionMenuForCancelDelete();
            else
                optionMenuForAddFavorite();
        }
        onMenu1Click: {
            container.hideMenu();

            optionMenuForReorder();
        }
        onMenu2Click: {
            container.hideMenu();

            optionMenuForDelete();
        }

        onOptionMenuFinished: {
            container.hideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForLocation
        ListElement{name: "Search"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForFavorite
        ListElement{name: "Add Favorite"; opType: ""}
        ListElement{name: "Reorder"; opType: ""}
        ListElement{name: "Delete"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForDelete
        ListElement{name: "Cancel Delete"; opType: ""}
    }

    //String
    function setModelString(){
        idOptionMenuModelForLocation.get(0).name = stringInfo.sSTR_XMDATA_SEARCH;

        idOptionMenuModelForFavorite.get(0).name = stringInfo.sSTR_XMDATA_ADDFAVORITE;
        idOptionMenuModelForFavorite.get(1).name = stringInfo.sSTR_XMDATA_CHANGE_ROW
        idOptionMenuModelForFavorite.get(2).name = stringInfo.sSTR_XMDATA_DELETE

        idOptionMenuModelForDelete.get(0).name = stringInfo.sSTR_XMDATA_CANCEL_DELETE;
    }

    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }
}
