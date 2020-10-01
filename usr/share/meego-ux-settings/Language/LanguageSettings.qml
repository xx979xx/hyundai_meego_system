/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import MeeGo.Settings 0.1

AppPage {
    id: page
    pageTitle: qsTr("Language Settings")

    Flickable {
        contentHeight: contents.height
        anchors.fill: parent
        clip: true

        LocaleSettings { id: localeSettings }

        Column {
            id: contents
            width: parent.width

            Image {
                id: languageItem
                source: "image://theme/pulldown_box"
                width: parent.width

                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Language:")
                    width: 100
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }

                /*DropDown {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    selectedValue: localeSettings.currentLocale()
                    dataList: localeSettings.locales()
                    //width: 300

                    onSelectionChanged: {
                        localeSettings.setLocale(data);
                    }
                }*/
            }
            Image {
                id: keyboardItem
                source: "image://theme/pulldown_box"
                width: parent.width

                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Virtual Keyboard:")
                    width: 100
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }

                /*Labs.DropDown {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    selectedValue: localeSettings.currentLayout()
                    dataList: localeSettings.layouts()
                    //width: 200

                    onSelectionChanged: {
                        localeSettings.setLayout(data);
                    }
                }*/
            }
            Image {
                id: dateFormatItem
                source: "image://theme/pulldown_box"
                width: parent.width

                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Date format:")
                    width: 100
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }

                /*Labs.DropDown {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    selectedValue: localeSettings.currentDateFormat()
                    dataList: localeSettings.dateFormats()
                    //width: 200

                    onSelectionChanged: {
                        localeSettings.setDateFormat(data);
                    }
                }*/
            }
            Image {
                id: timeFormatItem
                source: "image://theme/pulldown_box"
                width: parent.width

                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Time format:")
                    width: 100
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }

               /* Labs.DropDown {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    selectedValue: localeSettings.currentTimeFormat()
                    dataList: localeSettings.timeFormats()
                    //width: 200

                    onSelectionChanged: {
                        localeSettings.setTimeFormat(data);
                    }
                }*/
            }
            /*Image {
                    id: weekStartsItem
                    source: "image://theme/pulldown_box"
                    width: parent.width

                    Text {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: qsTr("Week starts:")
                        width: 100
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    DropDown {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        width: 200
                    }
                }*/
            Image {
                id: numberFormatItem
                source: "image://theme/pulldown_box"
                width: parent.width

                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Number Format:")
                    width: 100
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }

              /*  Labs.DropDown {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    selectedValue: localeSettings.currentNumberFormat()
                    dataList: localeSettings.numberFormats()
                    //width: 200

                    onSelectionChanged: {
                        localeSettings.setNumberFormat(data);
                    }
                }*/
            }
            /*Image {
                    id: currencyItem
                    source: "image://theme/pulldown_box"
                    width: parent.width

                    Text {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: qsTr("Currency:")
                        width: 100
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    DropDown {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        width: 200
                    }
                }
                Image {
                    id: currencyFormatItem
                    source: "image://theme/pulldown_box"
                    width: parent.width

                    Text {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: qsTr("Currency Format:")
                        width: 100
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    DropDown {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        width: 200
                    }
                }
                Image {
                    id: measurementsItem
                    source: "image://theme/pulldown_box"
                    width: parent.width

                    Text {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: qsTr("Measurements:")
                        width: 100
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    DropDown {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        width: 200
                    }
                }
                */
        }
    }
}
