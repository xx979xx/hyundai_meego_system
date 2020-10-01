
/*---------------------------------------------*/
/* Milliseconds Check Function For Perfomance  */
/*---------------------------------------------*/
// Call for Interval Milliseconds
function intervalMilliseconds(before, after) {
    return after - before;
}

// Call for Getting Milliseconds
function currentMilliseconds() {
    return (new Date()).getTime();
}
/*---------------------------------------------*/

function toFirstScreen() {
    if(weatherDataManager.bIsUserLocMode == true)
        weatherDataManager.bIsUserLocMode = false;

    idXmDataMainMenu.visible = false;

    idSportsMenu.source = '';
    idWeatherMenu.source = '';
    idStockMenu.source = '';
    idFuelPricesMenu.source = '';
    idMovieTimesMenu.source = '';
    idWSAlert.visible = false;

    idRadioPopupWarning1Line.source = '';
    idRadioPopupWarning2Line.source = '';

    setPropertyChanges("callForXMDataMainMenu", false);
}

function backKeyProcessing(isTouch) {
    switch(idAppMain.state)
    {
        case "callForXMDataMainMenu":
            UIListener.HandleBackKey(isTouch);
            break;
        default:
            setAppMainScreen(preSelectedMainScreen(), false);
            break;
    }
}

// Getting ID of Current State Item
function currentStateID()
{
    console.log("currentStateID() : " + idAppMain.state);
    switch(idAppMain.state)
    {
    case "callForXMDataMainMenu":                   return idXmDataMainMenu;
    case "callForSportsMenu":                       return idSportsMenu;

    case "callForWeatherMenu":                      return idWeatherMenu;
    case "callForStockMenu":                        return idStockMenu;
    case "callForFuelPricesMenu":                   return idFuelPricesMenu;
    case "callForMovieTimesMenu":                   return idMovieTimesMenu;

    case "callForWSAlert":                          return idWSAlert;

    case "PopupRadioWarning1Line":                  return idRadioPopupWarning1Line;
    case "PopupRadioWarning2Line":                  return idRadioPopupWarning2Line;

    default: if( idAppMain.state != "" ) console.log("currentStateID() ============== Warning!! " + idAppMain.state); break;
    }
}

// PropertyChanges for States ( Changing Main Screen )
function setPropertyChanges(mainScreen, saveCurrentScreen) {
    var beforeTime = currentMilliseconds();

//    UIListener.clearCache();

    if( saveCurrentScreen == true )
    {
        if(!(mainScreen == "callForWSADetail" && idAppMain.state == "callForWSAlert"))
            setPreSelectedMainScreen();
    }
    else
    {
        switch(idAppMain.state)
        {
        case "callForXMDataMainMenu":                   idXmDataMainMenu.visible = false; break;
        case "callForSportsMenu":                       idSportsMenu.visible = false; break;
        case "callForWeatherMenu":                      idWeatherMenu.visible = false; break;
        case "callForStockMenu":                        idStockMenu.visible = false; break;
        case "callForFuelPricesMenu":
            idFuelPricesMenu.visible = false;
            break;
        case "callForMovieTimesMenu":
            idMovieTimesMenu.visible = false;
            break;
        case "callForWSAlert":                          idWSAlert.visible = false; break;

        case "PopupRadioMsg1Line":                      idRadioPopupWarning1Line.visible = false; break;
        case "PopupRadioMsg2Line":                      idRadioPopupWarning2Line.visible = false; break;

        default: if( idAppMain.state != "" ) console.log(" (saveCurrentScreen === false) ============== Error!! " + idAppMain.state); break;
        }
    }


    if(mainScreen == "callForWSADetail")
        idAppMain.state = "callForWSAlert";
    else
        idAppMain.state = mainScreen; // change state


    // Focus for Current Screen
    idAppMain.focus                     = true;
    idAppMain.isFullScreen             = 0;

    idXmDataMainMenu.visible = false;
    idXmDataMainMenu.focus = false;

    switch(mainScreen)
    {
    case "callForXMDataMainMenu":
        if( idXmDataMainMenu.status == Loader.Null )
            idXmDataMainMenu.source = "../component/XMData/XMDataMainMenu.qml";

        idXmDataMainMenu.visible = true;
        idXmDataMainMenu.focus = true;
        idXmDataMainMenu.forceActiveFocus();
        idAppMain.isWSAFromMenu = false;
        break;
    case "callForWeatherMenu":
        if( idWeatherMenu.status == Loader.Null )
            idWeatherMenu.source = "../component/XMData/WeatherMenu.qml";

        idWeatherMenu.visible = true;
        idWeatherMenu.focus = true;
        idWeatherMenu.forceActiveFocus();
        break;
    case "callForStockMenu":
        if( idStockMenu.status == Loader.Null )
            idStockMenu.source = "../component/XMData/StockMenu.qml";

        stockDataManager.deselectAllDeleteFavorites();//[SMOKE TEST]
        idStockMenu.visible = true;
        idStockMenu.item.initLeftMenuFocus();
        idStockMenu.item.doCheckFavoriteData();
        idStockMenu.focus = true;
        idStockMenu.forceActiveFocus();
        break;
    case "callForSportsMenu":
        if( idSportsMenu.status == Loader.Null )
            idSportsMenu.source = "../component/XMData/SportsMenu.qml";

        idSportsMenu.visible = true;
        idSportsMenu.item.initLeftMenuFocus();
        idSportsMenu.item.selectLeague();
        idSportsMenu.focus = true;
        idSportsMenu.forceActiveFocus();
        //idMenuBar.textTitle = stringInfo.sSTR_XMDATA_SPORTS;
        break;

    case "callForFuelPricesMenu":
        if( idFuelPricesMenu.status == Loader.Null )
            idFuelPricesMenu.source = "../component/XMData/FuelPricesMenu.qml";

        fuelPriceDataManager.setSortColumn(true, 1);
        fuelPriceDataManager.setOnRouteChangedListModel(false);
        fuelPriceDataManager.setBrandSortColumn(0,0);
        idFuelPricesMenu.visible = true;
        idFuelPricesMenu.item.initLeftMenuFocus();
        idFuelPricesMenu.item.selectAll();
        idFuelPricesMenu.focus = true;
        idFuelPricesMenu.forceActiveFocus();
        break;

    case "callForMovieTimesMenu":
        if( idMovieTimesMenu.status == Loader.Null )
            idMovieTimesMenu.source = "../component/XMData/MovieTimesMenu.qml";

        movieTimesDataManager.sortTheaterList(0);
        movieTimesDataManager.sortMovieList(0);
        idMovieTimesMenu.visible = true;
        idMovieTimesMenu.item.initLeftMenuFocus();
        idMovieTimesMenu.item.selectMovie();
        idMovieTimesMenu.focus = true;
        idMovieTimesMenu.forceActiveFocus();
        break;

    case "callForWSAlert":
//        if( idWSAlert.status == Loader.Null )
//            idWSAlert.source = "../component/XMData/WeatherSecurityNAlerts.qml";

        idXmDataMainMenu.visible = false;
        idStockMenu.visible = false;
        idSportsMenu.visible = false;
        idWeatherMenu.visible = false;
        idFuelPricesMenu.visible = false;
        idMovieTimesMenu.visible = false;
        idAppMain.isWSAFromMenu = true;

        idWSAlert.hideWSADetail();
        idWSAlert.visible = true;
        idWSAlert.focus = true;
        idWSAlert.forceActiveFocus();
        break;
    case "callForWSADetail":
    {
        var uniqKey = idWSAlert.loadWSAPopupDetail();
        idXmDataMainMenu.visible = false;
        idStockMenu.visible = false;
        idSportsMenu.visible = false;
        idWeatherMenu.visible = false;
        idFuelPricesMenu.visible = false;
        idMovieTimesMenu.visible = false;

        idWSAlert.showWSADetail(uniqKey);
        idWSAlert.visible = true;
        idWSAlert.focus = true;
        idWSAlert.forceActiveFocus();
        break;
    }

    case "PopupRadioWarning1Line":{
        if( idRadioPopupWarning1Line.status == Loader.Null )
        {
            idRadioPopupWarning1Line.visible = false;
            idRadioPopupWarning1Line.source = "../component/XMData/Popup/PopupWarning1Line.qml";
        }

        if(idRadioPopupWarning1Line.visible == false)
        {
            idRadioPopupWarning1Line.visible = true;
        }
        idRadioPopupWarning1Line.focus = true;
        idRadioPopupWarning1Line.forceActiveFocus();
        break;
    }
    case "PopupRadioWarning2Line":{
        if( idRadioPopupWarning2Line.status == Loader.Null )
        {
            idRadioPopupWarning2Line.visible = false;
            idRadioPopupWarning2Line.source = "../component/XMData/Popup/PopupWarning2Line.qml";
        }

        if(idRadioPopupWarning2Line.visible == false)
        {
            idRadioPopupWarning2Line.visible = true;
        }
        idRadioPopupWarning2Line.focus = true;
        idRadioPopupWarning2Line.forceActiveFocus();
        break;
    }

    default:
        break;
    }

    UIListener.autoTest_athenaSendObject();

    var afterTime = currentMilliseconds();
    console.log(mainScreen + " LoadingTime : " + intervalMilliseconds(beforeTime, afterTime) + " msecs");
}

function setWSAList()
{
    setAppMainScreen("callForWSAlert", true);
}
