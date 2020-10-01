/**
 * FileName: FuelPriceOptionMenuForFavorite.qml
 * Author: David.Bae
 * Time: 2012-04-24 21:20
 *
 * - 2012-04-24 Initial Crated by David
 */

import Qt 4.7

import "../../QML/DH" as MComp

FocusScope{
    id:container

    property alias optionMenu: idMenu
    property bool menuForDelete: false
    property bool getIsNaviOnRoute: interfaceManager.isOnRoute();

    signal optionMenuSortByPrice()
    signal optionMenuSortByDistance();
    signal optinoMenuSortByAtoZ();
    signal optionMenuDelete();
    signal optionMenuCancelDelete();
    signal optionMenuAddFavorite();

    signal menuHided();

    Keys.onPressed: {
        if(idAppMain.isMenuKey(event)){
            console.log("[QML] FuelPriceOptionMenuForFavorite.qml Menu Key Pressed")
            allHideMenu();//[ITS 187042]
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            console.log("[QML] FuelPriceOptionMenuForFavorite.qml Back Key Pressed")
            //Hide this menu
            console.log("[QML] FuelPriceOptionMenuForFavorite.qml Hide this menu")
            hideMenu();
            event.accepted = true;
        }else{
            console.log("[QML] FuelPriceOptionMenuForBrand.qml Key Pressed")
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
        linkedModels: menuForDelete ? idOptionMenuModelForDelete: idOptionMenuModelForAll
        onMenu0Click: {
            if(menuForDelete)
            {
                container.allHideMenu();
                optionMenuCancelDelete();
            }else
            {
                container.allHideMenu();
                optionMenuAddFavorite();
            }
        }
        onMenu1Click: {
            container.allHideMenu();
            optionMenuDelete();
        }
        onOptionMenuFinished: {
            container.allHideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForAll
        ListElement{name: "Add Favorite"; opType: ""}
        ListElement{name: "Delete"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForDelete
        ListElement{name: "Cancel Delete"; opType: ""}
    }
    function setModelString(){
        idOptionMenuModelForAll.get(0).name = stringInfo.sSTR_XMDATA_ADDFAVORITE
        idOptionMenuModelForAll.get(1).name = stringInfo.sSTR_XMDATA_DELETE

        idOptionMenuModelForDelete.get(0).name = stringInfo.sSTR_XMDATA_CANCEL_DELETE;
    }

    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }

    Text {
        x:idMenu.x+5; y:idMenu.y+12; id:idFileName
        text:"FuelPricesOptionMenuForFavorite.qml";
        color : "white";
        visible: isDebugMode();
    }
}
