import Qt 4.7

// System Import
import "../QML/DH" as MComp
import "./List" as XMList
import "./ListDelegate" as XMDelegate

FocusScope {
    width: parent.width;
    height: parent.height;
    property alias listModel: idFuelPricesList.listModel
    property alias listCount: idFuelPricesList.count
    property bool bSeachButtonEnable: true

    Component{
        id: idFuelPricesListDelegate
        XMDelegate.XMFuelPricesListLargeDelegate {
            bfavorites: true;
            onGoButtonClicked: {
                if(idMainListFocusScope.focus == false)
                {
                    idMainListFocusScope.focus = true;
                }
                checkSDPopup(locationID, name, addr);
            }
        }
    }
    XMList.XMDataNormalList{
        id: idFuelPricesList
        x:0;y:0;
        focus: true
        width: parent.width;
        height: parent.height;
        listDelegate: idFuelPricesListDelegate
        rowPerPage: 4
        onListModelChanged: {
            if(visible)
            {
                currentIndex = 0
                idFuelPricesList.focus = true;
            }
        }
        onCountChanged: {
            if(visible)
            {
                console.log("=======[FuelPricesMyFavorites.qml][onCountChanged][leftFocusAndLock]=====count = "+count);

                bSeachButtonEnable = true;
                leftFocusAndLock(false);
                doCheckEnableMenuBtn();
                idFuelPricesList.focus = true;
            }
        }

        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITES_STORES;
        showSearchButtonWhenListEmpty: true;
        searchButtonEnable: bSeachButtonEnable

        onVisibleChanged: {
            if(visible)
            {
                bSeachButtonEnable = fuelPriceDataManager.getRowCountFuelAllSortModel() == 0 ? false : true;
                doCheckEnableMenuBtn();
            }
        }

        Connections{
            target : fuelPriceDataManager
            onCheckForFocus:{
                if(visible)
                {                    
                    idFuelPricesList.listView.positionViewAtIndex(0, ListView.Visible);
                    idFuelPricesList.listView.currentIndex = 0;
                    idLeftMenuFocusScope.KeyNavigation.right = idMainListFocusScope;
                    idFuelPricesList.focus = true;
                }
            }
            onMenuFuelPriceForFav:{
                if(visible)
                {
                    bSeachButtonEnable = true;
                    leftFocusAndLock(false);
                    doCheckEnableMenuBtn();
                    idFuelPricesList.focus = true;
                }
            }
        }
        onSearchButton: {
            fuelPriceDataManager.updateViewByFuelType(4);
            idFuelSearch.show();
        }
    }

    function currentIndexInitDelegate(){
        idFuelPricesList.listView.currentIndex = -1;
    }

    function doCheckEnableMenuBtn(){
        console.log("[QML] FulePriceFavorites.qml :: doCheckEnableMenuBtn :: lvisible = " + visible + ", onRoute = " + onRoute + ",  Fuel list count = " + fuelPriceDataManager.getRowCountFuelAll())
        if(visible)
        {
            idMenuBar.enableMenuBtn = fuelPriceDataManager.getRowCountFuelAllSortModel() == 0 ? false : true;
        }
    }

    function getListCount()
    {
        return true;
    }
}
