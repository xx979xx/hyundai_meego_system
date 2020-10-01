import QtQuick 1.1 //Changed by Alexey Edelev 2012.10.15

import com.filemanager.uicontrol 1.0
import com.filemanager.defines 1.0 // added by wspark 2012.12.13 for CR16396
import "DHAVN_AppFileManager_General.js" as FM
import "DHAVN_AppFileManager_Resources.js" as RES
// removed by Dmitry 25.08.13
import AppEngineQMLConstants 1.0

DHAVN_AppFileManager_FocusedListNew
{
   id: listView

   node_id: 2
   anchors.fill: parent
   property bool blocked: false
   property bool middleEast: EngineListener.middleEast
   property int prevIndex: 0
// modified by Dmitry 25.08.13
   //interactive: visibleArea.heightRatio < 1 //deleted by aettie 20130828 following UX Scenario
   property int scrollBarTopMargin: FM.const_APP_FILE_MANAGER_SCROLL_TOP_MARGIN

   // modified by ravikanth 09-08-13 for ITS 0183684
   //width: !UIControl.editButton ? ( FM.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_VIEW_EDIT_WIDTH - 250)
   //                                               : parent.
   anchors.rightMargin: UIControl.editButton ? FM.const_APP_FILE_MANAGER_CONTENT_AREA_RIGHT_MARGIN :
                                               FM.const_APP_FILE_MANAGER_CONTENT_AREA_RIGHT_MARGIN + FM.const_APP_FILE_MANAGER_RIGHT_BOTTOMAREA_WIDTH


   model: VideoListModel // modified by Dmitry 22.08.13
   delegate: browse_only ? browseVideoItemDelegate : videoItemDelegate
   highlight: highlightItem
   highlightFollowsCurrentItem: true
   highlightMoveDuration: 1
   clip: true
   cacheBuffer: 10000

	signal itemPressClear()

   scrollVisible: visibleArea.heightRatio < 1 // modified by Dmitry 25.08.13

   LayoutMirroring.enabled: middleEast 
   LayoutMirroring.childrenInherit: true
   
   property bool browse_only: UIControl.browseOnly
   property bool scrollingTicker: EngineListener.scrollingTicker; //added by aettie for ticker stop when DRS on

   Component
   {
      id: videoItemDelegate

      DHAVN_AppFileManager_VideoWidget
      {
         id: videoWidget

         name: itemName
         selected: itemChecked
         isFolder: itemIsFolder
         scrollingTicker: listView.scrollingTicker && listView.currentIndex === model.index && listView.focus_visible//Added by Alexey Edelev 2012.10.06 fix text scrolling
         checkVisible: !UIControl.editButton
         played: itemPlayed

         focus_visible: listView.focus_visible // modified by Dmitry 20.07.13
//added by aettie for focused text color 20131002
         item_focused : listView.focus_visible && listView.count > 0 && listView.currentIndex === model.index  

         onPlayedChanged:
         {
             EngineListener.qmlCritical("onPlayedChanged: "+ played+"; idx= "+index);
         }
         
         // modified by ravikanth for ITS 0184642
         onSelectedChanged:
         {
             if(UIControl.bottomBarMode &&  !UIControl.selectAllEnabled)
                 UIControl.setModeAreaCount("("+ listView.model.getFileURLCount() +")");
			 //modified by Michael.Kim 2013.11.15 for ISV 94567
         }

         onValueChanged:
         {
             listView.model.checkElement(index, value)
         }

         onFolderSelect:
         {
             itemPressClear()
             if(!StateManager.ShouldChangePath())
                 StateManager.FolderChangedHandler( index, false )
         }

         onFileSelect:
         {
             itemPressClear()
             EngineListener.PlayVideoFile( itemPath, UIListener.getCurrentScreen() ==
                                           UIListenerEnum.SCREEN_FRONT );
         }

         onFolderOperation:
         {
             // modified by ravikanth 20-08-13 for delete pause item
             if(played && UIControl.currentDevice == UIDef.DEVICE_JUKEBOX && EngineListener.videoPlaying)
                 UIControl.contentEventHandler( UIDef.CONTENT_EVENT_FILE_BLOCK_DELETE_OPERATION, itemPath )
             else
                 UIControl.contentEventHandler( UIDef.CONTENT_EVENT_FOLDER_OPERATION, itemPath )
         }

         onFileOperation:
         {
             if(played && UIControl.currentDevice == UIDef.DEVICE_JUKEBOX && EngineListener.videoPlaying)
                 UIControl.contentEventHandler( UIDef.CONTENT_EVENT_FILE_BLOCK_DELETE_OPERATION, itemPath )
             else
                 UIControl.contentEventHandler( UIDef.CONTENT_EVENT_FILE_OPERATION, itemPath )
         }

// modified by Dmitry 11.09.13 for ITS0183775
         onSetTouchFocus:
         {
            listView.currentIndex =  index
            if (!listView.focus_visible)
               listView.grabFocus(node_id)
         }

         Connections
         {
            target: listView

            onItemPressClear:
            {
                if ( focus_pressed ) focus_pressed = false
            }
         }
      }
   }

   Component
   {
      id: browseVideoItemDelegate

      DHAVN_AppFileManager_BrowseVideoWidget
      {
         name: itemName
         isFolder: itemIsFolder
         played: itemPlayed
         focus_visible: listView.focus_visible // modified by Dmitry 20.07.13
	 //added by aettie for focused text color 20131002
         item_focused : listView.focus_visible && listView.count > 0 && listView.currentIndex === model.index  
         onFolderSelect:
         {
            StateManager.VideoCopyFolderChangedHandler( index, false )
         }

         onSetTouchFocus:
         {
            listView.currentIndex =  index
            if (!listView.focus_visible)
               listView.grabFocus(node_id)
         }
// modified by Dmitry 11.09.13 for ITS0183775
      }
   }

// modified by Dmitry 20.07.13
   Component
   {
      id: highlightItem
      Image
      {
          id: focus_pictureWidget
          anchors.leftMargin: !UIControl.editButton ? FM.const_APP_FILE_MANAGER_VIDEOWIDGET_EDIT_LIST_LEFT_MARGIN
                                                    : FM.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_LEFT_MARGIN
          source: !UIControl.editButton ? RES.const_APP_FILE_MANAGER_VIDEOWIDGET_EDIT_LIST_02_F_URL
                                        : RES.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_VIDEO_F_URL
	  //added for List Focus Image 20131029				
          anchors.top : listView.currentItem.bottom
          anchors.topMargin : -111

          anchors.bottom : listView.currentItem.bottom
          anchors.bottomMargin : !UIControl.editButton ? -5 : -3
          
          visible: listView.focus_visible && listView.count > 0 &&!listView.currentItem.focus_pressed // modified by Dmitry 02.08.13        
      }
   }
   onJogSelected:
   {
       UIControl.setSharedMemData(0);
       currentItem.itemSelected()
       if(UIControl.bottomBarMode) UIControl.setModeAreaCount("("+ listView.model.getFileURLCount() +")"); //added by yungi 2013.03.08 for New UX FileCount
   }
// modified by Dmitry 16.08.13 for ITS0184683
   onJogPressed:
   {
       UIControl.setSharedMemData(1);
       if(!listView.moving || !listView.flicking)  //added by Hyejin.Noh 20140321 for ITS 0229848
           currentItem.itemPressed(true)
   }
   onJogReleased:
   {
       UIControl.setSharedMemData(0);
   }

   onJogCancelled:
   {
       UIControl.setSharedMemData(0);
       currentItem.itemPressed(false)
   }

   onJogLongPressed: {
       currentItem.itemLongPressed(true)
       //currentItem.focus_pressed=false; //added by suil.you 20130807 for ITS 0183060 //deleted by suilyou 20130911
   }

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

   Component.onCompleted:
   {
       // root.log("Component.onCompleted=")
       EngineListener.videoPlaying = UIControl.IsCurrentVideoPlaying() // added by Dmitry 24.07.13
       // added by Dmitry 15.10.13 for ITS0195216
       EngineListener.qmlLog("VideoListModel.layoutReady = " + VideoListModel.layoutReady)
       mainScreen.content_visible = VideoListModel.layoutReady

       if ( listView.currentIndex == -1)	
         changePlayFileName()
   }

   //onMovementEnded: // modified for ITS 0188370
   onContentYChanged:
   {
       if(!blocked)
           model.updateThumbnails(listView.indexAt(1, contentY), 10)
   }

   onShowFocus:
   {
      if (listView.count> 0 && listView.currentIndex >= 0) // modified by Dmitry 09.08.13
          StateManager.setCurrentItemNumber(listView.currentIndex, listView.currentItem.isFolder)
   }

   onHideFocus:
   {
      StateManager.setCurrentItemNumber(-1, false)
   }

   onCurrentIndexChanged:
   {
      if (!blocked && listView.count > 0) // modified by Dmitry 11.09.13 for ITS0183775
      {
         // modified by ravikanth 08-09-13 for ITS 0187226, 0188223
         //if (listView.focus_visible)
         //{
         //   StateManager.setCurrentItemNumber(listView.currentIndex, listView.currentItem.isFolder)
         //}
         //else
         //{
         //   StateManager.setCurrentItemNumber(-1, false)
         //}
         StateManager.setCurrentItemNumber(listView.currentIndex, listView.currentItem.isFolder)

         if (Math.abs(prevIndex - currentIndex) == listView.count - 1)
         {
            model.updateThumbnails(currentIndex - 5, 6)
         }
         else if (Math.abs(prevIndex - currentIndex) == 1)
         {
            model.updateThumbnails(prevIndex - currentIndex > 0 ? currentIndex - 5: currentIndex + 5, 1) // modified by Dmitry 02.08.13 for ITS0181739
         }
         prevIndex = currentIndex
      }
   }

// removed by Dmitry 25.08.13
   Binding
   {
      target: UIControl
      property: "videoIsChecked"
      value: VideoListModel.itemsAreChecked
   }

// modified by ravikanth 02-09-13 for ITS 0187326
   Connections
   {
      target: UIControl

      onEditButtonChanged:
      {
         listView.positionViewAtIndex( listView.currentIndex, ListView.Contain)
      }
   }

   function changePlayFileName()
   {
       EngineListener.qmlLog("changePlayFileName : "+ listView.moving);
       if(!listView.moving) // modified by ravikanth 08-09-13 for ITS 0187226, 0188223, 0180675
       {
          var pindex = listView.model.getPlayedItemIndex()
          if (pindex != -1)
          {
             listView.currentIndex = pindex
  //modified for list focus of bottom index 20131020
             if (StateManager.rootState){
                listView.positionViewAtIndex( listView.currentIndex, ListView.Center )
             }
             else
             {
                // modified by Dmitry 01.11.13
                var idx = 2;
                if (listView.currentIndex == listView.count - 2) idx = 3
                listView.positionViewAtIndex( listView.currentIndex - idx, ListView.Beginning )
             }
          }
       }
   }

   Connections
   {
       target: StateManager

       onCurrentPlayFileNameChanged:
       {
           if(StateManager.GetCurrentMediaState() == CommonDef.VideoFileType) // added by cychoi 2015.08.24 for ITS 267846
           {
               changePlayFileName()
           }
       }

       // { added by honggi.shin, 2014.03.06, for avoid hanging on to AFM when updating thumbnail
       onUpdateThumbnailsByQML:
       {
           if(!blocked)
               model.updateThumbnails(listView.indexAt(1, contentY), 5)
       }
       // } added by honggi.shin, 2014.03.06 END
   }

   Connections
   {
       target: EngineListener

       onTickerChanged:
       {
            EngineListener.qmlLog("onTickerChanged ticker : "+ ticker);
            listView.scrollingTicker = ticker;
       }

// removed by Dmitry 16.08.13 for ITS0184683
   }

   Connections
   {
      target: VideoListModel

      onLayoutAboutToBeChanged:
      {
         listView.currentIndex = -1 // added by Dmitry 21.08.13 for ITS0185464
         listView.blocked = true;
      }
// modified by Dmitry 08.08.13 for ITS0183013
      onLayoutChanged:
      {
          listView.positionViewAtBeginning() //added for ITS 244080 2014.09.02 To Fix Frame work View Port Error
         if(listView.count <=0)
         {
            emptyStub.visible = true
            if(StateManager.GetCurrentMediaState() == CommonDef.VideoFileType)
            {
                StateManager.emptyState = true;
            }
         }
         else
         {
            emptyStub.visible = false
            if(StateManager.GetCurrentMediaState() == CommonDef.VideoFileType)
            {
                StateManager.emptyState = false;
            }
            listView.grabFocus(listView.node_id) // modified 24-09-13 for ITS 0187109
            var pindex = listView.model.getPlayedItemIndex()
            if (pindex != -1)
            {
               listView.currentIndex = pindex
	       //modified for list focus of bottom index 20131020
                 if (StateManager.rootState){
                    listView.positionViewAtIndex( listView.currentIndex, ListView.Center )
                 }
                 else
                 {
                    listView.positionViewAtBeginning() //added for ITS 241209 2014.08.20 To Fix Frame work View Port Error
                    if (listView.currentIndex == listView.count - 1)
                        listView.positionViewAtEnd()
                    else
                    {
                        var idx = 2;
                        if (listView.currentIndex == listView.count - 2) idx = 3
                        listView.positionViewAtIndex( listView.currentIndex - idx, ListView.Beginning )
                    }
                 }
            }
            else
                listView.currentIndex = 0
            listView.prevIndex = listView.currentIndex
            listView.blocked = false;

            if (listView.focus_visible)
            {
                StateManager.setCurrentItemNumber(listView.currentIndex, listView.currentItem.isFolder)
            }
            else
            {
                StateManager.setCurrentItemNumber(-1, false)
            }
            if(!UIControl.bottomBarMode) // modified by ravikanth 21-08-13
                StateManager.showCountInfo()
            mainScreen.content_visible = true // added by Dmitry 03.10.13 for ITS0187937
         }
         //EngineListener.jogRotateForVideoList();//added for ITS 241209 2014.07.22
      }
   }
// modified by Dmitry 08.08.13 for ITS0183013

   Connections {
      target: EngineListener
      onMiddleEastChanged:
      {
         listView.positionViewAtIndex( listView.currentIndex, ListView.Visible)
      }
   }
}
