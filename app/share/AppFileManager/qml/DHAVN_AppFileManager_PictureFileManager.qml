import Qt 4.7
import QtQuick 1.1 // added by Dmitry 03.05.13
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM
import "DHAVN_AppFileManager_Resources.js" as RES
import com.filemanager.defines 1.0
// removed by Dmitry 25.08.13
import AppEngineQMLConstants 1.0

// modified by Dmitry 23.08.13
DHAVN_AppFileManager_FocusedGridNew
{
   id: gridView

   node_id: 2 // added by Dmitry 07.08.13 for ITS0175300
   //interactive: visibleArea.heightRatio < 1 // modified by Dmitry 25.08.13 //deleted by aettie 20130828 following UX Scenario

   property bool browse_only: UIControl.browseOnly
   property bool scrollingTicker: EngineListener.scrollingTicker; //added 20130621 for [KOR][ISV][83967][C] (aettie.ji)
   property int scrollBarTopMargin: anchors.topMargin // added by Dmitry 25.08.13
   property bool fileSelected: false // added by Michael.kim 2014.11.14 for ITS 252495
   
   anchors.fill: parent
   anchors.topMargin: ( StateManager.rootState || UIControl.bottomBarMode ) ? FM.const_APP_FILE_MANAGER_LIST_TOP_MARGIN
                                                : ( FM.const_APP_FILE_MANAGER_LIST_TOP_MARGIN - FM.const_APP_FILE_MANAGER_NAVIGATOR_HEIGHT )
   anchors.bottomMargin: FM.const_APP_FILE_MANAGER_LIST_BOTTOM_MARGIN

   scrollVisible: visibleArea.heightRatio < 1 // modified by Dmitry 25.08.13
   state: EngineListener.middleEast ? "middleEast" : "normal"
   highlightMoveDuration: 1

   model: PictureListModel // modified by Dmitry 22.08.13

   delegate: pictureItemDelegate

   cellWidth: FM.const_APP_FILE_MANAGER_PICTURE_GRID_VIEW__WIDTH
   cellHeight: FM.const_APP_FILE_MANAGER_PICTURE_GRID_VIEW__HIGHT
   clip: true
   maximumFlickVelocity: 2500 // modified by Dmitry 01.08.2013 for ITS0175300
   cacheBuffer: 1440 // modified by Dmitry 01.08.2013 for ITS0175300
   layoutDirection: EngineListener.middleEast ? Qt.RightToLeft : Qt.LeftToRight

   states: [
      State {
         name: "normal"
         PropertyChanges {
            target: gridView
            anchors.leftMargin: FM.const_APP_FILE_MANAGER_CONTENT_AREA_LEF_MARGIN
            anchors.rightMargin: UIControl.editButton ? FM.const_APP_FILE_MANAGER_CONTENT_AREA_RIGHT_MARGIN :
                                                        FM.const_APP_FILE_MANAGER_CONTENT_AREA_RIGHT_MARGIN + FM.const_APP_FILE_MANAGER_RIGHT_BOTTOMAREA_WIDTH

         }
      },
      State {
         name: "middleEast"
         PropertyChanges {
            target: gridView
            anchors.leftMargin: UIControl.editButton ? FM.const_APP_FILE_MANAGER_CONTENT_AREA_LEF_MARGIN :
                                                       FM.const_APP_FILE_MANAGER_CONTENT_AREA_LEF_MARGIN + FM.const_APP_FILE_MANAGER_RIGHT_BOTTOMAREA_WIDTH
            anchors.rightMargin: FM.const_APP_FILE_MANAGER_CONTENT_AREA_RIGHT_MARGIN
         }
      }
   ]

   Component
   {
      id: pictureItemDelegate

      DHAVN_AppFileManager_PictureWidget
      {
         id: pictureItemDelegateItem//Added by Alexey Edelev 2012.10.25 Fix thumbnails issue
         sNameFolder: itemName
         iNumberPicture: itemElementsCount
         isFolder: itemIsFolder
         selected: itemChecked
         checkVisible: !UIControl.editButton
         focus_visible: gridView.focus_visible && gridView.currentIndex === model.index//Added by Alexey Edelev 2012.10.15
         scrollingTicker: gridView.scrollingTicker && gridView.currentIndex === model.index && gridView.focus_visible
         mirrorLayout: EngineListener.middleEast // modified for ITS 0210303
         fileSelected: gridView.fileSelected // added by Michael.Kim 2014.11.14 for ITS 252495

         onSelectedChanged:
         {
             //EngineListener.qmlLog("ravi photo onSelectedChanged: " + selected + " " +index);
             if(UIControl.bottomBarMode) UIControl.setModeAreaCount("("+ gridView.model.getFileURLCount() +")"); // modified by Dmitry 22.08.13
         }

         onValueChanged:
         {
            gridView.model.checkElement(index, value)
         }

         onFolderSelect:
         {
             if(!StateManager.ShouldChangePath())
                 StateManager.FolderChangedHandler( index, false )
         }

         onFileSelect:
         {
            // EngineListener.qmlLog( "AppFileManager, picture selected = " + itemPath )
             if(!itemSupported)
                 UIControl.showPopupType(UIDef.POPUP_TYPE_UNSUPPORTED_FILE,
                               UIListener.getCurrentScreen() ==
                               UIListenerEnum.SCREEN_FRONT)
             else {
                 if(!gridView.fileSelected) {
                     EngineListener.FileSelected(itemPath, CommonDef.PictureFileType,
                                             UIListener.getCurrentScreen() ==
                                             UIListenerEnum.SCREEN_FRONT, thumbnailStatus == Image.Ready) // modified for ITS 0206895
                     gridView.fileSelected = true
                 }
             }
         }

         onFolderOperation:
         {
            UIControl.contentEventHandler( UIDef.CONTENT_EVENT_FOLDER_OPERATION, itemPath )
         }

         onFileOperation:
         {
             UIControl.contentEventHandler( UIDef.CONTENT_EVENT_FILE_OPERATION, itemPath )
         }

// modified by Dmitry 11.09.13 for ITS0183775
         onSetTouchFocus:
         {
            gridView.currentIndex = index
            if (!gridView.focus_visible)
               gridView.grabFocus(node_id)
         }
      }
   }

// modified by Dmitry 23.08.13

   onCurrentIndexChanged:
   {
      if (gridView.count > 0)
      {
         if (gridView.focus_visible)
         {
            StateManager.setCurrentItemNumber(gridView.currentIndex, gridView.currentItem.isFolder)
         }
         else
         {
            StateManager.setCurrentItemNumber(-1, false)
         }
      }
   }
// modified by Dmitry 11.09.13 for ITS0183775

   onShowFocus:
   {
      if (gridView.currentIndex >= 0 && gridView.count > 0) // modified by Dmitry 09.08.13
          StateManager.setCurrentItemNumber(gridView.currentIndex, gridView.currentItem.isFolder)
   }

   onHideFocus:
   {
      StateManager.setCurrentItemNumber(-1, false)
   }

   onJogSelected:
   {
   	// modified 05-09-13 for ITS 0188256
       if ((UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_FRONT) && EngineListener.isFrontDisplayFG() ||
               (UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_REAR) && EngineListener.isRearDisplayFG())
           currentItem.itemSelected()
       if(UIControl.bottomBarMode) UIControl.setModeAreaCount("("+ gridView.model.getFileURLCount() +")");
   }

   onJogLongPressed: currentItem.itemLongPressed(true)

    Text
    {
        id: emptyStub
        anchors.centerIn: parent
        visible: false
        text: qsTranslate(FM.const_APP_FILE_MANAGER_LANGCONTEXT, "STR_MEDIA_EMPTY") + LocTrigger.empty
        color: FM.const_APP_FILE_MANAGER__COLOR_BRIGHT_GREY //"white" //modified by Michael.Kim 2013.12.19 for ITS 216393
        font.pointSize: 40 //24 //modified by Michael.Kim 2013.12.19 for ITS 216393
        //font.family: FM.const_APP_FILE_MANAGER_FONT_NEW_HDB
        font.family: FM.const_APP_FILE_MANAGER_FONT_NEW_HDR //modified by Michael.Kim 2013.12.19 for ITS 216393
    }

   Connections
   {
       target: EngineListener

       onTickerChanged:
       {
            EngineListener.qmlLog("onTickerChanged ticker : "+ ticker);
            gridView.scrollingTicker = ticker;
       }

       onFileSelectedReset:
       {
           EngineListener.qmlLog("onFileSelectedReset fileSelected : "+ gridView.fileSelected);
           gridView.fileSelected = false
       }
// removed by Dmitry 16.08.13 for ITS0184683
   }

// removed by Dmitry 25.08.13

   Binding
   {
      target: UIControl
      property: "pictureIsChecked"
      value: PictureListModel.itemsAreChecked
   }

// modified by Dmitry 08.08.13 for ITS0183013
   Connections
   {
       target: StateManager

       onCurrentPlayFileNameChanged:
       {
           if(StateManager.GetCurrentMediaState() == CommonDef.PictureFileType) // added by cychoi 2015.08.24 for ITS 267846
           {
               var pindex = gridView.model.getPlayedItemIndex()
               if (pindex != -1)
               {
                  gridView.currentIndex = pindex
                  gridView.positionViewAtIndex( gridView.currentIndex, GridView.Beginning )
               }
           }
       }
   }

// added by Dmitry 27.08.13
   Connections
   {
      target: UIControl

      onEditButtonChanged:
      {
         gridView.positionViewAtIndex (gridView.currentIndex, GridView.Contain)
      }
   }
// added by Dmitry 27.08.13

// added by Dmitry 27.07.13
   Connections
   {
      target: PictureListModel

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
            gridView.currentIndex = -1 // modified by Dmitry 02.08.13

            var pindex = gridView.model.getPlayedItemIndex()
            EngineListener.qmlLog("ZZZ pindex = " + pindex)
            if (pindex != -1)
            {
               gridView.currentIndex = pindex
               gridView.positionViewAtIndex( gridView.currentIndex, GridView.Beginning )
            }
            else
               gridView.currentIndex = 0

            if (gridView.focus_visible)
            {
               StateManager.setCurrentItemNumber(gridView.currentIndex, gridView.currentItem.isFolder)
            }
            else
            {
               StateManager.setCurrentItemNumber(-1, false)
            }
            if(!UIControl.bottomBarMode) // modified by ravikanth 21-08-13
                StateManager.showCountInfo()
            mainScreen.content_visible = true // added by Dmitry 03.10.13 for ITS0187937
         }
      }
   }
// modified by Dmitry 08.08.13 for ITS0183013
// added by Dmitry 15.10.13 for ITS0195216
   Component.onCompleted:
   {
      EngineListener.qmlLog("PictureListModel.layoutReady = " + PictureListModel.layoutReady)
      mainScreen.content_visible = PictureListModel.layoutReady
   }
}

