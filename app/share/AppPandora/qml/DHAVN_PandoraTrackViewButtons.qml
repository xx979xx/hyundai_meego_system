import Qt 4.7
import AppEngineQMLConstants 1.0
import PandoraMenuItems 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
//{ modified by yongkyun.lee 2014-02-18 for : 
import POPUPEnums 1.0
//} modified by yongkyun.lee 2014-02-18 

import CQMLLogUtil 1.0

Rectangle {
    id: controlButtons
    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    height: 157
    color: "transparent"
    property string playerState;
    property bool isPlaying
    property bool focusVisible: true
    property bool allowRating: false
    property bool allowSkip: false
    property bool allowBookMark: false // added by wonseok.heo for
    property bool isRateVisible: false
    property bool isPrsssEventRecv: false
    property bool isTuning: false
    property bool allowTouchEvent: true
    property bool bPressedCapture: true
    property bool jog_press: false  // added by cheolhwan 2014-01-14. ITS 218715.
    property bool thumbs: false //{ modified by yongkyun.lee 2014-02-07 for : ITS 224220
    property bool isShared

    property string logString :""

    property variant saveRating: 0//{ modified by yongkyun.lee 2014-09-24 for : 
    property variant saveBookMark: 0 // added by wonseok.heo for ITS 266666
    //property int thumbState: 0;//added by esjang 2013.05.09 for certification #8.3

    signal handleSkipEvent();
    signal handleRewindEvent();
    signal handleListViewEvent();
    signal handleRatingEvent(int rating);
    signal lostFocus(int arrow, int status);
    signal handleTouchEvent(); //added by esjang 2013.11.12 for ITS # 208755
    signal tuneClicked();//{ modified by yongkyun.lee 2014-03-10 for : ISV 98547
    signal handleBookmark(); //added by wonseok.heo 2015.04.27 for DH PE new spec

    function __LOG( textLog , level)
    {
        logString = "TrackViewButtons.qml::" + textLog ;
        logUtil.log(logString , level);
    }

    // { add by wonseok.heo 2015.01.20 for 256640
    function setSharedStation(share)
    {
        __LOG("setSharedStation share" + share + "]" , LogSysID.LOW_LOG );
        isShared = share;
    }
    // } add by wonseok.heo 2015.01.20 for 256640

    function setTrackCurrentState(state)
    {
        playerState = state;
        if(playerState !== "trackStateInfoWaiting")
        {
            if(playerState == "trackStatePlaying")
            {
                isPlaying = true;
                playPauseIcon.source =  UIListener.IsCalling() ? PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_D : PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N

            }
            else
            {
                isPlaying = false;
                playPauseIcon.source = UIListener.IsCalling() ? PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_D : PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N
            }
        }
        rated(saveRating);//{ modified by yongkyun.lee 2014-11-04 for : ITS 251793
    }

    function showFocus()
    {
        __LOG("focus visible => focusVisible[" + focusVisible + "]" , LogSysID.LOW_LOG );
        focusVisible = true;
    }

    function hideFocus()
    {
        __LOG("focus hide => focusVisible[" + focusVisible + "]" , LogSysID.LOW_LOG );
        focusVisible = false;
    }

    function chkBookmark(mark)
    {
        saveBookMark = mark; // added by wonseok.heo for ITS 266666
        if(mark === 1)
        {
            booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_N;
            booMarkIcon.enabled = true;
            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.BookmarkSong, true)

        }else if(mark === 2){
            booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_S;
            booMarkIcon.enabled = false;
            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.BookmarkSong, false)

        }else if(mark === 3){

            booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_D;
            booMarkIcon.enabled = false;
            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.BookmarkSong, false)
        }

    }

    function rated(rating)
    {
        __LOG("Rating  rating= " +rating , LogSysID.LOW_LOG );
        saveRating = rating;//{ modified by yongkyun.lee 2014-09-24 for : 
        if(rating === 1)
        {
            __LOG("Rating  Thumbs Up " , LogSysID.LOW_LOG );

            thumbsUpIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_S;
            thumbsDownIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_N
            // Rating done means ratingallowed flag is true TrackInfo
            thumbsUpIcon.enabled = false; // Once rated the button should be disabled
            thumbsDownIcon.enabled = true;
            pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsUp,true); //added by wonseok.heo 2015.04.27 for DH PE new spec
            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsUp, false)
            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsDown, true)
        }
        else if(rating === 2)
        {
            __LOG("Rating  Thumbs down " , LogSysID.LOW_LOG );

            thumbsUpIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_N;
            thumbsDownIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_S
            // Rating done means ratingallowed flag is true TrackInfo
            thumbsDownIcon.enabled = false;// Once rated the button should be disabled
            thumbsUpIcon.enabled = true;
            pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsDown,true);            
            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsUp, true)
            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsDown, false)
        }// { modified by wonseok.heo for rated during AD
        else if(rating === 3){
//            booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_D //added by wonseok.heo 2015.04.27 for DH PE new spec
//            booMarkIcon.enabled = false
            thumbsUpIcon.source =  PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_D
            thumbsDownIcon.source =  PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_D
            // No Rating done means the buttons should be enable/disable based on flag in Track info
            thumbsUpIcon.enabled = false
            thumbsDownIcon.enabled = false
            pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsUp,false)
            pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsDown,false);
            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsUp, false)
            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsDown, false)

        } // } modified by wonseok.heo for rated during AD
        else
        {
            __LOG("Rating None isPlaying" + isPlaying , LogSysID.LOW_LOG );

            // { modified by wonseok.heo for ITS 255473
            if(isPlaying){
//                booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_N //added by wonseok.heo 2015.04.27 for DH PE new spec
//                booMarkIcon.enabled = true
                thumbsUpIcon.source = thumbsUp.enabled? PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_N : PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_D
                thumbsDownIcon.source = thumbsDown.enabled? PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_N : PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_D
                // No Rating done means the buttons should be enable/disable based on flag in Track info
                thumbsUpIcon.enabled = thumbsUp.enabled
                thumbsDownIcon.enabled = thumbsDown.enabled
                pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsUp,false)
                pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsDown,false);
                pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsUp, thumbsUp.enabled)
                pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsDown, thumbsDown.enabled)

            }else{
                if(isShared){ //add by wonseok.heo 2015.01.20 for 256640
//                    booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_N // added by wonseok.heo 2015.04.27 for DH PE new spec
//                    booMarkIcon.enabled = true
                    thumbsUpIcon.source =  PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_D
                    thumbsDownIcon.source =  PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_D
                    // No Rating done means the buttons should be enable/disable based on flag in Track info
                    thumbsUpIcon.enabled = false
                    thumbsDownIcon.enabled = false
                    pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsUp,false)
                    pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsDown,false);
                    pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsUp, false)
                    pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsDown, false)

                }else{
//                    booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_N // added by wonseok.heo 2015.04.27 for DH PE new spec
//                    booMarkIcon.enabled = true
                    thumbsUpIcon.source =  PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_N
                    thumbsDownIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_N

                    // No Rating done means the buttons should be enable/disable based on flag in Track info
                    thumbsUpIcon.enabled = true
                    thumbsDownIcon.enabled = true
                    pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsUp,false)
                    pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsDown,false);
                    pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsUp, true)
                    pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsDown, true)

                }


            }



            // No Rating done means the buttons should be enable/disable based on flag in Track info
            //            thumbsUpIcon.enabled = thumbsUp.enabled
            //            thumbsDownIcon.enabled = thumbsDown.enabled
            //            pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsUp,false)
            //            pandoraMenus.UpdateRatingInOptionsMenu(MenuItems.ThumbsDown,false);
            //            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsUp, thumbsUp.enabled)
            //            pandoraMenus.optTrackMenuModel.itemEnabled(MenuItems.ThumbsDown, thumbsDown.enabled)
        } // } modified by wonseok.heo for ITS 255473
    }
    //{added by esjang 2013.05.09 for certificate # 8.3
    function derated()
    {
        //__LOG(" derating thumbState[" + thumbState + "]" , LogSysID.LOW_LOG );        
        rated(thumbState);
    }
    //}added by esjang 2013.05.09 for certificate # 8.3

    //{ modified by yongkyun.lee 2014-02-07 for : ITS 224220
    function getRated(rating )
    {
        if(rating === 1 && !thumbsUpIcon.enabled)
            thumbs = true;
        else if (rating === 2 && !thumbsDownIcon.enabled)
            thumbs = true;
        else
            thumbs = false;
        
    }
    //} modified by yongkyun.lee 2014-02-07 
    function handleJogKey(arrow , status)
    {
        __LOG("handlejogkey -> arrow : " + arrow + " , status : "+status , LogSysID.LOW_LOG );

        switch(arrow)
        {
        case UIListenerEnum.JOG_LEFT:
            if(status == UIListenerEnum.KEY_STATUS_PRESSED ) // modified by esjang 2013.08.21 for BT Call
            {
                handleRewindEvent();//esjang test 2013.06.17
            }
            break;
        case UIListenerEnum.JOG_RIGHT:

            if(skip.enabled )
            {
                if(status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
                    skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_F; //modified by cheolhwan 2014-03-22. ITS 230499.
                    //handleSkipEvent();
                }
                else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                    handleSkipEvent();
                    skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D //modified by jyjeon 2014-03-12 for ITS 228706

                }
                else if(status == UIListenerEnum.KEY_STATUS_CANCELED)
                {
                    if(allowSkip)
                        skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D //modified by jyjeon 2014-03-12 for ITS 228706
                }
                // added by jyjeon 2013.12.12 for ITS 214424
                else if(status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
                {

                    if(!isTuning && !UIListener.IsCalling() /*&& bPressedCapture*/ && enabled){ // modified by jyjeon 2014.01.21. ITS 221524.
                        skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D //modified by jyjeon 2014-03-12 for ITS 228706
                        bPressedCapture = false;
                    }
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_CANNOT_BE_MANIPULATED, false);
                }
                // added by jyjeon 2013.12.12 for ITS 214424
            }
            break;

        case UIListenerEnum.JOG_WHEEL_RIGHT:
            //{ removed by esjang 2013.06.03 for ITS #168293
            /*
                if(skip.enabled && status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                    skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N;
                    handleSkipEvent();
                }
                */
            //} removed by esjang 2013.06.03 for ITS #168293

            break;

        case UIListenerEnum.JOG_UP: // It should not come here
            hideFocus();

            break;
        case UIListenerEnum.JOG_CENTER:
            if(status == UIListenerEnum.KEY_STATUS_CLICKED || status == UIListenerEnum.KEY_STATUS_PRESSED){
                jog_press = true;
            }else {
                jog_press = false;
            }
            //if(status == UIListenerEnum.KEY_STATUS_RELEASED && !popupVisible && ! UIListener.IsCalling() ) // modified by esjang 2013.08.21 for BT phone call
            if(status == UIListenerEnum.KEY_STATUS_RELEASED && !popupVisible && ! UIListener.IsCalling() && bPressedCapture) // modified by jyjeon 2014.01.15 for ITS 219038
            {
                bPressedCapture = false; // added by jyjeon 2014.01.21 for ITS 221512
                if(isPlaying)
                {
                    playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N // added by jyjeon 2013.12.12 for ITS 214039
                    pndrTrack.Pause();
                }
                else
                {
                    playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N // added by jyjeon 2013.12.12 for ITS 214039
                    UIListener.IfMute_SentAudioPass();//{ modified by yongkyun.lee 2014-04-06 for : ITS 233599
                    pndrTrack.Play();
                }
            }
            else if(status == UIListenerEnum.KEY_STATUS_PRESSED && !popupVisible && !UIListener.IsCalling() ) //{ added by esjang 2013.11.03 pressed image for ccp center
            {
                bPressedCapture = true; // added by jyjeon 2014.01.21 for ITS 221512
                if(isPlaying)
                {
                    playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_P // modified by esjang 2013.08.26 for ITS 164017
                }
                else
                {
                    playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_P // modified by esjang 2013.08.26 for ITS 164017
                }
            }//} added by esjang 2013.11.03 for ITS # 206197 pressed image by pressing ccp center
            break;
        }
    }

    function updateskipIcon(inStatus)
    {
        if(UIListener.IsCalling()) return; // added by checolhwan 2014-0115. ITS 220054. added condition for call status.
        if(inStatus) // enable
        {
            if(allowSkip)
                skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N;
        }
        else{ // disable
            skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D;
        }

    }

    function setSkipIcon(inStatus)
    {

        if(inStatus)
        {
            if(skip.enabled)
            {
                handleTouchEvent(); //added by jyjeon 2013.01.17 for ITS 220414
                skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_F; //modified by cheolhwan 2014-03-22. ITS 230499.
            }
        }
        else
        {
            skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N;
        }
    }


    function setTuneState(tuneState)
    {

        if(playerState !== "trackStateInfoWaiting")
        {
            if(tuneState === true)
            {
                isTuning = true;
                skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D
            }
            else if(tuneState === false)
            {
                isTuning = false;
                skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D
                //{ added by cheolhwan 2014-01-14. ITS 218715.
                playPauseIcon.source =  isPlaying? 
                            (playPause.enabled? (jog_press?PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_P:PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N) : PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_D):
                                                                                                                                                                                                                 (playPause.enabled? (jog_press?PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_P:PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N) : PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_D)
                //} added by cheolhwan 2014-01-14. ITS 218715.
            }
        }
    }


    function callingState(status)
    {
        __LOG("callingState -> status       : " + status + " , saveRating : "+saveRating , LogSysID.LOW_LOG );

        if(status)
        {
            //mediaBg.source =  PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_D
            playPauseIcon.source =  PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_D
            skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D
            //{ modified by yongkyun.lee 2014-09-24 for : 
            thumbsUpIcon.source  = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_D
            thumbsDownIcon.source= PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_D            
            //} modified by yongkyun.lee 2014-09-24 
            booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_D //added by wonseok.heo 2015.04.27 for DH PE new spec

        }
        else{
            //mediaBg.source = controlButtons.focusVisible?
            //            PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_F:
            //            PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_N
            //playPauseIcon.source =  PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N //modified by esjang for ITS # 198788
            // added by esjang 2013.10.27 for ITS # 198788
            playPauseIcon.source = pndrTrack.TrackStatus()?
                        PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N:
            PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N
            skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D
            rated(saveRating);//{ modified by yongkyun.lee 2014-09-24 for :
            chkBookmark(saveBookMark); // added by wonseok.heo for ITS 266666

        }
    }

    //modified by wonseok.heo for ITS 229730 2014.03.18
    function skipIconChange(status)
    {
        if(status)
        {
            skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D
        }
        else{
            skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D
        }

    }

    //modified by wonseok.heo for ITS 229730 2014.03.18

    //{ add by cheolhwan 2013.12.04 for ITS 212559 (by GUI guideline).
    function setButtonState(status)
    {
        if(UIListener.IsCalling()) return; // added by checolhwan 2014-0115. ITS 220054. added condition for call status.
        if(status)
        {
	    // Dimmed
            //mediaBg.source =  PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_D
            playPauseIcon.source = (isPlaying)?PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_D
                                              :PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_D //modified by jyjeon 2013.12.12 for 214832
            skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D
        }
        else{
            //mediaBg.source = controlButtons.focusVisible?
            //            PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_F:
            //            PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_N
            playPauseIcon.source = pndrTrack.TrackStatus()?
                        PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N:
            PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N
            skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D
        }
    }
    //} add by cheolhwan 2013.12.04 for ITS 212559 (by GUI guideline).

    onFocusVisibleChanged:
    {
        //mediaBg.source = controlButtons.focusVisible?
        //            PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_F:
        //            PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_N
    }

    states:[
        State{
            name: "buttonsEnabled"
            PropertyChanges { target:thumbsUp; enabled: controlButtons.allowRating }
            PropertyChanges { target:thumbsDown; enabled: controlButtons.allowRating}
            PropertyChanges { target:playPause; enabled: true }
            PropertyChanges { target:skip; enabled: controlButtons.allowSkip}            
        },
        State{
            name: "buttonsDisabled"
            PropertyChanges { target:thumbsUp; enabled: false }
            PropertyChanges { target:thumbsDown; enabled: false }
            PropertyChanges { target:playPause; enabled: false }
            PropertyChanges { target:skip; enabled: false }            
        }
    ]

    Rectangle
    {
        id: playPause
        width:  mediaBg.width
        height: mediaBg.height
        color: "transparent"

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        property bool hasFocus: true        

        Image {
            id: mediaBg
            source: (jog_press && isTuning)?
                        PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_P:
                                                                                (playPause.enabled?
                                                                                     (controlButtons.focusVisible?
                                                                                          PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_F:
                                                                                      PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_N):
                                                                                 PR_RES.const_APP_PANDORA_TRACK_VIEW_PALYPAUSE_BG_IMAGE_D);
        }

        Image{
            id: playPauseIcon
            enabled: playPause.enabled
            source: isPlaying? (playPause.enabled? PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N : PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_D):    (playPause.enabled? PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N : PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_D)
            anchors.centerIn: parent
            visible: !isTuning
        }


        /** Button text */
        Text
        {
            id: text_loader
            anchors.centerIn: parent
            //color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
            color: jog_press?PR.const_PANDORA_COLOR_TEXT_CURR_STATION:PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY // modified by cheolhwan 2014-01-14. ITS 218715.
            font.pointSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDB_32_FONT
            font.family: PR.const_PANDORA_FONT_FAMILY_HDB
            text: "OK"
            visible: isTuning
        }
        MouseArea{
            beepEnabled: false
            anchors.fill: parent
            enabled: !UIListener.IsCalling() //added by jyjeon 2014-03-26 for ITS 231480
            onPressed: {
                __LOG("Track play button pressed : " + allowTouchEvent , LogSysID.LOW_LOG )
                bPressedCapture = false;
                if(!UIListener.IsCalling() && allowTouchEvent){
                    bPressedCapture = true;
                    handleTouchEvent(); //added by cheolhwan 2013-01117. ITS 220414.
                    if(isPlaying)
                    {
                        //playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_P
                        playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_P // modified by esjang 2013.08.26 for ITS 164017
                    }
                    else
                    {
                        //playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_P
                        playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_P // modified by esjang 2013.08.26 for ITS 164017
                    }
                }
            }

            onReleased: {
                if( !UIListener.IsCalling() && bPressedCapture )
                {
                    //__LOG("esjang 131112 for play pause button on released" , LogSysID.LOW_LOG );
                    //handleTouchEvent(); //deleted by cheolhwan 2013-01117. ITS 220414.
                    if(isPlaying)
                    {
                        //playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N
                        playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N // modified by esjang 2013.08.26 for ITS 164017
                    }
                    else
                    {
                        //playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N
                        playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N // modified by esjang 2013.08.26 for ITS 164017
                    }
                }
            }

            onClicked: {
                UIListener.ManualBeep();
                if(!UIListener.IsCalling() && bPressedCapture )
                {
                    //{ modified by yongkyun.lee 2014-03-10 for : ISV 98547
                    if(isTuning === true)
                    {
                        tuneClicked();
                        return;
                    }
                    //} modified by yongkyun.lee 2014-03-10

                    if(isPlaying)
                    {
                        pndrTrack.Pause();
                    }
                    else
                    {
                        UIListener.IfMute_SentAudioPass();
                        pndrTrack.Play();
                    }
                }
            }

            onExited: {
                if( !UIListener.IsCalling() && bPressedCapture )
                {
                    if(isPlaying)
                        playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N
                    else
                        playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N // modified by esjang 2013.08.26 for ITS 164017
                    bPressedCapture = false;
                }
            }

            onCanceled:{
                if( !UIListener.IsCalling() && bPressedCapture )
                {
                    if(isPlaying)
                        playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N
                    else
                        playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N // modified by esjang 2013.08.26 for ITS 164017
                    bPressedCapture = false;
                }
            }
        }
        // added by jyjeon 2013.12.05 for #ITS 213327
        Connections
        {
            target: !popupVisible? UIListener:null
            onMenuKeyPressed:
            {
                __LOG("onMenuKeyPressed : bPressedCapture ==" + bPressedCapture , LogSysID.LOW_LOG );
                if( !UIListener.IsCalling() && bPressedCapture )
                {
                    if(isPlaying)
                        playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PAUSE_ICON_N
                    else
                        playPauseIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_PLAY_ICON_N
                    bPressedCapture = false;
                }
            }
        }
        // added by jyjeon 2013.12.05 for #ITS 213327
    }

    Rectangle
    {
        id: skip
        width: skipIcon.width
        height: skipIcon.height
        color: "transparent"

        //anchors.verticalCenter: playPause.verticalCenter
        anchors.left: playPause.right
        anchors.top: playPause.top

        anchors.leftMargin: 8
        anchors.topMargin: 41
        property bool hasFocus: false
        property bool isVisible: false

        Image{
            id: skipIcon
            enabled: (skip.enabled && !isTuning)//modified by jyjeon 2013-03-13 for 229304
            source: enabled? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D
            anchors.centerIn: skip

            MouseArea{
                beepEnabled: false
                anchors.fill: parent
                
                onPressed: {
                    __LOG("skip : onPressed : "  , LogSysID.LOW_LOG );
                    bPressedCapture = false;
                    if(!isTuning && !UIListener.IsCalling() && allowTouchEvent ){
                        handleTouchEvent(); //added by jyjeon 2013.01.17 for ITS 220414
                        bPressedCapture = true;
                        skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_F; //modified by cheolhwan 2014-03-22. ITS 230499.
                    }
                }

                onReleased: {
                    __LOG("skip : onReleased : "  , LogSysID.LOW_LOG );
                    if(!isTuning && !UIListener.IsCalling() && bPressedCapture )
                        skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D //modified by jyjeon 2014-03-12 for ITS 228706
                }

                onClicked: {
                    UIListener.ManualBeep();
                    __LOG("skip : onClicked : "  , LogSysID.LOW_LOG );
                    if(!isTuning && !UIListener.IsCalling() && bPressedCapture )
                        handleSkipEvent();
                }
                onExited: {
                    __LOG("skip : onExited : "  , LogSysID.LOW_LOG );
                    if(!isTuning && !UIListener.IsCalling() && bPressedCapture && enabled){
                        skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D //modified by jyjeon 2014-03-12 for ITS 228706
                        bPressedCapture = false;
                    }
                }

                onCanceled:{
                    __LOG("skip : onCanceled : "  , LogSysID.LOW_LOG );
                    if(!isTuning && !UIListener.IsCalling() && bPressedCapture && enabled){
                        skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D //modified by jyjeon 2014-03-12 for ITS 228706
                        bPressedCapture = false;
                    }
                }

                // added by jyjeon 2013.11.20 for not suppoted popup # ITS 212471
                onPressAndHold: {
                    // added by jyjeon 2013.12.09 for UX Update
                    if(!isTuning && !UIListener.IsCalling() && bPressedCapture && enabled){
                        skipIcon.source = skip.enabled ? PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N:PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_D //modified by jyjeon 2014-03-12 for ITS 228706
                        bPressedCapture = false;
                    }
                    //myToastPopup.show(QT_TR_NOOP("STR_OPERATION_NOT_SUPPORTED") , true)
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_CANNOT_BE_MANIPULATED , false);
                    // added by jyjeon 2013.12.09 for UX Update
                }
                // added by jyjeon 2013.11.20 for not suppoted popup # ITS 212471
            }

            // added by jyjeon 2013.12.12 for ITS 214424
            Connections
            {
                //target: !popupVisible? UIListener:null
                target:UIListener //modified by cheolhwan 2014-05-13. ITS 237346.

                onSkipNextLongKeyPressed:
                {
                    __LOG("onSkipNextLongKeyPressed" , LogSysID.LOW_LOG );
                    if(!isTuning && !UIListener.IsCalling() /*&& bPressedCapture*/ && enabled){ // modified by jyjeon 2013.12.12 for ITS 218698
                        skipIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_SKIP_ICON_N
                        //bPressedCapture = false; // removed by jyjeon 2013.12.12 for ITS 218698
                    }
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_CANNOT_BE_MANIPULATED , false);
                }
            }
            // added by jyjeon 2013.12.12 for ITS 214424
        }
    }


    Rectangle
    {
        id: thumbsUp
        width: thumbsUpIcon.width
        height: thumbsUpIcon.height
        color: "transparent"
        radius: thumbsUpIcon.height/2
        border.width: hasFocus? 5 : -1
        border.color:  "blue"
        visible: isRateVisible

        //anchors.verticalCenter: parent.verticalCenter
        //anchors.right: thumbsDown.left
        x: PR.const_APP_PANDORA_TRACK_VIEW_RATING_ICON_X_OFFSET -80 // modified by esjang 2013.06.05 for ISV #82826
        y: PR.const_APP_PANDORA_TRACK_VIEW_RATING_ICON_Y_OFFSET // modified by esjang 2013.06.05 for ISV #82826

        property bool hasFocus: false
        Image{
            id: thumbsUpIcon
            enabled: thumbsUp.enabled && !UIListener.IsCalling() //added by jyjeon 2014-03-26 for ITS 231480
            source: enabled? PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_N : PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_D
            anchors.centerIn: parent

            MouseArea{
                beepEnabled: false
                anchors.fill: parent
                onPressed: {
                    if( !UIListener.IsCalling() )
                        thumbsUpIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_P;
                }

                onReleased: {
                    if( !UIListener.IsCalling() )
                        thumbsUpIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_N
                }

                onClicked: {
                    UIListener.ManualBeep();
                    if( !UIListener.IsCalling() )
                        controlButtons.handleRatingEvent(1);
                }
                onExited: {
                    if( !UIListener.IsCalling() && enabled )
                        thumbsUpIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_N
                }

                onCanceled:{
                    //removed by jyjeon 2013-03-12 for 229040
                    //if( !UIListener.IsCalling() && enabled )
                    //    thumbsUpIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_N
                }

                // added by jyjeon 2014.01.10 for ITS 218699
                onPressAndHold: {
                    if( !UIListener.IsCalling() && enabled )
                        thumbsUpIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_UP_IMAGE_N
                }
                // added by jyjeon 2014.01.10 for ITS 218699
            }
        }
    }

    Rectangle
    {
        id: thumbsDown
        width: thumbsDownIcon.width
        height: thumbsDownIcon.height
        color: "transparent"
        radius: thumbsDownIcon.height/2
        border.width: hasFocus? 5 : -1
        border.color:  "blue"
        visible: isRateVisible

        //anchors.verticalCenter: parent.verticalCenter
        //x: PR.const_APP_PANDORA_TRACK_VIEW_RATING_ICON_X_OFFSET
        //anchors.right: thumbsUp.left // modified by esjang 2013.06.05 for ISV #82826
        x: PR.const_APP_PANDORA_TRACK_VIEW_RATING_ICON_X_OFFSET // modified by esjang 2013.06.05 for ISV #82826
        y: PR.const_APP_PANDORA_TRACK_VIEW_RATING_ICON_Y_OFFSET // modified by esjang 2013.06.05 for ISV #82826

        property bool hasFocus: false

        Image{
            id: thumbsDownIcon
            enabled: thumbsDown.enabled && !UIListener.IsCalling() //added by jyjeon 2014-03-26 for ITS 231480
            source: enabled? PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_N : PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_D
            anchors.centerIn: parent

            MouseArea{
                beepEnabled: false
                anchors.fill: parent
                onPressed: {
                    if( !UIListener.IsCalling() )
                        thumbsDownIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_P
                }

                onReleased: {
                    if( !UIListener.IsCalling() )  
                        thumbsDownIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_N
                }

                onClicked: {
                    UIListener.ManualBeep();
                    if( !UIListener.IsCalling() )
                        controlButtons.handleRatingEvent(2);
                }
                onExited: {
                    if( !UIListener.IsCalling() && enabled )
                        thumbsDownIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_N
                }

                onCanceled:{
                    //removed by jyjeon 2013-03-12 for 229040
                    //if( !UIListener.IsCalling() && enabled)
                    //    thumbsDownIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_N
                }
                // added by jyjeon 2014.01.10 for ITS 218699
                onPressAndHold: {
                    if( !UIListener.IsCalling() && enabled )
                        thumbsDownIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_LIKE_DOWN_IMAGE_N
                }
                // added by jyjeon 2014.01.10 for ITS 218699
            }
        }
    }



    Rectangle
    {
        id: bookmark
        width: booMarkIcon.width
        height: booMarkIcon.height
        color: "transparent"
        radius: booMarkIcon.height/2
        border.width: hasFocus? 5 : -1
        border.color:  "blue"
        visible: if (UIListener.IsVehicleType() == 2) { //added by wonseok.heo for integration DH PE
                     isRateVisible
                 }else{
                     false
                 }
        //anchors.verticalCenter: parent.verticalCenter
        //anchors.right: thumbsDown.left
        x: PR.const_APP_PANDORA_TRACK_VIEW_RATING_ICON_X_OFFSET - 1119 //PR.const_APP_PANDORA_TRACK_VIEW_RATING_ICON_X_OFFSET // modified by esjang 2013.06.05 for ISV #82826
        y: PR.const_APP_PANDORA_TRACK_VIEW_RATING_ICON_Y_OFFSET // modified by esjang 2013.06.05 for ISV #82826

        property bool hasFocus: false
        Image{
            id: booMarkIcon
            enabled: bookmark.enabled && !UIListener.IsCalling() //added by jyjeon 2014-03-26 for ITS 231480
            source: enabled? PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_N : PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_D
            anchors.centerIn: parent

            MouseArea{
                beepEnabled: false
                anchors.fill: parent
                onPressed: {
                    if( !UIListener.IsCalling() )
                        booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_P;
                }

                onReleased: {
                    if( !UIListener.IsCalling() )
                        booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_N
                }

                onClicked: {

                    if( !UIListener.IsCalling() ){
                        UIListener.ManualBeep(); //added by wonseok.heo for ITS 266693
                        controlButtons.handleBookmark(); // added by wonseok.heo 2015.04.27 for DH PE new spec
                    }
                }
                onExited: {
                    if( !UIListener.IsCalling() && enabled )
                        booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_N
                }

                onCanceled:{

                }

                onPressAndHold: {
                    if( !UIListener.IsCalling() && enabled )
                        booMarkIcon.source = PR_RES.const_APP_PANDORA_TRACK_VIEW_BOOKMARK_IMAGE_N
                }

            }
        }
    }



}
