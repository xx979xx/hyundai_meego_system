// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import Qt 4.7
import QtQuick 1.1

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../ListElement" as XMListElement
import "../Javascript/WeatherForecast.js" as MJavascript
import "../WeatherForecast" as MForecast
import "../Javascript/ConvertUnit.js" as MConvertUnit

Component{
    MComp.MComponent{
        id: idListItem
        x:0; y:0
        width:ListView.view.width; height:180
        //        focus: true

        property QtObject delegateItemInfo : XMListElement.XMDataMainMenuElement{}
        property QtObject dataManager : delegateItemInfo.getDataManager(delegateItemIndex)

        property int weatherEvent : Forecast0.wWEvent
        property int temperature : Forecast0.wTempCurrent
        property int isWeatherEvValid: Forecast0.wWeatherDataValid
        property int isMainTemperatureValid: Forecast0.wTemperatureDataValid

        property int prevDelegateItemIndex: prevItem
        property int nextDelegateItemIndex: nextItem

        property bool distanceUnitChange: interfaceManager.DBIsMileDistanceUnit//0: km, 1: mile
        property bool timeFormatChange: interfaceManager.DBIs24TimeFormat
        property bool summerTime: interfaceManager.DBIsDayLightSaving

        // Function for Change Text Color
        function changeTextColor(text) {
            if( text.charAt(0) == '+')
                return "#2F7DFF";
            else if( text.charAt(0) == '-')
                return "#EA3939";
            else
                return colorInfo.brightGrey;
        }

        function selectSource(jDirection) {
            var direct = parseInt(jDirection);
            if( direct > 341 || direct <= 11 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_01.png";
            else if( direct > 11 && direct <= 33 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_02.png";
            else if( direct > 33 && direct <= 55 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_03.png";
            else if( direct > 55 && direct <= 77 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_04.png";
            else if( direct > 77 && direct <= 99 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_05.png";
            else if( direct > 99 && direct <= 121 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_06.png";
            else if( direct > 121 && direct <= 143 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_07.png";
            else if( direct > 143 && direct <= 165 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_08.png";
            else if( direct > 165 && direct <= 187 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_09.png";
            else if( direct > 187 && direct <= 209 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_10.png";
            else if( direct > 209 && direct <= 231 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_11.png";
            else if( direct > 231 && direct <= 253 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_12.png";
            else if( direct > 253 && direct <= 275 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_13.png";
            else if( direct > 275 && direct <= 297 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_14.png";
            else if( direct > 297 && direct <= 319 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_15.png";
            else if( direct > 319 && direct <= 341 )
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_16.png";
            else
                return imageInfo.imgFolderXMData + "direction/ico_widget_direction_05.png";
        }

        function getComponent()
        {
            switch(delegateItemIndex)
            {
                case 0: return idCompWeather;
                case 1: return idCompTraffic;
                case 2: return idCompStock;
                case 3: return idCompSports;
                case 4: return idCompFuel;
                case 5: return idCompMovie;
                default: return null;
            }
        }

        function resetFristTicker()
        {
            if(idWidgetBg.tickerItem1 == null || idWidgetBg.tickerItem2 == null)
                return;

            var nextTicker = true;
            idWidgetBg.isFirstTicker = getNextTicker(nextTicker);
        }

        function resetFristTickerForMovie()
        {
            if(idWidgetBg.tickerItem1 == null)
                return;
            var nextTicker = true;
            idWidgetBg.isFirstTicker = getNextTicker(nextTicker);
        }
        function toggleTicker()
        {
            var nextTicker = idWidgetBg.isFirstTicker == true ? false: true;
            idWidgetBg.isFirstTicker = getNextTicker(nextTicker);
        }

        function getNextTicker(isFirst)
        {
            if(idWidgetBg.tickerItem1.overTextPaintedWidth <= 0 && isFirst == true)
                isFirst = false;
            else if(idWidgetBg.tickerItem2.overTextPaintedWidth <= 0 && isFirst == false)
                isFirst = true;
            return isFirst;
        }

        MComp.MButton{
            id: idWidgetBg
            x: 7; y:6
            width:1228; height: 168
            bgImage: imageInfo.imgFolderXMData + "bg_widget_n.png"
            bgImagePress: imageInfo.imgFolderXMData + "bg_widget_p.png"
            bgImageFocus: imageInfo.imgFolderXMData + "bg_widget_f.png"
            //            bgImageFocusPress: imageInfo.imgFolderXMData + "bg_widget_f.png"
            //            mEnabled: delegateItemInfo.isEnable(delegateItemIndex)
            focus: true//index == delegateItemIndex//delegateItemInfo.isEnable(delegateItemIndex)
            property bool isFirstTicker: true
            property Item tickerItem1: null
            property Item tickerItem2: null

            onActiveFocusChanged: {
                idListItem.resetFristTicker()
            }

            onClickOrKeySelected: {
                idListItem.ListView.view.currentIndex = index;
                idListItem.ListView.view.forceActiveFocus();
                delegateItemInfo.onClickOrKeySelected(delegateItemIndex);
            }
            MXData.XMRectangleForDebug{//for Debugging..
                x: 0; y:0
                width: parent.width
                height: parent.height
            }
        }

        Image{
            id: idMenuIcon
            x: idWidgetBg.x + 22; y:19+14
            source:delegateItemInfo.getIconPath(delegateItemIndex)
            opacity: 1.0//delegateItemInfo.isEnable(delegateItemIndex) ? 1.0 : 0.5
        }

        Loader{
            id: idWidgetLoader
            x: idWidgetBg.x; y: 0
            width: parent.width - idWidgetBg.x
            height: parent.height
            sourceComponent: getComponent()
        }

        // Menu Weather
        Component{
            id: idCompWeather
            Item{
                id: idWeatherWidgetItem
                opacity: 1.0//delegateItemInfo.isEnable(delegateItemIndex) ? 1.0 : 0.5

                Text{
                    id: idWeatherWidgetItem_FirstText
                    x: 22 + 115; y: 0
                    width: 144; height: parent.height
                    text: stringInfo.sSTR_XMDATA_WEATHER
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 32
                    color: colorInfo.brightGrey
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }

                Text{
                    id: idWeatherLoading
                    x: 22 + 115+164;
                    width: idListItem.width-x; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_MAIN_WIDGET_LOADING
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: (subscriptionData.SubWeather == 4 || (delegateItemInfo.isEnable(delegateItemIndex) == false && subscriptionData.SubWeather != 0))
                }

                Text{
                    id : idWeatherUnSubscribed
                    x: 22 + 115 + 164;
                    width: parent.width - x ; height: parent.height
                    text : stringInfo.sSTR_XMDATA_UNSUBSCRIBED
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: subscriptionData.SubWeather != 1 && !idWeatherLoading.visible
                }

                Item{
                    anchors.fill: parent
                    visible: delegateItemInfo.isEnable(delegateItemIndex) == true && !idWeatherUnSubscribed.visible && !idWeatherLoading.visible

                    MComp.DDScrollTicker{
                        id: idWeatherWidgetItem_SecondText
                        x: 324 ; y:0
                        width: 430//315
                        height: parent.height/2
                        text: weatherDataManager.szCityName
                        fontFamily : systemInfo.font_NewHDR
                        fontSize: 38
                        color: colorInfo.brightGrey
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignBottom
                        tickerEnable: true
                        tickerFocus: (idWidgetBg.activeFocus && idAppMain.focusOn)
                    }

                    Text {
                        id: idWeatherWidgetItem_ThirdText
                        x: 324; y:parent.height/2
                        width: 430//315
                        height: parent.height/2
                        text: weatherDataManager.szStateName
                        font.family: systemInfo.font_NewHDR
                        font.pixelSize: 32
                        color: colorInfo.grey
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignTop
                    }

                    Image {
                        id: idWeatherWidgetItem_WeatherEventIcon
                        x: 324+430+27/*324+315+13*/; y: 5
                        width: 191; height: 157
                        source: isWeatherEvValid != -1 ? MJavascript.getWidgetIcoImagePath(weatherEvent) : MJavascript.getWidgetIcoImagePath(0);
                        visible: weatherEvent != -999
                    }

                    Text {
                        id: idWeatherWidgetItem_FourthText
                        x: 324+430+27+191/*324+315+13+191+150*/; y:0
                        width: 225//204
                        height: parent.height
                        //text: isMainTemperatureValid != -1 ? distanceUnitChange ? MJavascript.getTemperature(temperature, 0) : MJavascript.getTemperature(temperature, 1) : "-"
                        text: isMainTemperatureValid != -1 ? MJavascript.getTemperature(temperature, 0) : "-"
                        font.family: systemInfo.font_NewHDR
                        font.pixelSize: distanceUnitChange ? 80 : 73
                        color: colorInfo.brightGrey
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        visible: temperature != -999
                    }
                }
            }
        }

        // Menu Traffic
        Component{
            id: idCompTraffic
            Item{
                id: idTrafficWidgetItem
                opacity: 1.0//delegateItemInfo.isEnable(delegateItemIndex) ? 1.0 : 0.5
                property int subTraffic: subscriptionData.SubTraffic
                property bool bTrafficEnable: interfaceManager.bTrafficEnable
                property bool isMountedMMC: interfaceManager.isMountedMMC
                property bool bTrafficEmpty: interfaceManager.bTrafficEmpty

                onSubTrafficChanged: selectShowingTest()
                onBTrafficEnableChanged: selectShowingTest()
                onIsMountedMMCChanged: selectShowingTest()
                onBTrafficEmptyChanged: selectShowingTest()

                function selectShowingTest(){
                    if(!isMountedMMC)
                    {
                        idTrafficNoNavi.visible = true;
                        idTrafficLoading.visible = false;
                        idTrafficUnSubscribed.visible = false;
                        idTrafficText.visible = false;
                        idTrafficNoInformationAvailable.visible = false;
                    }else if((subTraffic == 4 || (bTrafficEnable == false && subTraffic != 0)) && !isDebugVersion)
                    {
                        idTrafficNoNavi.visible = false;
                        idTrafficLoading.visible = true;
                        idTrafficUnSubscribed.visible = false;
                        idTrafficText.visible = false;
                        idTrafficNoInformationAvailable.visible = false;
                    }else if((subTraffic != 1) && !isDebugVersion)
                    {
                        idTrafficNoNavi.visible = false;
                        idTrafficLoading.visible = false;
                        idTrafficUnSubscribed.visible = true;
                        idTrafficText.visible = false;
                        idTrafficNoInformationAvailable.visible = false;
                    }else if(bTrafficEmpty)
                    {
                        idTrafficNoNavi.visible = false;
                        idTrafficLoading.visible = false;
                        idTrafficUnSubscribed.visible = false;
                        idTrafficText.visible = false;
                        idTrafficNoInformationAvailable.visible = true;
                    }else
                    {
                        idTrafficNoNavi.visible = false;
                        idTrafficLoading.visible = false;
                        idTrafficUnSubscribed.visible = false;
                        idTrafficText.visible = true;
                        idTrafficNoInformationAvailable.visible = false;
                    }
                }

                Text{
                    x: 22 + 115; y: 0
                    width: 164; height: parent.height
                    text: stringInfo.sSTR_XMDATA_TRAFFIC
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 32
                    color: colorInfo.brightGrey
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }

                Text{
                    id: idTrafficNoNavi
                    x: 22+115+164;
                    width: idListItem.width-x-100; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_TRAFFIC_SERVICE_UNAVAILABLE
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 36
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: false
                }

                Text{
                    id: idTrafficLoading
                    x: 22 + 115+164;
                    width: idListItem.width-x; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_MAIN_WIDGET_LOADING
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: true
                }

                Text{
                    id: idTrafficNoInformationAvailable
                    x: 22 + 115+164;
                    width: idListItem.width-x-50; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_NO_INFORMATION
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: false
                }

                Text{
                    id : idTrafficUnSubscribed
                    x: 22 + 115 + 164;
                    width: parent.width - x ; height: parent.height
                    text : stringInfo.sSTR_XMDATA_UNSUBSCRIBED
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: false
                }

                Text{
                    id : idTrafficText
                    x: 22 + 115 + 164 + 10;
                    width: parent.width - x -50; height: parent.height-10
                    text : stringInfo.sSTR_XMDATA_MAIN_WIDGET_TRAFFIC_FIRST_LINE
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 36
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: false//interfaceManager.bTrafficEnable == true && !idTrafficUnSubscribed.visible && !idTrafficLoading.visible
                }
            }
        }


        // Menu Stock
        Component{
            id: idCompStock
            Item{
                id: idStockWidgetItem
                opacity: 1.0//delegateItemInfo.isEnable(delegateItemIndex) ? 1.0 : 0.5
                Text{
                    x: 22 + 115; y: 0
                    width:  22 + 115; height: parent.height
                    text: stringInfo.sSTR_XMDATA_STOCK
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 32
                    color: colorInfo.brightGrey
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }

                Text{
                    id: idStockLoading
                    x: 22 + 115+164;
                    width: idListItem.width-x; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_MAIN_WIDGET_LOADING
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: (subscriptionData.SubStock == 4 || (delegateItemInfo.isEnable(delegateItemIndex) == false && subscriptionData.SubStock != 0)) && !idAppMain.isDRSChange
                }

                Text{
                    id : idStockUnSubscribed
                    x: 22 + 115 + 164;
                    width: parent.width - x ; height: parent.height
                    text : stringInfo.sSTR_XMDATA_UNSUBSCRIBED
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: subscriptionData.SubStock != 1 && !idStockLoading.visible && !idAppMain.isDRSChange
                }

                Text{
                    id : idStockNoFavoriteData
                    x: 22 + 115 + 164;
                    width: parent.width - x - 50; height: parent.height
                    text : stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITES_STOCK
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 36
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: delegateItemInfo.isEnable(delegateItemIndex) == true && !idStockUnSubscribed.visible && !idStockLoading.visible && (stockMyFavoriteDataModel[0] == null && stockMyFavoriteDataModel[1] == null && stockMyFavoriteDataModel[2] == null) && !idAppMain.isDRSChange
                }

                Text{
                    id : idStockDrivingRestriction
                    x: 22 + 115 + 164;
                    width: parent.width - x - 50; height: parent.height
                    text : stringInfo.sSTR_XMDATA_DRS_WARNING_EX
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 36
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: idAppMain.isDRSChange/*delegateItemInfo.isEnable(delegateItemIndex) == true && !idStockUnSubscribed.visible && !idStockLoading.visible && !idStockNoFavoriteData.visible  && idAppMain.isDRSChange*/
                }

                Item {
                    anchors.fill: parent
                    visible: delegateItemInfo.isEnable(delegateItemIndex) == true && !idStockUnSubscribed.visible && !idStockLoading.visible && !idStockNoFavoriteData.visible  && !idAppMain.isDRSChange

                    Image {
                        x: 323+27
                        y: 31+25+2
                        source: imageInfo.imgFolderXMData + "widget_line.png"
                    }

                    Image {
                        x: 323+27
                        y: 31+25+52
                        source: imageInfo.imgFolderXMData + "widget_line.png"
                    }

                    Item{
                        id: idFavorite1
                        x: 323
                        y: 23
                        width: 335+79+191+103+171
                        height: (parent.height-23-26)/3

                        Text {
                            x: 0
                            y: 0
                            width: 335
                            height: parent.height
                            text: stockMyFavoriteDataModel[0] == null ? "N/A" : stockMyFavoriteDataModel[0].Symbol == "" ? "N/A" : stockMyFavoriteDataModel[0].Symbol
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 30
                            color: colorInfo.brightGrey
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignBottom
                        }

                        Text {
                            x: 335+79
                            y: 0
                            width: 191
                            height: parent.height
                            text: stockMyFavoriteDataModel[0] == null ? "N/A" : stockMyFavoriteDataModel[0].LastSale == "" ? "N/A" : stockMyFavoriteDataModel[0].LastSale
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 30
                            color: colorInfo.brightGrey
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignBottom
                        }
                        Text {
                            x: 335+79+191+103
                            y: 0
                            width: 171
                            height: parent.height
                            text: stockMyFavoriteDataModel[0] == null ? "N/A" : stockMyFavoriteDataModel[0].PriceChange == "" ? "N/A" : stockMyFavoriteDataModel[0].PriceChange
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 30
                            color: changeTextColor(stockMyFavoriteDataModel[0] == null ? "" : stockMyFavoriteDataModel[0].PriceChange)
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignBottom
                        }
                    }

                    Item{
                        id: idFavorite2
                        x: 323
                        y: idFavorite1.y + idFavorite1.height + 3
                        width: 335+79+191+103+171
                        height: (parent.height-23-26)/3

                        Text {
                            x: 0
                            y: 0
                            width: 335
                            height: parent.height
                            text: stockMyFavoriteDataModel[1] == null ? "N/A" : stockMyFavoriteDataModel[1].Symbol == "" ? "N/A" : stockMyFavoriteDataModel[1].Symbol
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 30
                            color: colorInfo.brightGrey
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            x: 335+79
                            y: 0
                            width: 191
                            height: parent.height
                            text: stockMyFavoriteDataModel[1] == null ? "N/A" : stockMyFavoriteDataModel[1].LastSale == "" ? "N/A" : stockMyFavoriteDataModel[1].LastSale
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 30
                            color: colorInfo.brightGrey
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            x: 335+79+191+103
                            y: 0
                            width: 171
                            height: parent.height
                            text: stockMyFavoriteDataModel[1] == null ? "N/A" : stockMyFavoriteDataModel[1].PriceChange == "" ? "N/A" : stockMyFavoriteDataModel[1].PriceChange
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 30
                            color: changeTextColor(stockMyFavoriteDataModel[1] == null ? "" : stockMyFavoriteDataModel[1].PriceChange)
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Item{
                        id: idFavorite3
                        x: 323
                        y: idFavorite2.y + idFavorite2.height + 3
                        width: 335+79+191+103+171
                        height: (parent.height-23-26)/3

                        Text {
                            x: 0
                            y: 0
                            width: 335
                            height: parent.height
                            text: stockMyFavoriteDataModel[2] == null ? "N/A" : stockMyFavoriteDataModel[2].Symbol == "" ? "N/A" : stockMyFavoriteDataModel[2].Symbol
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 30
                            color: colorInfo.brightGrey
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                        }
                        Text {
                            x: 335+79
                            y: 0
                            width: 191
                            height: parent.height
                            text: stockMyFavoriteDataModel[2] == null ? "N/A" : stockMyFavoriteDataModel[2].LastSale == "" ? "N/A" : stockMyFavoriteDataModel[2].LastSale
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 30
                            color: colorInfo.brightGrey
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignTop
                        }
                        Text {
                            x: 335+79+191+103
                            y: 0
                            width: 171
                            height: parent.height
                            text: stockMyFavoriteDataModel[2] == null ? "N/A" : stockMyFavoriteDataModel[2].PriceChange == "" ? "N/A" : stockMyFavoriteDataModel[2].PriceChange
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 30
                            color: changeTextColor(stockMyFavoriteDataModel[2] == null ? "" : stockMyFavoriteDataModel[2].PriceChange)
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignTop
                        }
                    }
                }
            }
        }

        // Menu Sports
        Component{
            id: idCompSports
            Item{
                id: idSportsWidgetItem
                opacity: 1.0//delegateItemInfo.isEnable(delegateItemIndex) ? 1.0 : 0.5

                Text{
                    x: 22 + 115; y: 0
                    width: 164; height: parent.height
                    text: stringInfo.sSTR_XMDATA_SPORTS
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 32
                    color: colorInfo.brightGrey
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }

                Text{
                    id: idSportsLoading
                    x: 22 + 115 + 164;
                    width: idListItem.width-x; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_MAIN_WIDGET_LOADING
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: (subscriptionData.SubSports == 4 || (delegateItemInfo.isEnable(delegateItemIndex) == false && subscriptionData.SubSports != 0)) && !idAppMain.isDRSChange
                }

                Text{
                    id : idSportsUnSubscribed
                    x: 22 + 115 + 164;
                    width: parent.width - x ; height: parent.height
                    text : stringInfo.sSTR_XMDATA_UNSUBSCRIBED
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: subscriptionData.SubSports != 1 && !idSportsLoading.visible && !idAppMain.isDRSChange
                }

                Text{
                    id : idSportsDrivingRestriction
                    x: 22 + 115 + 164;
                    width: parent.width - x - 50; height: parent.height
                    text : stringInfo.sSTR_XMDATA_DRS_WARNING_EX
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 36
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: idAppMain.isDRSChange/*(sportsDataManager.mmFavoriteAffiliationListIsEmpty === false && delegateItemInfo.isEnable(delegateItemIndex) == true && !idSportsUnSubscribed.visible && !idSportsLoading.visible && idAppMain.isDRSChange)*/
                }

                Text{
                    id: idSportsNoFavoriteData
                    x: 22 + 115 + 164;
                    width: idListItem.width-x; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_NO_FAVORITES_LEAGUE
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 36
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: (sportsDataManager.mmFavoriteAffiliationListIsEmpty === 1 && delegateItemInfo.isEnable(delegateItemIndex) == true && !idSportsUnSubscribed.visible && !idSportsLoading.visible && !idAppMain.isDRSChange)
                }

                Text{
                    id: idSportsFavoriteNoEvent
                    x: 22 + 115 + 164;
                    width: idListItem.width-x; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_SPORTS_NO_CURRENT_EVENT
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 36
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: (sportsDataManager.mmFavoriteAffiliationListIsEmpty === 2 && delegateItemInfo.isEnable(delegateItemIndex) == true && !idSportsUnSubscribed.visible && !idSportsLoading.visible && !idAppMain.isDRSChange)
                }

                Item{
                    id: idSportsHeadToHeadEvent
                    anchors.fill: parent
                    visible: (sportsDataManager.mmFavoriteAffiliationListIsEmpty === 3 && delegateItemInfo.isEnable(delegateItemIndex) == true && !idSportsUnSubscribed.visible && !idSportsLoading.visible && !idAppMain.isDRSChange)

                    onVisibleChanged: resetFristTicker()

                    Image{
                        x: 350
                        y: 24+62
                        source: imageInfo.imgFolderXMData + "line_widget_sports_01.png"
                    }

                    Image{
                        x: 350+468
                        y: 24
                        source: imageInfo.imgFolderXMData + "widget_divider.png"
                    }
                    Image{
                        x: 350+468+200
                        y: 24
                        source: imageInfo.imgFolderXMData + "widget_divider.png"
                    }

                    //[ISV 88554]
                    //visiting team
                    MComp.DDScrollTicker{
                        id: idVisitingTeam
                        x: 324 ; y:24
                        width: 467
                        height: 62
                        text: sportsDataManager.mmFavoriteAffiliationVisitingName
                        fontFamily : systemInfo.font_NewHDR
                        fontSize: 36
                        color: colorInfo.brightGrey
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        tickerEnable: true//idVisitingTeam.visible == true/*idSportsHeadToHeadEvent.visitingTeamTickerEnableCheck()*/
                        tickerFocus: (idWidgetBg.activeFocus && idWidgetBg.isFirstTicker == true) && idAppMain.focusOn
                        onTickerTextEnd: toggleTicker()
                        onDoCheckTickerForTextChanged : resetFristTicker()

                    }

                    Text{
                        id: idVisitingTeamScore
                        x: 324+467+89
                        y: 24;
                        width: 78; height: 62;
                        text: sportsDataManager.mmFavoriteAffiliationVisitingScore
                        font.family: systemInfo.font_NewHDR
                        font.pixelSize: 36
                        color: colorInfo.brightGrey
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    //home team
                    MComp.DDScrollTicker{
                        id: idHomeTeam
                        x: 324 ; y:24+62
                        width: 467
                        height: 62
                        text: sportsDataManager.mmFavoriteAffiliationHomeName
                        fontFamily : systemInfo.font_NewHDR
                        fontSize: 36
                        color: colorInfo.brightGrey
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        tickerEnable: true//idHomeTeam.visible == true
                        tickerFocus: (idWidgetBg.activeFocus && idWidgetBg.isFirstTicker == false) && idAppMain.focusOn
                        onTickerTextEnd: toggleTicker()
                        onDoCheckTickerForTextChanged : resetFristTicker()
                    }

                    Component.onCompleted: {
                        idWidgetBg.tickerItem1 = idVisitingTeam;
                        idWidgetBg.tickerItem2 = idHomeTeam;
                    }

                    Text{
                        id: idHomeTeamScore
                        x: 324+467+89
                        y: 24+62;
                        width: 78; height: 62;
                        text: sportsDataManager.mmFavoriteAffiliationHomeScore
                        font.family: systemInfo.font_NewHDR
                        font.pixelSize: 36
                        color: colorInfo.brightGrey
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text{
                        id: idEventDivision
                        x: 324+467+89+78+92
                        y: 0
                        width: 143
                        height: parent.height
                        text: sportsDataManager.mmFavoriteAffiliationEventState ==  3 ? "F" : sportsDataManager.mmFavoriteAffiliationEventDivision // 3 : Final
                        font.family: systemInfo.font_NewHDR
                        font.pixelSize: 46
                        color: colorInfo.brightGrey
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // Menu Fuel
        Component{
            id: idCompFuel
            Item{
                id: idFuelPriceWidgetItem
                opacity: 1.0//delegateItemInfo.isEnable(delegateItemIndex) ? 1.0 : 0.5

                Text{
                    id: idFuelPriceWidgetItem_FirstText
                    x: 22 + 115; y: 0
                    width: 150; height: parent.height
                    text: stringInfo.sSTR_XMDATA_FUELPRICES
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 32
                    color: colorInfo.brightGrey
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }

                Text{
                    id: idFuelPriceNoInformationAvailable
                    x: 22 + 115+164;
                    width: idListItem.width-x-50; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_MAIN_NO_STATION
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: !idFuelPriceWidgetItem_StationName.text.length && !idFuelPriceUnSubscribed.visible && subscriptionData.SubFuelPrice === 1
                }

                Text{
                    id: idFuelPriceLoading
                    x: 22 + 115+164;
                    width: idListItem.width-x; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_MAIN_WIDGET_LOADING
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: (subscriptionData.SubFuelPrice == 4 || (delegateItemInfo.isEnable(delegateItemIndex) == false && subscriptionData.SubFuelPrice != 0 && subscriptionData.SubFuelPrice != 1))
                }

                Text{
                    id : idFuelPriceUnSubscribed
                    x: 22 + 115 + 164;
                    width: parent.width - x ; height: parent.height
                    text : stringInfo.sSTR_XMDATA_UNSUBSCRIBED
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: subscriptionData.SubFuelPrice != 1 && !idFuelPriceLoading.visible
                    Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "transparent"
                    }
                }

                Item {
                    anchors.fill: parent
                    visible: delegateItemInfo.isEnable(delegateItemIndex) == true && !idFuelPriceUnSubscribed.visible && !idFuelPriceLoading.visible && !idFuelPriceNoInformationAvailable.visible

                    Image{
                        id: idFuelPriceWidgetItem_HeadingIcon
                        x: 323
                        anchors.verticalCenter: parent.verticalCenter;
                        source: selectSource(fuelPriceDataManager.mmFuelDirection)
                    }

                    Item{
                        id: idFuelDistanceItem
                        anchors.fill: parent
                        property bool multiLineMode: false
                        Text{
                            id: txtTitle
                            x:323+102
                            y: 0
                            width: txtTitle.paintedWidth /*202*/
                            height: parent.height
                            text: MConvertUnit.convertToDU(distanceUnitChange,fuelPriceDataManager.mmFuelDistance) + (distanceUnitChange == false ? " km" : " mile")
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 40
                            color: colorInfo.brightGrey
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            visible: idFuelDistanceItem.multiLineMode == false

                        }
                        onVisibleChanged: {
                            if(txtTitle.width > 220)
                                idFuelDistanceItem.multiLineMode = true;
                            else
                                idFuelDistanceItem.multiLineMode = false;
                        }
                        Item{
                            x: 323+102;
                            width: 202
                            Text{
                                x: 0; y:25+22+12+25 - 50
                                height: 50
                                text: MConvertUnit.convertToDU(distanceUnitChange,fuelPriceDataManager.mmFuelDistance)
                                font.family: systemInfo.font_NewHDR
                                font.pixelSize: 40
                                color: colorInfo.brightGrey
                                horizontalAlignment: Text.AlignLeft
                            }
                            Text{
                                x: 0; y:25+22+12+25
                                height: 50
                                text: distanceUnitChange == false ? "km" : "mile"
                                font.family: systemInfo.font_NewHDR
                                font.pixelSize: 40
                                color: colorInfo.brightGrey
                                horizontalAlignment: Text.AlignLeft
                            }
                            visible: idFuelDistanceItem.multiLineMode == true
                        }
                    }

                    Image {
                        x: 323+102+202+19
                        y: 24
                        source: imageInfo.imgFolderXMData + "widget_divider.png"
                    }

                    Image{
                        id: idFuelPriceWidgetItem_BrandIconBG
                        x:  667; y: 28
                        source: imageInfo.imgFolderXMData + "bg_fuel.png"
                    }

                    Image{
                        id:idFuelPriceWidgetItem_BrandIcon
                        x:  667; y: 28
                        source:fuelBrandIconForMainMenu(fuelPriceDataManager.mmFuelBrand)

                        //for fuel brand Img
                        function fuelBrandIconForMainMenu(brand)
                        {
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

                    MComp.DDScrollTicker{
                        id: idFuelPriceWidgetItem_StationName
                        x: 667+86 ; y:28
                        width: 411
                        height: 42
                        text: fuelPriceDataManager.mmFuelBrandName
                        fontFamily : systemInfo.font_NewHDR
                        fontSize: 32
                        color: colorInfo.brightGrey
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        tickerEnable: true
                        tickerFocus: (idWidgetBg.activeFocus && idAppMain.focusOn)
                    }

                    //Regular
                    Item{
                        x: 667; y:28+21+34
                        width: 107
                        Text{
                            x: 0
                            y: 0
                            height: 20
                            text: stringInfo.sSTR_XMDATA_REGULAR
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 20
                            color: colorInfo.dimmedGrey
                            horizontalAlignment: Text.AlignLeft
                        }

                        Text{
                            x: 0
                            y: 20
                            height: 28
                            text: fuelPriceDataManager.mmFuelPriceR == 9999 ? "-" : "$ " + fuelPriceDataManager.mmFuelPriceR.toFixed(2)
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 28
                            color: colorInfo.brightGrey
                            horizontalAlignment: Text.AlignLeft
                        }
                    }

                    Image{
                        x: 667+107+19
                        y: 28+21+34
                        source: imageInfo.imgFolderXMData + "fuel_divider.png"
                    }

                    //Mid
                    Item{
                        x: 667+107+19+19; y:28+21+34
                        width: 107
                        Text{
                            x: 0
                            y: 0
                            height: 20
                            text: stringInfo.sSTR_XMDATA_MIDGRADE
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 20
                            color: colorInfo.dimmedGrey
                            horizontalAlignment: Text.AlignLeft
                            elide: Text.ElideRight
                        }

                        Text{
                            x: 0
                            y: 20
                            height: 28
                            text: fuelPriceDataManager.mmFuelPriceM == 9999 ? "-" : "$ " + fuelPriceDataManager.mmFuelPriceM.toFixed(2)
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 28
                            color: colorInfo.brightGrey
                            horizontalAlignment: Text.AlignLeft
                        }
                    }

                    Image{
                        x: 667+107+19+19+107+19
                        y: 28+21+34
                        source: imageInfo.imgFolderXMData + "fuel_divider.png"
                    }

                    //Premium
                    Item{
                        x: 667+107+19+19+107+19+19; y:28+21+34
                        width: 107
                        Text{
                            x: 0
                            y: 0
                            height: 20
                            text: stringInfo.sSTR_XMDATA_PREMIUM
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 20
                            color: colorInfo.dimmedGrey
                            horizontalAlignment: Text.AlignLeft
                        }

                        Text{
                            x: 0
                            y: 20
                            height: 28
                            text: fuelPriceDataManager.mmFuelPriceP == 9999 ? "-" : "$ " + fuelPriceDataManager.mmFuelPriceP.toFixed(2)
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 28
                            color: colorInfo.brightGrey
                            horizontalAlignment: Text.AlignLeft
                        }
                    }

                    Image{
                        x: 667+107+19+19+107+19+19+107+19
                        y: 28+21+34
                        source: imageInfo.imgFolderXMData + "fuel_divider.png"
                    }

                    //Diesel
                    Item{
                        x: 667+107+19+19+107+19+19+107+19+19; y:28+21+34
                        width: 107
                        Text{
                            x: 0
                            y: 0
                            height: 20
                            text: stringInfo.sSTR_XMDATA_DIESEL
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 20
                            color: colorInfo.dimmedGrey
                            horizontalAlignment: Text.AlignLeft
                        }

                        Text{
                            x: 0
                            y: 20
                            height: 28
                            text: fuelPriceDataManager.mmFuelPriceD == 9999 ? "-" : "$ " + fuelPriceDataManager.mmFuelPriceD.toFixed(2)
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 28
                            color: colorInfo.brightGrey
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                }
            }
        }

        // Menu Movie
        Component{
            id: idCompMovie
            Item{
                id: idMovieTimesWidgetItem
                opacity: 1.0//delegateItemInfo.isEnable(delegateItemIndex) ? 1.0 : 0.5

                Text{
                    x: 22 + 115; y: 0
                    width: 144; height: parent.height
                    text: stringInfo.sSTR_XMDATA_MOVIETIMES
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 32
                    color: colorInfo.brightGrey
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }

                Text{
                    id: idMovieTimesNoInformationAvailable
                    x: 22 + 115 + 164;
                    width: idListItem.width-x-50; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_MAIN_NO_THEATER_INFORMATION
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: !idMovieTimesWidgetItem_TheaterName.text.length && !idMovieTimesUnSubscribed.visible && subscriptionData.SubMovieTimes == 1 && !idAppMain.isDRSChange
                }

                Text{
                    id: idMovieTimesLoading
                    x: 22 + 115 + 164;
                    width: idListItem.width-x; height: idListItem.height;
                    text: stringInfo.sSTR_XMDATA_MAIN_WIDGET_LOADING
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: (subscriptionData.SubMovieTimes == 4 || (delegateItemInfo.isEnable(delegateItemIndex) == false && subscriptionData.SubMovieTimes != 0 && subscriptionData.SubMovieTimes != 1)) && !idAppMain.isDRSChange
                }

                Text{
                    id : idMovieTimesUnSubscribed
                    x: 22 + 115 + 164;
                    width: parent.width - x ; height: parent.height
                    text : stringInfo.sSTR_XMDATA_UNSUBSCRIBED
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: !idMovieTimesLoading.visible && subscriptionData.SubMovieTimes != 1 && !idAppMain.isDRSChange
                }

                Text{
                    id : idMovieTimesDrivingRestriction
                    x: 22 + 115 + 164;
                    width: parent.width - x - 50; height: parent.height
                    text : stringInfo.sSTR_XMDATA_DRS_WARNING_EX
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 36
                    color: colorInfo.brightGrey
                    wrapMode: Text.Wrap
                    lineHeight: 0.75
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: idAppMain.isDRSChange/*delegateItemInfo.isEnable(delegateItemIndex) == true && !idMovieTimesUnSubscribed.visible && !idMovieTimesLoading.visible && idAppMain.isDRSChange*/
                }

                Item{
                    id: idMovieTimesMainDelegate
                    anchors.fill: parent
                    visible: delegateItemInfo.isEnable(delegateItemIndex) == true && !idMovieTimesUnSubscribed.visible && !idMovieTimesLoading.visible && !idAppMain.isDRSChange && !idMovieTimesNoInformationAvailable.visible

                    onVisibleChanged: resetFristTickerForMovie()

                    Image {
                        id:idDirectionImage
                        x:323
                        anchors.verticalCenter: parent.verticalCenter;
                        source: selectSource(movieTimesDataManager.mmMovieDirection)
                        //MXData.XMRectangleForDebug{}
                    }

                    Item{
                        id: idMovieDistanceItem
                        anchors.fill: parent
                        property bool multiLineMode: true
                        Text{
                            x:323+102
                            y: 0
                            width: 202
                            height: parent.height
                            text: MConvertUnit.convertToDU(distanceUnitChange,movieTimesDataManager.mmMovieDistance) + (distanceUnitChange == false ? " km" : " mile")
                            font.family: systemInfo.font_NewHDR
                            font.pixelSize: 40
                            color: colorInfo.brightGrey
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            visible: idMovieDistanceItem.multiLineMode == false

                            onTextChanged: {
                                if(paintedWidth > 220)
                                    idMovieDistanceItem.multiLineMode = true;
                                else
                                    idMovieDistanceItem.multiLineMode = false;
                            }
                        }
                        Item{
                            x: 323+102;
                            width: 202

                            Item {
                                x: 0; y: 46+12;
                                MComp.Label {
                                    text: MConvertUnit.convertToDU(distanceUnitChange,movieTimesDataManager.mmMovieDistance)
                                    txtAlign: "Left"
                                    fontName: systemInfo.font_NewHDR
                                    fontSize: 40
                                    fontColor: colorInfo.brightGrey
                                }
                            }
                            Item {
                                x: 0; y: 46+12+50;
                                MComp.Label {
                                    text: distanceUnitChange == false ? "km" : "mile"
                                    txtAlign: "Left"
                                    fontName: systemInfo.font_NewHDR
                                    fontSize: 40
                                    fontColor: colorInfo.brightGrey
                                }
                            }
                            visible: idMovieDistanceItem.multiLineMode == true
                        }
                    }

                    Image {
                        x: 646
                        y: 24
                        source: imageInfo.imgFolderXMData + "widget_divider.png"
                    }

                    Image{
                        x: 646
                        y: 24+62
                        source: imageInfo.imgFolderXMData + "line_widget_movie.png"
                    }

                    MComp.DDScrollTicker{
                        id: idMovieTimesWidgetItem_TheaterName
                        x: (323+102+202+50) - idMovieTimesWidgetItem.x ; y:46 - 36/2 + 36/8
                        width: 285+20+210
                        height: 36
                        text: movieTimesDataManager.mmMovieTheaterName
                        fontFamily : systemInfo.font_NewHDR
                        fontSize: 36
                        color: colorInfo.brightGrey
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        tickerEnable: true
                        tickerFocus: (idWidgetBg.activeFocus && idWidgetBg.isFirstTicker == true) && idAppMain.focusOn
                        onTickerTextEnd: toggleTicker()
                        onDoCheckTickerForTextChanged : resetFristTicker()
                    }

                    MComp.DDScrollTicker{
                        id: idMovieTimesWidgetItem_MovieName
                        x: (323+102+202+50) - idMovieTimesWidgetItem.x ; y: (46+12+50) - 36/2 + 36/8
                        width: 285
                        height: 36
                        text: movieTimesDataManager.mmMovieMovieName
                        fontFamily : systemInfo.font_NewHDR
                        fontSize: 36
                        color: colorInfo.brightGrey
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        tickerEnable: true
                        tickerFocus: (idWidgetBg.activeFocus && idWidgetBg.isFirstTicker == false) && idAppMain.focusOn
                        onTickerTextEnd: toggleTicker()
                        onDoCheckTickerForTextChanged: resetFristTicker()
                    }
                    Component.onCompleted: {
                        idWidgetBg.tickerItem1 = idMovieTimesWidgetItem_TheaterName;
                        idWidgetBg.tickerItem2 = idMovieTimesWidgetItem_MovieName;
                    }

                    Text{
                        x: (323+102+202+50+285+20) - idMovieTimesWidgetItem.x
                        y: (46+12+50) - 36/2 + 36/8
                        width: 210
                        height: (parent.height)/2 + 5
                        text: movieTimesDataManager.mmMovieStartTime != 0 ? stringInfo.sSTR_XMDATA_STARTING + " " + MConvertUnit.convertTimeFormatForOthers(movieTimesDataManager.mmMovieStartTime, false, timeFormatChange) : "";
                        font.family: systemInfo.font_NewHDR
                        font.pixelSize: 24
                        color: colorInfo.dimmedGrey
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignTop
                    }
                }
            }
        }


        //for Key
        onWheelRightKeyPressed: {
            if(ListView.view.flicking || ListView.view.moving)   return;

            ListView.view.moveOnPageByPage(rowPerPage, true);

//            if(ListView.view.currentIndex < ListView.view.count-1)
//            {
//                ListView.view.incrementCurrentIndex();
//            }else
//            {
//                ListView.view.positionViewAtIndex(0, ListView.Visible);
//                ListView.view.currentIndex = 0;
//            }
        }
        onWheelLeftKeyPressed: {
            if(ListView.view.flicking || ListView.view.moving)   return;

            ListView.view.moveOnPageByPage(rowPerPage, false);
//            if(ListView.view.currentIndex > 0)
//            {
//                ListView.view.decrementCurrentIndex();
//            }else
//            {
//                ListView.view.positionViewAtIndex(ListView.view.count-1, ListView.Visible);
//                ListView.view.currentIndex = ListView.view.count-1;
//            }
        }
    }
}
