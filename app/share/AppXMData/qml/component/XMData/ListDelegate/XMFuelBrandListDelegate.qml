import Qt 4.7

// System Import
import "../../QML/DH" as MComp


//MComp.MComponent {
XMDataSmallTypeListDelegate{
    id: idListItem
    x:0; y:0
    z: index
    width:ListView.view.width-34; height:92

    Component.onCompleted: {
        if(ListView.view.count > 0)
        {
            leftFocusAndLock(false);
        }
    }

    Image {
        id:idBrandIconBg
        x: idBrandIcon.x-1; y: idBrandIcon.y-1
        source: imageInfo.imgFolderXMData + "bg_fuel.png"
    }
    Image {
        id:idBrandIcon
        x: 13; y: 24
        width:70;height:40
        source: fuelBrandIconForBrandList(brand)

        //for fuel brand Img
        function fuelBrandIconForBrandList(brand)
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

    // Brand
    MComp.DDScrollTicker{
        id: idText
        x: 13+96; y: 0
        width: 820
        height: parent.height
        text: brand
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

    //Debuging Data
    Text {
        id: idFranchiseCount
        x: 13+87; y: 65
        width: 250
        text:  "Count of franchise : " + franchise
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        visible: isDebugMode();
    }
    onClickOrKeySelected: {
        if(playBeepOn)
            UIListener.playAudioBeep();
        ListView.view.currentIndex = index;
        selectBrandname(brand);
    }
//    onPressAndHold: {
//        console.log("[QML] XMFuelBrandListDelegate - PressAndHold:"+index);
//    }

}

