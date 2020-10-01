import QtQuick 1.1 // modified by Dmitry 03.05.13

import "DHAVN_AppFileManager_General.js" as FM
import "DHAVN_AppFileManager_Resources.js" as RES
import com.filemanager.defines 1.0
import QmlSimpleItems 1.0

import AppEngineQMLConstants 1.0

DHAVN_AppFileManager_FocusedGridNew
{
   id: gridView

// modified by Dmitry 18.08.13 for ITS0184900
   node_id: 2 // added by Dmitry 07.08.13 for ITS0175300
   //interactive: visibleArea.heightRatio < 1 // modified by Dmitry 23.08.13 //deleted by aettie 20130828 following UX Scenario

   anchors.fill: parent
   anchors.topMargin: StateManager.rootState ? FM.const_APP_FILE_MANAGER_LIST_TOP_MARGIN
                                             : FM.const_APP_FILE_MANAGER_LIST_TOP_MARGIN - FM.const_APP_FILE_MANAGER_NAVIGATOR_HEIGHT

   anchors.bottomMargin: FM.const_APP_FILE_MANAGER_LIST_BOTTOM_MARGIN
   anchors.leftMargin: FM.const_APP_FILE_MANAGER_CONTENT_AREA_LEF_MARGIN
   anchors.rightMargin: FM.const_APP_FILE_MANAGER_CONTENT_AREA_RIGHT_MARGIN

   model: PictureListModel
   delegate: browsePictureItemDelegate
   highlightMoveDuration: 1

   cellWidth: FM.const_APP_FILE_MANAGER_PICTURE_GRID_VIEW__WIDTH
   cellHeight: FM.const_APP_FILE_MANAGER_PICTURE_GRID_VIEW__HIGHT
   clip: true
   scrollVisible: visibleArea.heightRatio < 1 // modified by Dmitry 23.08.13

   onJogSelected:
   {
       currentItem.itemSelected()
   }

   onJogLongPressed: currentItem.itemLongPressed(true)

   onShowFocus:
   {
      if (gridView.currentIndex >= 0 && gridView.count > 0) // modified by Dmitry 18.08.13 for ITS0184900
          StateManager.setCurrentItemNumber(gridView.currentIndex, gridView.currentItem.isFolder)
   }

   onHideFocus:
   {
      StateManager.setCurrentItemNumber(-1, false)
   }

   onCurrentIndexChanged:
   {
      if (gridView.focus_visible && gridView.currentIndex >= 0)
      {
         StateManager.setCurrentItemNumber(gridView.currentIndex, gridView.currentItem.isFolder)
      }
      else
      {
         StateManager.setCurrentItemNumber(-1, false)
      }
   }

   Text
   {
       id: emptyStub
       anchors.centerIn: parent
       visible: false
       text: "Empty"
       color: "white"
       font.pointSize: 24
       font.family: FM.const_APP_FILE_MANAGER_FONT_NEW_HDB
   }

   Component
   {
      id: browsePictureItemDelegate

      DHAVN_AppFileManager_BrowsePictureWidget
      {
         sNameFolder: itemName
// removed by Dmitry 23.08.13
         iNumberPicture: itemElementsCount
         isFolder: itemIsFolder
         focus_visible: gridView.focus_visible && gridView.currentIndex === model.index

// modified by Dmitry 11.09.13 for ITS0183775
         onFolderSelect:
         {
            StateManager.PictureFolderChangedHandler( index, false )
         }

         onFileSelect:
         {
            // EngineListener.qmlLog( "AppFileManager, picture selected = " + itemPath )
             EngineListener.FileSelected(itemPath, CommonDef.PictureFileType,
                                         UIListener.getCurrentScreen() ==
                                         UIListenerEnum.SCREEN_FRONT, thumbnailStatus == Image.Ready) // modified for ITS 0206895
         }
	 // modified by ravikanth 06-08-13 for ITS 0176380 

// modified by Dmitry 18.08.13 for ITS0184900
         onSetTouchFocus:
         {
            gridView.currentIndex = index
            if (!gridView.focus_visible)
               gridView.grabFocus(node_id)
         }
// modified by Dmitry 11.09.13 for ITS0183775
// removed by Dmitry 23.08.13
      }
   }

// removed by Dmitry 25.08.13

   Connections
   {
      target: PictureListModel

// modified by Dmitry 08.08.13 for ITS0183013
      onLayoutChanged:
      {
         if(gridView.count <=0)
         {
            emptyStub.visible = true
            if(StateManager.GetCurrentMediaState() == CommonDef.PictureFileType)
            {
                StateManager.emptyState = true;
            }
         }
         else
         {
            emptyStub.visible = false
            if(StateManager.GetCurrentMediaState() == CommonDef.PictureFileType)
            {
                StateManager.emptyState = false;
            }

            // need to set -1 as current index because of GridView issue
            // index should change on startup or currentItem will be NULL
            gridView.currentIndex = -1 // modified by Dmitry 16.08.13

            gridView.currentIndex = 0
            if (gridView.focus_visible)
            {
               StateManager.setCurrentItemNumber(gridView.currentIndex, gridView.currentItem.isFolder)
            }
            else
            {
               StateManager.setCurrentItemNumber(-1, false)
            }
            StateManager.showCountInfo()
         }
      }
// modified by Dmitry 08.08.13 for ITS0183013
   }

// added by Dmitry 15.10.13 for ITS0195216
   Component.onCompleted:
   {
      EngineListener.qmlLog("PictureListModel.layoutReady = " + PictureListModel.layoutReady)
      mainScreen.content_visible = PictureListModel.layoutReady
   }
}


