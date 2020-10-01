import Qt 4.7

//import QmlPopUpPlugin 1.0 as POPUPWIDGET
import "DHAVN_AppPhoto_Constants.js" as RES
//import PopUpConstants 1.0 remove by edo.lee 2013.01.26
import "../video/popUp/DHAVN_MP_PopUp_Constants.js" as EPopUp //added by edo.lee 2013.01.26
import "../video/popUp" // added by edo.lee 2013.01.17
//{Changed by Alexey Edelev 2012.10.16 CR 14591
Item
{
   id: popup_rect
   //anchors.fill: parent
   y : RES.const_MODE_AREA_WIDGET_Y //93 //modified by aettie 20130611 for ITS 167263 // modified by Michael.Kim 2014.07.23 to replace hard coding with constant
   //color: Qt.rgba( 0, 0, 0, 0 ) //transparent
//}Changed by Alexey Edelev 2012.10.16 CR 14591

   property int slideShowDelayPopupIndex: 0
   property int offset_y:0; //added by aettie 20130611 for ITS 167263

   //signal popupHided()


   function show_popup( popup_id )
   {
      EngineListenerMain.qmlLog("[MP_Photo] show_popup id = " + popup_id)
      //stop timer
      popup_timer.running = false

      popupImageInfo.visible = false
      popupDimmed.visible = false
      popupNoImageFileInUSB.visible = false
      popupNoImageFileInJukebox.visible = false
      popupHighTemperature.visible = false
      popupUnavailableFormat.visible = false
      popupZoom.visible = false
      popupFileExists.visible = false
      popupFileExistsInJukebox.visible = false // added by wspark 2012.11.20 for CR15521
      popupDRS.visible = false //added by edo.lee 2013.03.04
      popupJukeBoxCopyInProgress.visible = false // modified by ravikanth 16-04-13

      popup_rect.offset_y = - RES.const_MODE_AREA_WIDGET_Y //-93 //added by aettie 20130611 for ITS 167263 // modified by Michael.Kim 2014.07.23 to replace hard coding with constant

      switch ( popup_id )
      {
         case RES.const_POPUP_ID_IMAGE_INFO:
         {
            root.popup_state = RES.const_POPUP_ID_IMAGE_INFO //added by edo.lee 2012.10.23 for Function_USB_1721
            //show Image Info popup
            popupImageInfo.visible = true
            // { removed by eugeny.novikov 2012.12.01 for CR 14656
            // { add by yongkyun.lee@lge.com  2012.09.19 :  CR13815 : File name displayed in file info is not correct.
//            elideFolderName= EngineListener.makeElidedString(EngineListener.getCurrentFolderNameByPath(EngineListener.currentSource), "HDB", 32, 760 )
//            elideFileName= EngineListener.makeElidedString(EngineListener.getCurrentFileNameByPath(EngineListener.currentSource), "HDB", 32, 760 )
            // } add by yongkyun.lee@lge.com
            // } removed by eugeny.novikov 2012.12.01

            // { modified by changjin 2012.09.04 : for CR 13367
            //infoPopupModel.set(0, {"msg" : QT_TR_NOOP( "STR_MEDIA_FOLDERNAME" ), "arg1": EngineListener.GetCurrentFolderName() } )
            //infoPopupModel.set(1, {"msg" : QT_TR_NOOP( "STR_MEDIA_FILENAME" ), "arg1": EngineListener.GetCurrentFileName() } )
            // { modified by eugeny.novikov 2012.12.01 for CR 14656
            infoPopupModel.set(0, {"name" : QT_TR_NOOP( "STR_MEDIA_FOLDERNAME" ),
                                   "value": EngineListener.makeElidedString(EngineListener.getCurrentFolderNameByPath(EngineListener.currentSource), "DH_HDB", 32, 700) });

            infoPopupModel.set(1, {"name" : QT_TR_NOOP( "STR_MEDIA_FILENAME" ),
                                   "value": EngineListener.makeElidedString(EngineListener.getCurrentFileNameByPath(EngineListener.currentSource), "DH_HDB", 32, 760) });
            // } modified by changjin 2012.09.04
            // } modified by eugeny.novikov 2012.12.01

            infoPopupModel.set(2, {"name" : QT_TR_NOOP( "STR_MEDIA_RESOLUTION" ), "value": imageViewer.getImageResolution() } )
            infoPopupModel.set(3, {"name" : QT_TR_NOOP( "STR_MEDIA_FORMAT" ), "value": EngineListener.getCurrentFileExtByPath(EngineListener.currentSource) } )
            // added eugene.seo 2012.12.05 for adding contentCreated date into photo file info popup
            infoPopupModel.set(4, {"name" : QT_TR_NOOP( "STR_MEDIA_CREATEDATE" ), "value": EngineListener.getCurrentFileCreatedDateByPath(EngineListener.currentSource) } ) 
            
            popup_rect.height = popupImageInfo.height
            popup_rect.width = popupImageInfo.width

            root.photo_focus_visible ? popupImageInfo.showFocus(): 0
         }
         break

         case RES.const_POPUP_ID_MEMORY_FULL:
         {
            //show Memory Full popup
            popupDimmed.visible = true
            popupDimmed.typePopup = 0
            popupDimmed.message = popupMemoryFullModel

            popup_rect.height = popupDimmed.height
            popup_rect.width = popupDimmed.width

            //start popup timer
            popup_timer.running = true
         }
         break

         case RES.const_POPUP_ID_IMAGE_SAVED:
         {
            //show Image Saved popup
            popupDimmed.visible = true
            popupDimmed.typePopup = 0
            popupDimmed.message = popupSaveFrameModel

            // { remove by eunhye.yoo 2012.10.08 : for CR 13592
            //popup_rect.height = popupDimmed.height
            //popup_rect.width = popupDimmed.width
            // } remove by eunhye.yoo 2012.10.08

            //start popup timer
            popup_timer.running = true
         }
         break

         case RES.const_POPUP_ID_ROTATE_ANGLE:
         {
            //show Rotate angle popup
            popupZoom.visible = true
            popupZoom.msg = mainImage.rotation + "<font>&deg;</font>"
            popupZoom.icon = 0 //NONE_ICON

            popup_rect.height = popupZoom.height
            popup_rect.width = popupZoom.width

            //start popup timer
            popup_timer.running = true
         }
         break

         case RES.const_POPUP_ID_VALUE_SAVED:
         {
            //show Value Saved popup
            popupDimmed.visible = true
            popupDimmed.typePopup = 0
            popupDimmed.message = popupValueSavedModel

            popup_rect.height = popupDimmed.height
            popup_rect.width = popupDimmed.width

            //start popup timer
            popup_timer.running = true
         }
         break

         case RES.const_POPUP_ID_NO_IMAGE_FILES_IN_USB:
         {
            //show No image file in USB popup
             root.popup_state = RES.const_POPUP_ID_NO_IMAGE_FILES_IN_USB //added by edo.lee 2012.10.23 for Function_USB_1721
            popupNoImageFileInUSB.visible = true
            popupDimmed.message = noImageInUSBPopupModel

            popup_rect.height = popupNoImageFileInUSB.height
            popup_rect.width = popupNoImageFileInUSB.width

            root.photo_focus_visible ? popupNoImageFileInUSB.showFocus(): 0
         }
         break

         case RES.const_POPUP_ID_NO_IMAGE_FILES_IN_JUKEBOX:
         {
            //show No image file in Jukebox popup
             root.popup_state = RES.const_POPUP_ID_NO_IMAGE_FILES_IN_JUKEBOX //added by edo.lee 2012.10.23 for Function_USB_1721
            popupNoImageFileInJukebox.visible = true
            popupDimmed.message = noImageInJukeboxPopupModel

            popup_rect.height = popupNoImageFileInJukebox.height
            popup_rect.width = popupNoImageFileInJukebox.width

            root.photo_focus_visible ? popupNoImageFileInJukebox.showFocus(): 0
         }
         break

         case RES.const_POPUP_ID_HIGH_TEMPERATURE:
         {
            //show Temperature high popup
            popupHighTemperature.visible = true
            popupDimmed.message = highTemperaturePopupModel

            popup_rect.height = popupHighTemperature.height
            popup_rect.width = popupHighTemperature.width

            //start popup timer
            popup_timer.interval = 5000
            popup_timer.running = true
         }
         break

         case RES.const_POPUP_ID_UNAVAILABLE_FORMAT:
         {
            //show Unavailable format popup
             root.popup_state = RES.const_POPUP_ID_UNAVAILABLE_FORMAT //added by edo.lee 2012.10.23 for Function_USB_1721
            popupUnavailableFormat.visible = true
            popupDimmed.message = unsupportedFormatPopupModel

            popup_rect.height = popupUnavailableFormat.height
            popup_rect.width = popupUnavailableFormat.width

            root.photo_focus_visible ? popupUnavailableFormat.showFocus(): 0
//{Changed by Alexey Edelev 2012.10.23 CR14235
            popupUnavailableFormatTimer.interval = 3000
            popupUnavailableFormatTimer.running = true //delete by Yungi for CR12208
//}Changed by Alexey Edelev 2012.10.23 CR14235
         }
         break

         case RES.const_POPUP_ID_ZOOM_VALUE:
         {
            //show zoom value popup
            popupZoom.visible = true
            popupZoom.msg = show_zoom_value( EngineListener.zoom )
            popupZoom.icon = 3 //ZOOM_X

            popup_rect.height = popupZoom.height
            popup_rect.width = popupZoom.width

            //start popup timer
            popup_timer.running = true
         }
         break

         case RES.const_POPUP_ID_COPY_COMPLETED:
         {
            //show Copy Completed popup
            popupDimmed.visible = true
            popupDimmed.typePopup = 0
            popupDimmed.message = copyCompletedPopupModel

            popup_rect.height = popupDimmed.height
            popup_rect.width = popupDimmed.width

            //start popup timer
            popup_timer.running = true
         }
         break

         case RES.const_POPUP_ID_FILE_EXISTS:
         {
            //show "File already exists" popup
             root.popup_state = RES.const_POPUP_ID_FILE_EXISTS //added by edo.lee 2012.10.23 for Function_USB_1721
            popupFileExists.visible = true

            //{ added by yongkyun.lee 20130320 for : ISV 72779
            //fileExistsPopupModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_REPLACE_JUKEBOX_MYFRAME"), "arg1": EngineListener.getCurrentFileNameByPath(EngineListener.currentSource)})
            fileExistsPopupModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_REPLACE_JUKEBOX_MYFRAME"),
                                         "arg1": EngineListener.makeElidedString(EngineListener.getCurrentFileNameByPath(EngineListener.currentSource), "DH_HDB", 32,700 )})
            //} added by yongkyun.lee 20130320 

            popup_rect.height = popupFileExists.height
            popup_rect.width = popupFileExists.width

            root.photo_focus_visible ? popupFileExists.showFocus(): 0
         }
		 break;
// { add by yongkyun.lee@lge.com  2012.08.14  for : New UX : Photo(Teleca) #1 
         case RES.const_POPUP_ID_DRS:
         {
             root.popup_state = RES.const_POPUP_ID_DRS //added by edo.lee 2012.10.23 for Function_USB_1721
             popupDRS.visible = true
             popup_rect.height = popupDRS.height
             popup_rect.width  = popupDRS.width
             root.photo_focus_visible ? popupDRS.showFocus(): 0
         }
         break;
 // } add by yongkyun.lee@lge.com          
         // { added by wspark 2012.11.20 for CR15521
         case RES.const_POPUP_ID_FILE_EXISTS_INJUKEBOX:
         {
            root.popup_state = RES.const_POPUP_ID_FILE_EXISTS_INJUKEBOX
            popupFileExistsInJukebox.visible = true

            //{ added by yongkyun.lee 20130320 for : ISV 72779
            //fileExistsInJukeboxPopupModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_REPLACE"), "arg1": EngineListener.getCurrentFileNameByPath(EngineListener.currentSource)})
            fileExistsInJukeboxPopupModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_REPLACE"),
                                         "arg1": EngineListener.makeElidedString(EngineListener.getCurrentFileNameByPath(EngineListener.currentSource), "DH_HDB", 32,700 )})
            //} added by yongkyun.lee 20130320 

            popup_rect.height = popupFileExistsInJukebox.height
            popup_rect.width = popupFileExistsInJukebox.width

            root.photo_focus_visible ? popupFileExistsInJukebox.showFocus(): 0
         }
                 break;
         // } added by wspark
	 // { modified by ravikanth 16-04-13
         case RES.const_POPUP_ID_COPY_TO_JUKEBOX_PROGRESS:
         {
            root.popup_state = RES.const_POPUP_ID_COPY_TO_JUKEBOX_PROGRESS
            popupJukeBoxCopyInProgress.visible = true

            popup_rect.height = popupJukeBoxCopyInProgress.height
            popup_rect.width = popupJukeBoxCopyInProgress.width

            root.photo_focus_visible ? popupJukeBoxCopyInProgress.showFocus(): 0
         }
         break;
	 // } modified by ravikanth 16-04-13
      }
      popup_rect.visible = true
   }
   
   function handleTouchScreen()
   {
      // EngineListenerMain.qmlLog("[MP Photo Popup] popup screen touched")
          root.popup_state = RES.const_POPUP_ID_NONE //added by edo.lee 2012.10.23 for Function_USB_1721
      if (popupImageInfo.visible && popupImageInfo.focus_visible)
      {
         popupImageInfo.hideFocus()
      }
      else if (popupNoImageFileInUSB.visible && popupNoImageFileInUSB.focus_visible)
      {
         popupNoImageFileInUSB.hideFocus()
      }
      else if (popupNoImageFileInJukebox.visible && popupNoImageFileInJukebox.focus_visible)
      {
         popupNoImageFileInJukebox.hideFocus()
      }
      else if (popupUnavailableFormat.visible && popupUnavailableFormat.focus_visible)
      {
         popupUnavailableFormat.hideFocus()
      }
      //{ added by eunhye.yoo 2012.10.16 
      else if (popupFileExists.visible && popupFileExists.focus_visible)
      {
         popupFileExists.hideFocus()
      }
      //} added by eunhye.yoo 2012.10.16
      // { added by wspark 2012.11.20 for CR15521
      else if (popupFileExistsInJukebox.visible && popupFileExistsInJukebox.focus_visible)
      {
         popupFileExistsInJukebox.hideFocus()
      }
      // } added by wspark
      // { modified by ravikanth 16-04-13
      else if (popupJukeBoxCopyInProgress.visible && popupJukeBoxCopyInProgress.focus_visible)
      {
         popupJukeBoxCopyInProgress.hideFocus()
      }
      // } modified by ravikanth 16-04-13
   }

   function handleJog( jogButton )
   {
      // EngineListenerMain.qmlLog("[MP Photo Popup] handleJog in PopUp")

      if (popupImageInfo.visible && !popupImageInfo.focus_visible)
      {
         popupImageInfo.showFocus()
      }
      else if (popupNoImageFileInUSB.visible && !popupNoImageFileInUSB.focus_visible)
      {
         popupNoImageFileInUSB.showFocus()
      }
      else if (popupNoImageFileInJukebox.visible && !popupNoImageFileInJukebox.focus_visible)
      {
         popupNoImageFileInJukebox.showFocus()
      }
      else if (popupUnavailableFormat.visible && !popupUnavailableFormat.focus_visible)
      {
         popupUnavailableFormat.showFocus()
      }
      //{ added by eunhye.yoo 2012.10.16
      else if (popupFileExists.visible && !popupFileExists.focus_visible)
      {
         popupFileExists.showFocus()
      }
      //} added by eunhye.yoo 2012.10.16
      // { added by wspark 2012.11.20 for CR15521
      else if (popupFileExistsInJukebox.visible && !popupFileExistsInJukebox.focus_visible)
      {
         popupFileExistsInJukebox.showFocus()
      }
      // } added by wspark
      // { modified by ravikanth 16-04-13
      else if (popupJukeBoxCopyInProgress.visible && !popupJukeBoxCopyInProgress.focus_visible)
      {
         popupJukeBoxCopyInProgress.showFocus()
      }
      // } modified by ravikanth 16-04-13
   }

   function hide()
   {
      popup_timer.running = false
      popup_rect.visible = false
      root.photo_focus_index = root.focusEnum.cue
      // { modified by ravikanth 23-04-13 ISV 80359
      popupFileExists.focus_visible = false
      popupJukeBoxCopyInProgress.focus_visible = false
      // } modified by ravikanth 23-04-13 ISV 80359
   }

   function retranslateUi()
   {
      popupDimmed.retranslateUI(RES.const_APP_PHOTO_LANGCONTEXT)
      popupImageInfo.retranslateUI(RES.const_APP_PHOTO_LANGCONTEXT)
      popupNoImageFileInUSB.retranslateUI(RES.const_APP_PHOTO_LANGCONTEXT)
      popupNoImageFileInJukebox.retranslateUI(RES.const_APP_PHOTO_LANGCONTEXT)
      popupHighTemperature.retranslateUI(RES.const_APP_PHOTO_LANGCONTEXT)
      popupUnavailableFormat.retranslateUI(RES.const_APP_PHOTO_LANGCONTEXT)
      popupZoom.retranslateUI(RES.const_APP_PHOTO_LANGCONTEXT)
   }

   function show_zoom_value( value )
   {
      var ret_value = ""
      switch( value )
      {
         case 0:
            ret_value = "-4"
         break;

         case 1:
            ret_value = "-2"
         break;

         case 2:
            ret_value = "1"
         break;

         case 3:
            ret_value = "2"
         break;

         case 4:
            ret_value = "4"
         break;
      }
      // EngineListenerMain.qmlLog( "show_zoom_value, ret_value " +ret_value )
      return ret_value
   }

   ListModel
   {
       id: infoPopupModel
       ListElement { msg: "" }
       ListElement { msg: "" }
       ListElement { msg: "" }
       ListElement { msg: "" }
       ListElement { msg: "" } // added eugene.seo 2012.12.05 for adding contentCreated date into photo file info popup
   }

   ListModel
   {
      id: popupSaveFrameModel
      ListElement { msg: QT_TR_NOOP("STR_SAVE_FRAME_INFO") }
   }

   ListModel
   {
      id: popupMemoryFullModel
      ListElement { msg: QT_TR_NOOP("STR_SAVE_SAVE_FRAME_FULL_INFO") }
   }

   ListModel
   {
      id: popupValueSavedModel
      ListElement { msg: QT_TR_NOOP("STR_MEDIA_SET_SLIDESHOW_SET") }
   }

   ListModel
   {
       id: rotatePopupModel
       ListElement { msg: "" }
   }

   ListModel
   {
       id: noImageInUSBPopupModel
       ListElement { msg: "" }
   }
   ListModel
   {
       id: noImageInJukeboxPopupModel
       ListElement { msg: "" }
   }
   ListModel
   {
       id: usbReleasedPopupModel
       ListElement { msg: "" }
   }
   ListModel
   {
       id: highTemperaturePopupModel
       ListElement { msg: "" }
   }
   ListModel
   {
       id: unsupportedFormatPopupModel
       ListElement { msg: "" }
   }

   ListModel
   {
      id: copyCompletedPopupModel
      ListElement { msg: QT_TR_NOOP("STR_MEDIA_MNG_COPY_COMPLETED") }
   }

   ListModel
   {
      id: fileExistsPopupModel
      ListElement { msg: "" }
   }

   // { added by wspark 2012.11.20 for CR15521
   ListModel
   {
      id: fileExistsInJukeboxPopupModel
      ListElement { msg: "" }
   }
   // } added by wspark
// { add by yongkyun.lee@lge.com  2012.08.14  for : New UX : Photo(Teleca) #1 
/*   ListModel
   {
      id: dRSPopupModel
      ListElement { msg: "STR_MEDIA_PHOTO_DISABLED_INFO" }
   }
*/
// } add by yongkyun.lee@lge.com 
// { modified by ravikanth 16-04-13
   ListModel
   {
      id: fileCopInProgressPopupModel
      ListElement { msg: "STR_MEDIA_CANCEL_COPY_TO_JUKEBOX" }
   }
   // } modified by ravikanth 16-04-13

   DHAVN_MP_PopUp_Dimmed//POPUPWIDGET.PopUpDimmed
   {
      id: popupDimmed
      z: 1
      visible: false
      // { remove by eunhye.yoo 2012.10.08 : for CR 13592
      //anchors.verticalCenter: parent.verticalCenter
      //anchors.horizontalCenter: parent.horizontalCenter
      // } remove by eunhye.yoo 2012.10.08
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263
      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            hide()
            root.popup_state = RES.const_POPUP_ID_NONE //added by edo.lee 2012.10.31 for CR 15175
         }
      }
   }

// { add by yongkyun.lee@lge.com  2012.08.14  for : New UX : Photo(Teleca) #1 
   DHAVN_MP_PopUp_Text//POPUPWIDGET.PopUpText
   {
      id: popupDRS
      z: 1
      visible: false
      message: dRSPopupModel

      buttons: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_POPUP_OK"); btn_id: 1 }
      }
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263
      onBtnClicked:
      {
      	if(!popupDRS.visible) return;//added by edo.lee 01.19
         popupDRS.hideFocus()
         popupDRS.focus_visible = false // added by lssanh 2013.03.01 ISV73816
         hide()
         root.popup_state = RES.const_POPUP_ID_NONE //added by edo.lee 2012.10.31 for CR 15175
         EngineListener.HandleBackKey()		 
      }
   }
// } add by yongkyun.lee@lge.com 

   //POPUPWIDGET.PopUpPropertyTable//POPUPWIDGET.PopUpText
   DHAVN_MP_PopUp_PropertyTable
   {
      id: popupImageInfo
      z: 1
      visible: false

      //title:QT_TR_NOOP("STR_MEDIA_IMAGE_INFO")

      message: infoPopupModel

      buttons: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_POPUP_OK"); btn_id: 1 }
      }
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263
      onBtnClicked:
      {
      	if(!popupImageInfo.visible) return;//added by edo.lee 01.19
         popupImageInfo.hideFocus()
         popupImageInfo.focus_visible = false // added by lssanh 2013.03.01 ISV73816
         root.popup_state = RES.const_POPUP_ID_NONE //added by edo.lee 2012.10.31 for CR 15175
         hide()
      }
   }

   DHAVN_MP_PopUp_Text//POPUPWIDGET.PopUpText
   {
      id: popupNoImageFileInUSB
      z: 1
      visible: false

     // title: " "
    //  icon_title: EPopUp.WARNING_ICON; //deleted by aettie 2031.04.01 ISV 78226
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263
      message: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_MEDIA_NO_IMAGE_IN_USB") }
      }

      buttons: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_POPUP_OK"); btn_id: 1 }
      }

      onBtnClicked:
      {
      	if(!popupNoImageFileInUSB.visible) return;//added by edo.lee 01.19
         popupNoImageFileInUSB.hideFocus()
         popupNoImageFileInUSB.focus_visible = false // added by lssanh 2013.03.01 ISV73816
         root.popup_state = RES.const_POPUP_ID_NONE //added by edo.lee 2012.10.31 for CR 15175
         hide()
         //root.handleTabChange("Jukebox") delete by edo.lee 2012.08.24
         EngineListener.HandleBackKey() // modified by ravikanth 26-03-13
      }
   }

   DHAVN_MP_PopUp_Text//POPUPWIDGET.PopUpText
   {
      id: popupNoImageFileInJukebox
      z: 1
      visible: false
     // title: " "
     // icon_title: EPopUp.WARNING_ICON; //deleted by aettie 2031.04.01 ISV 78226

      message: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_MEDIA_NO_IMAGE_IN_JUKEBOX") }
      }

      buttons: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_POPUP_OK"); btn_id: 1 }
      }
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263
      onBtnClicked:
      {
      	if(!popupNoImageFileInJukebox.visible) return;//added by edo.lee 01.19
         popupNoImageFileInJukebox.hideFocus()
         hide()
         popupNoImageFileInJukebox.focus_visible = false // added by lssanh 2013.03.01 ISV73816
         root.popup_state = RES.const_POPUP_ID_NONE //added by edo.lee 2012.10.31 for CR 15175
         EngineListener.HandleNoImageInJukebox() // added by wspark 2012.11.01 for SANITY_CM_AJ559
      }
   }

   DHAVN_MP_PopUp_Text//POPUPWIDGET.PopUpText
   {
      id: popupHighTemperature
      z: 1
      visible: false

      //title: " "
      //icon_title: EPopUp.WARNING_ICON; //deleted by aettie 2031.04.01 ISV 78226
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263

      message: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_MEDIA_HIGH_TEMPERATURE") }
      }
   }

   DHAVN_MP_PopUp_Text//POPUPWIDGET.PopUpText
   {
      id: popupUnavailableFormat
      z: 1
      visible: false

      //title: " " 
     //icon_title: EPopUp.WARNING_ICON; //deleted by aettie 2031.04.01 ISV 78226
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263
      message: ListModel
      {
// { modify by lssanh 2012.09.05 for CR 12898      
//         ListElement { msg: QT_TR_NOOP("STR_MEDIA_UNAVAILABLE_FORMAT") }
         ListElement { msg: QT_TR_NOOP("STR_MEDIA_UNAVAILABLE_FILE") }
// } modify by lssanh 2012.09.05 for CR 12898         
      }

      buttons: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_POPUP_OK"); btn_id: 1 }
      }

      onBtnClicked:
      {
      	if(!popupUnavailableFormat.visible) return;//added by edo.lee 01.19
         popupUnavailableFormat.hideFocus()
         popupUnavailableFormat.focus_visible = false // added by lssanh 2013.03.01 ISV73816
         root.popup_state = RES.const_POPUP_ID_NONE //added by edo.lee 2012.10.31 for CR 15175
         hide()
         //changed by Alexey Edelev. Fix bug 13059. 2012.08.24
         //{
         if(EngineListener.isRunFromFileManager)
         {
             EngineListener.LaunchFileManager( EngineListener.getCurrentFilePath(EngineListener.currentSource) )
             EngineListener.isRunFromFileManager = false;
             //Added by alexey edelev 2012.09.08. Fix bug 13059.
             //{
             if(!EngineListener.restorePreviouslyPlayedImage())
             {
                 root.check_direction();
             }
             //}
             //Added by alexey edelev 2012.09.08. Fix bug 13059.
         }
//         else
//         {
//             root.check_direction()
//         }
         //}
         //changed by Alexey Edelev. Fix bug 13059. 2012.08.24
      }
//{Added by Alexey Edelev 2012.10.23 CR14235
       Timer
       {
           id: popupUnavailableFormatTimer
           interval: 3000
           repeat: false
           running: false
           onTriggered:
           {
               popupUnavailableFormat.btnClicked(1);
           }
       }
//}Added by Alexey Edelev 2012.10.23 CR14235
   }
//   POPUPWIDGET.Zoom_Photo
	DHAVN_MP_PopUp_Dimmed //modified by edo.lee 2013.01.23
   {
      id: popupZoom
      z: 1
      visible: false
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.left: parent.left
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263
   }

   Timer
   {
      id: popup_timer
      interval: 3000
      repeat: false
      running: false
      onTriggered:
      {
         hide()
         // EngineListenerMain.qmlLog( "[MP_Photo] Popup Timer Triggered" )
      }
   }

   DHAVN_MP_PopUp_Text//POPUPWIDGET.PopUpText
   {
      id: popupFileExists
      z: 1
      visible: false

      //title: QT_TR_NOOP("STR_MEDIA_SAVE_FRAME") //deleted by aettie 2013.04.02 for New UX
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263
      message: fileExistsPopupModel

      buttons: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_POPUP_OK"); btn_id: 1 }
         ListElement { msg: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL"); btn_id: 2 }
      }

      onBtnClicked:
      {
      	if(!popupFileExists.visible) return;//added by edo.lee 01.19
         root.popup_state = RES.const_POPUP_ID_NONE //added by edo.lee 2012.10.31 for CR 15175
         switch ( btnId )
         {
            case 1:
            {
               // EngineListenerMain.qmlLog( "[MP_Photo] SaveAsFrame: replace selected" )
               hide() // modified by ravikanth 23-04-13 ISV 80359
               EngineListener.SaveAsFrame( true )
               show_popup( RES.const_POPUP_ID_IMAGE_SAVED )
               popupFileExists.hideFocus()
               popupFileExists.focus_visible = false // added by lssanh 2013.03.01 ISV73816
               break
            }

            case 2:
            {
               // EngineListenerMain.qmlLog( "[MP_Photo] SaveAsFrame: cancel selected" )
               popupFileExists.hideFocus()
               popupFileExists.focus_visible = false // added by lssanh 2013.03.01 ISV73816
               hide()
               break
            }
         }
      }
   }

   // { added by wspark 2012.11.20 for CR15521
   DHAVN_MP_PopUp_Text//POPUPWIDGET.PopUpText
   {
      id: popupFileExistsInJukebox
      z: 1
      visible: false
 
      //title: QT_TR_NOOP("STR_MEDIA_MNG_COPY_FILE") //deleted by aettie 2013.04.02 for New UX
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263
      message: fileExistsInJukeboxPopupModel

      buttons: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_POPUP_OK"); btn_id: 1 }
         ListElement { msg: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL"); btn_id: 2 }
      }

      onBtnClicked:
      {
         if(!popupFileExistsInJukebox.visible) return;//added by edo.lee 01.19
         root.popup_state = RES.const_POPUP_ID_NONE
         switch ( btnId )
         {
            case 1:
            {
               EngineListenerMain.qmlLog( "[MP_Photo] CopyToJukebox: replace selected" )
               if(EngineListener.CopyImageToJukebox( true ))
               {
                    show_popup( RES.const_POPUP_ID_COPY_COMPLETED )
               }
               else
               {

               }
               popupFileExistsInJukebox.hideFocus()
               popupFileExistsInJukebox.focus_visible = false // added by lssanh 2013.03.01 ISV73816
               break
            }

            case 2:
            {
               EngineListenerMain.qmlLog( "[MP_Photo] CopyToJukebox: cancel selected" )
               popupFileExistsInJukebox.hideFocus()
               hide()
               popupFileExistsInJukebox.focus_visible = false // added by lssanh 2013.03.01 ISV73816
               break
            }
         }
      }
   }
   // } added by wspark
   
   // { modified by ravikanth 16-04-13
   DHAVN_MP_PopUp_Text//POPUPWIDGET.PopUpText
   {
      id: popupJukeBoxCopyInProgress
      z: 1
      visible: false
      message: fileCopInProgressPopupModel
      offset_y: popup_rect.offset_y //added by aettie 20130611 for ITS 167263
      buttons: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_MEDIA_MNG_YES"); btn_id: 1 }
         ListElement { msg: QT_TR_NOOP("STR_MEDIA_MNG_NO"); btn_id: 2 }
      }

      onBtnClicked:
      {
         if(!popupJukeBoxCopyInProgress.visible) return;
         root.popup_state = RES.const_POPUP_ID_NONE
         switch ( btnId )
         {
            case 1:
            {
               EngineListenerMain.qmlLog( "[MP_Photo] JukeBoxCopyInProgress: replace selected" )
               EngineListener.CancelCopyJukebox();
               popupJukeBoxCopyInProgress.hideFocus()
               hide()
               popupJukeBoxCopyInProgress.focus_visible = false

               // launch file manager
               EngineListener.setCopy(true);
               EngineListener.LaunchFileManager( EngineListener.getCurrentFilePath(EngineListener.currentSource) );
               break
            }

            case 2:
            {
               EngineListenerMain.qmlLog( "[MP_Photo] JukeBoxCopyInProgress: cancel selected" )
               popupJukeBoxCopyInProgress.hideFocus()
               hide()
               popupJukeBoxCopyInProgress.focus_visible = false
               root.photo_focus_visible = true // modified by ravikanth 10-07-13 for ITS 0178104
               break
            }
         }
      }
   }
   // } modified by ravikanth 16-04-13
}
