//Convert to km <-> mile
function convertToDU(isMileOrKm, distance)
{
    if(isMileOrKm == false)//km
    {
        var kmDistance = distance * 1.609344;
        return (Math.floor(kmDistance*10)/10).toFixed(1);
    }
    else if(isMileOrKm == true)//mile
    {
        var mileDistance = distance;
        return (Math.floor(mileDistance*10)/10).toFixed(1);
    }
}

function convertTimeFormat(UNIX_timestamp, DayLightSaving, TimeFormat){
    var dateTime = new Date((UNIX_timestamp - ((60*60)*5) + (DayLightSaving == true ? 60*60 : 0))*1000);
//    console.log("[convertTimeFormat]==timestamp("+UNIX_timestamp+"), DayLightSaving("+DayLightSaving+"), TimeFormat("+TimeFormat+"), dateTime("+dateTime.toUTCString()+")");
    var hour = dateTime.getUTCHours();
    var min = dateTime.getUTCMinutes();

    var returnString = "";
    if(TimeFormat)// 24h
    {
        returnString = (hour < 10 ? "0"+hour : hour) + ":" + (min < 10 ? "0" + min : min) + " ET";
    }
    else// 12h
    {
        var isOverHalfTime = hour > 11;
        returnString = (hour > 12 ? hour - 12 : (hour == 0 ? "12" : hour)) + ":" + (min < 10 ? "0" + min : min) + (isOverHalfTime ? " PM" : " AM") + " ET";
    }

    return returnString;
 }

function convertTimeFormatForOthers(UNIX_timestamp, DayLightSaving, TimeFormat){
    var dateTime = new Date((UNIX_timestamp + (DayLightSaving == true ? 60*60 : 0))*1000);
//    console.log("[convertTimeFormatForOthers]==timestamp("+UNIX_timestamp+"), DayLightSaving("+DayLightSaving+"), TimeFormat("+TimeFormat+"), dateTime("+dateTime.toUTCString()+")");
    var hour = dateTime.getUTCHours();
    var min = dateTime.getUTCMinutes();

    var returnString = "";
    if(TimeFormat)// 24h
    {
        returnString = (hour < 10 ? "0"+hour : hour) + ":" + (min < 10 ? "0" + min : min);
    }
    else// 12h
    {
        var isOverHalfTime = hour > 11;
        returnString = (hour > 12 ? hour - 12 : (hour == 0 ? "12" : hour)) + ":" + (min < 10 ? "0" + min : min) + (isOverHalfTime ? " PM" : " AM");
    }

    return returnString;
 }

function convertTimeFormatForRank(UNIX_timestamp){
    var dateTime = new Date(UNIX_timestamp*1000);
//    console.log("[convertTimeFormatForRank]==timestamp("+UNIX_timestamp+"), dateTime("+dateTime.toUTCString()+")");
    var hour = dateTime.getUTCHours();
    var min = dateTime.getUTCMinutes();

    var returnString = "";

    returnString = hour + ":" + (min < 10 ? "0" + min : min);

    return returnString;
 }

function convertTimeFormatForSports(UNIX_timestamp, DayLightSaving, TimeFormat){
    var dateTime = new Date((UNIX_timestamp + (DayLightSaving == true ? 60*60 : 0))*1000);
    var hour = dateTime.getUTCHours();
    var min = dateTime.getUTCMinutes();

    var returnString = "";
    if(TimeFormat)// 24h
    {
        returnString = (hour < 10 ? "0"+hour : hour) + ":" + (min < 10 ? "0" + min : min) + " ET";
    }
    else// 12h
    {
        var isOverHalfTime = hour > 11;
        returnString = (hour > 12 ? hour - 12 : (hour == 0 ? "12" : hour)) + ":" + (min < 10 ? "0" + min : min) + (isOverHalfTime ? " PM" : " AM") + " ET";
    }

    return returnString;
 }
