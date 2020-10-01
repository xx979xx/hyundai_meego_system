import Qt 4.7
import QtQuick 1.1

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../../../component/XMData/Javascript/WeatherForecast.js" as MJavascript
import "../../../component/XMData/Javascript/ConvertUnit.js" as MConvertUnit

Item {

    property alias titleText: idTitleText.text

    property int weatherEvent : -999
    property int temperature : -999
    property int rain : -999
    property int wind : -999
    property int windDirection : -999
    property int temperatureHigh : -999
    property int temperatureLow : -999
    property int humidityRangeHigh : -999
    property int humidityRangeLow : -999
    property int cloudCover: -999
    property int weatherEventDescription: -999
    property int timestamp: 0
    property bool summerTime: false
    property bool timeFormat: false

    property int isWeatherEvValid: -1
    property int isHumidityValid: -1
    property int isPrecipitationValid: -1
    property int isTemperatureValid: -1
    property int isWindValid: -1

    property bool distanceUnitChange: interfaceManager.DBIsMileDistanceUnit//0: km, 1: mile

//    property bool isVaildTodayFc: false
//    property bool isTodayView: false

//    property bool checkTodayData: isVaildTodayFc
//    property bool checkTodayView: false

//    property bool checkTodayTimer: false

//    property int countNum: 1
//    property int countMax: 16

//    onIsVaildTodayFcChanged: {
//        checkTodayData = isVaildTodayFc;
//    }

//    onIsTodayViewChanged: {
//        checkTodayView = isTodayView;
//    }

    // Image for Left Background
    Image {
        visible: false
        width : 680
        source: imageInfo.imgFolderXMData + "bg_forecast_bg_01.png"
    }

    // Label for Title
    Item {
        visible: false
        x:16+28+39; y:32
        width: 520
        MComp.Label {
            id: idTitleText
            text: ""
            txtAlign: "Center"
            fontName: systemInfo.font_NewHDR
            fontSize: 34
            fontColor: colorInfo.brightGrey
        }
    }

    Item {
        visible: true
        id : idBody

        // Image for Weather
        Image {
            id: idEventImage;
            x: 0; y: 166-systemInfo.statusBarHeight;
            source: isWeatherEvValid != -1 ? MJavascript.getImagePath(weatherEvent) : MJavascript.getImagePath(0)
            visible: isWeatherEvValid != -1
        }

        Image{
            id: idSubLoadingImageForToday
            x: idEventImage.x + 318/2 - 38; y: idEventImage.y + 318/2 - 35

            anchors.fill: idEventImage.Center
            source : countNum > 9 ? imageInfo.imgFolderPopup+"loading/loading_"+ countNum +".png" : imageInfo.imgFolderPopup+"loading/loading_0"+ countNum +".png"
            visible: idEventImage.visible == false

            property int countNum: 1
            property int countMax: 16

            SequentialAnimation{
                running: idSubLoadingImageForToday.visible
                loops: Animation.Infinite
                PauseAnimation { duration: 100 }
                ScriptAction{script:{idSubLoadingImageForToday.countNum = idSubLoadingImageForToday.countNum + 1 >= 16 ? 1 : idSubLoadingImageForToday.countNum + 1;}}
            }
        }

        // Label for Updated Time
        Item {
            x: 262; y: (248-systemInfo.statusBarHeight)
            width: 56+174
            MComp.Label {
                id: idUpdatedText
                text: timestamp != 0 ? stringInfo.sSTR_XMDATA_WEATHER_UPDATED + " " + MConvertUnit.convertTimeFormat(timestamp,summerTime,timeFormat) : stringInfo.sSTR_XMDATA_WEATHER_UPDATED + " " + "-"
//                text: timestamp != 0 ? stringInfo.sSTR_XMDATA_WEATHER_UPDATED + " " + MConvertUnit.convertTimeFormat(timestamp,false,timeFormat) : stringInfo.sSTR_XMDATA_WEATHER_UPDATED + " " + "-"
                txtAlign: "Right"
                fontName: systemInfo.font_NewHDR
                fontSize: 24
                fontColor: colorInfo.dimmedGrey
            }
        }

        // Label for Current Temperature
        Item {
            Item {
                x: 262+56; y: (248-systemInfo.statusBarHeight)+65
                width: 174
                MComp.Label {
                    id: idTemperatureText
                    text: isTemperatureValid != -1 ? temperature == 128 ? "-" : MJavascript.getTemperature(temperature, 0) : "-"
                    txtAlign: "Right"
                    fontName: systemInfo.font_NewHDR
                    fontSize: distanceUnitChange ? 80 : 73
                    fontColor: colorInfo.brightGrey
                }
            }
        }

        // Label for Weather - more 2 Line
        Text{
            id: txtTitle
            x: 262+56
            y: (248-systemInfo.statusBarHeight)+65+72-36
            width: 174
            height: 32*3+4
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignRight
            text: isWeatherEvValid != -1 ? MJavascript.getWeatherEventDescription(weatherEventDescription) : "-"
            property bool pendingScaleUpdate: false

            Text{
                x: txtTitle.x; y:txtTitle.y ;
                width: txtTitle.width; height: txtTitle.width
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 40
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignRight
                text: txtTitle.text
                visible: false;
                property bool pendingScaleUpdate: false
                onTextChanged: {
                    scaleText();
                }
                onPaintedWidthChanged: {
                    if(pendingScaleUpdate) {
                        scaleText();
                    }
                }
                function scaleText() {
                    if (paintedWidth == -1) {
                        pendingScaleUpdate = true;
                    } else {
                        pendingScaleUpdate = false;

                        if(paintedWidth > txtTitle.width)
                        {
                            if(text.match("Thunderstorms"))
                                txtTitle.font.pixelSize = 28;
                            else
                                txtTitle.font.pixelSize = 32;

                            txtTitle.color = colorInfo.brightGrey
                            txtTitle.y = 42+212;
                            txtTitle.verticalAlignment = Text.AlignTop
                            txtTitle.wrapMode = Text.WordWrap;
                            txtTitle.lineHeight = 0.7;
                        }else
                        {
                            if(text.match("Thunderstorms"))
                                txtTitle.font.pixelSize = 38;
                            else
                                txtTitle.font.pixelSize = 40;

                            txtTitle.color = colorInfo.brightGrey
                            txtTitle.y = 42+212;
                            txtTitle.verticalAlignment= Text.AlignTop
                            txtTitle.wrapMode = Text.NoWrap;
                        }
                    }
                }
            }
        }

        // Label for Rain
        Item {
            Image {
                id: idRainyChanceImage;
                x: 62 - 30; y: (463-systemInfo.statusBarHeight)
                width: 47; height: 47
                source: imageInfo.imgFolderXMData + "ico_waether_precipitation.png"
            }

            Item {
                x: 62+79 - 43; y: (463-systemInfo.statusBarHeight)+23
                width: 200
                MComp.Label {
                    id: idRainText
                    text: isPrecipitationValid != -1 ? rain == 101 ? "-" : rain + "%" : "-"
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 30
                    fontColor: colorInfo.brightGrey
                }
            }
        }

        // Label for Humidity
        Item {
            Image {
                id: idHumidityImage;
                x: 62 - 30; y: (463-systemInfo.statusBarHeight)+23+33
                width: 47; height: 47
                source: imageInfo.imgFolderXMData + "ico_waether_humidity.png"
            }

            Item {
                x: 62+79 - 43; y: (463-systemInfo.statusBarHeight)+23+33+23
                width: 174
                MComp.Label {
                    id: idHumidityValueText
                    text: isHumidityValid != -1 ? MJavascript.getHumidityRangeValue(humidityRangeLow, humidityRangeHigh) : "-"//[NAQC 4th Day - issue no.23
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 30
                    fontColor: colorInfo.brightGrey
                }
            }
        }

        // Label for Wind
        Item {
            Image {
                id: idWindImage;
                x: 62 - 30; y: (463-systemInfo.statusBarHeight)+23+33+23+33
                width: 47; height: 47
                source: imageInfo.imgFolderXMData + "ico_waether_wind.png"
            }

            Item {
                x: 62+79 - 43; y: (463-systemInfo.statusBarHeight)+23+33+23+33+23
                width: 174
                MComp.Label {
                    id: idWindValueText
                    text: isWindValid != -1 ? wind > 255 ? "-" : MJavascript.getWindDirection(wind, windDirection) : "-"
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 30
                    fontColor: colorInfo.brightGrey
                }
            }
        }

        // Label for Cloud Cover
        Item {
            Image {
                id: idCloudCoverImage;
                x: 62 - 30; y: (463-systemInfo.statusBarHeight)+23+33+23+33+23+33
                width: 47; height: 47
                source: imageInfo.imgFolderXMData + "ico_waether_cloud.png"
            }

            Item {
                x: 62+79 - 43; y: (463-systemInfo.statusBarHeight)+23+33+23+33+23+33+23
                width: 174
                MComp.Label {
                    id: idCloudCoverValueText
                    text: MJavascript.getCloudCoverStatusText(cloudCover)
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 30
                    fontColor: colorInfo.brightGrey
                }
            }
        }
    }
}
