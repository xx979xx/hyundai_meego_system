/**
 * FileName: WeatherLocationForCitu.qml
 * Author: jw.park
 * Time: 2012-04-13 11:30
 *
 * - 2012-04-13 Initial Crated by jw.park
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

    signal optionMenuSortByPrice()
    signal optionMenuSortByDistance();
    signal optinoMenuSortByAtoZ();
    signal optionMenuSeeOnTheMap();
    signal optionMenuAddFavorite();
    signal optionMenuSearch();
    signal optionMenuSubcriptionStatus();


    signal menuHided();

    Keys.onPressed: {
        if(idAppMain.isMenuKey(event)){
            console.log("[QML] WeatherLocationForCity.qml Menu Key Pressed")
            if(idMenu_SortBy.isShowed()){
                console.log("[QML] WeatherLocationForCity.qml Sub Menu Hide")
                idMenu_SortBy.hideMenu();
                idMenu.focus = true;
            }else{
                //Hide this menu
                console.log("[QML] WeatherLocationForCity.qml Hide this menu")
                hideMenu();
            }
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            console.log("[QML] WeatherLocationForCity.qml Back Key Pressed")
            if(idMenu_SortBy.isShowed()){
                console.log("[QML] WeatherLocationForCity.qml Sub Menu Hide")
                idMenu_SortBy.hideMenu();
                idMenu.focus = true;
            }else{
                //Hide this menu
                console.log("[QML] WeatherLocationForCity.qml Hide this menu")
                hideMenu();
            }
            event.accepted = true;
        }else{
            console.log("[QML] WeatherLocationForCity.qml Key Pressed")
            event.accepted = true;
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
        idMenu_SortBy.hideMenu();
        idMenu.hideMenu();
        menuHided();
    }

    MComp.MOptionMenu{
        id:idMenu
        x:0;y:0
        linkedModels: idOptionMenuModelForAll
//        onMenu0Click: {
//            console.log(">>>>>>>>>>>>>  MENU1 Click- Sort by")
//            idMenu_SortBy.titleText = stringInfo.sSTR_XMDATA_SORTBY;
//            idMenu_SortBy.showMenu();
//        } // End Click
//        onMenu1Click: {
//            console.log(">>>>>>>>>>>>>  MENU2 Click - See on the Map")
//            optionMenuSeeOnTheMap();
//        } // End Click
        onMenu0Click: {
            console.log(">>>>>>>>>>>>>  MENU0 Click - Add Favorite")
            optionMenuAddFavorite();
        } // End Click
        onMenu1Click: {
            console.log(">>>>>>>>>>>>>  MENU1 Click - Search")
            optionMenuSearch();
            //showNotImplementedYet();
        } // End Click
        onMenu2Click: {
            console.log(">>>>>>>>>>>>>  MENU2 Click - Subscription Status")
            //optionMenuSubcriptionStatus();
        } // End Click

        onOptionMenuFinished: {
            container.hideMenu();
        }

        //No Animation in GUI Guideline
        //Behavior on x { NumberAnimation { duration: 200 } }
        function showOrHide()
        {
            if(isHided()){
                showMenu();
            }else {
                hideMenu();
            }
        }
        function showMenu()
        {
            focus = true;
            x = 0;
        }
        function hideMenu()
        {
            x = systemInfo.lcdWidth;
        }
        function isShowed(){ return x==0; }
        function isHided() { return x==systemInfo.lcdWidth; }
    }
    ListModel {
        id: idOptionMenuModelForAll
//        ListElement{name: "Sort By"; opType: "subMenu"}
//        ListElement{name: "See on the Map"; opType: ""}
        ListElement{name: "Add Favorite"; opType: ""}
        ListElement{name: "Search"; opType: ""}
//        ListElement{name: "Subscription Status"; opType: ""}
    }
    MComp.MOptionMenu{
        id:idMenu_SortBy
        x:0;y:0
        menuDepth: "TwoDepth"
        linkedModels: idOptionMenuModelForAll_SortBy
        parentOptionMenu: idMenu.imgBGForSub
        visible: false
        onMenu0Click: {
            console.log(">>>>>>>>>>>>>  MENU1 Click - Price")
            optionMenuSortByPrice();
        } // End Click
        onMenu1Click: {
            console.log(">>>>>>>>>>>>>  MENU2 Click - Distance")
            optionMenuSortByDistance();
        } // End Click
        onMenu2Click: {
            console.log(">>>>>>>>>>>>>  MENU3 Click - A to Z")
            optinoMenuSortByAtoZ();
        } // End Click

        onRadio0Click: {
            console.log(">>>>>>>>>>>>>  Radio1 Click - Price")
            optionMenuSortByPrice();
        }
        onRadio1Click: {
            console.log(">>>>>>>>>>>>>  Radio2 Click - Distance")
            optionMenuSortByDistance();
        }
        onRadio2Click: {
            console.log(">>>>>>>>>>>>>  Radio3 Click - A to Z")
            optinoMenuSortByAtoZ();
        }

        onOptionMenuFinished:{
            idMenu_SortBy.hideMenu();
        }

        onOptionFinishForSubMenu: {
            hideMenu();
            idMenu.focus = true;
            idMenu.forceActiveFocus();
        }
        //No Animation in GUI Guideline
        //Behavior on x { NumberAnimation { duration: 200 } }
        function showOrHide()
        {
            if(isHided()){
                showMenu();
            }else {
                hideMenu();
            }
        }
        function showMenu()
        {
            focus = true;
            x = 0;
        }
        function hideMenu()
        {
            x = systemInfo.lcdWidth;
        }
        function isShowed(){ return x==0; }
        function isHided() { return x==systemInfo.lcdWidth; }
    }
    ListModel {
        id: idOptionMenuModelForAll_SortBy
        ListElement{name: "Price"; opType: "radioBtn"}
        ListElement{name: "Distance"; opType: "radioBtn"}
        ListElement{name: "A to Z"; opType: "radioBtn"}
    }

    //String
    function setModelString(){
//        idOptionMenuModelForAll.get(0).name = stringInfo.sSTR_XMDATA_SORTBY
//        idOptionMenuModelForAll.get(1).name = stringInfo.sSTR_XMDATA_SEEONTHEMAP
        idOptionMenuModelForAll.get(0).name = stringInfo.sSTR_XMDATA_ADD_TO_FAVORITE
        idOptionMenuModelForAll.get(1).name = stringInfo.sSTR_XMDATA_SEARCH
//        idOptionMenuModelForAll.get(2).name = stringInfo.sSTR_XMDATA_SUBSCRIPTIONSTATUS

//        idOptionMenuModelForAll_SortBy.get(0).name = stringInfo.sSTR_XMDATA_PRICE;
//        idOptionMenuModelForAll_SortBy.get(1).name = stringInfo.sSTR_XMDATA_DISTANCE;
//        idOptionMenuModelForAll_SortBy.get(2).name = stringInfo.sSTR_XMDATA_ATOZ;
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
        text:"WeatherLocationForCity.qml";
        color : "white";
        visible:isDebugMode();
    }
    Rectangle{
        id:idDebugInfoView
        z:200
        visible:isDebugMode()
        Column{
            id:idDebugInfo1
            x: 600
            y: -20
//            Text{text: "[QML Infomation]"; color: "yellow"; }
//            Text{text: "container Focus : " + container.focus; color: "white"; }
//            Text{text: "-idLeftMenuFocusScope Focus : " + idLeftMenuFocusScope.focus; color: "white"; }
//            Text{text: "- idAll Focus : " + idAll.focus; color: "white"; }
//            Text{text: "- idBrand Focus : " + idBrand.focus; color: "white"; }
//            Text{text: "-idMainListFocusScope Focus : " + idMainListFocusScope.focus; color: "white"; }
        }
    }
}
