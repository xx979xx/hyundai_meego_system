import Qt 4.7

import "DHAVN_AppFileManager_General.js" as FM
import "DHAVN_AppFileManager_Resources.js" as RES

DHAVN_AppFileManager_FocusedItem
{
   id: root

   width: parent.width
   height: parent.height

   focus_x: 0
   focus_y: 0
   name: "MusicFileManager"

   state: musicFilter.state

   /** indicate that items are checked */
   property bool itemsAreChecked: listView.model.itemsAreChecked

   Component
   {
      id: artistItemDelegate

      DHAVN_AppFileManager_AudioListArtistItem
      {
         mainText: itemViewName//itemName
         is_checked: itemChecked
         listModel: listView.model
      }
   }

   Component
   {
      id: albumItemDelegate

      DHAVN_AppFileManager_AudioListAlbumItem
      {
         mainText: itemViewName//itemName
         icon: itemIcon
         is_checked: itemChecked
         listModel: listView.model
      }
   }

   Component
   {
      id: songItemDelegate

         DHAVN_AppFileManager_AudioListSongItem
         {
            mainText: itemViewName//itemName
            is_checked: itemChecked
            listModel: listView.model

            onFileSelect:
            {
                // FIXED: CR #1220, CR #1238 Removed audio player
                // start from file manager
               //EngineListener.qmlLog( "AppFileManager: music file select " + index )
               //UIListener.PlayMusicFile( itemPath );
            }
         }
   }

   Component
   {
      id: highlight_component


      DHAVN_AppFileManager_SimpleBorder
      {
         width: listView.width
         height: FM.const_APP_FILE_MANAGER_AUDIO_SONG_LIST_ITEM_HEIGHT
      }
   }

   Image
   {
      source: RES.const_APP_FILE_MANAGER_FILELIST_BG_URL
      anchors.top: parent.top
      anchors.left: parent.left
   }

   DHAVN_AppFileManager_FocusedList
   {
      id: listView

      focus_x: 0
      focus_y: 0
      name: "ListView"

      anchors.top: parent.top
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      width: FM.const_APP_FILE_MANAGER_AUDIO_LIST_WIDTH
      model: AudioListModel
      highlight: highlight_component
      clip: true
   }

   DHAVN_AppFileManager_MusicFilter
   {
      id: musicFilter

      anchors.top: parent.top
      anchors.topMargin: FM.const_APP_FILE_MANAGER_MUSIC_FILTER_TOP_MARGIN
      anchors.right: parent.right
      anchors.rightMargin: FM.const_APP_FILE_MANAGER_MUSIC_FILTER_RIGHT_MARGIN

      focus_x: 1
      focus_y: 0
      name: "MusicFilter"
   }

   states: [
       State
       {
           name: "Artist"
           PropertyChanges { target: listView; delegate: artistItemDelegate }
           PropertyChanges { target: musicFilter; state: "Artist" }
       },
       State
       {
           name: "Album"
           PropertyChanges { target: listView; delegate: albumItemDelegate }
           PropertyChanges { target: musicFilter; state: "Album" }
       },
       State
       {
           name: "Song"
           PropertyChanges { target: listView; delegate: songItemDelegate }
           PropertyChanges { target: musicFilter; state: "Song" }
       }
   ]

   Binding
   {
      target: UIControl
      property: "musicIsChecked"
      value: listView.model.itemsAreChecked
   }
}

