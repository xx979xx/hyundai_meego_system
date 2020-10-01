 // { modified by Sergey for CR#15303
import QtQuick 1.0
//import QmlPopUpPlugin 1.0
import Qt.labs.gestures 2.0
import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../models"
import "../popUp"//added by edo.lee 2013.01.22
import "../components"

DHAVN_VP_FocusedItem
{
   id: main
   anchors.fill: parent

   default_x:0
   default_y:0
   name: "FileInfoPopup"

   property string fileName: video_model.filename
   property string resolution: video_model.resolution
   property string duration: video_model.duration

   onFileNameChanged:
   {
      // { modified by yungi 2012.12.13 for CR16307
      //infoPopupModel.set(0, {"msg" : QT_TR_NOOP( "STR_MEDIA_FILENAME" ), "arg1": EngineListener.makeElidedString(fileName, "HDR", 32, 780) } )
       infoPopupModel.set(0, {"name" : QT_TR_NOOP( "STR_MEDIA_FILENAME" ), "value": EngineListener.makeElidedString(fileName,"DH_HDR", 32,
                                      994-EngineListener.getStringWidth(QT_TR_NOOP( "STR_MEDIA_FILENAME") ,"DH_HDR",32 ) ) } )                                    
      // } modified by yungi 2012.12.13 for CR16307
   }

   onResolutionChanged:
   {
      infoPopupModel.set(1, {"name" : QT_TR_NOOP( "STR_MEDIA_RESOLUTION" ), "value": resolution } )
   }

   onDurationChanged:
   {
      infoPopupModel.set(2, {"name" : QT_TR_NOOP( "STR_MEDIA_RUNNINGTIME" ), "value": duration } )
   }

   function retranslateUi()
   {
       popupImageInfo.retranslateUI(CONST.const_APP_VIDEO_PLAYER_LANGCONTEXT)
   }

   GestureArea
   {
       id: gesture_area
       anchors.fill: parent

       Tap
       {
          onStarted:
          {
              controller.onMousePressed();
          }
       }
   }

   //PopUpText
   //PopUpPropertyTable
   DHAVN_MP_PopUp_PropertyTable
   {
      id: popupImageInfo
      //title: QT_TR_NOOP("STR_MEDIA_DETAIL_INFORMATION") //remove by edo.lee 2013.01.19
      message: infoPopupModel
      enableCloseBtn: false

      property string name: "FileInfoPopUpText"
      property int focus_x: 0
      property int focus_y: 0
      focus_id: 0
      
      buttons: ListModel
      {
         ListElement { msg: QT_TR_NOOP("STR_POPUP_OK"); btn_id: 1 }
      }

      onBtnClicked:
      {
         controller.closeScreen()
      }
   }

   ListModel
   {
      id: infoPopupModel
      ListElement { name: "STR_MEDIA_FILENAME"; value: "" }
      ListElement { name: "STR_MEDIA_RESOLUTION"; value: ""}
      ListElement { name: "STR_MEDIA_RUNNINGTIME"; value: "" }
   }

// { added by yungi 2012.12.13 for CR16307
   Connections
   {
      target: EngineListenerMain

      onRetranslateUi:
      {      
         fileName = "" 
         resolution = ""
         duration = "" 
         fileName = video_model.filename 
         resolution = video_model.resolution
         duration = video_model.duration
      }
   }
// } added by yungi 2012.12.13 for CR16307   
}
// } modified by Sergey for CR#15303.
