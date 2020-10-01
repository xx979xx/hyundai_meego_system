import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./Menu" as MMenu
import "./ListElement" as MListElement
import "../../component/XMData/Common" as XMCommon
import "./Popup" as MPopup

// Because Loader is a focus scope, converted from FocusScope to Item.
FocusScope{
    id:container
    objectName: "stockMenu"
    focus:  true
    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight;

    // property alias serviceProviderText: idServiceProviderText.text
    // favorite, search, changerow, delete
    property string szMode : "favorite"
    property bool checkDRSStatus: idAppMain.isDRSChange

    onVisibleChanged: {
        UIListener.consolMSG("StockMenu visible = " + visible + ", DRS : " + checkDRSStatus);
        if(visible == false)
        {
            idDrsScreen.hide();
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

    onCheckDRSStatusChanged: {
        if(visible)
        {
            if(checkDRSStatus == true && idDrsScreen.visible == false)
            {
                UIListener.consolMSG("StockMenu onCheckDRSStatusChanged idDrsScreen.show");
                if(idSearchFocusScope.visible)
                {
                    idSearchFocusScope.item.hideListIsFull();
                }
                if(idDeleteAllQuestion.visible)
                {
                    idDeleteAllQuestion.hide();
                }
                else
                {
                    idMainListFocusScope.focus = true;
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
        textTitle : stringInfo.sSTR_XMDATA_STOCKS
        intelliKey: stockDataManager.dIntelliKey
        contentItem: idCenterFocusScope
        checkDRSVisible: (checkDRSStatus && visible)
        function resetTitle()
        {
            textTitle = stringInfo.sSTR_XMDATA_STOCKS
        }
    }

    // Center Area Under Menu Bar
    FocusScope{
        id: idCenterFocusScope
        focus:true
        visible: true
        x:0; y:systemInfo.titleAreaHeight;
        width:systemInfo.lcdWidth;
        height:parent.height-y;

        //Left Menu And Right List
        FocusScope{
            id:idMainMenuAndListFocusScope
            focus: (idMainMenuAndListFocusScope.visible==true)
            visible : szMode == "favorite"
            //Left menu(All, Brand, Fuel Type, Favorite
            XMDataLeftMenuGroup{
                id:idLeftMenuFocusScope
                KeyNavigation.right: idMainListFocusScope
                countOfButton: 2; //(Favorite, Search)

                button1Text: stringInfo.sSTR_XMDATA_FAVORITE;
                button1Active: szMode == "favorite"
                onButton1Clicked: {
                    selectFavorite();
                    KeyNavigation.right.forceActiveFocus();
                }
                button2Text: stringInfo.sSTR_XMDATA_SEARCH
//                button2TextSize: 36
                autoTextSize: true
                button2Active: (szMode == "search")
                isNotStockBtn: false
                onButton2Clicked: {
                    idMainListFocusScope.focus = true;
                    selectAll();
                }
            }

            //Right List
            FocusScope{
                id:idMainListFocusScope
                KeyNavigation.left:idLeftMenuFocusScope
                x: idLeftMenuFocusScope.x+idLeftMenuFocusScope.width;
                y: idLeftMenuFocusScope.y;
                height:idLeftMenuFocusScope.height
                width:systemInfo.lcdWidth - idLeftMenuFocusScope.width
                focus:true;

                // Main list view
                StockMyFavoritesList {
                    id : idStoreList
                    focus : true
                    width: parent.width;
                    height : parent.height
                }
            }//idMainListFocusScope
        }//idMainMenuAndListFocusScope

        // Search
        Loader{
            id: idSearchFocusScope
            width: parent.width
            height: parent.height
            focus: false
            visible: false

            function hide()
            {
                idMenuBar.visibleSearchTextInput = false;
                idMenuBar.resetTitle();
                idMenuBar.menuBtnFlag = true;
                idSearchFocusScope.visible = false;
                idSearchFocusScope.source = ""
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.focus = true;
                    idCenterFocusScope.forceActiveFocus();
                }
            }

            function show()
            {
                idMenuBar.textTitle = stringInfo.sSTR_XMDATA_SEARCH;
                idMenuBar.menuBtnFlag = false;
                idSearchFocusScope.source = "StockAllStockSearch.qml"
                idSearchFocusScope.visible = true;
                idSearchFocusScope.focus = true;
                idMenuBar.visibleSearchTextInput = true;
            }
        }

        Loader{
            id: idChangeRowFocusScope
            width: parent.width
            height: parent.height
            focus: false
            visible: false

            function hide()
            {
                if(idChangeRowFocusScope.item != null)
                {
                    if(idChangeRowFocusScope.item.isHide())
                    {
                        idMenuBar.resetTitle();
                        idMenuBar.menuBtnFlag = true;
                        idChangeRowFocusScope.visible = false;
                        idChangeRowFocusScope.source = ""
                        if(checkDRSStatus == false)
                        {
                            idCenterFocusScope.focus = true;
                            idMainMenuAndListFocusScope.forceActiveFocus();
                        }
                        return true;
                    }else
                    {
                        return false;
                    }
                }
            }
            function show()
            {
                stockDataManager.initReorderDataModelAndView();
                idMenuBar.textTitle = stringInfo.sSTR_XMDATA_CHANGE_ROW;
                idMenuBar.menuBtnFlag = false;
                idChangeRowFocusScope.source = "StockMyFavoritesChange.qml"
                idChangeRowFocusScope.visible = true;
                idChangeRowFocusScope.focus = true;
                idChangeRowFocusScope.forceActiveFocus();
            }
        }

        Loader{
            id: idDeleteFocusScope
            width: parent.width
            height: parent.height
            focus: false
            visible: false

            function hide()
            {
                idMenuBar.resetTitle();
                idMenuBar.deleteAllNoFlag = false;
                idDeleteFocusScope.visible = false;
                idDeleteFocusScope.source = ""
                idMainMenuAndListFocusScope.focus = true;
                if(isToastPopupVisible() == false && checkDRSStatus == false)
                {
                    idCenterFocusScope.focus = true;
                }
                stockDataManager.removeDeleteFavorites();
            }
            function show()
            {
                idDeleteFocusScope.source = "StockMyFavoritesDeleteStock.qml"
                idDeleteFocusScope.visible = true;
                idMenuBar.deleteAllNoFlag = true;
                idDeleteFocusScope.focus = true;
                idDeleteFocusScope.forceActiveFocus();
            }
            Connections{
                target: idDeleteFocusScope.item
                onClose:{
                    onBack();
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
        visible: checkDRSStatus

        function show()
        {
            stopToastPopup();
            idDrsScreen.visible = true;
            UIListener.consolMSG("StockMenu idDrsScreen show");
        }
        function hide()
        {
            idDrsScreen.visible = false;
        }
    }

    //Option Menu
    Loader{id:idOptionMenu; z: parent.z+1}

    Component{
        id: idCompOptionMenu
        MMenu.StockOptionMenuForAll{
            y:0
            onMenuHided: {
                focus = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.focus = true;
                    if(idDeleteFocusScope.visible)
                    {
                        idDeleteFocusScope.focus = true;
                        idDeleteFocusScope.item.moveFocusToList();
                    }
                    else
                    {
                        idMainMenuAndListFocusScope.focus = true;
                        idMainListFocusScope.focus = true;
                    }
                }
            }

            onOptionMenuAddFavorite: {
                selectAll();
            }
            onOptionMenuReorder: {
                onChangeRow();
            }
            onOptionMenuDelete: {
                onDelete();
            }
            onOptionMenuCalcelDelete: {
                onBack();
            }
        }
    }

    function doCheckFavoriteData(){
        if(stockMyFavoriteDataModel[0] == null)
        {
            selectAll();
        }else
        {
            selectFavorite();
        }

        if(checkDRSStatus)
        {
            UIListener.consolMSG("StockMenu onCheckDRSStatusChanged idDrsScreen.show 22222");
            idDrsScreen.show();
        }
    }

    function selectAll()
    {
        szMode = "search";
        idSearchFocusScope.show();
    }

    function selectFavorite()
    {
        szMode = "favorite";
        idMenuBar.menuBtnFlag = true;
        idMenuBar.enableMenuBtn = true;
        idStoreList.listView.positionViewAtIndex(0, ListView.view)
        idStoreList.listView.currentIndex = 0;
        if(checkDRSStatus == false)
        {
            idCenterFocusScope.forceActiveFocus();
        }
        idMainListFocusScope.focus = true;
    }

    function onChangeRow()
    {
        szMode = "changerow";
        idChangeRowFocusScope.show();
    }

    function onDelete()
    {
        szMode = "delete";
        idDeleteFocusScope.show();
    }

    function onBack()
    {
        if(szMode == "changerow")
        {
            if(!idChangeRowFocusScope.hide())
            {
                return false;
            }else
            {
                stockDataManager.modifyChangedFavorites();
                szMode = "favorite"
                idMainMenuAndListFocusScope.focus = true;
                return false;
            }
        }
        else if(szMode == "search")
        {
            stopToastPopup();
            szMode = "favorite"
            idSearchFocusScope.hide();
            idMainMenuAndListFocusScope.focus = true;
            idMainListFocusScope.focus = true;
            return false;
        }else if(szMode == "delete")
        {
            idDeleteFocusScope.hide();
            szMode = "favorite"
            return false;
        }

        else
        {
            return true;
        }
    }

    function onOptionOnOff()
    {
        if(checkDRSStatus == true) {return;}
        if(idDeleteAllQuestion.visible == true)
        {
            return;
        }

        if(!(szMode == "favorite" || szMode == "delete"))
        {
            return;
        }

        idOptionMenu.visible = true;
        idOptionMenu.sourceComponent = idCompOptionMenu;
        idOptionMenu.item.showMenu();
        idCenterFocusScope.focus = false;
        idOptionMenu.focus = true;
    }

    // Function for Change Text Color
    function changeTextColor(text) {
        if( text.charAt(0) == '+')
            return "#2F7DFF";
        else if( text.charAt(0) == '-')
            return "#EA3939";
        else
            return colorInfo.brightGrey;
    }

    function checkFocusOfMovementEnd()
    {
        checkFocusOfScreen();
    }

    function checkFocusOfScreen()
    {
        if(checkDRSStatus == false)
        {
            if(idLeftMenuFocusScope.visible == true && (idLeftMenuFocusScope.activeFocus == true || idMenuBar.contentItem.KeyNavigation.up.activeFocus == true)){
                idCenterFocusScope.focus = true;
                if(idMainMenuAndListFocusScope.visible == true){
                    idMainMenuAndListFocusScope.focus = true;
                    idMainListFocusScope.focus = true;
                }else if(idSearchFocusScope.visible == true){
                    idSearchFocusScope.focus = true;
                }
            }
        }
    }

    function initLeftMenuFocus()
    {
        idLeftMenuFocusScope.initFirstFocus();
    }

    MPopup.Case_D_DeleteAllQuestion{
        id:idDeleteAllQuestion
        visible : false;
        text: stringInfo.sSTR_XMDATA_DELETE_ALL_MESSAGE
        property string targetId;
        property QtObject target;
        onClose: {
            stockDataManager.rollbackAllDeleteFavorites();
            hide();
        }
        onButton1Clicked: {
            //Delete All?
            stockDataManager.executeDeleteFavorites();
            reallyDeletedSuccessfully();
            idDeleteAllQuestion.visible = false;
            idDeleteAllQuestion.focus = false;
            onBack();
        }
        function show(){
            idCenterFocusScope.focus = false;
            idDeleteAllQuestion.visible = true;
            idDeleteAllQuestion.focus = true;
            idDeleteAllQuestion.forceActiveFocus();
        }
        function hide(){
            idDeleteAllQuestion.visible = false;
            idDeleteAllQuestion.focus = false;
            idCenterFocusScope.focus = true;
            idCenterFocusScope.forceActiveFocus();
        }
    }

    Connections {
        target: UIListener
        onHideWhenBG:{
            console.log(" ==> StockMyFavoritesChange onHideWhenBG: szMode = " + szMode);
            if(szMode == "changerow")
                stockDataManager.modifyChangedFavorites();
        }
    }

    Connections {
        target : idAppMain
        onToastPopupClose:{
            if(visible)
            {
                UIListener.consolMSG("StockMenu onToastPopupClose");
                idCenterFocusScope.focus = true;
                idMainMenuAndListFocusScope.focus = true;
                idMainMenuAndListFocusScope.forceActiveFocus();
            }
        }
    }
}
