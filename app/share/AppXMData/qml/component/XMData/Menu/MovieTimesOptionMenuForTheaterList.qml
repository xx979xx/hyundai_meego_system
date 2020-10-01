/**
 * FileName: MovieTimesOptionMenuForTheaterListTheaterList.qml
 * Author: David.Bae
 * Time: 2012-04-17 17:32
 *
 * - 2012-04-17 Initial Crated by David
 */

import Qt 4.7

// System Import
import "../../QML/DH" as MComp

// Local Import
import "../Common" as XMCommon

FocusScope{
    id:container
    z: parent.z + 1

    XMCommon.StringInfo {id:stringInfo}

    signal optionMenuSortByDistance();
    signal optionMenuSortByAtoZ();
//    signal optionMenuSortByOnRoute();

    signal optionMenuAddFavorite();
    signal optionMenuSubcriptionStatus();
    signal menuHided();

    property bool checkDRSStatus: idAppMain.isDRSChange

    Keys.onPressed: {
        if(idAppMain.isMenuKey(event)){
            console.log("[QML] MovieTimesOptionMenuForTheaterList.qml Menu Key Pressed")
//            if(idMenu_SortBy.isShowed()){
//                console.log("[QML] MovieTimesOptionMenuForTheaterList.qml Sub Menu Hide")
//                idMenu_SortBy.hideMenu();
//                idMenu.focus = true;
//                idMenu.forceActiveFocus();
//            }else{
//                //Hide this menu
//                console.log("[QML] MovieTimesOptionMenuForTheaterList.qml Hide this menu")
//                hideMenu();
//            }
            allHideMenu();//[ITS 187042]
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            console.log("[QML] MovieTimesOptionMenuForTheaterList.qml Back Key Pressed")
            if(idMenu_SortBy.isShowed()){
                console.log("[QML] MovieTimesOptionMenuForTheaterList.qml Sub Menu Hide")
                idMenu_SortBy.hideMenu();
                idMenu.focus = true;
                idMenu.forceActiveFocus();
            }else{
                //Hide this menu
                console.log("[QML] MovieTimesOptionMenuForTheaterList.qml Hide this menu")
                hideMenu();
            }
            event.accepted = true;
        }else{
            console.log("[QML] MovieTimesOptionMenuForTheaterList.qml Key Pressed")
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
        for(var nCnt = 0 ; nCnt < idOptionMenuModelForTwoDepth.count; nCnt++)
        {
            if(idOptionMenuModelForTwoDepth.get(nCnt).name == currentSortMode)
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
        linkedModels: idOptionMenuModelForOneDepth
        onMenu0Click: {
            console.log(">>>>>>>>>>>>>  MENU1 Click- Sort by")
            setCurrentSortIndex(getCurrentOptionSortMode());
            idMenu_SortBy.showMenu();
        } // End Click
        onMenu1Click: {
            console.log(">>>>>>>>>>>>>  MENU5 Click - Subscription Status")
            container.hideMenu();
            optionMenuAddFavorite();
        } // End Click
        onMenu2Click: {
            console.log(">>>>>>>>>>>>>  MENU5 Click - Subscription Status")
            container.hideMenu();
            optionMenuSubcriptionStatus();
        } // End Click

        onOptionMenuFinished: {
            container.allHideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForOneDepth
        ListElement{name: "Sort By"; opType: "subMenu"}
        ListElement{name: "Search"; opType: ""}
    }
    MComp.MOptionMenu{
        id:idMenu_SortBy
        x:0;y:0
        property alias linkModel: idMenu_SortBy.linkedModels
        parentOptionMenu: idMenu.imgBGForSub
        menuDepth: "TwoDepth"
        linkedModels: idOptionMenuModelForTwoDepth
        visible: false
        onRadio0Click: {
            container.allHideMenu();
            optionMenuSortByDistance();
        }
        onRadio1Click: {
            container.allHideMenu();
            optionMenuSortByAtoZ();
        }

        onOptionMenuFinished: {
            container.allHideMenu();
        }
        onOptionFinishForSubMenu: {
            hideMenu();
            idMenu.focus = true;
            idMenu.forceActiveFocus();
        }
    }
    ListModel {
        id: idOptionMenuModelForTwoDepth
        ListElement{name: "Distance";  opType: "radioBtn"}
        ListElement{name: "A - Z";      opType: "radioBtn"}
//        ListElement{name: "On Route"; opType: "radioBtn"}
    }

    function setModelString(){
        idOptionMenuModelForOneDepth.get(0).name = stringInfo.sSTR_XMDATA_SORTBY
        idOptionMenuModelForOneDepth.get(1).name = stringInfo.sSTR_XMDATA_SEARCH

        idOptionMenuModelForTwoDepth.get(0).name = stringInfo.sSTR_XMDATA_DISTANCE;
        idOptionMenuModelForTwoDepth.get(1).name = stringInfo.sSTR_XMDATA_ATOZ;
//        idOptionMenuModelForTwoDepth.get(2).name = stringInfo.sSTR_XMDATA_ON_ROUTE;
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
        text:"MovieTimesOptionMenuForTheaterList.qml";
        color : "white";
        visible:isDebugMode();
    }

    onCheckDRSStatusChanged: {
        if(checkDRSStatus == true && (idMenu.visible || idMenu_SortBy.visible))
        {
            container.allHideMenu();
        }
    }
}
