/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass DocumentPicker
  \title DocumentPicker
  \section1 DocumentPicker
  The DocumentPicker provides a modal dialog in which the user can choose a
  document. The 'Ok' button is disabled until a selection was made.
  On 'Ok'-clicked, depending on the selection mode, the fitting signal is
  emitted which provides the selected item's data. Multi selection of items
  is possible by setting set multiSelection to true.

  \section2 API Properties

  \section2 Signals

  \qmlsignal documentSelected
  \qmlcm propagates data of the selected document. Triggered on accepted if multiSelection is false
    \param string itemid
    \qmlpcm  ID of the selected document. \endparam
    \param string uri
    \qmlpcm  path to the selected document. \endparam
    \param string itemtitle
    \qmlpcm  title of the selected document. \endparam
    \param string thumbUri
    \qmlpcm  path to the thumbnail. \endparam

  \qmlsignal multipleDocumentsSelected
  \qmlcm propagates data of the selected documents. Triggered on accepted if multiSelection is true
    \param string itemids
    \qmlpcm  ID of the selected documents. \endparam
    \param string uris
    \qmlpcm  path to the selected documents. \endparam
    \param string itemtitles
    \qmlpcm  title of the selected documents. \endparam
    \param string thumbUris
    \qmlpcm  path to the thumbnails. \endparam

  \qmlsignal accepted
  \qmlcm emitted on 'OK' clicked.

  \qmlsignal rejected
  \qmlcm emitted on 'Cancel' clicked.

  \section2 Functions
  \qmlfn show
  \qmlcm fades the picker in, inherited from ModalFog.

  \qmlfn hide
  \qmlcm fades the picker out, inherited from ModalFog.

  \section2  Example
  \code
     AppPage{
        DocumentPicker {
            id: pickerExample

            onDocumentSelected: {
                // itemid, itemtitle and uri are available, picker dialog hidden
            }

            onRejected: {
                // cancel was clicked, picker dialog hidden and no photo selected
            }
        }

        Component.onCompleted: {
            pickerExample.show();
        }
     }
  \endcode
*/
import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Media 0.1
import MeeGo.Labs.Components 0.1
import "../../Ux/Components/Media/pickerArray.js" as PickerArray

ModalDialog {
    id: documentPicker

    property bool multiSelection: false

        // ###
    property real topHeight: (topItem.topItem.height - topItem.topDecorationHeight) * 0.95   // maximum height relativ to top item height

    property bool acceptBlocked: false //private property

    signal documentSelected( string itemid, string itemtitle, string uri, string thumbUri )
    signal multipleDocumentsSelected( variant ids, variant titles, variant uris, variant thumbUris )

    //ids, titles, uris
    onAccepted: {
        if( !acceptBlocked ) {
            acceptBlocked = true

            if( PickerArray.ids.length > 0 && PickerArray.titles.length > 0 ) {
                if( PickerArray.uris.length > 0 ) {
                    if( multiSelection ) {
                        multipleDocumentsSelected( PickerArray.ids, PickerArray.titles, PickerArray.uris, PickerArray.thumbUris )
                    }else {
                        documentSelected( PickerArray.ids[0], PickerArray.titles[0], PickerArray.uris[0], PickerArray.thumbUris[0] )
                    }
                }
            }
        }
    }

    onShowCalled: {     // reset MucMediaGridView on show

        acceptBlocked = false

        gridView.positionViewAtIndex( 0, GridView.Beginning )

        for( var i = 0; i < PickerArray.ids.length; i++ ) {
            gridView.model.setSelected( PickerArray.ids[i], false )
        }

        PickerArray.clear();

        if( gridView.selectedItem != "" )
            gridView.model.setSelected( gridView.selectedItem, false )

        acceptButtonEnabled = false
    }

    //use nearly the whole screen
    width: topItem.topItem.width * 0.95
    height:  if(gridView.estimateHeight + decorationHeight > topHeight ){
                 topHeight
             } else {
                 if( gridView.estimateHeight + decorationHeight > gridView.cellWidth ){
                     gridView.estimateHeight + decorationHeight
                 }
                else{
                     gridView.cellWidth + decorationHeight
                 }
             }

    title: qsTr("Pick a document")

    content: MediaGridView {
        id: gridView

        // the MucMediaGridView needs a width to be centered correctly inside its parent. To achieve this the estimateColumnCount computes
        // the number of columns and the width is then set to estimateColumnCount x cellWidth. Unfortunately, the pickers width is needed
        // for this, a value which can't be retrieved via parent.width. So the computation has to be in the picker.

        property int estimateHeight: Math.ceil( model.count / estimateColumnCount ) * cellHeight
        property int estimateColumnCount: Math.floor( ( documentPicker.width - documentPicker.leftMargin - documentPicker.rightMargin ) / cellWidth )
        property string selectedItem: ""

        defaultThumbnail: "image://themedimage/images/media/document_thumb_med"

        model: allDocumentsListModel
        type: documenttype
        selectionMode: true

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: cellWidth * estimateColumnCount
        anchors.horizontalCenter: parent.horizontalCenter

        cellWidth: (topItem.topWidth > topItem.topHeight) ? Math.floor((parent.width-1)  / theme.thumbColumnCountLandscape) - 2
                                                  : Math.floor((parent.width-1) / theme.thumbColumnCountPortrait) - 2

        //if an item is clicked, update the current data with that item's data
        onClicked: {
            if( documentPicker.multiSelection ) {
                var itemSelected = !model.isSelected( payload.mitemid ); //if the item was already selected, set itemSelected to false
                model.setSelected( payload.mitemid, itemSelected ); //set the selected state of the item according to itemSelected
                if( itemSelected ){
                    PickerArray.push( payload.mitemid, "ids" );
                    PickerArray.push( payload.mtitle, "titles" );
                    PickerArray.push( payload.muri, "uris" );
                    PickerArray.push( payload.mthumburi, "thumbUris" );
                }else {
                    PickerArray.remove( payload.mitemid, "ids" );
                    PickerArray.remove( payload.mtitle, "titles" );
                    PickerArray.remove( payload.muri, "uris" );
                    PickerArray.remove( payload.mthumburi, "thumbUris" );
                }
                documentPicker.acceptButtonEnabled = true; //enable OK button
            }else {
                model.setSelected( selectedItem, false ); //deselect the former selected item
                PickerArray.clear(); //use clear to delete the entry, so we don't have to store the title and thumburi all the time

                model.setSelected( payload.mitemid, true ); //select the clicked item
                PickerArray.push( payload.mitemid, "ids" );
                PickerArray.push( payload.mtitle, "titles" );
                PickerArray.push( payload.mthumburi, "thumbUris" );
                PickerArray.push( payload.muri, "uris" );

                selectedItem = payload.mitemid; //memorize the newly selected item
                documentPicker.acceptButtonEnabled = true; //enable OK button
            }
        }
    }

    TopItem{ id: topItem }
    Theme { id: theme }

    DocumentListModel {
        id: allDocumentsListModel

        type: DocumentListModel.ListofDocuments
        limit: 0
        sort: DocumentListModel.SortByTitle
    }
}

