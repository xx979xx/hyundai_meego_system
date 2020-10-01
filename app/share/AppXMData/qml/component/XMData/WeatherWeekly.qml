import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./WeatherForecast" as MForecast

// Because Loader is a focus scope, converted from FocusScope to Item.
Item {

    property int fcDay1Change: ForecastDay1.wDay
    property int fcDay2Change: ForecastDay2.wDay
    property int fcDay3Change: ForecastDay3.wDay
    property int fcDay4Change: ForecastDay4.wDay
    property int fcDay5Change: ForecastDay5.wDay

    property int fcWeek1Change: ForecastDay1.wWeek
    property int fcWeek2Change: ForecastDay2.wWeek
    property int fcWeek3Change: ForecastDay3.wWeek
    property int fcWeek4Change: ForecastDay4.wWeek
    property int fcWeek5Change: ForecastDay5.wWeek

    onFcDay1ChangeChanged: {
        idDay1.titleText = ForecastDay1.wDay == -999 ? "-" : ForecastDay1.wDay;
    }
    onFcDay2ChangeChanged: {
        idDay2.titleText = ForecastDay2.wDay == -999 ? "-" : ForecastDay2.wDay;
    }
    onFcDay3ChangeChanged: {
        idDay3.titleText = ForecastDay3.wDay == -999 ? "-" : ForecastDay3.wDay;
    }
    onFcDay4ChangeChanged: {
        idDay4.titleText = ForecastDay4.wDay == -999 ? "-" : ForecastDay4.wDay;
    }
    onFcDay5ChangeChanged: {
        idDay5.titleText = ForecastDay5.wDay == -999 ? "-" : ForecastDay5.wDay;
    }

    onFcWeek1ChangeChanged: {
        idDay1.titleText01 = ForecastDay1.wWeek == -999 ? "-" : getWeekStr(ForecastDay1.wWeek);
    }
    onFcWeek2ChangeChanged: {
        idDay2.titleText01 = ForecastDay2.wWeek == -999 ? "-" : getWeekStr(ForecastDay2.wWeek);
    }
    onFcWeek3ChangeChanged: {
        idDay3.titleText01 = ForecastDay3.wWeek == -999 ? "-" : getWeekStr(ForecastDay3.wWeek);
    }
    onFcWeek4ChangeChanged: {
        idDay4.titleText01 = ForecastDay4.wWeek == -999 ? "-" : getWeekStr(ForecastDay4.wWeek);
    }
    onFcWeek5ChangeChanged: {
        idDay5.titleText01 = ForecastDay5.wWeek == -999 ? "-" : getWeekStr(ForecastDay5.wWeek);
    }

    focus: false

    // Image for Bottom
    Image {
        visible: false
        x:0; y:627
        source: imageInfo.imgFolderBt_phone + "bg_bottom_device.png"
    }

    MForecast.WeatherForecastWeeklyItem {
        id: idDay1;
        x:21; y:90;
        titleText: "";
        titleText01: "";
        weatherEvent : ForecastDay1.wWEvent
        temperatureHigh : ForecastDay1.wTempHigh
        temperatureLow : ForecastDay1.wTempLow
        rain : ForecastDay1.wPrecipitation
        isStartDay : true;
        weatherEventDescription: ForecastDay1.wWEvent
        isWeatherEvValid: ForecastDay1.wWeatherDataValid
        isPrecipitationValid: ForecastDay1.wPrecipitationDataValid
        isTemperatureValid: ForecastDay1.wTemperatureDataValid
    }

    MForecast.WeatherForecastWeeklyItem {
        id: idDay2;
        x:idDay1.x + idDay1.width + 21; y:idDay1.y;
        titleText: "";
        titleText01: "";
        weatherEvent : ForecastDay2.wWEvent
        temperatureHigh : ForecastDay2.wTempHigh
        temperatureLow : ForecastDay2.wTempLow
        rain : ForecastDay2.wPrecipitation
        isStartDay : false;
        weatherEventDescription: ForecastDay2.wWEvent
        isWeatherEvValid: ForecastDay2.wWeatherDataValid
        isPrecipitationValid: ForecastDay2.wPrecipitationDataValid
        isTemperatureValid: ForecastDay2.wTemperatureDataValid
    }

    MForecast.WeatherForecastWeeklyItem {
        id: idDay3;
        x:idDay2.x + idDay2.width + 21; y:idDay1.y;
        titleText: "";
        titleText01: "";
        weatherEvent : ForecastDay3.wWEvent
        temperatureHigh : ForecastDay3.wTempHigh
        temperatureLow : ForecastDay3.wTempLow
        rain : ForecastDay3.wPrecipitation
        isStartDay : false;
        weatherEventDescription: ForecastDay3.wWEvent
        isWeatherEvValid: ForecastDay3.wWeatherDataValid
        isPrecipitationValid: ForecastDay3.wPrecipitationDataValid
        isTemperatureValid: ForecastDay3.wTemperatureDataValid
    }

    MForecast.WeatherForecastWeeklyItem {
        id: idDay4;
        x:idDay3.x + idDay3.width + 21; y:idDay1.y;
        titleText: "";
        titleText01: "";
        weatherEvent : ForecastDay4.wWEvent
        temperatureHigh : ForecastDay4.wTempHigh
        temperatureLow : ForecastDay4.wTempLow
        rain : ForecastDay4.wPrecipitation
        isStartDay : false;
        weatherEventDescription: ForecastDay4.wWEvent
        isWeatherEvValid: ForecastDay4.wWeatherDataValid
        isPrecipitationValid: ForecastDay4.wPrecipitationDataValid
        isTemperatureValid: ForecastDay4.wTemperatureDataValid
    }


    MForecast.WeatherForecastWeeklyItem {
        id: idDay5;
        x:idDay4.x + idDay4.width + 21; y:idDay1.y;
        titleText: "";
        titleText01: "";
        weatherEvent : ForecastDay5.wWEvent
        temperatureHigh : ForecastDay5.wTempHigh
        temperatureLow : ForecastDay5.wTempLow
        rain : ForecastDay5.wPrecipitation
        isStartDay : false;
        weatherEventDescription: ForecastDay5.wWEvent
        isWeatherEvValid: ForecastDay5.wWeatherDataValid
        isPrecipitationValid: ForecastDay5.wPrecipitationDataValid
        isTemperatureValid: ForecastDay5.wTemperatureDataValid
    }

    function getWeekStr(week)
    {
        switch(week)
        {
        case 1: return stringInfo.sSTR_XMDATA_MON;
        case 2: return stringInfo.sSTR_XMDATA_TUE;
        case 3: return stringInfo.sSTR_XMDATA_WED;
        case 4: return stringInfo.sSTR_XMDATA_THU;
        case 5: return stringInfo.sSTR_XMDATA_FRI;
        case 6: return stringInfo.sSTR_XMDATA_SAT;
        case 7: return stringInfo.sSTR_XMDATA_SUN;
        case -999: return "none";
        default : return "";
        }
    }
}
