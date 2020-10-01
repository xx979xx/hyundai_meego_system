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
    z: parent.z + 1

    property alias optionMenu: idMenu

    signal optionMenuSetPrioritizationLevels(int level);
    signal optionMenuSetMarineCoastalZone(bool onoff);
    signal optionMenuSetRange(int range);
    signal optionMenuShowPopup(bool onoff);

    signal menuHided();

    property int levels: 0
    property int ranges: 50

    Keys.onPressed: {
        if(idAppMain.isMenuKey(event)){
//            if(idMenu_SetPriority.isShowed()){
//                console.log("[QML] idOptionMenuForSecurityNAlerts.qml Sub Menu(set pri) Hide")
//                idMenu_SetPriority.hideMenu();
//                idMenu.focus = true;
//                idMenu.forceActiveFocus();
//            }else if(idMenu_SetRange.isShowed()){
//                console.log("[QML] idOptionMenuForSecurityNAlerts.qml Sub Menu(set range) Hide")
//                idMenu_SetRange.hideMenu();
//                idMenu.focus = true;
//                idMenu.forceActiveFocus();
//            }else if(idMenu_SetZone.isShowed()){
//                idMenu_SetZone.hideMenu();
//                idMenu.focus = true;
//                idMenu.forceActiveFocus();
//            }else {
//                //Hide this menu
//                console.log("[QML] idOptionMenuForSecurityNAlerts.qml Hide this menu")
//                hideMenu();
//            }
            console.log("[QML] idOptionMenuForSecurityNAlerts.qml Hide this menu")
            hideMenu();//[ITS 187042]
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            if(idMenu_SetPriority.isShowed()){
                console.log("[QML] idOptionMenuForSecurityNAlerts.qml Sub Menu(set pri) Hide")
                idMenu_SetPriority.hideMenu();
                idMenu.focus = true;
                idMenu.forceActiveFocus();
            }else if(idMenu_SetRange.isShowed()){
                console.log("[QML] idOptionMenuForSecurityNAlerts.qml Sub Menu(set range) Hide")
                idMenu_SetRange.hideMenu();
                idMenu.focus = true;
                idMenu.forceActiveFocus();
            }/*else if(idMenu_SetZone.isShowed()){
                idMenu_SetZone.hideMenu();
                idMenu.focus = true;
                idMenu.forceActiveFocus();
            }*/else {
                //Hide this menu
                console.log("[QML] idOptionMenuForSecurityNAlerts.qml Hide this menu")
                hideMenu();
            }
            event.accepted = true;
        }else{
            console.log("[QML] idOptionMenuForSecurityNAlerts.qml Key Pressed")
            event.accepted = true;
        }
    }
    function showMenu()
    {
        container.focus = true;
        setCurrentSortIndex_zone(weatherDataManager.getWSAZone());
        setCurrentSortIndex_showPopup(weatherDataManager.getWSAPopupEnable());
        if(idMenu_SetPriority.isShowed())
        {
            idMenu_SetPriority.showOrHide();
        }
        else if(idMenu_SetRange.isShowed())
        {
            idMenu_SetRange.showOrHide();
        }
//        else if(idMenu_SetZone.isShowed())
//        {
//            idMenu_SetZone.showOrHide();
//        }

        idMenu.showMenu();
    }
    function hideMenu(){
        if(!container.focus){return}
        idMenu_SetPriority.hideMenu();
        idMenu_SetRange.hideMenu();
//        idMenu_SetZone.hideMenu();
        idMenu.hideMenu();
        menuHided();
    }

    MComp.MOptionMenu{
        id:idMenu
        x:0;y:0
        linkedModels: idOptionMenuModelForAll

        onMenu0Click: {
            console.log(">>>>>>>>>>>>>  MENU0 Click - Set Prioritization Levels")
            setCurrentSortIndex_priority(weatherDataManager.getWSAPriorityLevels());
            idMenu_SetPriority.showMenu();
        } // End Click
        onMenu1Click: {
            console.log(">>>>>>>>>>>>>  MENU1 Click - Set Range")
            setCurrentSortIndex_range(weatherDataManager.getWSARange());
            idMenu_SetRange.showMenu();
        } // End Click
//        onMenu2Click: {
//            console.log(">>>>>>>>>>>>>  MENU2 Click - Set Zone")
//            setCurrentSortIndex_zone(weatherDataManager.getWSAZone());
//            idMenu_SetZone.showMenu();
////            optionMenuSetMarineCoastalZone();
//        } // End Click
        onDimCheck2Click: {
            optionMenuSetMarineCoastalZone(true);
            setCurrentSortIndex_zone(weatherDataManager.getWSAZone());
        }
        onDimUncheck2Click: {
            optionMenuSetMarineCoastalZone(false);
            setCurrentSortIndex_zone(weatherDataManager.getWSAZone());
        }
        onDimCheck3Click: {
            optionMenuShowPopup(true);
            setCurrentSortIndex_showPopup(true);
        }
        onDimUncheck3Click: {
            optionMenuShowPopup(false);
            setCurrentSortIndex_showPopup(false);
        }


        onOptionMenuFinished: {
            container.hideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForAll
        ListElement{name: "Set Prioritization Levels"; opType: "subMenu"}
        ListElement{name: "Set Range"; opType: "subMenu"}
        ListElement{name: "Marine/coastal"; opType: "dimCheck"; flagToggle: false}
        ListElement{name: "Show Popup"; opType: "dimCheck"; flagToggle: false}
    }

    //set Pri
    MComp.MOptionMenu{
        id:idMenu_SetPriority
        x:0;y:0
        property alias linkModel: idMenu_SetPriority.linkedModels
        parentOptionMenu: idMenu.imgBGForSub
        menuDepth: "TwoDepth"
        //titleText : stringInfo.sSTR_XMDATA_SORTBY
        linkedModels:idOptionMenuModelForTwoDepth
        visible: false
        onMenu0Click: {
            container.hideMenu();
            levels = 0;
            optionMenuSetPrioritizationLevels(levels);
//            optionMenuSortByDistance();
        } // End Click
        onMenu1Click: {
            container.hideMenu();
            levels = 5;
            optionMenuSetPrioritizationLevels(levels);
        } // End Click
        onMenu2Click: {
            container.hideMenu();
            levels = 7;
            optionMenuSetPrioritizationLevels(levels);
        } // End Click
        onMenu3Click: {
            container.hideMenu();
            levels = 9;
            optionMenuSetPrioritizationLevels(levels);
        } // End Click

        onRadio0Click: {
            container.hideMenu();
            levels = 0;
            optionMenuSetPrioritizationLevels(levels);
//            optionMenuSortByDistance();
        } // End Click
        onRadio1Click: {
            container.hideMenu();
            levels = 5;
            optionMenuSetPrioritizationLevels(levels);
        } // End Click
        onRadio2Click: {
            container.hideMenu();
            levels = 7;
            optionMenuSetPrioritizationLevels(levels);
        } // End Click
        onRadio3Click: {
            container.hideMenu();
            levels = 9;
            optionMenuSetPrioritizationLevels(levels);
        } // End Click

        onOptionMenuFinished: {
            container.hideMenu();
        }
        onOptionFinishForSubMenu: {
            hideMenu();
            idMenu.focus = true;
            idMenu.forceActiveFocus();
        }
    }
    ListModel {
        id: idOptionMenuModelForTwoDepth
        ListElement{name: "All";   opType: "radioBtn"}
        ListElement{name: "Low(5~6)";      opType: "radioBtn"}
        ListElement{name: "High(7~8)";   opType: "radioBtn"}
        ListElement{name: "Severe(9~15)";      opType: "radioBtn"}
    }

    //set Range
    MComp.MOptionMenu{
        id:idMenu_SetRange
        x:0;y:0
        property alias linkModel: idMenu_SetRange.linkedModels
        parentOptionMenu: idMenu.imgBGForSub
        menuDepth: "TwoDepth"
        //titleText : stringInfo.sSTR_XMDATA_SORTBY
        linkedModels:idOptionMenuSetRangeModelForTwoDepth
        visible: false
        onMenu0Click: {
            container.hideMenu();
            ranges = 50;
            optionMenuSetRange(ranges);
        } // End Click
        onMenu1Click: {
            container.hideMenu();
            ranges = 100;
            optionMenuSetRange(ranges);
        } // End Click
        onMenu2Click: {
            container.hideMenu();
            ranges = 200;
            optionMenuSetRange(ranges);
        } // End Click
        onMenu3Click: {
            container.hideMenu();
            ranges = 300;
            optionMenuSetRange(ranges);
        }

        onRadio0Click: {
            container.hideMenu();
            ranges = 50;
            optionMenuSetRange(ranges);
        } // End Click
        onRadio1Click: {
            container.hideMenu();
            ranges = 100;
            optionMenuSetRange(ranges);
        } // End Click
        onRadio2Click: {
            container.hideMenu();
            ranges = 200;
            optionMenuSetRange(ranges);
        } // End Click
        onRadio3Click: {
            container.hideMenu();
            ranges = 300;
            optionMenuSetRange(ranges);
        }

        onOptionMenuFinished: {
            container.hideMenu();
        }
        onOptionFinishForSubMenu: {
            hideMenu();
            idMenu.focus = true;
            idMenu.forceActiveFocus();
        }
    }
    ListModel {
        id: idOptionMenuSetRangeModelForTwoDepth
        ListElement{name: "50 miles";   opType: "radioBtn"}
        ListElement{name: "100 miles";      opType: "radioBtn"}
        ListElement{name: "200 miles";   opType: "radioBtn"}
        ListElement{name: "300 miles";      opType: "radioBtn"}
    }

    //set Zone
//    MComp.MOptionMenu{
//        id:idMenu_SetZone
//        x:0;y:0
//        property alias linkModel: idMenu_SetZone.linkedModels
//        parentOptionMenu: idMenu.imgBGForSub
//        menuDepth: "TwoDepth"
//        //titleText : stringInfo.sSTR_XMDATA_SORTBY
//        linkedModels:idOptionMenuSetZoneModelForTwoDepth
//        visible: false
//        onMenu0Click: {
//            container.hideMenu();
//            optionMenuSetMarineCoastalZone(false);
//        } // End Click
//        onMenu1Click: {
//            container.hideMenu();
//            optionMenuSetMarineCoastalZone(true);
//        } // End Click

//        onRadio0Click: {
//            container.hideMenu();
//            optionMenuSetMarineCoastalZone(false);
//        } // End Click
//        onRadio1Click: {
//            container.hideMenu();
//            optionMenuSetMarineCoastalZone(true);
//        } // End Click

//        onOptionMenuFinished: {
//            container.hideMenu();
//        }
//        onOptionFinishForSubMenu: {
//            hideMenu();
//            idMenu.focus = true;
//            idMenu.forceActiveFocus();
//        }
//    }
//    ListModel {
//        id: idOptionMenuSetZoneModelForTwoDepth
//        ListElement{name: "All";   opType: "radioBtn"}
//        ListElement{name: "Except Marine/Costal";      opType: "radioBtn"}
//    }

    //String
    function setModelString(){
        idOptionMenuModelForAll.get(0).name = stringInfo.sSTR_XMDATA_WSA_MENU_SET_PRIORITIZATION_LEVELS;
        idOptionMenuModelForAll.get(1).name = stringInfo.sSTR_XMDATA_WSA_MENU_SET_RANGE;
        idOptionMenuModelForAll.get(2).name = stringInfo.sSTR_XMDATA_WSA_MENU_SET_MARINE_COASTAL_ZONE;
        idOptionMenuModelForAll.get(3).name = stringInfo.sSTR_XMDATA_WSA_MENU_SET_SHOW_POPUP;

        idOptionMenuModelForTwoDepth.get(0).name = stringInfo.sSTR_XMDATA_WSA_MENU_ALL;
        idOptionMenuModelForTwoDepth.get(1).name = stringInfo.sSTR_XMDATA_WSA_MENU_LOW_5_6;
        idOptionMenuModelForTwoDepth.get(2).name = stringInfo.sSTR_XMDATA_WSA_MENU_HIGH_7_8;
        idOptionMenuModelForTwoDepth.get(3).name = stringInfo.sSTR_XMDATA_WSA_MENU_SEVERE_9_15;

        idOptionMenuSetRangeModelForTwoDepth.get(0).name = stringInfo.sSTR_XMDATA_WSA_MENU_50_MILES;
        idOptionMenuSetRangeModelForTwoDepth.get(1).name = stringInfo.sSTR_XMDATA_WSA_MENU_100_MILES;
        idOptionMenuSetRangeModelForTwoDepth.get(2).name = stringInfo.sSTR_XMDATA_WSA_MENU_200_MILES;
        idOptionMenuSetRangeModelForTwoDepth.get(3).name = stringInfo.sSTR_XMDATA_WSA_MENU_300_MILES;

//        idOptionMenuSetZoneModelForTwoDepth.get(0).name = stringInfo.sSTR_XMDATA_WSA_MENU_ALL;
//        idOptionMenuSetZoneModelForTwoDepth.get(1).name = stringInfo.sSTR_XMDATA_WSA_MENU_SET_MARINE_COASTAL_ZONE;
    }

    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }

    function setCurrentSortIndex_priority(priority)
    {
        var idx = 0;
        if(priority > 15)
        {
            idx = 0;
        }else if(priority >= 9)
        {
            idx = 3;
        }else if(priority >= 7)
        {
            idx = 2;
        }else if(priority >= 5)
        {
            idx = 1;
        }else
        {
            idx = 0;
        }

        idMenu_SetPriority.linkedCurrentIndex = (idx == 0) ? 1 : 0;
        idMenu_SetPriority.selectedRadioIndex = idx;
    }

    function setCurrentSortIndex_range(range)
    {
        var idx = 0;
        switch(range)
        {
            case 100:
                idx = 1;
                break;
            case 200:
                idx = 2;
                break;
            case 300:
                idx = 3;
                break;
            case 50:
            default:
                idx = 0;
                break;
        }

        idMenu_SetRange.linkedCurrentIndex = (idx == 0) ? 1 : 0;
        idMenu_SetRange.selectedRadioIndex = idx;
    }

    function setCurrentSortIndex_zone(zone)
    {
//        idMenu_SetZone.linkedCurrentIndex = (zone == true ? 0 : 1);
//        idMenu_SetZone.selectedRadioIndex = (zone == true ? 1 : 0);
        idOptionMenuModelForAll.get(2).flagToggle = zone;
    }

    function setCurrentSortIndex_showPopup(isShow)
    {
        idOptionMenuModelForAll.get(3).flagToggle = isShow;
    }

    //Debug Information
    Text {
        x:idMenu.x+5; y:idMenu.x+12+10; id:idFileName
        text:"WeatherSecurityNAlertsOptionMenu.qml";
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
