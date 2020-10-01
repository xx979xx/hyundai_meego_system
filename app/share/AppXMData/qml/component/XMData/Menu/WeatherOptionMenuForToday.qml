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

FocusScope{
    id:container

    property alias isOnAnimation: idMenu.isOnAnimation

    signal optionMenuForToday()
    signal optionMenuForForecast()
    signal optionMenuForLocationList()
    signal optionMenuForWeatherNSecurity()
    signal optionMenuForRadarMap()
    signal menuHided();

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
        idMenu.linkedModels = (idAppMain.isVariantId == 6)? (idWetherMain.state == "Today" ? idOptionMenuModelForToday_Canada : idWetherMain.state == "Forecast" ? idOptionMenuModelForForecast_Canada : idOptionMenuModelForSki_Canada) : (idWetherMain.state == "Today" ? idOptionMenuModelForToday : idWetherMain.state == "Forecast" ? idOptionMenuModelForForecast : idOptionMenuModelForSki)
        idMenu.showMenu();
    }
    function hideMenu(){
        if(!container.focus){return}
        idMenu.hideMenu();
        menuHided();
    }


    MComp.MOptionMenu{
        id:idMenu
        x:0;y:0
        linkedModels: (idAppMain.isVariantId == 6)? idOptionMenuModelForToday_Canada : idOptionMenuModelForToday

        onMenu0Click: {
            container.hideMenu();

            if(idWetherMain.state == "Today")
                optionMenuForForecast();
            else if(idWetherMain.state == "Forecast")
                optionMenuForToday();
            else
                optionMenuForLocationList();
        }
        onMenu1Click: {
            container.hideMenu();

            if(idWetherMain.state == "Ski")
                optionMenuForWeatherNSecurity();
            else
                optionMenuForLocationList();
        }
        onMenu2Click: {
            container.hideMenu();

            if(idWetherMain.state == "Ski")
                optionMenuForRadarMap();
            else
                optionMenuForWeatherNSecurity();
        }
        onMenu3Click: {
            container.hideMenu();

            optionMenuForRadarMap();
        }

        onOptionMenuFinished: {
            container.hideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForToday
        ListElement{name: "Forecast"; opType: ""}
        ListElement{name: "Location List"; opType: ""}
        ListElement{name: "Weather & Security"; opType: ""}
        ListElement{name: "Radar Map"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForForecast
        ListElement{name: "Today"; opType: ""}
        ListElement{name: "Location List"; opType: ""}
        ListElement{name: "Weather & Security"; opType: ""}
        ListElement{name: "Radar Map"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForSki
        ListElement{name: "Location List"; opType: ""}
        ListElement{name: "Weather & Security"; opType: ""}
        ListElement{name: "Radar Map"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForToday_Canada
        ListElement{name: "Forecast"; opType: ""}
        ListElement{name: "Location List"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForForecast_Canada
        ListElement{name: "Today"; opType: ""}
        ListElement{name: "Location List"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForSki_Canada
        ListElement{name: "Location List"; opType: ""}
    }


    //String
    function setModelString(){
        if(idAppMain.isVariantId != 6)
        {
            idOptionMenuModelForToday.get(0).name = stringInfo.sSTR_XMDATA_FORECAST;
            idOptionMenuModelForToday.get(1).name = stringInfo.sSTR_XMDATA_LOCATION_LIST
            idOptionMenuModelForToday.get(2).name = stringInfo.sSTR_XMDATA_WSA_TITLE//"Weather & Security Alerts"
            idOptionMenuModelForToday.get(3).name = stringInfo.sSTR_XMDATA_RADAR

            idOptionMenuModelForForecast.get(0).name = stringInfo.sSTR_XMDATA_TODAY;
            idOptionMenuModelForForecast.get(1).name = stringInfo.sSTR_XMDATA_LOCATION_LIST
            idOptionMenuModelForForecast.get(2).name = stringInfo.sSTR_XMDATA_WSA_TITLE//"Weather & Security Alerts"
            idOptionMenuModelForForecast.get(3).name = stringInfo.sSTR_XMDATA_RADAR

            idOptionMenuModelForSki.get(0).name = stringInfo.sSTR_XMDATA_LOCATION_LIST
            idOptionMenuModelForSki.get(1).name = stringInfo.sSTR_XMDATA_WSA_TITLE//"Weather & Security Alerts"
            idOptionMenuModelForSki.get(2).name = stringInfo.sSTR_XMDATA_RADAR
        }
        else{
            idOptionMenuModelForToday_Canada.get(0).name = stringInfo.sSTR_XMDATA_FORECAST;
            idOptionMenuModelForToday_Canada.get(1).name = stringInfo.sSTR_XMDATA_LOCATION_LIST;
            idOptionMenuModelForForecast_Canada.get(0).name = stringInfo.sSTR_XMDATA_TODAY;
            idOptionMenuModelForForecast_Canada.get(1).name = stringInfo.sSTR_XMDATA_LOCATION_LIST;
            idOptionMenuModelForSki_Canada.get(0).name = stringInfo.sSTR_XMDATA_LOCATION_LIST;
        }
    }

    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }
}
