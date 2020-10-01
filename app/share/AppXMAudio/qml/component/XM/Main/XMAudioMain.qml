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
    id: idRadioMainQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    //************************************************************************* # Property #
    property string sxm_main_curlist: "left" //"right"
    property Item topBand: idRadioMainBand

    property string bandSignalTextColor: colorInfo.blue
    
    //************************************************************************* # Background Image #
    Image{
        x: 0; y: systemInfo.titleAreaHeight; z: 0
        visible: true
        Image{
            x: 0; y: 0; z:0
            source: imageInfo.imgFolderRadio_Hd+"bg_menu_l.png"
            visible: (idRadioMainQml.sxm_main_curlist == "left") ? true : false
        }
        Image {
            x:0; y:0; z:100
            source: imageInfo.imgFolderRadio_Hd+"bg_menu_r.png"
            visible: (idRadioMainQml.sxm_main_curlist == "left") ? false : true
        }
    }
    //************************************************************************* # Background Selected Image #
    Image{
        x: 0; y: systemInfo.titleAreaHeight; z: 0
        visible: true
        Image{
            x: 0; y: 0; z:20
            source: imageInfo.imgFolderRadio_Hd+"bg_menu_l_s.png"
            visible: (idRadioMainQml.sxm_main_curlist == "left") ? true : false
        }
        Image {
            x:477; y:0; z:100
            source: imageInfo.imgFolderRadio_Hd+"bg_menu_r_s.png"
            visible: (idRadioMainQml.sxm_main_curlist == "left") ? false : true
        }
    }

    //************************************************************************* # Title Area #
    MComp.MBand{
        id: idRadioMainBand
        x: 0; y: 0

        // Select Button - Text
        selectedBand: stringInfo.sSTR_XMRADIO_SIRIUSXM
        tabBtnFlag: true
        tabBtnCount: 3
        tabBtnText: stringInfo.sSTR_XMRADIO_FM
        tabBtnText2: stringInfo.sSTR_XMRADIO_AM
        tabBtnText3: stringInfo.sSTR_XMRADIO_SIRIUSXM
        // "Acquiring Signal" message
        signalTextFlag: false
        signalTextX: 555
        signalTextY: 19
        signalTextSize: 24
        signalTextWidth: 150
        signalTextAlies: "Right"
        signalText2Line: true
        signalTextColor: bandSignalTextColor
        signalText: stringInfo.sSTR_XMRADIO_ACQUIRING_SIGNAL
        // Tag button
        reserveBtnFlag: true
        reserveBtnText: stringInfo.sSTR_XMRADIO_TAG
        // List button
        subBtnFlag: true
        subBtnText: stringInfo.sSTR_XMRADIO_UPPERLIST
        // Menu button
        menuBtnFlag: true
        menuBtnText: stringInfo.sSTR_XMRADIO_MENU

        onTabBtn1Clicked: {
            XMOperation.setPreviousScanStop();
            UIListener.HandleFMKey();
            selectedBand = tabBtnText3;
        }
        onTabBtn2Clicked: {
            XMOperation.setPreviousScanStop();
            UIListener.HandleAMKey();
            selectedBand = tabBtnText3;
        }
        onTabBtn3Clicked: {
            selectedBand = tabBtnText3;
        }
        onReserveBtnClicked: {
            XMOperation.setPreviousScanStop();
            UIListener.HandleTagSong();
        }
        onSubBtnClicked: {
            XMOperation.setPreviousScanStop();
            idAppMain.optionMenuAllOff();
            setAppMainScreen( "AppRadioList" , false);
        }
        onMenuBtnClicked: {
            idAppMain.optionMenuAllOff();
            if (idRadioDisplayButton.activeFocus == false && idRadioPresetList.movementStartedPresetListFlag == false)
                initForFocus(true);
            setAppMainScreen( "AppRadioOptionMenu" , true);
        }
        onBackBtnClicked: {
            if(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")
            {
                console.log("### gSXMEditPresetOrder###")
                XMOperation.setPreviousPresetSaveAndOrderStop();
                idAppMain.presetOrderDisabled();

                // ITS #194329 Focus initialization
                var idxPreset = UIListener.HandleGetPresetSelected();
                if(idxPreset >= 0)
                {
                    idRadioMainDisplay.focus = true;
                    idRadioPresetList.focus = true;
                    idRadioPresetList.presetList.currentIndex = idxPreset;
                    idRadioPresetList.onPresetListReInit(true, false);
                }
                else
                {
                    idRadioMainDisplay.focus = true;
                    idRadioDisplayButton.focus = true;
                    idRadioDisplayChannelBtn.focus = true;
                }
            }
            else
            {
                idAppMain.gotoBackScreen(bTouchBack);
            }
        }

        KeyNavigation.down: (PLAYInfo.ChnNum == "") ? idRadioMainBand : idRadioMainDisplay

        onActiveFocusChanged: {
            if(idAppMain.gSXMEditPresetOrder == "TRUE" && idRadioMainBand.activeFocus == true)
            {
                console.log("Reorder Preset ----------------> ActiveFocusChanged : "+idRadioMainBand.focus+" : "+idRadioMainBand.activeFocus);
                idAppMain.presetOrderDisabledAndChangeOrder();
            }
        }
    }

    //************************************************************************* # Display Area #
    MComp.MComponent{
        id:idRadioMainDisplay
        focus: true;

        // Preset List
        XMAudioPresetList{
            id: idRadioPresetList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9; z: 10
            width: 503; height: systemInfo.contentAreaHeight-20
            focus: true

            KeyNavigation.right: (PLAYInfo.Advisory != "") || (idAppMain.gSXMEditPresetOrder == "TRUE") || (idAppMain.gSXMSaveAsPreset == "TRUE")
                                 || (PLAYInfo.ChnArt == "" && PLAYInfo.ChnNum == "" && PLAYInfo.ChnName == "" && PLAYInfo.PresetNum == "") ? idRadioPresetList : idRadioDisplayButton
            onActiveFocusChanged: { if(idRadioPresetList.activeFocus == true) idRadioMainQml.sxm_main_curlist = "left"; }
        }

        // Channel/Category/Instant Replay
        MComp.MComponent{
            id:idRadioDisplayButton

            // Display Mode
            XMAudioDisplayLiveMode {
                id: idRadioDisplayLiveMode
                x: 660; y: systemInfo.headlineHeight-systemInfo.statusBarHeight; z: 10
                channelNameActivFocus: idRadioDisplayChannelBtn.activeFocus
                textTickerInit : idRadioDisplayButton.visible
            }

            XMAudioDisplayChannelBtn {
                id: idRadioDisplayChannelBtn
                x: 660; y: systemInfo.headlineHeight-systemInfo.statusBarHeight; z: 5
                focus: true

                Keys.onPressed: {
                    if(event.key == Qt.Key_Up) setForceFocusChangeBand();
                    else if(event.key == Qt.Key_Left) idRadioMainQml.setPresetListSetting();
                }
                KeyNavigation.down: (PLAYInfo.ChnNum == "0" || PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? idRadioDisplayChannelBtn : idRadioDisplayCategoryBtn
            }

            XMAudioDisplayCategoryBtn {
                id: idRadioDisplayCategoryBtn
                x: 660; y: systemInfo.headlineHeight-systemInfo.statusBarHeight; z: 5

                KeyNavigation.up: (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? idRadioDisplayCategoryBtn : idRadioDisplayChannelBtn
                Keys.onPressed: {
                    if(event.key == Qt.Key_Left)
                        idRadioMainQml.setPresetListSetting();
                    else if(event.key == Qt.Key_Down)
                    {
                        if(idRadioDisplayInstantReplayBtn.checkFocusInstantReplayButton() == true)
                            idRadioDisplayInstantReplayBtn.setFocusInstantReplayButton();
                        else
                            idRadioDisplayCategoryBtn.focus = true;
                    }
                }
            }

            XMAudioDisplayInstantReplayBtn {
                id: idRadioDisplayInstantReplayBtn
                x: 660; y: systemInfo.headlineHeight-systemInfo.statusBarHeight; z: 5

                KeyNavigation.up: (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? idRadioDisplayInstantReplayBtn : idRadioDisplayCategoryBtn
                Keys.onPressed: {
                    if(event.key == Qt.Key_Left) idRadioMainQml.setPresetListSetting();
                }
            }

            onActiveFocusChanged: {
                if (idRadioDisplayButton.activeFocus == true)
                {
                    idRadioPresetList.setFlickStartTimerStop();
                    idRadioMainQml.sxm_main_curlist = "right";
                }
            }
            onVisibleChanged: {
                idRadioDisplayLiveMode.textTickerInit = visible;
            }
        }

        onSWRCSeekPrevLongKeyPressed: {
            idRadioMainDisplay.focus = true;
            idRadioDisplayButton.focus = true;
            idRadioDisplayChannelBtn.focus = true;
        }
        onSWRCSeekNextLongKeyPressed: {
            idRadioMainDisplay.focus = true;
            idRadioDisplayButton.focus = true;
            idRadioDisplayChannelBtn.focus = true;
        }
    }

    //****************************** # Visual Cue #
    MComp.MVisualCue{
        id: idMVisualCue
        x: 466; y: 364-systemInfo.statusBarHeight; z: 100
        arrowUpFlag: (idAppMain.state == "AppRadioOptionMenu") || (idAppMain.state =="AppRadioOptionMenuSub") ? false : idRadioPresetList.activeFocus || idRadioDisplayButton.activeFocus
        arrowDownFlag: (PLAYInfo.ChnNum == "") || (idAppMain.state == "AppRadioOptionMenu") || (idAppMain.state =="AppRadioOptionMenuSub") || (idRadioDisplayCategoryBtn.activeFocus == true && idRadioDisplayInstantReplayBtn.checkFocusInstantReplayButton() == false) || (idRadioDisplayChannelBtn.activeFocus && PLAYInfo.ChnNum == "0") || (idRadioDisplayChannelBtn.activeFocus && PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : idRadioMainBand.activeFocus || idRadioDisplayChannelBtn.activeFocus || idRadioDisplayCategoryBtn.activeFocus
        arrowLeftFlag: (idAppMain.state == "AppRadioOptionMenu") || (idAppMain.state =="AppRadioOptionMenuSub") ? false : idRadioMainBand.activeFocus || idRadioPresetList.activeFocus || (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")? false:true
        arrowRightFlag: (PLAYInfo.Advisory != "") ? false : (idAppMain.state == "AppRadioOptionMenu") || (idAppMain.state =="AppRadioOptionMenuSub") || idRadioMainBand.activeFocus || !(idRadioPresetList.activeFocus) || (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? false : true
    }

    onBackKeyPressed: {
        if(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")
        {
            XMOperation.setPreviousPresetSaveAndOrderStop();
            idAppMain.presetOrderDisabledByBackKey();

            // ITS #194329 Focus initialization
            var idxPreset = UIListener.HandleGetPresetSelected();
            if(idxPreset >= 0)
            {
                idRadioMainDisplay.focus = true;
                idRadioPresetList.focus = true;
                idRadioPresetList.presetList.currentIndex = idxPreset;
                idRadioPresetList.onPresetListReInit(true, false);
            }
            else
            {
                idRadioMainDisplay.focus = true;
                idRadioDisplayButton.focus = true;
                idRadioDisplayChannelBtn.focus = true;
            }
        }
        else
        {
            idAppMain.gotoBackScreen(false);
        }
    }
    onHomeKeyPressed: {
        UIListener.HandleHomeKey();
    }

    onClickMenuKey: {
        if(idAppMain.gSXMSaveAsPreset == "TRUE" || idAppMain.gSXMEditPresetOrder == "TRUE") return;

        if(!(gSXMPresetScan != "PresetScan" || gSXMScan != "Scan"))
            idRadioDisplayInstantReplayBtn.stopFFRewByReleased(); //ITS #0189872 (FF, REW stoped when pressed H/K MENU)

        idAppMain.checkInstantPlayStausMenu();
        if (idRadioDisplayButton.activeFocus == false && idRadioPresetList.movementStartedPresetListFlag == false)
            initForFocus(true);
        idAppMain.releaseTouchPressed();
        setAppMainScreen( "AppRadioOptionMenu" , true);
    }

    onVisibleChanged: {
        if(idRadioMainQml.visible)
            idRadioMainQml.initForFocus(false);
    }

    function setForceFocusChangeBand()
    {
        if(!PLAYInfo.EnableTagging)
        {
            if((idAppMain.gSXMEditPresetOrder == "TRUE") || (idAppMain.gSXMSaveAsPreset == "TRUE") || ((idAppMain.preMainScreen == "AppRadioMain") && (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE")))
                idRadioMainBand.giveForceFocus("menuBtn"); //go to 'MENU' button
            else
                idRadioMainBand.giveForceFocus("subBtn"); //go to 'List' button
        }
        else
        {
            idRadioMainBand.giveForceFocus("reserveBtm"); //go to 'Tag' button
        }

        idRadioMainBand.focus = true;
    }

    function setForceFocusEnterPresetOrderOrSave()
    {
        idRadioMainDisplay.focus = true;
        idRadioPresetList.setActiveFocus();
    }

    function setPresetListSetting()
    {
        idRadioMainDisplay.focus = true;
        idRadioPresetList.setActiveFocus();
    }

    function setFocusPresetScan()
    {
        idRadioMainDisplay.focus = true;
        idRadioPresetList.focus = true;
    }

    function setFocusScanAllChannels()
    {
        idRadioMainDisplay.focus = true;
        idRadioDisplayButton.focus = true;
        idRadioDisplayChannelBtn.focus = true;
    }

    function initForFocus(bMenuPosition)
    {
        if(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")
            return;

        idRadioMainBand.giveForceFocus(3);
        if (PLAYInfo.ChnNum == "")
        {
            idRadioMainBand.focus = true;
        }
        else
        {
            var idxPreset = UIListener.HandleGetPresetSelected();
            if((idxPreset >= 0) || (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE"))
            {
                idRadioMainDisplay.focus = true;
                idRadioPresetList.focus = true;
                idRadioDisplayChannelBtn.focus = true; // default idRadioDisplayChannelBtn focus(change or select channel)
                idRadioPresetList.presetList.currentIndex = idxPreset;
                idRadioPresetList.onPresetListReInit(true, bMenuPosition);
            }
            else
            {
                idRadioMainDisplay.focus = true;
                idRadioDisplayButton.focus = true;
                idRadioDisplayChannelBtn.focus = true;
            }
        }
    }

    function setForceFocusButton(szBtnName)
    {
        switch(szBtnName)
        {
        case "CategoryButton":
        {
            idRadioMainDisplay.focus = true;
            idRadioDisplayButton.focus = true;
            idRadioDisplayCategoryBtn.focus = true;
            break;
        }
        case "InstantReplayButton":
        {
            idRadioMainDisplay.focus = true;
            idRadioDisplayButton.focus = true;
            idRadioDisplayInstantReplayBtn.focus = true;
            break;
        }
        }
    }

    Connections{
        target: UIListener
        onInitForFocus : {
            idRadioMainQml.initForFocus(false);
        }
        onInitForPresetScanFocus: {
            var idxPreset = UIListener.HandleGetPresetSelected();
            if(idxPreset >= 0 /*&& idRadioPresetList.activeFocus*/)
            {
                idRadioMainDisplay.focus = true;
                idRadioPresetList.focus = true;
                idRadioPresetList.presetList.currentIndex = idxPreset;
                idRadioPresetList.onPresetListReInit(true, false);
                gSXMPresetScan = "PresetScan";
            }
            idAppMain.presetScanFont();
        }
        onFocusOnChannelInfo : {
            if(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")
                return;
            if(PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE")
                return;

            idRadioMainDisplay.focus = true;
            idRadioDisplayButton.focus = true;
            idRadioDisplayChannelBtn.focus = true;
        }
    }

    property int ffrew_time_interval : 2
    property int ffrew_direction : 1
    function onFastFFRewStart(direction)
    {
        ffrew_time_interval = 2;
        ffrew_direction = direction;
        ffrew_command_timer.start();
        ffrew_inerval_timer.start();
    }

    function onFastFFRewStop()
    {
        ffrew_command_timer.stop();
        ffrew_inerval_timer.stop();
    }

    Timer {
        id : ffrew_inerval_timer
        interval: 2000; running: false; repeat: true
        onTriggered:
        {
            ffrew_time_interval = ffrew_time_interval * 2;
            if(ffrew_time_interval>20) ffrew_time_interval = 20;
        }
    }

    Timer {
        id : ffrew_command_timer
        interval: 500; running: false; repeat: true
        onTriggered:
        {
            XMOperation.onPlaySeek(ffrew_time_interval*ffrew_direction);
        }
    }
}
