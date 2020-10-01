import Qt 4.7
import QtQuick 1.1

// System Import
import "../../QML/DH" as MComp
import "../../../component/XMData/Javascript/WeatherForecast.js" as MJavascript
import "../../XMData" as MXData

Item {
    id : idComponent

    property alias titleText: idTitleText.text

    property int weatherEvent : -999
    property int temperature : -999
    property int rain : -999
    property int wind : -999
    property int windDirection : -999
    property int temperatureHigh : -999
    property int temperatureLow : -999
    property int weatherEventDescription: -999
    property int isValidData: -1
    property int isWeatherEvValid: -1
    property int isHumidityValid: -1
    property int isPrecipitationValid: -1
    property int isTemperatureValid: -1
    property int isWindValid: -1

    property bool distanceUnitChange: interfaceManager.DBIsMileDistanceUnit//0: km, 1: mile

//    property bool isVaildTodayExFc: false
//    property bool isTodayViewEx: false

//    property bool checkTodayExData: isVaildTodayExFc
//    property bool checkTodayExView: false

//    property bool checkTodayExTimer: false

//    property int countNum: 1
//    property int countMax: 16

//    onIsVaildTodayExFcChanged: {
//        checkTodayExData = isVaildTodayExFc;
//    }

//    onIsTodayViewExChanged: {
//        checkTodayExView = isTodayViewEx;
//    }

    // Image for Left Background
    Image {
        source: imageInfo.imgFolderXMData + "bg_weather_time.png"
    }

    // Label for Title
    Item {
        x:21; y:42
        width: 310
        MComp.Label {
            id: idTitleText
            text: ""
            txtAlign: "Center"
            fontName: systemInfo.font_NewHDR
            fontSize: 40
            fontColor: colorInfo.grey
        }
    }

    // Image for Weather
    Image {
        id: idEventImage
        x:56; y:66;
        width: 240; height: 240
        source: isWeatherEvValid != -1 ? MJavascript.getMediumImagePath(weatherEvent) : MJavascript.getMediumImagePath(0)
        visible: isWeatherEvValid != -1
    }

    Image{
        id: idSubLoadingImageForToday
        x: idEventImage.x + 240/2 - 38; y: idEventImage.y + 240/2 - 35

        anchors.centerIn: idEventImage.Center
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

    Item {
        visible: true
        id : idBody

        // Label for Weather - more 2 Line
        Text{
            id: txtTitle
            x: 21
            y: 42+212//42+231+20
            width: 310
            height: 32*3+4
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            text: isWeatherEvValid != -1 ? MJavascript.getWeatherEventDescription(weatherEvent) : "-"

            Text{
                x: txtTitle.x; y:txtTitle.y ;
                width: txtTitle.width; height: txtTitle.width
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 40
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
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
                                txtTitle.font.pixelSize = 30;

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

        // Label for Temperature
        Text {
            id: idTemperatureText
            x:21; y: 42+253+40
            width: 310
            height: 32*3+4
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            text: isTemperatureValid != -1 ? temperature == 128 ? "-" : MJavascript.getTemperatureEx(temperature, 0) + MJavascript.getFarenheit() : "-"
        }

        // Label for Rain
        Item {
            // Image for Rain Chance Value
            Image {
                id: idRainyChanceValueImage
                x:94; y:42+231+74+72
                width: 82; height: 82
                source: imageInfo.imgFolderXMData + "ico_waether_precipitation_l.png"
            }

            // Label for Rain Chance Value
            Item {
                x:94+90; y:42+231+74+72+46
                width: 65
                MComp.Label {
                    id: idRainyChanceValueText
                    text: isPrecipitationValid != -1 ? rain == 101 ? "-" : rain + "%" : "-"
                    txtAlign: "Center"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 30
                    fontColor: colorInfo.brightGrey
                }
            }
        }
    }
}
