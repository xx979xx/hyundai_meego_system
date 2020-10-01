import Qt 4.7
import QtQuick 1.1

// System Import
import "../../QML/DH" as MComp
import "../../../component/XMData/Javascript/WeatherForecast.js" as MJavascript

Item {
    id : idComponent
    width: 231

    property alias titleText: idTitleText.text
    property alias titleText01: idTitleText01.text

    property int weatherEvent : -999
    property int rain : -999
    property int temperatureHigh : -999
    property int temperatureLow : -999
    property int weatherEventDescription: -999
    property int isWeatherEvValid: -1
    property int isPrecipitationValid: -1
    property int isTemperatureValid: -1

    property bool isStartDay : false;
    property bool distanceUnitChange: interfaceManager.DBIsMileDistanceUnit//0: km, 1: mile


    function selectSource(checkStartDay) {
        if(checkStartDay)
            return imageInfo.imgFolderXMData + "bg_weather_week_s.png";
        else
            return imageInfo.imgFolderXMData + "bg_weather_week.png";
    }

    // Image for Left Background
    Image {
        source: selectSource(false);
        width: parent.width
    }

    // Label for Title
    Item {
        x:0; y:27
        width: parent.width
        MComp.Label {
            id: idTitleText
            text: ""
            txtAlign: "Center"
            fontName: systemInfo.font_NewHDR
            fontSize: 36
            fontColor: isStartDay ? colorInfo.bandBlue : colorInfo.grey
        }
    }

    Item {
        x:0; y:27+36
        width: parent.width
        MComp.Label {
            id: idTitleText01
            text: ""
            txtAlign: "Center"
            fontName: systemInfo.font_NewHDR
            fontSize: 32
            fontColor: isStartDay ? colorInfo.bandBlue : colorInfo.grey
        }
    }

    // Image for Weather
    Image {
        id: idEventImage;
        x:27+11; y:27+36+41;
        width: 155; height: 155
        source: isWeatherEvValid != -1 ? MJavascript.getSmallImagePath(weatherEvent) : MJavascript.getSmallImagePath(0)
        visible: isWeatherEvValid != -1
    }

    Image{
        id: idSubLoadingImageForToday
        x: idEventImage.x + 155/2 - 38; y: idEventImage.y + 155/2 - 35

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
        width: parent.width

        // Label for Temperature
        Item {
            visible: temperatureLow != -999 && temperatureHigh != -999

            // Label for Low Temperature
            Item {
                x:6+58+17; y: 27+36+41+176+81//27+36+41+184
                MComp.Label {
                    text: isTemperatureValid != -1 ? temperatureLow == 128 ? "-" : MJavascript.getTemperatureEx(temperatureLow, 0) : "-"
                    txtAlign: "Center"
                    fontName: systemInfo.font_NewHDR
                    fontSize: distanceUnitChange ? 34 : 28
                    fontColor: colorInfo.bandBlue
                }
            }

            // Image for Slash
            Image {
                x:6+58+17+26; y:27+36+41+(184-25)+81
                source: imageInfo.imgFolderXMData + "icon_slash.png"
            }

            // Label for High Temperature
            Item {
                x:6+58+17+26+47; y:27+36+41+176+81//27+36+41+184
                MComp.Label {
                    text: isTemperatureValid != -1 ? temperatureHigh == 128 ? "-" : MJavascript.getTemperatureEx(temperatureHigh, 0) : "-"
                    txtAlign: "Center"
                    fontName: systemInfo.font_NewHDR
                    fontSize: distanceUnitChange ? 34 : 28
                    fontColor: "#EB5C5C"
                }
            }
        }

        // Label for Rain
        Item {
            // Label for Weather - more 2 Line
            Text{
                id: txtTitle
                x: 27
                y: 27+36+41+148
                width: 176
                height: 32*3+4
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 28
                color: colorInfo.brightGrey
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                text: isWeatherEvValid != -1 ? MJavascript.getWeatherEventDescription(weatherEventDescription) : "-"
                property bool pendingScaleUpdate: false

                Text{
                    x: txtTitle.x; y:txtTitle.y ;
                    width: txtTitle.width; height: txtTitle.width
                    font.family: systemInfo.font_NewHDR
                    font.pixelSize: 28
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
                                    txtTitle.font.pixelSize = 20;
                                else
                                    txtTitle.font.pixelSize = 28;

                                txtTitle.color = colorInfo.brightGrey
                                txtTitle.y = 42+212;
                                txtTitle.verticalAlignment = Text.AlignTop
                                txtTitle.wrapMode = Text.WordWrap;
                                txtTitle.lineHeight = 0.7;
                            }else
                            {
                                if(text.match("Thunderstorms"))
                                    txtTitle.font.pixelSize = 20;
                                else
                                    txtTitle.font.pixelSize = 28;

                                txtTitle.color = colorInfo.brightGrey
                                txtTitle.y = 42+212;
                                txtTitle.verticalAlignment= Text.AlignTop
                                txtTitle.wrapMode = Text.NoWrap;
                            }
                        }
                    }
                }
            }

            // Image for Rain Chance Value
            Image {
                id: idRainyChanceValueImage
                x:39; y:419
                width: 82; height: 82
                source: imageInfo.imgFolderXMData + "ico_waether_precipitation_l.png"
            }

            Item {
                x:39+87; y:419+45
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
