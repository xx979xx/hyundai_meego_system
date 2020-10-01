/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.App.Contacts 0.1
import MeeGo.Media 0.1
import MeeGo.App.IM 0.1
import TelepathyQML 0.1

Flickable {
    id: editViewPortrait
    contentWidth: parent.width
    contentHeight: editList.height
    flickableDirection: Flickable.VerticalFlick
    anchors.horizontalCenter:  parent.horizontalCenter
    height: parent.width
    width: parent.width
    clip: true
    interactive: true
    opacity: 1

    property PeopleModel dataModel: contactModel
    property int index: personRow
    property bool validInput: false

    property string contextHome: qsTr("Home")
    property string contextWork: qsTr("Work")
    property string contextOther: qsTr("Other")
    property string contextMobile: qsTr("Mobile")
    property string defaultFirstName: qsTr("First name")
    property string defaultLastName: qsTr("Last name")
    property string defaultPronounciation: qsTr("Pronounciation")
    property string defaultCompany: qsTr("Company")
    property string defaultNote: qsTr("Enter note")
    property string defaultBirthday: qsTr("Enter birthday")
    property string headerBirthday: qsTr("Birthday")
    property string headerNote: qsTr("Note")

    property string favoriteValue: "Favorite"
    property string favoriteTranslated: qsTr("Favorite")
    property string unfavoriteValue: "Unfavorite"
    property string unfavoriteTranslated: qsTr("Unfavorite")

    property string phoneLabel: qsTr("Phone numbers")
    property string addPhones: qsTr("Add number")
    property string imLabel: qsTr("Instant messaging")
    property string addIms: qsTr("Add account")
    property string emailLabel: qsTr("Email")
    property string addEmails: qsTr("Add email address")
    property string urlLabel: qsTr("Web")
    property string addUrls: qsTr("Add web page")
    property string addressLabel: qsTr("Address")
    property string addAddress: qsTr("Add address")

    function contactSave(contactId){
        var newPhones = phones.getNewDetails();
        var newIms = ims.getNewDetails();
        var newEmails = emails.getNewDetails();
        var newWebs = urls.getNewDetails();
        var addresses = addys.getNewDetails();

        if (avatar_img.source == "image://theme/contacts/img_blankavatar")
            avatar_img.source = "";
            
                peopleModel.editPersonModel(contactId, avatar_img.source,
                                            data_first.text, data_first_p.text,
                                            data_last.text, data_last_p.text,
                                            data_company.text,
                                            newPhones["numbers"], newPhones["types"],
                                            (icn_faves.state == favoriteValue),
                                            newIms["ims"], newIms["types"],
                                            newEmails["emails"], newEmails["types"],
                                            addresses["streets"], addresses["locales"],
                                            addresses["regions"], addresses["zips"],
                                            addresses["countries"], addresses["types"],
                                            newWebs["urls"], newWebs["types"],
                                            datePicker.datePicked, data_notes.text);
    }

    Column{
        id: editList
        spacing: 1
        anchors {left:parent.left; right: parent.right; leftMargin:10; rightMargin:10;}
        Image{
            id: editHeader
            width: parent.width
            height: (data_first_p.visible ? 175 : 150)
            source: "image://theme/contacts/active_row"
            opacity:  (dataModel.data(index, PeopleModel.IsSelfRole) ? .5 : 1)
            Item{
                id: avatar
                width: 150
                height: 150
                anchors {top: editHeader.top; left: parent.left; }

                Image{
                    id: avatar_img
                    //REVISIT: Instead of using the URI from AvatarRole, need to use thumbnail URI
                    source: (dataModel.data(index, PeopleModel.AvatarRole) ? dataModel.data(index, PeopleModel.AvatarRole) : "image://theme/contacts/img_blankavatar")
                    anchors.centerIn: avatar
                    opacity: 1
                    signal clicked
                    width: avatar.width
                    height: avatar.height
                    smooth:  true
                    clip: true
                    state: "default"
                    fillMode: Image.PreserveAspectCrop

                    MouseArea{
                        id: mouseArea_avatar_img
                        anchors.fill: parent
                        onClicked:{
                            photoPicker.show();
                        }
                        onPressed: {
                            avatar.opacity = .5;
                            avatar_img.source = (avatar_img.source == "image://theme/contacts/img_blankavatar" ? "image://theme/contacts/img_blankavatar_dn" : avatar_img.source)
                        }
                    }
                }
            }

            PhotoPicker {
                id: photoPicker
                property string selectedPhoto

                albumSelectionMode: false
                onPhotoSelected: {
                    selectedPhoto = uri.split("file://")[1];
                    editViewPortrait.validInput = true;

                    if (selectedPhoto)
                    {
                        avatar_img.source = selectedPhoto;
                        avatar.opacity = 1;
                    }
                }
            }

            Grid{
                id: headerGrid
                columns:  2
                rows: 2
                anchors{ left: avatar.right; right: editHeader.right; verticalCenter: editHeader.verticalCenter}
                Item{
                    id: quad1
                    width: headerGrid.width/2
                    height: (data_first_p.visible ? childrenRect.height : data_first.height)
                    TextEntry{
                        id: data_first
                        text: dataModel.data(index, PeopleModel.FirstNameRole)
                        defaultText: defaultFirstName
                        width: (parent.width-avatar.width)
                        anchors {top: parent.top;
                                 left: parent.left; leftMargin: 20;
                                 right: parent.right; rightMargin: 10}
                    }
                    TextEntry{
                        id: data_first_p
                        text: dataModel.data(index, PeopleModel.FirstNameProRole)
                        defaultText: defaultPronounciation
                        width: (parent.width - avatar.width)
                        anchors {top: data_first.bottom; topMargin: 10;
                                 left: parent.left; leftMargin: 20;
                                 right: parent.right; rightMargin: 10}
                        visible: localeUtils.needPronounciationFields()
                    }
                }
                Item{
                    id: quad2
                    width: headerGrid.width/2
                    height: (data_last_p.visible ? childrenRect.height : data_last.height)
                    TextEntry{
                        id: data_last
                        text: dataModel.data(index, PeopleModel.LastNameRole)
                        defaultText: defaultLastName
                        width:(parent.width-avatar.width)
                        anchors {top: parent.top;
                                 left: parent.left; leftMargin: 10;
                                 right: parent.right; rightMargin: 20}
                    }
                    TextEntry{
                        id: data_last_p
                        text: dataModel.data(index, PeopleModel.LastNameProRole)
                        defaultText: defaultPronounciation
                        width: (parent.width-avatar.width)
                        anchors {top: data_last.bottom; topMargin: 10;
                                 left: parent.left; leftMargin: 10;
                                 right: parent.right; rightMargin: 20}
                        visible: localeUtils.needPronounciationFields()
                    }
                }
                Item{
                    id: quad3
                    width: headerGrid.width/2
                    height: childrenRect.height
                    TextEntry{
                        id: data_company
                        text: dataModel.data(index, PeopleModel.CompanyNameRole)
                        defaultText: defaultCompany
                        width:(parent.width-avatar.width)
                        anchors{ top: parent.top; topMargin: 10; left: parent.left; leftMargin: 20; right: parent.right; rightMargin: 10;}
                    }
                }
                Item{
                    id: quad4
                    width: headerGrid.width/2
                    height: childrenRect.height
                    Item{
                        anchors{ top: parent.top; topMargin: 10; left: parent.left; leftMargin: 10}
                        width: childrenRect.width
                        height: childrenRect.height
                        Image {
                            id: icn_faves
                            source: (dataModel.data(index, PeopleModel.FavoriteRole) ? "image://theme/contacts/icn_fav_star_dn" : "image://theme/contacts/icn_fav_star" )
                            opacity: (dataModel.data(index, PeopleModel.IsSelfRole) ? 0 : 1)

                            state: (dataModel.data(index, PeopleModel.FavoriteRole) ? favoriteValue : unfavoriteValue)
                            property string favoriteText: unfavoriteTranslated

                            states: [
                                State{ name: favoriteValue
                                    PropertyChanges{target: icn_faves; favoriteText: favoriteTranslated}
                                    PropertyChanges{target: icn_faves; source: "image://theme/contacts/icn_fav_star_dn"}
                                },
                                State{ name: unfavoriteValue
                                    PropertyChanges{target: icn_faves; favoriteText: unfavoriteTranslated}
                                    PropertyChanges{target: icn_faves; source: "image://theme/contacts/icn_fav_star"}
                                }
                            ]
                        }
                    }
                    MouseArea{
                        id: fav
                        anchors.fill: parent
                        onClicked: {
                            icn_faves.state = (icn_faves.source != "image://theme/contacts/icn_fav_star_dn" ? favoriteValue : unfavoriteValue)
                        }
                    }
                }
            }
        }

        ContactsExpandableDetails {
            id: phones 

            headerLabel: phoneLabel
            expandingBoxTitle: addPhones
            newDetailsComponent: PhoneEditWidget{}
            existingDetailsComponent: PhoneEditWidget{}
            existingDetailsModel: dataModel.data(index, PeopleModel.PhoneNumberRole)
            contextModel: dataModel.data(index, PeopleModel.PhoneContextRole)
        }

        ContactsExpandableDetails {
            id: ims 

            headerLabel: imLabel
            expandingBoxTitle: addIms
            newDetailsComponent: ImEditWidget{}
            existingDetailsComponent: ImEditWidget{}
            existingDetailsModel: dataModel.data(index, PeopleModel.OnlineAccountUriRole)
            contextModel: dataModel.data(index, PeopleModel.OnlineServiceProviderRole)
        }

        ContactsExpandableDetails {
            id: emails 

            headerLabel: emailLabel
            expandingBoxTitle: addEmails
            newDetailsComponent: EmailEditWidget{}
            existingDetailsComponent: EmailEditWidget{}
            existingDetailsModel: dataModel.data(index, PeopleModel.EmailAddressRole)
            contextModel: dataModel.data(index, PeopleModel.EmailContextRole)
        }

        ContactsExpandableDetails {
            id: urls 

            headerLabel: urlLabel
            expandingBoxTitle: addUrls
            newDetailsComponent: WebPageEditWidget{}
            existingDetailsComponent: WebPageEditWidget{}
            existingDetailsModel: dataModel.data(index, PeopleModel.WebUrlRole)
            contextModel: dataModel.data(index, PeopleModel.WebContextRole)
        }

        ContactsExpandableDetails {
            id: addys

            headerLabel: addressLabel
            expandingBoxTitle: addAddress
            newDetailsComponent: AddressEditWidget{}
            existingDetailsComponent: AddressEditWidget{}
            existingDetailsModel: dataModel.data(index, PeopleModel.AddressRole)
            contextModel: dataModel.data(index, PeopleModel.AddressContextRole)
        }

        Item{
            id: birthdayHeader
            width: parent.width
            height: 70
            opacity:  1

            Text{
                id: label_birthday
                text: defaultBirthday
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
                smooth: true
                anchors {bottom: birthdayHeader.bottom; bottomMargin: 10; left: parent.left; topMargin: 0; leftMargin: 30}
            }
        }

        Image{
            id: birthday
            width: parent.width
            height: 80
            source: "image://theme/contacts/active_row"
            TextEntry{
                id: data_birthday
                text: dataModel.data(index, PeopleModel.BirthdayRole)
                defaultText: defaultBirthday
                anchors {verticalCenter: birthday.verticalCenter; left: parent.left; topMargin: 30; leftMargin: 30; right: delete_button.left; rightMargin: 30}
                MouseArea{
                    id: mouse_birthday
                    anchors.fill: parent
                    onClicked: {
                        var map = mapToItem (window.content, mouseX, mouseY);
                        datePicker.show(map.x, map.y)
                    }
                }
            }
            Image {
                id: delete_button
                source: "image://theme/contacts/icn_trash"
                width: 36
                height: 36
                anchors {verticalCenter: birthday.verticalCenter; right: parent.right; rightMargin: 10}
                opacity: 1
                MouseArea {
                    id: mouse_delete
                    anchors.fill: parent
                    onPressed: {
                        delete_button.source = "image://theme/contacts/icn_trash_dn";
                    }
                    onClicked: {
                        data_birthday.text = "";
                    }
                }
                Binding{target: delete_button; property: "visible"; value: true; when: data_birthday.text != ""}
                Binding{target: delete_button; property: "visible"; value: false; when: data_birthday.text == ""}
            }
        }

        DatePicker {
            id:datePicker
            parent: editViewPortrait

            property date datePicked 

            onDateSelected: {
                datePicked = selectedDate;
                data_birthday.text = Qt.formatDate(selectedDate, window.dateFormat);
                data_birthday.state = (data_birthday.state == "default" ? "edit" : data_birthday.state)
            }
        }

        Item{
            id: notesHeader
            width: parent.width
            height: 70
            opacity: 1

            Text{
                id: label_notes
                text: headerNote
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
                smooth: true
                anchors {bottom: notesHeader.bottom; bottomMargin: 10; left: parent.left; topMargin: 0; leftMargin: 30}
            }
        }

        Image{
            id: notesBar
            width: parent.width
            height: 340
            source: "image://theme/contacts/active_row"
            anchors.bottomMargin: 1
            TextField{
                id: data_notes
                text: dataModel.data(index, PeopleModel.NotesRole)
                defaultText: defaultNote
                height: 300
                anchors {top: parent.top; left: parent.left; right: parent.right; rightMargin: 30; topMargin: 20; leftMargin: 30}
            }
        }
    }
    Binding{ target: editViewPortrait; property: "validInput"; value: true; when: {
            ((data_first.text != "")||(data_last.text != "")||(data_company.text != "")||(phones.validInput)||(ims.validInput)||(emails.validInput)||(urls.validInput)||(addys.validInput)||(data_birthday.text != "")||(data_notes.text != ""))
        }
    }
    Binding{ target: editViewPortrait; property: "validInput"; value: false; when: {
            ((data_first.text == "")&&(data_last.text == "")&&(data_company.text == "")&&(!phones.validInput)&&(!ims.validInput)&&(!emails.validInput)&&(!urls.validInput)&&(!addys.validInput)&&(data_birthday.text == "")&&(data_notes.text == ""))
        }
    }
}

