import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./Menu" as MMenu
import "./Popup" as MPopup
import "./Javascript/Definition.js" as MDefinition
import "../../component/XMData/Common" as XMCommon
import "./Popup" as MPopup


FocusScope{
    id:container
    objectName: "movieMenu"
    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight;

    property string szMovieMode : "movieMovie"

    property bool checkDRSStatus: idAppMain.isDRSChange
    property bool clockTime: interfaceManager.DBIsClockTimeSaving;

    property int nMovieID: 0
    property string szMovieName : ""
    property int nIndex: 0
    property int  nLocalID: 0

    onVisibleChanged: {
        UIListener.consolMSG("MovieTimeMenu visible = " + visible + ", DRS : " + checkDRSStatus);
        if(visible == false)
        {
            idDrsScreen.hide();
        }
    }

    //Movie Times Main Menu Key Processing
    Keys.onPressed: {
        console.log("[QML] MovieTimesMenu.qml Key Pressed")
        if( idAppMain.isMenuKey(event) ) {
            onOptionOnOff();
        }else if(idAppMain.isBackKey(event)){
            gotoBackScreen(false);//CCP
        }
    }

    onCheckDRSStatusChanged: {
        if(visible)
        {
            if(checkDRSStatus == true && idDrsScreen.visible == false)
            {
                if(idAddFavorite.visible)
                {
                    idAddFavorite.item.hideListIsFull();
                }
                if(idListIsSDMountPopUp.visible)
                {
                    idListIsSDMountPopUp.hide();
                }
                else if(idGotoTheaterQuestion.visible)
                {
                    idGotoTheaterQuestion.hide();
                }
                else if(idCallPopup.visible)
                {
                    idCallPopup.hide();
                }
                else if(idDescriptionPopup.visible)
                {
                    idDescriptionPopup.hide();
                }
                else if(idPopupCaseD.visible)
                {
                    idPopupCaseD.hide();
                }
                else
                {
                    idMovieListFocusScope.focus = true;
                }
                idDrsScreen.show();
            }
            else if(checkDRSStatus == false && idDrsScreen.visible == true)
            {
                idDrsScreen.hide();
            }
        }
    }

    XMCommon.XMMBand
    {
        id: idMenuBar
        z: -1
        textTitle : stringInfo.sSTR_XMDATA_MOVIETIMES
        contentItem: idCenterFocusScope
        intelliKey: movieTimesDataManager.dIntelliKey
        checkDRSVisible: (checkDRSStatus && visible)
        function resetTitle()
        {
            textTitle = stringInfo.sSTR_XMDATA_MOVIETIMES
        }
    }
    //idCenter Focus Scopce: Left Menu, Center List
    FocusScope{
        id:idCenterFocusScope
        x:0; y:systemInfo.titleAreaHeight;
        width:  parent.width;
        height: parent.height-y;
        focus:true;

        FocusScope{
            id:idMenuAndList_FocusScope
            focus:true
            width:parent.width;
            height:parent.height;
            visible: (idAddFavorite.visible!=true)&&(idSelectedDetailScreen_FocusScope.visible!=true)&&(idDeleteFavorite.visible!=true)
            // Left Menu Scope
            XMDataLeftMenuGroup{
                id:idMovieMain
                x:0; y:0;
                KeyNavigation.right: idMovieListFocusScope
                countOfButton: 3; //MovieTimes has 3 Left Menu(

                button1Text: stringInfo.sSTR_XMDATA_MOVIE;
                button1Active: szMovieMode == "movieMovie"
                onButton1Clicked: {
                    selectMovie();
                }
                button2Text: stringInfo.sSTR_XMDATA_THEATER
                button2Active: szMovieMode == "movieTheater"
                onButton2Clicked: {
                    selectTheater();
                }
                button3Text: stringInfo.sSTR_XMDATA_FAVORITE
                button3Active: szMovieMode == "movieFavorite"
                onButton3Clicked: {
                    selectFavorite();
                    if(movieTimesDataManager.getTheaterListCount() > 0 || idFavoriteList.item.listcount > 0)
                        KeyNavigation.right.forceActiveFocus();
                }
            }

            // List Scope
            FocusScope{
                id:idMovieListFocusScope
                x: idMovieMain.width
                y : 0
                width:parent.width - idMovieMain.width
                height:parent.height;
                KeyNavigation.left: idMovieMain
                focus:true;

                Loader{
                    id: idAllMovieList
                    anchors.fill: parent
                    function hide()
                    {
                        idMenuBar.enableMenuBtn = true;
                        idAllMovieList.visible = false;
                    }
                    function show()
                    {
                        idMenuBar.enableMenuBtn = false;
                        idAllMovieList.source = "MovieTimesAllMovie.qml"
                        idAllMovieList.visible = true;
                        idAllMovieList.item.focus = true;
                        idAllMovieList.focus = true;

                        idAllTheaterList.hide();
                        idFavoriteList.hide();
                        idAllMovieList.item.doCheckEnableMenuBtn();
                    }
                }

                Loader{
                    id: idAllTheaterList
                    anchors.fill: parent
                    function hide()
                    {
                        idMenuBar.enableMenuBtn = true;
                        idAllTheaterList.visible = false;
                    }
                    function show()
                    {
                        idAllTheaterList.source = "MovieTimesAllTheaters.qml"
                        idAllTheaterList.item.listModel = theaterList;
                        idAllTheaterList.item.focus = true;
                        idAllTheaterList.visible = true;
                        idAllTheaterList.focus = true;

                        idAllMovieList.hide();
                        idFavoriteList.hide();
                        idAllTheaterList.item.doCheckEnableMenuBtn();
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
                        idFavoriteList.source = "MovieTimesMyFavorites.qml"
                        idFavoriteList.item.listModel = favoriteList;
                        idFavoriteList.item.focus = true;
                        idFavoriteList.focus = true;

                        if(!idFavoriteList.visible)
                        {
                            idAllMovieList.hide();
                            idAllTheaterList.hide();
                            idFavoriteList.visible = true;
                        }

                    }
                }


            }
        }//idMenuAndList_FocusScope

        // Add Favorite
        Loader{
            id:idAddFavorite
            width: parent.width
            height: parent.height
            focus: false
            visible: false

            function hide()
            {
                idMenuBar.resetTitle();
                idMenuBar.menuBtnFlag = true;
                idMenuBar.visibleSearchTextInput = false;
                idAddFavorite.visible = false;
                idAddFavorite.source = ""
                idMenuAndList_FocusScope.focus = true;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.focus = true;
                    idMenuAndList_FocusScope.forceActiveFocus();
                }
            }
            function show()
            {
                idMenuBar.menuBtnFlag = false;
                idCenterFocusScope.focus = true;
                idAddFavorite.source = "MovieTimesMyFavoritesAddTheaters.qml"
                idAddFavorite.visible = true;
                idAddFavorite.focus = true;
                idMenuBar.visibleSearchTextInput = true;
            }
        }
        //idDeleteFavorite
        Loader{
            id:idDeleteFavorite
            width: parent.width
            height: parent.height
            focus: false
            visible: false
            function hide()
            {
                idMenuBar.resetTitle();
                idMenuBar.deleteAllNoFlag = false;
                idDeleteFavorite.visible = false;
                idDeleteFavorite.source = ""
            }
            function show()
            {
                idCenterFocusScope.focus = true;
                idDeleteFavorite.source = "MovieTimesMyFavoritesDeleteTheaters.qml"
                idDeleteFavorite.visible = true;
                idMenuBar.deleteAllNoFlag = true;
                idDeleteFavorite.focus = true;
                idDeleteFavorite.forceActiveFocus();
            }

            Connections{
                target: idDeleteFavorite.item
                onClose:{
                    onBack();
                }
            }
        }
        //Detail Screen
        FocusScope{
            id:idSelectedDetailScreen_FocusScope
            x: 0; y : 0;
            width:parent.width;
            height:parent.height - y;
            // Theater list of selected movie ID
            Loader {
                id: idMovieTheaterList
                width:parent.width;
                height:parent.height;
                focus:visible==true;
                visible:false;
                //XMRectangleForDebug{}//Left Menu Bound for debugging.
            }

            // Movie list of selected theater entry iD
            Loader {
                id: idTheaterMovieList
                width:parent.width;
                height:parent.height;
                focus:visible==true;
                visible:false;
                //XMRectangleForDebug{}//Left Menu Bound for debugging.
            }
            visible:false;

            //XMRectangleForDebug{height:parent.height-2} //Left Menu Bound for debugging.

        }//idSelectedDetailScreen_FocusScope


    }//idCenterFocusScope

    XMDataDRS
    {
        id: idDrsScreen
        x:0; y:0;
        z: parent.z+1
        width:systemInfo.lcdWidth;
        height:systemInfo.contentAreaHeight;
        focus: false
        visible: checkDRSStatus

        function show()
        {
            stopToastPopup();
            idDrsScreen.visible = true;
        }
        function hide()
        {
            idDrsScreen.visible = false;
        }
    }

    // Movie Description popup
    Loader{
        id: idDescriptionPopup
        focus:false;
        visible:false;
        anchors.fill: parent
        function hide()
        {
            idCenterFocusScope.focus = true;
            idDescriptionPopup.visible = false;
            idDescriptionPopup.source = ""
            idCenterFocusScope.focus = true;
            idCenterFocusScope.forceActiveFocus();
        }
        function show()
        {
            idCenterFocusScope.focus = false;
            idDescriptionPopup.source = "MovieTimesMovieInfomation.qml"
            idDescriptionPopup.visible = true;
            idDescriptionPopup.focus = true;
            idDescriptionPopup.forceActiveFocus();
        }

        z: parent.z+2//jwpark
    }

    //Menu
    Loader{id:idOptionMenu; z: parent.z+1}

    Component{
        id:idCompOptionMenuForMovieList
        MMenu.MovieTimesOptionMenuForMovieList {
            id:idOptionMenuForMovieList

            onMenuHided: {
                idOptionMenuForMovieList.focus = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.focus = true;
                    idMenuAndList_FocusScope.focus = true;
                    if(idAllMovieList.item.listCount > 0)
                    {
                        idMovieListFocusScope.focus = true;
                    }
                }
            }
            onOptionMenuSortByAtoZ: {
                idAllMovieList.item.currentIndexInitDelegate();
                movieTimesDataManager.sortMovieList(0);
                movieTimesDataManager.checkForFocusForElement(true);
            }
            onOptionMenuSortByNC_17: {
                idAllMovieList.item.currentIndexInitDelegate();
                movieTimesDataManager.sortMovieList(5);
                movieTimesDataManager.checkForFocusForElement(true);
            }
            onOptionMenuSortByR: {
                idAllMovieList.item.currentIndexInitDelegate();
                movieTimesDataManager.sortMovieList(4);
                movieTimesDataManager.checkForFocusForElement(true);
            }
            onOptionMenuSortByPG_13:{
                idAllMovieList.item.currentIndexInitDelegate();
                movieTimesDataManager.sortMovieList(3);
                movieTimesDataManager.checkForFocusForElement(true);
            }
            onOptionMenuSortByPG:{
                idAllMovieList.item.currentIndexInitDelegate();
                movieTimesDataManager.sortMovieList(2);
                movieTimesDataManager.checkForFocusForElement(true);
            }
            onOptionMenuSortByG:{
                idAllMovieList.item.currentIndexInitDelegate();
                movieTimesDataManager.sortMovieList(1);
                movieTimesDataManager.checkForFocusForElement(true);
            }
        }
    }

    Component{
        id:idCompOptionMenuForTheaterListShowingSelectedMovie
        MMenu.MovieTimesOptionMenuForTheaterListShowingSelectedMovie {
            id:idOptionMenuForTheaterListShowingSelectedMovie

            onMenuHided: {
                idOptionMenuForTheaterListShowingSelectedMovie.focus = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.focus = true
                    idSelectedDetailScreen_FocusScope.focus = true;
                    idSelectedDetailScreen_FocusScope.forceActiveFocus();
                }
            }
            onOptionMenuSortByDistance: {
                idMovieTheaterList.item.currentIndexInitDelegate();
                movieTimesDataManager.sortTheaterListByMovie(0);
                movieTimesDataManager.checkForFocusForElement(true);
            }
            onOptionMenuSortByStartingTime: {
                idMovieTheaterList.item.currentIndexInitDelegate();
                movieTimesDataManager.sortTheaterListByMovie(1);
                movieTimesDataManager.checkForFocusForElement(true);
            }
        }
    }

    Component{
        id:idCompOptionMenuForTheaterList
        MMenu.MovieTimesOptionMenuForTheaterList {
            id:idOptionMenuForTheaterList

            onMenuHided: {
                idOptionMenuForTheaterList.focus = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.focus = true;
                    idMenuAndList_FocusScope.focus = true;
                    if(movieTimesDataManager.getTheaterListCount() > 0)
                    {
                        idMovieListFocusScope.focus = true;
                    }
                }
            }
            onOptionMenuSortByDistance: {
                movieTimesDataManager.sortTheaterList(0);
                movieTimesDataManager.checkForFocusForElement(true);
            }
            onOptionMenuSortByAtoZ: {
                movieTimesDataManager.sortTheaterList(1);
                movieTimesDataManager.checkForFocusForElement(true);
            }
            onOptionMenuAddFavorite: {
                idAddFavorite.show();
            }
        }
    }

    Component{
        id:idCompOptionMenuForFavoriteList
        MMenu.MovieTimesOptionMenuForFavoriteList {
            id:idOptionMenuForFavoriteList

            onMenuHided: {
                idOptionMenuForFavoriteList.focus = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.focus = true;
                    if(idDeleteFavorite.visible)
                    {
                        idDeleteFavorite.focus = true;
                        idDeleteFavorite.item.moveFocusToList();
                    }
                    else
                    {
                        idMenuAndList_FocusScope.focus = true;
                        idMovieListFocusScope.focus = true;
                    }
                }
            }
            onOptionMenuSearch: {
                idAddFavorite.show();
            }
            onOptionMenuDelete: {
                idDeleteFavorite.show();
            }
            onOptionMenuCancelDelete: {
                onBack();
            }
        }
    }

    MPopup.Case_D_DeleteAllQuestion{
        id:idPopupCaseD
        visible : false;
        text: stringInfo.sSTR_XMDATA_DELETE_ALL_MESSAGE
        property string targetId;
        property QtObject target;
        onClose: {
            movieTimesDataManager.rollbackDeleteItems();
            hide();
        }
        onButton1Clicked: {
            //Delete All?
            movieTimesDataManager.deleteAllFavoriteList();
            reallyDeletedSuccessfully();
            idPopupCaseD.visible = false;
            idPopupCaseD.focus = false;
            onBack();
        }
        function show(){

            idCenterFocusScope.focus = false;
            idPopupCaseD.visible = true;
            idPopupCaseD.focus = true;
            idPopupCaseD.forceActiveFocus();
        }
        function hide(){
            idPopupCaseD.visible = false;
            idPopupCaseD.focus = false;
            idCenterFocusScope.focus = true;
            idCenterFocusScope.forceActiveFocus();
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
        id:idGotoTheaterQuestion
        x: 0
        y: 0
        z: parent.z + 2
        visible : false;
//        lineCount: 3
        text: name + "\n" + address + "\n" + stringInfo.sSTR_XMDATA_POPUP_QEUSTION

        property int index: 0
        property int entryID: 0;
        property string name: ""
        property string address: ""
        property string phonenumber: ""
        property double latitude: 0.0
        property double longitude: 0.0
        property string statename: ""
        property string city: ""
        property string street: ""
        property string zipcode: ""
        property int amenityseating: 0
        property int amenityrocker: 0

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
                sendTheaterDataToNavigation(index, entryID, name, address, phonenumber, latitude, longitude, statename, city, street, zipcode, amenityseating, amenityrocker);
            }
        }
        function show(index, entryID, name, address, phonenumber, latitude, longitude, statename, city, street, zipcode, amenityseating, amenityrocker){

            idGotoTheaterQuestion.index = index;
            idGotoTheaterQuestion.entryID = entryID;
            idGotoTheaterQuestion.name = name;
            idGotoTheaterQuestion.address = address;
            idGotoTheaterQuestion.phonenumber = phonenumber;
            idGotoTheaterQuestion.latitude = latitude;
            idGotoTheaterQuestion.longitude = longitude;
            idGotoTheaterQuestion.statename = statename;
            idGotoTheaterQuestion.city = city;
            idGotoTheaterQuestion.street = street;
            idGotoTheaterQuestion.zipcode = zipcode;
            idGotoTheaterQuestion.amenityseating = amenityseating;
            idGotoTheaterQuestion.amenityrocker = amenityrocker;

            idGotoTheaterQuestion.visible = true;
            idGotoTheaterQuestion.focus = true;
        }
        function hide(){
            idGotoTheaterQuestion.visible = false;
            idGotoTheaterQuestion.focus = false;
            idCenterFocusScope.focus = true;
            idCenterFocusScope.forceActiveFocus();
        }
    }

    MPopup.Case_DRS_Warning {
        id: idCallPopup
        z: parent.z + 2
        visible: false
        focus:false;
        popupLineCnt: 1
        btDuringCall: true;
        detailText1: stringInfo.sSTR_XMDATA_BT_DURING_CALL_NOCALL;
        detailText2: ""//"Only available when parked.";

        onClose: {
            hide();
        }
        function show(){
            //[ITS 191191]
            idAppMain.upKeyLongPressed = false;
            idAppMain.downKeyLongPressed = false;

            //[ITS 0233686] Check System Popup Flag
            if(UIListener.HandleGetSystemPopupFlag() == true)
                UIListener.HandleSetSystemPopupClose();

//            //[ITS 227121]
//            if(idOptionMenu.visible)
//                idOptionMenu.item.allHideMenu();

            idCenterFocusScope.focus = false;
            idCallPopup.visible = true;
            idCallPopup.focus = true;
            idCallPopup.forceActiveFocus();
        }
        function hide(){
            idCallPopup.visible = false;
            idCallPopup.focus = false;
            idCenterFocusScope.focus = true;
            idCenterFocusScope.forceActiveFocus();
        }
    }

    function selectMovie()
    {
        szMovieMode = "movieMovie";
        idAllMovieList.show();
        idMenuAndList_FocusScope.focus = true;
        idMovieListFocusScope.focus = true;
        if(checkDRSStatus)
        {
            idDrsScreen.show();
        }
        else
        {
            movieTimesDataManager.checkForFocusForElement(true);
        }
    }

    function selectTheater()
    {
        szMovieMode = "movieTheater";

        movieTimesDataManager.setSortColumn();
        idAllTheaterList.show();
        idMenuAndList_FocusScope.focus = true;
        idMovieListFocusScope.focus = true;
        movieTimesDataManager.checkForFocusForElement(true);
    }

    function selectFavorite()
    {
        szMovieMode = "movieFavorite";
        idFavoriteList.show();
    }

    //selected from All Movie List, it shows theater list that shows selected movie.
    function selectMovieTheater(movieID, movieName)
    {
        nMovieID = movieID;
        szMovieName = movieName;

        idMenuBar.menuBtnFlag = false;
        idMenuBar.enableMenuBtn = true;
        szMovieMode = "movieMovieTheater";

        // load theater list

        if(idMovieTheaterList.status == Loader.Null )
            idMovieTheaterList.source = "./MovieTimesTheaterList.qml";

        idMenuAndList_FocusScope.focus = false;
        idMovieListFocusScope.focus = true;

        idSelectedDetailScreen_FocusScope.visible = true;
        idSelectedDetailScreen_FocusScope.focus = true;
        idMovieTheaterList.focus = true;
        idMovieTheaterList.visible = true;
        idMovieTheaterList.item.visible = true;
        idMovieTheaterList.item.focus = true;
        idMovieTheaterList.item.forceActiveFocus();
        idMenuBar.textTitle = movieName;
        movieTimesDataManager.updateTheaterListByMovie(movieID);
        movieTimesDataManager.checkForFocusForElement(true);
        idMovieTheaterList.item.doCheckEnableMenuBtn();
    }

    function selectTheaterMovie(index, entryID, theaterName, theaterAddr, theaterPhoneNum, latitude, longitude, stateName, city, street, zipcode, amenityseating, amenityrocker, locID)
    {
        if(idTheaterMovieList.status == Loader.Null )
            idTheaterMovieList.source = "./MovieTimesMovieList.qml";
        idTheaterMovieList.item.entryID         = entryID;
        idTheaterMovieList.item.szTheaterName   = theaterName;
        idTheaterMovieList.item.szAddress       = theaterAddr;
        idTheaterMovieList.item.szPhoneNumber   = theaterPhoneNum;
        idTheaterMovieList.item.fLatitude       = latitude;
        idTheaterMovieList.item.fLongitude      = longitude;
        idTheaterMovieList.item.szState         = stateName;
        idTheaterMovieList.item.szCity          = city;
        idTheaterMovieList.item.szStreet        = street;
        idTheaterMovieList.item.szZipcode       = zipcode;
        idTheaterMovieList.item.iAmenityseating = amenityseating;
        idTheaterMovieList.item.iAmenityrocker  = amenityrocker;

        nIndex = index;
        nLocalID = locID;

        idMovieListFocusScope.focus = true;

        idSelectedDetailScreen_FocusScope.visible = true;
        idSelectedDetailScreen_FocusScope.focus = true;

        idTheaterMovieList.focus = true;
        idTheaterMovieList.visible = true;
        idTheaterMovieList.item.visible = true;
        idTheaterMovieList.item.focus = true;
        idTheaterMovieList.item.forceActiveFocus();
        idMenuBar.textTitle = theaterName;
        // load movie list
        movieTimesDataManager.updateMovieListForAllTheaterFilter(locID);
    }

    function initLeftMenuFocus()
    {
        idMovieMain.initFirstFocus();
    }

    function popupMovieInfo(movieName, grade, runningTime, actors, synopsis, rating)
    {
        if(idMovieListFocusScope.focus == false)
        {
            idMovieListFocusScope.focus = true;
        }
        idDescriptionPopup.show();
        idDescriptionPopup.item.textTitle = movieName;
        idDescriptionPopup.item.pgText = grade
        idDescriptionPopup.item.hourText = runningTime
        idDescriptionPopup.item.actorText = actors//for Actors Name
        idDescriptionPopup.item.descriptionText = synopsis
    }

    function onOptionOnOff()
    {
        if(checkDRSStatus == true) {return;}
        if(idCallPopup.visible == true) {return;}
        if(idMenuBar.menuBtnFlag == false)
            return;

        if(idDescriptionPopup.visible) return;
        if(idTheaterMovieList.visible) return;
        if(idAddFavorite.visible) return;
        if(idListIsSDMountPopUp.visible) return;
        if(idGotoTheaterQuestion.visible) return;
        if(/*idPopupCaseC.visible || */idPopupCaseD.visible) return;
        if(idMenuBar.enableMenuBtn == false) return;

        if(szMovieMode == "movieMovie"){
            idOptionMenu.sourceComponent = idCompOptionMenuForMovieList;
            idOptionMenu.item.showMenu();
            idCenterFocusScope.focus = false;
            idOptionMenu.focus = true;
        }else if(szMovieMode == "movieTheater"){
            idOptionMenu.sourceComponent = idCompOptionMenuForTheaterList;
            idOptionMenu.item.showMenu();
            idCenterFocusScope.focus = false;
            idOptionMenu.focus = true;
        }else if(szMovieMode == "movieFavorite") {
            idOptionMenu.sourceComponent = idCompOptionMenuForFavoriteList;
            if(idDeleteFavorite.visible)
                idOptionMenu.item.menuForDelete = true;
            else
                idOptionMenu.item.menuForDelete = false;
            idOptionMenu.item.showMenu();
            idCenterFocusScope.focus = false;
            idOptionMenu.focus = true;

            if(movieTimesDataManager.getTheaterListCount() == 0 && idFavoriteList.visible)
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
                idOptionMenu.item.optionMenu.menu2Enabled = false;
            }
            else
            {
                idOptionMenu.item.optionMenu.menu1Enabled = true;
                idOptionMenu.item.optionMenu.menu2Enabled = true;
            }
        }else if(szMovieMode == "movieMovieTheater") {
            idOptionMenu.sourceComponent = idCompOptionMenuForTheaterListShowingSelectedMovie;
            idOptionMenu.item.showMenu();
            idCenterFocusScope.focus = false;
            idOptionMenu.focus = true;
        }
    }

    function onBack()
    {
        if(idDescriptionPopup.visible){
            idDescriptionPopup.hide();
            return false;
        }
        if(idAddFavorite.visible){
            stopToastPopup();
            idAddFavorite.hide();
            return false;
        }
        if(idDeleteFavorite.visible){
            idDeleteFavorite.hide();
            idMenuAndList_FocusScope.focus = true;
            return false;
        }

        if(idTheaterMovieList.visible)
        {
            idMenuBar.enableMenuBtn = true;
            idMenuAndList_FocusScope.focus = true;
            idCenterFocusScope.visible = true;
            idTheaterMovieList.item.visible = false;
            idTheaterMovieList.source = '';
            idTheaterMovieList.visible = false;
            idSelectedDetailScreen_FocusScope.focus = false;
            idSelectedDetailScreen_FocusScope.visible = false;
            if(checkDRSStatus == false)
            {
                idCenterFocusScope.focus = true;
                idMenuAndList_FocusScope.forceActiveFocus();
            }
            idMenuBar.textTitle = stringInfo.sSTR_XMDATA_MOVIETIMES;
            if(idAllTheaterList.item != null)
                idAllTheaterList.item.doCheckEnableMenuBtn();
            return false;
        }

        if((szMovieMode == "movieMovie") || (szMovieMode == "movieTheater") || (szMovieMode == "movieFavorite"))
        {
            return true;
        }
        else if(szMovieMode == "movieMovieTheater")
        {
            idMenuBar.enableMenuBtn = true;
            idMenuAndList_FocusScope.focus = true;
            idCenterFocusScope.visible = true;
            idMovieTheaterList.item.visible = false;
            idMovieTheaterList.source = '';
            idMovieTheaterList.focus = false;
            idMovieTheaterList.visible = false;
            idSelectedDetailScreen_FocusScope.focus = false;
            idSelectedDetailScreen_FocusScope.visible = false;
            if(checkDRSStatus == false)
            {
                idCenterFocusScope.focus = true;
                idMenuAndList_FocusScope.forceActiveFocus();
            }
            szMovieMode = "movieMovie";
            idMenuBar.textTitle = stringInfo.sSTR_XMDATA_MOVIETIMES;
            idAllMovieList.item.doCheckEnableMenuBtn();
            return false;
        }

        return true;
    }

    function sendTheaterDataToNavigation(index, entryID, name, address, phonenumber, latitude, longitude, statename, city, street, zipcode, amenityseating, amenityrocker) {
        console.log(" GO: "+index+ ", entryID:" + entryID + ", name:" + name + ", addr:" + address + ", phoneNumber:"+phonenumber+", latitude:"+latitude+", longitude:"+longitude);

        movieTimesDataManager.reqSendTheaterDataToNavigation(name, statename, street, city, zipcode, phonenumber, latitude, longitude, amenityseating, amenityrocker)
        if( ! UIListener.HandleGoToNavigationForMovieTime() ){
            showNotConnectedWithNavigation("NotifyUISH event sending failed");
        }

    }

    function leftFocusAndLock(isLock)
    {
        if(isLock == true)
        {
            if(idMovieMain.visible)
                idMovieMain.forceActiveFocus();
            idMovieMain.KeyNavigation.right = null;
        }else{
            idMovieMain.KeyNavigation.right = idMovieListFocusScope;
        }
    }

    function getCurrentOptionSortMode()
    {
        switch(szMovieMode)
        {
            case "movieMovie":
            {
                switch(movieTimesDataManager.getNowGrade())
                {
                    case 0://ISV 84749 - initialize sort role
                        return stringInfo.sSTR_XMDATA_ATOZ;
                    case 1:
                        return stringInfo.sSTR_XMDATA_G;
                    case 2:
                        return stringInfo.sSTR_XMDATA_PG;
                    case 3:
                        return stringInfo.sSTR_XMDATA_PG_13;
                    case 4:
                        return stringInfo.sSTR_XMDATA_R;
                    case 5:
                        return stringInfo.sSTR_XMDATA_NC_17
                }
                break;
            }
            case "movieTheater":
            {
                switch(theaterList.sortRole)
                {
                    case (32 + 7):
                        return stringInfo.sSTR_XMDATA_DISTANCE;
                    case (32 + 3):
                        return stringInfo.sSTR_XMDATA_ATOZ;
                    case (32 + 5):
                        return stringInfo.sSTR_XMDATA_STARTINGTIME;
                }
                break;
            }
            case "movieFavorite":
            {
                switch(favoriteList.sortRole)
                {
                    case (32 + 7):
                        return stringInfo.sSTR_XMDATA_DISTANCE;
                    case (32 + 3):
                        return stringInfo.sSTR_XMDATA_ATOZ;
                    case (32 + 5):
                        return stringInfo.sSTR_XMDATA_STARTINGTIME;
                }
                break;
            }
            case "movieMovieTheater":
            {
                switch(theaterListByMovie.sortRole)
                {
                case (32 + 7):
                    return stringInfo.sSTR_XMDATA_DISTANCE;
                case (32 + 3):
                    return stringInfo.sSTR_XMDATA_ATOZ;
                case (32 + 5):
                    return stringInfo.sSTR_XMDATA_STARTINGTIME;
                }
                break;
            }
        }
    }

    function checkFocusOfMovementEnd()
    {
        checkFocusOfScreen();
    }

    function checkFocusOfScreen()
    {
        if(checkDRSStatus == false)
        {
            if(idCenterFocusScope.visible == true && (idMovieMain.activeFocus == true || idMenuBar.contentItem.KeyNavigation.up.activeFocus == true)){
                idCenterFocusScope.focus = true;
                if(idMenuAndList_FocusScope.visible == true){
                    idMenuAndList_FocusScope.focus = true;
                    idMovieListFocusScope.focus = true;
                }else if(idAddFavorite.visible == true){
                    idAddFavorite.focus = true;
                }
            }
        }
    }

    function checkSDPopup(index, entryID, name, address, phonenumber, latitude, longitude, statename, city, street, zipcode, amenityseating, amenityrocker)
    {
        if(interfaceManager.isMountedMMC == false)
        {
            idListIsSDMountPopUp.show();
        }
        else
        {
            idGotoTheaterQuestion.show(index, entryID, name, address, phonenumber, latitude, longitude, statename, city, street, zipcode, amenityseating, amenityrocker);
        }
    }
    onClockTimeChanged:{
        if(idMovieTheaterList.visible)
        {
            selectMovieTheater(nMovieID, szMovieName);
        }
    }
}
