/**
 * FileName: SportsOptionMenuForAllLeague.qml
 * Author: David.Bae
 * Time: 2012-06-04 15:15
 *
 * - 2012-06-04 Initial Crated by David
 */

import Qt 4.7

// System Import
import "../../QML/DH" as MComp
// Local Import
import "../Menu" as MMenu
import "../ListElement" as MListElement
import "../Common" as MCommon

FocusScope{
    id:container
    z: parent.z + 1

    MCommon.StringInfo {id:stringInfo}

    signal optionMenuSchedule();
    signal optionMenuNewsItem();
    signal optionMenuGoToSXMRadio();
    signal optionMenuSelectDate();
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
            console.log("[QML] SportsOptionMenuForAllLeague.qml Key Pressed")
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
        linkedModels: viewMode == 0 ? idOptionMenuModelForAllForScore : viewMode == 1 ? idOptionMenuModelForAllForOther : idOptionMenuModelForAllForRankedList//viewMode == 2 ? idOptionMenuModelForAllForRankedList : viewMode == 0 ? idOptionMenuModelForAllForScore : idOptionMenuModelForAllForOther
        onMenu0Click: {
            container.hideMenu()
            optionMenuSchedule();
        } // End Click
        onMenu1Click: {
            container.hideMenu()
            optionMenuNewsItem();
        } // End Click
        onMenu2Click: {
            optionMenuGoToSXMRadio();
        } // End Click
        onOptionMenuFinished: {
            container.allHideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForAllForScore
        ListElement{name: "Schedule"; opType: ""}
        ListElement{name: "News Item"; opType: ""}
        ListElement{name: "Go to SXM Radio"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForAllForOther
        ListElement{name: "Score" ; opType: ""}
        ListElement{name: "News Item"; opType: ""}
        ListElement{name: "Go to SXM Radio"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForAllForRankedList
        ListElement{name: "News Item"; opType: ""}
        ListElement{name: "Go to SXM Radio"; opType: ""}
    }

    function setModelString(){
        idOptionMenuModelForAllForScore.get(0).name = stringInfo.sSTR_XMDATA_SPORTS_SCHEDULE//stringInfo.sSTR_XMDATA_ADD_TO_FAVORITE
        idOptionMenuModelForAllForScore.get(1).name = stringInfo.sSTR_XMDATA_SPORTS_NEWS_ITEM
        idOptionMenuModelForAllForScore.get(2).name = stringInfo.sSTR_XMDATA_MENU_GOTOSXMRADIO

        idOptionMenuModelForAllForOther.get(0).name = stringInfo.sSTR_XMDATA_SPORTS_SCORE
        idOptionMenuModelForAllForOther.get(1).name = stringInfo.sSTR_XMDATA_SPORTS_NEWS_ITEM
        idOptionMenuModelForAllForOther.get(2).name = stringInfo.sSTR_XMDATA_MENU_GOTOSXMRADIO

        idOptionMenuModelForAllForRankedList.get(0).name = stringInfo.sSTR_XMDATA_SPORTS_NEWS_ITEM
        idOptionMenuModelForAllForRankedList.get(1).name = stringInfo.sSTR_XMDATA_MENU_GOTOSXMRADIO
    }

    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }

    Text {
        x:idMenu.x+5; y:idMenu.y+12; id:idFileName
        text:"SportsOptionMenuForAllLeague.qml";
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
