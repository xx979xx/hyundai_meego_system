import QtQuick 1.0
import Qt.labs.gestures 2.0

import AppEngineQMLConstants 1.0

import "components"
import "models"
import "DHAVN_VP_CONSTANTS.js" as CONST
// { added by Sergey Vetugov. CR#10273
import "DHAVN_VP_RESOURCES.js" as RES
// { added by Sergey Vetugov. CR#10273

DHAVN_VP_FocusedItem
{
    id: main
    anchors.fill: parent

    //width:1280 //added by edo.lee 2013.02.07
    //height:720

    name: "PlaybackScreen" // added by Sergey 24.08.2013 for ITS#185556 
    default_x: 0
    default_y: 0
    
    // { modified by Sergey 26.07.2013 for ITS#181444
    property bool bFullScreen: false
    property bool isFlicked : false     // Modified by Puneet for ITS 143047


    function logger(aText) { EngineListenerMain.qmlLog("[MP][QML] ScreenPlayback: " + aText) }

    // { added by Sergey 27.10.2013 for ITS#198669
    function onShowLockout(bOn)
    {
        logger("onShowLockout " + bOn);

        lockoutRect.visible  = bOn;
        progressBar.visible  = ( video_model.progressBarMode == "AUX" ) ? false : !bOn;
    }
    // } added by Sergey 27.10.2013 for ITS#198669

    
    Connections
    {
        target: EngineListener
        // added by hyejin.noh 20140602 for ITS 0239029
        onSetFullScreenMode: { logger("setFullMode"); main.bFullScreen = bOn;
            if(EngineListener.isVideoInFG())//added for ITS 249977 2014.11.04
                EngineListenerMain.sendTouchCleanUpForApps();
        }

        // { added by Sergey 12.10.2013 for ITS#195158
        onShowCaptions:
        {
            if(disp == SM.disp)
            {
                subtitlePlace.visible = bOn;
                test_image.fgVisible = bOn;
            }
        }
        // } added by Sergey 12.10.2013 for ITS#195158
    }



    // =========================== SUB ELEMENTS ===================================================

    GestureArea
    {
        id: main_gesture_area
        anchors.fill: parent
        objectName: "playbackGestureArea"
        enabled: !EngineListenerMain.blockMouse // added by Sergey 26.10.2013 for ITS#198513

        /* Here is the description of touch events handling:
         * First of all we should clear jog focus by any user touch. It's easy.
         * Then FullScreen: GestureArea catches touch even if user taps
         * on controls but we don't need it. So check where user taps.
         * If on controls don't handle it if on free (playback) area we handle.
         * Same logic for Pan.
         */
        property bool pbAreaTouch: false
        property bool pbAreaPan: false // added by cychoi 2015.09.04 for ITS 268398 & ITS 268399
        property bool isFlickable: false // added by Sergey 10.10.2013 for ITS#194807

        Tap
        {
            onStarted:
            {
                logger("Tap onStarted: y = " + gesture.position.y)
                //{ modified by yongkyun.lee 2013-08-15 for : 85716
                if( main.isSeekPressed || main.is_ff_rew )
                {
                  return;
                }

                main_gesture_area.isFlickable = (gesture.position.y > CONST.const_CONTENT_AREA_TOP_OFFSET); // added by Sergey 10.10.2013 for ITS#194807

                //} modified by yongkyun.lee 2013-08-15 
                if(main.bFullScreen || (gesture.position.y > CONST.const_CONTENT_AREA_TOP_OFFSET && gesture.position.y < controls.y))
                    main_gesture_area.pbAreaTouch = true

                logger("Tap onStarted: pbArea = " + main_gesture_area.pbAreaTouch)

                // { moved by Sergey 09.11.2013 for ITS#207159
                //{ removed for ITS 228567
                //SM.setDefaultFocus();
                //main.showFocus();
                //} removed for ITS 228567
                // moved by Sergey 09.11.2013 for ITS#207159
                controller.onMousePressed()
            }
            onFinished:
            {
                logger("Tap onFinished")
                //{ modified by yongkyun.lee 2013-08-15 for : 85716
                if( main.isSeekPressed || main.is_ff_rew )
                {
                   return;
                }
                //} modified by yongkyun.lee 2013-08-15 
//                controller.onMouseClicked(main_gesture_area.pbAreaTouch)     // Modified by Puneet for ITS 143047
				controller.onMouseReleased() // added by Sergey 13.09.2013 for ITS#188904
				// { moved by Sergey 09.11.2013 for ITS#207159
				//SM.setDefaultFocus(); // added by Sergey 29.10.2013 for ITS#198413
                //main.showFocus(); //added by aettie 2013.03.27 for Touch focus rule
				// } moved by Sergey 09.11.2013 for ITS#207159
                main_gesture_area.pbAreaTouch = false
            }
        }

        Pan
        {
            // { added by cychoi 2015.09.04 for ITS 268398 & ITS 268399
            onStarted: main_gesture_area.pbAreaPan = false
            
            onUpdated: main_gesture_area.pbAreaPan = true
            // } added by cychoi 2015.09.04

            onFinished:
            {
                if(main_gesture_area.pbAreaTouch && main_gesture_area.pbAreaPan) // modified by cychoi 2015.09.04 for ITS 268398 & ITS 268399
                {
                    if (gesture.offset.x < -100 && Math.abs(gesture.offset.y) < 300) // modified by Dmitry 21.05.13  //modified by aettie 20130522 for Master car QE issue
                    {
                        controller.onFlick_next();
                        isFlicked = true     // Modified by Puneet for ITS 143047
                    }
                    else if (gesture.offset.x > 100 && Math.abs(gesture.offset.y) < 300) // modified by Dmitry 21.05.13 //modified by aettie 20130522 for Master car QE issue
                    {
                        controller.onFlick_prev();
                        isFlicked = true     // Modified by Puneet for ITS 143047
                    }                    
                }
                controller.onMouseReleased() // modified by ravikanth 06-07-13 for SANITY fill screen transition on drag finish
                main_gesture_area.pbAreaTouch = false
                main_gesture_area.pbAreaPan = false // modified by cychoi 2015.09.04 for ITS 268398 & ITS 268399
            }
        }
    }
    // } modified by Sergey 26.07.2013 for ITS#181444
    
    //{ modified by Sergey 02.10.2013 for ITS#192280
    MouseArea
    {
        anchors.top: parent.top
        anchors.topMargin: main.bFullScreen ? 0 : CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        beepEnabled: false // added by Sergey 07.11.2013 not beep when flick track

        onClicked :
        {
            if(!isFlicked)
            {
                EngineListenerMain.ManualBeep(); // added by Sergey 07.11.2013 not beep when flick track
                controller.onMouseClicked(true)
            }
            isFlicked = false
        }
    }
     // } modified by Sergey 02.10.2013 for ITS#192280

   	// { moved by Sergey 12.10.2013 for ITS#195158
    // { XSubtitle added by jeeeun 2013.04.04
    Image
    {
        id: test_image
        source: "image://colors/red" //+ test_id
        anchors.bottom: parent.bottom
        anchors.bottomMargin: CONST.const_CAPTION_PLACE_BOTTOM_MARGIN
        anchors.horizontalCenter: parent.horizontalCenter

        //cache:false
        visible: video_model.divxCaptionVisible && fgVisible

        property bool fgVisible: false

        onVisibleChanged:
        {
            test_image.source=""; test_image.source="image://colors/yellow" + Math.random();
        }
    }
    // } XSubtitle added by jeeeun 2013.04.04

    // Just text element for displaying subtitle on playback screen
    DHAVN_VP_CaptionPlace
    {
        id: subtitlePlace
        objectName: "subtitlePlace"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
    // } moved by Sergey 12.10.2013 for ITS#195158

    // { modified by Sergey 01.08.2013 for new Loading popup
    Rectangle
    {
        // modified by kihyung 2013.09.15 for ISV 91113
        visible: ((video_model.loadingMode || video_model.removingMode || video_model.fgLoadingMode || video_model.stoppingMode) && lockoutRect.visible == false) // added by cychoi 2015.07.28 for ITS 266537

        anchors.fill:parent
        smooth: true

        Image
        {
            id: loadingPopupBg
            source: RES.const_URL_IMG_BG_LOADING_POPUP
        }

        Text
        {
            visible: (parent.visible && (video_model.loadingMode || video_model.fgLoadingMode)) // modified by Sergey 18.10.2013 for Loading screen after Camera
            anchors.horizontalCenter: parent.horizontalCenter
            y: CONST.const_LOADING_POPUP_TEXT_TOP_OFFSET
            text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_LOADING") + LocTrigger.empty // modified by yungi 2013.04.16 ITS162630
            font.pointSize: 40
            color: CONST.const_FONT_COLOR_BRIGHT_GREY
        }

//        AnimatedImage
//        {
//            smooth: true
//            anchors.horizontalCenter: parent.horizontalCenter
//            y: CONST.const_LOADING_POPUP_ICON_TOP_OFFSET
//            source: RES.const_URL_IMG_LOADING_ICON
//        }
    }
    // } modified by Sergey 01.08.2013 for new Loading popup

	// moved by Sergey 12.10.2013 for ITS#195158

    /* Wrapper for MediaProgressBar & own reinvented wheels with the
     * common API. See DHAVN_VP_ProgressBar.qml for details.
     */
    DHAVN_VP_ProgressBar
    {
        id: progressBar

        //{ modified by yongkyun.lee 2013-08-15 for : ISV 85716
        property alias isSeekPressed: controls.isSeekPressed
        property alias is_ff_rew: controls.is_ff_rew
        //} modified by yongkyun.lee 2013-08-15 
        
        anchors.fill: main
        objectName: "progressBar"
    }

    DHAVN_VP_PlaybackInfo
    {
       id: playbackInfoPopUp
       anchors.centerIn: main.Center
    }

    Rectangle
    {
       //objectName: "lockoutMode"
       id: lockoutRect //added by edo.lee 2013.02.26

       visible: false//video_model.lockoutMode
       anchors.fill:parent

       // { added by Sergey Vetugov. CR#10273
       color: "black"

       Image
       {
       //[KOR][ITS][181226][comment](aettie.ji)
           id: lockoutImg
          //  anchors.horizontalCenter:parent.horizontalCenter
           anchors.left: parent.left
           anchors.leftMargin: 562
           y: ( video_model.progressBarMode == "AUX" )? CONST.const_NO_PBCUE_LOCKOUT_ICON_TOP_OFFSET:CONST.const_LOCKOUT_ICON_TOP_OFFSET // modified by lssanh 2013.05.24 ISV84099
           source: RES.const_URL_IMG_LOCKOUT_ICON
       }
	   // { added by Sergey Vetugov. CR#10273
	   
       Text
       {
           // { modified by Sergey Vetugov. CR#10273
           //anchors.horizontalCenter: parent.horizontalCenter
           width: parent.width           
           horizontalAlignment:Text.AlignHCenter//added by edo.lee 2013.06.22
	   //[KOR][ITS][181226][comment](aettie.ji)
           //y: ( video_model.progressBarMode == "AUX" )? CONST.const_NO_PBCUE_LOCKOUT_TEXT_TOP_OFFSET:CONST.const_LOCKOUT_TEXT_TOP_OFFSET // modified by lssanh 2013.05.24 ISV84099
           //text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_CAPTION_VIDEO_DISABLED_INFO") + LocTrigger.empty
           anchors.top : lockoutImg.bottom
           text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_DISC_VCD_DRIVING_REGULATION") + LocTrigger.empty  //added by edo.lee 2013.05.24
           font.pointSize: 32//36//modified by edo.lee 2013.05.24        
           color: "white"
           // { modified by Sergey Vetugov. CR#10273
       }

       //MouseArea { anchors.fill: parent } // added by Sergey 25.05.2013
    }

    DHAVN_VP_PlaybackControls
    {
       id: controls
       visible: true
       objectName: "playbackControlls"
//       enabled: !EngineListenerMain.isBTCall // commented by Sergey 17.05.2013 for ISV#83170

       name: "PlaybackControls_Video" // added by Sergey 24.08.2013 for ITS#185556 
       focus_x: 0
       focus_y: 0
       property bool isPlaybackLoaded : EngineListener.setVideoPlaybackQMLlsLoaded(true) // added by sjhyun 2013.11.06 for ITS 206822

       isBtMusic: false //added by edo.lee 2013.01.14

		// removed by Sergey 24.08.2013 for ITS#185556 

       onNext_pressed: EngineListener.releaseTuneMode() // added by Sergey 19.05.2013
       onPrev_pressed: EngineListener.releaseTuneMode() // added by Sergey 19.05.2013
       onPlay_button_clicked:controller.onTogglePlayBtn();
       onJog_longpress: controller.onLongPressPlayBtn();
       onPrev_clicked:
           if(EngineListener.isVideoInFG())
           {
               if(!EngineListener.rewReachedFirst)
               {
                   controller.onPrevBtn(); // added by Sergey 28.05.2013
               }
           }
           else
               EngineListener.prev();
       onLong_rew:
           if(EngineListener.isVideoInFG())
               controller.onPrevBtnHold();
           else
               EngineListener.rewind();
       onCritical_rew:
           if(EngineListener.isVideoInFG())
               controller.onPrevBtnHoldCritical();
           else
               EngineListener.rewindCritical();
       onNext_clicked:
           if(EngineListener.isVideoInFG())
               controller.onNextBtn();
           else
               EngineListener.next();
       onLong_ff:
           if(EngineListener.isVideoInFG())
               controller.onNextBtnHold();
           else
               EngineListener.fastForward();
       onCritical_ff:
           if(EngineListener.isVideoInFG())
               controller.onNextBtnHoldCritical();
           else
               EngineListener.fastForwardCritical();
       onCancel_ff_rew:
           if(EngineListener.isVideoInFG())
               controller.onCancel_ff_rew();
           else
               EngineListener.cancel_ff_rew();
       onSelect_Tune: controller.onSelectTuned();//added by edo.lee 2013.06.11
       // removed by Sergey 09.09.2013 for ITS#188944
    }

	// removed by Sergey 24.08.2013 for ITS#185556

    // { added by kihyung 2012.12.01 for ISV 62687
    Item {
        id: inhibition_item

        visible: false
        x: 1176
        y: 175
        width: 92
        height: 92

        Image {
            id: icon_image
            anchors.left: parent.left
            anchors.top: parent.top
            source: "/app/share/images/video/ico_dvd_error.png"
        }

        Timer {
            id: icon_timer
            interval: 3000
            repeat: false
            triggeredOnStart: false
            running: false
            onTriggered: 
            {
                EngineListenerMain.qmlLog("[MP][QML] VP Screen_Playback :: onShowPlaybackControls: onTriggered");
                inhibition_item.visible = false
            }
        }
    }
    // } added by kihyung

    // { added by kihyung 2012.06.20
    // for CR 9855
    Connections
    {
        target: controller


        onShowLockout: onShowLockout(onShow); // modified by Sergey 27.10.2013 for ITS#198669

        onResetSpeedIcon:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP Screen_Playback :: onResetSpeedIcon");
            // { modified by cychoi 2013.12.09 for SmokeTest cue icon is not reset on OnNormalPlay
            if(video_model.progressBarMode == "DVD" ||
               video_model.progressBarMode == "VCD") // Deck's operation is different from that of Jukebox/USB on OnNormalPlay
            {
                controls.is_ff_rew = false; // removed by taihyun.ahn 2013.12.06
            }
            // } modified by cychoi 2013.12.09
            controls.setPauseState();
        }

        // { added by cychoi 2014.10.14 for ITS 250235
        onResetSpeedIconToPlayIcon:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP Screen_Playback :: onResetSpeedIconToPlayIcon");
            // { modified by cychoi 2013.12.09 for SmokeTest cue icon is not reset on OnNormalPlay
            if(video_model.progressBarMode == "DVD" ||
               video_model.progressBarMode == "VCD") // Deck's operation is different from that of Jukebox/USB on OnNormalPlay
            {
                controls.is_ff_rew = false; // removed by taihyun.ahn 2013.12.06
            }
            // } modified by cychoi 2013.12.09
            controls.setPlayState();
        }
        // } added by cychoi 2014.10.14

        onSetSpeedIcon:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP Screen_Playback :: onSetSpeedIcon");
            // { modified by cychoi 2013.12.09 for SmokeTest cue icon is not reset on OnNormalPlay
            if(video_model.progressBarMode == "DVD" ||
               video_model.progressBarMode == "VCD") // Deck's operation is different from that of Jukebox/USB on OnNormalPlay
            {
                controls.is_ff_rew = true; // removed by taihyun.ahn 2013.12.06
            }
            // } modified by cychoi 2013.12.09
            controls.setSpeedRate(rate);
        }

        //{ added by yongkyun 2013.01.19 for ITS 150703
        onCancelFfRew:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP Screen_Playback :: onCancelFfRew");
            controls.handleOnCancel_ff_rew();
        }
        //} added by yongkyun 2013.01.19
        
        // removed by Sergey 23.09.2013 for ITS#188498

        // { added by kihyung 2012.08.27 for Video(LGE) #12
        onShowPlaybackControls:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP Screen_Playback :: onShowPlaybackControls: " + bShow);
            controls.visible = bShow;
            progressBar.visible = ( video_model.progressBarMode == "AUX" )? false:bShow;	//added by hyochang.ryu 20130902 for smoke test
        }
        // } added by kihyung
        // removed by sjhyun 2013.11.05 for ITS 206357
        
        // { added by junggil 2012.09.06 for keep the FF or REW mode when change to another screen. 
        onReleaseLongPress:
        {
            controls.hideFocus();
        }
        // } added by junggil 
    }
    // } added by kihyung

    // modified by ravikanth 02-10-13 for ITS 0190988
    Connections
    {
        target: VideoEngine
        // { moved by sjhyun 2013.11.05 for ITS 206357
        onShowInhibitionIcon:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP Screen_Playback :: onShowInhibitionIcon: " + bShow)
            if(lockoutRect.visible)
            {
                EngineListenerMain.qmlLog("[MP][QML] VP Screen_Playback :: onShowInhibitionIcon:  lock out : return")
                return
            }
            inhibition_item.visible = bShow
            if(bShow == true)
                icon_timer.start()
            else
                icon_timer.stop()
        }
        // } moved by sjhyun

        onSystemPopupShow:
        {
            main_gesture_area.enabled = !bShown
        }

        // { added by cychoi 2015.12.03 for ITS 270621
        onSigClearSpeedIcon:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP Screen_Playback :: onSigClearSpeedIcon");
            // { modified by cychoi 2013.12.09 for SmokeTest cue icon is not reset on OnNormalPlay
            if(video_model.progressBarMode == "DVD" ||
               video_model.progressBarMode == "VCD") // Deck's operation is different from that of Jukebox/USB on OnNormalPlay
            {
                controls.is_ff_rew = false; // removed by taihyun.ahn 2013.12.06
            }
            // } modified by cychoi 2013.12.09
            controls.setPauseState();
        }

        onSigCancelFastPlay:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP Screen_Playback :: onSigCancelFastPlay");
            controls.handleOnCancel_ff_rew();
        }
        // } added by cychoi 2015.12.03
    }
    
    // removed by Sergey 01.08.2013 for new Loading popup
}
