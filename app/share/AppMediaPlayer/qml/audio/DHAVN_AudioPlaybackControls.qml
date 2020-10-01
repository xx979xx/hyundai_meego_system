// { added by Sergey 24.08.2013 for separating Audio and Video playback controls
import QtQuick 1.0
import Qt 4.7
import AppEngineQMLConstants 1.0

import "../video/DHAVN_VP_CONSTANTS.js" as CONST
import "../video/models"
import "../video/components"

// modified by Dmitry 15.05.13
DHAVN_VP_FocusedItem
{
   id: controls_area

   property string curMode: video_model.progressBarMode
   //{ added by yongkyun.lee 20130601 for :  ITS 146106
   property int isLeftRight: UIListenerEnum.JOG_NONE
   property bool is_Critical:false
   //} added by yongkyun.lee 20130601

   //warning!!! FLAG - it should be removed
  // property bool is_ff_rew: false
   property bool is_scan: false

   property bool bFullScreenAnimation: true // added by Sergey 03.08.2013 for ITS#0180899
   property bool onScreen: true

   property bool isCommonJogEnabled: false

   property bool tuneMode: video_model.tuneMode
   // removed by Sergey 01.05.2013 for Tune Functionality
   property bool enabled: true // added by Dmitry 28.04.13

   property bool isBtMusic: false // added by edo.lee 2012.08.23
   property bool camMode: video_model.camMode // added by wspark 2013.02.21 for ISV 73305
   // removed by Sergey 13.08.2013 for ITS#183043
   property bool isAudio: false // added by Dmitry 26.05.13
   //property bool isSeekPressed:false //added by edo.lee 2013.06.30
   property bool isBTLong: false // added by hyochang.ryu 20130727
   property bool isBasicControlEnableStatus : true //added by junam 2013.08.15 for muisc app control icon

   //{ added by yongkyun.lee 20130822 for : Multi Key-Only First key
  // property int  oldArrow: -1
  // property bool isJogProcessing: false // added by sungha.choi 2013.08.26 for JogEvent Mutex
   //} added by yongkyun.lee 20130417
   property bool bTunePressed: false

   onBTunePressedChanged:
   {
       if(bTunePressed)
           btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,{jog_pressed: true})
       else
           btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,{jog_pressed: false})
   }

   default_x: 0
   default_y: 0

   /** Signals */
   signal prev_pressed(); // added by Sergey 19.05.2013
   signal next_pressed(); // added by Sergey 19.05.2013
   signal prev_clicked();
   signal next_clicked();
   signal play_button_clicked();
// DUAL_KEY START
   signal prev_canceled();
   signal next_canceled();
   signal play_button_canceled();
// DUAL_KEY END
   signal jog_longpress();
   signal long_ff();
   signal long_rew();
   signal critical_rew()
   signal critical_ff()
   signal cancel_ff_rew()
   signal hideFocusInParent()
   signal lostFocus( int direction )
   signal released(string btnId) //added by junam 2013.05.18 for ISV_KR81848
   signal canceled(string btnId) // added by suilyou DUAL_KEY
   signal select_Tune();//added by edo.lee 2013.06.11

   /*-------Function for set icon/text controls--------*/

   function handleJogEvent( arrow, status, bRRC )
   {
       /* DAUL_KEY
       if(status == UIListenerEnum.KEY_STATUS_PRESSED) { // { added by sungha.choi 2013.08.26 for JogEvent Mutex
           isJogProcessing = true;

           if(isJogProcessing == true)
               return;
           else {
               isJogProcessing = true;
               oldArrow = arrow;
           }

       } else if(status == UIListenerEnum.KEY_STATUS_RELEASED) {
           isJogProcessing = false;
           /* DUAL_KEY
           if(isJogProcessing && arrow == oldArrow) {
               isJogProcessing = false;
               oldArrow   = -1;
           }
           else
               return;

       }else if(status == UIListenerEnum.KEY_STATUS_CANCELED)
       {
           isJogProcessing = false;
       }
       else if(status == UIListenerEnum.KEY_STATUS_LONG_PRESSED || status == UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED) {
           if(isJogProcessing && arrow == oldArrow) {

           }
           else
          return;
       } // } added by sungha.choi 2013.08.26 for JogEvent Mutex
       EngineListenerMain.qmlLog("SUILYOU pass JogEvent Mutex")
/* DUAL_KEY
       switch(arrow)
       {
           case UIListenerEnum.JOG_LEFT:
           {
               if(!bRRC)
                   EngineListenerMain.setJogKeyReleased(CONST.const_CCP_JOG_LEFT_PRESSED);
               else
                   EngineListenerMain.setJogKeyReleased(CONST.const_RRC_JOG_LEFT_PRESSED);
                   break;
           }
           case UIListenerEnum.JOG_RIGHT:
           {
               if(!bRRC)
                   EngineListenerMain.setJogKeyReleased(CONST.const_CCP_JOG_RIGHT_PRESSED);
               else
                   EngineListenerMain.setJogKeyReleased(CONST.const_RRC_JOG_RIGHT_PRESSED);
                   break;
           }
           case UIListenerEnum.JOG_CENTER:
           {
               if(!bRRC)
                   EngineListenerMain.setJogKeyReleased(CONST.const_CCP_JOG_CENTER_PRESSED);
               else
                   EngineListenerMain.setJogKeyReleased(CONST.const_RRC_JOG_CENTER_PRESSED);
                   break;
           }
           default:
           {
               break;
           }
       }
DUAL_KEY */
// don't show focus if playback control is invisible
      if (visible && focus_visible) //changed by junam 2013.09.10 for ITS_KOR_189008
          controls_area.isCommonJogEnabled = true // modified by Dmitry 11.09.13

      EngineListenerMain.qmlLog("[PlaybackControls]handleJogEvent arrow =" + arrow +" , status ="+ status)
      switch ( arrow )
      {
         case UIListenerEnum.JOG_UP:
         //case UIListenerEnum.JOG_DOWN:
         {
	 //modified by aettie Focus moves when pressed 20131015
//            if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               controls_area.lostFocus( arrow )
               controls_area.isCommonJogEnabled = false // modified by Dmitry Bykov 07.04.2013 for ISV75839
            }
            break
         }

         case UIListenerEnum.JOG_RIGHT:
         case UIListenerEnum.JOG_LEFT:
         {
            if (!enabled && status != UIListenerEnum.KEY_STATUS_CANCELED) return; // added by Dmitry 28.04.13 // ITS 231763

            var curIndex = (arrow == UIListenerEnum.JOG_LEFT)?
                            CONST.const_CONTROLS_REW_BTN_NUMBER: CONST.const_CONTROLS_FF_BTN_NUMBER

            if(btnModel.get(curIndex).is_dimmed) //added by junam 2013.09.16 for ITS_NA_189858
                return;

            if(status == UIListenerEnum.KEY_STATUS_PRESSED)
            {
                //{ added by yongkyun.lee 20130601 for : ITS 146106
                /* DUAL_KEY
                if(is_ff_rew)
                    return; DUAL_KEY */
                 //} added by yongkyun.lee 20130601
           //     isSeekPressed = true;//added by edo.lee 2013.05.30
                isBTLong = false; // added by oseong.kwon 2014.08.27 for ITS 246908, ITS 246911
                handleOnPress(btnModel.get(curIndex).btn_id) // added by Sergey 19.05.2013
                btnModel.set(curIndex,{jog_pressed: true})
                EngineListenerMain.repaintUI(); // added by Sergey 27.12.2013 for ITS#217503
            }
            else if(status == UIListenerEnum.KEY_STATUS_RELEASED )// added by yongkyun.lee 20130801 for : ITS 181898
            {
                isLeftRight= UIListenerEnum.JOG_NONE;  // added by yongkyun.lee 20130601 for : ITS 146106
                //{ modified by yongkyun.lee 2013-10-12 for : nocr - BT FF - Media key - next song
                if(isBTLong == true )
                {
                    isBTLong = false;
                    // { commented by oseong.kwon 2014.08.27 for ITS 246908, ITS 246911
                    //btnModel.set(curIndex,{jog_pressed: false})
                    //controls_area.released(btnModel.get(curIndex).btn_id) //added by junam 2013.05.18 for ISV_KR81848
                    // } commented by oseong.kwon 2014.08.27
                }
                else
                //} modified by yongkyun.lee 2013-10-12 
                {
                    controls_area.handleOnRelease(btnModel.get(curIndex).btn_id)
                    btnModel.set(curIndex,{jog_pressed: false})
                    //EngineListenerMain.sendVRCancelSignal(); removed by suilyou 20140312 ITS_0224783
                    controls_area.released(btnModel.get(curIndex).btn_id) //added by junam 2013.05.18 for ISV_KR81848
                }
            }
            else if(status == UIListenerEnum.KEY_STATUS_CANCELED)
            {
                if(isBTLong == true)
                {
                    isBTLong = false;
                    // { commented by oseong.kwon 2014.08.27 for ITS 246908, ITS 246911
                    //btnModel.set(curIndex,{jog_pressed: false})
                    //controls_area.released(btnModel.get(curIndex).btn_id) //added by junam 2013.05.18 for ISV_KR81848
                    // } commented by oseong.kwon 2014.08.27
                }
                else
                {
                    btnModel.set(curIndex,{jog_pressed: false})
                    controls_area.handleOnCanceled(btnModel.get(curIndex).btn_id)
                }
            }
            else if(status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
            {
                // { modified by oseong.kwon 2014.08.27 for ITS 246908, ITS 246911
                if(isBtMusic == true)
                {
                    btnModel.set(curIndex,{jog_pressed: false})
                    controls_area.canceled(btnModel.get(curIndex).btn_id) //added by junam 2013.05.18 for ISV_KR81848
                    isBTLong = true;
                    AudioController.NotSupportedBTOSD(false) // modified by cychoi 2014.10.17 for ITS 250091 // modified by cychoi 2014.07.30 for ITS 244501, ITS 244504 (ITS187310)
                    return;
                }
                // } modified by oseong.kwon 2014.08.27
                //isSeekPressed = false; // added by yongkyun.lee 20130627 for :  ITS 176166 DUAL_KEY
                //{ added by yongkyun.lee 20130601 for : ITS 146106
/* DUAL_KEY
               if(is_ff_rew || is_Critical)
                    return;

                if(arrow == UIListenerEnum.JOG_RIGHT)
                    isLeftRight= UIListenerEnum.JOG_RIGHT;
                else
                    isLeftRight= UIListenerEnum.JOG_LEFT;
                //} added by yongkyun.lee 20130601
DUAL_KEY*/
                btnModel.set(curIndex,{jog_pressed: true}) // added by Sergey 20.04.2013
                controls_area.handleOnPressAndHold(btnModel.get(curIndex).btn_id,false)
                //UIListener.ManualBeep() // removed by sangmin.seol 2014.05.23 ITS 0238157 // modified by yongkyun.lee 2013-08-06 for : ITS 182922
            }
            else if(status == UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED)
            {
                // { modified by oseong.kwon 2014.08.27 for ITS 246908, ITS 246911
                if(isBtMusic == true)
                {
                    btnModel.set(curIndex,{jog_pressed: false})
                    controls_area.canceled(btnModel.get(curIndex).btn_id) //added by junam 2013.05.18 for ISV_KR81848
                    isBTLong = true;
                    AudioController.NotSupportedBTOSD(false) // modified by cychoi 2014.10.17 for ITS 250091 // modified by cychoi 2014.07.30 for ITS 244501, ITS 244504 (ITS187310)
                    return;
                }
                // } modified by oseong.kwon 2014.08.27
               //{ added by yongkyun.lee 20130627 for :  ITS 176166
               /* DUAL_KEY
               isSeekPressed = false;
               if( !is_ff_rew ||is_Critical)
                    return;
                    DUAL_KEY */
               //} added by yongkyun.lee 20130627
               btnModel.set(curIndex,{jog_pressed: true}) // added by Sergey 20.04.2013
               controls_area.handleOnPressedAndHoldCritical(btnModel.get(curIndex).btn_id)
               //UIListener.ManualBeep()  // removed by sangmin.seol 2014.05.23 ITS 0238157 // modified by yongkyun.lee 2013-08-06 for : ITS 182922
            }
            break
         }

// modified by Dmitry 26.05.13
         case UIListenerEnum.JOG_CENTER:
         {
             EngineListenerMain.qmlLog("SUILYOU In case UIListenerEnum.JOG_CENTER" + status)
            //{ added by yongkyun.lee 20130627 for :  ITS 176166
            ///if (!enabled ) return; // added by Dmitry 28.04.13
            if (!enabled /*|| (is_ff_rew || is_Critical)*/) return; //DUAL_KEY
            //} added by yongkyun.lee 20130627
            EngineListenerMain.qmlLog("SUILYOU if (!enabled || (is_ff_rew || is_Critical))")
            if(status == UIListenerEnum.KEY_STATUS_PRESSED)
            {
                EngineListenerMain.qmlLog("SUILYOU KEY_STATUS_PRESSED")
                //isSeekPressed = true;//added by edo.lee 2013.05.30 DUAL_KEY

                bTunePressed = true     // added by sangmin.seol 2014.02.06 ITS 0223853
                btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,{jog_pressed: true})
                EngineListenerMain.repaintUI(); // added by Sergey 27.12.2013 for ITS#217503
            }
            else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
            {
                //{ added by junam 2013.01.08 for ITS_NA_218502
                if(btnModel.get(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER).jog_pressed == false)
                {
                    EngineListenerMain.qmlLog("Control cue released without pressed event - ignore")
                    return;
                }
                //} added by junam
                EngineListenerMain.qmlLog("SUILYOU KEY_STATUS_RELEASED")
                bTunePressed = false    // added by sangmin.seol 2014.02.06 ITS 0223853
                btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,{jog_pressed: false})
                // removed by Sergey 13.08.2013 for ITS#183043
                //EngineListenerMain.sendVRCancelSignal(); removed by suilyou 20140312 ITS_0224783
                controls_area.handleOnRelease(btnModel.get(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER).btn_id)
               // removed by Sergey 13.08.2013 for ITS#183043
            }
            else if(status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
            {
                // removed by Sergey 13.08.2013 for ITS#183043
                controls_area.jog_longpress();
            }
// added by Dmitry 18.08.13 for ITS0176369
            else if (status == UIListenerEnum.KEY_STATUS_CANCELED)
            {
                bTunePressed = false    // added by sangmin.seol 2014.02.06 ITS 0223853
                btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,{jog_pressed: false})
                controls_area.handleOnCanceled(btnModel.get(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER).btn_id)
            }
            break
// modified by Dmitry 26.05.13
         }
      }//switch
   }  //onSignal

   function setPlayState()
   {
       //{ added by yongkyun.lee 20130627 for :  ITS 176166
       //if(!is_ff_rew && !is_scan && !is_Critical)      //added by hyochang.ryu 20130620
       //  if(!is_ff_rew && !is_scan )DUAL_KEY
       //} added by yongkyun.lee 20130627
       {
          btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: ""})
       
          //{changed by junam 2013.08.15 for muisc app control icon
          //if((isBtMusic == true) && albumBTView.visible) // BT music icon modified 2012.08.25
          if((isBtMusic == true /*&& albumBTView.visible*/) || isBasicControlEnableStatus == false) // modified by sangmin.seol 2015.01.26 NoCR Play icon showing on BT Music
          { //}changed by junam
             EngineListenerMain.qmlLog("setPlayState case 1")
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: ""})
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_p: "/app/share/images/general/media_play_p.png"})
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_n: "/app/share/images/general/media_play_n.png"})
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_d: "/app/share/images/general/media_play_d.png"}) //added by junam 2013.08.15 for muisc app control icon
          }
          else
          {
             EngineListenerMain.qmlLog("setPlayState case 2")
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_p: "/app/share/images/general/media_play_02_p.png"})
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_n: "/app/share/images/general/media_play_02_n.png"})
             //{added by junam 2013.07.25 for dim control que
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_d: "/app/share/images/general/media_play_02_d.png"})
             //}added by junam
          }
          //} modified by edo.lee
       }
   }

   function setPauseState()
   {
       //{ added by yongkyun.lee 20130627 for :  ITS 176166
       //if(!is_ff_rew && !is_scan && !is_Critical)      //added by hyochang.ryu 20130620
       // if(!is_ff_rew && !is_scan )DUAL_KEY
       //} added by yongkyun.lee 20130627
       {
          //{changed by junam 2013.08.15 for muisc app control icon
          //if((isBtMusic == true) && albumBTView.visible)
          if((isBtMusic == true /*&& albumBTView.visible*/) || isBasicControlEnableStatus == false) // modified by sangmin.seol 2015.01.26 NoCR Play icon showing on BT Music
          {//}changed by junam
             EngineListenerMain.qmlLog("setPauseState case 1")
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: ""})
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_p: "/app/share/images/general/media_play_p.png"})
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_n: "/app/share/images/general/media_play_n.png"})
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_d: "/app/share/images/general/media_play_d.png"}) //added by junam 2013.08.15 for muisc app control icon
             //{ modified by yongkyun.lee 2013-11-14 for : ITS 209018
             btnModel.set(CONST.const_CONTROLS_REW_BTN_NUMBER,{is_dimmed: false})
             btnModel.set(CONST.const_CONTROLS_FF_BTN_NUMBER,{is_dimmed: false})
             //} modified by yongkyun.lee 2013-11-14
          }
          else
          {
             EngineListenerMain.qmlLog("setPauseState case 2")
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: ""})
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_p: "/app/share/images/general/media_pause_p.png"})
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_n: "/app/share/images/general/media_pause_n.png"})
             //{added by junam 2013.07.25 for dim control que
             btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                          {icon2_d: "/app/share/images/general/media_pause_d.png"})
             //}added by junam
          }
       }
   }

   //{added by junam 2013.07.24 for iPOD FF/RW icon
   function  setPause()
   {
       btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, { text: "",
                    icon2_p: "/app/share/images/general/media_pause_p.png",
                    icon2_n: "/app/share/images/general/media_pause_n.png"})
   }
   //}added by junam

   // { added by wspark 2012.08.14 for CR11620
   // { modified by wspark 2012.08.17 for DQA #26
   function setTuneState(tuneState)
   {
       if(tuneState == true)
       {
            btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {icon2_p: ""})
            btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {icon2_n: ""})
            btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: "OK"})
            btnModel.set(CONST.const_CONTROLS_REW_BTN_NUMBER,{is_dimmed: true})
            btnModel.set(CONST.const_CONTROLS_FF_BTN_NUMBER,{is_dimmed: true})
       }
       else if(tuneState == false)
       {
            btnModel.set(CONST.const_CONTROLS_REW_BTN_NUMBER,{is_dimmed: false})
            btnModel.set(CONST.const_CONTROLS_FF_BTN_NUMBER,{is_dimmed: false})
       }

   }
   // } modified by wspark
   // } added by wspark

   function setSpeedRate(rate)
   {
      if(isBtMusic)return; //modified by edo.lee 2013.01.12

      btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {icon2_p: ""})
      btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {icon2_n: ""})

      switch (rate)
      {
         case CONST.const_CONTROLS_SPEED_RATE_4X:
         {
            btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: "4x"})
            break;
         }
         case CONST.const_CONTROLS_SPEED_RATE_16X:
         {
            btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: "16x"})
            break;
         }
         case CONST.const_CONTROLS_SPEED_RATE_20X:
         {
            btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: "20x"})
            break;
         }
      }
   }

   function setScanState()
   {
       btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {icon2_p: "/app/share/images/general/media_stop_p.png"})
       btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {icon2_n: "/app/share/images/general/media_stop_n.png"})
       btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {icon2_d: "/app/share/images/general/media_stop_d.png"})
   }

   function hideFocus()
   {
      clearAllJogs()
      controls_area.isCommonJogEnabled = false // modified by ravikanth 09-07-13 for focus fix on system popup
   }

   function showFocus()
   {
      controls_area.isCommonJogEnabled = true
   }

   function clearAllJogs()
   {
      EngineListenerMain.qmlLog(" clearAllJogs()")

      handleOnCancel_ff_rew()

      // rollback ITS 243921,2
      btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,{jog_pressed: false})
      btnModel.set(CONST.const_CONTROLS_REW_BTN_NUMBER,{jog_pressed: false})
      btnModel.set(CONST.const_CONTROLS_FF_BTN_NUMBER,{jog_pressed: false})
   }

   function handleOnPress(btn_id)
   {
       switch (btn_id)
       {
          case "Prev":
          {
              controls_area.prev_pressed()
              break;
          }
          case "Next":
          {
              controls_area.next_pressed()
              break;
          }
       }
 //       isSeekPressed = true;//added by edo.lee 2013.05.30
   } // added by Sergey 19.05.2013

   function handleOnRelease(btn_id)
   {
       EngineListenerMain.qmlLog("SUILYOU handleOnRelease"+ btn_id)
      switch (btn_id)
      {
         case "Prev":
         {
            // { DUAL_KEY Modified condition for cancel_ff_rew
            //if (!handleOnCancel_ff_rew() /*&& isSeekPressed*/ )//added by edo.lee 2013.05.30
            //{
            //   EngineListenerMain.qmlLog("ZZZ handleOnRelease PREV clicked")
            //   controls_area.prev_clicked()
            //}
            if (AudioController.GetFfRewState() && timerPressedAndHoldCritical.lastPressed == "Prev") // modified by cychoi 2014.04.02 for ITS 233225 Prev/Next after REW/FF
            {
                handleOnCancel_ff_rew();
            }
            else
            {
               EngineListenerMain.qmlLog("ZZZ handleOnRelease PREV clicked")
               controls_area.prev_clicked()
            }
            // } DUAL_KEY Modified condition for cancel_ff_rew

            EngineListener.rewReachedFirst = false // added by Sergey 28.05.2013
            break;
         }

         case "Next":
         {
             //if (!handleOnCancel_ff_rew() /*&& isSeekPressed*/ )//added by edo.lee 2013.05.30
             //{
             //   EngineListenerMain.qmlLog("ZZZ handleOnRelease NEXT clicked")
             //   controls_area.next_clicked()
             //}
             if (AudioController.GetFfRewState() && timerPressedAndHoldCritical.lastPressed == "Next") // modified by cychoi 2014.04.02 for ITS 233225 Prev/Next after REW/FF
             {
                 handleOnCancel_ff_rew();
             }
             else
             {
                EngineListenerMain.qmlLog("ZZZ handleOnRelease NEXT clicked")
                controls_area.next_clicked()
             }
            break;
         }
         case "PlayButton":
         {
            EngineListenerMain.qmlLog("ZZZ handleOnRelease PLAY clicked")
        //added by edo.lee 2013.06.11
            if(tuneMode)
            {
                controls_area.select_Tune()
            }else
            {
                controls_area.play_button_clicked()
            }
            break;
         }
      }
    //   isSeekPressed = false;//added by edo.lee 2013.05.30
   }

// DUAL_KEY START
   function handleOnCanceled(btn_id)
   {
       EngineListenerMain.qmlLog("SUILYOU handleOnCanceled"+ btn_id)
       timerPressedAndHoldCritical.stop()
       timerPressedAndHoldCritical.lastPressed = "" // added by cychoi 2014.04.02 for ITS 233225 Prev/Next after REW/FF
      switch (btn_id)
      {
         case "Prev":
         {
             EngineListenerMain.qmlLog("ZZZ handleOnCanceled PREV canceled")
             controls_area.prev_canceled()
             break;
         }
         case "Next":
         {
             EngineListenerMain.qmlLog("ZZZ handleOnCanceled Next canceled")
             controls_area.next_canceled()
            break;
         }
         case "PlayButton":
         {
             EngineListenerMain.qmlLog("ZZZ handleOnCanceled PlayButton canceled")
             controls_area.play_button_canceled()
            break;
         }
      }
   }
// DUAL_KEY END

   function handleOnPressAndHold(btn_id, start)
   {
       /* DUAL_KEY
       //{ added by yongkyun.lee 20130601 for :  ITS 146106
      if(is_ff_rew  && is_Critical )
           return;
       //} added by yongkyun.lee 20130601
       */
      switch (btn_id)
      {
         case "Prev":
         {
            controls_area.long_rew()
            //is_ff_rew = true; DUAL_KEY
            timerPressedAndHoldCritical.lastPressed = btn_id
            if(start)
            {
               timerPressedAndHoldCritical.start()
            }
            break;
         }
         case "Next":
         {
            controls_area.long_ff()
           //  is_ff_rew = true;DUAL_KEY
            timerPressedAndHoldCritical.lastPressed = btn_id
            if(start)
            {
               timerPressedAndHoldCritical.start()
            }
            break;
         }
         // removed by Sergey 13.08.2013 for ITS#183043
      }
   }

   //{ added by yongkyun 2013.01.19 for ITS 150703
   function handleOnCancel_ff_rew()
   {
       EngineListenerMain.qmlLog("handleOnCancel_ff_rew ")
/* DUAL_KEY
        //{ added by yongkyun.lee 20130607 for : ITS 146106
        //if (is_ff_rew == true  )
        if (is_ff_rew == true || is_Critical == true )
        //} added by yongkyun.lee 20130607
        {
            is_ff_rew = false;
            is_Critical = false //  added by yongkyun.lee 20130601 for : ITS 146106
            timerPressedAndHoldCritical.stop()
            controls_area.cancel_ff_rew()
            return true
        }
        */
       timerPressedAndHoldCritical.stop()
       timerPressedAndHoldCritical.lastPressed = "" // added by cychoi 2014.04.02 for ITS 233225 Prev/Next after REW/FF
       if(AudioController.IsFFREWCancelNeeded()) // added by oseong.kwon 2014.07.04 for ITS 241663, ITS 241665 change FF/REW to Play on BT Call
       {
           controls_area.cancel_ff_rew()
           EngineListenerMain.setUnMuteForSeek(true); // added by suilyou 20140218 ITS 0225686
       }
       return true
   }
   //} added by yongkyun 2013.01.19

   function handleOnPressedAndHoldCritical(btn_id)
   {
       switch (btn_id)
       {
            case "Prev":
            {
                controls_area.critical_rew()
                break;
            }
            case "Next":
            {
                controls_area.critical_ff()
                break;
            }
       }
   }

   //{ modified by yongkyun.lee 2013-10-17 for : ITS 196623
   function resetPlaybackControl()
   {
       EngineListenerMain.qmlLog("[leeyk1]resetPlaybackControl")
       //isSeekPressed = false;
       //isBtMusic = false;// modified by yongkyun.lee 2013-10-24 for : ITS 194947
       isBTLong = false;
   }
   //} modified by yongkyun.lee 2013-10-17
  
   state: (video_model.playbackStatus == 0) ? "Play" :
   (video_model.playbackStatus == 1
    || video_model.playbackStatus == 2) ? "Pause" : // modified by Sergey 03.05.2013 for ISV_KR#76907
   (video_model.playbackStatus == 3) ? "4X" :
   (video_model.playbackStatus == 4) ? "16X" :
   (video_model.playbackStatus == 5) ? "20X" :
   (video_model.playbackStatus == 6) ? "4X" :
   (video_model.playbackStatus == 7) ? "16X" :
   (video_model.playbackStatus == 8) ? "20X" :
   (video_model.playbackStatus == 9) ? "Scan" : "Play"

   states :
   [
      State
      {
          name: "Play"
          StateChangeScript {
              name: "pauseToplay"
              script: setPauseState();
          }
      },
      State
      {
          name: "Pause"
          StateChangeScript {
              name: "playTopause"
              script: setPlayState();
          }
      },

      State
      {
          name: "4X"
          StateChangeScript {
              name: "4x"
              script: setSpeedRate(4);
          }
      },

      State
      {
          name: "16X"
          StateChangeScript {
              name: "16x"
              script: setSpeedRate(16);
          }
      },

      State
      {
          name: "20X"
          StateChangeScript {
              name: "16x"
              script: setSpeedRate(20);
          }
      },

      State
      {
          name: "Scan"
          StateChangeScript {
              name: "scan"
              script: setScanState();
          }
      }

      // { added by wspark 2012.08.14 for CR11620
      ,
      State
      {
          name: "Tune"
          StateChangeScript {
              name: "tune"
              script: setTuneState(true); // modified by wspark 2012.08.17 for DQA #26
          }
      }
      // } added by wspark
   ]

   //{ modified by yongkyun.lee 2013-07-24 for : ITS 181258
   onIsCommonJogEnabledChanged:
   {
       if(controls_area.isCommonJogEnabled == false )
       {
           clearAllJogs()
           //{ modified by yongkyun.lee 2013-08-29 for : ITS 186916
           //isJogProcessing = false;
           //oldArrow   = -1;
           //} modified by yongkyun.lee 2013-08-29
       }
   }
   //} modified by yongkyun.lee 2013-07-23

   onCurModeChanged:
   {
       controls_area.visible = ( video_model.progressBarMode == "AUX" )? false: true
   }

   // { added by wspark 2012.08.14 for CR11620
   onTuneModeChanged:
   {
       if(tuneMode == false)
       {
           if(state == "Play")
               setPauseState();
           else if(state == "Pause")
               setPlayState();

           setTuneState(false); // added by wspark 2012.08.17 for DQA #26
       }
   }
   // } added by wspark

   // { added by wspark 2013.02.21 for ISV 73305
   onCamModeChanged:
   {
       EngineListenerMain.qmlLog("onCamModeChanged")
   }
   // } added by wspark

   anchors.left: parent.left
   anchors.leftMargin : CONST.const_CONTROLS_LEFT_MARGIN

   anchors.top: parent.top
   // { modified by edo.lee  2013.08.10 ITS 183057
   anchors.topMargin: (onScreen)? CONST.const_CONTROLS_TOP_MARGIN : CONST.const_CONTROLS_TOP_MARGIN + CONST.const_FULL_SCREEN_OFFSET // (CONST.const_CONTROLS_TOP_MARGIN * 2)
   // } modified by edo.lee  2013.08.10 ITS 183057
   // { modified by Sergey 03.08.2013 for ITS#0180899
   Behavior on anchors.topMargin
   {
      PropertyAnimation
      {
          duration: (bFullScreenAnimation) ? CONST.const_FULLSCREEN_DURATION_ANIMATION : 0

          onRunningChanged:
          {
              if(!running && bFullScreenAnimation == false)
                  bFullScreenAnimation = true;
          }
      }
   }
   // } modified by Sergey 03.08.2013 for ITS#0180899

// added for expand touch area
   Rectangle{
      id: rectLeft
      color: "transparent"
      anchors
      {
         top: parent.top
         topMargin: CONST.const_CONTROLS_MA_TOP_MARGIN // added by cychoi 2015.11.06 for ISV 120461
         left: parent.left
         leftMargin: CONST.const_CONTROLS_MA_LEFT_MARGIN // added by cychoi 2015.11.06 for ISV 120461
      }
      width:105 //157 - CONST.const_CONTROLS_MA_LEFT_MARGIN // modified by cychoi 2015.11.06 for ISV 120461
      height:150
      clip:false
      MouseArea
      {
          id: mouseAreaLeft
          anchors.fill: parent
          enabled: (!btnModel.get(CONST.const_CONTROLS_FF_BTN_NUMBER).is_dimmed && controls_area.enabled) ? true : false
          beepEnabled: false
          noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445
          property bool bActive: false

          onExited:
          {
              EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaLeft -> onExited()") // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

              bActive = false

              var curIndex = CONST.const_CONTROLS_REW_BTN_NUMBER

              // added by sangmin.seol 2014.06.03 same code with btnDelegate MouseArea
              if(btnModel.get(curIndex).jog_pressed != true)
              {
                  EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaLeft onExited - jog_pressed = false")
                  return;
              }

              btnModel.set(curIndex,{jog_pressed: false})
              controls_area.handleOnCanceled("Prev") // modified by suilyou 20131127 DUAL_KEY

              return;
          }

          onCanceled:
          {
              EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaLeft -> onCanceled()") // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

              bActive = false

              var curIndex = CONST.const_CONTROLS_REW_BTN_NUMBER

              // added by sangmin.seol 2014.06.03 same code with btnDelegate MouseArea
              if(btnModel.get(curIndex).jog_pressed != true)
              {
                  EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaLeft onExited - jog_pressed = false")
                  return;
              }

              btnModel.set(curIndex,{jog_pressed: false})
              controls_area.handleOnCanceled("Prev") //DUAL_KEY

              return;
          }

          onPressed:
          {
              EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaLeft -> onPressed(), tuneMode = " + tuneMode) // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

              bActive = true
              if(tuneMode) return ;

              controls_area.isCommonJogEnabled=true  // added by sangmin.seol 2014.06.03 same code with btnDelegate MouseArea

              controls_area.handleJogEvent( UIListenerEnum.JOG_LEFT, UIListenerEnum.KEY_STATUS_PRESSED )

              // added by sangmin.seol 2014.06.03 same code with btnDelegate MouseArea
              if(!(isBtMusic == true && albumBTView.visible))
                  controls_area.hideFocusInParent()

              return;
          }

          onReleased:
          {
              EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaLeft -> onReleased(), bActive = " + bActive) // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

              timerPressedAndHoldCritical.stop()    // added by sangmin.seol ITS_0221686
              EngineListener.setPrevNextKeySwapState(false)	// added by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap

              if(!bActive /*&& !(is_ff_rew || is_Critical)*/ )
                 return;

              if(AudioController.GetFfRewState() != true) // modified by sangmin.seol ITS 0230761 Beep on Prev, Next Touch
                 UIListener.ManualBeep()

              bActive = false

              if(!tuneMode)
              {
                  controls_area.handleJogEvent( UIListenerEnum.JOG_LEFT, UIListenerEnum.KEY_STATUS_RELEASED )
                  return;
              }
              else
              {
                  handleOnRelease("Prev")
              }

              return;
          }

          onPressAndHold:
          {
              EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaLeft -> onPressAndHold()") // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

              if(tuneMode) return ;

              // { added by cychoi 2014.07.30 for ITS 244501, ITS 244504
              if(isBtMusic == true)
              {
                  bActive = false
              }
              // } added by cychoi 2014.07.30

              timerPressedAndHoldCritical.start()
              timerPressedAndHoldCritical.lastPressed = "Prev"
              controls_area.handleJogEvent( UIListenerEnum.JOG_LEFT, UIListenerEnum.KEY_STATUS_LONG_PRESSED )

              return;
          }
      }
   }

   Rectangle{
      id: rectCenter
      color: "transparent"
      anchors
      {
         top: parent.top
         left: rectLeft.right
      }
      width:176
      height:157 //150 // modified by cychoi 2015.11.06 for ISV 120461
      clip:false
   }

   Rectangle{
      id: rectRight
      color: "transparent"
      anchors
      {
         top: parent.top
         topMargin: CONST.const_CONTROLS_MA_TOP_MARGIN // added by cychoi 2015.11.06 for ISV 120461
         left: rectCenter.right
      }
      width:105 //157 - CONST.const_CONTROLS_MA_LEFT_MARGIN // modified by cychoi 2015.11.06 for ISV 120461
      height:150
      clip:false
      MouseArea
      {
          id: mouseAreaRight
          anchors.fill: parent
          enabled: (!btnModel.get(CONST.const_CONTROLS_FF_BTN_NUMBER).is_dimmed && controls_area.enabled) ? true : false
          beepEnabled: false
          property bool bActive: false
          noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445

          onExited:
          {
              EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaRight -> onExited()") // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

              bActive = false

              var curIndex = CONST.const_CONTROLS_FF_BTN_NUMBER

              // added by sangmin.seol 2014.06.03 same code with btnDelegate MouseArea
              if(btnModel.get(curIndex).jog_pressed != true)
              {
                  EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaLeft onExited - jog_pressed = false")
                  return;
              }

              btnModel.set(curIndex,{jog_pressed: false})
              controls_area.handleOnCanceled("Next") // modified by suilyou 20131127 DUAL_KEY

              return;
          }

          onCanceled:
          {
              EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaRight -> onCanceled()") // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

              bActive = false

              var curIndex = CONST.const_CONTROLS_FF_BTN_NUMBER

              // added by sangmin.seol 2014.06.03 same code with btnDelegate MouseArea
              if(btnModel.get(curIndex).jog_pressed != true)
              {
                  EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaRight onExited - jog_pressed = false")
                  return;
              }

              btnModel.set(curIndex,{jog_pressed: false})
              controls_area.handleOnCanceled("Next")

              return;
          }

          onPressed:
          {
              EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaRight -> onPressed(), tuneMode = " + tuneMode) // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

              bActive = true
              if(tuneMode) return ;

              controls_area.isCommonJogEnabled=true  // added by sangmin.seol 2014.06.03 same code with btnDelegate MouseArea

              controls_area.handleJogEvent( UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_PRESSED )

              // added by sangmin.seol 2014.06.03 same code with btnDelegate MouseArea
              if(!(isBtMusic == true && albumBTView.visible))
                  controls_area.hideFocusInParent()

              return;
          }

          onReleased:
          {
              EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaRight -> onReleased(), bActive = " + bActive) // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

              timerPressedAndHoldCritical.stop()    // added by sangmin.seol ITS_0221686
              EngineListener.setPrevNextKeySwapState(false)	// added by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap

              if(!bActive /*&& !(is_ff_rew || is_Critical)*/ )
                 return;

              if(AudioController.GetFfRewState() != true) // modified by sangmin.seol ITS 0230761 Beep on Prev, Next Touch
                 UIListener.ManualBeep()

              bActive = false

              if(!tuneMode)
              {
                  controls_area.handleJogEvent( UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_RELEASED )
                  return;
              }
              else
              {
                  handleOnRelease("Next")
              }

              return;
          }

          onPressAndHold:
          {
              EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, mouseAreaRight -> onPressAndHold()") // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

              if(tuneMode) return ;

              // { added by cychoi 2014.07.30 for ITS 244501, ITS 244504
              if(isBtMusic == true)
              {
                  bActive = false
              }
              // } added by cychoi 2014.07.30

              timerPressedAndHoldCritical.start()
              timerPressedAndHoldCritical.lastPressed = "Next"
              controls_area.handleJogEvent( UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_LONG_PRESSED )

              return;
          }
      }
   }
// added for expand touch area

   DHAVN_VP_FocusedRow
   {
      id: bottomElements
      focus_x: 0
      focus_y: 0
      name: "FocusedRow"
      spacing: CONST.const_CONTROLS_SPACING
      repeaterModel: btnModel
      repeaterComponent: btnDelegate
   }

   Component
   {
      id: btnDelegate

      Image
      {
         id: main_image
         //{changed by junam 2013.07.25 for dim control que
         //property bool is_dimmed: model.is_dimmed || false
         property bool is_dimmed: model.is_dimmed || (controls_area.enabled == false)
         //}changed by junam
         property bool jog_pressed: model.jog_pressed || false

         anchors.verticalCenter: parent.verticalCenter
         width: btn_width
         height: btn_height
         source: main_image.is_dimmed ? (icon_d || "") : "" // modified by sangmin.seol 2014.12.23 for ITS 254979

         /** Icon image */
         Image
         {
            id: visual_cue_icon
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            visible: !main_image.is_dimmed
            source: main_image.jog_pressed || mouseArea.bActive ? (icon_p || "") :
                       controls_area.isCommonJogEnabled && btn_id == "PlayButton" && !mediaPlayer.systemPopupVisible ?  (icon_f || "") : (icon_n || "")
            // } modified by sangmin.seol 2014.12.23
         }

         Image
         {
            id: play_pause_icon
            //modified by aettie UX fix 20130916
            anchors.left: parent.left
            anchors.leftMargin: CONST.const_PLAY_PAUSE_ICON_LEFT_MARGIN //29
            //anchors.horizontalCenter: parent.horizontalCenter
            // { modified by dongjin 2012.09.26 for No35 car DQA#94
            //anchors.verticalCenter:parent.verticalCenter
            anchors.top: parent.top
            anchors.topMargin: CONST.const_PLAY_PAUSE_ICON_TOP_MARGIN
            // } modified by dongjin
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            source:  main_image.is_dimmed ?  (icon2_d || "") : //added by junam 2013.07.25 for dim control que
                        main_image.jog_pressed || mouseArea.bActive ? (icon2_n || "") :
                        bottomElements.focus_visible && !mediaPlayer.systemPopupVisible ? (icon2_n || "") : ( icon2_n || "" )
            // } modified by sangmin.seol 2014.12.23
         }

         /** Button text */
         Text
         {
            id: text_loader
            anchors.centerIn: parent
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            color: is_dimmed ? CONST.const_WIDGET_CMDBTN_DIMMED_TEXT_COLOR : CONST.const_FF_REW_TEXT_COLOR
            // } modified by sangmin.seol 2014.12.23
            font.pointSize: CONST.const_WIDGET_CMDBTN_TEXT_SIZE
            font.family: CONST.const_WIDGET_CMDBTN_TEXT_FAMILY_NEW      //added by aettie.ji 2012.11.22 for NEW UX
            text: model.text || ""
         }

         // { modified by Sergey 18.04.2013
         MouseArea
         {
             id: mouseArea
             anchors.fill: parent
             enabled: (!is_dimmed /*&& !tuneMode*/ && controls_area.enabled) ? true : false // modified by edo.lee 2013.06.11
             beepEnabled: false // added by Sergey 08.05.2013
             noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445
             property bool bActive: false

             //{ modified by yongkyun.lee 2013-07-12 for : ISV 83569
             onExited:
             {
                 //EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls::btnDelegate ->MouseArea -> onExited()---------->>")
                 EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, btnDelegate -> MouseArea -> onExited(), btn_id = " + model.btn_id + ", bActive = " + bActive) // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

                 //if(tuneMode) return ;//{ modified by yongkyun.lee 2013-07-25 for : ITS 181263

                 var curIndex;

                 // { modified by sangmin.seol 2014.01.15 SMOKETest fix for MP3 shffule problem by FF SK button.
                 if(model.btn_id == "PlayButton")
                 {
                     curIndex = CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER;
                 }
                 else
                 {
                     curIndex = (model.btn_id == "Prev")?
                                     CONST.const_CONTROLS_REW_BTN_NUMBER: CONST.const_CONTROLS_FF_BTN_NUMBER;
                 }

                 bActive = false  // { moved by sangmin.seol 2014.03.11 ITS 0225385 H/U Tune Key Cancel Fix

                 if(btnModel.get(curIndex).jog_pressed != true)
                 {
                     return;
                 }
                 // } modified by sangmin.seol 2014.01.15 SMOKETest fix for MP3 shffule problem by FF SK button.

                 //bActive = false // { removed by sangmin.seol 2014.03.11 ITS 0225385 H/U Tune Key Cancel Fix

//                 if((oldArrow == UIListenerEnum.JOG_LEFT && model.btn_id == "Prev")
//                         || (oldArrow == UIListenerEnum.JOG_RIGHT && model.btn_id == "Next")) //added by junam 2013.09.07 for ITS_KOR_185529
//                 {
//                     isJogProcessing = false; // added by sungha.choi 2013.08.26 for JogEvent Mutex
//                     oldArrow   = -1;
//                 }

                 //{ modified by cychoi 2014.03.21 for ITS 230441
                 //{ added by hyochang.ryu 20130831 for ITS187032
                 if(EngineListenerMain.getisBTCall()&&isBtMusic&&model.btn_id == "PlayButton") //added by hyochang.ryu 20131005 for ITS191526
                 {
                     btnModel.set(curIndex,{jog_pressed: false})
                     //AudioController.sigShowBTCallPopup();
                     return;
                 }
                 //} added by hyochang.ryu 20130831 for ITS187032
                 //} modified by cychoi 2014.03.21

/*                 if((is_ff_rew == true || is_Critical == true) && !isBtMusic ) //added by hyochang.ryu 20130726 for BT	//  modified by yongkyun.lee 2013-07-17 for : NO CR
                 {
                    handleOnCancel_ff_rew();
                    return;
                 }*/ // removed by suilyou 20131127 DUAL_KEY

                 btnModel.set(curIndex,{jog_pressed: false})
                 controls_area.handleOnCanceled(model.btn_id)
             }

             onCanceled:
             {
                 // { modified by sangmin.seol 2014-03-10 fixed to same with onExited
                 //EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls::btnDelegate ->MouseArea -> onCanceled()---------->>")
                 EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, btnDelegate -> MouseArea -> onCanceled(), btn_id = " + model.btn_id) // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...
                 //if(tuneMode) return ;//{ modified by yongkyun.lee 2013-07-25 for : ITS 181263

                 var curIndex;

                 // { modified by sangmin.seol 2014.01.15 SMOKETest fix for MP3 shffule problem by FF SK button.
                 if(model.btn_id == "PlayButton")
                 {
                     curIndex = CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER;
                 }
                 else
                 {
                     curIndex = (model.btn_id == "Prev")?
                                     CONST.const_CONTROLS_REW_BTN_NUMBER: CONST.const_CONTROLS_FF_BTN_NUMBER;
                 }

                 bActive = false  // { moved by sangmin.seol 2014.03.11 ITS 0225385 H/U Tune Key Cancel Fix

                 if(btnModel.get(curIndex).jog_pressed != true)
                 {
                     return;
                 }
                 // } modified by sangmin.seol 2014.01.15 SMOKETest fix for MP3 shffule problem by FF SK button.

                 //bActive = false // { removed by sangmin.seol 2014.03.11 ITS 0225385 H/U Tune Key Cancel Fix

                 //{ modified by cychoi 2014.03.21 for ITS 230441
                 //{ added by hyochang.ryu 20130831 for ITS187032
                 if(EngineListenerMain.getisBTCall()&&isBtMusic&&model.btn_id == "PlayButton") //added by hyochang.ryu 20131005 for ITS191526
                 {
                     btnModel.set(curIndex,{jog_pressed: false})
                     //AudioController.sigShowBTCallPopup();
                     return;
                 }
                 //} added by hyochang.ryu 20130831 for ITS187032
                 //} modified by cychoi 2014.03.21

                 btnModel.set(curIndex,{jog_pressed: false})
                 controls_area.handleOnCanceled(model.btn_id)
                 // } modified by sangmin.seol 2014-03-10 fixed to same with onExited
             }
             //} modified by yongkyun.lee 2013-07-12

             /*onClicked:
             {
                 bActive = false
                 handleOnRelease(model.btn_id)
             }*/

             onPressed:
             {
                 //EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls::btnDelegate ->MouseArea -> onPressed()---------->>")
                 EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, btnDelegate -> MouseArea -> onPressed(), btn_id = " + model.btn_id) // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

                 //{ added by yongkyun.lee 20130601 for : ITS 146106
         // modified by ravikanth 23.06.13. Moved bActive before return.
                 bActive = true //added by yongkyun.lee 20130612 for :  ITS 146106
                 controls_area.isCommonJogEnabled=true
                 if(tuneMode) return ;//added by edo.lee 2013.06.11
                 if(model.btn_id == "Prev")
                 {
                     controls_area.handleJogEvent( UIListenerEnum.JOG_LEFT, UIListenerEnum.KEY_STATUS_PRESSED )
                     return;
                 }
                 else if(model.btn_id == "Next")
                 {
                     controls_area.handleJogEvent( UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_PRESSED )
                     return;
                 }
                 // { added by sangmin.seol 2014-03-10 to PlayButton onExit function.
                 else if(model.btn_id == "PlayButton")
                 {
                     controls_area.handleJogEvent( UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_PRESSED )
                     return;
                 }
                 // { added by sangmin.seol 2014-03-10 to PlayButton onExit function.
                 //} added by yongkyun.lee 20130601
                     //bActive = true //deleted by yongkyun.lee 20130612 for :  ITS 146106
           //          isSeekPressed = true//added by edo.lee 2013.05.30
                     if(!(isBtMusic == true && albumBTView.visible))//{ modified by yongkyun.lee 2013-11-20 for : ITS 210014
                         controls_area.hideFocusInParent()
             }
//             onExited:
//             {
//                 if (mouseArea.pressed)
//                 {
//                    bActive = false
//                    handleOnCancel_ff_rew()
//                 }
//             } // commented by Sergey 18.05.2013
// modified by Dmitry 25.05.13
             onReleased:
             {
                 //EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls::btnDelegate ->MouseArea -> onReleased()---------->>")
                 EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, btnDelegate -> MouseArea -> onReleased(), btn_id = " + model.btn_id) // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

                 timerPressedAndHoldCritical.stop()    // added by sangmin.seol ITS_0221686
                 EngineListener.setPrevNextKeySwapState(false)		// added by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap

                 //{ added by yongkyun.lee 20130612 for :  ITS 146106
                 if(!bActive /*&& !(is_ff_rew || is_Critical)*/ )
                    return;
                 //} added by yongkyun.lee 20130612
                 bActive = false

                 // removed by oseong.kwon for PQ.09.34.8 Ver.NA Smoke Test
                 if(model.btn_id == "PlayButton" || AudioController.GetFfRewState() != true) // modified by sangmin.seol ITS 0230761 Beep on Prev, Next and Playbutton release
                    UIListener.ManualBeep()

                 // removed by Sergey 13.08.2013 for ITS#183043

                 if(model.btn_id == "Prev" && !tuneMode)//modified by edo.lee 2013.06.11
                 {
                     controls_area.handleJogEvent( UIListenerEnum.JOG_LEFT, UIListenerEnum.KEY_STATUS_RELEASED )
                     return;
                 }
                 else if(model.btn_id == "Next" && !tuneMode)//modified by edo.lee 2013.06.11
                 {
                     controls_area.handleJogEvent( UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_RELEASED )
                     return;
                 }
                 else
                 //} added by yongkyun.lee 20130601
                 {
                     // removed by Sergey 13.08.2013 for ITS#183043
                     handleOnRelease(model.btn_id)
                 }
// modified by Dmitry 25.05.13
             }

             onPressAndHold:
             {
                 EngineListenerMain.qmlLog("DHAVN_AudioPlaybackControls, btnDelegate -> MouseArea -> onPressAndHold(), btn_id = " + model.btn_id) // modified by sangmin.seol 2014.09.12 reduce high log // 2014.06.03 touch critical log...

                 if(tuneMode) return ;//added by edo.lee 2013.06.11
                 //{ added by yongkyun.lee 20130601 for :
                 //handleOnPressAndHold(model.btn_id,true)
//                 if(is_ff_rew || is_Critical )
//                    return;

                 // { added by cychoi 2014.07.30 for ITS 244501, ITS 244504
                 if(isBtMusic == true)
                 {
                     bActive = false
                 }
                 // } added by cychoi 2014.07.30

                 if(model.btn_id == "Prev")
                 {
                     timerPressedAndHoldCritical.start()
                     timerPressedAndHoldCritical.lastPressed = model.btn_id
                     controls_area.handleJogEvent( UIListenerEnum.JOG_LEFT, UIListenerEnum.KEY_STATUS_LONG_PRESSED )
                     // removed by yongkyun.lee 2013-08-06 for : ITS 182922
                     return;
                 }
                 else if(model.btn_id == "Next")
                 {
                     timerPressedAndHoldCritical.start()
                     timerPressedAndHoldCritical.lastPressed = model.btn_id
                     controls_area.handleJogEvent( UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_LONG_PRESSED )
                     // removed by yongkyun.lee 2013-08-06 for : ITS 182922
                     return;
                 }
                 //} added by yongkyun.lee 20130601
             }
         } // } modified by Sergey 18.04.2013
      } // Image
      // focusedItem
   }     // end of component


   DHAVN_VP_Model_PlaybackControls
   {
      id: btnModel
   }

   Timer
   {
      id: timerPressedAndHoldCritical
      interval: 4200
      running: false
      property string lastPressed: ""
      onTriggered:
      {
          if(isBtMusic == true) return; // added by oseong.kwon for PQ.09.34.8 Ver.NA Smoke Test
          handleOnPressedAndHoldCritical(timerPressedAndHoldCritical.lastPressed)
          //UIListener.ManualBeep() // removed by sangmin.seol 2014.06.05 ITS 0230761 // modified by yongkyun.lee 2013-08-22 for : ISV 89537
          // removed by yongkyun.lee 2013-08-06 for : ITS 182922
      }
   } //timer

   // modified by ravikanth 05-07-13 for ITS 0178426
   Connections
   {
       target: EngineListener
       onSeekHandlejogevent:
       {
           EngineListenerMain.qmlLog("ravi6 connection");
           var curIndex = (arrow == UIListenerEnum.JOG_LEFT)?
                       CONST.const_CONTROLS_REW_BTN_NUMBER: CONST.const_CONTROLS_FF_BTN_NUMBER
           if(status == UIListenerEnum.KEY_STATUS_PRESSED)
           {
               handleOnPress(btnModel.get(curIndex).btn_id) // added by Sergey 19.05.2013
               btnModel.set(curIndex,{jog_pressed: true})
           }
           else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
           {
               controls_area.handleOnRelease(btnModel.get(curIndex).btn_id)
               btnModel.set(curIndex,{jog_pressed: false})
               controls_area.released(btnModel.get(curIndex).btn_id) //added by junam 2013.05.18 for ISV_KR81848
           }
           else if(status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
           {
               btnModel.set(curIndex,{jog_pressed: true}) // added by Sergey 20.04.2013
               controls_area.handleOnPressAndHold(btnModel.get(curIndex).btn_id,false)
           }
           else if(status == UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED)
           {
               btnModel.set(curIndex,{jog_pressed: true}) // added by Sergey 20.04.2013
               controls_area.handleOnPressedAndHoldCritical(btnModel.get(curIndex).btn_id)
           }
           break
       }

       // added sangmin.seol 2014.03.11 for ITS 0225385 H/U Tune Key Cancel Fix
       onCancelPressedControlCue:
       {
           var index

           for(index = CONST.const_CONTROLS_REW_BTN_NUMBER; index <= CONST.const_CONTROLS_FF_BTN_NUMBER; ++index)
           {
               if(btnModel.get(index).jog_pressed == true)
               {
                   btnModel.set(index,{jog_pressed: false})
                   controls_area.handleOnCanceled(btnModel.get(index).btn_id)
               }
           }
       }
       // added sangmin.seol 2014.03.11 for ITS 0225385 H/U Tune Key Cancel Fix
   }
}
// modified by Dmitry 15.05.13
// } added by Sergey 24.08.2013  for separating Audio and Video playback controls

