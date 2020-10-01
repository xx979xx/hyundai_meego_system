/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass MusicPicker
  \section1 MusicPicker
  \qmlcm The MusicPicker provides a modal dialog in which the user can choose an
         album, playlist or single song. The 'OK' button is disabled until a selection was made.
         On 'OK'-clicked the signal albumOrPlaylistSelected is emitted which provides
         the selected item's data. Multiselection of items is possible by setting set
         multiSelection: true (though disabled due to missing design for multiple song selection).

  \section2 API Properties
  \qmlproperty bool showAlbums
  \qmlcm property which enables the albums in the picker.

  \qmlproperty bool showPlaylists
  \qmlcm property which enables the playlist in the picker.

  \qmlproperty bool multiSelection
  \qmlcm property which sets the multi-selection of the media grid.

  \qmlproperty bool selectSongs
  \qmlcm property which sets the selection of songs in the media list

  \section2 Signals
  \qmlproperty [signal] albumOrPlaylistSelected
  \qmlcm Signal which returns the selected albums and/or playlist if
         the dialog was accepted.
         \param	string	title
         \qmlpcm title of the selected item. \endparam
         \param	string	uri
         \qmlpcm path to the album or playlist. \endparam
         \param	string	thumbUri
         \qmlpcm path to the thumbnail of the album or playlist. \endparam
         \param int	type
         \qmlpcm type of the item. \endparam

  \qmlproperty [signal] multipleAlbumsOrPlaylistsSelected
  \qmlcm Signal which returns the selected albums and/or playlists if
         the dialog was accepted.
         \param	string	titles
         \qmlpcm title of the selected items. \endparam
         \param	string	uris
         \qmlpcm path to the albums or playlists. \endparam
         \param	string	thumbUris
         \qmlpcm path to the thumbnails of the albums or playlists. \endparam
         \param int	types
         \qmlpcm type of the items. \endparam


  \qmlproperty [signal] songSelected
  \qmlcm Signal which returns the selected song if the dialog was accepted.
    \param string title
    \qmlpcm title of the selected item. \endparam
    \param  string  uri
    \qmlpcm path to the song. \endparam
    \param  string  thumbUri
    \qmlpcm path to the thumbnail of the song. \endparam
    \param string album
    \qmlpcm title of the selected album. \endparam
    \param int type
    \qmlpcm type of the item. \endparam

  \qmlproperty [signal] multipleSongsSelected
  \qmlcm Signal which returns the selected songs if the dialog was accepted.
    \param string titles
    \qmlpcm titles of the selected items. \endparam
    \param  string  uris
    \qmlpcm paths to the songs. \endparam
    \param  string  thumbUris
    \qmlpcm paths to the thumbnails of the songs. \endparam
    \param string album
    \qmlpcm title of the selected album. \endparam
    \param int types
    \qmlpcm types of the items. \endparam

  \qmlproperty [signal] accepted
  \qmlcm emitted on 'OK' clicked.

  \qmlproperty [signal] rejected
  \qmlcm emitted on 'Cancel' clicked.

  \qmlproperty [signal] showCalled
  \qmlcm notifies the children that the ModalFog is about to show up.

  \section2 Functions
  
  \qmlfn show
  \qmlcm fades the picker in, inherited from ModalFog.

  \qmlfn hides
  \qmlcm fades the picker out, inherited from ModalFog.

  \section2 Example
  \qml
    AppPage{
        MusicPicker {
            id: myMusicPicker

            showAlbums: true
            showPlayList: false

            onAlbumOrPlaylistSelected: {
               // handle the given data
            }

            onRejected: {
                // handle the rejection
            }
        }

       Component.onCompleted: {
            myMusicPicker.show();
        }
     }
 \endqml
*/

import Qt 4.7
import MeeGo.Media 0.1 as Media
import MeeGo.Components 0.1
import "pickerArray.js" as PickerArray

ModalDialog {
    id: musicPicker

    // API
    property bool showAlbums: true
    property bool showPlaylists: true
    property bool selectSongs: false
    property bool multiSelection: false

    signal albumOrPlaylistSelected( string title, string uri, string thumbUri, int type )
    signal multipleAlbumsOrPlaylistsSelected( variant titles, string uris, string thumbUris, variant types )
    signal songSelected( string title, string uri, string thumbUri, string album, int type )
    signal multipleSongsSelected( variant titles, variant uris, variant thumbUris, string album, variant types )

    // Private
    property variant model: ( showAlbums ? (showPlaylists ? musicAlbumsAndPlaylistsMixed : musicAlbumsOnly) :
                             (showPlaylists ? musicPlaylistsOnly : musicAlbumsAndPlaylistsMixed) ) // don't allow nothing

    property real topHeight: (topItem.topItem.height - topItem.topDecorationHeight) * 0.95   // maximum height relativ to top item height

    property bool albumSelected: false
    property string selectedAlbumName: ""
    property string selectedAlbumThumbUri: ""

    property bool gridVisible: true

    property string backButtonText: qsTr( "Back...")

    property bool acceptBlocked: false

    onModelChanged: musicGridView.model = musicPicker.model;

    onAccepted:{
        if( !acceptBlocked ) {
            acceptBlocked = true

            if( selectSongs ) {
                if( multiSelection ){
                    multipleSongsSelected( PickerArray.titles, PickerArray.uris, PickerArray.thumbUris[0], selectedAlbumName, PickerArray.types )
                }else {
                    songSelected( PickerArray.titles[0] , PickerArray.uris[0], PickerArray.thumbUris[0], selectedAlbumName , PickerArray.types[0] )
                }
            } else if( musicPicker.showAlbums || musicPicker.showPlaylists ) {
                if( PickerArray.titles.length > 0 && PickerArray.types.length > 0 ) {
                    if( multiSelection ) {
                        multipleAlbumsOrPlaylistsSelected( PickerArray.titles, PickerArray.uris, PickerArray.thumbUris, PickerArray.types )
                    }else {
                        albumOrPlaylistSelected( PickerArray.titles[0], PickerArray.uris[0], PickerArray.thumbUris[0], PickerArray.types[0] )
                    }
                }
            }
        }
    } // onAccepted

    onShowCalled: {
        acceptBlocked = false

        musicGridView.positionViewAtIndex( 0, GridView.Beginning )

        for( var i = 0; i < PickerArray.ids.length; i++ ) {
            gridView.model.setSelected( PickerArray.ids[i], false )
        }

        PickerArray.clear();

        if( musicGridView.selectedItem != "" )
            musicGridView.model.setSelected( musicGridView.selectedItem, false )

        if( musicListView.selectedSong != "" ) {
            musicListView.highlightVisible = false  //workaround for qml bug: currentIndex = -1 and setSelected(id, bool) doesn't work
        }

        buttonAccept.enabled = false
        albumSelected = false
    } //onShowCalled

    title: ( ( albumSelected ? qsTr("Pick a Song") : ( showPlaylists && showAlbums ) ? qsTr("Pick a Playlist/Album") :
           ( showPlaylists ? qsTr("Pick a Playlist") : qsTr("Pick an Album") ) ) )

    width: topItem.topItem.width * 0.95

    height: if( selectSongs && albumSelected ) {
                if( musicListView.estimatedHeight + decorationHeight > topHeight ){
                    topHeight
                }
                else {
                    musicListView.estimatedHeight + decorationHeight
                }
            }
            else if(musicGridView.estimateHeight + decorationHeight > topHeight ) {
                topHeight
            }
            else {
                if( musicGridView.estimateHeight + decorationHeight > musicGridView.cellWidth ) {
                    musicGridView.estimateHeight + decorationHeight
                } else {
                   musicGridView.cellWidth + decorationHeight
                }
            }

    content: Item {
        id: musicGridListWrapper
        anchors.fill: parent

        ScrollableMusicList {
            id: musicListView

            visible: musicPicker.albumSelected
            opacity: (musicPicker.albumSelected) ? 1 : 0    // this forces a repaint

            anchors.fill: parent

            model: songsFromAlbum

            onListItemSelected: {
                if( musicPicker.multiSelection ) {
                    var itemSelected = !model.isSelected( itemid ); //if the item was already selected, set itemSelected to false
                    model.setSelected( itemid, itemSelected ); //set the selected state of the item according to itemSelected

                    if( itemSelected ){
                        PickerArray.push( title, "titles" );
                        PickerArray.push( type, "types" );
                        PickerArray.push( uri, "uris" );
                        PickerArray.push( selectedAlbumThumbUri, "thumbUris" );
                    }else {
                        PickerArray.remove( title, "titles" );
                        PickerArray.remove( type, "types" );
                        PickerArray.remove( uri, "uris" );
                        PickerArray.remove( selectedAlbumThumbUri, "thumbUris" );
                    }

                    musicPicker.acceptButtonEnabled = true; //enable OK button
                    musicListView.highlightVisible = true
                }else {
                    model.setSelected( selectedSong, false ); //deselect the former selected item
                    PickerArray.clear();  //PickerArray.remove( title, "titles" );

                    model.setSelected( itemid, true ); //select the clicked item
                    PickerArray.push( title, "titles" );
                    PickerArray.push( type, "types" );
                    PickerArray.push( uri, "uris" );
                    PickerArray.push( selectedAlbumThumbUri, "thumbUris" );

                    selectedSong = itemid

                    buttonAccept.enabled = true //enable OK button
                    musicPicker.acceptButtonEnabled = true
                    musicListView.highlightVisible = true
                }
            }
        }

        Media.MediaGridView {
            id: musicGridView

            // the MucMediaGridView needs a width to be centered correctly inside its parent. To achieve this the estimateColumnCount computes
            // the the number of columns and the width is then set to estimateColumnCount x cellWidth. Unfortunately, the pickers width is needed
            // for this, a value which can't be retrieved via parent.width. So the computation has to be in the picker.

            property int estimateHeight: Math.ceil( model.count / estimateColumnCount ) * cellHeight
            property int estimateColumnCount: Math.floor( ( musicPicker.width - musicPicker.leftMargin - musicPicker.rightMargin ) / cellWidth )
            property string selectedItem: ""

            Component.onCompleted: { musicGridView.model = musicPicker.model }

            defaultThumbnail: "image://themedimage/images/media/music_thumb_med"

            visible: !musicPicker.albumSelected
            opacity: (musicPicker.albumSelected) ? 0 : 1    // this forces a repaint

            selectionMode: true
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: cellWidth * estimateColumnCount
            anchors.horizontalCenter: parent.horizontalCenter

            theGridView.cacheBuffer: 5000

            cellWidth: (topItem.topWidth > topItem.topHeight) ? Math.floor((parent.width-1)  / theme.thumbColumnCountLandscape) - 2
                                                      : Math.floor((parent.width-1) / theme.thumbColumnCountPortrait) - 2
            cellHeight: cellWidth

            onClicked: {
                if( musicPicker.selectSongs ) {
		  
                    selectedAlbumName = payload.mtitle;
                    selectedAlbumThumbUri = payload.mthumburi
                    musicPicker.albumSelected = true;		
		    
                } else {
                    if( musicPicker.multiSelection ) {
                        var itemSelected = !model.isSelected( payload.mitemid ); //if the item was already selected, set itemSelected to false
                        model.setSelected( payload.mitemid, itemSelected ); //set the selected state of the item according to itemSelected
                        if( itemSelected ){
                            PickerArray.push( payload.mtitle, "titles" );
                            PickerArray.push( payload.mitemtype, "types" );
                            PickerArray.push( payload.mthumburi, "thumbUris" );
                            PickerArray.push( payload.muri, "uris" );
                        }else {
                            PickerArray.remove( payload.mtitle, "titles" );
                            PickerArray.remove( payload.mitemtype, "types" );
                            PickerArray.remove( payload.mthumburi, "thumbUris" );
                            PickerArray.remove( payload.muri, "uris" );
                        }
                        musicPicker.acceptButtonEnabled = true; //enable OK button
                    }else {
                        model.setSelected( selectedItem, false ); //deselect the former selected item
                        PickerArray.clear(); //use clear to delete the entry, so we don't have to store the title and thumburi all the time

                        model.setSelected( payload.mitemid, true ); //select the clicked item
                        PickerArray.push( payload.mtitle, "titles" );
                        PickerArray.push( payload.mitemtype, "types" );
                        PickerArray.push( payload.mthumburi, "thumbUris" );
                        PickerArray.push( payload.muri, "uris" );

                        selectedItem = payload.mitemid; //memorize the newly selected item
                        musicPicker.acceptButtonEnabled = true; //enable OK button
                    }
                    buttonAccept.enabled = true //enable OK button
                } //end !selectSongs
            } // onClicked
        } // MucMediaGridView
    } // Item

    showAcceptButton: false
    showCancelButton: false

    buttonRow: [            // custom buttons
        Button {
            id: buttonBack

            text: qsTr( "Back" )
            height:  50
            maxWidth:  musicPicker.width / 4
            minWidth: musicPicker.width * 0.1
            visible: musicPicker.albumSelected
            anchors.verticalCenter: parent.verticalCenter

            bgSourceUp: cancelButtonImage
            bgSourceDn: cancelButtonImagePressed

            onClicked: {
                albumSelected = false
                buttonAccept.enabled = false //disable OK button
                musicListView.highlightVisible = false  //workaround for qml bug: currentIndex = -1 and setSelected(id, bool) doesn't work
            }
        },

        Button {
            id: buttonAccept

            text: qsTr( "OK" )
            height:  50
            maxWidth:  musicPicker.width / 4
            minWidth: musicPicker.width * 0.1
            anchors.verticalCenter: parent.verticalCenter

            bgSourceUp: acceptButtonImage
            bgSourceDn: acceptButtonImagePressed

            onClicked: {
                musicPicker.accepted()
                musicPicker.hide()
            }
        },

        Button {
            id: buttonCancel

            text: qsTr( "Cancel" )
            height:  50
            maxWidth:  musicPicker.width / 4
            minWidth: musicPicker.width * 0.1
            anchors.verticalCenter: parent.verticalCenter

            bgSourceUp: cancelButtonImage
            bgSourceDn: cancelButtonImagePressed

            onClicked: {
                musicPicker.rejected()
                musicPicker.hide()
            }
        }
    ]

    TopItem { id: topItem }
    Theme { id: theme }

    Media.MusicListModel {
        id: musicAlbumsOnly

        type: Media.MusicListModel.ListofAlbums
        limit: 0
        sort: Media.MusicListModel.SortByTitle
        mixtypes: Media.MusicListModel.Albums
    } // MusicListModel

    Media.MusicListModel {
        id: musicPlaylistsOnly

        type: Media.MusicListModel.ListofPlaylists
        limit: 0
        sort: Media.MusicListModel.SortByTitle
        mixtypes: Media.MusicListModel.Playlists
    } // MusicListModel

    Media.MusicListModel {
        id: musicAlbumsAndPlaylistsMixed

        type: Media.MusicListModel.MixedList
        limit: 0
        sort: Media.MusicListModel.SortByTitle
        mixtypes: Media.MusicListModel.Albums| Media.MusicListModel.Playlists
    } // MusicListModel

    Media.MusicListModel {
        id: songsFromAlbum

        type: Media.MusicListModel.ListofSongsForAlbum
        album: selectedAlbumName == undefined ? "" : selectedAlbumName
        limit: 0
        sort: Media.MusicListModel.SortByDefault
    }
}
