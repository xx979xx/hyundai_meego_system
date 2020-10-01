import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   signal popupClosed()

   property int popup_type: -1

   anchors.fill: parent

   function retranslateUi()
   {
       popup.retranslateUI(FM.const_APP_FILE_MANAGER_LANGCONTEXT)
   }

   // { added by  yongkyun.lee 2012.10.09 for add close popup
   function closePopup()
   {
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_FILE_OPERATION_CANCEL )
       popupClosed()
   }
   // } added by  yongkyun.lee

   function handleFolderOperation(index)
   {
       switch ( index )
       {
          case 0:
          {
             UIControl.popupEventHandler( UIDef.POPUP_EVENT_FOLDER_OPERATION_RENAME )
          }
          break

          case 1:
          {
             UIControl.popupEventHandler( UIDef.POPUP_EVENT_FOLDER_OPERATION_DELETE )
          }
          break

          default:
          {
              EngineListener.qmlLog("DHAVN_AppFileManager_FolderActionPopUp.handleFolderOperation: unhandled button index " + index)
          }
       }
   }

   function handlePictureJukeboxOperation(index)
   {
       switch ( index )
       {
       // modified by ravikanth 25-07-13 for copy spec changes
//          case 0:
//          {
//             UIControl.popupEventHandler( UIDef.POPUP_EVENT_FILE_OPERATION_RENAME )
//          }
//          break
//Modified by aettie 2013 08 07 [KOR][ITS][182912][minor][KOR][ITS][182908][minor]
          case 0:
          {
                UIControl.popupEventHandler( UIDef.POPUP_EVENT_SAVE_FRAME_REQUEST )

          }
          break

          case 1:
          {
             UIControl.popupEventHandler( UIDef.POPUP_EVENT_FILE_OPERATION_DELETE )
          }
          break

          default:
          {
              EngineListener.qmlLog("DHAVN_AppFileManager_FolderActionPopUp.handlePictureJukeboxOperation: unhandled button index " + index)
          }
       }
   }

   function handlePictureUsbOperation(index)
   {
       switch ( index )
       {
          case 0:
          {
              UIControl.popupEventHandler( UIDef.POPUP_EVENT_SAVE_FRAME_REQUEST )
          }
          break

          default:
          {
              EngineListener.qmlLog("DHAVN_AppFileManager_FolderActionPopUp.handlePictureJukeboxOperation: unhandled button index " + index)
          }
       }
   }

   function handleVideoJukeboxOperation(index)
   {
       switch ( index )
       {
          case 0:
          {
             UIControl.popupEventHandler( UIDef.POPUP_EVENT_FILE_OPERATION_RENAME )
          }
          break

          case 1:
          {
             UIControl.popupEventHandler( UIDef.POPUP_EVENT_FILE_OPERATION_DELETE )
          }
          break

          default:
          {
              EngineListener.qmlLog("DHAVN_AppFileManager_FolderActionPopUp.handlePictureJukeboxOperation: unhandled button index " + index)
          }
       }
   }

   MouseArea
   {
      anchors.fill: parent
   }
//Modified by aettie 2013 08 07 [KOR][ITS][182912][minor][KOR][ITS][182908][minor]
   DHAVN_AppFileManager_PopUp_ListAndButtons
   {
      id: menuList
      listmodel: emptyModel
      buttons: buttonsModel

      property int focus_x: 0
      property int focus_y: 0
      property string name: "PopUpListAndButtons"
      focus_id: 0
      nCurIndex: -1
      visible: true

      onBtnClicked:
      {
         popupClosed()

         UIControl.popupEventHandler( UIDef.POPUP_EVENT_FILE_OPERATION_CANCEL )
      }

      onListItemClicked:
      {
         popupClosed()

         switch ( popup_type )
         {
             case UIDef.FOLDER_MODE_FOLDER:
             {
                 handleFolderOperation(index)
             }
             break

             case UIDef.FOLDER_MODE_FILE_PICTURE_JUKEBOX:
             {
                 handlePictureJukeboxOperation(index)
             }
             break

             case UIDef.FOLDER_MODE_FILE_PICTURE_USB:
             {
                 handlePictureUsbOperation(index)
             }
             break

             case UIDef.FOLDER_MODE_FILE_VIDEO_JUKEBOX:
             {
                 handleVideoJukeboxOperation(index)
             }
             break

             default:
             {
                 EngineListener.qmlLog("DHAVN_AppFileManager_FolderActionPopUp: unhandled popup type " +
                             popup_type)
             }
         }
      }
   }

   ListModel
   {
      id: emptyModel

      ListElement
      {
         name: ""
         index: 0
      }
   }

   ListModel
   {
      id: folderModel

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_RENAME_FOLDER")
         index: 0
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_DELETE")
         index: 1
      }
   }

   ListModel
   {
      id: filePictureJukeboxModel
   // modified by ravikanth 25-07-13 for copy spec changes
//      ListElement
//      {
//         name: QT_TR_NOOP("STR_MEDIA_MNG_RENAME_FILE")
//         index: 0
//      }

//Modified by aettie 2013 08 07 [KOR][ITS][182912][minor][KOR][ITS][182908][minor]
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_SAVE_FRAME")
         index: 0
      }
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_DELETE")
         index: 1
      }
   }

   ListModel
   {
      id: filePictureUsbModel

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_SAVE_FRAME")
         index: 0
      }
   }

   ListModel
   {
      id: fileVideoJukeboxModel

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_RENAME_FILE")
         index: 0
      }

      ListElement
      {
         name:  QT_TR_NOOP("STR_MEDIA_MNG_DELETE")
         index: 1
      }
   }

   ListModel
   {
      id: buttonsModel

      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_CANCEL_BUTTON")
         btn_id: "btn_cancel"
      }
   }

   Binding
   {
      target: menuList
      property: "listmodel"
      value: folderModel
      when: popup_type == UIDef.FOLDER_MODE_FOLDER
   }

   Binding
   {
      target: menuList
      property: "listmodel"
      value: filePictureJukeboxModel
      when: popup_type == UIDef.FOLDER_MODE_FILE_PICTURE_JUKEBOX
   }

   Binding
   {
      target: menuList
      property: "listmodel"
      value: filePictureUsbModel
      when: popup_type == UIDef.FOLDER_MODE_FILE_PICTURE_USB
   }

   Binding
   {
      target: menuList
      property: "listmodel"
      value: fileVideoJukeboxModel
      when: popup_type == UIDef.FOLDER_MODE_FILE_VIDEO_JUKEBOX
   }
}
