/**
 * FileName: RadioFmFrequencyDial.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MComponent {
    id: idRadioDisplayInstantReplayBtnQml
    x: 0; y: 0

    property bool instantReplayPressAndHoldFlag : false
    property bool iRPrevEnabled: idRadioInstantReplayPrev.mEnabled
    property bool iRPlayPauseEnabled: idRadioInstantReplayPause.mEnabled
    property bool iRNextEnabled: idRadioInstantReplayNext.mEnabled
    property bool iRNowEnabled: idRadioInstantReplayNow.mEnabled
    property bool nextbuttonlongstate: false
    property bool prevbuttonlongstate: false
    property int   playTimeOffset : PLAYInfo.nOffset

    //****************************** # Instant Replay Button #
    Item{
        id: idRadioInstantReplayDisplay
        x: 0; y: 438
        width: 539; height: 81
        visible:PLAYInfo.ChnNum != "0"

        //IR / Play time
        Image {
            id:idRadioInstantReplayIcon
            x: -114; y: 29
            width: 25; height: 23
            smooth: true
            fillMode: Image.PreserveAspectFit
            source: ((PLAYInfo.bPaused == false) || (idAppMain.gSXMPlayMode == "Play" && PLAYInfo.bPaused == true)) ? imageInfo.imgFolderRadio_SXM+"ico_replay.png" : imageInfo.imgFolderRadio_SXM+"ico_delay.png"
        }
        Text {
            id:idRadioInstantReplayTime
            x:-84; y:29+13-(font.pixelSize/2)
            width: 77; height: 25
            font.pixelSize: 25
            font.family : systemInfo.font_NewHDR
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            text : PLAYInfo.PlayTime
        }

        MComp.MButton{
            id: idRadioInstantReplayPrev
            x: 6; y: 0
            width: 107; height: 81
            visible: true

	    mEnabled: (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : ((PLAYInfo.nDuration == 0 && PLAYInfo.nOffset == 0) ? false : ((PLAYInfo.nDuration - PLAYInfo.nOffset) < 4) ? false : true)

            /* Button Setting */
            bgImage:(idRadioInstantReplayPrev.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_n.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            bgImagePress:(idRadioInstantReplayPrev.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_p.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            bgImageFocusPress:(idRadioInstantReplayPrev.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_fp.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            bgImageFocus:(idRadioInstantReplayPrev.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_f.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            fgImage: (idRadioInstantReplayPrev.mEnabled)? imageInfo.imgFolderRadio_SXM+"ico_prev_n.png" : imageInfo.imgFolderRadio_SXM+"ico_prev_d.png"
            fgImageX: 30
            fgImageY: 22
            fgImageWidth: 48
            fgImageHeight: 37

            onMEnabledChanged: {
                console.log("### onMEnabledChanged : Prev --> "+idRadioInstantReplayDisplay.activeFocus+" "+PLAYInfo.nOffset+" "+instantReplayPressAndHoldFlag+" "+idRadioInstantReplayPrev.mEnabled+" "+idRadioInstantReplayPrev.activeFocus+" "+idRadioInstantReplayPrev.focus);

                if(idRadioInstantReplayPrev.mEnabled) { iRPrevEnabled = true; }
                else
                {
                    iRPrevEnabled = false;
                    prevAllTimerStop();
                }

                if((idRadioInstantReplayPrev.mEnabled == false) && (instantReplayPressAndHoldFlag == true) && (PLAYInfo.nOffset >= 0))
                {
                    stopFFRewByReleased();

                    if(idAppMain.isJogEnterLongPressed == true)
                    {
                        idAppMain.isJogEnterLongPressed = false;
                        prevbuttonlongstate = true;
                    }
                }
                if((idRadioInstantReplayPrev.mEnabled == false) && idRadioInstantReplayPrev.activeFocus)
                {
                    idRadioInstantReplayPrev.focus = false;
                    setFocusInstantReplayButton();
                }
            }

            /* Button Action */
            onClickOrKeySelected: {
                console.log("### onClickOrKeySelected : Prev --> ")

                if(idAppMain.isJogEnterLongPressed == true)
                {
                    if(idRadioInstantReplayPrev.mEnabled == true)
                    {
                        console.log("Instant Replay = play mode(Selected Released)");
                        stopFFRewByReleased();
                    }
                }
                else
                {
                    if((idRadioInstantReplayPrev.mEnabled == true) && (instantReplayPressAndHoldFlag == false))
                    {
                        console.log("Instant Replay = play mode(RWD short tap)");
                        XMOperation.onPlaySeekSong(-1);
                    }
                }

                instantReplayPressAndHoldFlag = false;
                prevAllTimerStop();
                if(idRadioInstantReplayPrev.mEnabled == true)
                {
                    idRadioInstantReplayPrev.focus = true;
                }
                setForceFocusButton("InstantReplayButton");
            }
            onPressAndHold: {
                console.log("### onPressAndHold : Prev --> ")

                if(idRadioInstantReplayPrev.mEnabled == true && instantReplayPressAndHoldFlag == false)
                {
                    console.log("Instant Replay = play mode(RWD long tap)");
                    instantReplayPressAndHoldFlag = true;
                    onFastFFRewStart(-1);
                    prevLongTimer.start();
                }
            }
            onClickReleased: {
                console.log("### onClickReleased : Prev --> ")

                if(idRadioInstantReplayPrev.mEnabled == true && idAppMain.playBeepOn == true)
                {
                    console.log("Instant Replay = play mode(Selected Released)");
                    // TA Requirement
                    // 243 Replay_028 (B, C, D) ~ 028a
                    stopFFRewByReleased();
                }

                if(idRadioInstantReplayPrev.mEnabled == true)
                {
                    idRadioInstantReplayPrev.focus = true;
                }
                instantReplayPressAndHoldFlag = false;
                setForceFocusButton("InstantReplayButton");
            }
            //ITS #0194536, #0194562 Cancel Key
            onCancel: {
                console.log("### onCancel : Prev --> ")

                if(idRadioInstantReplayPrev.mEnabled == true && idAppMain.playBeepOn == true)
                {
                    stopFFRewByReleased();
                }
                if(idRadioInstantReplayPrev.mEnabled == true)
                {
                    idRadioInstantReplayPrev.focus = true;
                }
                prevLongTimer.stop();
                instantReplayPressAndHoldFlag = false;
                setForceFocusButton("InstantReplayButton");
            }

            /* Wheel Focus */
            onWheelRightKeyPressed: setFocusWheelRight(idRadioInstantReplayPrev);
        }

        MComp.MButton{
            id: idRadioInstantReplayPause
            x: 6+107; y: 0
            width: 107; height: 81
            visible: true
            focus: true

	    mEnabled: (PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE") ? false : ((PLAYInfo.nDuration > 0) ? true : false)

            /* Button Setting */
            bgImage:(idRadioInstantReplayPause.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_n.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            bgImagePress:(idRadioInstantReplayPause.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_p.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            bgImageFocusPress:(idRadioInstantReplayPause.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_fp.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            bgImageFocus: (idRadioInstantReplayPause.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_f.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            fgImage: ((PLAYInfo.bPaused == false) || (idAppMain.gSXMPlayMode == "Play" && PLAYInfo.bPaused == true)) ? ((idRadioInstantReplayPause.mEnabled)? imageInfo.imgFolderRadio_SXM+"ico_pause_n.png" : imageInfo.imgFolderRadio_SXM+"ico_pause_d.png") : ((idRadioInstantReplayPause.mEnabled)? imageInfo.imgFolderRadio_SXM+"ico_play_n.png" : imageInfo.imgFolderRadio_SXM+"ico_play_d.png")
            fgImageX: 30
            fgImageY: 22
            fgImageWidth: 48
            fgImageHeight: 37

            onMEnabledChanged: {
                console.log("### onMEnabledChanged : PlayPause --> "+idRadioInstantReplayDisplay.activeFocus+" "+PLAYInfo.nOffset+" "+instantReplayPressAndHoldFlag+" "+idRadioInstantReplayPause.mEnabled+" "+idRadioInstantReplayPause.activeFocus+" "+idRadioInstantReplayPause.focus);

                if(idRadioInstantReplayPause.mEnabled) { iRPlayPauseEnabled = true; }
                else { iRPlayPauseEnabled = false; }

                if((idRadioInstantReplayPause.mEnabled == false) && idRadioInstantReplayPause.activeFocus)
                {
                    setFocusInstantReplayButton();
                }
            }
            /* Button Action */
            onClickOrKeySelected: {
                console.log("### onClickOrKeySelected : PlayPause --> ")

                if (prevbuttonlongstate == false && nextbuttonlongstate == false)
                {
                    if(idAppMain.gSXMMode == "LiveMode")
                    {
                        idAppMain.gSXMMode = "InstantReplay";
                    }

                    onFastFFRewStop();
                    if(PLAYInfo.bPaused == true)
                    {
                        XMOperation.onPlay();
                    }
                    else
                    {
                        XMOperation.onPause();
                    }
                    idRadioInstantReplayPause.focus = true;
                    playpauseDimCheck();
                }

                setForceFocusButton("InstantReplayButton");
                prevbuttonlongstate = false;
                nextbuttonlongstate = false;
            }
            onCancel:
            {
                prevbuttonlongstate = false;
                nextbuttonlongstate = false;
            }

            /* Wheel Focus */
            onWheelLeftKeyPressed: setFocusWheelLeft(idRadioInstantReplayPause);
            onWheelRightKeyPressed: setFocusWheelRight(idRadioInstantReplayPause);
        }

        MComp.MButton{
            id: idRadioInstantReplayNext
            x: 6+107+107; y: 0
            width: 107; height: 81
            visible: true

            mEnabled: (((PLAYInfo.nOffset > 0) || (PLAYInfo.nOffset == 0 && prevLongTimer.running == true && instantReplayPressAndHoldFlag == true) || (PLAYInfo.bPaused != 0 && PLAYInfo.nOffset != 0)) && (PLAYInfo.Advisory == "")) ? true : false

            /* Button Setting */
            bgImage:(idRadioInstantReplayNext.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_n.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            bgImagePress:(idRadioInstantReplayNext.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_p.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            bgImageFocusPress:(idRadioInstantReplayNext.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_fp.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            bgImageFocus: (idRadioInstantReplayNext.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_s_f.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_s_d.png"
            fgImage: (idRadioInstantReplayNext.mEnabled)? imageInfo.imgFolderRadio_SXM+"ico_next_n.png" : imageInfo.imgFolderRadio_SXM+"ico_next_d.png"
            fgImageX: 30
            fgImageY: 22
            fgImageWidth: 48
            fgImageHeight: 37

            onMEnabledChanged: {
                console.log("### onMEnabledChanged : Next --> "+idRadioInstantReplayDisplay.activeFocus+" "+PLAYInfo.nOffset+" "+instantReplayPressAndHoldFlag+" "+idRadioInstantReplayNext.mEnabled+" "+idRadioInstantReplayNext.activeFocus+" "+idRadioInstantReplayNext.focus);

                if(idRadioInstantReplayNext.mEnabled) { iRNextEnabled = true; }
                else { iRNextEnabled = false; }

                if((idRadioInstantReplayNext.mEnabled == false) && (instantReplayPressAndHoldFlag == true) && (PLAYInfo.nOffset >= 0))
                {
                    stopFFRewByReleased();

                    if (idAppMain.isJogEnterLongPressed == true)
                    {
                        idAppMain.isJogEnterLongPressed = false;
                        nextbuttonlongstate = true;
                    }
                }
                if((idRadioInstantReplayNext.mEnabled == false) && idRadioInstantReplayNext.activeFocus)
                {
                    idRadioInstantReplayNext.focus = false;
                    setFocusInstantReplayButton();
                }
            }
            /* Button Action */
            onClickOrKeySelected: {
                console.log("### onClickOrKeySelected : Next --> ")

                if(idAppMain.isJogEnterLongPressed == true)
                {
                    if(idRadioInstantReplayNext.mEnabled == true)
                    {
                        console.log("Instant Replay = play mode(Select Released)");
                        stopFFRewByReleased();
                    }
                }
                else
                {
                    if((idRadioInstantReplayNext.mEnabled == true) && (instantReplayPressAndHoldFlag == false))
                    {
                        console.log("Instant Replay = play mode(FF short tap)");
                        XMOperation.onPlaySeekSong(1);
                    }
                }

                setForceFocusButton("InstantReplayButton");
                if((idRadioInstantReplayNext.mEnabled == false) && (PLAYInfo.nOffset == 0) )
                {
                    setFocusInstantReplayButton();
                }
                else
                {
                    idRadioInstantReplayNext.focus = true;
                }
                prevSetEnable();
            }
            onPressAndHold: {
                console.log("### onPressAndHold : Next --> ")

                if(idRadioInstantReplayNext.mEnabled == true && instantReplayPressAndHoldFlag == false)
                {
                    console.log("Instant Replay = play mode(FF long tap)");
                    instantReplayPressAndHoldFlag = true;
                    onFastFFRewStart(1);
                    prevSetEnable();
                }
            }
            onClickReleased: {
                console.log("### onClickReleased : Next --> ")

                if(idRadioInstantReplayNext.mEnabled == true && idAppMain.playBeepOn == true)
                {
                    console.log("Instant Replay = play mode(Select Released)");
                    // TA Requirement
                    // 243 Replay_028 (B, C, D) ~ 028a
                    stopFFRewByReleased();
                }

                instantReplayPressAndHoldFlag = false;
                setForceFocusButton("InstantReplayButton");
                if((idRadioInstantReplayNext.mEnabled == false) && (PLAYInfo.nOffset == 0) )
                {
                    setFocusInstantReplayButton();
                }
                else
                {
                    idRadioInstantReplayNext.focus = true;
                }
            }
            //ITS #0194536, #0194562 Cancel Key
            onCancel: {
                console.log("### onCancel : Next --> ")

                if(idRadioInstantReplayNext.mEnabled == true && idAppMain.playBeepOn == true)
                {
                    stopFFRewByReleased();
                }
                if(idRadioInstantReplayNext.mEnabled == true)
                {
                    idRadioInstantReplayNext.focus = true;
                }
                instantReplayPressAndHoldFlag = false;
                setForceFocusButton("InstantReplayButton");
            }

            /* Wheel Focus */
            onWheelLeftKeyPressed: setFocusWheelLeft(idRadioInstantReplayNext);
            onWheelRightKeyPressed: setFocusWheelRight(idRadioInstantReplayNext);
        }

        MComp.MButton{
            id: idRadioInstantReplayNow
            x: 6+107+107+107; y: 0
            width: 218; height: 81
            visible: true

	    mEnabled: (((PLAYInfo.nOffset > 0) || (PLAYInfo.nOffset == 0 && prevLongTimer.running == true && instantReplayPressAndHoldFlag == true) || (PLAYInfo.bPaused != false && PLAYInfo.nOffset != 0)) && (PLAYInfo.Advisory == "")) ? true : false

            /* Button Setting */
            bgImage: (idRadioInstantReplayNow.mEnabled)? imageInfo.imgFolderRadio_SXM+"btn_ins_l_n.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_l_d.png"
            bgImagePress: (idRadioInstantReplayNow.mEnabled) ? imageInfo.imgFolderRadio_SXM+"btn_ins_l_p.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_l_d.png"
            bgImageFocusPress: (idRadioInstantReplayNow.mEnabled) ? imageInfo.imgFolderRadio_SXM+"btn_ins_l_fp.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_l_d.png"
            bgImageFocus: (idRadioInstantReplayNow.mEnabled) ? imageInfo.imgFolderRadio_SXM+"btn_ins_l_f.png" : imageInfo.imgFolderRadio_SXM+"btn_ins_l_d.png"
            firstText: stringInfo.sSTR_XMRADIO_LIVE
            firstTextX: 0; firstTextY: 38
            firstTextWidth: 214
            firstTextSize: 28
            firstTextStyle: systemInfo.font_NewHDB
            firstTextAlies: "Center"
            firstTextColor: (idRadioInstantReplayNow.mEnabled) ? colorInfo.brightGrey : colorInfo.dimmedGrey

            onMEnabledChanged: {
                console.log("### onMEnabledChanged : Live --> "+idRadioInstantReplayDisplay.activeFocus+" "+PLAYInfo.nOffset+" "+instantReplayPressAndHoldFlag+" "+idRadioInstantReplayNow.mEnabled+" "+idRadioInstantReplayNow.activeFocus+" "+idRadioInstantReplayNow.focus);

                if(idRadioInstantReplayNow.mEnabled) { iRNowEnabled = true; }
                else
                {
                    iRNowEnabled = false;
                    prevAllTimerStop();
                }

                if((idRadioInstantReplayNow.mEnabled == false) && idRadioInstantReplayNow.activeFocus)
                {
                    setFocusInstantReplayButton();
                }
            }
            /* Button Action */
            onClickOrKeySelected: {
                console.log("### onClickOrKeySelected : Live --> ")

                if(idRadioInstantReplayNow.mEnabled == true)
                {
                    XMOperation.onNowPlay(true);
                }

                setForceFocusButton("InstantReplayButton");
                idRadioInstantReplayNow.focus = true;
            }

            /* Wheel Focus */
            onWheelLeftKeyPressed: setFocusWheelLeft(idRadioInstantReplayNow);
        }
    }

    Timer {
        id: playpauseDimTimer
        interval: 2000
        running: false
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            playpauseDimChange();
        }
    }

    function playpauseDimChange()
    {
        playpauseDimTimer.stop();
        idRadioInstantReplayPause.mEnabled = true;

        onFastFFRewStop();
        if(PLAYInfo.bPaused == true)
        {
            XMOperation.onPlay();
        }
    }

    function playpauseDimCheck()
    {
        if((PLAYInfo.nIRBufferDuration - PLAYInfo.nOffset) < 4)
        {
            playpauseDimTimer.start();
            idRadioInstantReplayPause.mEnabled = false;

            setFocusWheelRight(idRadioInstantReplayPause);
        }
    }

    Timer {
        id: prevDimTimer
        interval: 4000
        repeat: false
        onTriggered: {
            prevDimChange();
        }
    }

    function prevDimChange()
    {
        prevAllTimerStop();
        if((PLAYInfo.nDuration - PLAYInfo.nOffset) < 4)
        {
            prevDimTimer.start();
        }
    }

    Timer {
        id: prevLongTimer
        interval: 1000
        repeat: true
        onTriggered: {
            prevLongChange();
        }
    }

    function prevLongChange()
    {
        if((PLAYInfo.nDuration - PLAYInfo.nOffset) < 4)
        {
            prevDimTimer.stop();
        }
    }

    function prevSetEnable()
    {
        prevAllTimerStop();
    }

    function prevAllTimerStop()
    {
        prevLongTimer.stop();
        prevDimTimer.stop();
    }

    Connections{
        target: UIListener
        onCheckInstantPlayStaus: {
            console.log("[QML] XMAudioDisplayInstantReplayBtn :: onCheckInstantPlayStaus");
            cancelFFRew();
        }
        onSetInstantReplayLive: {
            console.log("setInstantReplayLive - emit receive");
            XMOperation.onNowPlay(true);
        }
    }

    Connections{
        target: idAppMain
        onCheckInstantPlayStausMenu: {
            console.log("[QML] XMAudioDisplayInstantReplayBtn :: onCheckInstantPlayStausMenu");
            cancelFFRew();
        }
    }

    onPlayTimeOffsetChanged:
    {
        if(instantReplayPressAndHoldFlag)
        {
            return;
        }

        prevAllTimerStop();
        if(idRadioInstantReplayPrev.mEnabled == false)
        {
            prevDimTimer.start();
        }
    }

    //****************************** # Instant Replay Function #
    //ITS #0194536, #0194562, #0189872  (FF,REW Stoped when changed screen)
    function stopFFRewByReleased(){
        instantReplayPressAndHoldFlag = false;
        onFastFFRewStop();
        XMOperation.onPlay();
    }

    function cancelFFRew(){
        console.log("[QML] XMAudioDisplayInstantReplayBtn :: cancelFFRew()");
        console.log("[QML] XMAudioDisplayInstantReplayBtn :: cancelFFRew() :: idAppMain.isJogEnterLongPressed = "+ idAppMain.isJogEnterLongPressed);
        console.log("[QML] XMAudioDisplayInstantReplayBtn :: cancelFFRew() ::instantReplayPressAndHoldFlag = "+ instantReplayPressAndHoldFlag);

        if(idAppMain.isJogEnterLongPressed == true || instantReplayPressAndHoldFlag == true)
        {
            if(idRadioInstantReplayNext.mEnabled == true)
            {
                console.log("Instant Replay = play mode(Select Released)");
                instantReplayPressAndHoldFlag = false;
                onFastFFRewStop();

                // TA Requirement
                // 243 Replay_028 (B, C, D) ~ 028a
                XMOperation.onPlay();
            }

            if(idRadioInstantReplayPrev.mEnabled == true)
            {
                console.log("Instant Replay = play mode(Selected Released)");
                instantReplayPressAndHoldFlag = false;

                onFastFFRewStop();
                // TA Requirement
                // 243 Replay_028 (B, C, D) ~ 028a
                XMOperation.onPlay();
            }

            idAppMain.cancelInstantBtnImag();
        }
    }

    function checkFocusInstantReplayButton()
    {
        var retValue = false;

        console.log("checkFocusInstantReplayButton "+iRPrevEnabled+" "+iRPlayPauseEnabled+" "+iRNextEnabled+" "+iRNowEnabled);

        if(idRadioInstantReplayPrev.mEnabled) retValue |= true;
        else if(iRPlayPauseEnabled) retValue |= true;
        else if(iRNextEnabled) retValue |= true;
        else if(iRNowEnabled) retValue |= true;

        return retValue;
    }

    function setFocusInstantReplayButton()
    {
        console.log("setFocusInstantReplayButton "+iRPrevEnabled+" "+iRPlayPauseEnabled+" "+iRNextEnabled+" "+iRNowEnabled);

        if(iRPlayPauseEnabled)
        {
            idRadioInstantReplayPause.forceActiveFocus();
        }
        else if(idRadioInstantReplayPrev.mEnabled)
        {
            idRadioInstantReplayPrev.forceActiveFocus();
        }
        else if(iRNextEnabled)
        {
            idRadioInstantReplayNext.forceActiveFocus();
        }
        else if(iRNowEnabled)
        {
            idRadioInstantReplayNow.forceActiveFocus();
        }
        else
        {
            idRadioInstantReplayPause.focus = true;
        }
    }

    function setFocusWheelLeft(idValue)
    {
        console.log("setFocusWheelLeft !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+idValue)
        switch(idValue)
        {
        case idRadioInstantReplayPrev:
        {
            idRadioInstantReplayPrev.forceActiveFocus();

            break;
        }
        case idRadioInstantReplayPause:
        {
            if(idRadioInstantReplayPrev.mEnabled)
                idRadioInstantReplayPrev.forceActiveFocus();
            else
                idRadioInstantReplayPause.forceActiveFocus();

            break;
        }
        case idRadioInstantReplayNext:
        {
            if(iRPlayPauseEnabled)
                idRadioInstantReplayPause.forceActiveFocus();
            else if(idRadioInstantReplayPrev.mEnabled)
                idRadioInstantReplayPrev.forceActiveFocus();
            else
                idRadioInstantReplayNext.forceActiveFocus();

            break;
        }
        case idRadioInstantReplayNow:
        {
            if(iRNextEnabled)
                idRadioInstantReplayNext.forceActiveFocus();
            else if(iRPlayPauseEnabled)
                idRadioInstantReplayPause.forceActiveFocus();
            else if(idRadioInstantReplayPrev.mEnabled)
                idRadioInstantReplayPrev.forceActiveFocus();
            else
                idRadioInstantReplayNow.forceActiveFocus();

            break;
        }
        default:
            console.log("setFocusWheelLeft - No Find id Value")
            break;
        }
    }

    function setFocusWheelRight(idValue)
    {
        console.log("setFocusWheelRight !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+idValue)
        switch(idValue)
        {
        case idRadioInstantReplayPrev:
        {
            if(iRPlayPauseEnabled)
                idRadioInstantReplayPause.forceActiveFocus();
            else if(iRNextEnabled)
                idRadioInstantReplayNext.forceActiveFocus();
            else if(iRNowEnabled)
                idRadioInstantReplayNow.forceActiveFocus();
            else
                idRadioInstantReplayPrev.forceActiveFocus();

            break;
        }
        case idRadioInstantReplayPause:
        {
            if(iRNextEnabled)
                idRadioInstantReplayNext.forceActiveFocus();
            else if(iRNowEnabled)
                idRadioInstantReplayNow.forceActiveFocus();
            else
                idRadioInstantReplayPause.forceActiveFocus();

            break;
        }
        case idRadioInstantReplayNext:
        {
            if(iRNowEnabled)
                idRadioInstantReplayNow.forceActiveFocus();
            else
                idRadioInstantReplayNext.forceActiveFocus();

            break;
        }
        case idRadioInstantReplayNow:
        {
            idRadioInstantReplayNow.forceActiveFocus();
            break;
        }
        default:
            console.log("setFocusWheelRight - No Find id Value")
            break;
        }
    }
}
