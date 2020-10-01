import QtQuick 1.0

import "DHAVN_AppFileManager_General.js" as FM
import "DHAVN_AppFileManager_Resources.js" as RES

import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0

DHAVN_AppFileManager_FocusedItem
{
   id: root
// modified by Dmitry 03.05.13
   anchors.fill: parent
   anchors.leftMargin: FM.const_APP_FILE_MANAGER_CONTENT_AREA_LEF_MARGIN

   name: "VideoList_FocusedItem"
   default_x: 0
   default_y: 0

   LayoutMirroring.enabled: EngineListener.middleEast
   LayoutMirroring.childrenInherit: true
// modified by Dmitry 03.05.13
   Component
   {
      id: browseVideoItemDelegate

      DHAVN_AppFileManager_BrowseVideoWidget
      {
         name: itemName
         file: itemThumbPicture1
         isFolder: itemIsFolder
         played: itemPlayed

         onFolderSelect:
         {
            StateManager.VideoFolderChangedHandler( index, false )
         }

         onFileSelect:
         {
            // EngineListener.qmlLog( "AppFileManager: video file selected " + index )
            EngineListener.PlayVideoFile( itemPath, UIListener.getCurrentScreen() ==
                                         UIListenerEnum.SCREEN_FRONT );
         }
      }
   }

   Component
   {
      id: highlight_component

      /** focus */
      Image
      {
         id: focus_pictureWidget
         anchors.left: parent.left
         anchors.leftMargin: !UIControl.editButton ? FM.const_APP_FILE_MANAGER_VIDEOWIDGET_EDIT_LIST_LEFT_MARGIN
                                                   : FM.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_LEFT_MARGIN
//         z:parent.z +100      //deleted by aettie 2013.03.05 for New UX
         source: !UIControl.editButton ? RES.const_APP_FILE_MANAGER_VIDEOWIDGET_EDIT_LIST_02_F_URL
//                                       : RES.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_SXM_F_URL
                                          : RES.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_VIDEO_F_URL //modified by aettie 2013.03.05 for New UX
      }
   }


   Component
   {
      id: stub
      Item {}
   }

   DHAVN_AppFileManager_FocusedList
   {
      id: listView

      property bool focus_moved: false

      focus_x: 0
      focus_y: 0
      name: "ListView"

      anchors.top: parent.top
      anchors.left: parent.left
      width: !UIControl.editButton ? FM.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_VIEW_EDIT_WIDTH
                                   : parent.width
      height: parent.height
      model: VideoListModel
      delegate: browseVideoItemDelegate
      highlight: focus_visible ? highlight_component : stub
      clip: true
      cacheBuffer: 10000

      onJogSelected:
      {
          focus_moved = false;
          currentItem.itemSelected()
      }
// modified by Dmitry 16.08.13 for ITS0184683
      onJogPressed:
      {
          currentItem.itemPressed(true)
      }

      onJogCancelled:
      {
         currentItem.itemPressed(false)
      }

      onJogLongPressed: currentItem.itemLongPressed(true)

      onFocusElement:
      {
          // root.log("Focused element=" + index)
          StateManager.setCurrentItemNumber(index, currentItem.isFolder )
      }

      onFocusMoved:
      {
          if (noCenterJog)
          {
              // EngineListener.qmlLog("onFocusMoved ")
              focus_moved = true;
          }
          else focus_moved = false;
      }

      onCountChanged:
      {
          if (focus_visible)
          {
              currentIndex = 0;
          }
      }

      onSignalHideFocus: StateManager.setCurrentItemNumber(-1, false)

      onSignalShowFocus: StateManager.setCurrentItemNumber(currentIndex, currentItem.isFolder )

      Text
      {
          id: emptyStub
          anchors.centerIn: parent
          visible: false
          text: "Empty"
          color: "white"
          // { modified by edo.lee 2012.11.29 New UX
          //font.pixelSize: 24
          font.pointSize: 24
          // } modified by edo.lee
//          font.family: FM.const_APP_FILE_MANAGER_FONT_HDB
          font.family: FM.const_APP_FILE_MANAGER_FONT_NEW_HDB
      }
   }

   Connections
   {
       target: StateManager

       onUpdateModelFinish:
       {
           if(listView.count <=0)
           {
              emptyStub.visible = true
           }
           else
           {
               emptyStub.visible = false
           }

           if (listView.focus_visible)
           {
               StateManager.setCurrentItemNumber(listView.currentIndex, listView.currentItem.isFolder)
           }
           else
           {
               StateManager.setCurrentItemNumber(-1, false)
           }
       }
   }

   Item
   {
// modified by Dmitry 03.05.13
      anchors.right: parent.right
      anchors.rightMargin: UIControl.editButton ? FM.const_APP_FILE_MANAGER_SCROLL_RIGHT_MARGIN
                                                : FM.const_APP_FILE_MANAGER_RIGHT_BOTTOMAREA_WIDTH
// modified by Dmitry 03.05.13
      anchors.top:parent.top
      anchors.topMargin: FM.const_APP_FILE_MANAGER_SCROLL_TOP_MARGIN
      width: scrollBar.width
      clip: true
      height: UIControl.editButton ? FM.const_APP_FILE_MANAGER_SCROLL_HEIGHT
                                   : (FM.const_APP_FILE_MANAGER_SCROLL_HEIGHT - FM.const_APP_FILE_MANAGER_BOTTOM_BAR_HEIGHT)

      VerticalScrollBar
      {
         id: scrollBar
         height: parent.height
         anchors.left: parent.left
         position: listView.visibleArea.yPosition
         pageSize: listView.visibleArea.heightRatio
      }
   }
}
