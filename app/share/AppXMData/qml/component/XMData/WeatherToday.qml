import Qt 4.7

import "../QML/DH" as MComp
import "./WeatherForecast" as MForecast

// Because Loader is a focus scope, converted from FocusScope to Item.
Item {
    focus: false

    // Item for Current weather informaion
    MForecast.WeatherForecastLargeItem {
        id: idLargeItem;
        x:0; y:0
        titleText: stringInfo.sSTR_XMDATA_TODAY;
        weatherEvent : Forecast0.wWEvent
        temperature : Forecast0.wTempCurrent
        rain : Forecast0.wPrecipitation
        wind : Forecast0.wWindSpeed
        windDirection : Forecast0.wWindDirection
        humidityRangeHigh : Forecast0.wHumidityRangeHigh
        humidityRangeLow : Forecast0.wHumidityRangeLow
        cloudCover : Forecast0.wCloudCover
        weatherEventDescription: Forecast0.wWEvent
        timestamp : Forecast0.wTimeStamp
        summerTime: interfaceManager.DBIsDayLightSaving
        timeFormat: interfaceManager.DBIs24TimeFormat
        isWeatherEvValid: Forecast0.wWeatherDataValid
        isHumidityValid: Forecast0.wHumidityDataValid
        isPrecipitationValid: Forecast0.wPrecipitationDataValid
        isTemperatureValid: Forecast0.wTemperatureDataValid
        isWindValid: Forecast0.wWindDataValid
    }

    MForecast.WeatherForecastSmallItem {
        id: id3HrsItem;
        x:538; y:181-systemInfo.statusBarHeight
        width: 352
        titleText: stringInfo.sSTR_XMDATA_3HRS;
        weatherEvent : Forecast03.wWEvent
        temperature : Forecast03.wTempCurrent
        rain : Forecast03.wPrecipitation
        weatherEventDescription: Forecast03.wWEvent
        isWeatherEvValid: Forecast03.wWeatherDataValid
        isHumidityValid: Forecast03.wHumidityDataValid
        isPrecipitationValid: Forecast03.wPrecipitationDataValid
        isTemperatureValid: Forecast03.wTemperatureDataValid
        isWindValid: Forecast03.wWindDataValid
    }

    MForecast.WeatherForecastSmallItem {
        id: id6HrsItem;
        x:538+370; y:181-systemInfo.statusBarHeight
        width: 352
        titleText: stringInfo.sSTR_XMDATA_6HRS;
        weatherEvent : Forecast36.wWEvent
        temperature : Forecast36.wTempCurrent
        rain : Forecast36.wPrecipitation
        weatherEventDescription: Forecast36.wWEvent
        isWeatherEvValid: Forecast36.wWeatherDataValid
        isHumidityValid: Forecast36.wHumidityDataValid
        isPrecipitationValid: Forecast36.wPrecipitationDataValid
        isTemperatureValid: Forecast36.wTemperatureDataValid
        isWindValid: Forecast36.wWindDataValid
    }
}
