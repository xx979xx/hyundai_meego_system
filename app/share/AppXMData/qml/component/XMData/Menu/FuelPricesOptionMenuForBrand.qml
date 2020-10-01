/**
 * FileName: FuelPriceOptionMenuForBrand.qml
 * Author: David.Bae
 * Time: 2012-04-13 15:04
 *
 * - 2012-04-13 Initial Crated by David
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

    signal optinoMenuSortByAtoZ();
    signal optionMenuSortByFranchise();
    signal optionMenuAddFavorite();
    signal optionMenuSearch();
    //signal optionMenuSubcriptionStatus();

    signal menuHided();

    Keys.onPressed: {
        if(idAppMain.isMenuKey(event)){
            console.log("[QML] FuelPriceOptionMenuForBrand.qml Menu Key Pressed")
//            if(idMenu_SortBy.isShowed()){
//                console.log("[QML] FuelPriceOptionMenuForBrand.qml Sub Menu Hide")
//                idMenu_SortBy.hideMenu();
//                idMenu.focus = true;
//                idMenu.forceActiveFocus();
//            }else{
//                //Hide this menu
//                console.log("[QML] FuelPriceOptionMenuForBrand.qml Hide this menu")
//                hideMenu();
//            }
            allHideMenu();//[ITS 187042]
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            console.log("[QML] FuelPriceOptionMenuForBrand.qml Back Key Pressed")
            if(idMenu_SortBy.isShowed()){
                console.log("[QML] FuelPriceOptionMenuForBrand.qml Sub Menu Hide")
                idMenu_SortBy.hideMenu();
                idMenu.focus = true;
                idMenu.forceActiveFocus();
            }else{
                //Hide this menu
                console.log("[QML] FuelPriceOptionMenuForBrand.qml Hide this menu")
                hideMenu();
            }
            event.accepted = true;
        }else{
            console.log("[QML] FuelPriceOptionMenuForBrand.qml Key Pressed")
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
    function allHideMenu(){
        if(!container.focus){return}
        idMenu_SortBy.hideMenu();
        idMenu.hideMenu();
        menuHided();
    }
    function setCurrentSortIndex(currentSortMode){
        for(var nCnt = 0 ; nCnt < idOptionMenuModelForAll_SortBy.count; nCnt++)
        {
            if(idOptionMenuModelForAll_SortBy.get(nCnt).name == currentSortMode)
            {
                idMenu_SortBy.linkedCurrentIndex = (nCnt == 0) ? 1 : 0;;
                idMenu_SortBy.selectedRadioIndex = nCnt;
                break;
            }
        }
    }

    MComp.MOptionMenu{
        id:idMenu
        x:0;y:0
        linkedModels: idOptionMenuModelForAll
        onMenu0Click: {
            //console.log(">>>>>>>>>>>>>  MENU1 Click- Sort by")
            //idMenu_SortBy.titleText = stringInfo.sSTR_XMDATA_SORTBY;
            setCurrentSortIndex(getCurrentOptionSortMode());
            idMenu_SortBy.showMenu();
        } // End Click
//        onMenu1Click: {
//            //console.log(">>>>>>>>>>>>>  MENU2 Click - Add Favorite")
//            container.hideMenu();
//            optionMenuAddFavorite();
//        } // End Click
        onMenu1Click: {
            //console.log(">>>>>>>>>>>>>  MENU2 Click - Search")
            container.hideMenu();
            optionMenuSearch();
        } // End Click

//        onMenu2Click: {
//            console.log(">>>>>>>>>>>>>  MENU3 Click - Add Favorite")
//            optionMenuAddFavorite();
//        } // End Click
//        onMenu3Click: {
//            console.log(">>>>>>>>>>>>>  MENU4 Click - Subscription Status")
//            optionMenuSubcriptionStatus();
//        } // End Click
        onOptionMenuFinished: {
            container.allHideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForAll
        ListElement{name: "Sort By"; opType: "subMenu"}
        ListElement{name: "Search"; opType: ""}
//        ListElement{name: "Add Favorite"; opType: ""}
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
            //console.log(">>>>>>>>>>>>>  MENU1 Click - A to Z")
            container.allHideMenu();
            optinoMenuSortByAtoZ();
        } // End Click
        onMenu1Click: {
            //console.log(">>>>>>>>>>>>>  MENU1 Click - Frachise")
            container.allHideMenu();
            optionMenuSortByFranchise();
        } // End Click
        onRadio0Click: {
            //console.log(">>>>>>>>>>>>>  Radio1 Click - A to Z")
            container.allHideMenu();
            optinoMenuSortByAtoZ();
        }
        onRadio1Click: {
            //console.log(">>>>>>>>>>>>>  Radio2 Click - Frachise")
            container.allHideMenu();
            optionMenuSortByFranchise();
        }
        onOptionMenuFinished: {
            //idMenu_SortBy.hideMenu();
            container.allHideMenu();
        }
        onOptionFinishForSubMenu: {
            hideMenu();
            idMenu.focus = true;
            idMenu.forceActiveFocus();
        }
    }
    ListModel {
        id: idOptionMenuModelForAll_SortBy
        ListElement{name: "A to Z"; opType: "radioBtn"}
        ListElement{name: "Frachise"; opType: "radioBtn"}
    }

    function setModelString(){
        idOptionMenuModelForAll.get(0).name = stringInfo.sSTR_XMDATA_SORTBY
//        idOptionMenuModelForAll.get(1).name = stringInfo.sSTR_XMDATA_ADD_TO_FAVORITE
        idOptionMenuModelForAll.get(1).name = stringInfo.sSTR_XMDATA_SEARCH

        idOptionMenuModelForAll_SortBy.get(0).name = stringInfo.sSTR_XMDATA_ATOZ;
        idOptionMenuModelForAll_SortBy.get(1).name = stringInfo.sSTR_XMDATA_FRANCHISE;
    }

    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }

    Text {
        x:idMenu.x+5; y:idMenu.y+12; id:idFileName
        text:"FuelPricesOptionMenuForBrand.qml";
        color : "white";
        visible: isDebugMode();
    }
    Rectangle{
        id:idDebugInfoView
        z:200
        visible:isDebugMode();
        Column{
            id:idDebugInfo1
            x: 600
            y: -20
        }
    }
}
