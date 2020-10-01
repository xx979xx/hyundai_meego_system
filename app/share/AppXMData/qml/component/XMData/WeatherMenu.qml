import Qt 4.7

// Local Import
import "./Menu" as MMenu
import "../QML/DH" as MComp
import "../../component/QML/DH" as MComp
import "./ListElement" as XMListElement
import "./Common" as XMMComp
import "./Popup" as MPopup

// Because Loader is a focus scope, converted from FocusScope to Item.
Item {
    id: idWetherMain
    // Today, Forecast, Ski, Radar, Location,
    state : "Today"
    property string szPreState : ""
    property string szMode : "City"
    property string szPreModeForLoading: ""
    property bool searchMode: false
    property string szPreStateForOption : ""

    onVisibleChanged: {
        szPreModeForLoading = "";
        checkForWeatherLoadingTimer();
        UIListener.consolMSG("WeatherMenu visible = " + visible);
    }

    onSearchModeChanged: {
        if(searchMode == true)
        {
            idMenuBar.visibleSearchTextInput = true;
        }else
        {
            idMenuBar.visibleSearchTextInput = false;
        }
    }

    onStateChanged: {
        if(state == "Today")
        {
            idToday.show();

            idWeekly.hide();
            idSki.hide();
            idRadar.hide();
            idLocation.hide();
        }else if(state == "Forecast")
        {
            idWeekly.show();

            idToday.hide();
            idSki.hide();
            idRadar.hide();
            idLocation.hide();
        }else if(state == "Ski")
        {
            idSki.show();

            idWeekly.hide();
            idToday.hide();
            idRadar.hide();
            idLocation.hide();
        }else if(state == "Radar")
        {
            idRadar.show();

            idSki.hide();
            idWeekly.hide();
            idToday.hide();
            idLocation.hide();
        }else if(state == "Location")
        {
            idLocation.show();

            idRadar.hide();
            idSki.hide();
            idWeekly.hide();
            idToday.hide();
        }
    }

    FocusScope{
        id: idCenterFocusScope

        Loader{
            id: idToday
            function hide()
            {
//                if(idToday.item != null)
//                    item.isTodayVisible = false;
                visible = false;
                source = "";
            }
            function show()
            {
                source = "./WeatherToday.qml"
                visible = true;
//                if(idToday.item != null)
//                    item.isTodayVisible = true;
            }
        }

        Loader{
            id: idWeekly

            function hide()
            {
//                if(idWeekly.item != null)
//                    item.isForecastVisible = false;
                visible = false;
                source = "";
            }
            function show()
            {
                source = "./WeatherWeekly.qml"
                visible = true;
//                if(idWeekly.item != null)
//                    item.isForecastVisible = true;
            }
        }
        Loader{
            id: idSki
            function hide()
            {
//                if(idSki.item != null)
//                    item.isSkiVisible = false;
                visible = false;
                source = "";
            }

            function show()
            {
                source = "./WeatherSki.qml"
                visible = true;
//                if(idSki.item != null)
//                    item.isSkiVisible = true;
            }
        }

        // Weather location
        Loader {
            id: idLocation;

            function hide()
            {
                visible = false;
                source = "";
            }
            function show()
            {
                if(status == Loader.Null)
                    source = "./WeatherLocation.qml";
                visible = true;
                forceActiveFocus();
            }
        }
    }

    // Weather radar
    Loader {
        id: idRadar;
        visible: false;

        function hide()
        {
            idMainFocusScope.z = systemInfo.context_CONTENT;
            visible = false;
            source = "";
        }
        function show()
        {
            idMainFocusScope.z = systemInfo.context_CONTENT_LOW;
            if(idRadar.status == Loader.Null)
                idRadar.source = "./WeatherRadar.qml";
            visible = true;
            forceActiveFocus();
        }
    }

    XMMComp.XMMBand
    {
        id: idMenuBar
        x: 0; y: 0; z: -1
        isWeekSubBtn: true
        textTitle: stringInfo.sSTR_XMDATA_WEATHER;
        subTitleText: (weatherDataManager.szCityName != "" && weatherDataManager.szStateName != "") ? weatherDataManager.szCityName + ", " + weatherDataManager.szStateName : "";
        subTitleFlag: true;
        titleFavoriteImg: (weatherDataManager.bIsFavoriteCity && (idToday.visible == true || idWeekly.visible == true || idSki.visible == true));
        intelliKey: weatherDataManager.dIntelliKey
        contentItem: idCenterFocusScope
    }

    //Option Menu
    Loader{id:idOptionMenu; z: parent.z+1}

    Component{
        id: idCompOptionMenu
        MMenu.WeatherOptionMenuForToday {
            y:0
            onMenuHided: {
                focus = false;
                idMenuBar.contentItem.KeyNavigation.up.forceActiveFocus();
            }

            onOptionMenuForToday: {
                onToday();
            }
            onOptionMenuForForecast: {
                onWeekly();
            }
            onOptionMenuForLocationList: {
                onLocation();
            }
            onOptionMenuForWeatherNSecurity: {
                idMenuBar.idBandTop.focus = true;
                setAppMainScreen("callForWSAlert", true);
                idWSAlert.alertsList.resetCurrentIndex();
            }
            onOptionMenuForRadarMap: {
                onRadar();
            }
        }
    }

    Keys.onPressed: {        
        if( idAppMain.isMenuKey(event) ) {
            onOptionOnOff();
        }
        else if(idAppMain.isBackKey(event)){
            stopToastPopup();
            gotoBackScreen(false);//CCP
        }
    }

    Component.onCompleted: {
        onToday();
    }

    function onTitleOption(btnName)
    {
        if(idWetherMain.state == "Today")
        {
            onWeekly();
        }
        else if(idWetherMain.state == "Forecast")
        {
            onToday();
        }
        else if(idWetherMain.state == "Forecast")
        {
            onWeekly();
        }
    }
    function onLocationPressed()
    {
        returnToCurrentLocation();
    }

    function onToday()
    {
        idWetherMain.szMode = "City";
        idWetherMain.state = "Today";
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_WEATHER;
        idMenuBar.subTitleFlag = true;
        checkIsUserLocation();
        idMenuBar.focus = true;
        idMenuBar.menuBtnFlag = true;
        idMenuBar.focusInitLeft();
        idMenuBar.idBandTop.forceActiveFocus();
        UIListener.autoTest_athenaSendObject();
        checkForWeatherLoadingTimer();
    }

    function onWeekly()
    {
        idWetherMain.state = "Forecast";
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_WEATHER;
        idMenuBar.subTitleFlag = true;
        checkIsUserLocation();
        idMenuBar.focus = true;
        idMenuBar.menuBtnFlag = true;
        idMenuBar.idBandTop.forceActiveFocus();
        UIListener.autoTest_athenaSendObject();
        checkForWeatherLoadingTimer();
    }

    function onSki()
    {
        idWetherMain.szMode = "Ski";
        idWetherMain.state = "Ski";
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_WEATHER;
        idMenuBar.subTitleFlag = true;
        checkIsUserLocation();
        idMenuBar.focus = true;
        idMenuBar.menuBtnFlag = true;
        idMenuBar.focusInitLeft();
        idMenuBar.idBandTop.forceActiveFocus();
        UIListener.autoTest_athenaSendObject();
        checkForWeatherLoadingTimer();
    }

    function onRadar()
    {
        szPreState = idWetherMain.state;
        idMenuBar.visible = false;
        idWetherMain.state = "Radar";
        idRadar.focus = true;
        UIListener.autoTest_athenaSendObject();
        if(idRadar.item != null)
            idRadar.item.openForRadar();
        checkForWeatherLoadingTimer();
    }

    function onLocation()
    {
        idWetherMain.szMode = "City";
        szPreState = idWetherMain.state;
        if(szPreState != "Location")
            szPreStateForOption = szPreState;
        console.log("[onLocation]szPreState = " + szPreState);
        console.log("[onLocation]szPreStateForOption = " + szPreStateForOption);
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_LOCATION_LIST
        idMenuBar.subTitleFlag = false;
        idMenuBar.locationBtnFlag = false;
        idWetherMain.state = "Location";
        UIListener.autoTest_athenaSendObject();
        checkForWeatherLoadingTimer();
    }

    function onLocationSki()
    {
        idWetherMain.szMode = "Ski"
        szPreState = idWetherMain.state;
        if(szPreState != "Location")
            szPreStateForOption = szPreState;
        console.log("[onLocationSki]szPreState = " + szPreState);
        console.log("[onLocationSki]szPreStateForOption = " + szPreStateForOption);
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_LOCATION_LIST
        idMenuBar.subTitleFlag = false;
        idMenuBar.locationBtnFlag = false;
        idWetherMain.state = "Location";
        UIListener.autoTest_athenaSendObject();
        checkForWeatherLoadingTimer();
    }



    function onDestoryRadar()
    {
        idAppMain.isFullScreen = 0;
        idRadar.item.visible = false;
        idRadar.source = '';
        idMenuBar.visible = true;
        idMenuBar.focus = true;
    }

    function onDestoryLocation()
    {
        if(idLocation.item != null)
        {
            idLocation.item.visible = false;
            idLocation.source = '';
        }
    }

    function onDestorySki()
    {
        if(idSki.item != null)
        {
//            idSki.item.isSkiVisible = false;
            idSki.item.visible = false;
            idSki.source = '';
        }
    }

    function returnToCurrentLocation()
    {
        if(weatherDataManager.bIsUserLocMode == true)
        {
            weatherDataManager.bIsUserLocMode = false;
// Deleted by igbae, 2013/07/22
//            var result = weatherDataManager.SetCurrentLocation(weatherDataManager.fCurLat,weatherDataManager.fCurLon);
//            console.log("current position : " + result);
//            interfaceManager.reqWeatherCity(result);
            checkIsUserLocation();
        }
        if((idLocation.item != null && idLocation.item.visible == true) || (idSki.item != null && idSki.item.visible == true))
        {
            onDestoryLocation();
            onDestorySki();
            onToday();
        }
    }

    function checkIsUserLocation()
    {
// Added by igbae, 2013/07/22 for Do not check weather Device location is same as user selected location
//        console.log("checkIsUserLocation() "+weatherDataManager.bIsUserLocMode+" "+weatherDataManager.isSameCurrentLocationWithUserLocation())
//        if(weatherDataManager.bIsUserLocMode && !weatherDataManager.isSameCurrentLocationWithUserLocation())
        if(weatherDataManager.bIsUserLocMode)
        {
            idMenuBar.locationBtnFlag = true;
        }
        else
        {
            idMenuBar.locationBtnFlag = false;
        }
    }

    function onBack()
    {
        switch(idWetherMain.state)
        {
        case "Today" :
            returnToCurrentLocation();
            return true;
        case "Forecast" :
            returnToCurrentLocation();
            idWetherMain.state = "Today";
            return true;
        case "Ski" :
            returnToCurrentLocation();
            idWetherMain.state = "Today";
            return true;
        case "Radar" :
            onDestoryRadar();
            switch(szPreState)
            {
            case "Today" : onToday(); break;
            case "Forecast" : onWeekly(); break;
            case "Ski" : onSki(); break;
            }
            return false;
        case "Location" :
            switch(szPreState)
            {
            case "Today" :
                onDestoryLocation();
                searchMode = false;
                onToday();
                break;
            case "Forecast" :
                onDestoryLocation();
                searchMode = false;
                onWeekly();
                break;
            case "Ski" :
                onDestoryLocation();
                searchMode = false;
                onSki();
                break;
            case "DeleteFavorite" :
                onLocation();
                idMenuBar.locationBtnFlag = false;
                idLocation.item.backForDeleteFavorite();
                idWetherMain.state = "Location";
                szPreState = szPreStateForOption;
                break;
            case "ChangeRow" :
                if(!idLocation.item.backForChangeRow())
                {
                    onLocation();
                    idMenuBar.locationBtnFlag = false;
                    idWetherMain.state = "Location";
                    szPreState = szPreStateForOption;
                }
                break;
            case "SearchForCity" :
                onLocation();
                idLocation.item.backForWeatherSearchForCity();
                idWetherMain.state = "Location";
                szPreState = szPreStateForOption;
                break;
            }
            return false;
        }
    }

    function onOptionOnOff()
    {
        if(idWeatherLoadingFinishPopUp.visible == true) { return; }

        switch(idWetherMain.state)
        {
        case "Today" :
        case "Forecast" :
        case "Ski" :
            idOptionMenu.sourceComponent = idCompOptionMenu;
//            if(idOptionMenu.item.isOnAnimation)
//                return;
//            idOptionMenu.visible = true;
            idOptionMenu.item.showMenu();
            idOptionMenu.focus = true;
            break;
        case "Location" :
            idLocation.item.onMenu();
            break;
        case "Radar" :
            idRadar.item.onMenu();
            break;
        }
    }

    function getNextFocusMoveFromBand()
    {
        switch(idWetherMain.state)
        {
        case "Today" :
        case "Forecast" :
        case "Ski" :
            return null;
        case "Radar" :
        case "Location" :
            return idCenterFocusScope;
        }
    }

    Connections{
        target: weatherDataManager
        onDoCheckUserLocation : {
            if(idWetherMain.state == "Today")
            {
// Added by igbae, 2013/07/22 for Do not check weather Device location is same as user selected location
//                if(weatherDataManager.bIsUserLocMode && !weatherDataManager.isSameCurrentLocationWithUserLocation())
                if(weatherDataManager.bIsUserLocMode)
                    idMenuBar.locationBtnFlag = true;
                else
                    idMenuBar.locationBtnFlag = false;
            }
        }
        onDoCheckLoading : {
            checkForWeatherLoadingTimer();
        }
    }

    // Weather Loading Timer
    function checkForWeatherLoadingTimer(){
        // this function have to call after szMode changed.
        if(idWetherMain.visible == false)
        {
            idWeatherLoadingTimer.stop();
        }else
        {
            var isLoading = true;
            if(state == "Today")
            {
                if(Forecast0.wValidForecastData != -1 && Forecast03.wValidForecastData != -1 && Forecast36.wValidForecastData != -1)
                {
                    isLoading = false;
                }
            }else if(state == "Forecast")
            {
                if(ForecastDay1.wValidForecastData != -1 && ForecastDay2.wValidForecastData != -1 && ForecastDay3.wValidForecastData != -1 &&
                        ForecastDay4.wValidForecastData != -1 && ForecastDay5.wValidForecastData != -1 && ForecastDay6.wValidForecastData != -1)
                {
                    isLoading = false;
                }
            }else if(state == "Ski")
            {
                if(SkiResortInfo.wSkiDataValid != -1)
                {
                    isLoading = false;
                }
            }else
            {
                isLoading = false;
            }

            if(isLoading == true)
            {
                if(szPreModeForLoading != state || idWeatherLoadingTimer.running == false)
                    idWeatherLoadingTimer.restart();
            }else if(isLoading == false)
            {
                idWeatherLoadingTimer.stop();
                if(idWeatherLoadingFinishPopUp.visible)
                {
                    idMenuBar.contentItem.KeyNavigation.up.focus = true;
                    idWeatherLoadingFinishPopUp.visible = false;
                }
            }
            szPreModeForLoading = state;
        }

        console.log("[checkForWeatherLoadingTimer] idWetherMain.visible("+idWetherMain.visible+"), state("+state+"), szPreModeForLoading("+szPreModeForLoading+"), idWeatherLoadingTimer.Running("+idWeatherLoadingTimer.running+")");
    }

    SequentialAnimation{
        id: idWeatherLoadingTimer
        PauseAnimation { duration: 30000 }
        ScriptAction{script:{if(idWetherMain.visible) idWeatherLoadingFinishPopUp.show();}}
    }

    MPopup.Case_E_Warning{
        id:idWeatherLoadingFinishPopUp
        visible : false;
        focus:false;
        detailText1: stringInfo.sSTR_XMDATA_DATA_UPDATE_DELAYED_WARNING;
        detailText2: "";
        popupLineCnt: 1

        onClose: {
            hide();
            gotoFristScreenFroRequestFG();
        }
        function show(){
            if(idOptionMenu.state == "show" || idOptionMenu.state == "")
            {
                if(idOptionMenu.item != null)
                    idOptionMenu.item.hideMenu();
            }

            console.log("==========[JWPARK TEST]idWeatherLoadingFinishPopUp.show()==================");
            idWeatherLoadingFinishPopUp.visible = true;
            idWeatherLoadingFinishPopUp.focus = true;
        }
        function hide(){
            idWeatherLoadingFinishPopUp.visible = false;
            idWeatherLoadingFinishPopUp.focus = false;
            idMenuBar.contentItem.KeyNavigation.up.forceActiveFocus();
            gotoFristScreenFroRequestFG();
        }
    }
}
