import Qt 4.7

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../QML/DH" as MComp
import "./Popup" as MPopup

// Because Loader is a focus scope, converted from FocusScope to Item.
//Item {
FocusScope {
    id:container

    property alias listModel: idFuelPricesList.listModel
    property alias listCount: idFuelPricesList.count
    property string selectedBrand : "";
    property string selectedBrandName : "";
    property string selectedType : "";
    property bool subDistanceUnitChange: mainDistanceUnitChange;

    function getHeight()
    {
        if((selectedBrand != "") || fuelPriceDataManager.isOnRoute)
        {
            return container.height - 90;
        }else if(selectedType!="")
        {
            return container.height - 88 - 6
        }

        return 138*4;
    }
    function getYPosition()
    {
        if((selectedBrand != "") || (selectedType!="") || fuelPriceDataManager.isOnRoute)
        {
            return 90
        }
        return 0;
    }

    //Brand
    Item{
        id:idBrandArea
        visible:selectedBrand != "" && (fuelPriceDataManager.isOnRoute != true)
        Image {
            id:idBrandIconBg
            x: idBrandIcon.x-1; y: idBrandIcon.y-1
            //width : 78; height:  78
            source: imageInfo.imgFolderXMData + "bg_fuel.png"
            //XMRectangleForDebug{border.color: "red"}
        }
        Image {
            id:idBrandIcon
            x: 13; y: 24
            width:70;height:40

            source: fuelBrandIconForAll(selectedBrand)

            //for fuel brand Img
            function fuelBrandIconForAll(brand)
            {
//                console.log("brand: " + brand);
                switch(brand){
                case "BP":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_01.png"; //BP
                case "VALERO":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_02.png"; //Valero
                case "USA GASOLINE":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_03.png"; //USA gasoline
                case "TOWER MARKET":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_04.png"; //Tower Market
                case "TESORO":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_05.png"; //Tesoro
                case "SHELL":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_06.png"; //Shell
                case "SAMS CLUB":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_07.png"; //Sam's club
                case "QUIKSTOP":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_08.png"; //Quikstop
                case "MOBIL":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_09.png"; //Mobil
                case "UNBRANDED":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_10.png"; //UNBRANDED(Default icon)
                case "GOLDEN GATE PETROLEUM":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_11.png"; //Golden gate petroleum
                case "CIRCLE K":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_13.png"; //Circle K
                case "CHEVRON":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_14.png"; //Chevron
                case "ARCO":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_15.png"; //Arco
                case "76GAS":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_16.png"; //76 gas
                case "7-ELEVEN":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_17.png"; //Seven Eleven
                case "COSTCO":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_18.png"; //Costco
                case "SPEEDWAY":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_19.png"; //Speedway
                case "MARATHON":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_20.png"; //Marathon oil
                case "KROGER":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_21.png"; //Kroger
                case "EXXON":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_22.png"; //Exxon
                case "CLARK":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_23.png"; //Clark
                case "CITGO":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_24.png"; //Citgo
                case "SUNOCO":
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_25.png"; //Sunoco
                default:
                    return imageInfo.imgFolderXMDataFuel + "ico_fuel_10.png"; //UNBRANDED(Default icon)
                }
            }
        }

        // Brand
        MComp.DDScrollTicker{
            id: idText
            x: 13+96; y: 0
            width: 990
            height: 90
            text: selectedBrand
            fontFamily : systemInfo.font_NewHDR
            fontSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerEnable: true
            tickerFocus: (idFuelPricesList.activeFocus && idAppMain.focusOn)
        }

        Image {
            x: 0; y: 88
            source: imageInfo.imgFolderMusic + "tab_list_line.png"
        }
    }
    //Type
    Item{
        id:idTypeArea
        visible:selectedType != "" && (fuelPriceDataManager.isOnRoute != true)
        Text {
            id: idTypeText
            x: 19; y: 0//44 - font.pixelSize/2;
            width: 130
            height: 90
            text: (selectedType === "0")? stringInfo.sSTR_XMDATA_REGULAR : (selectedType === "1")? stringInfo.sSTR_XMDATA_MIDGRADE : (selectedType === "2")? stringInfo.sSTR_XMDATA_PREMIUM : stringInfo.sSTR_XMDATA_DIESEL
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            //XMRectangleForDebug{}
        }
        Image {
            x: 0; y: 88
            source: imageInfo.imgFolderMusic + "tab_list_line.png"
        }
    }

    //OnRoute
    Item{
        id:idOnRouteDestination
        visible: fuelPriceDataManager.isOnRoute
        Text {
            x: 19; y: 0//44 - font.pixelSize/2;
            width: 270
            height: 90
            text: stringInfo.sSTR_XMDATA_DESTINATION + " : "
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        MComp.DDScrollTicker { //  Text
            x: 289; y: 0//44 - font.pixelSize/2;
            width: 680
            height: 90
            text: fuelPriceDataManager.onRouteDest
            fontFamily: systemInfo.font_NewHDR
            fontSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerEnable: true
            tickerFocus: (true && idAppMain.focusOn)
        }
        Image {
            x: 0; y: 88
            source: imageInfo.imgFolderMusic + "tab_list_line.png"
        }
    }

    Component{
        id: idFuelPricesListDelegate
        XMDelegate.XMFuelPricesListDelegate
        {
            x: 0; y: 0
            width: ListView.view.width - 34
            onGoButtonClicked: {
                checkSDPopup(locationID, name, addr);
            }
        }
    }

    Component{
        id: idFuelPricesListLargeDelegate
        XMDelegate.XMFuelPricesListLargeDelegate
        {
            distanceUnitChange: subDistanceUnitChange;
            bfavorites: false;

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
        x:0;y:getYPosition();
        focus: true
        width: parent.width;
        height: getHeight();
        listDelegate: selectedType == "" ? idFuelPricesListLargeDelegate : idFuelPricesListDelegate
        rowPerPage: selectedType == "" ? (fuelPriceDataManager.isOnRoute || selectedBrand != "" ? 3 : 4) : 6
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
                //console.log("=======[FuelPricesAllStores.qml][onCountChanged][leftFocusAndLock]=====count = "+count);                
                if(count == 0)
                {
                    leftFocusAndLock(true);
                    idAppMain.forceActiveFocus();
                }else
                {
                    leftFocusAndLock(false);
                    idFuelPricesList.listView.positionViewAtIndex(idFuelPricesList.listView.currentIndex, ListView.Contain);
                    doCheckEnableMenuBtn();
                }
            }
        }

        noticeWhenListEmpty: fuelPriceDataManager.isOnRoute ? stringInfo.sSTR_XMDATA_NO_STATION_FOR_ONROUTE : stringInfo.sSTR_XMDATA_NO_STATION

        Connections{
            target : fuelPriceDataManager
            onCheckForFocus:{
                if(visible)
                {
                    idFuelPricesList.listView.positionViewAtIndex(0, ListView.Visible);
                    idFuelPricesList.listView.currentIndex = 0;
                    if (idFuelPricesList.listView.count == 0) {
                        idLeftMenuFocusScope.focus = true;
                        idLeftMenuFocusScope.KeyNavigation.right = null;
                    }
                }
            }

        }
    }

    function doCheckEnableMenuBtn(){
        if(visible && onRoute == false)
            idMenuBar.enableMenuBtn = idFuelPricesList.count == 0 ? false : true;
    }

    function currentIndexInitDelegate(){
        idFuelPricesList.listView.currentIndex = -1;
    }
}
