import Qt 4.7
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0
import AppEngineQMLConstants 1.0
import AhaMenuItems 1.0
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES

Rectangle {
    id: controlButtons
    width: PR.const_AHA_ALL_SCREEN_WIDTH
    height: 200 //wsuk.kim btns_pos 100
    //const_AHA_MAIN_SCREEN_HEIGHT - const_AHA_COMMON_STATUS_BAR_HEIGHT

    color: "transparent"
    property string playerState;
    property string like_icon_n;
    property string like_icon_p;
    property string like_icon_none;
    property string dislike_icon_n;
    property string dislike_icon_p;
    property string dislike_icon_none;
    property bool isPlaying;
    property bool focusVisible: true;
    property bool allowRating: false;
    property bool allowLike: false;
    property bool allowDislike: false;
    property bool allowSkip: false;
    property bool allowSkipBack: false;
    property bool allowTimeShift: false;
    property bool allowCall: false;
    property bool allowNavigate: false;
    property bool isRateVisible: false;
    property alias isJogLongPressTimerRunning: cueJogPressTimer.running     //wsuk.kim buffering flash

//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
    property bool isSkipPressed: false;
    property bool isSkipBackPressed: false;
    //hsryu_0423_block_play_btcall
//    signal trackShowBtBlockPopup(int jogCenter);
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.


    signal handleSkipEvent();
    signal handleSkipBackEvent();
    signal handlePlayPauseEvent();

    signal handleRewind15Event();
    signal handleForward30Event();

    signal handleRewindEvent();
//NOT USED    signal handleListViewEvent();
    signal handleRatingEvent(int rating);
    signal lostFocus(int arrow, int status);

//wsuk.kim 130207 jog_pop
    signal handleNoSkipBackEvent();
    signal handleNoSkipEvent();
    signal handleNoREW15Event();
    signal handleNoFW30Event();
//wsuk.kim 130207 jog_pop

    signal handleJogCenterSearch();    //wsuk.kim WHEEL_SEARCH
    signal handleStopTuneSearching();   //wsuk.kim 130912 ITS_0189859 pressed HK skip/skipback during tune search.

    signal handlePressSeekTrack();			//ITS_226621

    function __LOG( textLog )
    {
       console.log("DHAVN_AhaTrackViewButtons.qml: " + textLog )
    }

    function setTrackCurrentState(state)
    {
        playerState = state;

        if(playerState !== "trackStateInfoWaiting")
        {
            if(playerState === "trackStatePlaying")
            {
                isPlaying = true;
                if(!cueJogPressTimer.running)//wsuk.kim 121224
                    playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_N
            }
            else
            {
                isPlaying = false;
                if(!cueJogPressTimer.running)//wsuk.kim 121224
                    playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N
            }
        }    
    }

    function showFocus()
    {
        focusVisible = true;
    }

    function hideFocus()
    {
        focusVisible = false;
        //ITS_0223964
        isSkipBackPressed = false;
        isSkipPressed = false;
    }

    function updateLikeDislikeImage(currLikeIcon, altLikeIcon, currDislikeIcon, altDislikeIcon)
    {
        thumbsUpIcon.source = currLikeIcon;
        thumbsDownIcon.source = currDislikeIcon;
        like_icon_n = currLikeIcon;
        like_icon_p = altLikeIcon;
        like_icon_none = "";
        dislike_icon_n = currDislikeIcon;
        dislike_icon_p = altDislikeIcon;
        dislike_icon_none = "";

        //hsryu_0423_block_play_btcall
        ahaMenus.UpdateAllowInOptionsMenu(InTrackInfo.allowLike, InTrackInfo.allowDislike, InTrackInfo.allowCall, InTrackInfo.allowNavigate);
        //ITS_222229, 223048, 225840, 225843
        ahaMenus.UpdateLikeDislikeIconInOptionsMenu(currLikeIcon, currDislikeIcon); /*wsuk.kim menu_option*/
    }

//wsuk.kim SEEK_TRACK
    function startTimeshiftAnimation(allowKey)
    {
    	//ITS_0222228, 0222230
        if(allowKey === PR.const_AHA_SEEK_OR_JOGLEFT_ALLOW_KEY && isSkipBackPressed === true)
        {
            cueJogPressTimer.lastPressed = UIListenerEnum.JOG_LEFT;
            cueJogPressTimer.counter = PR.const_AHA_CUE_LEFT_TIMER_COUNTER_MIN_VAL;
            cueJogPressTimer.start();
        }
        //ITS_0222228, 0222230
        else if(allowKey === PR.const_AHA_TRACK_OR_JOGRIGHT_ALLOW_KEY  && isSkipPressed === true)
        {
            cueJogPressTimer.lastPressed = UIListenerEnum.JOG_RIGHT;
            cueJogPressTimer.counter = PR.const_AHA_CUE_RIGHT_TIMER_COUNTER_MIN_VAL;
            cueJogPressTimer.start();
        }
    }

    function stopTimeshiftAnimation()
    {
        cueJogPressTimer.stop();
        playPauseIcon.source = isPlaying? PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_N : PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N;
    }
//wsuk.kim SEEK_TRACK

    function releasedSkipPrevNextBtn()
    {
        isSkipPressed = false;
        isSkipBackPressed = false;
    }

    Connections
    {
        target: ahaController

        onBackground:
        {
            releasedSkipPrevNextBtn()
            if(isPlaying)
            {
                playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_N;
            }
            else
            {
                playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N;
            }
        }
    }

    //ITS_226621
    Connections
    {
        target: (!controlButtons.focusVisible && !popupVisible  && !isOptionsMenuVisible && !isNaviExceptPopupVisible && !isReceivingPopupVisible && !popUpTextVisible && !stationGuidePopupVisible && !networkErrorPopupVisible)?UIListener:null

        onSignalSeekTrackKey:
        {
            UIListener.printQMLDebugString("trackviewbutton onSignalSeekTrackKey :"+ ahaController.state+ "\n");

            if(!UIListener.IsCallingSameDevice())   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
            {
                if(status === UIListenerEnum.KEY_STATUS_PRESSED)
                {
                    handlePressSeekTrack();
                    releasedSkipPrevNextBtn();
                    stopTimeshiftAnimation();

                    switch(arrow)
                    {
                        case UIListenerEnum.JOG_LEFT:
                            isSkipBackPressed = true;   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_F;
                            break;
                        case UIListenerEnum.JOG_RIGHT:
                            isSkipPressed = true;   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.   skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_F;
                            break;
                    }
                }
            }
        }
    }

    Connections
    {
//hsryu_0423_block_play_btcall
//hsryu_0502_jog_control
        target: (controlButtons.focusVisible && !popupVisible  && !isOptionsMenuVisible /*&& !isShiftPopupVisible*/
                 && !isNaviExceptPopupVisible && !isReceivingPopupVisible && /*!btBlockPopupVisible*/!popUpTextVisible && !stationGuidePopupVisible && !networkErrorPopupVisible)?UIListener:null //wsuk.kim 130207 jog_pop //wsuk.kim navi_pop

        onSignalJogNavigation:
        {
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }
            //wsuk.kim 130912 ITS_0189859 pressed HK skip/skipback during tune search. // ITS 231156
            if(arrow !== UIListenerEnum.JOG_CENTER && arrow !== UIListenerEnum.JOG_WHEEL_LEFT && arrow !== UIListenerEnum.JOG_WHEEL_RIGHT && arrow !== UIListenerEnum.JOG_UP)
            {
                handleStopTuneSearching();
            }

            if(status === UIListenerEnum.KEY_STATUS_PRESSED)
            {
            	//ITS_0222228, 0222230
                releasedSkipPrevNextBtn();
                stopTimeshiftAnimation();

                switch(arrow)
                {
                case UIListenerEnum.JOG_LEFT:
                    if(!UIListener.IsCallingSameDevice())   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
                    {
                        isSkipBackPressed = true;
                    }
                    break;
                case UIListenerEnum.JOG_RIGHT:
                    if(!UIListener.IsCallingSameDevice())   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
                    {
                        isSkipPressed = true;
                    }
                    break;
//wsuk.kim 130820 pressed effect at cue button.
                case UIListenerEnum.JOG_CENTER:
                    if(!tuneSearching && !UIListener.IsCallingSameDevice()) //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
                    {
                        if(isPlaying)
                        {
                            playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_P
                        }
                        else
                        {
                            playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_P
                        }
                    }
                    break;
//wsuk.kim 130820 pressed effect at cue button.

                default:
                    break;
                }
            }
            else if(status === UIListenerEnum.KEY_STATUS_RELEASED)
            {
                if(UIListener.IsCallingSameDevice())
                {
                    UIListener.OSDInfoCannotPlayBTCall();
                    return;
                }

                switch(arrow)
                {
//hsryu_0502_jog_control
                case UIListenerEnum.JOG_CENTER:
                {
//wsuk.kim WHEEL_SEARCH
                    if(tuneSearching)
                    {
                        handleJogCenterSearch();
                        break;
                    }
//wsuk.kim WHEEL_SEARCH

////hsryu_0423_block_play_btcall
//                    if(UIListener.IsCallingSameDevice())
//                    {
//                        UIListener.OSDInfoCannotPlayBTCall();
////wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
////                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N
////                        trackShowBtBlockPopup(1);
//                        break;
//                    }
////hsryu_0423_block_play_btcall

//wsuk.kim 131128 ITS_211742 to press pause, keep mute icon.    UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                    if(isPlaying)
                    {
                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_N;    //wsuk.kim 131213 ITS_215483 cue BTN released.
                        ahaTrack.PlayPause();
                    }
                    else
                    {
                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N;     //wsuk.kim 131213 ITS_215483 cue BTN released.
                        UIListener.handleNotifyAudioPath();  //wsuk.kim 131128 ITS_211742 to press pause, keep mute icon.
                        ahaTrack.ignoreBufferingByKey();    //wsuk.kim 130926 ITS_191339 repeat press play/pause key, occur repeat buffering popup.
                        ahaTrack.PlayPause();
                    }

                    break;
                }
//hsryu_0502_jog_control
                case UIListenerEnum.JOG_LEFT:
//0428                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
//                    //hsryu_0423_block_play_btcall
//                    if(UIListener.IsCallingSameDevice())
//                    {
////wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
////                       skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_N;
////                       trackShowBtBlockPopup(0);
//                        return;
//                    }

                    if(!UIListener.getIsJogKeyLongPress()) /*wsuk.kim jog_long_press*/
                    {
                        if(controlButtons.allowSkipBack)    //wsuk.kim 130207 jog_pop
                        {
                            handleSkipBackEvent();
                        }
                        else //hsryu_0506_jog_release_patch
                        {
                            handleNoSkipBackEvent();
                        }
                    }
                    else//jog_long_press 121221
                    {
                        //ITS 0223477// if(rewind15.enabled)
                        if(allowTimeShift == true)
                        {
                            stopTimeshiftAnimation();
                        }
                    }
                    isSkipBackPressed = false;  //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_N;//jog_long_press 121221
                    break;
                }
                case UIListenerEnum.JOG_RIGHT:
//0428                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
//                    //hsryu_0423_block_play_btcall
//                    if(UIListener.IsCallingSameDevice())
//                    {
////wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
////                        skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_N;
////                        trackShowBtBlockPopup(0);
//                        return;
//                    }

                    if(!UIListener.getIsJogKeyLongPress()) /*wsuk.kim jog_long_press*/
                    {
                        if(controlButtons.allowSkip)    //wsuk.kim 130207 jog_pop
                        {
                            handleSkipEvent();
                        }
                        else //hsryu_0506_jog_release_patch
                        {
                            handleNoSkipEvent();
                        }
                    }
                    else    //jog_long_press 121221
                    {
                        //ITS 0223477// if(forward30.enabled)
                        if(allowTimeShift == true)
                        {
                            stopTimeshiftAnimation();
                        }
                    }
                    isSkipPressed = false;  //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_N;//jog_long_press 121221
                    break;
                }
                case UIListenerEnum.JOG_UP: //wsuk.kim 131001 HK JOG Relesed, work to JogEvent.
                {
                    controlButtons.focusVisible = false;
                    controlButtons.lostFocus(arrow, status);
                    break;
                }
                default:
                    break;
                }
            }
/*wsuk.kim jog_long_press*/
            else if(status === UIListenerEnum.KEY_STATUS_LONG_PRESSED)
            {
                //hsryu_0423_block_play_btcall
                if(UIListener.IsCallingSameDevice())
                {
                    UIListener.OSDInfoCannotPlayBTCall();
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//                    skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_N;
//                    skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_N;
//                    trackShowBtBlockPopup(0);
                    return;
                }

                switch(arrow)
                {
                    case UIListenerEnum.JOG_LEFT:
                    {
                    	//ITS_0222228, 0222230
                        if(isSkipBackPressed == false)
                        {
                            UIListener.printQMLDebugString("[ UIListenerEnum.KEY_STATUS_LONG_PRESSED left return \n");
                            return;
                        }

                        //ITS 0223477// if(rewind15.enabled)
                        if(allowTimeShift == true)
                        {
                            UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                            startTimeshiftAnimation(PR.const_AHA_SEEK_OR_JOGLEFT_ALLOW_KEY);
                        }
                        else
                        {
                            handleNoREW15Event();    //wsuk.kim 130207 jog_pop
                        }

                        break;
                    }
                    case UIListenerEnum.JOG_RIGHT:
                    {
                    	//ITS_0222228, 0222230
                        if(isSkipPressed == false)
                        {
                            UIListener.printQMLDebugString("[ UIListenerEnum.KEY_STATUS_LONG_PRESSED right return \n");
                            return;
                        }

                        //ITS 0223477// if(forward30.enabled)
                        if(allowTimeShift == true)
                        {
                            UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                            startTimeshiftAnimation(PR.const_AHA_TRACK_OR_JOGRIGHT_ALLOW_KEY);
                        }
                        else
                        {
                            handleNoFW30Event();    //wsuk.kim 130207 jog_pop
                        }

                        break;
                    }
                    default:
                        break;
                }
            }
/*wsuk.kim jog_long_press*/
        }

        onSignalSeekTrackKey:
        {
            handleStopTuneSearching();  //wsuk.kim 130912 ITS_0189859 pressed HK skip/skipback during tune search.
            if(!UIListener.IsCallingSameDevice())   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
            {
                if(status === UIListenerEnum.KEY_STATUS_PRESSED)
                {
                	//ITS_0222228, 0222230
                    //if(cueJogPressTimer.running)    //wsuk.kim 131008 remain SK rew15/ff30 animation effect when pressed SEEK/TRACK.
                    //{
                        //isSkipPressed = isSkipBackPressed = false;
                        //stopTimeshiftAnimation();
                    //}
                    releasedSkipPrevNextBtn();
                    stopTimeshiftAnimation();

                    switch(arrow)
                    {
                        case UIListenerEnum.JOG_LEFT:
                            isSkipBackPressed = true;   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_F;
                            break;
                        case UIListenerEnum.JOG_RIGHT:
                            isSkipPressed = true;   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.   skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_F;
                            break;
                    }
                }
                else if(status === UIListenerEnum.KEY_STATUS_RELEASED)
                {
                	//ITS_0222228, 0222230
                    releasedSkipPrevNextBtn();
//                    switch(arrow)
//                    {
//                        case UIListenerEnum.JOG_LEFT:
//                            isSkipBackPressed = false;   //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_N;
//                            break;
//                        case UIListenerEnum.JOG_RIGHT:
//                            isSkipPressed = false;  //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_N;
//                            break;
//                    }
                }
            }
        }
    }

    states:[
        State{
            name: "buttonsEnabled"
            PropertyChanges { target:thumbsUp; enabled: controlButtons.allowLike}
            PropertyChanges { target:thumbsDown; enabled: controlButtons.allowDislike}
            PropertyChanges { target:playPause; enabled: true }
            PropertyChanges { target:skip; enabled: true/*controlButtons.allowSkip*/}   //always
            PropertyChanges { target:skipBack; enabled: true/*controlButtons.allowSkipBack*/}   //always
            //ITS 0223477// PropertyChanges { target:forward30; enabled: controlButtons.allowTimeShift}
            //ITS 0223477// PropertyChanges { target:rewind15; enabled: controlButtons.allowTimeShift}
            //wsuk.kim title_bar    PropertyChanges { target:navigatePOI; enabled: controlButtons.allowNavigate}
            //wsuk.kim title_bar    PropertyChanges { target:phonePOI; enabled: controlButtons.allowCall}
            PropertyChanges { target:titleNavigatePOI; enabled: controlButtons.allowNavigate} //wsuk.kim title_bar
            PropertyChanges { target:titlePhonePOI; enabled: controlButtons.allowCall} //wsuk.kim title_bar
        },
        State{
            name: "buttonsDisabled"
            PropertyChanges { target:thumbsUp; enabled: false}
            PropertyChanges { target:thumbsDown; enabled: false}
            PropertyChanges { target:playPause; enabled: false}
            PropertyChanges { target:skip; enabled: false}
            PropertyChanges { target:skipBack; enabled: false}
            //ITS 0223477// PropertyChanges { target:forward30; enabled: false}
            //ITS 0223477// PropertyChanges { target:rewind15; enabled: false}

            //PropertyChanges { target:navigatePOI; enabled: false}
            //PropertyChanges { target:phonePOI; enabled: false}
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.            PropertyChanges { target:titleNavigatePOI; enabled: false} //wsuk.kim title_bar
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.            PropertyChanges { target:titlePhonePOI; enabled: false} //wsuk.kim title_bar
        },
        State{
            name: "NextPrevBtnEnabled"
            PropertyChanges { target:skip; enabled: true}
            PropertyChanges { target:skipBack; enabled: true}
        },
        State{
            name: "NextPrevBtnDisabled"
            PropertyChanges { target:skip; enabled: false}
            PropertyChanges { target:skipBack; enabled: false}
        }
    ]

//wsuk.kim 121224
    Item
    {
        Timer
        {
            id: cueJogPressTimer
            interval: 200;
            repeat: true;
            running: false;
            property int lastPressed: -1;
            property int counter: -1;

            onTriggered:
            {
                if(cueJogPressTimer.lastPressed === UIListenerEnum.JOG_LEFT)
                {
                    if(counter == PR.const_AHA_CUE_LEFT_TIMER_COUNTER_MAX_VAL)
                    {
                        counter = PR.const_AHA_CUE_LEFT_TIMER_COUNTER_MIN_VAL
                        handleRewind15Event()
                    }
                    else if(counter == PR.const_AHA_CUE_LEFT_TIMER_COUNTER_MIN_VAL)
                    {
                        handleRewind15Event()
                    }
                    playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_CUE_LONG_PRESS[counter]
                    counter = counter + 1
                }
                else if(cueJogPressTimer.lastPressed === UIListenerEnum.JOG_RIGHT)
                {
                    if(counter == PR.const_AHA_CUE_RIGHT_TIMER_COUNTER_MAX_VAL)
                    {
                        counter = PR.const_AHA_CUE_RIGHT_TIMER_COUNTER_MIN_VAL
                        handleForward30Event()
                    }
                    else if(counter == PR.const_AHA_CUE_RIGHT_TIMER_COUNTER_MIN_VAL)
                    {
                        handleForward30Event()
                    }
                    playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_CUE_LONG_PRESS[counter]
                    counter = counter + 1
                }
            }
        }
    }
//wsuk.kim 121224

    Rectangle
    {
        id: playPause
        width: mediaBg.width
        height: mediaBg.height
        color: "transparent"

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        property string playPauseBg: enabled? (isDialUI?PR_RES.const_APP_AHA_TRACK_VIEW_PLAYPAUSE_BG_IMAGE_F:PR_RES.const_APP_AHA_TRACK_VIEW_PLAYPAUSE_BG_IMAGE_N):PR_RES.const_APP_AHA_TRACK_VIEW_PLAYPAUSE_BG_IMAGE_D;
        property string playIcon: enabled? PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N : PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_D
        property string pauseIcon: enabled? PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_N : PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_D
        property bool hasFocus: true

        Image {
            id: mediaBg
//wsuk.kim pandora_72_merge            source: playPause.playPauseBg
            source: playPause.enabled?
                        (controlButtons.focusVisible?
                            PR_RES.const_APP_AHA_TRACK_VIEW_PLAYPAUSE_BG_IMAGE_F:
                            PR_RES.const_APP_AHA_TRACK_VIEW_PLAYPAUSE_BG_IMAGE_N):
                            PR_RES.const_APP_AHA_TRACK_VIEW_PLAYPAUSE_BG_IMAGE_D;
        }

        Image{
            id: playPauseIcon
            enabled: playPause.enabled
//wsuk.kim pandora_72_merge            source: isPlaying? playPause.pauseIcon:playPause.playIcon
            source: isPlaying? (playPause.enabled? PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_N : PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_D):(playPause.enabled? PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N : PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_D)
            anchors.centerIn: parent
            visible: !tuneSearching //wsuk.kim 130910 ITS_0189180 to change cue BTN OK during tune search.
            }

            /** Button text */  //wsuk.kim 130910 ITS_0189180 to change cue BTN OK during tune search.
            Text
            {
                id: text_loader
                anchors.centerIn: parent
                color: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY
                font.pointSize: PR.const_AHA_FONT_SIZE_TEXT_HDB_32_FONT
                font.family: PR.const_AHA_FONT_FAMILY_HDB
                text: "OK"
                visible: tuneSearching
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    //hsryu_0423_block_play_btcall
                    if(UIListener.IsCallingSameDevice())
                    {
                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_P
                        return;
                    }
                    if(toastPopupVisible)    //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        return;
                    }

                    if(isPlaying)
                    {
                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_P //wsuk.kim 130820 pressed effect at cue button.
                    }
                    else
                    {
                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_P  //wsuk.kim 130820 pressed effect at cue button.
                    }
                }

                onReleased: {
//wsuk.kim 130830 ITS_0187365 to add cancel touch released on other view.
//                    //hsryu_0423_block_play_btcall
//                    if(UIListener.IsCallingSameDevice())
//                    {
//                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N
////wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.                        trackShowBtBlockPopup(0);
//                        return;
//                    }
//                    UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
//                    if(isPlaying)
//                    {
//                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N
//                        ahaTrack.PlayPause();
//                    }
//                    else
//                    {
//                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_N
//                        ahaTrack.PlayPause();
//                    }
                    if(toastPopupVisible)    //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        return;
                    }
                    handlePlayPauseEvent();
                }

                onClicked: {
                    //hsryu_0423_block_play_btcall
                    if(UIListener.IsCallingSameDevice())
                    {
                        return;
                    }

                    if(toastPopupVisible)    //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        toastPopupVisible = false;
                        return;
                    }

                    if(tuneSearching)   //wsuk.kim 130910 ITS_0189180 to change cue BTN OK during tune search.
                    {
                        handleJogCenterSearch();
                        return;
                    }
//wsuk.kim 131128 ITS_211742 to press pause, keep mute icon.        UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                    if(isPlaying)
                    {
                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_N;    //wsuk.kim 131213 ITS_215483 cue BTN released.
                        ahaTrack.PlayPause();
                    }
                    else
                    {
                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N;     //wsuk.kim 131213 ITS_215483 cue BTN released.
                        UIListener.handleNotifyAudioPath();  //wsuk.kim 131128 ITS_211742 to press pause, keep mute icon.
                        ahaTrack.ignoreBufferingByKey();    //wsuk.kim 130926 ITS_191339 repeat press play/pause key, occur repeat buffering popup.
                        ahaTrack.PlayPause();
                    }
                }

//wsuk.kim 130830 ITS_0187365 to add cancel touch released on other view.
                onExited: {
                    if(isPlaying)
                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PAUSE_ICON_N
                    else
                        playPauseIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_PLAY_ICON_N
                }
//wsuk.kim 130830 ITS_0187365 to add cancel touch released on other view.
            }
    }

    Rectangle
    {
        id: skip
        width: mediaBg.width
        height: mediaBg.height
        color: "transparent"

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: playPause.right
        property bool hasFocus: false
        property bool isVisible: false

        Image{
            id: skipIcon
            enabled: skip.enabled
            source: enabled? (isSkipPressed? PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_F : PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_N): PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_D
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.            source: PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_N
            anchors.centerIn: parent

            MouseArea{
                anchors.fill: parent

//wsuk.kim hold_long
                onCanceled: {
                    isSkipPressed = false;  //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_N;
                }
//wsuk.kim hold_long

//wsuk.kim 130830 ITS_0187365 to add cancel touch released on other view.
                onExited:{
                    isSkipPressed = false;
                    if(cueJogPressTimer.running)
                    {
                        stopTimeshiftAnimation();
                    }
                }

                onClicked: {
                    isSkipPressed = false;

                    if(UIListener.IsCallingSameDevice())
                    {
                        return;
                    }

                    if(toastPopupVisible)    //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        toastPopupVisible = false;
                        return;
                    }

                    if(cueJogPressTimer.running)
                    {
                        stopTimeshiftAnimation();
                    }
                    else
                    {
                        if(!controlButtons.allowSkip)
                        {
                            handleNoSkipEvent();
                        }
                        else
                        {
                            handleSkipEvent();
                        }
                    }
                }
//wsuk.kim 130830 ITS_0187365 to add cancel touch released on other view.

                onPressed: {
                    if(toastPopupVisible)    //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        return;
                    }
                    if(tuneSearching) //wsuk.kim 131004 ITS_189859 skip/skipback SK enable, during tune Searching.
                    {
                        handleStopTuneSearching();
                    }

                    isSkipBackPressed = false;
                    isSkipPressed = true;
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//                    skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_N;
//                    skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_P;
                }

                onReleased: {
//wsuk.kim 130830 ITS_0187365 to add cancel touch released on other view.
//                    isSkipPressed = false;  //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.  skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_N;
//                    //hsryu_0423_block_play_btcall
//                    if(UIListener.IsCallingSameDevice())
//                    {
////wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.                        trackShowBtBlockPopup(0);
//                        return;
//                    }
////wsuk.kim 121224
//                    if(cueJogPressTimer.running)    //wsuk.kim hold_long    if(forward30.enabled)
//                    {
//                        stopTimeshiftAnimation();
//                    }
//                    else //hsryu_0507_key_release_patch
//                    {
//                        if(!controlButtons.allowSkip)
//                        {
//                            handleNoSkipEvent();
//                        }
//                        else
//                        {
//                            if(!skip.isBeforeHoldKey)
//                            {
//                                handleSkipEvent();  //wsuk.kim hold_long
//                            }
//                        }
//                    }
//                    skip.isBeforeHoldKey = false;
//wsuk.kim 121224
                    if(toastPopupVisible)    //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        return;
                    }
                }

//wsuk.kim 121224
                onPressAndHold: {
                    //hsryu_0423_block_play_btcall
                    if(UIListener.IsCallingSameDevice() || toastPopupVisible)    //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.                        trackShowBtBlockPopup(0);
                        return;
                    }
                    //ITS 0223477// if(forward30.enabled)
                    if(allowTimeShift == true)
                    {
                        UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                        cueJogPressTimer.lastPressed = UIListenerEnum.JOG_RIGHT;
                        cueJogPressTimer.counter = PR.const_AHA_CUE_RIGHT_TIMER_COUNTER_MIN_VAL;
                        cueJogPressTimer.start();
                    }
                    else
                    {
                        isSkipPressed = false;  //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_N;
                        handleNoFW30Event();    //wsuk.kim 130207 jog_pop
                    }
                }
//wsuk.kim 121224
            }
        }
    }

    Rectangle
    {
        id: skipBack
        width: mediaBg.width
        height: mediaBg.height
        color: "transparent"

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: playPause.left
        property bool hasFocus: false
        property bool isVisible: false

        Image{
            id: skipBackIcon
            enabled: skipBack.enabled
            source: enabled? (isSkipBackPressed? PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_F : PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_N) : PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_D
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.            source: PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_N
            anchors.centerIn: parent

            MouseArea{
                anchors.fill: parent

//wsuk.kim hold_long
                onCanceled: {
                    isSkipBackPressed = false;  //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_N;
                }
//wsuk.kim hold_long

//wsuk.kim 130830 ITS_0187365 to add cancel touch released on other view.
                onExited:{
                    isSkipBackPressed = false;
                    if(cueJogPressTimer.running)
                    {
                        stopTimeshiftAnimation();
                    }
                }

                onClicked: {
                    isSkipBackPressed = false;

                    if(UIListener.IsCallingSameDevice())
                    {
                        return;
                    }

                    if(toastPopupVisible)    //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        toastPopupVisible = false;
                        return;
                    }

                    if(cueJogPressTimer.running)
                    {
                        stopTimeshiftAnimation();
                    }
                    else
                    {
                        if(!controlButtons.allowSkipBack)
                        {
                            handleNoSkipBackEvent();
                        }
                        else
                        {
                            handleSkipBackEvent();
                        }
                    }
                }
//wsuk.kim 130830 ITS_0187365 to add cancel touch released on other view.
                onPressed: {
                    if(toastPopupVisible)   //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        return;
                    }
                    if(tuneSearching) //wsuk.kim 131004 ITS_189859 skip/skipback SK enable, during tune Searching.
                    {
                        handleStopTuneSearching();
                    }
                    isSkipPressed = false;
                    isSkipBackPressed = true;
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//                    skipIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIP_ICON_N;
//                    skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_P;
                }

                onReleased: {
//wsuk.kim 130830 ITS_0187365 to add cancel touch released on other view.
//                    isSkipBackPressed = false;  //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_N;
//                    //hsryu_0423_block_play_btcall
//                    if(UIListener.IsCallingSameDevice())
//                    {
////wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.                        trackShowBtBlockPopup(0);
//                        return;
//                    }
////wsuk.kim 121224
//                    if(cueJogPressTimer.running)    //wsuk.kim hold_long    if(rewind15.enabled)
//                    {
//                        stopTimeshiftAnimation();
//                    }
//                    else //hsryu_0507_key_release_patch
//                    {
//                        if(!controlButtons.allowSkipBack)
//                        {
//                            handleNoSkipBackEvent();
//                        }
//                        else
//                        {
//                            if(!skipBack.isBeforeHoldKey)
//                            {
//                                handleSkipBackEvent(); //wsuk.kim hold_long
//                            }
//                        }
//                    }
//                    skipBack.isBeforeHoldKey = false;
//wsuk.kim 121224
                    if(toastPopupVisible)    //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        return;
                    }
                }

//wsuk.kim 121224
                onPressAndHold: {
                    //hsryu_0423_block_play_btcall
                    if(UIListener.IsCallingSameDevice() || toastPopupVisible)    //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.                        trackShowBtBlockPopup(0);
                        return;
                    }
                    //ITS 0223477// if(rewind15.enabled)
                    if(allowTimeShift == true)
                    {
                        UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                        cueJogPressTimer.lastPressed = UIListenerEnum.JOG_LEFT;
                        cueJogPressTimer.counter = PR.const_AHA_CUE_LEFT_TIMER_COUNTER_MIN_VAL;
                        cueJogPressTimer.start();
                    }
                    else
                    {
                        isSkipBackPressed = false;  //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    skipBackIcon.source = PR_RES.const_APP_AHA_TRACK_VIEW_SKIPBACK_ICON_N;
                        handleNoREW15Event();    //wsuk.kim 130207 jog_pop
                    }
                }
//wsuk.kim 121224
            }
        }
    }

    Rectangle
    {
        id: forward30
        width: 114//wsuk.kim btns_pos 127
        height: thumbsDown.height
        color: "transparent"

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: thumbsUp.left    //wskim.kim AhaRadio 4 button position
        property bool hasFocus: false
        property bool isVisible: false

        Image{
            id: forward30Icon
            //ITS 0223477// enabled: forward30.enabled
            enabled: allowTimeShift
        }
    }

    Rectangle
    {
        id: rewind15
        width: 114//wsuk.kim btns_pos  127
        height: thumbsUp.height
        color: "transparent"

        anchors.verticalCenter: parent.verticalCenter
//wsuk.kim 121224        anchors.right: forward30.left
        property bool hasFocus: false
        property bool isVisible: false

        Image{
            id: rewind15Icon
            //ITS 0223477//  enabled: rewind15.enabled
            enabled: allowTimeShift
/*wsuk.kim 121224
            source: enabled? PR_RES.const_APP_AHA_TRACK_VIEW_REWIND15_ICON_N:PR_RES.const_APP_AHA_TRACK_VIEW_REWIND15_ICON_D
            anchors.centerIn: parent

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    isDialUI = false;
                    rewind15Icon.source = PR_RES.const_APP_AHA_TRACK_VIEW_REWIND15_ICON_P;
                }

                onReleased: {
                    rewind15Icon.source = PR_RES.const_APP_AHA_TRACK_VIEW_REWIND15_ICON_N;
                }

                onClicked: {
                    handleRewind15Event();
                }
            }
*/
        }
    }

    Rectangle
    {
        id: thumbsUp
        width: PR.const_AHA_TRACK_VIEW_LIKE_ICON_WIDTH
        height: PR.const_AHA_TRACK_VIEW_LIKE_ICON_HEIGHT
        color: "transparent"
        radius: thumbsUpIcon.height/2
        border.width: hasFocus? 5 : -1
        border.color:  "blue"
        visible: isRateVisible

        anchors.verticalCenter: parent.verticalCenter
        x: PR.const_APP_AHA_TRACK_VIEW_RATING_ICON_X_OFFSET //wsuk.kim 0121 anchors.right: thumbsDown.left
        property bool hasFocus: false
        Image{
            id: thumbsUpIcon
            enabled: thumbsUp.enabled
            source: enabled? like_icon_n : like_icon_none
            anchors.centerIn: parent
            visible: isRateVisible //hsryu_0326_like_dislike

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        toastPopupVisible = false;
                    }

                    thumbsUpIcon.source = like_icon_p;
                }

                onReleased: {
                    thumbsUpIcon.source = like_icon_n;
                }

                onClicked: {
                    controlButtons.handleRatingEvent(1);
                }

                onExited: { //wsuk.kim 20131014 ISV_92398 to add cancel touch released on other view.
                    thumbsUpIcon.source = like_icon_n;
                }
            }
        }
    }

    Rectangle
    {
        id: thumbsDown
        width: PR.const_AHA_TRACK_VIEW_LIKE_ICON_WIDTH
        height: PR.const_AHA_TRACK_VIEW_LIKE_ICON_HEIGHT
        color: "transparent"
        radius: thumbsDownIcon.height/2
        border.width: hasFocus? 5 : -1
        border.color:  "blue"
        visible: isRateVisible

        anchors.verticalCenter: parent.verticalCenter
        x: PR.const_APP_AHA_TRACK_VIEW_RATING_ICON_X_OFFSET + 97    //wsuk.kim 0121
        property bool hasFocus: false
        Image{
            id: thumbsDownIcon
            enabled: thumbsDown.enabled
            source: enabled? dislike_icon_n : dislike_icon_none
            anchors.centerIn: parent
            visible: isRateVisible //hsryu_0326_like_dislike

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                    {
                        toastPopupVisible = false;
                    }

                    thumbsDownIcon.source = dislike_icon_p;
                }

                onReleased: {
                    thumbsDownIcon.source = dislike_icon_n;
                }

                onClicked: {
                    controlButtons.handleRatingEvent(2);
                }

                onExited: { //wsuk.kim 20131014 ISV_92398 to add cancel touch released on other view.
                    thumbsDownIcon.source = dislike_icon_n;
                }
            }
        }
    }
}
