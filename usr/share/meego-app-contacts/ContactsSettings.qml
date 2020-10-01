/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Settings 0.1
import MeeGo.App.Contacts 0.1

AppPage {
    id: settingsPage
    property string titleStr: qsTr("Contacts Settings")
    property string sortPreferenceStr: qsTr("Sort Order:")
    property string displayPreferenceStr: qsTr("Display Order:")
    property string sortByFirst: qsTr("Sort by first name")
    property string sortByLast: qsTr("Sort by last name")
    property string displayByFirst: qsTr("Display by first name")
    property string displayByLast: qsTr("Display by last name")

    Translator { catalog: "meego-app-contacts" }
    pageTitle: titleStr
    anchors.fill: parent

    function getSettingText(type) {
        if (type == "sort")
            return sortPreferenceStr;

        return displayPreferenceStr;
    }

    function getCurrentVal(type) {
        if (type == "sort") {
            if (settingsDataStore.getSortOrder() == PeopleModel.LastNameRole)
                return sortByLast;
            else
                return sortByFirst;
        }

        if (settingsDataStore.getDisplayOrder() == PeopleModel.LastNameRole)
            return displayByLast;
        else
            return displayByFirst;
    }

    function getDataList(type) {
        if (type == "sort")
            return [sortByFirst, sortByLast];

        return [displayByFirst, displayByLast];
    }

    function handleSelectionChanged(type, data) {
        if (type == "sort") {
            if (data == sortByFirst)
                settingsDataStore.setSortOrder(PeopleModel.FirstNameRole);
            else if (data == sortByLast)
                settingsDataStore.setSortOrder(PeopleModel.LastNameRole);
        }

        if (data == displayByFirst)
            settingsDataStore.setDisplayOrder(PeopleModel.FirstNameRole);
        else if (data == displayByLast)
            settingsDataStore.setDisplayOrder(PeopleModel.LastNameRole);
    }

    ListModel {
        id: settingsList
        ListElement { type: "sort" }
        ListElement { type: "display" }
    }

    Item {
        anchors.fill: parent

        Flickable {
            contentHeight: contents.height
            anchors.fill: parent
            clip: true

            Column {
                id: contents
                width: parent.width

                Repeater {
                    model: settingsList
                    width: parent.width
                    height: childrenRect.height
                    delegate: settingsComponent
                }
            } //Column
        } //Flickable
    } //Item

    Component {
        id: settingsComponent

        Image {
            id: sortSettingItem
            source: "image://theme/pulldown_box"
            width: parent.width

            Text {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: getSettingText(modelData)
                width: 100
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }

            DropDown {
                anchors {verticalCenter: parent.verticalCenter;
                         right: parent.right
                         rightMargin: 10 }
                title: getCurrentVal(modelData)
                titleColor: theme_fontColorNormal
                replaceDropDownTitle: true

                model: getDataList(modelData)

                width: 300
                minWidth: width
                maxWidth: width + 50

                onTriggered: {
                    handleSelectionChanged(modelData, selectedTitle);
                }
            } //DropDown
        }  //Image
    }  //Component
}
