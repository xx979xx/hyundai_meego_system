import QtQuick 1.0
import Qt 4.7
import AppEngineQMLConstants 1.0
import VPEnum 1.0	// added by Sergey 28.08.2013 for ITS#186507 

import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../models"

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
   property bool is_ff_rew: false
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
   property bool isSeekPressed:false //added by edo.lee 2013.06.30
   property bool isBTLong: false // added by hyochang.ryu 20130727
   property bool isBasicControlEnableStatus : true //added by junam 2013.08.15 for muisc app control icon
   property bool isPlaybackControlQMLIsLoaded : EngineListener.setPlaybackControlQMLIsLoaded(true) // modified by sjhyun 2013.11.11 for ITS 206822

   property int activeArrow: UIListenerEnum.JOG_NONE	// modified by Sergey 28.08.2013 for ITS#186507 

   property bool isCancelHKafterTouch: false // added by kihyung 2013.10.28 to do next/prev after cancel FF/REW
   property bool bSystemPopupVisible: false // added by cychoi 2014.07.24 for ITS 243910, ITS 243911 control cue focus

   default_x: 0
   default_y: 0

   /** Signals */
   signal prev_pressed(); // added by Sergey 19.05.2013
   signal next_pressed(); // added by Sergey 19.05.2013
   signal prev_clicked();
   signal next_clicked();
   signal play_button_clicked();
   signal jog_longpress();
   signal long_ff();
   signal long_rew();
   signal critical_rew()
   signal critical_ff()
   signal cancel_ff_rew()
   // removed by Sergey 09.09.2013 for ITS#188944
   signal lostFocus( int direction )
   signal released(string btnId) //added by junam 2013.05.18 for ISV_KR81848
   signal select_Tune();//added by edo.lee 2013.06.11


   
   // { added by Sergey 09.09.2013 for ITS#188944
   function log(str)
   {
       EngineListenerMain.qmlLog("DHAVN_VP_PlaybackControls " + str);
   }
   // } added by Sergey 09.09.2013 for ITS#188944

   
   // { modified by Sergey 28.08.2013 for ITS#186507
   function handleJogEvent( arrow, status )
   {
       // { added by Sergey 26.10.2013 to fix SEEK after ModeArea focus

       if(arrow == UIListenerEnum.JOG_UP)//modified by taihyun.ahn for dual key
       {
           if(EngineListener.seekHKPressed())
                handleOnCancel_ff_rew()
           if(status == UIListenerEnum.KEY_STATUS_PRESSED /*&& !EngineListener.seekHKPressed()*/)
               controls_area.lostFocus(arrow);

           return;
       }
       // } added by Sergey 26.10.2013 to fix SEEK after ModeArea focus

       log("handleJogEvent pbOwner = " + EngineListener.pbOwner + "  disp = " + SM.disp)    // uncommented by Sergey 17.10.2013 for ITS#195124

       if(arrow == UIListenerEnum.JOG_WHEEL_LEFT || arrow == UIListenerEnum.JOG_WHEEL_RIGHT) // tune is not handled here
           return;

       // comment by edo.lee 2013.11.13 ITS 0209068 
       //if(EngineListener.pbOwner != SM.disp && EngineListener.pbOwner != VPEnum.VDISP_MAX) // ignores simultaneous events from front and rear jogs (for DRS mode)
       //    return;

       log("handleJogEvent new arrow = " + arrow +" active arrow = "+ controls_area.activeArrow + " status = " + status)  // uncommented by Sergey 17.10.2013 for ITS#195124

       if(EngineListener.seekHKPressed())//Added by taihyun.ahn for dualkey 2013.12.27
           isCancelHKafterTouch = true;
      // comment by edo.lee 2013.11.05 ITS 196043
      // if(controls_area.activeArrow != arrow && controls_area.activeArrow != UIListenerEnum.JOG_NONE) // ignores simultaneous left and right arrows from same jog (for clone mode case)
      //     return;


       log("handleJogEvent Jog event passed")     // uncommented by Sergey 17.10.2013 for ITS#195124

       if(status == UIListenerEnum.KEY_STATUS_PRESSED)
       {          
           EngineListener.pbOwner = SM.disp;
           controls_area.activeArrow = arrow;
       }
       // } modified by Sergey 28.08.2013



       switch ( arrow )
       {
           // { commented by Sergey 26.10.2013 to fix SEEK after ModeArea focus
           //       case UIListenerEnum.JOG_UP:
           //       {
           //       //modified by aettie Focus moves when pressed 20131015
           ////           if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
           //           if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
           //           {
           //               controls_area.lostFocus( arrow )
           //           }
           //           break
           //       }
           // } commented by Sergey 26.10.2013 to fix SEEK after ModeArea focus

       case UIListenerEnum.JOG_RIGHT:
       case UIListenerEnum.JOG_LEFT:
       {
           if (!enabled) return; // added by Dmitry 28.04.13

           var curIndex = (arrow == UIListenerEnum.JOG_LEFT)?
                   CONST.const_CONTROLS_REW_BTN_NUMBER: CONST.const_CONTROLS_FF_BTN_NUMBER

           if(status == UIListenerEnum.KEY_STATUS_PRESSED)
           {
               //{ added by yongkyun.lee 20130601 for : ITS 146106
               // { commented by cychoi 2014.09.02 for DUAL_KEY
               //if(is_ff_rew)
               //    return;
               // } commented by cychoi 2014.09.02
               //} added by yongkyun.lee 20130601
               isSeekPressed = true;//added by edo.lee 2013.05.30
               handleOnPress(btnModel.get(curIndex).btn_id) // added by Sergey 19.05.2013
               lightControls(curIndex, true, true); // added by Sergey 10.10.2013 for ITS#194643
               EngineListener.repaintUIQML(SM.disp); // added by Sergey 27.12.2013 for ITS#217503
           }
           else if(status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED )// added by yongkyun.lee 20130801 for : ITS 181898
           {
               EngineListener.stopFFRewTimer(); // added by Sergey13.10.13
               isLeftRight= UIListenerEnum.JOG_NONE;  // added by yongkyun.lee 20130601 for : ITS 146106
               //{ added by hyochang.ryu 20130727
               if(isBTLong == true)
                   isBTLong = false; 
               else if(status == UIListenerEnum.KEY_STATUS_RELEASED) //{ modified by yongkyun.lee 2013-10-27 for : ITS 195924
                   //} added by hyochang.ryu 20130727
                   controls_area.handleOnRelease(btnModel.get(curIndex).btn_id)
               //isSeekPressed = false; // commented by cychoi 2014.09.02 for DUAL_KEY //added by edo.lee 2013.10.07
               lightControls(curIndex, false, true); // added by Sergey 10.10.2013 for ITS#194643
               controls_area.released(btnModel.get(curIndex).btn_id) //added by junam 2013.05.18 for ISV_KR81848
               if(status == UIListenerEnum.KEY_STATUS_CANCELED)//added by taihyun.ahn 2013.11.05 for ITS 198908
               {
                   handleOnCancel_ff_rew()
               }
           }
           else if(status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
           {
               //{ added by hyochang.ryu 20130727
               isCancelHKafterTouch = false;//Added by taihyun.ahn for dualkey 2013.12.27
               if(isBtMusic == true) 
               {
                   lightControls(curIndex, false, true); // added by Sergey 10.10.2013 for ITS#194643
                   isBTLong = true;
                   return;
               }
               //} added by hyochang.ryu 20130727
               // { modified by cychoi 2014.09.02 for DUAL_KEY
               if(controls_area.activeArrow == arrow)
               {
                   isSeekPressed = false; // added by yongkyun.lee 20130627 for :  ITS 176166
               }
               // } modified by cychoi 2014.09.02
               //{ added by yongkyun.lee 20130601 for : ITS 146106
               if(is_ff_rew || is_Critical)
                   return;
               if(arrow == UIListenerEnum.JOG_RIGHT)
                   isLeftRight= UIListenerEnum.JOG_RIGHT;
               else
                   isLeftRight= UIListenerEnum.JOG_LEFT;
               //} added by yongkyun.lee 20130601

               lightControls(curIndex, true, true); // added by Sergey 10.10.2013 for ITS#194643
               EngineListener.repaintUIQML(SM.disp);// added for ITS 236669 2014.05.26
               controls_area.handleOnPressAndHold(btnModel.get(curIndex).btn_id,false)
               //                islongKey = true;// added by yongkyun.lee 20130822 for : Multi Key-Only First key
               UIListener.ManualBeep() // modified by yongkyun.lee 2013-08-06 for : ITS 182922
           }
           else if(status == UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED)
           {
               //{ added by hyochang.ryu 20130727
               isCancelHKafterTouch = false;//Added by taihyun.ahn for dualkey 2013.12.27
               if(isBtMusic == true) 
               {
                   lightControls(curIndex, false, true); // added by Sergey 10.10.2013 for ITS#194643
                   isBTLong = true;
                   return;
               }
               //} added by hyochang.ryu 20130727
               //{ added by yongkyun.lee 20130627 for :  ITS 176166
               // { modified by cychoi 2014.09.02 for DUAL_KEY
               if(controls_area.activeArrow == arrow)
               {
                   isSeekPressed = false;
               }
               // } modified by cychoi 2014.09.02
               if( !is_ff_rew ||is_Critical)
                   return;
               //} added by yongkyun.lee 20130627 
               //               if(islongKey == false ) break;  // added by yongkyun.lee 20130822 for : Multi Key-Only First key
               lightControls(curIndex, true, true); // added by Sergey 10.10.2013 for ITS#194643
               EngineListener.repaintUIQML(SM.disp);// added for ITS 236669 2014.05.26
               controls_area.handleOnPressedAndHoldCritical(btnModel.get(curIndex).btn_id)
               UIListener.ManualBeep()  // modified by yongkyun.lee 2013-08-06 for : ITS 182922
           }
           break
       }

       // modified by Dmitry 26.05.13
       case UIListenerEnum.JOG_CENTER:
       {
           //{ added by yongkyun.lee 20130627 for :  ITS 176166
           ///if (!enabled ) return; // added by Dmitry 28.04.13
           if (!enabled || (is_ff_rew || is_Critical)) return;
           //} added by yongkyun.lee 20130627
           if(status == UIListenerEnum.KEY_STATUS_PRESSED)
           {
               isSeekPressed = true;//added by edo.lee 2013.05.30
               lightControls(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, true, true); // added by Sergey 16.10.2013 for ITS#195505
               EngineListener.repaintUIQML(SM.disp); // added by Sergey 27.12.2013 for ITS#217503
               controller.onMousePressed(); // added by Sergey 12.10.2013 for ITS#195210
           }
           else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
           {
               //added by suilyou 20130927 ITS 0185074 START
               if(btnModel.get(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER).jog_pressed!=true)
               {
                   EngineListenerMain.qmlLog("return Invalid Key");
                   return;
               }
               //added by suilyou 20130927 ITS 0185074 END
               //isSeekPressed = false; // commented by cychoi 2014.09.02 for DUAL_KEY //added by edo.lee 2013.10.07
               lightControls(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, false, true); // added by Sergey 16.10.2013 for ITS#195505
               controller.onMouseReleased(); // added by Sergey 12.10.2013 for ITS#195210
               // removed by Sergey 13.08.2013 for ITS#183043
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
               //isSeekPressed = false; // commented by cychoi 2014.09.02 for DUAL_KEY //added by edo.lee 2013.10.07
               lightControls(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, false, true); // added by Sergey 16.10.2013 for ITS#195505
               controller.onMouseReleased(); // added by Sergey 12.10.2013 for ITS#195210
           }
           break
           // modified by Dmitry 26.05.13
       }
       }//switch

       if(status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED)
       {
           // { modified by cychoi 2014.09.02 for DUAL_KEY
           if(controls_area.activeArrow == arrow &&
              !(EngineListener.seekHKPressed() || EngineListener.seekSKPressed()))
           {
               isSeekPressed = false;//added by edo.lee 2013.10.07
               EngineListener.pbOwner = VPEnum.VDISP_MAX;
               controls_area.activeArrow = UIListenerEnum.JOG_NONE;
           }
           // } modified by cychoi 2014.09.02
       }

   }
   // } modified by Sergey 28.08.2013 for ITS#186507


   function setPlayState()
   {
      //{ added by yongkyun.lee 20130627 for :  ITS 176166
      //if(!is_ff_rew && !is_scan && !is_Critical)		//added by hyochang.ryu 20130620  
      if(!is_ff_rew && !is_scan && !tuneMode) // modified by Sergey 26.11.2013 for ITS#211040
      //} added by yongkyun.lee 20130627 
      {
         btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: ""})

          //{changed by junam 2013.08.15 for muisc app control icon
          //if((isBtMusic == true) && albumBTView.visible) // BT music icon modified 2012.08.25
          if((isBtMusic == true && albumBTView.visible) || isBasicControlEnableStatus == false)
          { //}changed by junam
            EngineListenerMain.qmlLog("setPlayState case 1")
            btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: ""})
            btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                  {icon2_p: "/app/share/images/general/media_play_p.png"})
            btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                  {icon2_n: "/app/share/images/general/media_play_n.png"})
              btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {icon2_d: "/app/share/images/general/media_play_d.png"}) //added by junam 2013.08.15 for muisc app control icon
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
       if(!is_ff_rew && !is_scan && !tuneMode) // modified by Sergey 26.11.2013 for ITS#211040
       //} added by yongkyun.lee 20130627 
      {
           //{changed by junam 2013.08.15 for muisc app control icon
           //if((isBtMusic == true) && albumBTView.visible)
           if((isBtMusic == true && albumBTView.visible) || isBasicControlEnableStatus == false)
           {//}changed by junam
               EngineListenerMain.qmlLog("setPauseState case 1")
               btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {text: ""})
               btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                            {icon2_p: "/app/share/images/general/media_play_p.png"})
               btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,
                            {icon2_n: "/app/share/images/general/media_play_n.png"})
               btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, {icon2_d: "/app/share/images/general/media_play_d.png"}) //added by junam 2013.08.15 for muisc app control icon
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
               // { added by cychoi 2015.09.17 for ITS 268839
               if(curMode == "FS")
               {
                   //{ added by yongkyun.lee 20130326 for : ISV 77220
                   lightControls(CONST.const_CONTROLS_REW_BTN_NUMBER, false, true);
                   lightControls(CONST.const_CONTROLS_FF_BTN_NUMBER, false, true); // added by Sergey 10.10.2013 for ITS#194643
                   //} added by yongkyun.lee 20130326
               }
               // } added by cychoi 2015.09.17
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

	// removed by Sergey 24.08.2013 for ITS#185556 

   function clearAllJogs()
   {
      EngineListenerMain.qmlLog(" clearAllJogs()")
       EngineListenerMain.clearCCPJogKey(); // added by suilyou 20131002
       EngineListenerMain.clearRRCJogKey();// added by suilyou 20131002

      handleOnCancel_ff_rew()
       EngineListener.pbOwner = VPEnum.VDISP_MAX;
       controls_area.activeArrow = UIListenerEnum.JOG_NONE;

      btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER,{jog_pressed: false})
      lightControls(CONST.const_CONTROLS_REW_BTN_NUMBER, false, true);
      lightControls(CONST.const_CONTROLS_FF_BTN_NUMBER, false, true); // added by Sergey 10.10.2013 for ITS#194643

      //isSeekPressed = false;   // modify by yongkyun.lee 20130703 for : ITS 177707
   }

   // { added by Sergey 10.10.2013 for ITS#194643
   function lightControls(item, isOn, isAllDisp)
   {
       btnModel.set(item, {jog_pressed: isOn})

       if(isAllDisp)
       {
           var otherDisp = (SM.disp == VPEnum.VDISP_FRONT) ? VPEnum.VDISP_REAR : VPEnum.VDISP_FRONT;
           EngineListener.lightPlaybackControls(item, isOn, otherDisp);
       }
   }
   // } added by Sergey 10.10.2013 for ITS#194643

   function handleOnPress(btn_id)
   {
       switch (btn_id)
       {
          case "Prev":
          {
              controls_area.prev_pressed()
              // { modified by cychoi 2014.04.16 for ITS 234889 //{added for ITS 228567
              if(controls_area.isCommonJogEnabled == true && !EngineListener.seekHKPressed()) // modified by cychoi 2014.09.03 for ITS 247964, ITS 247965
              {
                  SM.setDefaultFocus();
                  showFocus();
              }
              // { modified by cychoi 2014.04.16 //}added for ITS 228567
              break;
          }
          case "Next":
          {
              controls_area.next_pressed()
              // { modified by cychoi 2014.04.16 for ITS 234889 //{added for ITS 228567
              if(controls_area.isCommonJogEnabled == true && !EngineListener.seekHKPressed()) // modified by cychoi 2014.09.03 for ITS 247964, ITS 247965
              {
                  SM.setDefaultFocus();
                  showFocus();
              }
              // { modified by cychoi 2014.04.16 //}added for ITS 228567
              break;
          }
       }
       //isSeekPressed = true; // commented by cychoi 2014.09.02 for DUAL_KEY //added by edo.lee 2013.05.30
   } // added by Sergey 19.05.2013

   function handleOnRelease(btn_id)
   {
      switch (btn_id)
      {
         case "Prev":
         {
            // { modified by kihyung 2013.10.28. To do prev after cancel FF/REW.
            /*
            if (!handleOnCancel_ff_rew() && isSeekPressed )//added by edo.lee 2013.05.30
            {
               EngineListenerMain.qmlLog("ZZZ handleOnRelease PREV clicked")
               controls_area.prev_clicked()
            }
            */
            if( handleOnCancel_ff_rew() == false)
            {
                if( isSeekPressed )
                {
                    EngineListenerMain.qmlLog("isSeekPressed handleOnRelease PREV clicked")
                    controls_area.prev_clicked()
                }
            }
            else
            {
                if( isCancelHKafterTouch )
                {
                    EngineListenerMain.qmlLog("isCancelHKafterTouch handleOnRelease PREV clicked")
                    //controls_area.prev_clicked()
                }
            }
            isCancelHKafterTouch = false
            // } modified by kihyung 2013.10.28

            EngineListener.rewReachedFirst = false // added by Sergey 28.05.2013
            break;
         }

         case "Next":
         {
            // { modified by kihyung 2013.10.28. To do next after cancel FF/REW.
            /*
            if (!handleOnCancel_ff_rew() && isSeekPressed )//added by edo.lee 2013.05.30
            {
               EngineListenerMain.qmlLog("ZZZ handleOnRelease NEXT clicked")
               controls_area.next_clicked()
            }
            */
            if( handleOnCancel_ff_rew() == false)
            {
                if( isSeekPressed )
                {
                    EngineListenerMain.qmlLog("isSeekPressed handleOnRelease NEXT clicked")
                    controls_area.next_clicked()
                }
            }
            else
            {
                if( isCancelHKafterTouch )
                {
                    EngineListenerMain.qmlLog("isCancelHKafterTouch handleOnRelease NEXT clicked")
                    //controls_area.next_clicked()
                }
            }
            isCancelHKafterTouch = false
            // } modified by kihyung 2013.10.28
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
      //isSeekPressed = false; // commented by cychoi 2014.09.02 for DUAL_KEY //added by edo.lee 2013.05.30
   }

   function handleOnPressAndHold(btn_id, start)
   {
       //{ added by yongkyun.lee 20130601 for :  ITS 146106
      if(is_ff_rew  && is_Critical )
           return;
       //} added by yongkyun.lee 20130601 
      switch (btn_id)
      {
         case "Prev":
         {
            controls_area.long_rew()
            is_ff_rew = true;
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
            is_ff_rew = true;
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
        timerPressedAndHoldCritical.stop() // moved by cychoi 2014.04.07 for ITS 233743
        timerPressedAndHoldCritical.lastPressed = "" // added by cychoi 2014.04.07 for ITS 233743
        //{ added by yongkyun.lee 20130607 for : ITS 146106
        //if (is_ff_rew == true  )
        if (is_ff_rew == true || is_Critical == true)// || EngineListenerMain.getisBTCall())//modified by taihyun.ahn 2013.12.06
        //} added by yongkyun.lee 20130607 
        {
            is_ff_rew = false;
            is_Critical = false //  added by yongkyun.lee 20130601 for : ITS 146106
            controls_area.cancel_ff_rew()
            return true
        }
        return false
   }
   //} added by yongkyun 2013.01.19

   function handleOnPressedAndHoldCritical(btn_id)
   {
       //{ added by yongkyun.lee 20130601 for :  ITS 146106
      //if(is_ff_rew == true)
      if(is_ff_rew == true && is_Critical == false )
       //} added by yongkyun.lee 20130601 
      {
         switch (btn_id)
         {
            case "Prev":
            {
               is_Critical = true;//  added by yongkyun.lee 20130601 for : ITS 146106
               controls_area.critical_rew()
               break;
            }
            case "Next":
            {
               is_Critical = true;//  added by yongkyun.lee 20130601 for : ITS 146106
               controls_area.critical_ff()
               break;
            }
         }
      }
   }

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
           log("onMousePressed"); // added by sjhyun 2013.11.08 for ITS 207579
           btnModel.set(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER , {jog_pressed : false}) //added by edo.lee 2013.11.20 ITS 0210032 
		   
           if(state == "Play")
               setPauseState();
           else if(state == "Pause")
               setPlayState();

           setTuneState(false); // added by wspark 2012.08.17 for DQA #26
       }
       else
       {
           setTuneState(true);
       }
   }
   // } added by wspark

        // removed by Sergey 10.10.2013 for ITS#194643
   
   anchors.left: parent.left
   anchors.leftMargin : CONST.const_CONTROLS_LEFT_MARGIN

   anchors.top: parent.top
   // { modified by edo.lee  2013.08.10 ITS 183057
   anchors.topMargin: (onScreen)? CONST.const_CONTROLS_TOP_MARGIN : CONST.const_CONTROLS_TOP_MARGIN + CONST.const_FULL_SCREEN_OFFSET + 10 // modified for expand touch area
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
          enabled: (!is_dimmed && controls_area.enabled) ? true : false
          beepEnabled: false

          property bool bActive: false

          onExited: onMouseExited();
          onCanceled: onMouseCanceled();
          onPressed: onMousePressed();
          onReleased: onMouseReleased();
          onPressAndHold: onMousePressAndHold();

          function onMousePressed()
          {
              bActive = true

              if(tuneMode) return ;

              EngineListener.setSeekSKPressed(true); // added by cychoi 2014.09.02 for DUAL_KEY
              controls_area.handleJogEvent( UIListenerEnum.JOG_LEFT, UIListenerEnum.KEY_STATUS_PRESSED )
          }

          function onMouseReleased()
          {
              if(!bActive && !(is_ff_rew || is_Critical) )
                  return;

              // { moved by oseong.kwon 2014.10.14 for ITS 250190 & ITS 250191
              if(!(isBtMusic == true && albumBTView.visible)||(!is_ff_rew && !is_Critical ))
                  if(!(is_ff_rew || is_Critical) && !tuneMode)
                      UIListener.ManualBeep()
              // } moved by oseong.kwon 2014.10.14

              bActive = false
              EngineListener.setSeekSKPressed(false); // added by cychoi 2014.09.02 for DUAL_KEY

              if(!tuneMode)
              {
                  controls_area.handleJogEvent( UIListenerEnum.JOG_LEFT, UIListenerEnum.KEY_STATUS_RELEASED )
                  return;
              }
              else
              {
                  handleOnRelease( "Prev" )
                  // { added by cychoi 2014.09.02 for DUAL_KEY
                  if(controls_area.activeArrow == UIListenerEnum.JOG_LEFT)
                  {
                      isSeekPressed = false;//added by edo.lee 2013.10.07
                  }
                  // } added by cychoi 2014.09.02
              }
          }

          function onMouseExited()
          {
              if(!bActive)
                  return;

              if(is_ff_rew || is_Critical)
              {
                 onMouseReleased("Prev");
              }
              else
              {
                  EngineListener.setSeekSKPressed(false); // added by cychoi 2014.09.02 for DUAL_KEY
                  lightControls(CONST.const_CONTROLS_REW_BTN_NUMBER, false, true); // added by Sergey 10.10.2013 for ITS#194643
                  // { added by cychoi 2014.09.02 for DUAL_KEY
                  if(controls_area.activeArrow == UIListenerEnum.JOG_LEFT &&
                     !(EngineListener.seekHKPressed() || EngineListener.seekSKPressed()))
                  {
                      isSeekPressed = false;//added by edo.lee 2013.10.07
                      EngineListener.pbOwner = VPEnum.VDISP_MAX;
                      controls_area.activeArrow = UIListenerEnum.JOG_NONE;
                  }
                  // } added by cychoi 2014.09.02
              }

              bActive = false
              // { commented by cychoi 2014.09.02 for DUAL_KEY
              //EngineListener.pbOwner = VPEnum.VDISP_MAX;
              //controls_area.activeArrow = UIListenerEnum.JOG_NONE;
              // } commented by cychoi 2014.09.02
          }

          function onMouseCanceled()
          {
              onMouseExited();
          }

          function onMousePressAndHold()
          {
              if(tuneMode) return ;

              if(is_ff_rew || is_Critical )
                  return;

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
          enabled: (!is_dimmed && controls_area.enabled && onScreen) ? true : false
          beepEnabled: false

          property bool bActive: false

          onExited: onMouseExited();
          onCanceled: onMouseCanceled();
          onPressed: onMousePressed();
          onReleased: onMouseReleased();
          onPressAndHold: onMousePressAndHold();

          function onMousePressed()
          {
              bActive = true

              if(tuneMode) return ;

              EngineListener.setSeekSKPressed(true); // added by cychoi 2014.09.02 for DUAL_KEY
              controls_area.handleJogEvent( UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_PRESSED )
              return;
          }

          function onMouseReleased()
          {
              if(!bActive && !(is_ff_rew || is_Critical) )
                  return;

              // { moved by oseong.kwon 2014.10.14 for ITS 250190 & ITS 250191
              if(!(isBtMusic == true && albumBTView.visible)||(!is_ff_rew && !is_Critical ))
                  if(!(is_ff_rew || is_Critical) && !tuneMode)
                      UIListener.ManualBeep()
              // } moved by oseong.kwon 2014.10.14

              bActive = false
              EngineListener.setSeekSKPressed(false); // added by cychoi 2014.09.02 for DUAL_KEY

              if(!tuneMode)
              {
                  controls_area.handleJogEvent( UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_RELEASED )
                  return;
              }
              else
              {
                  handleOnRelease( "Next" )
                  // { added by cychoi 2014.09.02 for DUAL_KEY
                  if(controls_area.activeArrow == UIListenerEnum.JOG_RIGHT)
                  {
                      isSeekPressed = false;//added by edo.lee 2013.10.07
                  }
                  // } added by cychoi 2014.09.02
              }
          }

          function onMouseExited()
          {
              if(!bActive)
                  return;

              if(is_ff_rew || is_Critical)
              {
                 onMouseReleased();
              }
              else
              {
                  EngineListener.setSeekSKPressed(false); // added by cychoi 2014.09.02 for DUAL_KEY
                  lightControls(CONST.const_CONTROLS_FF_BTN_NUMBER, false, true); // added by Sergey 10.10.2013 for ITS#194643
                  // { added by cychoi 2014.09.02 for DUAL_KEY
                  if(controls_area.activeArrow == UIListenerEnum.JOG_RIGHT &&
                     !(EngineListener.seekHKPressed() || EngineListener.seekSKPressed()))
                  {
                      isSeekPressed = false;//added by edo.lee 2013.10.07
                      EngineListener.pbOwner = VPEnum.VDISP_MAX;
                      controls_area.activeArrow = UIListenerEnum.JOG_NONE;
                  }
                  // } added by cychoi 2014.09.02
              }

              bActive = false
              // { commented by cychoi 2014.09.02 for DUAL_KEY
              //EngineListener.pbOwner = VPEnum.VDISP_MAX;
              //controls_area.activeArrow = UIListenerEnum.JOG_NONE;
              // { commented by cychoi 2014.09.02
          }

          function onMouseCanceled()
          {
              onMouseExited();
          }

          function onMousePressAndHold()
          {
              if(tuneMode) return ;

              if(is_ff_rew || is_Critical )
                  return;

              timerPressedAndHoldCritical.start()
              timerPressedAndHoldCritical.lastPressed = "Next"
              controls_area.handleJogEvent( UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_LONG_PRESSED )
              return;
          }
      }
   }

   // { modified by Sergey 24.08.2013 for ITS#185556 
   DHAVN_VP_FocusedRow
   {
      id: bottomElements

      focus_x: 0
      focus_y: 0
      name: "PlaybackControlsRow"
      spacing: CONST.const_CONTROLS_SPACING
      repeaterModel: btnModel
      repeaterComponent: btnDelegate

      function setDefaultFocus(arrow) {}
   }
   // } modified by Sergey 24.08.2013 for ITS#185556 


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
         source: main_image.is_dimmed ? (icon_d || "") : "" // modified by hyejin.noh 2014.12.23 for ITS 254979

         /** Icon image */
         Image
         {
            id: visual_cue_icon
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            // { modified by hyejin.noh 2014.12.23 for ITS 254979 // { modified by cychoi 2014.07.24 for ITS 243910, ITS 243911 control cue focus
            visible: !main_image.is_dimmed
            source: main_image.jog_pressed || mouseArea.bActive ? (icon_p || "") :
                       bottomElements.focus_visible && btn_id == "PlayButton" && !bSystemPopupVisible ?  (icon_f || "") : (icon_n || "")
            // } modified by hyejin.noh 2014.12.23 // } modified by cychoi 2014.07.24
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
            visible: btn_id == "PlayButton"
            // { modified by hyejin.noh 2014.12.23 for ITS 254979 // { modified by cychoi 2014.07.24 for ITS 243910, ITS 243911 control cue focus
            source:  main_image.is_dimmed ?  (icon2_d || "") : //added by junam 2013.07.25 for dim control que
                        main_image.jog_pressed || mouseArea.bActive ? (icon2_n || "") :
                        bottomElements.focus_visible && !bSystemPopupVisible ? (icon2_n || "") : ( icon2_n || "" )
            // } modified by hyejin.noh 2014.12.23 // } modified by cychoi 2014.07.24
         }

         /** Button text */
         Text
         {
            id: text_loader
            anchors.centerIn: parent
            // { modified by hyejin.noh 2014.12.23 for ITS 254979 // { modified by cychoi 2014.07.24 for ITS 243910, ITS 243911 control cue focus
            color: CONST.const_FF_REW_TEXT_COLOR // added by Sergey 16.10.2013 for ITS#195505 // added by Sergey 15.01.2013 for ITS#219649
            // } modified by hyejin.noh 2014.12.23 // } modified by cychoi 2014.07.24
            //color: is_dimmed ? CONST.const_WIDGET_CMDBTN_DIMMED_TEXT_COLOR :
            //                   CONST.const_FF_REW_TEXT_COLOR
            font.pointSize: CONST.const_WIDGET_CMDBTN_TEXT_SIZE
            font.family: CONST.const_WIDGET_CMDBTN_TEXT_FAMILY_NEW      //added by aettie.ji 2012.11.22 for NEW UX
            text: model.text || ""
         }


	     // { modified by Sergey 09.09.2013 for ITS#188944
         MouseArea
         {
             id: mouseArea

             anchors.fill: parent
             enabled: (!is_dimmed /*&& !tuneMode*/ && controls_area.enabled) ? true : false // modified by edo.lee 2013.06.11
             beepEnabled: false // added by Sergey 08.05.2013

             property bool bActive: false


             onExited: onMouseExited();
             onCanceled: onMouseCanceled();
             onPressed: onMousePressed();
             onReleased: onMouseReleased();
             onPressAndHold: onMousePressAndHold();

			
             function onMousePressed()
             {
                 bActive = true //added by yongkyun.lee 20130612 for :  ITS 146106

                 log("onMousePressed"); // added by Sergey 15.10.2013 for ITS#195593

				 if(model.btn_id == "PlayButton")
				 {
				     //added by edo.lee 2013.11.05 
				     if(is_ff_rew || is_Critical ) 
				     {
				        return;
				     }
				     else
				     {
				        //{added for ITS 228567
                        SM.setDefaultFocus();
                        showFocus();
                         //}added for ITS 228567
                        lightControls(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, true, true); // added by Sergey 16.10.2013 for ITS#195505
                      }
				 }
                 
                 if(tuneMode) return ;//added by edo.lee 2013.06.11

                 EngineListener.setSeekSKPressed(true); // added by cychoi 2014.09.02 for DUAL_KEY

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

                 if(is_ff_rew )  return;// added by yongkyun.lee 20130607 : NO CR
                 isSeekPressed = true//added by edo.lee 2013.05.30
                 controls_area.activeArrow = UIListenerEnum.JOG_CENTER // added by cychoi 2014.09.02 for DUAL_KEY
             }

             function onMouseReleased()
             {
                 log("onMouseReleased is_ff_rew = " + is_ff_rew + " is_Critical = " + is_Critical) // added by Sergey 15.10.2013 for ITS#195593

                 //{ modified by kihyung 2013.10.28
                 /*
                 //{ modified by yongkyun.lee 2013-08-19 for : ITS 183677
                 if(model.btn_id == "PlayButton" && (is_ff_rew || is_Critical ) )
                 {
                     return;
                 }
                 //} modified by yongkyun.lee 2013-08-15
                 */
                 if( is_ff_rew || is_Critical )
                 {
                     if( model.btn_id == "PlayButton" )
                         return
                    // else if( model.btn_id == "Prev" || model.btn_id == "Next" )
                    //     isCancelHKafterTouch = true
                 }
                 //} modified by kihyung 2013.10.28
                 
                 //{ added by yongkyun.lee 20130612 for :  ITS 146106
                 if(!bActive && !(is_ff_rew || is_Critical) )
                     return;
                 //} added by yongkyun.lee 20130612
                 // { moved by oseong.kwon 2014.10.14 for ITS 250190 & ITS 250191
                 if(!(isBtMusic == true && albumBTView.visible)||(!is_ff_rew && !is_Critical ))
                     // { modified by kihyung 2013.07.11 for P1 346
                     if(!(is_ff_rew || is_Critical))
                         UIListener.ManualBeep() // added by Sergey 08.05.2013
                     // } modified by kihyung 2013.07.11 for P1 346
                 // } moved by oseong.kwon 2014.10.14
                 bActive = false
                 EngineListener.setSeekSKPressed(false); // added by cychoi 2014.09.02 for DUAL_KEY

                 if(model.btn_id == "PlayButton")
                      lightControls(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, false, true); // added by Sergey 16.10.2013 for ITS#195505


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
                     // { added by cychoi 2014.09.02 for DUAL_KEY
                     if(controls_area.activeArrow == UIListenerEnum.JOG_CENTER)
                     {
                         isSeekPressed = false;//added by edo.lee 2013.10.07
                     }
                     // } added by cychoi 2014.09.02
                 }
             }

             function onMouseExited()
             {
                 if(!bActive)
                     return;

                 log("onMouseExited is_ff_rew = " + is_ff_rew + "is_Critical = " + is_Critical) // added by Sergey 15.10.2013 for ITS#195593

                 if(is_ff_rew || is_Critical)
                 {
                    onMouseReleased();
                 }
                 else
                 {
                     EngineListener.setSeekSKPressed(false); // added by cychoi 2014.09.02 for DUAL_KEY
                 	 // { modified by cychoi 2014.09.02 for DUAL_KEY // { modified by Sergey 10.10.2013 for ITS#194643
                     if(model.btn_id == "PlayButton")
                     {
                          lightControls(CONST.const_CONTROLS_VISUALCUE_BTN_NUMBER, false, true); // added by Sergey 16.10.2013 for ITS#195505
                          if(controls_area.activeArrow == UIListenerEnum.JOG_CENTER &&
                             !(EngineListener.seekHKPressed() || EngineListener.seekSKPressed()))
                          {
                              isSeekPressed = false;//added by edo.lee 2013.10.07
                              EngineListener.pbOwner = VPEnum.VDISP_MAX;
                              controls_area.activeArrow = UIListenerEnum.JOG_NONE;
                          }
                     }
                     else if(model.btn_id == "Prev")
                     {
                         var curIndex = CONST.const_CONTROLS_REW_BTN_NUMBER
                         lightControls(curIndex, false, true);
                         if(controls_area.activeArrow == UIListenerEnum.JOG_LEFT &&
                            !(EngineListener.seekHKPressed() || EngineListener.seekSKPressed()))
                         {
                             isSeekPressed = false;//added by edo.lee 2013.10.07
                             EngineListener.pbOwner = VPEnum.VDISP_MAX;
                             controls_area.activeArrow = UIListenerEnum.JOG_NONE;
                         }
                     }
                     else
                     {
                         var curIndex = CONST.const_CONTROLS_FF_BTN_NUMBER
                         lightControls(curIndex, false, true);
                         if(controls_area.activeArrow == UIListenerEnum.JOG_RIGHT &&
                            !(EngineListener.seekHKPressed() || EngineListener.seekSKPressed()))
                         {
                             isSeekPressed = false;//added by edo.lee 2013.10.07
                             EngineListener.pbOwner = VPEnum.VDISP_MAX;
                             controls_area.activeArrow = UIListenerEnum.JOG_NONE;
                         }
                     }
                     // } modified by cychoi 2014.09.02 // } modified by Sergey 10.10.2013 for ITS#194643
                 }

                 bActive = false
                 // { commented by cychoi 2014.09.02 for DUAL_KEY
                 //isSeekPressed = false; // added by Sergey 15.10.2013 for ITS#195593
                 //EngineListener.pbOwner = VPEnum.VDISP_MAX;
                 //controls_area.activeArrow = UIListenerEnum.JOG_NONE;
                 // } commented by cychoi 2014.09.02
             }

             function onMouseCanceled()
             {
                 onMouseExited();
             }

             function onMousePressAndHold()
             {
                 if(tuneMode) return ;//added by edo.lee 2013.06.11
                  //{ added by yongkyun.lee 20130601 for :
                  //handleOnPressAndHold(model.btn_id,true)
                  if(is_ff_rew || is_Critical )
                     return;
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
         }
		 // } modified by Sergey 09.09.2013 for ITS#188944
         
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
         handleOnPressedAndHoldCritical(timerPressedAndHoldCritical.lastPressed)
         UIListener.ManualBeep() // modified by yongkyun.lee 2013-08-22 for : ISV 89537
         // removed by yongkyun.lee 2013-08-06 for : ITS 182922            
      }
   } //timer
   
   // { modified by Sergey 10.09.2013 for ITS#188771
   Connections
   {
       target: EngineListener


       onFsAnimation: controls_area.bFullScreenAnimation = bOn // added by Sergey 26.09.2013 for ITS#191542

       // { modified by Sergey 10.10.2013 for ITS#194643
       onLightControls:
       {
           if(SM.disp == disp)
               lightControls(item, isOn, false);
       }
       
       onSeekHandlejogevent:
       {
           if(SM.disp == VPEnum.VDISP_FRONT || !EngineListener.isFrontLoaded()) // added by Sergey 24.10.2013 for ITS#196105, 197778
               handleJogEvent(arrow, status)
       }

       // { added by cychoi 2014.07.24 for ITS 243910, ITS 243911 control cue focus
       onSystemPopupShow:
       {
           if( disp == SM.disp)
               bSystemPopupVisible = bShown
           else
               bSystemPopupVisible = false
       }
       // } added by cychoi 2014.07.24

       // { added by cychoi 2015.01.07 for move focus to control cue on TuneWheel
       onPlaybackTuned:
       {
           if(controls_area.isCommonJogEnabled == true && bottomElements.focus_visible == false)
           {
               SM.setDefaultFocus();
               showFocus();
           }
       }
       // } added by cychoi 2015.01.07
   }
   // } modified by Sergey 10.09.2013 for ITS#188771

   // } modified by Sergey 10.10.2013 for ITS#194643


   Connections //added by suilyou ITS 0193848
   {
       target:EngineListenerMain

       onSignalModeChange:
       {
           clearAllJogs();
       }
   }

   // rollback by cychoi 2013.11.10 for ITS 207831 Control Cue Icon on Tune Mode
}
// modified by Dmitry 15.05.13


