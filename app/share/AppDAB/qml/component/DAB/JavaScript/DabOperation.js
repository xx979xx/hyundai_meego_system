/**
 * FileName: DabOpertation.js
 * Author: DaeHyungE
 * Description: Collection of JavaScript Function for DAB
 *
 *
 *
 */

function setPropertyChanges(mainScreen, saveCurrentScreen)
{
    console.debug("[QML] DabOperation.js : setPropertyChanges : idAppMain.state = " + idAppMain.state + " mainScreen = " + mainScreen + " saveCurrentScreen = " + saveCurrentScreen)

    if( saveCurrentScreen == true )
    {
        setPreSelectedMainScreen();
        switch(idAppMain.state)
        {
        case "DABPlayerMain":
            if(mainScreen=="DabENGMode")idDabPlayerMain.visible = false; break;
            break;

        case "DabPlayerOptionMenu":
            break;

        case "DabStationList":
            break;

        case "DabStationListMainMenu":
            break;

        case "DabStationListSubMenu":
            break;

        case "DabInfoDLSMain":
            break;

        case "DabInfoSLSMain":
            break;

        case "DabInfoEPGMain":
            break;

        case "DabInfoEPGDescPopup":
            break;

        case "DabInfoEPGPreservePopup":
            break;

        case "DabInfoEPGPreserveFullPopup":
            break;

        case "DabInfoEPGPreserveTimerPopup":
            break;

        case "DabInfoEPGDateListPopup":
            break;

        case "DabSetting":
            break;

        case "DabPresetList":
            break;

        case "DabPresetSavedPopup":
            break;

        case "DabENGMode":
            break;

        case "DabENGDealerMode":
            break;

        case "DabInfoEPGPreserveOffAirPopup":
            break;

        default:
            console.log(" (saveCurrentScreen === true) ============== Error!!");
            break;
        }
    }
    else
    {
        switch(idAppMain.state)
        {
        case "DABPlayerMain":
            idDabPlayerMain.visible = false;
            break;

        case "DabPlayerOptionMenu":
            idDabPlayerOptionMenu.visible = false;
            break;

        case "DabStationList":
            idDabStationList.visible = false;
            break;

        case "DabStationListMainMenu":
            idDabStationListMainMenu.visible = false;            
            break;

        case "DabStationListSubMenu":
            idDabStationListSubMenu.visible = false;
            break;

        case "DabInfoDLSMain":
            idDabInfoDLSMain.visible = false;
            break;

        case "DabInfoSLSMain":
            idDabInfoSLSMain.visible = false;
            break;

        case "DabInfoEPGMain":
            idDabInfoEPGMain.visible = false;
            break;

        case "DabInfoEPGDescPopup":
            idDabInfoEPGDescPopup.visible = false;
            break;

        case "DabInfoEPGPreservePopup":
            idDabInfoEPGPreservePopup.visible = false;
            break;

        case "DabInfoEPGPreserveFullPopup":
            idDabInfoEPGPreserveFullPopup.visible = false;
            break;

        case "DabInfoEPGDateListPopup":
            idDabInfoEPGDateListPopup.visible = false;
            break;

        case "DabTAPopup":
            idDabTAPopup.visible = false;
            break;

        case "DabSetting":
            idDabSetting.visible = false;
            break;

        case "DabPresetList":
            idDabPresetList.visible = false;
            break;

        case "DabPresetSavedPopup":
            idDabPresetSavedPopup.visible = false;
            break;

        case "DabENGMode":
            idDabENGModeMain.visible = false;
            break;

        case "DabENGDealerMode":
            idDabENGDealerMode.visible = false;
            break;

        case "DabInfoEPGPreserveOffAirPopup":
            idDabInfoEPGPreserveOffAirPopup.visible = false;
            break;

        default:
            console.log(" (saveCurrentScreen === false) ============== Error!!");
            break;
        }
    }

    idAppMain.state = mainScreen;
    idAppMain.focus = true;

    UIListener.autoTest_athenaSendObject();
    switch(mainScreen)
    {
        //App
    case "DABPlayerMain":
        console.log("[QML] DABPlayerMain.qml Loader !!")
        if( idDabPlayerMain.status == Loader.Null )
        {
            idDabPlayerMain.source = "../component/DAB/PlayingScreen/DABPlayerMain.qml";
        }
        idDabPlayerMain.visible = true;
        idDabPlayerMain.focus = true;
        break;

    case "DabPlayerOptionMenu":
        console.log("[QML] DabPlayerOptionMenu.qml Loader !!")
        if( idDabPlayerOptionMenu.status == Loader.Null )
        {
            idDabPlayerOptionMenu.source = "../component/DAB/PlayingScreen/DABPlayerOptionMenu.qml";
        }
        idDabPlayerOptionMenu.visible = true;
        idDabPlayerOptionMenu.focus = true;
        break;

    case "DabStationList":
        console.log("[QML] DabStationList.qml Loader !! , idDabStationList.visible = " + idDabStationList.visible)
        idDabPlayerMain.visible = false;
        if( idDabStationList.status == Loader.Null )
        {
            idDabStationList.source = "../component/DAB/StationList/DABStationList.qml";
        }
        if(idDabStationList.visible == false)
        {
            idDabStationList.item.initialize();
            idDabStationList.visible = true;
        }
        idDabStationList.focus = true;
        break;

    case "DabStationListMainMenu":
        console.log("[QML] DabStationList_MainMenu.qml Loader !! status = " + idDabStationListMainMenu.status )
        if( idDabStationListMainMenu.status == Loader.Null )
        {
            idDabStationListMainMenu.source = "../component/DAB/StationList/DABStationListMainMenu.qml";
        }
        idDabStationListMainMenu.visible = true;
        idDabStationListMainMenu.focus = true;
        break;

    case "DabStationListSubMenu":
        console.log("[QML] DABStationListSubMenu.qml Loader !! status = " + idDabStationListMainMenu.status )
        if( idDabStationListSubMenu.status == Loader.Null )
        {
            idDabStationListSubMenu.source = "../component/DAB/StationList/DABStationListSubMenu.qml";
        }
        idDabStationListSubMenu.visible = true;
        idDabStationListSubMenu.focus = true;
        break;

    case "DabInfoDLSMain":
        console.log("[QML] DABInfoDLSMain.qml Loader !! status = " + idDabInfoDLSMain.status )
        if( idDabInfoDLSMain.status == Loader.Null )
        {
            idDabInfoDLSMain.source = "../component/DAB/Info/DABInfoDLSMain.qml";
        }

        idDabInfoDLSMain.visible = true;
        idDabInfoDLSMain.focus = true;
        break;

    case "DabInfoSLSMain":
        console.log("[QML] DABInfoSLSMain.qml Loader !! status = " + idDabInfoSLSMain.status )
        if( idDabInfoSLSMain.status == Loader.Null )
        {
            idDabInfoSLSMain.source = "../component/DAB/Info/DABInfoSLSMain.qml";
        }

        idDabInfoSLSMain.visible = true;
        idDabInfoSLSMain.focus = true;
        break;

    case "DabInfoEPGMain":
        console.log("[QML] DABInfoEPGMain.qml Loader !! status = " + idDabInfoEPGMain.status + ", visible = " + idDabInfoEPGMain.visible)
        idDabPlayerMain.visible = false;
        if( idDabInfoEPGMain.status == Loader.Null )
        {
            idDabInfoEPGMain.source = "../component/DAB/Info/DABInfoEPGMain.qml";
        }
        if(!idDabInfoEPGMain.visible)
        {
            idDabInfoEPGMain.item.initialize();
            idDabInfoEPGMain.visible = true;
        }
        idDabInfoEPGMain.focus = true;
        break;

    case "DabInfoEPGDescPopup":
        console.log("[QML] DABInfoEPGDescPopup.qml Loader !! status = " + idDabInfoEPGDescPopup.status )
        if( idDabInfoEPGDescPopup.status == Loader.Null )
        {
            idDabInfoEPGDescPopup.source = "../component/DAB/Info/DABInfoEPGDescPopup.qml";
        }
        idDabInfoEPGDescPopup.visible = true;
        idDabInfoEPGDescPopup.focus = true;
        break;

    case "DabInfoEPGPreservePopup":
        console.log("[QML] DABInfoEPGPreservePopup.qml Loader !! status = " + idDabInfoEPGPreservePopup.status )
        if( idDabInfoEPGPreservePopup.status == Loader.Null )
        {
            idDabInfoEPGPreservePopup.source = "../component/DAB/Info/DABInfoEPGPreservePopup.qml";
        }
        idDabInfoEPGPreservePopup.item.initialize();
        idDabInfoEPGPreservePopup.visible = true;
        idDabInfoEPGPreservePopup.focus = true;
        break;

    case "DabInfoEPGPreserveFullPopup":
        console.log("[QML] DabInfoEPGPreserveFullPopup.qml Loader !! status = " + idDabInfoEPGPreserveFullPopup.status )
        if( idDabInfoEPGPreserveFullPopup.status == Loader.Null )
        {
            idDabInfoEPGPreserveFullPopup.source = "../component/DAB/Info/DABInfoEPGPreserveFullPopup.qml";
        }
        idDabInfoEPGPreserveFullPopup.visible = true;
        idDabInfoEPGPreserveFullPopup.focus = true;
        break;

    case "DabInfoEPGDateListPopup":
        console.log("[QML] DabInfoEPGDateListPopup.qml Loader !! status = " + idDabInfoEPGDateListPopup.status )
        if( idDabInfoEPGDateListPopup.status == Loader.Null )
        {
            idDabInfoEPGDateListPopup.source = "../component/DAB/Info/DABInfoEPGDateListPopup.qml";
        }

        idDabInfoEPGDateListPopup.item.initialize();
        idDabInfoEPGDateListPopup.visible = true;
        idDabInfoEPGDateListPopup.focus = true;
        break;

    case "DabTAPopup":
        console.log("[QML] DabTAPopup.qml Loader !! status = " + idDabTAPopup.status )
        if( idDabTAPopup.status == Loader.Null )
        {
            idDabTAPopup.source = "../component/DAB/Common/DABTAPopup.qml";
        }
        idDabTAPopup.visible = true;
        idDabTAPopup.focus = true;
        break;

    case "DabSetting":
        console.log("[QML] DABSetting.qml Loader !! status = " + idDabSetting.status )
        idDabPlayerMain.visible = false;
        if( idDabSetting.status == Loader.Null )
        {
            idDabSetting.source = "../component/DAB/Setting/DABSetting.qml";
        }
        idDabSetting.visible = true;
        idDabSetting.focus = true;
        break;

    case "DabPresetList":
        console.log("[QML] DABPresetList.qml Loader !! status = " + idDabPresetList.status )
        idDabPlayerMain.visible = false;
        if( idDabPresetList.status == Loader.Null )
        {
            idDabPresetList.source = "../component/DAB/PresetList/DABPresetList.qml";
        }
        idDabPresetList.item.initialize();
        idDabPresetList.visible = true;
        idDabPresetList.focus = true;
        break;

    case "DabPresetSavedPopup":
        console.log("[QML] DABPresetSavedPopup.qml Loader !! status = " + idDabPresetSavedPopup.status )
        if( idDabPresetSavedPopup.status == Loader.Null )
        {
            idDabPresetSavedPopup.source = "../component/DAB/PresetList/DABPresetSavedPopup.qml";
        }
        idDabPresetSavedPopup.item.initialize();
        idDabPresetSavedPopup.visible = true;
        idDabPresetSavedPopup.focus = true;
        break;

    case "DabENGMode":
        console.log("[QML] ENGModeMain.qml Loader !! status = " + idDabENGModeMain.status )
        if( idDabENGModeMain.status == Loader.Null )
        {
            idDabENGModeMain.source = "../component/DAB/ENGMode/ENGModeMain.qml";
        }
        idDabENGModeMain.visible = true;
        idDabENGModeMain.focus = true;
        break;

    case "DabENGDealerMode":
        console.log("[QML] ENGDealerMode.qml Loader !! status = " + idDabENGDealerMode.status )
        if( idDabENGDealerMode.status == Loader.Null )
        {
            idDabENGDealerMode.source = "../component/DAB/ENGMode/ENGDealerMode.qml";
        }
        idDabENGDealerMode.visible = true;
        idDabENGDealerMode.focus = true;
        break;

    case "DabInfoEPGPreserveOffAirPopup":
        console.log("[QML] DabInfoEPGPreserveOffAirPopup.qml Loader !! status = " + idDabInfoEPGPreserveOffAirPopup.status )
        if( idDabInfoEPGPreserveOffAirPopup.status == Loader.Null )
        {
            idDabInfoEPGPreserveOffAirPopup.source = "../component/DAB/Info/DABInfoEPGPreserveOffAirPopup.qml";
        }
        idDabInfoEPGPreserveOffAirPopup.visible = true;
        idDabInfoEPGPreserveOffAirPopup.focus = true;
        break;

    default: {
        idAppMain.state = "DABPlayerMain";

        if( idDabPlayerMain.status == Loader.Null )
        {
            idDabPlayerMain.source = "../component/DAB/PlayingScreen/DABPlayerMain.qml";
            idDabPlayerMain.visible = true;
            idDabPlayerMain.focus = true;
        }
        else
        {
            idDabPlayerMain.visible = true;
            idDabPlayerMain.focus = true;
        }
        break;
    }
    }

    console.log("[QML] Current Stack Count : " + getCurrentStackCount());
}

//# DAB Setting Screen Change - KEH (20130115)
function setSettingScreenChanges(selectedSettingScreen)
{
    console.debug("[DabOperation.js] setSettingScreenChanges - selectedSettingScreen : " +  selectedSettingScreen)

    switch(idDabSetting.state)
    {
        case "DabSetting_SlideShow":
            idDabSetting_SlideShow.visible = false;
            break;

        case "DabSetting_ServiceFollowing":
            idDabSetting_ServiceFollowing.visible = false;
            break;

        case "DabSetting_BandSelection":
            idDabSetting_BandSelection.visible = false;
            break;

        default:
            console.log(" (setSettingScreenChanges) ============== Error!!");
            break;
    }

    idDabSetting.state = selectedSettingScreen;

    switch(selectedSettingScreen)
    {        
        case "DabSetting_SlideShow":
            console.log("[QML]>> DabSetting_SlideShow.qml Loader !! status = " + idDabSetting_SlideShow.status )
            if( idDabSetting_SlideShow.status == Loader.Null )
            {
                idDabSetting_SlideShow.source = "DABSetting_SlideShow.qml";
            }
            idDabSetting_SlideShow.visible = true;
            break;

        case "DabSetting_ServiceFollowing":
            console.log("[QML] DabSetting_ServiceFollowing.qml Loader !! status = " + idDabSetting_ServiceFollowing.status )
            if( idDabSetting_ServiceFollowing.status == Loader.Null )
            {
                idDabSetting_ServiceFollowing.source = "DABSetting_ServiceFollowing.qml";
            }
            idDabSetting_ServiceFollowing.visible = true;
            break;

        case "DabSetting_BandSelection":
            console.log("[QML] DabSetting_BandSelection.qml Loader !! status = " + idDabSetting_BandSelection.status )
            if( idDabSetting_BandSelection.status == Loader.Null )
            {
                idDabSetting_BandSelection.source = "DABSetting_BandSelection.qml";
            }
            idDabSetting_BandSelection.visible = true;
            break;

        default: {
            idAppMain.state = "DabSetting_SlideShow";
            if( idDabSetting_SlideShow.status == Loader.Null )
            {
                idDabSetting_SlideShow.source = "DABSetting_SlideShow.qml";
                idDabSetting_SlideShow.visible = true;
                idDabSetting_SlideShow.focus = true;
            }
            else
            {
                idDabSetting_SlideShow.visible = true;
                idDabSetting_SlideShow.focus = true;
            }
            break;
        }
    }
}

function backKeyProcessing() {
    console.debug("[QML] DabOperation.js : backKeyProcessing : idAppMain.state: "+idAppMain.state + ", idAppMain.inputMode = " + idAppMain.inputMode)
    switch(idAppMain.state)
    {
    case "DABPlayerMain":
        UIListener.HandleBackKey(idAppMain.inputMode);
        break;

    default:
        setAppMainScreen(preSelectedMainScreen(), false);
        break;
    }
}

function getLogoImage(ptyNum)
{
    /* Image Logo  Priority is,
    * 1. Service Logo
    * 2. PTY Image
    * 3. Default DAB logo
    */
    //  define PTY Image

    var ptyImage = [ imageInfo.imgBgStationDefaultLogo,     // Default Image
                    imageInfo.imgIcoPty_1,                  // 1. New
                    imageInfo.imgIcoPty_2,                  // 2. Current Affairs
                    imageInfo.imgIcoPty_3,                  // 3. Information
                    imageInfo.imgIcoPty_4,                  // 4. Sport
                    imageInfo.imgIcoPty_5,                  // 5. Education
                    imageInfo.imgIcoPty_6,                  // 6. Drama
                    imageInfo.imgIcoPty_2,                  // 7. Culture
                    imageInfo.imgIcoPty_7,                  // 8. Science
                    imageInfo.imgIcoPty_8,                  // 9. Varied
                    imageInfo.imgIcoPty_9,                  // 10. Pop Music
                    imageInfo.imgIcoPty_10,                 // 11. Rock Music
                    imageInfo.imgIcoPty_11,                 // 12. Easy Listening Music
                    imageInfo.imgIcoPty_12,                 // 13. Light Classical Music
                    imageInfo.imgIcoPty_12,                 // 14. Serious Classical Music
                    imageInfo.imgIcoPty_11,                 // 15. Other Music
                    imageInfo.imgIcoPty_13,                 // 16. Weather
                    imageInfo.imgIcoPty_14,                 // 17. Finance
                    imageInfo.imgIcoPty_15,                 // 18. Children Program
                    imageInfo.imgIcoPty_2,                  // 19. Social Affairs
                    imageInfo.imgIcoPty_16,                 // 20. Religion
                    imageInfo.imgIcoPty_17,                 // 21. Phone In
                    imageInfo.imgIcoPty_18,                 // 22. Travel
                    imageInfo.imgIcoPty_19,                 // 23. Leisure
                    imageInfo.imgIcoPty_20,                 // 24. Jazz Music
                    imageInfo.imgIcoPty_21,                 // 25. Country Music
                    imageInfo.imgIcoPty_11,                 // 26. National Music
                    imageInfo.imgIcoPty_11,                 // 27. Oldies Music
                    imageInfo.imgIcoPty_22,                 // 28. Folk Music
                    imageInfo.imgIcoPty_2,                  // 29. Documentary
                    imageInfo.imgIcoPty_23,                 // 30. Alarm Test
                    imageInfo.imgIcoPty_23,                 // 31. Alarm
        ]

    console.log("[QML] DabOperation.js : getLogoImage : ptyNum = " + ptyNum + ", m_sChannelLogo = " + idAppMain.m_sChannelLogo)

    if(ptyNum == 255) return imageInfo.imgBgStationDefaultLogo;

    return ptyImage[ptyNum];
}

function checkProgramType(ptyNum)
{
    console.log("[QML] DabOperation.js : checkProgramType : ptyNum = " + ptyNum )
    if(ptyNum == 0 || ptyNum == 255)
        return false;
    else
        return true;
}

function getProgramTypeName(ptyNum){
    var names = [  " "/*stringInfo.strPty_All_Category*/,
                 stringInfo.strPty_News,
                 stringInfo.strPty_Current_Affairs,
                 stringInfo.strPty_Information,
                 stringInfo.strPty_Sport,
                 stringInfo.strPty_Education,
                 stringInfo.strPty_Drama,
                 stringInfo.strPty_Culture,
                 stringInfo.strPty_Science,
                 stringInfo.strPty_Varied,
                 stringInfo.strPty_Pop_Music,
                 stringInfo.strPty_Rock_Music,
                 stringInfo.strPty_Easy_Listening_Music,
                 stringInfo.strPty_Light_Classical_Music,
                 stringInfo.strPty_Serious_Classical_Music,
                 stringInfo.strPty_Other_Music,
                 stringInfo.strPty_Weather,
                 stringInfo.strPty_Finance,
                 stringInfo.strPty_Children_program,
                 stringInfo.strPty_Social_Affairs,
                 stringInfo.strPty_Religion,
                 stringInfo.strPty_Phone_In,
                 stringInfo.strPty_Travel,
                 stringInfo.strPty_Leisure,
                 stringInfo.strPty_Jazz_Music,
                 stringInfo.strPty_Country_Music,
                 stringInfo.strPty_National_Music,
                 stringInfo.strPty_Oldies_Music,
                 stringInfo.strPty_Folk_Music,
                 stringInfo.strPty_Documentary,
                 stringInfo.strPty_Alarm_Test,
                 stringInfo.strPty_Alarm];

    if(ptyNum == 255) return " "
    return names[ptyNum];
}

function settingSaveData()
{
    cmdSettingSaveData();
    console.log("[QML] DabOperation.js : settingSaveData")
    gotoBackScreen();
}

// =================== QML --> QT Command Transprent
function CmdReqListSelected(listNumber, type)
{
    cmdReqListSelected(listNumber, type);
}

function CmdReqScan()
{
    cmdReqScan();   
    idDabPlayerMain.item.bandFocusPosition();
    //if(idAppMain.m_bListScanningOn) idDabPlayerMain.item.bandFocusPosition();
}

function CmdReqPresetScan()
{
    cmdReqPresetScan();
    idDabPlayerMain.item.bandFocusPosition();
   // if(idAppMain.m_bPresetScanningOn) idDabPlayerMain.item.bandFocusPosition();
}

function CmdSettingSlideShow(value)
{
    console.log("[QML]  DabOperation.js : CmdSettingSlideShow Called. : value = " + value);
    cmdSettingSlideShow(value);
}

function CmdSettingServiceFollowing(value)
{
    console.log("[QML]  DabOperation.js : CmdSettingServiceFollowing Called. : value = " + value);
    cmdSettingServiceFollowing(value);
}

function CmdSettingBandSelection(value)
{
    console.log("[QML]  DabOperation.js : CmdSettingBandSelection : value = " + value);
    cmdSettingBandSelection(value);
}

function CmdReqPresetSelected(presetNumber)
{
    cmdReqPresetSelected(presetNumber);
}

function CmdReqSoundSetting(isJogMode)
{   
    cmdSoundSetting(isJogMode);
}

function CmdAddEPGReservation(currentDate, serviceName, serviceID, title, description, hour, minute, second, duration)
{
    cmdAddEPGReservation(currentDate, serviceName, serviceID, title, description, hour, minute, second, duration);
}

function CmdAddRemoveEPGReservation(currentDate, serviceName, serviceID, title, description, hour, minute, second, duration)
{
    cmdAddRemoveEPGReservation(currentDate, serviceName, serviceID, title, description, hour, minute, second, duration);
}

function CmdSetCurrentChannelInfo(serviceID)
{
    cmdReqSetCurrentChannelInfo(serviceID);
}

function CmdSettingDyanmicRangeControl(value)
{
    cmdSettingDyanmicRangeControl(value);
}

function updatePresetList(currIndex, realIndex)
{
    console.log("[QML]  DabOperation.js : updatePresetList : currIndex = " + currIndex + " realIndex = " + realIndex);
    cmdReqUpdatePresetList(currIndex, realIndex);
}

function checkExistRevervationList(curentDate, serviceID, hour, minute, second)
{
    console.log("[QML]  DabOperation.js : checkExistRevervationList : serviceID = " + serviceID);
    cmdCheckExistServiceID(curentDate, serviceID, hour, minute, second);
}

function CmdCancelEPGReservation(serviceID)
{
    console.log("[QML]  DabOperation.js : CmdCancelEPGReservation : serviceID = " + serviceID);
    cmdCancelEPGReservation(false);
}

function CmdReqSeekCancel()
{
    console.log("[QML]  DabOperation.js : CmdReqSeekCancel");
    cmdReqSeekCancel();
}

function CmdReqAnnouncementStop(m_AnnouncementFlags, onOff)
{
    if(m_AnnouncementFlags == 1)
    {
        cmdReqCancelAlarmAnnouncement();
        cmdReqAlarmStop();
    }
    else
    {
        cmdReqCancelTrafficAnnouncement(onOff);
        cmdReqTAStop();
    }
}


// =================== For Debugging
function DebugViewOnOff()
{
    idAppMain.m_bDebugViewOn = (idAppMain.m_bDebugViewOn)?false:true;
}

function checkService(value)
{
    if(value == "Weak")
        return "<font color=red>" + value + "</font>";
    else
        return "<font color=green>" + value + "</font>";
}

function checkPrimaryService(value)
{
    if(value == 0x00)
        return "<font color=red>" + "Secondary Service" + "</font>";
    else
        return "<font color=green>" + "Primary Service" + "</font>";
}

function checkCER(value)
{
    if( value < 200)
        return "<font color=green>" + value + "</font>";
    else if(value < 500)
        return "<font color=yellow>" + value + "</font>";
    else if(value < 800)
        return "<font color=orange>" + value + "</font>";
    else
        return "<font color=red>" + value+ "</font>";
}

function checSNR(value)
{
    if( value < 5)
        return "<font color=red>" + value + "</font>";
    else if(value < 10)
        return "<font color=orange>" + value + "</font>";
    else if(value < 15)
        return "<font color=yellow>" + value + "</font>";
    else
        return "<font color=green>" + value+ "</font>";
}

function checRSSI(value)
{
    if( value < 5)
        return "<font color=red>" + value + "</font>";
    else if(value < 30)
        return "<font color=orange>" + value + "</font>";
    else if(value < 65)
        return "<font color=yellow>" + value + "</font>";
    else
        return "<font color=green>" + value+ "</font>";
}

function checkCERSub(value)
{
    if( value < 200)
        return "<font color=green>" + value + "</font>";
    else if(value < 500)
        return "<font color=yellow>" + value + "</font>";
    else if(value < 800)
        return "<font color=orange>" + value + "</font>";
    else
        return "<font color=red>" + value+ "</font>";
}

function checSNRSub(value)
{
    if( value < 5)
        return "<font color=red>" + value + "</font>";
    else if(value < 10)
        return "<font color=orange>" + value + "</font>";
    else if(value < 15)
        return "<font color=yellow>" + value + "</font>";
    else
        return "<font color=green>" + value+ "</font>";
}

function checRSSISub(value)
{
    if( value < 5)
        return "<font color=red>" + value + "</font>";
    else if(value < 30)
        return "<font color=orange>" + value + "</font>";
    else if(value < 65)
        return "<font color=yellow>" + value + "</font>";
    else
        return "<font color=green>" + value+ "</font>";
}

function checkSignalStatus(value)
{
    if(value == 0)
        return "<font color=green>" + "GOOD" + "</font>";
    else if(value == 1)
        return "<font color=yellow>" + "NO GOOD" + "</font>";
    else if(value == 2)
        return "<font color=red>" + "BAD" + "</font>";
    else if(value == 3)
        return "<font color=orange>" + "None" + "</font>";
}

function checkMode(value)
{
    if(value == true)
        return "<font color=red>" + "view mode" + "</font>";
    else
        return "<font color=green>" + "normal mode" + "</font>";
}

function checkGoodCount(count)
{
//    var value = count/2;
//    if (value.toString().indexOf(".") >=0)
//        return "<font color=orange>" + parseInt(value) + "</font>";
//    else
        return "<font color=orange>" + count + "</font>";
}

function checkReqMicomCount(count)
{
    return "<font color=orange>" + count + "</font>";
}

function checkFMSensitivity(value)
{
    if(value == 0x02)
        return "<font color=green>" + "Good" + "</font>";
    else if(value == 0x01)
        return "<font color=red>" + "Bad" + "</font>";
    else if(value == 0x03)
        return "<font color=purple>" + "Audio Path is not DAB" + "</font>";
    else if(value == 0x04)
        return "<font color=yellow>" + "FM Weak" + "</font>";
    else if(value == 0x05)
        return "<font color=yellow>" + "FM Co-Channel" + "</font>";
    else
        return "<font color=orange>" + "FM not available" + "</font>";
}

function checkIntervalCount(count)
{
    return "<font color=green>" + count + "</font>";
}

function checkServiceFolloingStatus(value)
{
    if(value == 0)
        return "<font color=green>" + "OFF" + "</font>";
    else if(value == 1)
        return "<font color=green>" + "DABtoDAB" + "</font>";
    else if(value == 2)
        return "<font color=green>" + "DABtoFM" + "</font>";
    else if(value == 3)
        return "<font color=green>" + "On" + "</font>";
}
