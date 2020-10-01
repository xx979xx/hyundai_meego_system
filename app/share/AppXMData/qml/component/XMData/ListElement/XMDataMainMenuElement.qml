import Qt 4.7

QtObject {
    //    property int itemIndex
    property string itemText: getIconPath()

    function getIconPath( itemIndex ) {
        switch( itemIndex )
        {
            case 0: return qsTr(imageInfo.imgFolderXMData + "ico_main_weather.png");
            case 1: return qsTr(imageInfo.imgFolderXMData + "ico_main_traffic.png");
            case 2: return qsTr(imageInfo.imgFolderXMData + "ico_main_stock.png");
            case 3: return qsTr(imageInfo.imgFolderXMData + "ico_main_sports.png");
            case 4: return qsTr(imageInfo.imgFolderXMData + "ico_main_fuel.png");
            case 5: return qsTr(imageInfo.imgFolderXMData + "ico_main_movie.png");
            default: return "";
        }
    }

    function getDataManager( itemIndex ) {
        switch( itemIndex )
        {
            case 0: return weatherDataManager;
            case 2: return stockDataManager;
            case 3: return sportsDataManager;
            case 4: return fuelPriceDataManager;
            case 5: return movieTimesDataManager;
            default: return null;
        }
    }

    function isEnable( itemIndex ) {
        switch( itemIndex )
        {
            case 0: return weatherDataManager.bEnable;
            case 1: return interfaceManager.bTrafficEnable;
            case 2: return stockDataManager.bEnable;
            case 3: return sportsDataManager.bEnable;
            case 4: return fuelPriceDataManager.bEnable;
            case 5: return movieTimesDataManager.bEnable;
            default: return false;
        }
    }

    function onClickOrKeySelected( itemIndex ) {

        switch( itemIndex )
        {
            case 0:
                if(isDebugVersion || idAppMain.debugOnOff || (subscriptionData.SubWeather == 1))
                {
                    if(isEnable(itemIndex))
                        setAppMainScreen("callForWeatherMenu", true);
                    else
                        idTryAgainPopUp.show();
                }
                else
                {
                     idSubscriptionStatusNotify.show(itemIndex);
                }
                return;
            case 1:
                if(isDebugVersion || idAppMain.debugOnOff || (subscriptionData.SubTraffic == 1))
                {
                    if(interfaceManager.isMountedMMC == false)
                    {
                        idListIsSDMountPopUp.show();
                    }
                    else
                    {
                        if(isEnable(itemIndex))
                        {
                            if( !UIListener.HandleGoToNavigationForTraffic() )
                                showNotConnectedWithNavigation("No Navigation Conntected..")
                        }
                        else
                            idTryAgainPopUp.show();
                    }
                }
                else
                {
                    idSubscriptionStatusNotify.show(itemIndex);
                }
                return;
            case 2:
                if(isDebugVersion || idAppMain.debugOnOff || (subscriptionData.SubStock == 1))
                {
                    if(isEnable(itemIndex))
                        setAppMainScreen("callForStockMenu", true);
                    else if((idAppMain.isDRSChange) && (isEnable(itemIndex) == false))
                        showHideDRSPopup(true);
                    else
                        idTryAgainPopUp.show();
                }
                else
                {
                    idSubscriptionStatusNotify.show(itemIndex);
                }
                return;
            case 3:
                if(isDebugVersion || idAppMain.debugOnOff || (subscriptionData.SubSports == 1))
                {
                    if(isEnable(itemIndex))
                        setAppMainScreen("callForSportsMenu", true);
                    else if((idAppMain.isDRSChange) && (isEnable(itemIndex) == false))
                        showHideDRSPopup(true);
                    else
                        idTryAgainPopUp.show();
                }
                else
                {
                    idSubscriptionStatusNotify.show(itemIndex);
                }
                return;
            case 4:
                if(isDebugVersion || idAppMain.debugOnOff || (subscriptionData.SubFuelPrice == 1))
                {
                    if(isEnable(itemIndex))
                        setAppMainScreen("callForFuelPricesMenu", true);
                    else
                        idTryAgainPopUp.show();
                }
                else
                {
                    idSubscriptionStatusNotify.show(itemIndex);
                }
                return;
            case 5:
                if(isDebugVersion || idAppMain.debugOnOff || (subscriptionData.SubMovieTimes == 1))
                {
                    if(isEnable(itemIndex))
                        setAppMainScreen("callForMovieTimesMenu", true);
                    else if((idAppMain.isDRSChange) && (isEnable(itemIndex) == false))
                        showHideDRSPopup(true);
                    else
                        idTryAgainPopUp.show();
                }
                else
                {
                    idSubscriptionStatusNotify.show(itemIndex);
                }
                return;
            default: return "";
        }
    }
}
