/**
 * FileName: SportsOptionMenuForFavorite.qml
 * Author: David.Bae
 * Time: 2012-06-04 21:20
 *
 * - 2012-06-04 Initial Crated by David
 */

import Qt 4.7

// System Import
import "../../QML/DH" as MComp
// Local Import
import "../Menu" as MMenu
import "../ListElement" as MListElement

FocusScope{
    id:container
    z: parent.z + 1

    property alias optionMenu: idMenu
    property bool menuForDelete: false

    signal optionMenuSearch();
    signal optionMenuReorder();
    signal optionMenuDelete();
    signal optionMenuCancelDelete();
    signal menuHided();

    property bool checkDRSStatus: idAppMain.isDRSChange

    Keys.onPressed: {
        if(idAppMain.isMenuKey(event)){
            //Hide this menu
            console.log("[QML] SportsOptionMenuForFavorite.qml Hide this menu")
            hideMenu();
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            //Hide this menu
            console.log("[QML] SportsOptionMenuForFavorite.qml Hide this menu")
            hideMenu();
            event.accepted = true;
        }else{
            console.log("[QML] SportsOptionMenuForFavorite.qml Key Pressed")
        }
    }
    function showMenu()
    {
        container.focus = true;
        idMenu.showMenu();
    }
    function hideMenu(){
        if(!container.focus){return}
        idMenu.hideMenu();
        menuHided();
    }
    function allHideMenu(){
        if(!container.focus){return}
        idMenu.hideMenu();
        menuHided();
    }

    MComp.MOptionMenu{
        id:idMenu
        x:0;y:0
        linkedModels: menuForDelete? idOptionMenuModelForDelete : idOptionMenuModelForAll
        onMenu0Click: {
            //console.log(">>>>>>>>>>>>>  MENU1 Click- Change Row")
            container.hideMenu()
            if(menuForDelete)
                optionMenuCancelDelete();
            else
                optionMenuSearch();
        } // End Click

        onMenu1Click: {
            container.hideMenu()
            optionMenuReorder();
        }

        onMenu2Click: {
            //console.log(">>>>>>>>>>>>>  MENU2 Click - Delete")
            container.hideMenu()
            optionMenuDelete();
        } // End Click
        onOptionMenuFinished: {
            container.allHideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForAll
        ListElement{name: "Add Favorite"; opType: ""}
        ListElement{name: "Reorder"; opType: ""}
        ListElement{name: "Delete"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForDelete
        ListElement{name: "Cancel Delete"; opType: ""}
    }

    function setModelString(){
        idOptionMenuModelForAll.get(0).name = stringInfo.sSTR_XMDATA_ADDFAVORITE
        idOptionMenuModelForAll.get(1).name = stringInfo.sSTR_XMDATA_CHANGE_ROW
        idOptionMenuModelForAll.get(2).name = stringInfo.sSTR_XMDATA_DELETE

        idOptionMenuModelForDelete.get(0).name = stringInfo.sSTR_XMDATA_CANCEL_DELETE;
    }

    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }

    Text {
        x:idMenu.x+5; y:idMenu.y+12; id:idFileName
        text:"SportsOptionMenuForFavorite.qml";
        color : "white";
        visible: isDebugMode();
    }

    onCheckDRSStatusChanged: {
        if(checkDRSStatus == true && idMenu.visible)
        {
            container.hideMenu();
        }
    }
}
