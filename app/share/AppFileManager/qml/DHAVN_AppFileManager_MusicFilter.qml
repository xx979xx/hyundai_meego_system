import Qt 4.7
import com.filemanager.uicontrol 1.0

import "DHAVN_AppFileManager_General.js" as FM
import "DHAVN_AppFileManager_Resources.js" as RES


DHAVN_AppFileManager_FocusedItem
{
   id: root

   function updateState()
   {
      switch ( UIControl.musicFileter )
      {
         case UIDef.MUSIC_FILTER_ARTIST:
         {
            root.state = "Artist"
         }
         break

         case UIDef.MUSIC_FILTER_ALBUM:
         {
            root.state = "Album"
         }
         break

         case UIDef.MUSIC_FILTER_SONG:
         {
            root.state = "Song"
         }
         break
      }
   }

   width: FM.const_APP_FILE_MANAGER_MUSIC_FILTER_WIDTH

   state: "Album"

   Component
   {
      id: button

      DHAVN_AppFileManager_FocusedItem
      {
         anchors { left: parent.left; top: parent.top }
         name: "FilterButton"

         height: img.height
         width: img.width
         Image
         {
            id: img

            anchors { left: parent.left; top: parent.top }

            width: FM.const_APP_FILE_MANAGER_MUSIC_FILTER_ITEM_WIDTH
            height: FM.const_APP_FILE_MANAGER_MUSIC_FILTER_ITEM_HEIGHT

            source: RES.const_APP_FILE_MANAGER_MUSIC_FILTER_TAB_BG_URL

            Image
            {
               anchors { left: parent.left; top: parent.top }
               anchors.leftMargin: FM.const_APP_FILE_MANAGER_MUSIC_FILTER_ITEM_ICON_LEFT_MARGIN
               anchors.topMargin: FM.const_APP_FILE_MANAGER_MUSIC_FILTER_ITEM_ICON_TOP_MARGIN

               source: selected ? icon_s : icon_n
            }

            Text
            {
               id: text_id
               anchors.bottom: parent.bottom
               anchors.horizontalCenter: parent.horizontalCenter
               anchors.bottomMargin:
               {
                  var value = FM.const_APP_FILE_MANAGER_MUSIC_FILTER_ITEM_TEXT_BOTTOM_MARGIN - text_id.height / 2
                  return value
               }

               text: qsTranslate(FM.const_APP_FILE_MANAGER_LANGCONTEXT, sourceText) + LocTrigger.empty
               color: selected ? FM.const_APP_FILE_MANAGER_MUSIC_FILTER_ITEM_TEXT_COLOR_S : FM.const_APP_FILE_MANAGER_MUSIC_FILTER_ITEM_TEXT_COLOR_N
               // { modified by edo.lee 2012.11.29 New UX
               //font.pixelSize: FM.const_APP_FILE_MANAGER_MUSIC_FILTER_TEXT_PIXEL_SIZE
               font.pointSize: FM.const_APP_FILE_MANAGER_MUSIC_FILTER_TEXT_PIXEL_SIZE
               // { modified by edo.lee
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

   DHAVN_AppFileManager_FocusedLoader
   {
      id: artist_tab

      property bool selected: false
      property string sourceText: QT_TR_NOOP("STR_MEDIA_ARTIST")
      property url icon_n: RES.const_APP_FILE_MANAGER_MUSIC_FILTER_TAB_ARTIST_N_URL
      property url icon_s: RES.const_APP_FILE_MANAGER_MUSIC_FILTER_TAB_ARTIST_S_URL

      anchors { left: parent.left; top: parent.top }

      sourceComponent: button

      focus_x: 0
      focus_y: 0
      name: "ArtistFilter"

      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            root.state = "Artist"
            UIControl.musicFileterEventHandler( UIDef.MUSIC_FILTER_ARTIST )
         }
      }

      Connections
      {
         target: artist_tab.item
         onJogSelected:
         {
            root.state = "Artist"
            UIControl.musicFileterEventHandler( UIDef.MUSIC_FILTER_ARTIST )
         }
      }
   }

   DHAVN_AppFileManager_FocusedLoader
   {
      id: album_tab

      property bool selected: false
      property string sourceText: QT_TR_NOOP("STR_MEDIA_ALBUM")
      property url icon_n: RES.const_APP_FILE_MANAGER_MUSIC_FILTER_TAB_ALBUM_N_URL
      property url icon_s: RES.const_APP_FILE_MANAGER_MUSIC_FILTER_TAB_ALBUM_S_URL

      anchors.left: parent.left
      anchors.top: artist_tab.bottom

      sourceComponent: button

      focus_x: 0
      focus_y: 1
      name: "AlbumFilter"

      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            root.state = "Album"
            UIControl.musicFileterEventHandler( UIDef.MUSIC_FILTER_ALBUM )
         }
      }

      Connections
      {
         target: album_tab.item
         onJogSelected:
         {
            root.state = "Album"
            UIControl.musicFileterEventHandler( UIDef.MUSIC_FILTER_ALBUM )
         }
      }
   }

   DHAVN_AppFileManager_FocusedLoader
   {
      id: song_tab

      property bool selected: false
      property string sourceText: QT_TR_NOOP("STR_MEDIA_SONG")
      property url icon_n: RES.const_APP_FILE_MANAGER_MUSIC_FILTER_TAB_SONG_N_URL
      property url icon_s: RES.const_APP_FILE_MANAGER_MUSIC_FILTER_TAB_SONG_S_URL

      anchors.left: parent.left
      anchors.top: album_tab.bottom

      sourceComponent: button

      focus_x: 0
      focus_y: 2
      name: "SongFilter"

      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            root.state = "Song"
            UIControl.musicFileterEventHandler( UIDef.MUSIC_FILTER_SONG )
         }
      }

      Connections
      {
         target: song_tab.item
         onJogSelected:
         {
            root.state = "Song"
            UIControl.musicFileterEventHandler( UIDef.MUSIC_FILTER_SONG )
         }
      }
   }

   Connections
   {
      target: UIControl

      onMusicFileterChanged:
      {
         updateState()
      }
   }

   states:
   [
      State
      {
         name: "Artist"
         PropertyChanges { target: artist_tab; selected: true }
         PropertyChanges { target: album_tab; selected: false }
         PropertyChanges { target: song_tab; selected: false }
      },
      State
      {
         name: "Album"
         PropertyChanges { target: artist_tab; selected: false }
         PropertyChanges { target: album_tab; selected: true }
         PropertyChanges { target: song_tab; selected: false }
      },
      State
      {
         name: "Song"
         PropertyChanges { target: artist_tab; selected: false }
         PropertyChanges { target: album_tab; selected: false }
         PropertyChanges { target: song_tab; selected: true }
      }
   ]

   Component.onCompleted:
   {
      updateState()
   }
}
