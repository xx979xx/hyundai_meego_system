/*
* Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import QtMobility.contacts 1.1
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1

/*
* Contacts Picker
 *
 * signals:
 * contactSelected(variant contact)
 * - qdeclarativecontact of selected contact
 *
 * dataSelected(string type, int dataIndex) //not implemented yet
 * - type {"Phone", "Email", "IM"} and index of data, 
 * - usage: if(type == "Phone") contact.phones[dataIndex];
 *
 * parameters:
 * promptString - Title of Picker Dialog
 * filterType - data types to filter by {All, Phone, Email, IM}
 * 
 * functions: 
 *  show() - shows the contact picker with the current list of contacts displayed
 *
 */

ModalDialog {
    id: contactPicker

    property string promptString: qsTr("Pick a contact:")
    property string filterType: "All"

    property int dataIndex: 0 //not implemented yet
    property variant person: null
    property string noContact;

    title: promptString

    signal closed
    signal opened
    signal contactSelected(variant contact)
    signal dataSelected(string type, int dataIndex) //not implemented
    signal cancelled

    onAccepted:{
        contactPicker.contactSelected(contactPicker.person)
        contactPicker.dataSelected(contactPicker.filterType, contactPicker.dataIndex)
        contactPicker.closed();
    }

    onRejected:{
        contactPicker.cancelled();
    }

    Theme{ id:theme }

    sizeHintWidth: 300
    sizeHintHeight: 450

    content: Item {
            id:contactsView

            property int highlightHeight: 0
            property int highlightWidth: 0
            property alias contactListView: cardListView

            function getDataModel(dType, cModel){
                if( dType == "Email"){
                    noContact = qsTr("You have no contacts with an email address");
                    return cModel.emails;
                }else if (dType == "Phone"){
                    noContact = qsTr("You have no contacts with a phone number");
                    return cModel.phoneNumbers;
                }else if (dType == "IM") {
                    noContact = qsTr("You have no contacts with an instant messaging account");
                    return cModel.onlineAccounts;
                }
                noContact = qsTr("You have no contacts");
                return null;
            }

            function getDataValue(dType, dModel, i){
                if( dType == "Email"){
                    return dModel[i].emailAddress;
                }else if (dType == "Phone"){
                    return dModel[i].subTypes[0] + ": "+ dModel[i].number;
                }else if (dType == "IM") {
                    return dModel[i].accountUri;
                }
                return "";
            }

            Component {
                id: cardHighlight
                Rectangle {
                    opacity: .5
                    color: "lightgrey"
                    y: cardListView.currentItem.y
                    width: contactsView.highlightWidth;
                    height: contactsView.highlightHeight
                    z: 2
                    Behavior on y { SmoothedAnimation { velocity: 5000 } }
                }
            }

            anchors.fill: parent
            clip:  true

            Column {
                id:pickerContents
                spacing: 5

   		height: parent.height
                width: parent.width

                Item {
                    id:noContactText
                    height:contactsView.height
                    width:contactsView.width
                    Text {
                        id: noContactPrompt
                        text: noContact
                        color:theme.fontColorHighlight
                        height:contactsView.height
                        width:contactsView.width
                        font.pixelSize: theme.fontPixelSizeLarge
                        anchors.centerIn: contactsView.Center
                        visible: true
                        opacity: 1
                        wrapMode: Text.WordWrap
                    }
                }

                Item {
                    id: groupedViewPortrait
                    width: parent.width
                    height: parent.height

                    ListView {
                        id: cardListView
                        height: parent.height
                        width: groupedViewPortrait.width
                        snapMode: ListView.SnapToItem
                        highlightFollowsCurrentItem: false
                        focus: true
                        keyNavigationWraps: false
                        clip: true
                        opacity: 1

                        property int counter  :  0

                        Component.onCompleted: {
                            positionViewAtIndex(-1, ListView.Beginning);
                            cardListView.currentIndex = -1 // force to -1 since currentIndex inits with 0.
                        }

                        highlight: cardHighlight
                        model: ContactModel {
                            id: contactModel
                            autoUpdate: true
                            Component.onCompleted : {
                                contactModel.sortOrders= sortFirstName;
                                contactModel.filter= allFilter;
                                if(manager == "tracker")
                                    console.debug("[contacts:myappallcontacts] tracker found for all contacts model")
                                }
                                }//model
                                    SortOrder {
                                        id: sortFirstName
                                        detail:ContactDetail.Name
                                        field:Name.FirstName
                                        direction:Qt.AscendingOrder
                                    }
                                    IntersectionFilter {
                                        id: allFilter
                                    }

                                    delegate:  Image {
                                        id: contactCardPortrait

                                        property variant dList : (filterType == "All" ? [""] : contactsView.getDataModel(contactPicker.filterType, model.contact))
                                        function getIfCardVisible(cardValid){
                                            if(cardValid)
                                                cardListView.counter++;
                                        }

                                        height: (filterType == "All" ? 50 : (dList.length > 0 ? childrenRect.height : 0))
                                        width: parent.width
                                        visible: (filterType == "All" ? true : (dList.length > 0 ? true: false))

                                        property variant dataContact: model.contact
                                        property string dataUuid: model.contact.guid.guid
                                        property string dataFirst: model.contact.name.firstName
                                        property string dataLast: model.contact.name.lastName
                                        property string dataCompany: model.contact.organization.name
                                        property string dataFavorite: model.contact.tag.tag
                                        property int dataStatus: model.contact.presence.state
                                        property string dataAvatar: model.contact.avatar.imageUrl

                                        signal clicked

                                        source: "image://theme/contacts/contact_bg_portrait";

                                        Image{
                                            id: photo
                                            fillMode: Image.PreserveAspectFit
                                            smooth: true
                                            width: 50
                                            height: 50
                                            source: (dataAvatar ? dataAvatar :"image://theme/contacts/blank_avatar")
                                            anchors {left: contactCardPortrait.left;}
                                        }

                                        Text{
                                            id: row1
                                            height: 20
                                            text:  dataFirst+" "+dataLast
                                            anchors { left: photo.right; top: photo.top; topMargin: 2; leftMargin: 2;}
                                            font.pixelSize: theme.fontPixelSizeNormal
                                            color: theme.fontColorNormal
                                        }

                                        Column{
                                            id: dataCol
                                            anchors { left: row1.left; top: row1.bottom; topMargin: 2;}
                                            height: (filterType == "All" ? 0 : childrenRect.height)
                                            spacing: 2
                                            visible: (filterType == "All" ? false : true)
                                            Repeater{
                                                id: rep
                                                model: dList
                                                delegate: Text {
                                                    text: contactsView.getDataValue(contactPicker.filterType, dList, index)
                                                    font.pixelSize: theme.fontPixelSizeNormal
                                                    color: theme.fontColorNormal
                                                }
                                            }
                                        }

                                        Image {
                                            id: favorite
                                            source: "image://theme/contacts/icn_fav_star"
                                            height: 10
                                            width: 10
                                            opacity: (dataFavorite == "Favorite" ? 1 : .2 )
                                            anchors {right: contactCardPortrait.right; top: row1.top; rightMargin: 2;}
                                        }

                                        Image {
                                            id: statusIcon
                                            height: 10
                                            width: 10
                                            source: {
                                                if(dataStatus == Presence.Unknown)
                                                    return "image://theme/contacts/status_idle";
                                                else if (dataStatus == Presence.Available)
                                                    return "image://theme/contacts/status_available";
                                                else if (dataStatus == Presence.Busy)
                                                    return "image://theme/contacts/status_busy_sml";
                                                else
                                                    return "image://theme/contacts/status_idle";

                                            }
                                            anchors {horizontalCenter: favorite.horizontalCenter; top: dataCol.bottom; topMargin:2; rightMargin: 2; }
                                        }

                                        Text {
                                            id: statusText
                                            text: {
                                                if (dataStatus == Presence.Unknown)
                                                    return qsTr("Idle");
                                                else if (dataStatus == Presence.Available)
                                                    return qsTr("Available");
                                                else if (dataStatus == Presence.Busy)
                                                    return qsTr("Busy");
                                                else
                                                    return ""
                                            }
                                            anchors { left: row1.left; top: dataCol.bottom; topMargin: 2}
                                            font.pixelSize: theme.fontPixelSizeSmall
                                            color: theme.fontColorHighlight
                                        }

                                        Image{
                                            id: contactDivider
                                            source: "image://theme/contacts/contact_divider"
                                            anchors {right: contactCardPortrait.right; bottom: contactCardPortrait.bottom; left: contactCardPortrait.left; }
                                        }

                                        MouseArea {
                                            id: mouseArea
                                            anchors.fill: contactCardPortrait
                                            onClicked: {
                                                contactCardPortrait.clicked()
                                                cardListView.currentIndex = index
                                                contactPicker.person = dataContact
                                                contactsView.highlightWidth = cardListView.currentItem.width
                                                contactsView.highlightHeight = cardListView.currentItem.height
                                            }
                                        }

                                        Component.onCompleted: {
                                            if(filterType == "All" ? true : (dList.length > 0 ? true: false))
                                                cardListView.counter++;
                                        }

                                    }//contactCardPortrait

                                    section.property: "dataFirst"
                                    section.criteria: ViewSection.FirstCharacter
                                    section.delegate: Image {
                                        id: header

                                        width: parent.width
                                        height: 30

                                        source: "image://theme/contacts/contact_btmbar_landscape";
                                        clip: true

                                        Text {
                                            id: title
                                            text: section
                                            anchors { fill: parent; rightMargin: 6; leftMargin: 20; topMargin: 6; bottomMargin: 6; verticalCenter: header.verticalCenter }
                                            font.pixelSize: theme.fontPixelSixeNormal
                                            color: theme.fontColorHighlight
                                        }
                                    }

                                    Binding{target: noContactText; property: "visible"; value: false; when: cardListView.counter > 0}
                                    Binding{target: noContactText; property: "opacity"; value: 0; when: cardListView.counter > 0}
                    }

                }//portraitGroupedView
            }//Column
        }
}//ContactPicker

