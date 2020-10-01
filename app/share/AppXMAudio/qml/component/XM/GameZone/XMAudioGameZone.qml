/**
 * FileName: RadioMain.qml
 * Author: HYANG
 * Time: 2012-02
 *
 * - 2012-02 Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MComponent {
    id: idRadioGameZoneQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    //************************************************************************* # Property, State #
    state: (idAppMain.gDriverRestriction == false) ? "LIVE" : "LIVEDRIVERRESTRICTION"

    property string sxm_gamezone_curlist: "left" //"right"
    property string sxm_gamezone_currcat : stringInfo.sSTR_XMRADIO_All_CHANNELS
    property string sxm_gamezone_currchn : ""
    property int    sxm_gamezone_catindex : 0
    property int    sxm_gamezone_chnindex : 0
    property Item topBand: idRadioGameZoneBand
    property bool changeCategoryInGameZoneByTimer: false

    //****************************** # SXM Radio - Title area #
    MComp.MBigBand {
        id: idRadioGameZoneBand
        x: 0; y: 0

        //****************************** # Tab button OFF #
        tabBtnFlag: true
        tabBtnCount: 3
        tabBtnText: stringInfo.sSTR_XMRADIO_LIVE
        tabBtnText2: stringInfo.sSTR_XMRADIO_SET_TEAM
        tabBtnText3: stringInfo.sSTR_XMRADIO_ACTIVE
        selectedBand: stringInfo.sSTR_XMRADIO_LIVE
        tabBtnSendTextSize: XMOperation.checkFranceLanguage();

        //****************************** # button clicked or key selected #
        onTabBtn1Clicked: {
            giveForceFocus(1);
        }
        onTabBtn2Clicked: {
            stopGameZoneCategoryListTimerOnly();
            giveForceFocus(1);
            UIListener.HandleSetXMDataRequestToGameZone(false);
            setAppMainScreen("AppRadioGameSet", false);
        }
        onTabBtn3Clicked: {
            stopGameZoneCategoryListTimerOnly();
            giveForceFocus(1);
            UIListener.HandleSetXMDataRequestToGameZone(false);
            setAppMainScreen("AppRadioGameActive", false);
        }

        onBackBtnClicked: {
            giveForceFocus(1);
            setGameZoneClose();
            UIListener.HandleSetXMDataRequestToGameZone(false);
            setAppMainScreen( "AppRadioMain" , false);
        }

        Keys.onPressed: {
            if(event.key == Qt.Key_Down)
            {
                if(idAppMain.gDriverRestriction == true)
                {
                    idRadioGameZoneBand.focus = true;
                }
                else
                {
                    if((idRadioGameZoneChannelList.gameZoneChannelListCount == 0) && (idRadioGameZoneCategoryList.gameZoneCategoryListCount == 0))
                        idRadioGameZoneBand.focus = true;
                    else
                        changeFocusToChannelListPosition();
                }
            }
        }

        onTuneLeftKeyPressed: {
            if(idRadioGameZoneBand.activeFocus)
            {
                if(idAppMain.gDriverRestriction == true)
                {
                    idRadioGameZoneBand.focus = true;
                }
                else
                {
                    if(idAppMain.state == "AppRadioGameZone" && !(UIListener.HandleGetShowPopupFlag() == true))
                    {
                        changeFocusToChannelListOrBand();
                    }
                }
            }
        }
        onTuneRightKeyPressed: {
            if(idRadioGameZoneBand.activeFocus)
            {
                if(idAppMain.gDriverRestriction == true)
                {
                    idRadioGameZoneBand.focus = true;
                }
                else
                {
                    if(idAppMain.state == "AppRadioGameZone" && !(UIListener.HandleGetShowPopupFlag() == true))
                    {
                        changeFocusToChannelListOrBand();
                    }
                }
            }
        }
    }

    //****************************** # SXM Radio - Display Area #
    MComp.MComponent{
        id:idRadioGameZoneDisplay
        focus: true;

        //****************************** # Background Image #
        Image{
            x: 0; y: systemInfo.titleAreaHeight; z: 0
            visible: true
            Image{
                source: imageInfo.imgFolderGeneral+"bg_menu_l.png"
                visible: (sxm_gamezone_curlist == "left") ? true : false
            }
            Image {
                source: imageInfo.imgFolderGeneral+"bg_menu_r.png"
                visible: (sxm_gamezone_curlist == "left") ? false : true
            }
        }
        Image{
            x: 0; y: systemInfo.titleAreaHeight; z: 0
            visible : true
            Image{
                x: 0; y: 0; z:1
                source: imageInfo.imgFolderGeneral+"bg_menu_l_s.png"
                visible: (sxm_gamezone_curlist == "left") ? true : false
            }
            Image {
                x:585; y:0; z:5
                source: imageInfo.imgFolderGeneral+"bg_menu_r_s.png"
                visible: (sxm_gamezone_curlist == "left") ? false : true
            }
        }

        //****************************** # Category List #
        XMAudioGameZoneCategoryList{
            id: idRadioGameZoneCategoryList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9
            width: 585; height: systemInfo.contentAreaHeight-19

            Keys.onPressed: {
                if(event.key == Qt.Key_Right)
                {
                    if(idRadioGameZoneChannelList.gameZoneChannelListCount > 0)
                    {
                        if(idRadioGameZoneCategoryList.movementStartedGameZoneCategoryFlag == true)
                            idRadioGameZoneCategoryList.movementStartedGameZoneCategoryFlag = false;

                        stopGameZoneCategoryListTimer();
                    }
                    else
                    {
                        idRadioGameZoneDisplay.focus = true;
                        idRadioGameZoneCategoryList.focus = true;
                    }
                }
            }
            onActiveFocusChanged: { if(idRadioGameZoneCategoryList.activeFocus) sxm_gamezone_curlist = "left"; }
        }

        //****************************** # Channel List #
        XMAudioGameZoneChannelList {
            id: idRadioGameZoneChannelList
            x: 698; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9
            width: systemInfo.lcdWidth-698; height: systemInfo.contentAreaHeight-19
            focus: true

            KeyNavigation.left: idRadioGameZoneCategoryList
            onActiveFocusChanged: { if(idRadioGameZoneChannelList.activeFocus) sxm_gamezone_curlist = "right"; }
        }

        //****************************** # Visual Cue - list #
        MComp.MVisualCue{
            id: idMVisualCue
            x: 560; y: 357-systemInfo.statusBarHeight; z: 10
            arrowUpFlag: idRadioGameZoneCategoryList.activeFocus || idRadioGameZoneChannelList.activeFocus ? true:false
            arrowDownFlag: idRadioGameZoneBand.activeFocus ? (idRadioGameZoneCategoryList.gameZoneCategoryListCount == 0) ? false : true : false
            arrowRightFlag: idRadioGameZoneCategoryList.activeFocus ? (idRadioGameZoneChannelList.gameZoneChannelListCount == 0) ? false : true : false
            arrowLeftFlag: idRadioGameZoneChannelList.activeFocus ? true:false
        }
    }

    MComp.MComponent{
        id: idRadioGameZoneDriverRestrictionDisplay

        //Driver Restriction
        XMAudioGameZoneDriverRestriction {
            id: idRadioGameZoneDriverRestrictionList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
        }
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        setGameZoneClose();
        UIListener.HandleSetXMDataRequestToGameZone(false);
        setAppMainScreen( "AppRadioMain" , false);
    }
    /* CCP Home Key */
    onHomeKeyPressed: {
        setGameZoneClose();
        UIListener.HandleSetXMDataRequestToGameZone(false);
        UIListener.HandleHomeKey();
    }

    onVisibleChanged: {
        if(visible)
        {
            if(idAppMain.gDriverRestriction == true)
            {
                idRadioGameZoneBand.giveForceFocus(1);
                idRadioGameZoneBand.focus = true;
            }
            else
            {
                changeGameZoneCateogy(gGameZoneCatIndex);
                idRadioGameZoneBand.tabBtnSendTextSize = XMOperation.checkFranceLanguage();

                if((idRadioGameZoneChannelList.gameZoneChannelListCount == 0) && (idRadioGameZoneCategoryList.gameZoneCategoryListCount == 0))
                {
                    idRadioGameZoneBand.focus = true;
                }
                else
                {
                    changeFocusToChannelList();
                }
            }
        }
        else
        {
            sxm_gamezone_catindex = -1;
            idAppMain.gGameZoneCatIndex = 0;
        }
    }

    onStateChanged: {
        if(!visible) return;

        if(idAppMain.gDriverRestriction == true)
        {
            if(!idRadioGameZoneBand.activeFocus)
                idRadioGameZoneBand.giveForceFocus(7);
            idRadioGameZoneBand.focus = true;
        }
    }

    //****************************** # Function #
    function setGameZoneClose()
    {
        idRadioGameZone.visible = false;
        idRadioGameZoneCategoryList.stopGameZoneCategoryTimer();
        UIListener.HandleSetTuneKnobKeyOperation(0);
        UIListener.HandleSetSeekTrackKeyOperation(0);
    }

    function stopGameZoneCategoryListTimer()
    {
        idRadioGameZoneCategoryList.stopGameZoneCategoryTimer();
        if(idRadioGameZoneCategoryList.aGAMEZONECategoryListModel.currentIndex != sxm_gamezone_catindex)
        {
            sxm_gamezone_catindex = idRadioGameZoneCategoryList.aGAMEZONECategoryListModel.currentIndex;
            changeGameZoneCateogy(sxm_gamezone_catindex);
            changeFocusToChannelList();
        }
        else
        {
            if(changeCategoryInGameZoneByTimer == true)
            {
                changeCategoryInGameZoneByTimer = false;
                changeFocusToChannelList();
            }
            else
            {
                changeFocusToChannelListPosition();
            }
        }
    }

    function stopGameZoneCategoryListTimerOnly()
    {
        idRadioGameZoneCategoryList.stopGameZoneCategoryTimer();
    }

    function setGameZoneCategory(category)
    {
        sxm_gamezone_currcat = category;
    }

    function setGameZoneChannel(channel)
    {
        sxm_gamezone_currchn = channel;
    }

    function changeGameZoneCateogy(category)
    {
        gGameZoneCatIndex = category;
        sxm_gamezone_chnindex = 0;
        sxm_gamezone_catindex = category;
        idRadioGameZoneChannelList.changeCategory(category);
        changeFocusToChannelListReset();
    }

    function changeFocusToChannelListReset()
    {
        idRadioGameZoneChannelList.onGameZoneChannelInitPos(true);
    }

    function changeFocusToChannelList()
    {
        if((idRadioGameZoneChannelList.gameZoneChannelListCount == 0) && (idRadioGameZoneCategoryList.gameZoneCategoryListCount == 0))
        {
            idRadioGameZoneBand.focus = true;
        }
        else
        {
            if(idRadioGameZoneChannelList.gameZoneChannelListCount > 0)
            {
                idRadioGameZoneChannelList.onGameZoneChannelInitPos(false);

                idRadioGameZoneDisplay.focus = true;
                idRadioGameZoneChannelList.forceActiveFocus();
            }
            else
            {
                idRadioGameZoneDisplay.focus = true;
                idRadioGameZoneCategoryList.forceActiveFocus();
            }
        }
    }

    function changeFocusToChannelListPosition()
    {
        if((idRadioGameZoneChannelList.gameZoneChannelListCount == 0) && (idRadioGameZoneCategoryList.gameZoneCategoryListCount == 0))
        {
            idRadioGameZoneBand.focus = true;
        }
        else
        {
            if(idRadioGameZoneChannelList.gameZoneChannelListCount > 0)
            {
                idRadioGameZoneChannelList.onGameZoneChannelPosUpdate();

                idRadioGameZoneDisplay.focus = true;
                idRadioGameZoneChannelList.forceActiveFocus();
            }
            else
            {
                idRadioGameZoneDisplay.focus = true;
                idRadioGameZoneCategoryList.forceActiveFocus();
            }
        }
    }

    function changeFocusToChannelListOrBand()
    {
        if(idRadioGameZoneChannelList.gameZoneChannelListCount > 0)
        {
            idRadioGameZoneChannelList.onGameZoneChannelPosUpdate();

            idRadioGameZoneDisplay.focus = true;
            idRadioGameZoneChannelList.forceActiveFocus();
        }
        else
        {
            idRadioGameZoneBand.focus = true;
        }
    }

    function setGameZoneTuneEnter()
    {
        if(idRadioGameZoneChannelList.gameZoneChannelListCount > 0)
            idRadioGameZoneChannelList.setGameZoneChListTuneEnter();
    }
    function setGameZoneTuneLeft()
    {
        if(idRadioGameZoneChannelList.gameZoneChannelListCount > 0)
            idRadioGameZoneChannelList.setGameZoneChListTuneLeft();
    }
    function setGameZoneTuneRight()
    {
        if(idRadioGameZoneChannelList.gameZoneChannelListCount > 0)
            idRadioGameZoneChannelList.setGameZoneChListTuneRight();
    }

    //************************************************************************* # Timer #
    Timer {
        id: changeGameZoneCategoryTimer
        interval: 250
        running: false
        repeat: false
        onTriggered: idRadioGameZoneCategoryList.changeGameZoneCategoryList();
    }
    
    states: [
        State{
            name: "LIVE"
            PropertyChanges{target: idRadioGameZoneDriverRestrictionDisplay; opacity: 0;}
            PropertyChanges{target: idRadioGameZoneDisplay; opacity: 1;}
        },
        State{
            name: "LIVEDRIVERRESTRICTION"
            PropertyChanges{target: idRadioGameZoneDisplay; opacity: 0;}
            PropertyChanges{target: idRadioGameZoneDriverRestrictionDisplay; opacity: 1;}
        }
    ]

    transitions: [
        Transition{
            ParallelAnimation{ PropertyAnimation{properties: "opacity"; duration: 0; easing.type: "InCubic"} }
        }
    ]
}
