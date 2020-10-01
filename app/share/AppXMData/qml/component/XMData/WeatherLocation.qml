import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./Menu" as MMenu
import "./Popup" as MPopup
import "./Javascript/Definition.js" as MDefinition

import "../../component/XMData/Common" as XMCommon

FocusScope{
    id:container
    focus:true

    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight;

    property string szMode : ""//idWetherMain.szMode
    property bool checkDRSStatus: idAppMain.isDRSChange

    Binding {
        target: weatherDataManager; property: "searchPredicate"; value: idMenuBar.textSearchTextInput; when: idMenuBar.intelliUpdate
    }

    onVisibleChanged: {
        UIListener.consolMSG("WeatherLocation visible = " + visible);
        if(visible == false)
        {
            idDrsScreen.hide();
        }
    }

    onCheckDRSStatusChanged:
    {
        if(idWeatherSearchForCity.visible)
        {
            if(checkDRSStatus && searchMode)
            {
                if(idListIsFullPopUp.visible)
                {
                    idListIsFullPopUp.hide();
                }
                idDrsScreen.show();
            }
            else
            {
                idDrsScreen.hide();
            }
        }
    }

    XMDataDRS
    {
        id: idDrsScreen
        x:0; y:0;
        z: parent.z+1
        width:systemInfo.lcdWidth;
        height:systemInfo.contentAreaHeight;
        focus: false
        visible: false

        function show()
        {
            stopToastPopup();
            idMenuBar.checkDRSVisible = true;
            idMenuBar.z = -2;
            idDrsScreen.z = idMenuBar.z+3;
            idDrsScreen.visible = true;
        }
        function hide()
        {
            idDrsScreen.z = idMenuBar.z-1;
            idMenuBar.z = 1;
            idDrsScreen.visible = false;
            idMenuBar.checkDRSVisible = false;
        }
    }

    Keys.onPressed: {
        if( idAppMain.isMenuKey(event) ) {
            onMenu();
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            stopToastPopup();

            if(!onBack())
                event.accepted = true;
        }
    }

    //idCenter Focus Scopce: Left Menu, Center List
    FocusScope{
        id: idCenterFocusScopeForLocation
        width:parent.width;
        height:parent.height;
        focus:true

        FocusScope {
            id: idMenuAndList_FocusScope
            focus: true
            width: parent.width
            height: parent.height
            visible: (idDeleteFavorite.visible!=true)&&(idChangeRow.visible!=true)&&(idWeatherSearchForCity.visible!=true)

            // Left Menu Scope
            XMDataLeftMenuGroup{
                id:idLeftMenuFocusScope
                KeyNavigation.right: idMainListFocusScope
                x:0; y:systemInfo.titleAreaHeight;
                countOfButton: 3; //List has 3 Left Menu

                button1Text: stringInfo.sSTR_XMDATA_CITY;
                button1Active: szMode == "City"
                onButton1Clicked: {
                    selectCity();
                    weatherDataManager.checkForFocusForElement(true);
                }
                button2Text: stringInfo.sSTR_XMDATA_SKIRESORT
                button2Active: szMode == "Ski"
                isWrapForWeather: true;
                onButton2Clicked: {
                    selectSki();
                    weatherDataManager.checkForFocusForElement(true);
                }
                button3Text: stringInfo.sSTR_XMDATA_FAVORITE
                button3Active: szMode == "Favorite"
                onButton3Clicked: {
                    selectFavorite();
                    weatherDataManager.checkForFocusForElement(true);
                }
            }

            //Right List Scope
            FocusScope{
                id:idMainListFocusScope
                KeyNavigation.left:idLeftMenuFocusScope
                focus:true;

                Loader{
                    id: idMainListLoader
                    focus: true
                    visible: true
                    sourceComponent: szMode == "City" ? idCompCityList : szMode == "Ski" ? idCompSkiList : idCompWeatherFavoriteList

                    // City List
                    Component{
                        id: idCompCityList
                        WeatherLocationCity {
                        }
                    }

                    // Ski List
                    Component{
                        id: idCompSkiList
                        WeatherLocationSki {
                        }
                    }

                    // Favorite List
                    Component{
                        id:idCompWeatherFavoriteList
                        WeatherMyFavorites {
                            listModel: weatherFavoriteList;
                        }
                    }
                }

                Component.onCompleted: {
                    szMode = idWetherMain.szMode;
                    weatherDataManager.copyListModelToAddFavoriteList();
                    UIListener.autoTest_athenaSendObject();
                }
            }//idMainListFocusScope
        }//idMenuAndList_FocusScope

        // Delete Favorite
        Loader{
            id: idDeleteFavorite
            x: 0; y: systemInfo.titleAreaHeight
            height: parent.height - systemInfo.titleAreaHeight; width: parent.width
            visible: false

            function hide()
            {
                item.hide();
                sourceComponent = null;
            }
            function show()
            {
                sourceComponent = idCompDeleteFavorite;
                item.show();
            }
            Component{
                id: idCompDeleteFavorite
                WeatherMyFavoritesDelete {
                    onClose:{
                        idDeleteFavorite.hide();
                        weatherDataManager.checkForFocusForElement(false);
                    }

                    onShowDeleteAllPopup: {
                        idDeleteAllQuestion.show();
                    }

                    function hide()
                    {
                        weatherDataManager.updateListFavoriteRoleOfFavoriteList();
                        idMenuBar.deleteAllNoFlag = false;
                        idDeleteFavorite.visible = false;
                        isChanged = 0;
                        if(isToastPopupVisible() == false)
                        {
                            idCenterFocusScopeForLocation.focus = true;
                            idMenuAndList_FocusScope.forceActiveFocus();
                        }
                        gotoBackScreen(false);//CCP
                    }
                    function show()
                    {
                        idCenterFocusScopeForLocation.focus = true;
                        idDeleteFavorite.visible = true;
                        idMenuBar.deleteAllNoFlag = true;
                        idDeleteFavorite.focus = true;
                        idDeleteFavorite.forceActiveFocus();
                        UIListener.autoTest_athenaSendObject();

                        szPreState = "DeleteFavorite";
                    }
                    XMRectangleForDebug{}
                }
            }
        }
        //idDeleteFavorite

        // ChangeRow
        Loader{
            id: idChangeRow
            x: 0; y: systemInfo.titleAreaHeight
            height: parent.height - systemInfo.titleAreaHeight; width: parent.width
            visible: false

            function hide()
            {
                return item.hide();
            }
            function show()
            {
                weatherDataManager.initReorderDataModelAndView();
                sourceComponent = idCompChangeRow;
                item.show();
            }
            Component{
                id: idCompChangeRow
                WeatherMyFavoritesChangeRow {
                    onClose:
                    {
                        idChangeRow.hide();
                    }
                    function hide()
                    {
                        if(idListView.isDragStarted)
                        {
                            idListView.isDragStarted = false;
                            idListView.interactive = true;
                            weatherDataManager.reorderDataModel(idListView.curIndex, idListView.insertedIndex);
                            idListView.currentIndex = idListView.insertedIndex;
                            idListView.insertedIndex = -1;
                            idListView.curIndex = -1;
                            return true;
                        }else
                        {
                            idCenterFocusScopeForLocation.focus = true;
                            idChangeRow.visible = false;
                            idChangeRow.sourceComponent = null;
                            idMenuBar.menuBtnFlag = true;
                            idMenuAndList_FocusScope.forceActiveFocus();
                            return false;
                        }
                    }
                    function show()
                    {
                        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_CHANGE_ROW;
                        idCenterFocusScopeForLocation.focus = true;
                        idChangeRow.visible = true;
                        idChangeRow.focus = true;
                        idChangeRow.forceActiveFocus();
                        idMenuBar.menuBtnFlag = false;
                        UIListener.autoTest_athenaSendObject();

                        szPreState = "ChangeRow";
                    }
                    XMRectangleForDebug{}
                }
            }
        }
        //idChangeRow

        //idWeatherSearchForCity
        Loader{
            id: idWeatherSearchForCity
            objectName: "weatherSearchLocation"
            x: 0; y: systemInfo.titleAreaHeight
            width:parent.width;
            height:parent.height - systemInfo.titleAreaHeight
            visible:false;
            focus: false;

            function hide()
            {
                item.hide();
                sourceComponent = null;
            }
            function show()
            {
                sourceComponent = idCompSearchForCity;
                item.show();
            }
            Component{
                id: idCompSearchForCity
                WeatherSearchForCity {
                    function hide()
                    {
                        idCenterFocusScopeForLocation.focus = true;
                        idWeatherSearchForCity.visible = false;
                        idMenuAndList_FocusScope.forceActiveFocus();
                        idMainListFocusScope.focus = true;
                        searchMode = false;
                        if(idDrsScreen.visible)
                        {
                            idDrsScreen.hide();
                        }
                    }
                    function show()
                    {
                        if(checkDRSStatus)
                        {
                            idMenuBar.checkDRSVisible = true;
                        }
                        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_SEARCH;
                        idCenterFocusScopeForLocation.focus = true;
                        searchMode = true;
                        idWeatherSearchForCity.visible = true;
                        idWeatherSearchForCity.focus = true;
                        idMenuBar.locationBtnFlag = false;
                        szPreState = "SearchForCity";
                        if(checkDRSStatus)
                        {
                            idDrsScreen.show();
                        }
                    }
                }
            }
        }
        //idWeatherSearchForCity
    }//idCenterFocusScopeForLocation

    //blacktip
    MPopup.Case_E_Warning{
        id:idListIsFullPopUp
        z: 0
        visible : false;
        focus:false;
        detailText1: stringInfo.sSTR_XMDATA_LIST_IS_FULL;
        detailText2: stringInfo.sSTR_XMDATA_UPMOST_10_ITEMS_CAN_BE_ADDED;

        onClose: {
            hide();
        }
        function show(){
            idMenuBar.z = -2;
            idListIsFullPopUp.z = idMenuBar.z+3;
            idCenterFocusScopeForLocation.focus = false;
            idListIsFullPopUp.visible = true;
            idListIsFullPopUp.focus = true;
            idListIsFullPopUp.forceActiveFocus();
        }
        function hide(){
            idListIsFullPopUp.z = idMenuBar.z-1;
            idMenuBar.z = 1;
            idListIsFullPopUp.visible = false;
            idListIsFullPopUp.focus = false;
            idCenterFocusScopeForLocation.focus = true;
            idCenterFocusScopeForLocation.forceActiveFocus();
        }
    }

    MPopup.Case_D_DeleteAllQuestion{
        id:idDeleteAllQuestion
        visible : false;
        text: stringInfo.sSTR_XMDATA_DELETE_ALL_MESSAGE
        property string targetId;
        property QtObject target;
        onClose: {
            weatherDataManager.rollbackDeleteItems();
            hide();
        }
        onButton1Clicked: {
            //Delete All?
            hide();
            weatherDataManager.deleteAllFavoriteList();
            reallyDeletedSuccessfully();
            idDeleteAllQuestion.visible = false;
            idDeleteAllQuestion.focus = false;
            onBack();
        }
        function show(){
            idMenuBar.z = -2;
            idCenterFocusScopeForLocation.focus = false;
            idDeleteAllQuestion.visible = true;
            idDeleteAllQuestion.focus = true;
            idDeleteAllQuestion.forceActiveFocus();
        }
        function hide(){
            idMenuBar.z = 1;
            idDeleteAllQuestion.visible = false;
            idDeleteAllQuestion.focus = false;
            idCenterFocusScopeForLocation.focus = true;
            idCenterFocusScopeForLocation.forceActiveFocus();
        }
    }

    //Option Menu
    //    Loader{id:idOptionMenu; z: parent.z+1}

    Component{
        id: idCompOptionMenu
        MMenu.WeatherOptionMenuForLocation {
            y:0
            onMenuHided: {
                focus = false;
                idCenterFocusScope.focus = true;
                if(idDeleteFavorite.visible)
                {
                    idDeleteFavorite.focus = true;
                    idDeleteFavorite.item.moveFocusToList();
                }
                else
                {
                    idMenuAndList_FocusScope.focus = true;
                    idMainListFocusScope.focus = true;
                }
            }

            onOptionMenuForSearch: {
                idWeatherSearchForCity.show();
            }
            onOptionMenuForAddFavorite: {
                idWeatherSearchForCity.show();
            }
            onOptionMenuForReorder: {
                idChangeRow.show();
            }
            onOptionMenuForDelete: {
                idDeleteFavorite.show();
            }
            onOptionMenuForCancelDelete: {
                idDeleteFavorite.hide();
            }
        }
    }

    function onSelectTtem(CityID)
    {
        weatherDataManager.bIsUserLocMode = (true);
        if(szMode == "City")
        {
            selectLocationCity(CityID);
        }else
        {
            selectLocationSki(CityID)
        }
    }

    function selectCity()
    {
        szMode = "City";
        idMenuAndList_FocusScope.focus = true;
        idMenuBar.locationBtnFlag = false;
        UIListener.autoTest_athenaSendObject();
    }

    function selectSki()
    {
        szMode = "Ski";
        idMenuAndList_FocusScope.focus = true;
        idMenuBar.locationBtnFlag = false;
        UIListener.autoTest_athenaSendObject();
    }

    function selectFavorite()
    {
        szMode = "Favorite";
        idMenuAndList_FocusScope.focus = true;
        idMenuBar.locationBtnFlag = false;
        UIListener.autoTest_athenaSendObject();
    }

    function selectLocationCity(cityid)
    {
        interfaceManager.reqWeatherCity(cityid);
        onDestoryLocation();
        onToday();
    }

    function selectLocationSki(skiid)
    {
        interfaceManager.reqWeatherSki(skiid);
        onDestoryLocation();
        onSki();
    }

    function onMenu()
    {
        if(idMenuBar.menuBtnFlag == false)
            return;

        if(idChangeRow.visible == true){return;}
        if(idWeatherSearchForCity.visible == true){return;}
        if(idDeleteAllQuestion.visible == true){return;}

        idOptionMenu.visible = true;
        idOptionMenu.sourceComponent = idCompOptionMenu;
        idOptionMenu.item.showMenu();
        idOptionMenu.focus = true;
    }

    function onBack()
    {
        if(idChangeRow.visible){
            if(!backForChangeRow())
                return true;
            return false;
        }else if(idWeatherSearchForCity.visible){
            idWeatherSearchForCity.hide();
            return false;
        }else if(idDeleteFavorite.visible){
            idDeleteFavorite.hide();
            return false;
        }

        return true;
    }

    function backForDeleteFavorite()
    {
        if(idDeleteFavorite.visible){
            idDeleteFavorite.hide();
        }
    }
    function backForChangeRow()
    {
        if(idChangeRow.visible){
            return idChangeRow.hide();
        }
        return false;
    }
    function backForWeatherSearchForCity()
    {
        if(idWeatherSearchForCity.visible){
            stopToastPopup();
            idWeatherSearchForCity.hide();
        }
    }

    function leftFocusAndLock(isLock)
    {
        if(isLock == true)
        {
            if(idLeftMenuFocusScope.visible)
                idLeftMenuFocusScope.forceActiveFocus();
            idLeftMenuFocusScope.KeyNavigation.right = null;
        }else{
            idLeftMenuFocusScope.KeyNavigation.right = idMainListFocusScope;
        }
    }

    function checkFocusOfMovementEnd()
    {
        checkFocusOfScreen();
    }

    function checkFocusOfScreen()
    {
        if(idCenterFocusScopeForLocation.visible == true && (idLeftMenuFocusScope.activeFocus == true || idMenuBar.contentItem.KeyNavigation.up.activeFocus == true)){
            idCenterFocusScope.focus = true;
            idLocation.focus = true;
            idCenterFocusScopeForLocation.focus = true;
            if(idMenuAndList_FocusScope.visible == true){
                idMenuAndList_FocusScope.focus = true;
                idMainListFocusScope.focus = true;
            }else if(idWeatherSearchForCity.visible == true){
                idWeatherSearchForCity.focus = true;
            }
        }
    }

    Connections {
        target : idAppMain
        onToastPopupClose:{
            if(visible)
            {
                UIListener.consolMSG("WeatherLocation onToastPopupClose");
                idCenterFocusScopeForLocation.focus = true;
                idMenuAndList_FocusScope.forceActiveFocus();
            }
        }
    }
}//container
