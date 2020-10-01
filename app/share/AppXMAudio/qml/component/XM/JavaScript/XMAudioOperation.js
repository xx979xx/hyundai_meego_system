/**
 * FileName: RadioOperation.js
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

/////////////////////////////////////////////////////////////
// Related function of List
/////////////////////////////////////////////////////////////
function onListSkip()
{
    idRadioList.item.setListSkip();
}

/////////////////////////////////////////////////////////////
// Related function of Instant Replay
/////////////////////////////////////////////////////////////
function instantReplayWarning()
{
    //Dim - "Replay Memory Near Full"
    setAppMainScreen("PopupRadioDim1Line5Second", true);
    idRadioPopupDim1Line5Second.item.onPopupDim1LineFirst(stringInfo.sSTR_XMRADIO_REPLAY_MEMORY_NEAR_FULL);
}

function onPause()
{
    gSXMPlayMode = "Pause";
    UIListener.HandlePause();
}

function onPlay()
{
    gSXMPlayMode = "Play";
    UIListener.HandlePlay();
}

function onNowPlay(bPlayFlag)
{
    idRadioMain.item.onFastFFRewStop();
    gSXMMode = "LiveMode"
    gSXMPlayMode = "Play";
    if(bPlayFlag == true)
        UIListener.HandleNowPlay();
}

function onPlaySeek(offset)
{
    UIListener.HandleSeek(offset);
}

function onPlaySeekSong(offset)
{
    UIListener.HandleSeekSong(offset);
}

/////////////////////////////////////////////////////////////
// Related function of Set Team
/////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////
// Related function of Favorite List
/////////////////////////////////////////////////////////////
function onFavoriteList()
{
    idRadioFavorite.item.setFavoriteListSongList();
    idRadioFavorite.item.setFavoriteListSongFocus();
    idRadioFavorite.item.setFavoriteListChangeStyle();
}

function onFavoriteDelete()
{
    idAppMain.selectAllcancelandok();
    setAppMainScreen( "AppRadioFavorite" , false);
    idRadioFavorite.item.setFavoriteDelete();
}

function favoriteDeletefinished()
{
    idRadioFavorite.item.setPreFavoriteList();
    setAppMainScreen( "AppRadioFavorite" , false);

    setAppMainScreen("PopupRadioDim1Line", true);
    idRadioPopupDim1Line.item.onPopupDim1LineFirst(stringInfo.sSTR_XMRADIO_DELETED_SUCCESSFULLY);
}

/////////////////////////////////////////////////////////////
// Related function of Scan / PresetScan
/////////////////////////////////////////////////////////////
function scanTimerStop()
{
    gSXMScan = "Normal";
    gSXMPresetScan = "Normal";
}

function setPreviousScanStop()
{
    console.log("setPreviousScanStop Scan:"+gSXMScan+" PresetScan:"+gSXMPresetScan);
    if((gSXMScan == "Scan") || (gSXMPresetScan == "PresetScan"))
    {
        gSXMScan = "Normal";
        gSXMPresetScan = "Normal";
        UIListener.HandleScanAndPresetScanStop();
    }
}

/////////////////////////////////////////////////////////////
// Related function of Artist/Song/Games Alert
/////////////////////////////////////////////////////////////
function dialogSongArtistGame(m_status, m_sztext, chid)
{
    console.log("Song/Artist/Game Dialog : " + m_status + " " + m_sztext + " " + chid)
    switch(m_status)
    {
    case 0://Artist Alert
    {
        if(currentAppStateID() != idRadioPopupAlert)
            setAppMainScreen("PopupRadioAlert", true);
        idRadioPopupAlert.item.onPopupAlertFirst(stringInfo.sSTR_XMRADIO_YOUR_FAVORITE_ARTIST);
        idRadioPopupAlert.item.onPopupAlertSecond(m_sztext);
        idRadioPopupAlert.item.onPopupAlertChnID(chid);
        idRadioPopupAlert.item.onPopupAlertThirdTextUsed(true);
    }
    break;
    case 1://Song Alert
    {
        if(currentAppStateID() != idRadioPopupAlert)
            setAppMainScreen("PopupRadioAlert", true);
        idRadioPopupAlert.item.onPopupAlertFirst(stringInfo.sSTR_XMRADIO_YOUR_FAVORITE_SONG);
        idRadioPopupAlert.item.onPopupAlertSecond(m_sztext);
        idRadioPopupAlert.item.onPopupAlertChnID(chid);
        idRadioPopupAlert.item.onPopupAlertThirdTextUsed(true);
    }
    break;
    case 2://Game Alert
    {
        if(currentAppStateID() != idRadioPopupAlert)
            setAppMainScreen("PopupRadioAlert", true);
        idRadioPopupAlert.item.onPopupAlertFirst(stringInfo.sSTR_XMRADIO_YOUR_FAVORITE_GAME);
        idRadioPopupAlert.item.onPopupAlertSecond(m_sztext);
        idRadioPopupAlert.item.onPopupAlertChnID(chid);
        idRadioPopupAlert.item.onPopupAlertThirdTextUsed(true);
    }
    break;
    case 3://EPG Program Alert
    {
        if(currentAppStateID() != idRadioPopupAlert)
            setAppMainScreen("PopupRadioAlert", true);
        idRadioPopupAlert.item.onPopupAlertFirst(m_sztext);
        idRadioPopupAlert.item.onPopupAlertChnID(chid);
        idRadioPopupAlert.item.onPopupAlertThirdTextUsed(false);
    }
    break;
    case 4://EPG Series Alert
    {
        if(currentAppStateID() != idRadioPopupAlert)
            setAppMainScreen("PopupRadioAlert", true);
        idRadioPopupAlert.item.onPopupAlertFirst(m_sztext);
        idRadioPopupAlert.item.onPopupAlertChnID(chid);
        idRadioPopupAlert.item.onPopupAlertThirdTextUsed(false);
    }
    break;
    default:
        break;
    }
}

/////////////////////////////////////////////////////////////
// Related function of Engineering Mode
/////////////////////////////////////////////////////////////
function engineeringModeDynamics(b_status)
{
    if(b_status == true)
    {
        UIListener.settEngineeringMode(true);
        UIListener.HandleEngineeringListView();
        setAppMainScreen("AppRadioEngineering", false);
        idRadioEngineering.item.setEngMode();
    }
    else
    {
        setAppMainScreen("AppRadioMain", false);
        idRadioEngineering.item.setNoEngMode();
    }
}

function dealerModeDynamics(b_status)
{
    if(b_status == true)
    {
        UIListener.settEngineeringMode(true);
        UIListener.HandleEngineeringListView();
        setAppMainScreen("AppRadioDealerMode", false);
        idRadioDealerMode.item.setEngMode();
    }
    else
    {
        setAppMainScreen("AppRadioMain", false);
        idRadioDealerMode.item.setNoDealMode();
    }
}

/////////////////////////////////////////////////////////////
// Related function of EPG
/////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////
// Related function of Tag
/////////////////////////////////////////////////////////////
function tagStatusChanged(m_status, filecount)
{
    console.log("OnTaggingInfo - changed:" + m_status)
    switch(m_status)
    {
    case 1://Memory Full!!! Message
    {
        setAppMainScreen("PopupRadioWarning1Line", true);
        idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_TAG_MEMORY_FULL_MESSAGE1);
        idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(false);
    }
    break;
    case 2://Song Tagged
    {
        var mTagSongNum = filecount;
        var mTagSongTempNum = 50;
        setAppMainScreen("PopupRadioDim2Line", true);
        idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_TAG_STORED);
        idRadioPopupDim2Line.item.onPopupDim2LineSecond(mTagSongNum+" / "+mTagSongTempNum);
    }
    break;
    case 3://Song Taggings Transferred to iPod
    {
        //TODO - OSD display
    }
    break;
    case 4://Song Tagging Failed
    {
        setAppMainScreen("PopupRadioWarning1Line", true);
        idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_TAG_MESSAGE1);
        idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(false);
    }
    break;
    case 5://Song Already Tagged
    {
        setAppMainScreen("PopupRadioWarning1Line", true);
        idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_TAG_ERROR_MESAGE2);
        idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(false);
    }
    break;
    case 6: //Already saved as preset -> jdh1022 : Not used
    {
        //        setAppMainScreen("PopupRadioWarning1Line", true);
        //        idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_ALREADY_SAVE_AS_PRESET);
        //        idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(false);
    }
    break;
    default:
        console.log("OnTaggingInfo - No Found changed:" + m_status)
        break;
    }
}

/////////////////////////////////////////////////////////////
// Related function of Advisory Message
/////////////////////////////////////////////////////////////
function setAdvisoryMessage(szChnNum)
{
    console.log("setAdvisoryMessage - " + szChnNum);
    setAppMainScreen("PopupRadioAdvisory1Line", true);
    idRadioPopupAdvisory1Line.item.onPopupAdv1LineFirst(stringInfo.sSTR_XMRADIO_CHANNEL+" "+szChnNum+" "+stringInfo.sSTR_XMRADIO_IS_NOT_AVAILABLE);
}

function showSavedAsPresetSuccessfully()
{
    console.log("showSavedAsPresetSuccessfully - changed:");
    setAppMainScreen("PopupRadioDim1Line", true);
    idRadioPopupDim1Line.item.onPopupDim1LineFirst(stringInfo.sSTR_XMRADIO_PRESET_SAVED);
}

function showSavedAsPresetRadioIDChannelNotAvailable()
{
    console.log("showSavedAsPresetRadioIDChannelNotAvailable - changed:");
    setAppMainScreen("PopupRadioDim1Line", true);
    idRadioPopupDim1Line.item.onPopupDim1LineFirst(stringInfo.sSTR_XMRADIO_PRESET_RADIOID_CHANNEL_NOT_AVAILABLE);
}

function onEPGCategoryMode()
{
    idRadioEPG.item.selectEPGCategory();
}

function sxmDataRequestToGameZone()
{
    idAppMain.gotoFirstScreen();
    setAppMainScreen( "AppRadioGameZone" , false);
}

function epgAlertListMax(m_status)
{
    console.log("epgAlertListMax - changed:" + m_status);
    switch(m_status)
    {
    case 1: //program alert max
    {
        setAppMainScreen("PopupRadioWarning1Line", true);
        idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_TIMER_MESSAGE2);
        idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(false);
    }
    break;
    default:
        console.log("epgAlertListMax - No Found changed:" + m_status)
        break;
    }
}

function setPresetSaveFlag(b_status)
{
    if(b_status)
        idAppMain.gSXMSaveAsPreset = "TRUE";
    else
        idAppMain.gSXMSaveAsPreset = "FALSE";

    UIListener.HandleSetPresetSaveFlag(b_status);
}

function setPresetOrderFlag(b_status)
{
    if(b_status)
        idAppMain.gSXMEditPresetOrder = "TRUE";
    else
        idAppMain.gSXMEditPresetOrder = "FALSE";

    UIListener.HandleSetPresetOrderFlag(b_status);
}

function setPreviousPresetSaveAndOrderStop()
{
    idAppMain.gSXMSaveAsPreset = "FALSE";
    idAppMain.gSXMEditPresetOrder = "FALSE";
    UIListener.HandleSetPresetSaveFlag(false);
    UIListener.HandleSetPresetOrderFlag(false);
}

function setForceFocusEnterPresetOrderOrSave()
{
    console.log("setForceFocusEnterPresetOrderOrSave!!!!!!!!!!!!!!!!!!!!!!")
    idRadioMain.item.setForceFocusEnterPresetOrderOrSave();
}

function popupXMSubscriptionUpdated()
{
    console.log("popupXMSubscriptionUpdated");
    setAppMainScreen("PopupRadioWarning2Line", true);
    idRadioPopupWarning2Line.item.onPopupWarning2LineFirst(stringInfo.sSTR_XMRADIO_SUBSCRIPTION_UPDATED);
    idRadioPopupWarning2Line.item.onPopupWarning2LineSecond(stringInfo.sSTR_XMRADIO_SUBSCRIPTION_DESCRIPTION);
    idRadioPopupWarning2Line.item.onPopupWarning2LineWrap(true);
}

function setTeamCheckInvalid(szTeamName)
{
    console.log("setTeamCheckInvalid "+szTeamName);
    setAppMainScreen("PopupRadioWarning1Line", true);
    idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_TEAM+" "+szTeamName+" "+stringInfo.sSTR_XMRADIO_ALERT_UNAVAILABLE);
    idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(false);
}

function checkFranceLanguage()
{
    if(UIListener.HandleCheckFrenchSpanishLanguage() == true)
        return 32;
    else
        return 36;
}

function btConnectStatus(b_status)
{
    console.log("BT Connect Status -> "+b_status);
    idRadioPopupSubscriptionStatus.item.setBTConnectStatus(b_status);
}
