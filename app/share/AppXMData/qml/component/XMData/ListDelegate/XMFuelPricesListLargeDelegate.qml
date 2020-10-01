import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../../XMData/Javascript/ConvertUnit.js" as MConvertUnit

MComp.MComponent{
    id: idListItem
    x:0; y:0
    width:ListView.view.width; height:137

    property bool distanceUnitChange: interfaceManager.DBIsMileDistanceUnit;
    property bool bfavorites: false;

    //Signal
    signal goButtonClicked(int locationID, string name, string addr);
    Image {
        x: 0; y: parent.height-2
        source: imageInfo.imgFolderMusic + "tab_list_line.png"
    }

    Component.onCompleted: {
        if(visible)
        {
            if(ListView.view.count > 0)
            {
                leftFocusAndLock(false);
            }
        }

        if(txtTitle.width > 175)
            idPoint.multiLineMode = true;
        else
            idPoint.multiLineMode = false;
    }

    Image {
        x:3; y: 137-102//8+9
        source: selectSource(direction)

        function selectSource(jDirection) {
            var direct = parseInt(jDirection);
            if( direct > 341 || direct <= 11 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_01.png";
            else if( direct > 11 && direct <= 33 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_02.png";
            else if( direct > 33 && direct <= 55 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_03.png";
            else if( direct > 55 && direct <= 77 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_04.png";
            else if( direct > 77 && direct <= 99 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_05.png";
            else if( direct > 99 && direct <= 121 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_06.png";
            else if( direct > 121 && direct <= 143 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_07.png";
            else if( direct > 143 && direct <= 165 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_08.png";
            else if( direct > 165 && direct <= 187 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_09.png";
            else if( direct > 187 && direct <= 209 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_10.png";
            else if( direct > 209 && direct <= 231 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_11.png";
            else if( direct > 231 && direct <= 253 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_12.png";
            else if( direct > 253 && direct <= 275 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_13.png";
            else if( direct > 275 && direct <= 297 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_14.png";
            else if( direct > 297 && direct <= 319 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_15.png";
            else if( direct > 319 && direct <= 341 )
                return imageInfo.imgFolderXMData + "direction/ico_direction_16.png";
            else
                return imageInfo.imgFolderXMData + "direction/ico_direction_05.png";
        }
    }

    Item{
        id: idPoint
        property bool multiLineMode: false
        x: 87; y: 0//44 - font.pixelSize/2;
        width: 175
        height: parent.height

        Text{
            id: txtTitle
            width: txtTitle.paintedWidth
            height: idPoint.height
            text: MConvertUnit.convertToDU(interfaceManager.DBIsMileDistanceUnit,distance) + (interfaceManager.DBIsMileDistanceUnit == false ? " km" : " mile")
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 36
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            visible: idPoint.multiLineMode == false
        }
        onVisibleChanged: {
            if(txtTitle.width > 175)
                idPoint.multiLineMode = true;
            else
                idPoint.multiLineMode = false;
        }
        Item{
            width: 175
            Text{
                x: 0; y:25+12-(36/2)
                width: parent.width
                height: 50
                text: MConvertUnit.convertToDU(interfaceManager.DBIsMileDistanceUnit,distance)
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 36
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignRight
            }
            Text{
                x: 0; y:75+10-(36/2)
                width: parent.width
                height: 50
                text: (interfaceManager.DBIsMileDistanceUnit == false ? "km" : "mile")
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 36
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignRight
            }
            visible: idPoint.multiLineMode == true
        }
    }

    Item{
        id: idBrendArea
        x: 87+175+40
        width: 86+21+23+107+23+107+23+107
        height: parent.height/2

        Image {
            id:idBrandIconBg
            x: idBrandIcon.x-1; y: idBrandIcon.y-1
            source: imageInfo.imgFolderXMData + "bg_fuel.png"
        }
        Image {
            id:idBrandIcon
            x: 0; y: 16
            source: fuelBrandIconForPriceListLarge(brand)

            //for fuel brand Img
            function fuelBrandIconForPriceListLarge(brand)
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

        // Brand ==> Name

        MComp.DDScrollTicker{
            id: idText
            x: 86; y: 0
            width: 21+23+107+23+107+23+107
            height: parent.height
            text: name
            fontFamily : systemInfo.font_NewHDR
            fontSize: 32
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerEnable: true
            tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
        }
    }

    Item{
        id: idTypeArea
        x: 87+175+40; y: parent.height/2
        width: 86+21+23+107+23+107+23+107
        height: parent.height/2

        // Regular
        Item{
            x: (107+23)*0; y: 0
            width: 107
            height: parent.height
            Text{
                x: 0
                height: parent.height/2
                text: stringInfo.sSTR_XMDATA_REGULAR
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 20
                color: colorInfo.dimmedGrey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text{
                y: parent.height/2
                height: parent.height/2
                text: (priceRegular == 9999 ? "-" : "$ " + priceRegular.toFixed(2))
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 28
                color: colorInfo.grey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                MXData.XMRectangleForDebug{}
            }
        }

        // Mid
        Item{
            x: (107+23)*1; y: 0
            width: 107
            height: parent.height
            Text{
                x: 0
                height: parent.height/2
                width:  parent.width
                text: stringInfo.sSTR_XMDATA_MIDGRADE
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 20
                color: colorInfo.dimmedGrey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text{
                y: parent.height/2
                height: parent.height/2
                text: (priceMid == 9999 ? "-" : "$ " + priceMid.toFixed(2))
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 28
                color: colorInfo.grey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                MXData.XMRectangleForDebug{}
            }
        }

        // Premium
        Item{
            x: (107+23)*2; y: 0
            width: 107
            height: parent.height
            Text{
                x: 0
                width: parent.width
                height: parent.height/2
                text: stringInfo.sSTR_XMDATA_PREMIUM
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 20
                color: colorInfo.dimmedGrey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text{
                y: parent.height/2
                height: parent.height/2
                text: (pricePremium == 9999 ? "-" : "$ " + pricePremium.toFixed(2))
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 28
                color: colorInfo.grey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                MXData.XMRectangleForDebug{}
            }
        }

        // Diesel
        Item{
            x: (107+23)*3; y: 0
            width: 107
            height: parent.height
            Text{
                x: 0
                width: parent.width
                height: parent.height/2
                text: stringInfo.sSTR_XMDATA_DIESEL
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 20
                color: colorInfo.dimmedGrey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text{
                y: parent.height/2
                width: parent.width
                height: parent.height/2
                text: (priceDiesel == 9999 ? "-" : "$ " + priceDiesel.toFixed(2))
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 28
                color: colorInfo.grey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                MXData.XMRectangleForDebug{}
            }
        }

        Image {
            x: 413-parent.x
            y: parent.height-58
            source: imageInfo.imgFolderXMData + "fuel_divider.png"
        }
        Image {
            x: (413+130)-parent.x
            y: parent.height-58
            source: imageInfo.imgFolderXMData + "fuel_divider.png"
        }
        Image {
            x: (413+130+130)-parent.x
            y: parent.height-58
            source: imageInfo.imgFolderXMData + "fuel_divider.png"
        }
    }

    MComp.MButton {
        id: idEditButton
        x: 3+816; y: 137-102-2//8+9
        width: 134; height: 79
        focus: true
        bgImage: imageInfo.imgFolderXMData + "btn_go_n.png"
        bgImagePress: imageInfo.imgFolderXMData + "btn_go_p.png"
        bgImageFocus: imageInfo.imgFolderXMData + "btn_go_f.png"
        firstTextX: 12
        firstText: stringInfo.sSTR_XMDATA_GO
        firstTextSize: 32
        firstTextStyle: systemInfo.font_NewHDB
        firstTextColor: colorInfo.brightGrey

        onBackKeyPressed: {
            gotoBackScreen(false);//CCP
        }
        onHomeKeyPressed: {
            gotoFirstScreen();
        }

        onClickOrKeySelected: {
            idListItem.ListView.view.currentIndex = index;
            goButtonClicked(locID, name, address);
        }
    }

    onClickOrKeySelected: {
        ListView.view.currentIndex = index;
        if(fuelPriceDataManager.isOnRoute)
        {
            var startIndex = ListView.view.getStartIndex(ListView.view.contentY);
            var endIndex = ListView.view.getEndIndex(ListView.view.contentY);
            if( (ListView.view.currentIndex < (ListView.view.count-1)) && (endIndex == ListView.view.currentIndex)
                && ((startIndex + 3) == endIndex) )
            {
                ListView.view.positionViewAtIndex(ListView.view.currentIndex, ListView.Beginning);
            }
        }
    }

    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        if((fuelPriceDataManager.isOnRoute) && (!bfavorites))
        {
            ListView.view.fuelmoveOnPageByPage(rowPerPage, true);
        }
        else
        {
            ListView.view.moveOnPageByPage(rowPerPage, true);
        }
    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        if((fuelPriceDataManager.isOnRoute) && (!bfavorites))
        {
            ListView.view.fuelmoveOnPageByPage(rowPerPage, false);
        }
        else
        {
            ListView.view.moveOnPageByPage(rowPerPage, false);
        }
    }

    function getBgImageOfDelegate()
    {
        /*if(idListItem.activeFocus && isMousePressed()){
           return imageInfo.imgFolderXMData + "fuel_list_fp.png"
        }else */if(isMousePressed()){
            return imageInfo.imgFolderXMData + "fuel_list_p.png"
        }else{
            return "";
        }
    }

    //property int debugOnOff: idAppMain.debugOnOff;
    Text {
        x:5; y:12; id:idFileName
        text:"XMFuelPricesListDelegate.qml";
        color : colorInfo.transparent;
    }
    Rectangle{
        x:10
        y:65
        visible:isDebugMode();
        Column{
            Row{
                Text{text:"["+index+"] EntryID:"+entryID +", distance:" + distance.toFixed(3)+", direction:"+ direction+", Lat:"+latitude+",Log:"+longitude; color:"white"}
            }
            Row{
                Text{text:"["+index+"] Name:"+ name +", Address:"+ address + ", PhoneNumber:" + phonenumber; color:"white"}
            }
        }
    }
}