
// Wind direction and speed function
function getWindDirection(speed, dir)
{
    switch(dir)
    {
        case 0:
        case 360:
            return      speed + " mph" + " (" + "N" +")";
        case 22: return     speed + " mph" + " (" + "NNE" +")";
        case 45: return     speed + " mph" + " (" + "NE" +")";
        case 67: return     speed + " mph" + " (" + "ENE" +")";
        case 90: return     speed + " mph" + " (" + "E" +")";
        case 112: return    speed + " mph" + " (" + "ESE" +")";
        case 135: return    speed + " mph" + " (" + "SE" +")";
        case 157: return    speed + " mph" + " (" + "SSE" +")";
        case 180: return    speed + " mph" + " (" + "S" +")";
        case 202: return    speed + " mph" + " (" + "SSW" +")";
        case 225: return    speed + " mph" + " (" + "SW" +")";
        case 247: return    speed + " mph" + " (" + "WSW" +")";
        case 270: return    speed + " mph" + " (" + "W" +")";
        case 292: return    speed + " mph" + " (" + "WNW" +")";
        case 315: return    speed + " mph" + " (" + "NW" +")";
        case 337: return    speed + " mph" + " (" + "NNW" +")";
        case 400: return     "";
        default: return     "";
    }
}

// Weather event image
function getImagePath(weatherEvent)
{
    console.log("weatherEvent for large image : " + weatherEvent);

    switch(weatherEvent)
    {
        case 0: return "";//No Data Available
        case 1: return "";//Unknown Precipitation
        case 2: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_84.png";//Isolated Thunderstorms(84)
        case 3: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_98.png";//Scattered Thunderstorms(98)
        case 4: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_84.png";//Scattered Thunderstorms(night)(84)
        case 5: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_84.png";//Severe Thunderstorms(84 or 108/109)
        case 6: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_84.png";//Thunderstorms(84)
        case 7: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_82.png";//Rain(82)
        case 8: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_87.png";//Light Rain(87)
        case 9: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_82.png";//Heavy Rain(82)
        case 10: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_87.png";//Scattered Showers(87)
        case 11: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_86.png";//Scattered Showers(night)(86)
        case 12: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_87.png";//Showers(87)
        case 13: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_76.png";//Drizzle(76)
        case 14: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_90.png";//Freezing Drizzle(90)
        case 15: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_89.png";//Freezing Rain(89)
        case 16: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_79.png";//Wintry Mix(79)
        case 17: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_79.png";//Mixed Rain And Snow(79)
        case 18: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_88.png";//Mixed Rain And Sleet(88)
        case 19: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_89.png";//Mixed Rain And Hail(89)
        case 20: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_110.png";//Hail(110)
        case 21: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_88.png";//Sleet(88)
        case 22: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_110.png";//Ice Pellets(110)
        case 23: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_77.png";//Flurries(77)
        case 24: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_74.png";//Light Snow(74)
        case 25: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_83.png";//Moderate Snow(83)
        case 26: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_83.png";//Snow(83)
        case 27: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_83.png";//Heavy Snow(83)
        case 28: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_74.png";//Scattered Snow Showers(74)
        case 29: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_96.png";//Scattered Snow Showers(night)(96)
        case 30: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_74.png";//Snow Showers(74)
        case 31: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_81.png";//Blowing Snow(81)
        case 32: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_80.png";//Blizzard(80)
        case 33: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_111.png";//Sandstorm(111)
        case 34: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_112.png";//Blowing Dust(112)
        case 35: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_68.png";//Dust(68)
        case 36: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_70.png";//Foggy(70)
        case 37: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_70.png";//Light Fog(70)
        case 38: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_70.png";//Moderate Fog(70)
        case 39: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_70.png";//Heavy Fog(70)
        case 40: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_95.png";//Mist(95)
        case 41: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_72.png";//Hazy(72 or 113)
        case 42: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_75.png";//Smoky(75 or  99)
        case 43: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_78.png";//Blustery(78)
        case 44: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_78.png";//Windy(78)
        case 45: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_73.png";//Cold(73)
        case 46: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_71.png";//Hot(71)
        case 47: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_85.png";//Sunny(85 or 100)
        case 48: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_66.png";//Mostly Sunny(66 or 106)
        case 49: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_101.png";//Clear (night)(101)
        case 50: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_107.png";//Mostly Clear (night)(107)
        case 51: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_66.png";//Partly cloudy(66 or 106)
        case 52: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_107.png";//Partly cloudy (night)(107)
        case 53: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_69.png";//Mostly cloudy(69 or 104)
        case 54: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_105.png";//Mostly cloudy (night)(105)
        case 55: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_67.png";//Cloudy(67 or 102)
        case 56: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_117.png";//Tropical Storm(117 or 118)
        case 57: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_115.png";//Hurricane(115 or 116)
        case 58: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_103.png";//Funnel Cloud(103)
        case 59: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_103.png";//Tornado(103)
        case 60: return "";
        case 61: return "";
        case 62: return "";
        case 63: return "";
        default: return "";
    }
}

function getMediumImagePath(weatherEvent)
{
    console.log("weatherEvent for medium image : " + weatherEvent);

    switch(weatherEvent)
    {
        case 0: return "";//No Data Available
        case 1: return "";//Unknown Precipitation
        case 2: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_84.png";//Isolated Thunderstorms(84)
        case 3: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_98.png";//Scattered Thunderstorms(98)
        case 4: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_84.png";//Scattered Thunderstorms(night)(84)
        case 5: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_84.png";//Severe Thunderstorms(84 or 108/109)
        case 6: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_84.png";//Thunderstorms(84)
        case 7: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_82.png";//Rain(82)
        case 8: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_87.png";//Light Rain(87)
        case 9: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_82.png";//Heavy Rain(82)
        case 10: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_87.png";//Scattered Showers(87)
        case 11: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_86.png";//Scattered Showers(night)(86)
        case 12: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_87.png";//Showers(87)
        case 13: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_76.png";//Drizzle(76)
        case 14: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_90.png";//Freezing Drizzle(90)
        case 15: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_89.png";//Freezing Rain(89)
        case 16: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_79.png";//Wintry Mix(79)
        case 17: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_79.png";//Mixed Rain And Snow(79)
        case 18: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_88.png";//Mixed Rain And Sleet(88)
        case 19: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_89.png";//Mixed Rain And Hail(89)
        case 20: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_110.png";//Hail(110)
        case 21: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_88.png";//Sleet(88)
        case 22: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_110.png";//Ice Pellets(110)
        case 23: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_77.png";//Flurries(77)
        case 24: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_74.png";//Light Snow(74)
        case 25: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_83.png";//Moderate Snow(83)
        case 26: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_83.png";//Snow(83)
        case 27: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_83.png";//Heavy Snow(83)
        case 28: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_74.png";//Scattered Snow Showers(74)
        case 29: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_96.png";//Scattered Snow Showers(night)(96)
        case 30: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_74.png";//Snow Showers(74)
        case 31: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_81.png";//Blowing Snow(81)
        case 32: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_80.png";//Blizzard(80)
        case 33: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_111.png";//Sandstorm(111)
        case 34: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_112.png";//Blowing Dust(112)
        case 35: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_68.png";//Dust(68)
        case 36: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_70.png";//Foggy(70)
        case 37: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_70.png";//Light Fog(70)
        case 38: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_70.png";//Moderate Fog(70)
        case 39: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_70.png";//Heavy Fog(70)
        case 40: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_95.png";//Mist(95)
        case 41: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_72.png";//Hazy(72 or 113)
        case 42: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_75.png";//Smoky(75 or  99)
        case 43: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_78.png";//Blustery(78)
        case 44: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_78.png";//Windy(78)
        case 45: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_73.png";//Cold(73)
        case 46: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_71.png";//Hot(71)
        case 47: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_85.png";//Sunny(85 or 100)
        case 48: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_66.png";//Mostly Sunny(66 or 106)
        case 49: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_101.png";//Clear (night)(101)
        case 50: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_107.png";//Mostly Clear (night)(107)
        case 51: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_66.png";//Partly cloudy(66 or 106)
        case 52: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_107.png";//Partly cloudy (night)(107)
        case 53: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_69.png";//Mostly cloudy(69 or 104)
        case 54: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_105.png";//Mostly cloudy (night)(105)
        case 55: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_67.png";//Cloudy(67 or 102)
        case 56: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_117.png";//Tropical Storm(117 or 118)
        case 57: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_115.png";//Hurricane(115 or 116)
        case 58: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_103.png";//Funnel Cloud(103)
        case 59: return imageInfo.imgFolderXMDataWeather + "ico_weather_m_103.png";//Tornado(103)
        case 60: return "";
        case 61: return "";
        case 62: return "";
        case 63: return "";
        default: return "";
    }
}

function getSmallImagePath(weatherEvent)
{
    console.log("weatherEvent for small image : " + weatherEvent);

    switch(weatherEvent)
    {
        case 0: return "";//No Data Available
        case 1: return "";//Unknown Precipitation
        case 2: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_84.png";//Isolated Thunderstorms(84)
        case 3: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_98.png";//Scattered Thunderstorms(98)
        case 4: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_84.png";//Scattered Thunderstorms(night)(84)
        case 5: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_84.png";//Severe Thunderstorms(84 or 108/109)
        case 6: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_84.png";//Thunderstorms(84)
        case 7: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_82.png";//Rain(82)
        case 8: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_87.png";//Light Rain(87)
        case 9: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_82.png";//Heavy Rain(82)
        case 10: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_87.png";//Scattered Showers(87)
        case 11: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_86.png";//Scattered Showers(night)(86)
        case 12: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_87.png";//Showers(87)
        case 13: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_76.png";//Drizzle(76)
        case 14: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_90.png";//Freezing Drizzle(90)
        case 15: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_89.png";//Freezing Rain(89)
        case 16: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_79.png";//Wintry Mix(79)
        case 17: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_79.png";//Mixed Rain And Snow(79)
        case 18: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_88.png";//Mixed Rain And Sleet(88)
        case 19: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_89.png";//Mixed Rain And Hail(89)
        case 20: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_110.png";//Hail(110)
        case 21: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_88.png";//Sleet(88)
        case 22: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_110.png";//Ice Pellets(110)
        case 23: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_77.png";//Flurries(77)
        case 24: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_74.png";//Light Snow(74)
        case 25: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_83.png";//Moderate Snow(83)
        case 26: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_83.png";//Snow(83)
        case 27: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_83.png";//Heavy Snow(83)
        case 28: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_74.png";//Scattered Snow Showers(74)
        case 29: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_96.png";//Scattered Snow Showers(night)(96)
        case 30: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_74.png";//Snow Showers(74)
        case 31: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_81.png";//Blowing Snow(81)
        case 32: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_80.png";//Blizzard(80)
        case 33: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_111.png";//Sandstorm(111)
        case 34: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_112.png";//Blowing Dust(112)
        case 35: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_68.png";//Dust(68)
        case 36: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_70.png";//Foggy(70)
        case 37: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_70.png";//Light Fog(70)
        case 38: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_70.png";//Moderate Fog(70)
        case 39: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_70.png";//Heavy Fog(70)
        case 40: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_95.png";//Mist(95)
        case 41: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_72.png";//Hazy(72 or 113)
        case 42: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_75.png";//Smoky(75 or  99)
        case 43: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_78.png";//Blustery(78)
        case 44: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_78.png";//Windy(78)
        case 45: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_73.png";//Cold(73)
        case 46: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_71.png";//Hot(71)
        case 47: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_85.png";//Sunny(85 or 100)
        case 48: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_66.png";//Mostly Sunny(66 or 106)
        case 49: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_101.png";//Clear (night)(101)
        case 50: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_107.png";//Mostly Clear (night)(107)
        case 51: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_66.png";//Partly cloudy(66 or 106)
        case 52: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_107.png";//Partly cloudy (night)(107)
        case 53: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_69.png";//Mostly cloudy(69 or 104)
        case 54: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_105.png";//Mostly cloudy (night)(105)
        case 55: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_67.png";//Cloudy(67 or 102)
        case 56: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_117.png";//Tropical Storm(117 or 118)
        case 57: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_115.png";//Hurricane(115 or 116)
        case 58: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_103.png";//Funnel Cloud(103)
        case 59: return imageInfo.imgFolderXMDataWeather + "ico_weather_s_103.png";//Tornado(103)
        case 60: return "";
        case 61: return "";
        case 62: return "";
        case 63: return "";
        default: return "";
    }
}

function getWidgetIcoImagePath(weatherEvent)
{
    console.log("weatherEvent for widget Icon image : " + weatherEvent);

    switch(weatherEvent)
    {
        case 0: return "";//No Data Available
        case 1: return "";//Unknown Precipitation
        case 2: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_84.png";//Isolated Thunderstorms(84)
        case 3: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_98.png";//Scattered Thunderstorms(98)
        case 4: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_84.png";//Scattered Thunderstorms(night)(84)
        case 5: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_84.png";//Severe Thunderstorms(84 or 108/109)
        case 6: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_84.png";//Thunderstorms(84)
        case 7: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_82.png";//Rain(82)
        case 8: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_87.png";//Light Rain(87)
        case 9: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_82.png";//Heavy Rain(82)
        case 10: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_87.png";//Scattered Showers(87)
        case 11: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_86.png";//Scattered Showers(night)(86)
        case 12: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_87.png";//Showers(87)
        case 13: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_76.png";//Drizzle(76)
        case 14: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_90.png";//Freezing Drizzle(90)
        case 15: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_89.png";//Freezing Rain(89)
        case 16: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_79.png";//Wintry Mix(79)
        case 17: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_79.png";//Mixed Rain And Snow(79)
        case 18: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_88.png";//Mixed Rain And Sleet(88)
        case 19: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_89.png";//Mixed Rain And Hail(89)
        case 20: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_110.png";//Hail(110)
        case 21: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_88.png";//Sleet(88)
        case 22: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_110.png";//Ice Pellets(110)
        case 23: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_77.png";//Flurries(77)
        case 24: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_74.png";//Light Snow(74)
        case 25: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_83.png";//Moderate Snow(83)
        case 26: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_83.png";//Snow(83)
        case 27: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_83.png";//Heavy Snow(83)
        case 28: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_74.png";//Scattered Snow Showers(74)
        case 29: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_96.png";//Scattered Snow Showers(night)(96)
        case 30: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_74.png";//Snow Showers(74)
        case 31: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_81.png";//Blowing Snow(81)
        case 32: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_80.png";//Blizzard(80)
        case 33: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_111.png";//Sandstorm(111)
        case 34: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_112.png";//Blowing Dust(112)
        case 35: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_68.png";//Dust(68)
        case 36: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_70.png";//Foggy(70)
        case 37: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_70.png";//Light Fog(70)
        case 38: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_70.png";//Moderate Fog(70)
        case 39: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_70.png";//Heavy Fog(70)
        case 40: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_95.png";//Mist(95)
        case 41: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_72.png";//Hazy(72 or 113)
        case 42: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_75.png";//Smoky(75 or  99)
        case 43: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_78.png";//Blustery(78)
        case 44: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_78.png";//Windy(78)
        case 45: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_73.png";//Cold(73)
        case 46: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_71.png";//Hot(71)
        case 47: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_85.png";//Sunny(85 or 100)
        case 48: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_66.png";//Mostly Sunny(66 or 106)
        case 49: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_101.png";//Clear (night)(101)
        case 50: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_107.png";//Mostly Clear (night)(107)
        case 51: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_66.png";//Partly cloudy(66 or 106)
        case 52: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_107.png";//Partly cloudy (night)(107)
        case 53: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_69.png";//Mostly cloudy(69 or 104)
        case 54: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_105.png";//Mostly cloudy (night)(105)
        case 55: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_67.png";//Cloudy(67 or 102)
        case 56: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_117.png";//Tropical Storm(117 or 118)
        case 57: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_115.png";//Hurricane(115 or 116)
        case 58: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_103.png";//Funnel Cloud(103)
        case 59: return imageInfo.imgFolderXMDataWeather + "ico_widget_weather_103.png";//Tornado(103)
        case 60: return "";
        case 61: return "";
        case 62: return "";
        case 63: return "";
        default: return "";
    }
}

// Weather event image
function getImagePathForSki(weatherEvent)
{
    console.log("weatherEvent for Ski event large image : " + weatherEvent);

    switch(weatherEvent)
    {
        case 0: return "";//No Data Available
        case 1: return "";//Unknown Precipitation
        case 2: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_84.png";//Isolated Thunderstorms(84)
        case 3: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_98.png";//Scattered Thunderstorms(98)
        case 4: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_84.png";//Scattered Thunderstorms(night)(84)
        case 5: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_84.png";//Severe Thunderstorms(84 or 108/109)
        case 6: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_84.png";//Thunderstorms(84)
        case 7: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_82.png";//Rain(82)
        case 8: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_87.png";//Light Rain(87)
        case 9: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_82.png";//Heavy Rain(82)
        case 10: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_87.png";//Scattered Showers(87)
        case 11: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_86.png";//Scattered Showers(night)(86)
        case 12: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_87.png";//Showers(87)
        case 13: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_76.png";//Drizzle(76)
        case 14: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_90.png";//Freezing Drizzle(90)
        case 15: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_89.png";//Freezing Rain(89)
        case 16: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_79.png";//Wintry Mix(79)
        case 17: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_79.png";//Mixed Rain And Snow(79)
        case 18: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_88.png";//Mixed Rain And Sleet(88)
        case 19: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_89.png";//Mixed Rain And Hail(89)
        case 20: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_110.png";//Hail(110)
        case 21: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_88.png";//Sleet(88)
        case 22: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_110.png";//Ice Pellets(110)
        case 23: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_77.png";//Flurries(77)
        case 24: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_74.png";//Light Snow(74)
        case 25: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_83.png";//Moderate Snow(83)
        case 26: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_83.png";//Snow(83)
        case 27: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_83.png";//Heavy Snow(83)
        case 28: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_74.png";//Scattered Snow Showers(74)
        case 29: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_96.png";//Scattered Snow Showers(night)(96)
        case 30: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_74.png";//Snow Showers(74)
        case 31: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_81.png";//Blowing Snow(81)
        case 32: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_80.png";//Blizzard(80)
        case 33: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_111.png";//Sandstorm(111)
        case 34: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_112.png";//Blowing Dust(112)
        case 35: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_68.png";//Dust(68)
        case 36: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_70.png";//Foggy(70)
        case 37: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_70.png";//Light Fog(70)
        case 38: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_70.png";//Moderate Fog(70)
        case 39: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_70.png";//Heavy Fog(70)
        case 40: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_95.png";//Mist(95)
        case 41: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_72.png";//Hazy(72 or 113)
        case 42: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_75.png";//Smoky(75 or  99)
        case 43: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_78.png";//Blustery(78)
        case 44: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_78.png";//Windy(78)
        case 45: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_73.png";//Cold(73)
        case 46: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_71.png";//Hot(71)
        case 47: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_85.png";//Sunny(85 or 100)
        case 48: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_66.png";//Mostly Sunny(66 or 106)
        case 49: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_101.png";//Clear (night)(101)
        case 50: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_107.png";//Mostly Clear (night)(107)
        case 51: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_66.png";//Partly cloudy(66 or 106)
        case 52: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_107.png";//Partly cloudy (night)(107)
        case 53: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_69.png";//Mostly cloudy(69 or 104)
        case 54: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_105.png";//Mostly cloudy (night)(105)
        case 55: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_67.png";//Cloudy(67 or 102)
        case 56: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_117.png";//Tropical Storm(117 or 118)
        case 57: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_115.png";//Hurricane(115 or 116)
        case 58: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_103.png";//Funnel Cloud(103)
        case 59: return imageInfo.imgFolderXMDataWeather + "ico_weather_l_103.png";//Tornado(103)
        case 60: return "";
        case 61: return "";
        case 62: return "";
        case 63: return "";
        case -999: return "";
        default: return "";
    }
}

// Temperature convert function (F <-> C)
function getTemperature(fahrenheit, setvalue)
{
    console.log("getTemperature -> fahrenheit = " + fahrenheit);

    var tmpTemp = 0;

    if(setvalue == 0)
    {
        return fahrenheit + "°F";
    }
    else
    {
        tmpTemp = (fahrenheit-32)*10/18;
        return parseFloat(tmpTemp.toFixed(1)) + "°C";
    }
}

function getTemperatureEx(fahrenheit, setvalue)
{
    console.log("getTemperature -> fahrenheit = " + fahrenheit);

    var tmpTemp = 0;

    if(setvalue == 0)
    {
        return fahrenheit;
    }
    else
    {
        tmpTemp = (fahrenheit-32)*10/18;
        return parseFloat(tmpTemp.toFixed(1));
    }
}

function getFarenheit()
{
   return "°F";
}

function getCelsius()
{
   return "°C";
}

function getWindConditionText(windcondition)
{
    console.log("getWindConditionText -> windcondition = " + windcondition);

    switch(windcondition)
    {
        case 0 : return stringInfo.sSTR_XMDATA_SKI_WIND_CONDITION_CALM;
        case 1 : return stringInfo.sSTR_XMDATA_SKI_WIND_CONDITION_MILD;
        case 2 : return stringInfo.sSTR_XMDATA_SKI_WIND_CONDITION_MODERATE;
        case 3 : return stringInfo.sSTR_XMDATA_SKI_WIND_CONDITION_STRONG;
        case 4 : return stringInfo.sSTR_XMDATA_SKI_WIND_CONDITION_GUSTY;
        case 5 : return stringInfo.sSTR_XMDATA_SKI_WIND_CONDITION_VERY_STRONG;
        case 6 : return stringInfo.sSTR_XMDATA_SKI_WIND_CONDITION_NOT_RECOMMENDED;
        default: return "-";
    }
}

function getSnowConditionText(snowcondition)
{
    console.log("getsnowConditionText -> snowcondition = " + snowcondition);

    switch(snowcondition)
    {
        case 0 : return stringInfo.sSTR_XMDATA_SKI_SNOW_CONDITION_POWDER;
        case 1 : return stringInfo.sSTR_XMDATA_SKI_SNOW_CONDITION_HARD_PACKED;
        case 2 : return stringInfo.sSTR_XMDATA_SKI_SNOW_CONDITION_WET_PACKED;
        case 3 : return stringInfo.sSTR_XMDATA_SKI_SNOW_CONDITION_LOOSE_GRANULAR;
        case 4 : return stringInfo.sSTR_XMDATA_SKI_SNOW_CONDITION_WET_GRANULAR;
        case 5 : return stringInfo.sSTR_XMDATA_SKI_SNOW_CONDITION_FROZEN_GRANULAR;
        case 6 : return stringInfo.sSTR_XMDATA_SKI_SNOW_CONDITION_ICY;
        case 7 : return stringInfo.sSTR_XMDATA_SKI_SNOW_CONDITION_MIXED_CONDITIONS;
        default: return "-";
    }
}

function getOperatingStatusText(operationStatus)
{
    console.log("getOperatingStatusText -> operationStatus = " + operationStatus);

    switch(operationStatus)
    {
        case 0 : return stringInfo.sSTR_XMDATA_CLOSED;
        case 1 : return stringInfo.sSTR_XMDATA_OPEN;
        default: return "-";
    }
}


function getSkiStatusText(status)
{
    console.log("getSkiStatusText -> status = " + status);

    switch(status)
    {
        case 0 : return stringInfo.sSTR_XMDATA_NO;
        case 1 : return stringInfo.sSTR_XMDATA_YES;
        case 2: return "-";
        default: return "-";
    }
}

function getCloudCoverStatusText(status)
{
    console.log("getCloudCoverStatusText -> status = " + status);

    switch(status)
    {
        case 0 : return stringInfo.sSTR_XMDATA_CLOUD_COVER_STATUS_CLEAR/*"Clear"*/;
        case 1 : return stringInfo.sSTR_XMDATA_CLOUD_COVER_STATUS_FEW/*"Few"*/;
        case 2 : return stringInfo.sSTR_XMDATA_CLOUD_COVER_STATUS_SCATTERED/*"Scattered"*/;
        case 3 : return stringInfo.sSTR_XMDATA_CLOUD_COVER_STATUS_BROKEN/*"Broken"*/;
        case 4 : return stringInfo.sSTR_XMDATA_CLOUD_COVER_STATUS_OVERCAST/*"Overcast"*/;
        case 5 : return "-";
        case 6 : return "-";
        case 7 : return "-";
        default: return "-";
    }
}

function getWeatherEventDescription(event)
{
    switch(event)
    {
        case 0: return "";//No Data Available
        case 1: return "";//Unknown Precipitation
        case 2: return "Isolated Thunderstorms"
        case 3: return "Scattered Thunderstorms"
        case 4: return "Scattered Thunderstorms"//(night)
        case 5: return "Severe Thunderstorms"
        case 6: return "Thunderstorms"
        case 7: return "Rain"
        case 8: return "Light Rain"
        case 9: return "Heavy Rain"
        case 10: return "Scattered Showers"
        case 11: return "Scattered Showers"//(night)
        case 12: return "Showers"
        case 13: return "Drizzle"
        case 14: return "Freezing Drizzle"
        case 15: return "Freezing Rain"
        case 16: return "Wintry Mix"
        case 17: return "Mixed Rain And Snow"
        case 18: return "Mixed Rain And Sleet"
        case 19: return "Mixed Rain And Hail"
        case 20: return "Hail"
        case 21: return "Sleet"
        case 22: return "Ice Pellets"
        case 23: return "Flurries"
        case 24: return "Light Snow"
        case 25: return "Moderate Snow"
        case 26: return "Snow"
        case 27: return "Heavy Snow"
        case 28: return "Scattered Snow Showers"
        case 29: return "Scattered Snow Showers"//(night)
        case 30: return "Snow Showers"
        case 31: return "Blowing Snow"
        case 32: return "Blizzard"
        case 33: return "Sandstorm"
        case 34: return "Blowing Dust"
        case 35: return "Dust"
        case 36: return "Foggy"
        case 37: return "Light Fog"
        case 38: return "Moderate Fog"
        case 39: return "Heavy Fog"
        case 40: return "Mist"
        case 41: return "Hazy"
        case 42: return "Smoky"
        case 43: return "Blustery"
        case 44: return "Windy"
        case 45: return "Cold"
        case 46: return "Hot"
        case 47: return "Sunny"
        case 48: return "Mostly Sunny"
        case 49: return "Clear"//(night)
        case 50: return "Mostly Clear"//(night)
        case 51: return "Partly Cloudy"
        case 52: return "Partly Cloudy"//(night)
        case 53: return "Mostly Cloudy"
        case 54: return "Mostly Cloudy"//(night)
        case 55: return "Cloudy"
        case 56: return "Tropical Storm"
        case 57: return "Hurricane"
        case 58: return "Funnel Cloud"
        case 59: return "Tornado"
        case 60: return "";
        case 61: return "";
        case 62: return "";
        case 63: return "";
        default: return "-";
    }
}

function timeConverter(UNIX_timestamp, DayLightSaving){
    var a = new Date(UNIX_timestamp*1000 + (3600000*-5))

    var hour = a.getUTCHours();
    var min = a.getUTCMinutes();

    if(DayLightSaving == 1)
    {
        hour = hour + 1;
    }
    a.setHours(hour);

    if (min<=9)
    {
        min="0"+min;
        a.setMinutes(min);
    }

    var timesep;
    if(hour > 0 && hour < 13)
    {
        timesep = 'AM';
    }
    else if(hour > 12 && hour < 25)
    {
        hour -= 12;
        timesep = 'PM';
    }

    var time = hour+':'+min+' '+timesep + ' ' + 'EST';
    return time;
 }

function getBaseDepthValue(minValue, maxValue)
{
    if(minValue > 63 && maxValue > 63)
        return "-";

    if(minValue > 63)
        minValue = "-";

    if(maxValue > 63)
        maxValue = "-";

    return minValue + " / " + maxValue;
}

function getNewSnowRangeValue(minValue, maxValue)
{
    if(minValue > 42 && maxValue > 42)
        return "-";

    if(minValue > 42)
        minValue = "-";

    if(maxValue > 42)
        maxValue = "-";

    return minValue + " / " + maxValue;
}

function getNumOfTrailsRangeValue(minValue, maxValue)
{
    if(minValue > 230 && maxValue > 230)
        return "-";

    if(minValue > 230)
        minValue = "-";

    if(maxValue > 230)
        maxValue = "-";

    return minValue + " / " + maxValue;
}

function getHumidityRangeValue(minValue, maxValue)
{
    if(minValue > 100 && maxValue > 100)
        return "-";

    if(minValue > 100)
        minValue = "-";

    if(maxValue > 100)
        maxValue = "-";

    return minValue + "%" + " ~ " + maxValue + "%";
}
