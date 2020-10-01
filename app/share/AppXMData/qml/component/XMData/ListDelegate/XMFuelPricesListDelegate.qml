import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../../XMData/Javascript/ConvertUnit.js" as MConvertUnit

XMDataSmallTypeListDelegate{
    id: idListItem
    x:0; y:0
//    z: index
    width:ListView.view.width; height:92
    isShowBGImage: false;

    property bool distanceUnitChange: interfaceManager.DBIsMileDistanceUnit;

    Component.onCompleted: {
        if(ListView.view.count > 0)
        {
            leftFocusAndLock(false);
        }
    }

    signal goButtonClicked(int locationID, string name, string addr);

    Image {
        id:idBrandIconBg
        x: idBrandIcon.x-1; y: idBrandIcon.y-1
        //width : 78; height:  78
        source: imageInfo.imgFolderXMData + "bg_fuel.png"
    }
    Image {
        id:idBrandIcon
        x: 86 + 155 + 32; y: 24
        width:70;height:40

        source: fuelBrandIconForPriceList(brand)

        //for fuel brand Img
        function fuelBrandIconForPriceList(brand)
        {
//            console.log("brand: " + brand);
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
        x: 86 + 155 + 32 + 87; y: 0;
        width: 252
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

    // Fuel type
    Text {
        id: idType
        x: 86 + 155 + 32 + 87 + 252 + 62 - 20 ; y: 5;
        width: 146
        height: parent.height/2
        text: (selectedType == "0")? stringInfo.sSTR_XMDATA_REGULAR : (selectedType == "1")? stringInfo.sSTR_XMDATA_MIDGRADE : (selectedType == "2")? stringInfo.sSTR_XMDATA_PREMIUM : stringInfo.sSTR_XMDATA_DIESEL
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 24
        color: colorInfo.dimmedGrey
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // Price
    Text {
        id: idAmount
        x: 86 + 155 + 32 + 87 + 252 + 62 - 20 ; y: parent.height/2//24+20+19 - font.pixelSize/2;
        width: 146
        height: parent.height/2 - 5
        text: (selectedType == "0" ? priceRegular == "9999"? "-" : "$ " + priceRegular.toFixed(2) : selectedType == "1" ? priceMid == "9999"? "-" : "$ " + priceMid.toFixed(2) : selectedType == "2" ? pricePremium == "9999"? "-" : "$ " + pricePremium.toFixed(2) : priceDiesel == "9999"? "-" : "$ " + priceDiesel.toFixed(2))
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 32
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    // Distance
    Text {
        id: idPoint
        x: 86; y: 0//44 - font.pixelSize/2;
        width: 155
        height: parent.height
        text: MConvertUnit.convertToDU(distanceUnitChange, distance) + (distanceUnitChange == false ? " km" : " mile")
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 32
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }
    Image {
        x: 258; y: 0
        source: imageInfo.imgFolderXMData + "movie_divider.png"
    }
    Image {
        x: 258+379; y: 0
        source: imageInfo.imgFolderXMData + "movie_divider.png"
    }
    Image {
        x:6; y: 7//8+9
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

    MComp.MButton {
        id: idEditButton
        x: 801; y: 8//8+9
        width: 134; height: 79
        focus: true
        bgImage: imageInfo.imgFolderXMData + "btn_go_n.png"
        bgImagePress: imageInfo.imgFolderXMData + "btn_go_p.png"
        bgImageFocus: imageInfo.imgFolderXMData + "btn_go_f.png"
        firstTextX: 12
//        firstTextY: 39
//        firstTextWidth: 110
//        firstTextHeight: 32
        firstText: stringInfo.sSTR_XMDATA_GO
        firstTextSize: 32
        firstTextStyle: systemInfo.font_NewHDB
//        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        onBackKeyPressed: {
            gotoBackScreen(false);//CCP
        }
        onHomeKeyPressed: {
            gotoFirstScreen();
        }

        onClickOrKeySelected: {
            idListItem.forceActiveFocus();
            goButtonClicked(locID, name, address);
        }
    }

    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            ListView.view.currentIndex = index;
//            goButtonClicked(index, entryID, brand, name, address, phonenumber, latitude, longitude);
        }
    }
    onPressAndHold: {
        console.log("[QML] XMFuelPriceListDelegate - PressAndHold:"+index)
    }

    //property int debugOnOff: idAppMain.debugOnOff;
    Text {
        x:5; y:12; id:idFileName
        text:"XMFuelPricesListDelegate.qml";
        color : colorInfo.transparent;
    }
    Rectangle{
        x:10
        y:0
        visible:isDebugMode();
        Column{
            Row{
                Text{text:"["+index+"] EntryID:"+entryID  + ", distance:" + distance.toFixed(3)+", direction:"+ direction+", Lat:"+latitude+",Log:"+longitude; color:"white"}
            }
            Row{
                Text{text:"["+index+"] Name:"+ name +", Address:"+ address + ", PhoneNumber:" + phonenumber; color:"white"}
            }
            Row{
                Text{text:"R:"+priceRegular+", M:"+priceMid +", P:" +pricePremium+", D:"+priceDiesel; color:"white"}
            }
        }
    }
}
