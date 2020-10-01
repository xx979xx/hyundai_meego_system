/**
 * FileName: FuelPriceOptionMenuForAll.qml
 * Author: David.Bae
 * Time: 2012-04-13 11:30
 *
 * - 2012-04-13 Initial Crated by David
 */

import Qt 4.7

// System Import
import "../../QML/DH" as MComp
// Local Import
import "../Menu" as MMenu
import "../ListElement" as MListElement

// Because Loader is a focus scope, converted from FocusScope to Item.
//Item {
FocusScope{
    id:container
    z: parent.z + 1

    signal optionMenuSortByPrice()
    signal optionMenuSortByDistance();
    signal optinoMenuSortByAtoZ();
    signal optionMenuSortByOnRoute();
    signal optionMenuSearch();
    signal optionMenuSubcriptionStatus();

    signal menuHided();

    property bool getIsNaviOnRoute: interfaceManager.isOnRoute();

    Keys.onPressed: {
        if(idAppMain.isMenuKey(event)){
            console.log("[QML] FuelPriceOptionMenuForAll.qml Menu Key Pressed")
//            if(idMenu_SortBy.isShowed()){
//                console.log("[QML] FuelPriceOptionMenuForAll.qml Sub Menu Hide")
//                idMenu_SortBy.hideMenu();
//                idMenu.focus = true;
//                idMenu.forceActiveFocus();
//            }else{
//                //Hide this menu
//                console.log("[QML] FuelPriceOptionMenuForAll.qml Hide this menu")
//                hideMenu();
//            }
            allHideMenu();//[ITS 187042]
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            console.log("[QML] FuelPriceOptionMenuForAll.qml Back Key Pressed")
            if(idMenu_SortBy.isShowed()){
                console.log("[QML] FuelPriceOptionMenuForAll.qml Sub Menu Hide")
                idMenu_SortBy.hideMenu();
                idMenu.focus = true;
                idMenu.forceActiveFocus();
            }else{
                //Hide this menu
                console.log("[QML] FuelPriceOptionMenuForAll.qml Hide this menu")
                hideMenu();
            }
            event.accepted = true;
        }else{
            console.log("[QML] FuelPriceOptionMenuForAll.qml Key Pressed")
        }
    }
    function showMenu()
    {
        container.focus = true;
        if(idMenu_SortBy.isShowed())
        {
            idMenu_SortBy.showOrHide();
        }
        idMenu.showMenu();
    }
    function hideMenu(){
        if(!container.focus){return}
        if(idMenu_SortBy.isShowed())
            idMenu_SortBy.hideMenu();
        else{
            idMenu.hideMenu();
            menuHided();
        }
    }
    function allHideMenu(){
        if(!container.focus){return}
        idMenu_SortBy.hideMenu();
        idMenu.hideMenu();
        menuHided();
    }
    function setCurrentSortIndex(currentSortMode){
        for(var nCnt = 0 ; nCnt < idOptionMenuModelForAll_SortByForOnRoute.count; nCnt++)
        {
            if(idOptionMenuModelForAll_SortByForOnRoute.get(nCnt).name == currentSortMode)
            {
                idMenu_SortBy.linkedCurrentIndex = (nCnt == 0) ? 1 : 0;
                idMenu_SortBy.selectedRadioIndex = nCnt;
                break;
            }
        }
    }

    MComp.MOptionMenu{
        id:idMenu
        x:0;y:0
        linkedModels: idOptionMenuModelForAll
        visible: true

        onMenu0Click: {
            console.log(">>>>>>>>>>>>>  MENU1 Click- Sort by")
            setCurrentSortIndex(getCurrentOptionSortMode());
            getIsNaviOnRoute = interfaceManager.isOnRoute();
            idMenu_SortBy.showMenu();
        } // End Click
        onMenu1Click: {
            console.log(">>>>>>>>>>>>>  MENU4 Click - Search")
            container.hideMenu();
            optionMenuSearch();
        } // End Click
        onOptionMenuFinished: {
            container.allHideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForAll
        ListElement{name: "Sort By"; opType: "subMenu"}
        ListElement{name: "Search"; opType: ""}
    }
    MComp.MOptionMenu{
        id:idMenu_SortBy
        x:0;y:0

        parentOptionMenu: idMenu.imgBGForSub
        menuDepth: "TwoDepth"
        linkedModels: idOptionMenuModelForAll_SortByForOnRoute
        menu3Enabled: interfaceManager.isMountedMMC && getIsNaviOnRoute
        visible: false

        onMenu0Click: {
            //console.log(">>>>>>>>>>>>>  MENU0 Click - Distance")
            container.allHideMenu();
            optionMenuSortByDistance();
        } // End Click
        onMenu1Click: {
            //console.log(">>>>>>>>>>>>>  MENU1 Click - Price")
            container.allHideMenu();
            optionMenuSortByPrice();
        } // End Click
        onMenu2Click: {
            //console.log(">>>>>>>>>>>>>  MENU2 Click - A to Z")
            container.allHideMenu();
            optinoMenuSortByAtoZ();
        } // End Click
        onMenu3Click: {
            container.allHideMenu();
            optionMenuSortByOnRoute();
        }

        onRadio0Click: {
            //console.log(">>>>>>>>>>>>>  Radio0 Click - Distance")
            container.allHideMenu();
            optionMenuSortByDistance();
        }
        onRadio1Click: {
            //console.log(">>>>>>>>>>>>>  Radio1 Click - Price")
            container.allHideMenu();
            optionMenuSortByPrice();
        }

        onRadio2Click: {
            //console.log(">>>>>>>>>>>>>  Radio2 Click - A to Z")
            container.allHideMenu();
            optinoMenuSortByAtoZ();
        }

        onRadio3Click: {
            container.allHideMenu();
            optionMenuSortByOnRoute();
        }

        onOptionMenuFinished:{
            container.allHideMenu();
        }

        onOptionFinishForSubMenu: {
            hideMenu();
            idMenu.focus = true;
            idMenu.forceActiveFocus();
        }
    }
    ListModel {
        id: idOptionMenuModelForAll_SortByForOnRoute
        ListElement{name: "Distance"; opType: "radioBtn"}
        ListElement{name: "Price"; opType: "radioBtn"}
        ListElement{name: "A to Z"; opType: "radioBtn"}
        ListElement{name: "On Route"; opType: "radioBtn"}
    }

    //String
    function setModelString(){
        idOptionMenuModelForAll.get(0).name = stringInfo.sSTR_XMDATA_SORTBY
        idOptionMenuModelForAll.get(1).name = stringInfo.sSTR_XMDATA_SEARCH

        idOptionMenuModelForAll_SortByForOnRoute.get(0).name = stringInfo.sSTR_XMDATA_DISTANCE;
        idOptionMenuModelForAll_SortByForOnRoute.get(1).name = stringInfo.sSTR_XMDATA_PRICE;
        idOptionMenuModelForAll_SortByForOnRoute.get(2).name = stringInfo.sSTR_XMDATA_ATOZ;
        idOptionMenuModelForAll_SortByForOnRoute.get(3).name = stringInfo.sSTR_XMDATA_ON_ROUTE;

    }

    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }

    //Debug Information
    Text {
        x:idMenu.x+5; y:idMenu.x+12+10; id:idFileName
        text:"FuelPricesOptionMenuForAll.qml";
        color : "white";
        visible:isDebugMode();
    }
}
