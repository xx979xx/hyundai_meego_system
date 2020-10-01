import Qt 4.7

import "DHAVN_AppPhoto_Constants.js" as CONST
import QmlOptionMenu 1.0
import AppEngineQMLConstants 1.0 // added by wspark 2012.11.30 for ISV59938

OptionMenu
{
   id: options
   menumodel: EngineListener.optMenuModel
   focus_id: root.focusEnum.options
   focus_visible: ( focus_id == photo_focus_index ) && photo_focus_visible
   autoHiding: true
   autoHideInterval: 10000 // modified by Sergey 01.08.2013
   z: 1000
   visible: false // added by Dmitry 26.04.13
   middleEast: EngineListenerMain.middleEast // modified by Dmitry 11.05.13
   scrollingTicker: true //EngineListenerMain.scrollingTicker // modified by sangmin.seol 2014.08.04 ITS 0244649 //[EU][IVS][84553][84633][c][EU][ITS][167240][comment] [KOR][ISV][64532][C](aettie.ji)
   //bAVPMode:true // DUAL_KEY  // modified by sangmin.seol ITS_0218558 RollBack DUAL_KEY for Photo.
   property int previous_focus_index : 0 // added by wspark 2012.11.30 for ISV59938

   function showMenu()
   {
       EngineListenerMain.sendTouchCleanUpForApps() //added by suilyou ITS 0191448
       options.visible = true
       options.show()
   } // added by Sergey 02.08.2103 for ITS#181512

   function hideMenu(animated)
   {
       options.visible = false
       if (animated)
           options.hide()
       else{
	   	EngineListenerMain.invokeMethod(options,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
           //options.quickHide()
       	}
   }


   onBeep: UIListener.ManualBeep(); // added by Sergey 02.11.2013 for ITS#205776
   onQmlLog: EngineListenerMain.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log

   onTextItemSelect:
   {
      // EngineListenerMain.qmlLog( "[MP Photo] onTextItemSelect: " + itemId )
// removed by Dmitry 26.04.13
      switch ( itemId )
      {
         case 1: //slide show
         {
            imageViewer.startSlideShow()
            break
         }

         case 2: //list
         {
            EngineListenerMain.qmlLog("[MP_Photo] Launch FileManager in List Mode");
            EngineListener.LaunchFileManager( EngineListener.getCurrentFilePath(EngineListener.currentSource) );
           // root.photo_focus_visible = false
            break
         }
//{modified by aettie 20130828 for ITS 184108
     /*    case 3: //rotation
         {
            root.state = "rotation"
            //popup_screen.show( CONST.const_POPUP_ID_ROTATE_ANGLE ) //removed by eunhye 2012.11.17 for SANITY_CM_AK450
            isRotate = true  //added by yungi 2012.11.26 for No CR - Photo Roatateing backkey don't exit when Backkey
            break
         }*/

     /*    case 4: //save as frame
         {
            if ( EngineListener.SaveAsFrame(false) )
            {
               popup_screen.show( CONST.const_POPUP_ID_IMAGE_SAVED )
            }
            // { removed by kihyung 2013.06.30 for ITS 0163616 
            
            else
            {
               popup_screen.show( CONST.const_POPUP_ID_FILE_EXISTS )
            }
            
            // } removed by kihyung 2013.06.30 

            break
         }*/
         case 5: //copy to jukebox
         {
	    // { modified by ravikanth 16-04-13
             if(EngineListener.isCopyInProgress())
             {
                 popup_screen.show( CONST.const_POPUP_ID_COPY_TO_JUKEBOX_PROGRESS )
             }
             else
             {

                 EngineListener.setCopy(true);
                 EngineListener.LaunchFileManager( EngineListener.getCurrentFilePath(EngineListener.currentSource) );
              }
	      // } modified by ravikanth 16-04-13
             root.photo_focus_visible = false
	     // } modified by eunhye 2013.02.26
            break
         }
         case 6: //full screen
         {
            root.state = "fullScreen"
	    // commented by ravikanth 05-09-13 for ITS 0188375
            //isFullscreen = true //added by yungi 2012.11.26 for No CR - Photo Roatateing backkey don't exit when Backkey
            break
         }

         /*case 7: //file info
         {
            popup_screen.show( CONST.const_POPUP_ID_IMAGE_INFO )
            break
         }*/
//}modified by aettie 20130828 for ITS 184108

         case 9: //Screen setup
         {
            EngineListener.LaunchScreenSettings()
            //root.photo_focus_visible = false // removed by Dmitry 26.07.13 for ITS0175511
            break
         }
      }
      if (itemId != 9 && itemId != 2)  
	{
	        //options.quickHide() // modified by Sergey 02.08.2103 for ITS#181512
	  	EngineListenerMain.invokeMethod(options,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
      	}
   }

   onRadioBtnSelect:
   {
      // EngineListenerMain.qmlLog("[MP Photo] onRadioBtnSelect: " + itemId)

      root.state = "normal"
// removed by Dmitry 26.04.13
      // removed by ruindmby 2012.11.28

      switch ( itemId )
      {
         case 21: //5 sec
            EngineListener.slideShowDelay = CONST.const_SLIDE_SHOW_DELAY_1
            break

         case 22: //10 sec
            EngineListener.slideShowDelay = CONST.const_SLIDE_SHOW_DELAY_2
            break

         case 23: //20 sec
            EngineListener.slideShowDelay = CONST.const_SLIDE_SHOW_DELAY_3
            break

         case 24: //30 sec
            EngineListener.slideShowDelay = CONST.const_SLIDE_SHOW_DELAY_4
            break
      }
      //options.quickHide()//restored for ITS195746 29.Oct.2013 // modified by Sergey 02.08.2103 for ITS#181512
      EngineListenerMain.invokeMethod(options,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
      EngineListener.SaveSettings()//added by aettie 20130604 Master car QE issue

      //popup_screen.show( CONST.const_POPUP_ID_VALUE_SAVED )//deleted by aettie 20130604 Master car QE issue
   }

// modified by Dmitry 26.04.13
   onIsHidden:
   {
      visible = false
      root.photo_focus_index = root.focusEnum.cue
   }
// modified by Dmitry 26.04.13

   // removed by sangmin.seol 2014.08.11 ITS 0244649
   //[EU][IVS][84553][84633][c][EU][ITS][167240][comment] [KOR][ISV][64532][C](aettie.ji)
   // Connections
   // {
   //     target:EngineListenerMain
   //     onTickerChanged:
   //     {
   //         EngineListenerMain.qmlLog("[MP Photo] onTickerChanged ticker(photo option) : " + ticker);
   //         options.scrollingTicker = ticker;
   //     }
   // }
}
