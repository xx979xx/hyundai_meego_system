import Qt 4.7

// System Import
import "./Menu" as MMenu
import "./ListDelegate" as XMDelegate

import "../../component/XMData/Common" as XMCommon
import "./Popup" as MPopup

// Because Loader is a focus scope, converted from FocusScope to Item.
//Item {
FocusScope{
    id:container
    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight;
    focus: true

    property string szMode : ""//brand"//"all"
    property string selectedBrand: "";
    property string selectedBrandName : "";
    property string selectedType: "";

    property bool onRoute: fuelPriceDataManager.isOnRoute;
    property bool mainDistanceUnitChange: interfaceManager.DBIsMileDistanceUnit;
    property bool checkDRSStatus: idAppMain.isDRSChange

    onVisibleChanged: {
        UIListener.consolMSG("FuelPriceMenu visible = " + visible);
        if(visible == false)
        {
            idDrsScreen.hide();
        }
    }

    onCheckDRSStatusChanged: {
        if(visible)
        {
            if(idFuelSearch.visible == true || idFuelBrandSearch.visible == true)
            {
                if(checkDRSStatus == true && idDrsScreen.visible == false)
                {
                    if(idFuelSearch.visible)
                    {
                        idFuelSearch.item.hideListIsFull();
                    }
                    if(idListIsSDMountPopUp.visible)
                    {
                        idListIsSDMountPopUp.hide();
                    }
                    else if(idGotoFuelQuestion.visible)
                    {
                        idGotoFuelQuestion.hide();
                    }
                    idDrsScreen.show();
                }
                else if(checkDRSStatus == false && idDrsScreen.visible == true)
                    idDrsScreen.hide();
                else
                    idDrsScreen.hide();
            }
        }
    }

    onOnRouteChanged: {
        console.log("FuelPriceMenu.qml onOnRouteChanged onRoute = " + onRoute)
        if(onRoute)
        {
        }else
        {
            fuelPriceDataManager.setSortColumn();
            interfaceManager.reqNaviOnRouteStop();
        }
    }

    Keys.onPressed: {
        console.log("[QML] FuelPriceMenu.qml Key Pressed")
        if( idAppMain.isMenuKey(event) ) {
            onOptionOnOff();
        }else if(idAppMain.isBackKey(event)){
            stopToastPopup();
            gotoBackScreen(false);//CCP
        }
    }

    // MenuBar ( Titles & Back Buttons )
    XMCommon.XMMBand
    {
        id: idMenuBar
        z: -1
        textTitle: stringInfo.sSTR_XMDATA_FUELPRICES
        intelliKey: fuelPriceDataManager.dIntelliKey
        contentItem: idCenterFocusScope
        function resetTitle()
        {
            textTitle = stringInfo.sSTR_XMDATA_FUELPRICES
        }
    }

    // Center Area Under Menu Bar
    FocusScope{
        id: idCenterFocusScope
        focus:true

        x:0; y:systemInfo.titleAreaHeight;
        width:  parent.width;
        height: parent.height-y;

        //Left Menu And Right List
        FocusScope{
            id:idMainMenuAndListFocusScope
            width:  parent.width;
            height: parent.height;
            focus: (idMainMenuAndListFocusScope.visible==true)
            visible: (idFuelSearch.visible!=true)&&(idFuelBrandSearch.visible!=true)&&(idDeleteFavorite.visible!=true)
            //Left menu(All, Brand, Fuel Type, Favorite
            XMDataLeftMenuGroup{
                id:idLeftMenuFocusScope
                KeyNavigation.right: idMainListFocusScope
                countOfButton: 4; //Fure Price has 4 LefeMenu(All, Brand, Fuel Type, Favorite)

                button1Text: stringInfo.sSTR_XMDATA_ALL;
                button1Active: szMode == "all"
                onButton1Clicked: {
                    selectAll();
                }
                button2Text: stringInfo.sSTR_XMDATA_BRAND
                button2Active: (szMode == "brand") || (szMode == "brand_name")
                onButton2Clicked: {
                    selectedBrand = "";
                    selectBrand();
                }
                button3Text: stringInfo.sSTR_XMDATA_FUELTYPE
                button3Active: (szMode == "type") || (szMode == "type_name")
                onButton3Clicked: {
                    selectedType = "";
                    selectType();
                }
                button4Text: stringInfo.sSTR_XMDATA_FAVORITE
                button4Active: szMode == "favorite"
                onButton4Clicked: {
                    selectFavorite();
                }
            }
            //Right List
            FocusScope{
                id:idMainListFocusScope
                KeyNavigation.left:idLeftMenuFocusScope
                x: idLeftMenuFocusScope.width
                y : 0
                width:parent.width - idLeftMenuFocusScope.width
                height:parent.height;
                focus:true;

                Loader{
                    id: idStoreAllList
                    anchors.fill: parent
                    function hide()
                    {
                        idMenuBar.enableMenuBtn = true;
                        idStoreAllList.visible = false;
                    }
                    function show()
                    {
                        idMenuBar.enableMenuBtn = false;
                        idStoreAllList.source = "FuelPricesAllStores.qml"
                        idStoreAllList.item.listModel = fuelPriceList
                        idStoreAllList.item.selectedBrand = container.selectedBrand;
                        idStoreAllList.item.selectedBrandName = container.selectedBrandName;
                        idStoreAllList.item.selectedType = container.selectedType;
                        idStoreAllList.item.selectedBrand = container.selectedBrand;
                        idStoreAllList.item.focus = true;
                        idStoreAllList.item.subDistanceUnitChange = mainDistanceUnitChange;
                        idStoreAllList.visible = true;
                        idStoreAllList.focus = true;

                        idStoreBrandList.hide();
                        idStoreTypeList.hide();
                        idBrandList.hide();
                        idTypeList.hide();
                        idFavoriteList.hide();
                        idStoreAllList.item.doCheckEnableMenuBtn();
                    }
                }

                Loader{
                    id: idStoreBrandList
                    anchors.fill: parent
                    function hide()
                    {
                        idMenuBar.enableMenuBtn = true;
                        idStoreBrandList.visible = false;
                    }
                    function show()
                    {
                        idStoreBrandList.source = "FuelPricesAllStores.qml"
                        idStoreBrandList.item.listModel = fuelBrandPriceList
                        idStoreBrandList.item.selectedType = container.selectedType;
                        idStoreBrandList.item.selectedBrand = container.selectedBrand;
                        idStoreBrandList.item.focus = true;
                        idStoreBrandList.item.subDistanceUnitChange = mainDistanceUnitChange;
                        idStoreBrandList.visible = true;
                        idStoreBrandList.focus = true;

                        idStoreAllList.hide();
                        idStoreTypeList.hide();
                        idBrandList.hide();
                        idTypeList.hide();
                        idFavoriteList.hide();
                        idStoreBrandList.item.doCheckEnableMenuBtn();
                    }
                }

                Loader{
                    id: idStoreTypeList
                    anchors.fill: parent
                    function hide()
                    {
                        idMenuBar.enableMenuBtn = true;
                        idStoreTypeList.visible = false;
                    }
                    function show()
                    {
                        idStoreTypeList.source = "FuelPricesAllStores.qml"
                        idStoreTypeList.item.listModel = fuelTypePriceList
                        idStoreTypeList.item.selectedType = container.selectedType;
                        idStoreTypeList.item.selectedBrand = container.selectedBrand;
                        idStoreTypeList.item.focus = true;
                        idStoreTypeList.item.subDistanceUnitChange = mainDistanceUnitChange;
                        idStoreTypeList.visible = true;
                        idStoreTypeList.focus = true;

                        idStoreAllList.hide();
                        idStoreBrandList.hide();
                        idBrandList.hide();
                        idTypeList.hide();
                        idFavoriteList.hide();
                        idStoreTypeList.item.doCheckEnableMenuBtn();
                    }
                }

                Loader{
                    id: idBrandList
                    anchors.fill: parent
                    function hide()
                    {
                        idMenuBar.enableMenuBtn = true;
                        idBrandList.visible = false;
                    }
                    function show()
                    {
                        idBrandList.source = "FuelPricesBrand.qml"
                        idBrandList.item.listModel = fuelBrandList
                        idBrandList.item.focus = true;
                        idBrandList.visible = true;
                        idBrandList.focus = true;

                        idStoreAllList.hide();
                        idStoreBrandList.hide();
                        idStoreTypeList.hide();
                        idTypeList.hide();
                        idFavoriteList.hide();
                        idBrandList.item.doCheckEnableMenuBtn();
                    }
                }

                Loader{
                    id: idTypeList
                    anchors.fill: parent
                    function hide()
                    {
                        idMenuBar.enableMenuBtn = true;
                        idMenuBar.menuBtnFlag = true;
                        idTypeList.visible = false;
                    }
                    function show()
                    {
                        idMenuBar.menuBtnFlag = false;

                        idTypeList.source = "FuelPricesTypeMenu.qml"
                        idTypeList.item.focus = true;
                        idTypeList.visible = true;
                        idTypeList.focus = true;

                        idStoreAllList.hide();
                        idStoreBrandList.hide();
                        idStoreTypeList.hide();
                        idBrandList.hide();
                        idFavoriteList.hide();
                        idTypeList.item.doCheckEnableMenuBtn();
                    }
                }

                Loader{
                    id: idFavoriteList
                    anchors.fill: parent
                    function hide()
                    {
                        idFavoriteList.visible = false;
                    }
                    function show()
                    {
                        idFavoriteList.source = "FuelPricesMyFavorites.qml"
                        idFavoriteList.item.listModel = fuelFavoriteList;
                        idFavoriteList.item.focus = true;
                        idFavoriteList.focus = true;
                        if(!idFavoriteList.visible)
                        {
                        idStoreAllList.hide();
                        idStoreBrandList.hide();
                        idStoreTypeList.hide();
                        idBrandList.hide();
                        idTypeList.hide();
                            idFavoriteList.visible = true;
                        }
                    }
                }
            }//idMainListFocusScope
        }//idMainMenuAndListFocusScope

        //idFuelSearch
        Loader {
            id:idFuelSearch
            objectName: "fuelSearchMenu"
            width:parent.width;
            height:parent.height
            focus: false
            visible:false

            function hide()
            {
                if(checkDRSStatus)
                {
                    idDrsScreen.hide();
                }
                idMenuBar.resetTitle();
                idCenterFocusScope.focus = true;
                idMenuBar.visibleSearchTextInput = false;
                idFuelSearch.visible = false;
                idFuelSearch.source = ""
                if(idMainMenuAndListFocusScope.visible == true) idMainMenuAndListFocusScope.forceActiveFocus()
                else idCenterFocusScope.forceActiveFocus();
                idMainListFocusScope.focus = true;
                fuelPriceDataManager.checkForFocusForElement(false);
            }
            function show()
            {
                idMenuBar.textTitle = stringInfo.sSTR_XMDATA_SEARCH;
                idCenterFocusScope.focus = true;
                idFuelSearch.source = "FuelPricesSearch.qml"
                idFuelSearch.visible = true;
                idFuelSearch.focus = true;
                if(checkDRSStatus)
                {
                    idDrsScreen.show();
                }
                idMenuBar.visibleSearchTextInput = true;
            }
        }//idFuelSearch

        //idFuelBrandSearch
        Loader {
            id:idFuelBrandSearch
            objectName: "fuelBrandSearchMenu"
            width:parent.width;
            height:parent.height;
            visible:false;
            focus: false;
            function hide()
            {
                if(checkDRSStatus)
                {
                    idDrsScreen.hide();
                }
                idMenuBar.resetTitle();
                idCenterFocusScope.focus = true;
                idMenuBar.visibleSearchTextInput = false;
                idFuelBrandSearch.visible = false;
                idFuelBrandSearch.source = "";
                idMainMenuAndListFocusScope.forceActiveFocus();
                fuelPriceDataManager.checkForFocusForElement(false);
            }
            function show()
            {
                idMenuBar.textTitle = stringInfo.sSTR_XMDATA_SEARCH;
                idCenterFocusScope.focus = true;
                idMainListFocusScope.focus = true;
                idFuelBrandSearch.source = "FuelPricesSearchBrand.qml"
                idFuelBrandSearch.visible = true;
                idFuelBrandSearch.focus = true;
                if(checkDRSStatus)
                {
                    idDrsScreen.show();
                }
                idMenuBar.visibleSearchTextInput = true;
            }
        }

        //idDeleteFavorite
        Loader{
            id:idDeleteFavorite
            width: parent.width
            height: parent.height
            visible: false
            focus: false
            function hide()
            {
                idMenuBar.resetTitle();
                idMenuBar.deleteAllNoFlag = false;
                idDeleteFavorite.visible = false;
                idDeleteFavorite.source = "";
                fuelFavoriteList.dynamicSortFilter = true;
                if(isToastPopupVisible() == false)
                {
                    idCenterFocusScope.focus = true;
                    idMainMenuAndListFocusScope.forceActiveFocus();
                }
                fuelPriceDataManager.checkForFocusForElement(false);
            }
            function show()
            {
                idCenterFocusScope.focus = true;
                idDeleteFavorite.source = "FuelPricesMyFavoritesDeleteStore.qml"
                fuelFavoriteList.dynamicSortFilter = false;
                idDeleteFavorite.visible = true;
                idMenuBar.deleteAllNoFlag = true;
                idDeleteFavorite.focus = true;
                idDeleteFavorite.forceActiveFocus();
                fuelPriceDataManager.checkForFocusForElement(false);
            }
            Connections{
                target: idDeleteFavorite.item
                onClose:{
                    onBack();
                    fuelPriceDataManager.checkForFocusForElement(false);
                }
                onShowDeleteAllPopup: {
                    idDeleteAllQuestion.show();
                }
            }
        }
    }//idCenterFocusScope

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
            if(idFuelSearch.visible == true || idFuelBrandSearch.visible == true)
            {
                stopToastPopup();
                idMenuBar.checkDRSVisible = true;
                idDrsScreen.visible = true;
            }
        }
        function hide()
        {
            idMenuBar.checkDRSVisible = false;
            idDrsScreen.visible = false;
        }
    }

    Loader{id:idOptionMenu; z: parent.z+1}

    Component{
        id:idCompOptionMenuForAll
        MMenu.FuelPricesOptionMenuForAll{
            id:idOptionMenuForAll

            onMenuHided: {
                idOptionMenuForAll.focus = false;
                idCenterFocusScope.focus = true;
                idMainMenuAndListFocusScope.focus = true;
                if(idStoreAllList.item.listCount > 0)
                {
                    idMainListFocusScope.focus = true;
                }
            }
            onOptionMenuSortByPrice:{
                if(onRoute)
                    fuelPriceDataManager.setOnRouteChangedListModel(false);
                idStoreAllList.item.currentIndexInitDelegate();
                fuelPriceDataManager.setSortColumn(true, 0);
                fuelPriceDataManager.checkForFocusForElement(false);
            }
            onOptionMenuSortByDistance:{
                if(onRoute)
                    fuelPriceDataManager.setOnRouteChangedListModel(false);
                idStoreAllList.item.currentIndexInitDelegate();
                fuelPriceDataManager.setSortColumn(true, 1);
                fuelPriceDataManager.checkForFocusForElement(false);
            }
            onOptinoMenuSortByAtoZ:{
                if(onRoute)
                    fuelPriceDataManager.setOnRouteChangedListModel(false);
                idStoreAllList.item.currentIndexInitDelegate();
                fuelPriceDataManager.setSortColumn(true, 3); //By Name
                fuelPriceDataManager.checkForFocusForElement(false);
            }
            onOptionMenuSortByOnRoute: {
                idStoreAllList.item.currentIndexInitDelegate();
                interfaceManager.reqNaviOnRouteData(0);
                fuelPriceDataManager.checkForFocusForElement(false);
            }
            onOptionMenuSearch:{
                 idFuelSearch.show();
            }
            onOptionMenuSubcriptionStatus:{
            }
        }
    }

    Component{
        id:idCompOptionMenuForBrand
        MMenu.FuelPricesOptionMenuForBrand{
            id:idOptionMenuForBrand

            onMenuHided: {
                idOptionMenuForBrand.focus = false;
                idCenterFocusScope.focus = true;
                idMainMenuAndListFocusScope.focus = true;
                idMainListFocusScope.focus = true;
            }
            onOptinoMenuSortByAtoZ:{
                fuelPriceDataManager.setBrandSortColumn(0, 0);
                fuelPriceDataManager.checkForFocusForElement(false);
            }
            onOptionMenuSortByFranchise:{
                fuelPriceDataManager.setBrandSortColumn(0, 1);
                fuelPriceDataManager.checkForFocusForElement(false);
            }
            onOptionMenuSearch:{
                idFuelBrandSearch.show();
            }
        }
    }

    Component{
        id:idCompOptionMenuForFavorite
        MMenu.FuelPricesOptionMenuForFavorite{
            id:idOptionMenuForFavorite

            onMenuHided: {
                idOptionMenuForFavorite.focus = false;
                if(!idFuelSearch.visible)
                {
                    idCenterFocusScope.focus = true;
                    if(idDeleteFavorite.visible)
                    {
                        idDeleteFavorite.focus = true;
                        idDeleteFavorite.item.moveFocusToList();
                    }
                    else
                    {
                        idMainMenuAndListFocusScope.focus = true;
                        if(idFavoriteList.item.getListCount())
                        {
                            idMainListFocusScope.focus = true;
                        }
                    }
                }
            }
            onOptionMenuAddFavorite: {
                idFuelSearch.show();
            }
            onOptionMenuDelete: {
                idDeleteFavorite.show();
            }
            onOptionMenuCancelDelete: {
                onBack();
            }
        }
    }

    MPopup.Case_E_Warning{
        id:idListIsSDMountPopUp
        z: parent.z + 2
        visible : false;
        focus:false;
        detailText1: stringInfo.sSTR_XMDATA_SD_CARD_ERROR;
        popupLineCnt: 1

        onClose: {
            hide();
        }
        function show(){
            idListIsSDMountPopUp.visible = true;
            idListIsSDMountPopUp.focus = true;
        }
        function hide(){
            idListIsSDMountPopUp.visible = false;
            idListIsSDMountPopUp.focus = false;
            idCenterFocusScope.focus = true;
            idCenterFocusScope.forceActiveFocus();
        }
    }

    // Yes or No Popup
    MPopup.Case_D_DeleteAllQuestion{
        id:idGotoFuelQuestion
        z: parent.z + 2
        visible : false;
        text: brand + "\n" + address + "\n" + stringInfo.sSTR_XMDATA_POPUP_QEUSTION
        property int locID: 0
        property string brand: ""
        property string address: ""

        onClose: {
            hide();
        }

        onButton1Clicked: {
            if(interfaceManager.isMountedMMC == false)
            {
                hide();
                idListIsSDMountPopUp.show();
            }else
            {
                sendDataToNavigation(locID);
            }
        }
        function show(locationID, name, addr){
            locID = locationID;
            brand = name;
            address = addr;

            idGotoFuelQuestion.visible = true;
            idGotoFuelQuestion.focus = true;
        }
        function hide(){
            idGotoFuelQuestion.visible = false;
            idGotoFuelQuestion.focus = false;
            idCenterFocusScope.focus = true;
            idCenterFocusScope.forceActiveFocus();
        }
    }

    MPopup.Case_D_DeleteAllQuestion{
        id:idDeleteAllQuestion
        visible : false;
        text: stringInfo.sSTR_XMDATA_DELETE_ALL_MESSAGE
        property string targetId;
        property QtObject target;
        onClose: {
            fuelPriceDataManager.rollbackDeleteItems();
            hide();
        }
        onButton1Clicked: {
            //Delete All?
            fuelPriceDataManager.deleteAllFavoriteList();
            reallyDeletedSuccessfully();
            idDeleteAllQuestion.visible = false;
            idDeleteAllQuestion.focus = false;
            onBack();
        }
        function show(){
            idDeleteFavorite.focus = false;
            idDeleteAllQuestion.visible = true;
            idDeleteAllQuestion.focus = true;
            idDeleteAllQuestion.forceActiveFocus();
        }
        function hide(){
            idDeleteAllQuestion.visible = false;
            idDeleteAllQuestion.focus = false;
            idDeleteFavorite.focus = true;
            idDeleteFavorite.forceActiveFocus();
        }
    }

    function selectAll()
    {
        szMode = "all";
        selectedBrand = "";
        selectedType = "";
        fuelPriceDataManager.updateViewByFuelType(4);
        idStoreAllList.show();
        fuelPriceDataManager.checkForFocusForElement(true);

        console.log("=======[FuelPricesMenu.qml][selectAll()][leftFocusAndLock]=====fuelPriceDataManager.getRowCountFuelAll() = "+fuelPriceDataManager.getRowCountFuelAll());

        if(fuelPriceDataManager.getRowCountFuelAll() == 0)
            leftFocusAndLock(true)
        else
            leftFocusAndLock(false)

        if(idLeftMenuFocusScope.KeyNavigation.right != null)
            idLeftMenuFocusScope.KeyNavigation.right.focus = true;
//        idMainListFocusScope.forceActiveFocus();
    }

    function selectBrand()
    {
        szMode = "brand";
        idBrandList.show();
        fuelPriceDataManager.setSortColumn();
        if(selectedBrand != "")
        {
            selectedBrand = "";
        }else
        {
            fuelPriceDataManager.checkForFocusForElement(true);
        }
        selectedType = "";

        console.log("=======[FuelPricesMenu.qml][selectBrand()][leftFocusAndLock]=====fuelPriceDataManager.getRowCountFuelViewBrand() = "+fuelPriceDataManager.getRowCountFuelViewBrand());

        if(fuelPriceDataManager.getRowCountFuelViewBrand() == 0)
            leftFocusAndLock(true)
        else
            leftFocusAndLock(false)
        if(idLeftMenuFocusScope.KeyNavigation.right != null)
            idLeftMenuFocusScope.KeyNavigation.right.focus = true;
    }

    function selectType()
    {
        szMode = "type";
        idTypeList.show();
        fuelPriceDataManager.setSortColumn();
        selectedBrand = "";
        if(selectedType != "")
        {
            selectedType = "";
        }else
        {
            fuelPriceDataManager.checkForFocusForElement(true);
        }

        console.log("=======[FuelPricesMenu.qml][selectType()][leftFocusAndLock]=====");

        leftFocusAndLock(false);
        if(idLeftMenuFocusScope.KeyNavigation.right != null)
            idLeftMenuFocusScope.KeyNavigation.right.focus = true;
    }

    function selectFavorite()
    {
        szMode = "favorite";
        selectedBrand = "";
        selectedType = "";
        idFavoriteList.show();
        fuelPriceDataManager.checkForFocusForElement(true);

        if(fuelPriceDataManager.getRowCountFuelAllSortModel() == 0)
            leftFocusAndLock(true)
        else
            leftFocusAndLock(false);

        if(idLeftMenuFocusScope.KeyNavigation.right != null)
            idLeftMenuFocusScope.KeyNavigation.right.focus = true;
    }

    function selectBrandname(brand)
    {
        szMode = "brand_name"
        selectedBrand = brand;
        fuelPriceDataManager.updateListBrandModel(brand);
        idStoreBrandList.show();
        fuelPriceDataManager.checkForFocusForElement(true);
        if (fuelPriceDataManager.getRowCountFuelSelectBrand() != 0) {
            idMainListFocusScope.focus = true;
            idMainListFocusScope.forceActiveFocus();
        }
    }

    function selectTypename(type)
    {
        szMode = "type_name";
        selectedType = type;
        switch(type)
        {
        case 0:
            fuelPriceDataManager.updateViewByFuelType(type);
            break;
        case 1:
            fuelPriceDataManager.updateViewByFuelType(type);
            break;
        case 2:
            fuelPriceDataManager.updateViewByFuelType(type);
            break;
        case 3:
            fuelPriceDataManager.updateViewByFuelType(type);
            break;
        default :
            fuelPriceDataManager.updateViewByFuelType(4);
            break;
        }

        idStoreTypeList.show();
        fuelPriceDataManager.checkForFocusForElement(true);
        idStoreTypeList.item.currentIndexInitDelegate();
        idStoreTypeList.forceActiveFocus();

        console.log("=======[FuelPricesMenu.qml][selectTypename()][leftFocusAndLock]=====fuelPriceDataManager.getRowCountFuelType() = "+fuelPriceDataManager.getRowCountFuelType());

        if(fuelPriceDataManager.getRowCountFuelType() == 0)
            leftFocusAndLock(true)
        else
        {
            leftFocusAndLock(false)
        }
    }

    function initLeftMenuFocus()
    {
        idLeftMenuFocusScope.initFirstFocus();
    }

    function onOptionOnOff()
    {
        if(idFuelSearch.visible == true){return;}
        if(idFuelBrandSearch.visible == true){return;}
        if(idGotoFuelQuestion.visible == true) {return;}
        if(idListIsSDMountPopUp.visible == true) {return;}
        if(idDeleteAllQuestion.visible == true) {return;}

        if(idMenuBar.enableMenuBtn == false) return;

        if(szMode == "all" || szMode == "brand_name" || szMode == "type_name"){
            console.log("[QML] FuelPriceMenu.qml Menu Key Pressed - All ShowMenu")
            idOptionMenu.sourceComponent = idCompOptionMenuForAll;
            idOptionMenu.item.showMenu();
            idCenterFocusScope.focus = false;
            idOptionMenu.focus = true;
        }else if(szMode == "brand"){
            console.log("[QML] FuelPriceMenu.qml Menu Key Pressed - Brand ShowMenu")
            idOptionMenu.sourceComponent = idCompOptionMenuForBrand;
            idOptionMenu.item.showMenu();
            idCenterFocusScope.focus = false;
            idOptionMenu.focus = true;
        }else if(szMode == "favorite"){
            idOptionMenu.sourceComponent = idCompOptionMenuForFavorite;

            if(idDeleteFavorite.visible)
                idOptionMenu.item.menuForDelete = true;
            else
                idOptionMenu.item.menuForDelete = false;

            idOptionMenu.item.showMenu();
            idCenterFocusScope.focus = false;
            idOptionMenu.focus = true;
            if(fuelPriceDataManager.getRowCountFuelAll() == 0 && onRoute == false)
            {
                idOptionMenu.item.optionMenu.menu0Enabled = false;
            }
            else
            {
                idOptionMenu.item.optionMenu.menu0Enabled = true;
            }
            if(idFavoriteList.item.listCount == 0)
            {
                idOptionMenu.item.optionMenu.menu1Enabled = false;
            }
            else
            {
                idOptionMenu.item.optionMenu.menu1Enabled = true;
            }

            if(idFavoriteList.item.listCount == 0)
            {
                idOptionMenu.item.optionMenu.menu2Enabled = false;
            }
            else
            {
                idOptionMenu.item.optionMenu.menu2Enabled = true;
            }
        }
    }

    function getCurrentOptionSortMode()
    {
        if(onRoute)
            return stringInfo.sSTR_XMDATA_ON_ROUTE;
        switch(szMode)
        {
            case "all":
            {
                switch(fuelPriceList.sortRole)
                {
                    case (33 + 3):
                    case (33 + 4):
                    case (33 + 5):
                    case (33 + 6):
                        return stringInfo.sSTR_XMDATA_PRICE;
                    case (33 + 7):
                        return stringInfo.sSTR_XMDATA_DISTANCE;
                    case (33 + 12):
                        return stringInfo.sSTR_XMDATA_ATOZ;
                }
                return 0;
            }
            case "brand_name":
            {
                switch(fuelBrandPriceList.sortRole)
                {
                    case (33 + 3):
                    case (33 + 4):
                    case (33 + 5):
                    case (33 + 6):
                        return stringInfo.sSTR_XMDATA_PRICE;
                    case (33 + 7):
                        return stringInfo.sSTR_XMDATA_DISTANCE;
                    case (33 + 12):
                        return stringInfo.sSTR_XMDATA_ATOZ;
                }
                return 0;
            }
            case "type_name":
            {
                switch(fuelTypePriceList.sortRole)
                {
                    case (33 + 3):
                    case (33 + 4):
                    case (33 + 5):
                    case (33 + 6):
                        return stringInfo.sSTR_XMDATA_PRICE;
                    case (33 + 7):
                        return stringInfo.sSTR_XMDATA_DISTANCE;
                    case (33 + 12):
                        return stringInfo.sSTR_XMDATA_ATOZ;
                }
                return 0;
            }
            case "brand":
            {
                switch(fuelBrandList.sortRole)
                {
                    case (33 + 0):
                        return stringInfo.sSTR_XMDATA_ATOZ;
                    case (33 + 1):
                        return stringInfo.sSTR_XMDATA_FRANCHISE;
                }
                return 0;
            }
            case "favorite":
            {
                switch(fuelFavoriteList.sortRole)
                {
                    case (33 + 3):
                    case (33 + 4):
                    case (33 + 5):
                    case (33 + 6):
                        return stringInfo.sSTR_XMDATA_PRICE;
                    case (33 + 7):
                        return stringInfo.sSTR_XMDATA_DISTANCE;
                    case (33 + 12):
                        return stringInfo.sSTR_XMDATA_ATOZ;
                }
                return 0;
            }
            default:
                return 0;
        }
    }

    function onBack()
    {
        // movieMovie, movieTheater, movieFavorite, movieMovieTheater, movieTheaterMovie
        if(szMode == "brand_name" && idFuelSearch.visible == false)
        {
            selectBrand();
            return false;
        }
        if(szMode == "type_name" && idFuelSearch.visible == false)
        {
            selectType();
            return false;
        }

        if(idFuelSearch.visible){
            stopToastPopup();
            idFuelSearch.hide();
            return false;
        }else if(idFuelBrandSearch.visible){
            idFuelBrandSearch.hide();
            return false;
        }else if(idDeleteFavorite.visible){
            idDeleteFavorite.hide();
            return false;
	}
        return true;
    }
    /////////////////////////////////////////////////////////////
    function sendDataToNavigation(locationID) {
        fuelPriceDataManager.reqSendFuelStationDataToNavigation(locationID);
        if( !UIListener.HandleGoToNavigationForFuelPrice() ){
                showNotConnectedWithNavigation("NotifyUISH event sending failed");
        }
    }

    function leftFocusAndLock(isLock)
    {
        if(isLock == true)
        {
            if(idLeftMenuFocusScope.visible)
            {
                idLeftMenuFocusScope.focus = true;
            }
            idLeftMenuFocusScope.KeyNavigation.right = null;
        }else{
            idLeftMenuFocusScope.KeyNavigation.right = idMainListFocusScope;
            idMainListFocusScope.focus = true;
        }
    }

    function checkFocusOfMovementEnd()
    {
        checkFocusOfScreen();
    }

    function checkFocusOfScreen()
    {
        if(idCenterFocusScope.visible == true && (idLeftMenuFocusScope.activeFocus == true || idMenuBar.contentItem.KeyNavigation.up.activeFocus == true)){
            idCenterFocusScope.focus = true;
            if(idMainMenuAndListFocusScope.visible == true){
                idMainMenuAndListFocusScope.focus = true;
                idMainListFocusScope.focus = true;
            }else if(idFuelSearch.visible == true){
                idFuelSearch.focus = true;
            }else if(idFuelBrandSearch.visible == true){
                idFuelBrandSearch.focus = true;
            }
        }
    }

    function checkSDPopup(locationID, name, addr)
    {
        if(interfaceManager.isMountedMMC == false)
        {
            idListIsSDMountPopUp.show();
        }
        else
        {
            idGotoFuelQuestion.show(locationID, name, addr);
        }
    }

    Connections{
        target: interfaceManager

        onMmcStateChanged:{
            if(onRoute)
            {
                if(interfaceManager.isMountedMMC == false)
                {
                    if(idOptionMenu.visible == true)
                        idOptionMenu.item.allHideMenu();

                    if(szMode == "favorite")
                        fuelPriceDataManager.setSortColumnForFavorite();
                    else
                        fuelPriceDataManager.setSortColumn();

                    idCenterFocusScope.focus = true;
                    idCenterFocusScope.forceActiveFocus();
                }
            }
        }
    }

    Connections {
        target : idAppMain
        onToastPopupClose:{
            if(visible)
            {
                UIListener.consolMSG("FuelMenu onToastPopupClose");
                idCenterFocusScope.focus = true;
                idMainMenuAndListFocusScope.forceActiveFocus();
            }
        }
    }
}
