import Qt 4.7
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM
import "DHAVN_AppFileManager_Resources.js" as RES

Item
{
   id: root

   function updateState()
   {
      switch ( UIControl.currentDevice )
      {
         case UIDef.DEVICE_USB:
         {
            root.state = "usb"
         }
         break

         case UIDef.DEVICE_JUKEBOX:
         {
            root.state = "jukebox"
         }
         break
      }
   }

   width: FM.const_APP_FILE_MANAGER_USBJUKEBOX_WIDTH

   state: "usb"

   Component
   {
      id: button

      Item
      {
         height: img.height
         width: img.width
         Image
         {
            id: img

            anchors { left: parent.left; top: parent.top }

            width: FM.const_APP_FILE_MANAGER_USBJUKEBOX_ITEM_WIDTH
            height: FM.const_APP_FILE_MANAGER_USBJUKEBOX_ITEM_HEIGHT

            source: selected ? RES.const_APP_FILE_MANAGER_USBJUKEBOX_TAB_S_URL : RES.const_APP_FILE_MANAGER_USBJUKEBOX_TAB_N_URL

            Image
            {
               anchors { left: parent.left; top: parent.top }
               anchors.leftMargin: FM.const_APP_FILE_MANAGER_USBJUKEBOX_ITEM_ICON_LEFT_MARGIN
               anchors.topMargin: FM.const_APP_FILE_MANAGER_USBJUKEBOX_ITEM_ICON_TOP_MARGIN

               source: selected ? icon_s : icon_n
            }

            Text
            {
               id: text_id

               anchors.top: parent.top
               anchors.horizontalCenter: parent.horizontalCenter
               anchors.topMargin:
               {
                  var value = FM.const_APP_FILE_MANAGER_USBJUKEBOX_ITEM_TEXT_TOP_MARGIN - text_id.height / 2
                  return value
               }

               text: qsTranslate(FM.const_APP_FILE_MANAGER_LANGCONTEXT, sourceText) + LocTrigger.empty
               color: selected ? FM.const_APP_FILE_MANAGER_USBJUKEBOX_TEXT_COLOR_S : FM.const_APP_FILE_MANAGER_USBJUKEBOX_TEXT_COLOR_N
               // { modified by edo.lee 2012.11.29 New UX
               //font.pixelSize: FM.const_APP_FILE_MANAGER_USBJUKEBOX_FONT_SIZE
               font.pointSize: FM.const_APP_FILE_MANAGER_USBJUKEBOX_FONT_SIZE
               // } modified by edo.lee
            }
         }

         DHAVN_AppFileManager_SimpleBorder
         {
            width: img.width
            height: img.height

            visible: parent.focus_visible
         }
      }
   }

   Loader
   {
      id: usb_button

      property bool selected: false
      property string sourceText: QT_TR_NOOP("STR_MEDIA_USB")
      property url icon_n: RES.const_APP_FILE_MANAGER_USBJUKEBOX_ICON_USB_N_URL
      property url icon_s: RES.const_APP_FILE_MANAGER_USBJUKEBOX_ICON_USB_S_URL

      anchors { left: parent.left; top: parent.top }

      sourceComponent: button

      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            root.state = "usb"
            UIControl.usbjukeEventHandler( UIDef.DEVICE_USB )
         }
      }

      Connections
      {
         target: usb_button.item
         onJogSelected:
         {
            root.state = "usb"
            UIControl.usbjukeEventHandler( UIDef.DEVICE_USB )
         }
      }
   }



   Loader
   {
      id: jukebox_button

      property bool selected: false
      property string sourceText: QT_TR_NOOP("STR_MEDIA_JUKEBOX")
      property url icon_n: RES.const_APP_FILE_MANAGER_USBJUKEBOX_ICON_JUKEBOX_N_URL
      property url icon_s: RES.const_APP_FILE_MANAGER_USBJUKEBOX_ICON_JUKEBOX_S_URL

      anchors { left: parent.left; top: parent.top }
      anchors.topMargin: FM.const_APP_FILE_MANAGER_USBJUKEBOX_ITEM_HEIGHT

      sourceComponent: button

      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            root.state = "jukebox"
            UIControl.usbjukeEventHandler( UIDef.DEVICE_JUKEBOX )
         }
      }

      Connections
      {
         target: jukebox_button.item
         onJogSelected:
         {
            root.state = "jukebox"
            UIControl.usbjukeEventHandler( UIDef.DEVICE_JUKEBOX )
         }
      }
   }

   Image
   {
      anchors { right: parent.right; top: parent.top }
      source: RES.const_APP_FILE_MANAGER_USBJUKEBOX_SHADOW_LIST_URL
   }

   Connections
   {
      target: UIControl

      onCurrentDeviceChanged:
      {
         updateState()
      }
   }

   states:
   [
      State
      {
         name: "usb"
         PropertyChanges { target: usb_button; selected: true }
         PropertyChanges { target: jukebox_button; selected: false }
      },
      State
      {
         name: "jukebox"
         PropertyChanges { target: usb_button; selected: false }
         PropertyChanges { target: jukebox_button; selected: true }
      }
   ]

   Component.onCompleted:
   {
      updateState()
   }
}
