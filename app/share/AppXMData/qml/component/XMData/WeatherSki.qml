import Qt 4.7
import QtQuick 1.1

// System Import
import "../QML/DH" as MComp
// Local Import
import "./WeatherForecast" as MForecast
import "../../component/XMData/Javascript/WeatherForecast.js" as MJavascript
import "../../component/XMData/Javascript/ConvertUnit.js" as MConvertUnit

// Because Loader is a focus scope, converted from FocusScope to Item.
Item {
    focus: false

    property int weatherEvent               : SkiResortInfo.wWEvent
    property int temperature                : SkiResortInfo.wTempCurrent
    property int temperatureLow             : SkiResortInfo.wTempLow
    property int temperatureHigh            : SkiResortInfo.wTempHigh
    property int windCond                   : SkiResortInfo.wWindCond
    property int snowCond                   : SkiResortInfo.wSnowCond
    property int snowCondMaxBaseDepth       : SkiResortInfo.wSnowCondMaxBaseDepth
    property int snowCondMinBaseDepth       : SkiResortInfo.wSnowCondMinBaseDepth
    property int newSnowRangeLow            : SkiResortInfo.wNewSnowRangeLow
    property int newSnowRangeHigh           : SkiResortInfo.wNewSnowRangeHigh
    property int operationalStatus          : SkiResortInfo.wOperationalStatus
    property int numOfLifts                 : SkiResortInfo.wNumOfLifts
    property int numOfTrailsRangeLow        : SkiResortInfo.wNumOfTrailsRangeLow
    property int numOfTrailsRangeHigh       : SkiResortInfo.wNumOfTrailsRangeHigh
    property int snowMaking                 : SkiResortInfo.wSnowMaking
    property int grooming                   : SkiResortInfo.wGrooming
    property int nightSkiing                : SkiResortInfo.wNightSkiing
    property int snowboarding               : SkiResortInfo.wSnowboarding
    property int timeStamp                  : SkiResortInfo.wTimeStamp
    property bool summerTime                : interfaceManager.DBIsDayLightSaving
    property bool timeFormat                : interfaceManager.DBIs24TimeFormat
    property int isWeatherEvValid           : SkiResortInfo.wSkiWeatherEventDataVaild
    property int isWeatherAttrValid         : SkiResortInfo.wSkiWeatherAttrDataVaild
    property int isTemperatureValid         : SkiResortInfo.wSkiTemperatureDataVaild
    property int isSnowCondValid            : SkiResortInfo.wSkiSnowCondDataVaild
    property bool isSkiDataValid            : SkiResortInfo.wSkiDataValid == -1 ? false : true

    property bool distanceUnitChange: interfaceManager.DBIsMileDistanceUnit//0: km, 1: mile

//    property bool isSkiVisible: false

//    property bool checkSkiData: isSkiDataValid
//    property bool checkSkiView: false

//    property bool isFinishTimerForSki: idVisualCueTimerForSki.running

//    property int countNum: 1
//    property int countMax: 16

    //run timer when enter ski view
//    onVisibleChanged: {
//        console.log("==========[WeatherSki.qml][onVisibleChanged]isSkiDataValid = "+isSkiDataValid);
//        if(visible == true)
//        {
//            if(!isSkiDataValid)
//            {
//                idVisualCueTimerForSki.running = true;
//            }
//            else
//            {
//                idVisualCueTimerForSki.stop();
//            }
//        }
//        else
//        {
//            idVisualCueTimerForSki.stop();
//        }
//    }

//    onIsFinishTimerForSkiChanged: {
//        console.log("==========[JWPARK TEST]onIsFinishTimerForSkiChanged ====> isFinishTimerForSki = " + isFinishTimerForSki);

//        if(idVisualCueTimerForSki == false)
//        {
//            console.log("==========[JWPARK TEST]idVisualCueTimerForSki start!!!");
//            idVisualCueTimerForSki.running = true;
//        }
//    }

//    onIsSkiDataValidChanged: {
//        checkSkiData = isSkiDataValid;

//        if(checkSkiData == true)
//        {
//            if(idVisualCueTimerForSki.running == true)
//                idVisualCueTimerForSki.running = false

//            if(idWeatherLoadingFinishPopUp.visible == true)
//            {
//                idWeatherLoadingFinishPopUp.visible = false;
//                idWeatherLoadingFinishPopUp.focus = false;
//                idMenuBar.contentItem.KeyNavigation.up.forceActiveFocus();
//            }
//        }
//    }

//    onIsSkiVisibleChanged: {
//        checkSkiView = isSkiVisible;
//    }

    Item {
        visible: true
        id : idBody

        // Label for Weather
        Item {
            x:16+28; y:32+36+173
            width: 39+27+222+39
            MComp.Label {
                id: idWeatherLabel
                txtAlign: "Center"
                fontName: systemInfo.font_NewHDR
                fontSize: 26
                fontColor: colorInfo.brightGrey
            }
        }

        // Image for Weather
        Image {
            id: idEventImage;
            x: 0; y: 70
            source: isWeatherEvValid != -1 ? MJavascript.getImagePathForSki(weatherEvent) : MJavascript.getImagePathForSki(0)
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


//            Image{
//                id: idSubLoadingImageForSki
//                x: 318/2 - 38; y: 318/2 - 35
//                width: 76; height: 76
//                source: countNum > 9 ? imageInfo.imgFolderPopup+"loading/loading_"+ countNum +".png" : imageInfo.imgFolderPopup+"loading/loading_0"+ countNum +".png"
//                visible: checkSkiData == false && isSkiVisible == true

//                Timer{
//                    id: idSubLoadingImageForSkiTimer
//                    interval: 100;
//                    repeat: true
//                    running: idSubLoadingImageForSki.visible
//                    onTriggered: {
//                        if(countNum == countMax) countNum = 1
//                        countNum++;
//                    }
//                }

//                onSourceChanged: {
//                    if(idSubLoadingImageForSki.visible == true)
//                        idVisualCueTimerForSki.running = true;
//                }
//            }
//        }

//        Timer {
//            id:idVisualCueTimerForSki;
//            interval: 30000;
//            running: false;
//            repeat: false;
//            onTriggered: {
//                idVisualCueTimerForSki.running = false;
//                idSubLoadingImageForSki.visible = false;
//                idWeatherLoadingFinishPopUp.show();
//            }
//        }

        // Label for Updated Time
        Item {
            x: 262+13; y: (248-systemInfo.statusBarHeight)
            width: 56+174
            MComp.Label {
                id: idUpdatedText
//                text: timeStamp != 0 ? stringInfo.sSTR_XMDATA_WEATHER_UPDATED + " " + MConvertUnit.convertTimeFormat(timeStamp,summerTime,timeFormat) : stringInfo.sSTR_XMDATA_WEATHER_UPDATED + " " + "-"
                text: timeStamp != 0 ? stringInfo.sSTR_XMDATA_WEATHER_UPDATED + " " + MConvertUnit.convertTimeFormat(timeStamp,false,timeFormat) : stringInfo.sSTR_XMDATA_WEATHER_UPDATED + " " + "-"
                txtAlign: "Right"
                fontName: systemInfo.font_NewHDR
                fontSize: 24
                fontColor: colorInfo.dimmedGrey
            }
        }

        // Label for Current Temperature
        Item {
            Item {
                x: 318+13; y: 147+70
                width: 175
                MComp.Label {
                    id: idTemperatureText
                    text: isTemperatureValid != -1 ? MJavascript.getTemperature(temperature, 0) : "-"
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
            x: 262+56+13
            y: (248-systemInfo.statusBarHeight)+65+72
            width: 174
            height: 32*3+4
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignRight
            text: isWeatherEvValid != -1 ? MJavascript.getWeatherEventDescription(weatherEvent) : "-"
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

        // Label for Wind Conditon
        Item {
            Item{
                Image {
                    x: 62-30; y: (463-systemInfo.statusBarHeight)
                    width: 47; height: 47
                    visible: true
                    source: imageInfo.imgFolderXMData + "ico_waether_windy.png"
                }
            }

            Item {
                x: 62 + 69 - 43; y: (463-systemInfo.statusBarHeight)+23
                width: 131
                MComp.Label {
                    id: idWindText
                    text: stringInfo.sSTR_XMDATA_SKIWINDCOND
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 24
                    fontColor: colorInfo.brightGrey
                }
            }

            Item {
                x: 62 + 69 + 131 - 18; y: (463-systemInfo.statusBarHeight)+23
                width: 210
                MComp.Label {
                    id: idWindConditionText
                    text: MJavascript.getWindConditionText(windCond)
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 24
                    fontColor: colorInfo.brightGrey
                }
            }
        }

        // Label for Snow Condition
        Item {
            Item{
                Image {
                    x: 62 - 30; y: (463-systemInfo.statusBarHeight)+23+33
                    width: 47; height: 47
                    visible: true
                    source: imageInfo.imgFolderXMData + "ico_waether_snow.png"
                }
            }

            Item {
                x: 62 + 69 - 43; y: (463-systemInfo.statusBarHeight)+23+33+23
                width: 131
                MComp.Label {
                    id: idSnowText
                    text:stringInfo.sSTR_XMDATA_SKISHOWCOND
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 24
                    fontColor: colorInfo.brightGrey
                }
            }

            Item {
                x: 62 + 69 + 131 - 18; y: (463-systemInfo.statusBarHeight)+23+33+23
                width: 210
                MComp.Label {
                    id: idSnowConditonText
                    text: isSnowCondValid != -1 ? MJavascript.getSnowConditionText(snowCond) : "-"
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 24
                    fontColor: colorInfo.brightGrey
                }
            }
        }

        // Label for Snow Condtion Base Depth
        Item {
            Item{
                Image {
                    x: 62 - 30; y: (463-systemInfo.statusBarHeight)+23+33+23+33
                    width: 47; height: 47
                    visible: true
                    source: imageInfo.imgFolderXMData + "ico_waether_snow.png"
                }
            }

            Item {
                x: 62 + 69 - 43; y: (463-systemInfo.statusBarHeight)+23+33+23+33+23
                width: 131
                MComp.Label {
                    id: idBaseText
                    text: stringInfo.sSTR_XMDATA_SKIBASEDEPTH
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 24
                    fontColor: colorInfo.brightGrey
                }
            }

            Item {
                x: 62 + 69 + 131 - 18; y: (463-systemInfo.statusBarHeight)+23+33+23+33+23
                width: 210
                MComp.Label {
                    id: idBaseDepthText
                    text: isSnowCondValid != -1 ? MJavascript.getBaseDepthValue(snowCondMinBaseDepth, snowCondMaxBaseDepth) : "-";
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 24
                    fontColor: colorInfo.brightGrey
                }
            }
        }

        // Label for New Snow
        Item {
            Item{
                Image {
                    x: 62 - 30; y: (463-systemInfo.statusBarHeight)+23+33+23+33+23+33
                    width: 47; height: 47
                    visible: true
                    source: imageInfo.imgFolderXMData + "ico_waether_snow.png"
                }
            }

            Item {
                x: 62 + 69 - 43; y: (463-systemInfo.statusBarHeight)+23+33+23+33+23+33+23
                width: 131
                MComp.Label {
                    id: idNewSnowText
                    text: stringInfo.sSTR_XMDATA_SKINEWSNOW
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 24
                    fontColor: colorInfo.brightGrey
                }
            }

            Item {
                x:62 + 69 + 131 - 18; y: (463-systemInfo.statusBarHeight)+23+33+23+33+23+33+23
                width: 210
                MComp.Label {
                    id: idNewSnowValueText
                    text: isSnowCondValid != -1 ? MJavascript.getNewSnowRangeValue(newSnowRangeLow, newSnowRangeHigh) : "-";
                    txtAlign: "Left"
                    fontName: systemInfo.font_NewHDR
                    fontSize: 24
                    fontColor: colorInfo.brightGrey
                }
            }
        }
    }

    // Image for Background
    Item {
        Image {
            visible: true
            x:538; y:90
            width: 722; height: 523
            source: imageInfo.imgFolderXMData + "bg_weather_local.png"
        }
    }

    Item {
        MComp.Label {
            id: idOperationText
            x: 538+42; y: 90+40
            text: stringInfo.sSTR_XMDATA_SKIOPERATIONSTATUS
            txtAlign: "Left"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.dimmedGrey
        }

        MComp.Label {
            id: idOperationStatusText
            x: 538+42+470+10+144; y: 90+40
            text: MJavascript.getOperatingStatusText(operationalStatus)
            txtAlign: "Right"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.brightGrey
        }

        MComp.Label {
            id: idNoOfLiftText
            x: 538+42; y: 90+40+73
            text: stringInfo.sSTR_XMDATA_SKINOOFLIFTOPER
            txtAlign: "Left"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.dimmedGrey
        }

        MComp.Label {
            id: idNoOfLiftoperText
            x: 538+42+470+10+144; y: 90+40+73
            text: isWeatherAttrValid != -1 ? numOfLifts > 230 ? "-" : numOfLifts : "-"
            txtAlign: "Right"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.brightGrey
        }

        MComp.Label {
            id: idNoOfTrailsText
            x: 538+42; y: 90+40+73+80
            text: stringInfo.sSTR_XMDATA_SKINOOFTRAILSOPEN
            txtAlign: "Left"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.dimmedGrey
        }

        MComp.Label {
            id: idNoOfTrailsOpenNoText
            x: 538+42+470+10+144; y: 90+40+73+80
            text: isWeatherAttrValid != -1 ? MJavascript.getNumOfTrailsRangeValue(numOfTrailsRangeLow, numOfTrailsRangeHigh) : "-";
            txtAlign: "Right"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.brightGrey
        }

        MComp.Label {
            id: idSnowMakingText
            x: 538+42; y: 90+40+73+80+73
            text: stringInfo.sSTR_XMDATA_SKISNOWMAKING
            txtAlign: "Left"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.dimmedGrey
        }

        MComp.Label {
            id: idSnowMakingValueText
            x: 538+42+470+10+144; y: 90+40+73+80+73
            text: isWeatherAttrValid != -1 ? MJavascript.getSkiStatusText(snowMaking) : "-"
            txtAlign: "Right"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.brightGrey
        }

        MComp.Label {
            id: idGroomingText
            x: 538+42; y: 90+40+73+80+73+73
            text: stringInfo.sSTR_XMDATA_SKIGROMMING
            txtAlign: "Left"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.dimmedGrey
        }

        MComp.Label {
            id: idGroomingValueText
            x: 538+42+470+10+144; y: 90+40+73+80+73+73
            text: isWeatherAttrValid != -1 ? MJavascript.getSkiStatusText(grooming) : "-"
            txtAlign: "Right"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.brightGrey
        }

        MComp.Label {
            id: idNightSkingText
            x: 538+42; y: 90+40+73+80+73+73+73
            text: stringInfo.sSTR_XMDATA_SKINIGHTSKING
            txtAlign: "Left"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.dimmedGrey
        }

        MComp.Label {
            id: idNightSkingValueText
            x: 538+42+470+10+144; y: 90+40+73+80+73+73+73
            text: isWeatherAttrValid != -1 ? MJavascript.getSkiStatusText(nightSkiing) : "-"
            txtAlign: "Right"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.brightGrey
        }

        MComp.Label {
            id: idSnowboardingText
            x: 538+42; y: 90+40+73+80+73+73+73+73
            text: stringInfo.sSTR_XMDATA_SKISNOWBOARDING
            txtAlign: "Left"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.dimmedGrey
        }

        MComp.Label {
            id: idSnowboardingValueText
            x: 538+42+470+10+144; y: 90+40+73+80+73+73+73+73
            text: isWeatherAttrValid != -1 ? MJavascript.getSkiStatusText(snowboarding) : "-"
            txtAlign: "Right"
            fontName: systemInfo.font_NewHDR
            fontSize: 28
            fontColor: colorInfo.brightGrey
        }
    }
}
