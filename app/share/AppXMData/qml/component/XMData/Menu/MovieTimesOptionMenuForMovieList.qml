/**
 * FileName: MovieTimesOptionMenuForMovieList.qml
 * Author: David.Bae
 * Time: 2012-04-17 15:01
 *
 * - 2012-04-17 Initial Crated by David
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

    signal optionMenuSortByAtoZ()
    signal optionMenuSortByNC_17() //No One 17 and under Admitted.
    signal optionMenuSortByR();    //Restricted, Under 17 Requires Accompanying parent Or Adult Guardian
    signal optionMenuSortByPG_13();//Parents Strongly Cautioned. Some Material May be Inappropriate for childer Under 13
    signal optionMenuSortByPG();   //Parental Guidance Suggested. Some Material May not be Suitable For childer
    signal optionMenuSortByG();    //General Audiences-All Ages Admitted.

//    signal optionMenuSortByStartingTime();
//    signal optionMenuSortByDistance();

    signal optionMenuSubcriptionStatus();
    signal menuHided();

    property bool checkDRSStatus: idAppMain.isDRSChange

    Keys.onPressed: {
        if(idAppMain.isMenuKey(event)){
            console.log("[QML] MovieTimesOptionMenuForMovieList.qml Menu Key Pressed")
//            if(idMenu_SortBy.isShowed()){
//                console.log("[QML] MovieTimesOptionMenuForMovieList.qml Sub Menu Hide")
//                idMenu_SortBy.hideMenu();
//                idMenu.focus = true;
//                idMenu.forceActiveFocus();
//            }else{
//                //Hide this menu
//                console.log("[QML] MovieTimesOptionMenuForMovieList.qml Hide this menu")
//                hideMenu();
//            }
            allHideMenu();//[ITS 187042]
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            console.log("[QML] MovieTimesOptionMenuForMovieList.qml Back Key Pressed")
            if(idMenu_SortBy.isShowed()){
                console.log("[QML] MovieTimesOptionMenuForMovieList.qml Sub Menu Hide")
                idMenu_SortBy.hideMenu();
                idMenu.focus = true;
                idMenu.forceActiveFocus();
            }else{
                //Hide this menu
                console.log("[QML] MovieTimesOptionMenuForMovieList.qml Hide this menu")
                hideMenu();
            }
            event.accepted = true;
        }else{
            console.log("[QML] MovieTimesOptionMenuForMovieList.qml Key Pressed")
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
            //idMenu_SortBy.titleText = stringInfo.sSTR_XMDATA_SORTBY;
            setCurrentSortIndex(getCurrentOptionSortMode());
            idMenu_SortBy.showMenu();
        } // End Click
        onMenu1Click: {
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
    }
    MComp.MOptionMenu{
        id:idMenu_SortBy
        x:0;y:0
        menuDepth: "TwoDepth"
        //titleText : stringInfo.sSTR_XMDATA_SORTBY
        linkedModels: idOptionMenuModelForTwoDepth
        parentOptionMenu: idMenu.imgBGForSub
        visible: false
        onRadio0Click: {
            //console.log(">>>>>>>>>>>>>  Radio1 Click - A to Z")
            container.allHideMenu();
            optionMenuSortByAtoZ();
        } // End Click
        onRadio1Click: {
            //console.log(">>>>>>>>>>>>>  Radio1 Click - NC_17")
            container.allHideMenu();
            optionMenuSortByNC_17();//No One 17 and under Admitted.
        } // End Click
        onRadio2Click: {
            //console.log(">>>>>>>>>>>>>  Radio2 Click - R")
            container.allHideMenu();
            optionMenuSortByR();//Restricted, Under 17 Requires Accompanying parent Or Adult Guardian
        } // End Click
        onRadio3Click: {
            //console.log(">>>>>>>>>>>>>  Radio3 Click - PG_13")
            container.allHideMenu();
            optionMenuSortByPG_13();//Parents Strongly Cautioned. Some Material May be Inappropriate for childer Under 13
        } // End Click

        onRadio4Click: {
            //console.log(">>>>>>>>>>>>>  Radio4 Click - PG")
            container.allHideMenu();
            optionMenuSortByPG();//Parental Guidance Suggested. Some Material May not be Suitable For childer
        }
        onRadio5Click: {
            //console.log(">>>>>>>>>>>>>  Radio5 Click - G")
            container.allHideMenu();
            optionMenuSortByG();//General Audiences-All Ages Admitted.
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
        id: idOptionMenuModelForTwoDepth
        ListElement{name: "A to Z"; opType: "radioBtn"}
        ListElement{name: "NC-17";  opType: "radioBtn"}//No One 17 and under Admitted.
        ListElement{name: "R";      opType: "radioBtn"}//Restricted, Under 17 Requires Accompanying parent Or Adult Guardian
        ListElement{name: "PG-13";  opType: "radioBtn"}//Parents Strongly Cautioned. Some Material May be Inappropriate for childer Under 13
        ListElement{name: "PG";     opType: "radioBtn"}//Parental Guidance Suggested. Some Material May not be Suitable For childer
        ListElement{name: "G";      opType: "radioBtn"}//General Audiences-All Ages Admitted.
    }

    //String Translation
    function setModelString(){
        idOptionMenuModelForOneDepth.get(0).name = stringInfo.sSTR_XMDATA_SORTBY
//        idOptionMenuModelForOneDepth.get(1).name = stringInfo.sSTR_XMDATA_SUBSCRIPTIONSTATUS

        idOptionMenuModelForTwoDepth.get(0).name = stringInfo.sSTR_XMDATA_ATOZ;
        idOptionMenuModelForTwoDepth.get(1).name = stringInfo.sSTR_XMDATA_NC_17;
        idOptionMenuModelForTwoDepth.get(2).name = stringInfo.sSTR_XMDATA_R;
        idOptionMenuModelForTwoDepth.get(3).name = stringInfo.sSTR_XMDATA_PG_13;
        idOptionMenuModelForTwoDepth.get(4).name = stringInfo.sSTR_XMDATA_PG;
        idOptionMenuModelForTwoDepth.get(5).name = stringInfo.sSTR_XMDATA_G;
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
        text:"MovieTimesOptionMenuForMovieList.qml";
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
