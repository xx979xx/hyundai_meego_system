/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.App.Contacts 0.1
import MeeGo.App.IM 0.1
import TelepathyQML 0.1

Flickable {
    id: detailViewPortrait
    contentWidth: parent.width
    contentHeight: detailsList.height
    flickableDirection: Flickable.VerticalFlick
    height: parent.height
    width: parent.width
    interactive: true
    clip: true;
    opacity: 1

    property PeopleModel detailModel: contactModel
    property int indexOfPerson: personRow

    property string statusIdle: qsTr("Idle")
    property string statusBusy: qsTr("Busy")
    property string statusOnline: qsTr("Online")
    property string statusOffline: qsTr("Offline")

    property string contextHome: qsTr("Home")
    property string contextWork: qsTr("Work")
    property string contextOther: qsTr("Other")
    property string contextMobile: qsTr("Mobile")
    property string contextBookmark: qsTr("Bookmark")
    property string contextFavorite: qsTr("Favorite")

    property string defaultFirstName: qsTr("First name")
    property string defaultLastName: qsTr("Last name")
    property string defaultCompany: qsTr("Company")
    property string defaultNote: qsTr("Enter note")
    property string defaultBirthday: qsTr("Enter birthday")
    property string defaultWeb : qsTr("Site")

    property string headerPhone: qsTr("Phone numbers")
    property string headerIm: qsTr("Instant messaging")
    property string headerEmail: qsTr("Email")
    property string headerWeb: qsTr("Web")
    property string headerAddress : qsTr("Address")
    property string headerBirthday: qsTr("Birthday")
    property string headerDate: qsTr("Date")
    property string headerNote: qsTr("Note")

    property string aimTr : qsTr("AIM")
    property string msnTr : qsTr("MSN")
    property string jabberTr : qsTr("Jabber")
    property string yahooTr : qsTr("Yahoo!")
    property string facebookTr : qsTr("Facebook")
    property string gtalkTr : qsTr("Google Talk")
    property string imTr : qsTr("IM")

    property string favoriteTranslated: qsTr("Favorite")
    property string unfavoriteTranslated: qsTr("Unfavorite")

    //do not internationalize
    property string favoriteWeb: "Favorite"
    property string homeValue: "Home"
    property string workValue: "Work"
    property string otherValue: "Other"
    property string mobileValue: "Mobile"
    property string bookmarkValue: "Bookmark"

    property string aimValue : "im-aim"
    property string msnValue : "im-jabber"
    property string jabberValue : "im_msn"
    property string yahooValue : "im-facebook"
    property string facebookValue : "im-google-talk"
    property string gtalkValue : "im-yahoo"

    property string viewUrl: qsTr("View")
    property string stringTruncater: qsTr("...")

    function getTruncatedString(valueStr, stringLen) {
        var MAX_STR_LEN = stringLen;
        var multiline = (valueStr.indexOf("\n") == -1 ? false : true);
        var valueStr = valueStr.split("\n");
        var MAX_NEWLINE = valueStr.length-1;
        var newStr = "";
        for(var i = 0; i < valueStr.length; i++){
            //Make sure string is no longer than MAX_STR_LEN characters
            //Use MAX_STR_LEN - stringTruncater.length to make room for ellipses
            if (valueStr[i].length > MAX_STR_LEN) {
                valueStr[i] = valueStr[i].substring(0, MAX_STR_LEN - stringTruncater.length);
                valueStr[i] = valueStr[i] + stringTruncater;
            }
            if(multiline && (i<MAX_NEWLINE))
                newStr = newStr + valueStr[i] + "\n";
            else
                newStr = newStr + valueStr[i];
        }
        return newStr;
    }

    function getOnlineStatus() {
        if ((detailModel.data(indexOfPerson, PeopleModel.OnlineAccountUriRole).length < 1)
                || (detailModel.data(indexOfPerson, PeopleModel.OnlineServiceProviderRole).length < 1))
            return "";

        var account = detailModel.data(indexOfPerson, PeopleModel.OnlineServiceProviderRole)[0].split("\n");
        if (account.length != 2)
            return "";
        account = account[1];

        var buddy = detailModel.data(indexOfPerson, PeopleModel.OnlineAccountUriRole)[0].split(") ");
        if (buddy.length != 2)
            return "";
        buddy = buddy[1];

        var contactItem = accountsModel.contactItemForId(account, buddy);

        var presence = contactItem.data(AccountsModel.PresenceTypeRole);
        return presence;
    }

    Column{
        id: detailsList
        spacing: 1
        anchors {left:parent.left; right: parent.right; leftMargin:10; rightMargin:10;}
        Image{
            id: detailHeader
            width: parent.width
            height: (firstname_p.visible ? 175 : 150)
            source: "image://theme/contacts/active_row"
            opacity: (detailModel.data(indexOfPerson, PeopleModel.IsSelfRole) ? .5 : 1)
            Image{
                id: avatar_image
                //REVISIT: Instead of using the URI from AvatarRole, need to use thumbnail URI
                source: (detailModel.data(indexOfPerson, PeopleModel.AvatarRole) ? detailModel.data(indexOfPerson, PeopleModel.AvatarRole): "image://theme/contacts/blank_avatar")
                anchors {top: detailHeader.top; left: parent.left; }
                opacity: 1
                signal clicked
                width: 150
                height: 150
                smooth:  true
                clip: true
                fillMode: Image.PreserveAspectCrop
                //Image.Error
                Binding{target: avatar_image; property: "source"; value:"image://theme/contacts/img_blankavatar"; when: avatar_image.status == Image.Error }
            }
            Grid{
                id: headerGrid
                columns:  2
                rows: 2
                anchors{ left: avatar_image.right; right: detailHeader.right; top: detailHeader.top; bottom: detailHeader.bottom}
                Item{
                    id: quad1
                    width: headerGrid.width*(2/3)
                    height: headerGrid.height/2
                    Item{
                        anchors{verticalCenter: quad1.verticalCenter; left: quad1.left; leftMargin: 50}
                        width: parent.width
                        height: childrenRect.height
                        Text{
                            id: firstname
                            width: parent.width/2
                            text: (detailModel.data(indexOfPerson, PeopleModel.FirstNameRole)? detailModel.data(indexOfPerson, PeopleModel.FirstNameRole) : "")
                            color: theme_fontColorNormal
                            font.pixelSize: theme_fontPixelSizeLarge
                            elide: Text.ElideRight
                            smooth: true
                        }
                        Text{
                            id: firstname_p
                            text: (detailModel.data(indexOfPerson, PeopleModel.FirstNameProRole)? getTruncatedString(detailModel.data(indexOfPerson, PeopleModel.FirstNameProRole), 25) : "")
                            color: theme_fontColorNormal
                            font.pixelSize: theme_fontPixelSizeLarge
                            smooth: true
                            visible: localeUtils.needPronounciationFields()
                            anchors {top: firstname.bottom; topMargin: 10;}
                        }
                        Text{
                            id: lastname
                            width: parent.width/2
                            text: (detailModel.data(indexOfPerson, PeopleModel.LastNameRole) ? detailModel.data(indexOfPerson, PeopleModel.LastNameRole) : "")
                            color: theme_fontColorNormal
                            font.pixelSize: theme_fontPixelSizeLarge
                            elide: Text.ElideRight
                            smooth: true
                            anchors{left: firstname.right; leftMargin: 15;}
                        }
                    }
                }
                Item{
                    id: quad2
                    width: headerGrid.width/3
                    height: headerGrid.height/2
                    Item{
                        anchors.left: parent.left
                        anchors.leftMargin: 100
                        anchors.verticalCenter: parent.verticalCenter
                        width: childrenRect.width
                        height: childrenRect.height
                        Image {
                            id:  icon_status
                            source: {
                                var imStatus = getOnlineStatus();
                                var icon = "";
                                switch(imStatus) {
                                case TelepathyTypes.ConnectionPresenceTypeAvailable:
                                    icon = "image://theme/contacts/status_available_sml";
                                    break;
                                case TelepathyTypes.ConnectionPresenceTypeBusy:
                                    icon = "image://theme/contacts/status_busy_sml";
                                    break;
                                case TelepathyTypes.ConnectionPresenceTypeAway:
                                case TelepathyTypes.ConnectionPresenceTypeExtendedAway:
                                    icon = "image://theme/contacts/status_idle_sml";
                                    break;
                                case TelepathyTypes.ConnectionPresenceTypeHidden:
                                case TelepathyTypes.ConnectionPresenceTypeUnknown:
                                case TelepathyTypes.ConnectionPresenceTypeUnknown:
                                case TelepathyTypes.ConnectionPresenceTypeOffline:
                                default:
                                    icon = "image://theme/contacts/status_idle_sml";
                                }
                                return icon;
                            }

                            anchors{right: label_status.left;  rightMargin: 10}
                            opacity: 1
                        }
                        Text{
                            id: label_status
                            text: {
                                var imStatus = getOnlineStatus();
                                var text = "";
                                switch(imStatus) {
                                case TelepathyTypes.ConnectionPresenceTypeAvailable:
                                    text = statusOnline;
                                    break;
                                case TelepathyTypes.ConnectionPresenceTypeBusy:
                                    text = statusBusy;
                                    break;
                                case TelepathyTypes.ConnectionPresenceTypeAway:
                                case TelepathyTypes.ConnectionPresenceTypeExtendedAway:
                                    text = statusIdle;
                                    break;
                                case TelepathyTypes.ConnectionPresenceTypeHidden:
                                case TelepathyTypes.ConnectionPresenceTypeUnknown:
                                case TelepathyTypes.ConnectionPresenceTypeError:
                                case TelepathyTypes.ConnectionPresenceTypeOffline:
                                default:
                                    text = statusOffline;
                                }
                                return text;
                            }
                            color: theme_fontColorNormal
                            font.pixelSize: theme_fontPixelSizeLarge
                            styleColor: theme_fontColorInactive
                            smooth: true
                            anchors{  left: parent.left}
                        }
                    }
                }
                Item{
                    id: quad3
                    width: headerGrid.width*(2/3)
                    height: headerGrid.height/2
                    Text{
                        id: company
                        width: parent.width
                        text: (detailModel.data(indexOfPerson, PeopleModel.CompanyNameRole) ? detailModel.data(indexOfPerson, PeopleModel.CompanyNameRole) : "")
                        color: theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        elide: Text.ElideRight
                        styleColor: theme_fontColorInactive
                        smooth: true
                        anchors{ verticalCenter: quad3.verticalCenter; left: parent.left; leftMargin: 50}
                    }
                }
                Item{
                    id: quad4
                    width: headerGrid.width/3
                    height: headerGrid.height/2
                    Item{
                        anchors.left: parent.left
                        anchors.leftMargin: 100
                        anchors.verticalCenter: parent.verticalCenter
                        width: childrenRect.width
                        height: childrenRect.height
                        Image {
                            id: icon_favorite
                            anchors{right: parent.left;  rightMargin: 10}
                            source: (detailModel.data(indexOfPerson, PeopleModel.FavoriteRole) ? "image://theme/contacts/icn_fav_star_dn" : "image://theme/contacts/icn_fav_star" )
                            opacity: (detailModel.data(indexOfPerson, PeopleModel.IsSelfRole) ? 0 : 1)
                        }
                    }
                }
            }
        }

        Item{
            id: phoneHeader
            width: parent.width-20
            height: 70
            opacity: (detailModel.data(indexOfPerson, PeopleModel.PhoneNumberRole).length > 0 ? 1: 0)

            Text{
                id: label_phone
                text: headerPhone
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
                styleColor: theme_fontColorInactive
                smooth: true
                anchors {bottom: phoneHeader.bottom; bottomMargin: 10; left: phoneHeader.left; leftMargin: 30}
            }
        }

        Repeater{
            id: detailsPhone
            width: parent.width-20
            height: childrenRect.height
            opacity: phoneHeader.opacity
            model: detailModel.data(indexOfPerson, PeopleModel.PhoneNumberRole)
            property variant phoneContexts: detailModel.data(indexOfPerson, PeopleModel.PhoneContextRole)
            Item{
                id: delegatePhone
                width: parent.width
                height: 80
                Image{
                    id: phoneBar
                    source: "image://theme/contacts/active_row"
                    anchors.fill:  parent
                    Text{
                        id: label
                        text: {
                            if(detailsPhone.phoneContexts[index] == mobileValue)
                                return mobileValue;
                            else if(detailsPhone.phoneContexts[index] == homeValue)
                                return homeValue;
                            else if(detailsPhone.phoneContexts[index] == workValue)
                                return workValue;
                            else if(detailsPhone.phoneContexts[index] == otherValue)
                                return otherValue;
                            else
                                return homeValue;
                        }
                        color: theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        smooth: true
                        anchors {verticalCenter: phoneBar.verticalCenter; left: phoneBar.left; leftMargin: 20}
                        opacity: 1
                    }
                    Text{
                        id: data_phone
                        text: getTruncatedString(modelData, 25)
                        color: theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        smooth: true
                        font.bold: true
                        anchors {verticalCenter: phoneBar.verticalCenter; left: phoneBar.left; leftMargin: 145}
                        opacity: 1
                    }
                }
            }
        }

        Item{
            id: imHeader
            width: parent.width-20
            height: 70
            opacity: (detailModel.data(indexOfPerson, PeopleModel.OnlineAccountUriRole).length > 0 ? 1: 0)

            Text{
                id: label_im
                text: headerIm
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
                styleColor: theme_fontColorInactive
                smooth: true
                anchors {bottom: imHeader.bottom; bottomMargin: 10; left: parent.left; leftMargin: 30}
            }
        }

        Repeater{
            id: detailsIm
            opacity: imHeader.opacity
            width: parent.width-20
            height: childrenRect.height
            model: detailModel.data(indexOfPerson, PeopleModel.OnlineAccountUriRole)
            property variant imContexts: detailModel.data(indexOfPerson, PeopleModel.OnlineServiceProviderRole)
            Item{
                id: delegateim
                width: parent.width
                height: 80

                Image{
                    id: imBar
                    source: "image://theme/contacts/active_row"
                    anchors.fill: parent

                    Text{
                        id: label_im
                        text: {
                            var context = detailsIm.imContexts[index];
                            context = context.split("\n")[0];
                            return context;
                        }
                        color: theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        smooth: true
                        anchors {verticalCenter: imBar.verticalCenter; left: imBar.left; leftMargin: 20 }
                        opacity: 1
                    }

                    Text{
                        id: data_im
                        text: getTruncatedString(modelData, 25)
                        color: theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        smooth: true
                        font.bold: true
                        anchors {verticalCenter: imBar.verticalCenter; left:label_im.right; leftMargin: 20}
                        opacity: 1
                    }
                }
            }
        }

        Item{
            id: emailHeader
            width: parent.width
            height: 70
            opacity: (detailModel.data(indexOfPerson, PeopleModel.EmailAddressRole).length > 0 ? 1 : 0)

            Text{
                id: label_email
                text: headerEmail
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
                styleColor: theme_fontColorInactive
                smooth: true
                anchors {bottom: emailHeader.bottom; bottomMargin: 10; left: parent.left; leftMargin: 30}
            }
        }

        Repeater{
            id: detailsEmail
            width: parent.width
            opacity: emailHeader.opacity
            height: childrenRect.height
            model: detailModel.data(indexOfPerson, PeopleModel.EmailAddressRole)
            property variant emailContexts: detailModel.data(indexOfPerson, PeopleModel.EmailContextRole)

            Item{
                id: delegateemail
                width: parent.width
                height: 80

                Image{
                    id: emailBar
                    source: "image://theme/contacts/active_row"
                    anchors.fill: parent
                    Text{
                        id: email_txt
                        text:  {
                            if(detailsEmail.emailContexts[index] == homeValue)
                                return contextHome;
                            else if(detailsEmail.emailContexts[index] == workValue)
                                return contextWork;
                            else if(detailsEmail.emailContexts[index] == otherValue)
                                return contextOther;
                            else
                                return contextHome;
                        }
                        color: theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        smooth: true
                        anchors {verticalCenter: emailBar.verticalCenter; left: emailBar.left; leftMargin: 20 }
                        opacity: 1
                    }
                    Text{
                        id: data_email
                        text: getTruncatedString(modelData, 25)
                        color: theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        smooth: true
                        font.bold: true
                        anchors {verticalCenter: emailBar.verticalCenter; left: emailBar.left; leftMargin: 110 }
                        opacity: 1
                    }
                }
            }
        }

        Item{
            id: webHeader
            width: parent.width
            height: 70
            opacity: (detailModel.data(indexOfPerson, PeopleModel.WebUrlRole).length > 0 ? 1 : 0)

            Text{
                id: label_web
                text: headerWeb
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
                styleColor: theme_fontColorInactive
                smooth: true
                anchors {bottom: webHeader.bottom; bottomMargin: 10; left: parent.left; topMargin: 10; leftMargin: 30}
            }
        }
        Repeater{
            id: detailsWeb
            width: parent.width
            opacity: webHeader.opacity
            model: detailModel.data(indexOfPerson, PeopleModel.WebUrlRole)
            property variant webContexts: detailModel.data(indexOfPerson, PeopleModel.WebContextRole)

            Item{
                id: delegateweb
                width: parent.width
                height: 80

                Image{
                    id: webBar
                    source: "image://meegotheme/widgets/common/list/list-single-selected"
                    anchors.fill: parent

                    Text{
                        id: button_web_txt
                        text:  {
                            if(detailsWeb.webContexts[index] == favoriteWeb)
                                return contextFavorite;
                            else if(detailsWeb.webContexts[index] == bookmarkValue)
                                return contextBookmark;
                            else
                                return contextBookmark;
                        }
                        color: theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        smooth: true
                        anchors {verticalCenter: webBar.verticalCenter; left: webBar.left; leftMargin: 20 }
                        opacity: 1
                    }
                    Text{
                        id: data_web
                        text: getTruncatedString(modelData, 25)
                        color: theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        smooth: true
                        font.bold: true
                        anchors {verticalCenter: webBar.verticalCenter; left: webBar.left; leftMargin: 145 }
                        opacity: 1
                    }

                    MouseArea{
                        id: mouseArea_url
                        anchors.fill: parent
                        onPressed: {
                            var cmd = "meego-app-browser " + data_web.text;
                            appModel.launch(cmd);
                        }
                    }

                    Labs.ApplicationsModel{
                        id: appModel
                    }
                }
            }
        }

        Item{
            id: addressHeader
            width: parent.width
            height: 70
            opacity: (detailModel.data(indexOfPerson, PeopleModel.AddressRole).length > 0 ? 1: 0)

            Text{
                id: label_address
                text: headerAddress
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
                styleColor: theme_fontColorInactive
                smooth: true
                anchors {bottom: addressHeader.bottom; bottomMargin: 10; left: parent.left; topMargin: 0; leftMargin: 30}
            }
        }
        Repeater{
            id: detailsAddress
            width: parent.width
            opacity: addressHeader.opacity
            model: detailModel.data(indexOfPerson, PeopleModel.AddressRole)
            property variant addressContexts: detailModel.data(indexOfPerson, PeopleModel.AddressContextRole)
            Item{
                id: delegateaddy
                width: parent.width
                height: 200

                Image{
                    id: addyBar
                    source: "image://theme/contacts/active_row"
                    anchors.fill: parent

                    Text{
                        id: button_addy_txt
                        text: {
                            if(detailsAddress.addressContexts[index] == homeValue)
                                return contextHome;
                            else if(detailsAddress.addressContexts[index] == workValue)
                                return contextWork;
                            else if(detailsAddress.addressContexts[index] == otherValue)
                                return contextOther;
                            else
                                return contextHome;
                        }
                        color: theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        smooth: true
                        anchors {verticalCenter: addyBar.verticalCenter; left: addyBar.left; leftMargin: 20 }
                        opacity: 1
                    }
                    Column{
                        width: parent.width-100
                        height: childrenRect.height
                        anchors {verticalCenter: addyBar.verticalCenter; left: addyBar.left; leftMargin: 145 }
                        spacing: 10

                        Item{
                            id: address_rect
                            height: childrenRect.height
                            width: parent.width

                            Text{
                                id: data_street
                                anchors.verticalCenter: address_rect.verticalCenter
                                text: getTruncatedString(modelData, 25)
                                color: theme_fontColorNormal
                                font.pixelSize: theme_fontPixelSizeLarge
                                smooth: true
                                font.bold: true
                                opacity: 1
                            }
                        }

                    }
                }
            }
        }

        Item{
            id: birthdayHeader
            width: parent.width
            height: 70
            opacity: (detailModel.data(indexOfPerson, PeopleModel.BirthdayRole).length > 0 ? 1: 0)

            Text{
                id: label_birthday
                text: headerBirthday
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
                styleColor: theme_fontColorInactive
                smooth: true
                anchors {bottom: birthdayHeader.bottom; bottomMargin: 10; left: parent.left; topMargin: 0; leftMargin: 30}
            }
        }

        Item{
            id: delegatebday
            width: parent.width
            opacity: birthdayHeader.opacity
            height: 80
            Image{
                id: bdayBar
                source: "image://theme/contacts/active_row"
                anchors.fill: parent

                Text{
                    id: button_birthday_txt
                    text: headerDate
                    color: theme_fontColorNormal
                    font.pixelSize: theme_fontPixelSizeLarge
                    smooth: true
                    anchors {verticalCenter: bdayBar.verticalCenter; left: bdayBar.left; leftMargin: 20 }
                    opacity: 1
                }
                Text{
                    id: data_birthday
                    text: detailModel.data(indexOfPerson, PeopleModel.BirthdayRole)
                    color: theme_fontColorNormal
                    font.pixelSize: theme_fontPixelSizeLarge
                    smooth: true
                    font.bold: true
                    anchors {verticalCenter: bdayBar.verticalCenter; left: button_birthday_txt.right; leftMargin: 20 }
                    opacity: 1
                }
            }
        }

        Item{
            id: notesHeader
            width: parent.width
            height: 70
            opacity: (detailModel.data(indexOfPerson, PeopleModel.NotesRole).length > 0 ? 1: 0)

            Text{
                id: label_notes
                text: headerNote
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
                styleColor: theme_fontColorInactive
                smooth: true
                anchors {bottom: notesHeader.bottom; bottomMargin: 10; left: parent.left; topMargin: 0; leftMargin: 30}
            }
        }
        Item{
            id: delegateNote
            width: parent.width
            height: 200
            opacity:  notesHeader.opacity
            Image{
                id: noteBar
                source: "image://theme/contacts/active_row"
                anchors.fill:  parent

                Text{
                    id: data_notes
                    text: getTruncatedString(detailModel.data(indexOfPerson, PeopleModel.NotesRole), 50)
                    color: theme_fontColorNormal
                    font.pixelSize: theme_fontPixelSizeLarge
                    smooth: true
                    font.bold: true
                    anchors {top: noteBar.top; left: noteBar.left; leftMargin: 30; topMargin: 30}
                    opacity: 1
                }
            }
        }
    }
}

