import QtQuick 1.0
import QmlOptionMenu 1.0
import Qt.labs.gestures 2.0
import AppEngineQMLConstants 1.0 // added by wspark 2012.11.30 for ISV59938

import "components"

DHAVN_VP_FocusedItem
{
   anchors.fill: parent
   default_x: 0
   default_y: 0
   id: optWrapper
   focus_visible: true //added by aettie 2013.03.27 for Touch focus rule

// modified by Dmitry 26.04.13
   onVisibleChanged:
   {
       main.setDefaultFocus(UIListenerEnum.JOG_DOWN) // added by wspark 2013.02.26 for ISV 70132

      if(optWrapper.visible)
        main.showFocus();
      else
        main.hideFocus();
   }
// modified by Dmitry 10.10.13
   GestureArea
   {
       anchors.fill: parent
   }

   // { added by Sergey 22.04.2013
//   Rectangle
//   {
//       id: sb_strip
//       anchors.top: parent.top
//       anchors.horizontalCenter: parent.horizontalCenter
//       color: Qt.rgba( 0, 0, 0, 0.8 )
//       width: 1280
//       height: 93
//       opacity: optWrapper.visible ? 1 : 0

//       Behavior on opacity { PropertyAnimation { duration: 250  } }
//   }
   // } added by Sergey 22.04.2013
// modified by Dmitry 10.10.13

   OptionMenu
   {
      id: main
      menumodel: video_model.optionMenuModel
      property int focus_x : 0
      property int focus_y : 0
      property bool bHidden: true  // added by Sergey 08.08.2013 to fix double OptionsMenu

      focus_visible: true //added by aettie 2013.03.28 for Touch Focus rule
      autoHiding: true
      autoHideInterval: 10000 // modified by Sergey 01.08.2013
      middleEast: EngineListenerMain.middleEast // modified by Dmitry 11.05.13
      scrollingTicker: EngineListenerMain.scrollingTicker  //[EU][IVS][84553][84633][c][EU][ITS][167240][comment] [KOR][ISV][64532][C](aettie.ji)
      bAVPMode:true // DUAL_KEY
      property int previous_focus_index : 0 // added by wspark 2012.11.30 for ISV59938

      onIsHidden:
      {
          main.bHidden = true // added by Sergey 08.08.2013 to fix double OptionsMenu
          controller.onHidden() // modified by Sergey 06.08.2013 to close menu in good time
          optWrapper.showFocus()//added by edo.lee 2013.04.15
		  // EngineListenerMain.invokeMethod(controller,"onHidden"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
		  // EngineListenerMain.invokeMethod(optWrapper,"showFocus"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
      }

      onCheckBoxSelect:
      {
         EngineListenerMain.qmlLog("onCheckBoxSelect itemId = " + itemId + " flag = " + flag)
		  EngineListenerMain.invokeMethod(controller , "onCheckBoxSelect", itemId, flag); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
        // controller.onCheckBoxSelect( itemId, flag )
      }

      onRadioBtnSelect:
      {
         EngineListenerMain.qmlLog("onRadioBtnSelect", itemId)
        // controller.onItemPressed(itemId)
         controller.invokeSelectItemMethod(controller,"onItemPressed", itemId); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
      }
//      onNextLevelSelect:
//      {
//         EngineListenerMain.qmlLog("onNextLevel")
//      }
      onTextItemSelect:
      {
         EngineListenerMain.qmlLog("onTextItemSelect", itemId)
         controller.invokeSelectItemMethod(controller,"onItemPressed", itemId);// added by edo.lee 2013.11.20 ITS 0207978 
        // controller.onItemPressed(itemId)
      }

      onBeep:  EngineListenerMain.invokeMethod(UIListener, "ManualBeep");  //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
      onQmlLog: EngineListenerMain.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log

       //added by edo.lee 2013.09.14
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
	
		   anchors.left: parent.left
		   anchors.leftMargin: 562
		   y: ( video_model.progressBarMode == "AUX" )? CONST.const_NO_PBCUE_LOCKOUT_ICON_TOP_OFFSET:CONST.const_LOCKOUT_ICON_TOP_OFFSET // modified by lssanh 2013.05.24 ISV84099
		   source: RES.const_URL_IMG_LOCKOUT_ICON
	   }
		   
	   Text
	   {
	
		   width: parent.width			 
		   horizontalAlignment:Text.AlignHCenter//added by edo.lee 2013.06.22
	
		   anchors.top : lockoutImg.bottom
		   text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_DISC_VCD_DRIVING_REGULATION") + LocTrigger.empty  //added by edo.lee 2013.05.24
		   font.pointSize: 32//36//modified by edo.lee 2013.05.24		 
		   color: "white"
		   // { modified by Sergey Vetugov. CR#10273
	   }	
	}
	//added by edo.lee 2013.09.14

      //{ modified by yongkyun.lee 2013-11-11 for : NOCR JOG is no beep

	// { modified by Sergey 08.08.2013 to fix double OptionsMenu
      Connections
      {
          target: controller
	//added by edo.lee 2013.09.14
	onShowLockout:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP Option menu :: onShowLockout");
            lockoutRect.visible  = onShow;    
        }
	//added by edo.lee 2013.09.14

          onCloseOptions:
          {
              if(!main.bHidden) 
              {
                  if (animated)
                      main.hide() //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                      // EngineListenerMain.invokeMethod(main,"hide"); 
                  else
                  {
                      //EngineListenerMain.invokeMethod(main,"quickHide"); 
                      main.quickHide()//modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                  }
              }
          }

          onBackPressed:
          {
              //main.backLevel()
               EngineListenerMain.invokeMethod(main,"backLevel"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
          }

          onShowOptions:
          {
              //EngineListenerMain.sendTouchCleanUpForApps() //added by suilyou ITS 0191448
              EngineListenerMain.invokeMethod(EngineListenerMain, "sendTouchCleanUpForApps") //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
              optWrapper.visible = true
              //main.show()
              EngineListenerMain.invokeMethod(main,"show"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
              main.bHidden = false
          } // added by Sergey 02.08.2103 for ITS#181512
      }

    Connections
    {
        target:EngineListenerMain
        onTickerChanged:
        {
            EngineListenerMain.qmlLog("onTickerChanged ticker(video option) : " + ticker);
            main.scrollingTicker = ticker;
        }
    }
	// } modified by Sergey 08.08.2013 to fix double OptionsMenu
   }
}
