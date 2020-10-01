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
// Local Import
import "../Menu" as MMenu
import "../ListElement" as MListElement

// Because Loader is a focus scope, converted from FocusScope to Item.
FocusScope{
    id:container

    property int tileSupport: 0;

    signal optionMenuForFullScreen()
    signal optionMenuForFront()
    signal optionMenuForIsobar();
    signal optinoMenuForPressureCenter();
//    signal optionMenuForStormAttributes();
//    signal optionMenuForStormPosition();
//    signal optionMenuForWindRadiiField();
    signal optionMenuForNowRad();
//    signal optionMenuForWindDirection();
//    signal optionMenuForWindMagnitude();
    signal menuHided();

    signal optionMenuForFrontUncheck();
    signal optionMenuForIsobarUncheck();
    signal optinoMenuForPressureCenterUncheck();

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
        container.focus = true;
        idMenu.showMenu();
    }
    function hideMenu(){
        if(!container.focus){return}
        idMenu.hideMenu();
        menuHided();
    }

    onTileSupportChanged: {
        idOptionMenuModelForAll.get(1).flagToggle  = (tileSupport & 0x02/*AGWDataMapItem.TILE_FRONT*/);
        idOptionMenuModelForAll.get(2).flagToggle  = (tileSupport & 0x04/*AGWDataMapItem.TILE_ISOBAR*/);
        idOptionMenuModelForAll.get(3).flagToggle  = (tileSupport & 0x08/*AGWDataMapItem.TILE_PRESSURECENTER*/);
//        idOptionMenuModelForAll.get(4).flagToggle  = (tileSupport & 0x10/*AGWDataMapItem.TILE_STORMATTRIBUTES*/);
//        idOptionMenuModelForAll.get(5).flagToggle  = (tileSupport & 0x20/*AGWDataMapItem.E_STORMPOSITION*/);
        idOptionMenuModelForAll.get(4/*6*/).flagToggle  = (tileSupport & 0x01/*AGWDataMapItem.E_NOWRAD*/);
    }

    MComp.MOptionMenu{
        id:idMenu
        x:0;y:0
        linkedModels: idOptionMenuModelForAll

        onMenu0Click: {
            container.hideMenu();
            optionMenuForFullScreen();
        }

        onDimCheck1Click: {
//            container.hideMenu();
            optionMenuForFront();
        }
        onDimCheck2Click: {
//            container.hideMenu();
            optionMenuForIsobar();
        }
        onDimCheck3Click: {
//            container.hideMenu();
            optinoMenuForPressureCenter();
        }
//        onDimCheck4Click: {
//            container.hideMenu();
//            optionMenuForStormAttributes();
//        }
//        onDimCheck5Click: {
//            container.hideMenu();
//            optionMenuForStormPosition();
//        }
//        onDimCheck6Click: {
        onDimCheck4Click: {
//            container.hideMenu();
            optionMenuForNowRad();
        }
        onDimUncheck1Click: {
//            container.hideMenu();
            optionMenuForFront();
        }
        onDimUncheck2Click: {
//            container.hideMenu();
            optionMenuForIsobar();
        }
        onDimUncheck3Click: {
//            container.hideMenu();
            optinoMenuForPressureCenter();
        }
//        onDimUncheck4Click: {
//            container.hideMenu();
//            optionMenuForStormAttributes();
//        }
//        onDimUncheck5Click: {
//            container.hideMenu();
//            optionMenuForStormPosition();
//        }
//        onDimUncheck6Click: {
        onDimUncheck4Click: {
//            container.hideMenu();
            optionMenuForNowRad();
        }

        onOptionMenuFinished: {
            container.hideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForAll
        ListElement{name: "Full Screen"; opType: ""}
        ListElement{name: "Front Line"; opType: "dimCheck"; flagToggle: false}
        ListElement{name: "Isobar"; opType: "dimCheck"; flagToggle: false}
        ListElement{name: "Pressure Center"; opType: "dimCheck"; flagToggle: false}
//        ListElement{name: "Storm Attribute"; opType: "dimCheck"; flagToggle: false}
//        ListElement{name: "Tropical Storm Track"; opType: "dimCheck"; flagToggle: false}
        ListElement{name: "NOWRad"; opType: "dimCheck"; flagToggle: false}
    }

    //String
    function setModelString(){
        idOptionMenuModelForAll.get(0).name = stringInfo.sSTR_XMDATA_FULLSCREEN
        idOptionMenuModelForAll.get(1).name = stringInfo.sSTR_XMDATA_SHAPE_FRONT
        idOptionMenuModelForAll.get(2).name = stringInfo.sSTR_XMDATA_ISOBAR
        idOptionMenuModelForAll.get(3).name = stringInfo.sSTR_XMDATA_PRESSURE_CENTER
//        idOptionMenuModelForAll.get(4).name = stringInfo.sSTR_XMDATA_STORM_ATTRIBUTES
//        idOptionMenuModelForAll.get(5).name = stringInfo.sSTR_XMDATA_TROPICAL_STORM_TRACK
        idOptionMenuModelForAll.get(4/*6*/).name = stringInfo.sSTR_XMDATA_NOW_RAD
    }

    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }

    //Debug Information
//    Text {
//        x:idMenu.x+5; y:idMenu.x+12+10; id:idFileName
//        text:"WeatherRadarOptionMenuForType.qml";
//        color : "white";
//        visible:isDebugMode();
//    }

    function remoteSelectForUpdate(type)
    {
        console.log("====================================remoteSelectForUpdate type is ", type)
        idWeatherMap.mapRemoteSelectForUpdate(type);
    }
}
