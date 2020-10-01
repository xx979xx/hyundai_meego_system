/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Qt Labs.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/
import Qt 4.7
import ImplicitSizeItem 1.0
import "../../XMData/Javascript/SectionScroller.js" as Sections

ImplicitSizeItem {
    id: root

    property ListView listViewForQuickScroll
    property bool platformSingleRow: false

    function doReload(){
        internal.initDirtyObserver();
    }
    onListViewForQuickScrollChanged: {
        if (listViewForQuickScroll && listViewForQuickScroll.model) {
            internal.initDirtyObserver();
        } else if (listViewForQuickScroll) {
            listViewForQuickScroll.modelChanged.connect(function() {
                if (listViewForQuickScroll.model) {
                    internal.initDirtyObserver();
                }
            })
        }
    }

    Rectangle {
        id: container

        property bool dragging: false
        color: "transparent"
        width: 38/*platformSingleRow ? listView.width : 3 * privateStyle.scrollBarThickness*/
        height: 508/*listView.height*/
        x: listViewForQuickScroll.width - 71/*listView.x + listView.width - width*/
        property string tipText: internal.currentSection
        property string showingText: ""

        onTipTextChanged: {
            checkShowTip();
        }

        MouseArea {
            id: dragArea
            objectName: "dragArea"
            x: -20; y: 0; width: 20+parent.width+40; height: parent.height
            drag.axis: Drag.YAxis
            drag.minimumY: listViewForQuickScroll.y + 10
            drag.maximumY: listViewForQuickScroll.y + listViewForQuickScroll.height - toolTip.height + 10
            property int lastY: 0

            onPressed: {
                internal.adjustContentPosition(dragArea.mouseY);
                container.dragging = true;
                container.checkShowTip();
            }

            onReleased: {
                container.dragging = false;
                container.checkShowTip();

                UIListener.playAudioBeep();
            }

            onPositionChanged: {
                lastY = dragArea.mouseY;
                idTimer.restart();
            }

            Timer{
                id: idTimer
                interval: 10
                repeat: false
                triggeredOnStart: false
                onTriggered: {
                    internal.adjustContentPosition(dragArea.lastY);
                }
            }
        }

        function checkShowTip(){
            if(dragging)
            {
                var fixedText = {'#':true, 'A':true, 'D':true, 'G':true, 'J':true, 'M':true, 'P':true, 'S':true, 'V':true};
                if(fixedText[tipText] == true)
                {
                    toolTip.opa = true;
                    showingText = tipText;
                }else
                {
                    toolTip.opa = false;
                }
            }else
            {
                toolTip.opa = false;
            }
        }

        BorderImage {
            id: singleRowBackground

            objectName: "singleRowBackground"
            width: 38
            height: 508
            source: imageInfo.imgFolderMusic + "quickscroll_bg.png"
            border { left: 10; top: 10; right: 10; bottom: 10 }
            visible: isTouchMode()/*true*/

//            Text {
//                id: singleRowText
//                objectName: "singleRowText"
//                color: colorInfo.brightGrey/*"white"*/
//                anchors.centerIn: parent
//                font.family: systemInfo.font_NewHDB
//                font.pixelSize: 22
//                text: internal.currentSection
//            }

            Item {
                anchors.centerIn: parent
                Text {
                    id: idQuickScroll01Text
                    y: -238
                    color: colorInfo.brightGrey
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 22
                    text: "#"
                }
                Image {
                    id: idQuickScroll01Dot
                    y: idQuickScroll01Text.y + 40
                    source: imageInfo.imgFolderMusic + "quickscroll_dot.png"
                    sourceSize.width: 6
                    sourceSize.height: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: idQuickScroll02Text
                    y: idQuickScroll01Dot.y + 15
                    color: colorInfo.brightGrey
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 22
                    text: "A"
                }
                Image {
                    id: idQuickScroll02Dot
                    y: idQuickScroll02Text.y + 40
                    source: imageInfo.imgFolderMusic + "quickscroll_dot.png"
                    sourceSize.width: 6
                    sourceSize.height: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: idQuickScroll03Text
                    y: idQuickScroll02Dot.y + 15
                    color: colorInfo.brightGrey
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 22
                    text: "D"
                }
                Image {
                    id: idQuickScroll03Dot
                    y: idQuickScroll03Text.y + 40
                    source: imageInfo.imgFolderMusic + "quickscroll_dot.png"
                    sourceSize.width: 6
                    sourceSize.height: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: idQuickScroll04Text
                    y: idQuickScroll03Dot.y + 15
                    color: colorInfo.brightGrey
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 22
                    text: "G"
                }
                Image {
                    id: idQuickScroll04Dot
                    y: idQuickScroll04Text.y + 40
                    source: imageInfo.imgFolderMusic + "quickscroll_dot.png"
                    sourceSize.width: 6
                    sourceSize.height: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: idQuickScroll05Text
                    y: idQuickScroll04Dot.y + 15
                    color: colorInfo.brightGrey
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 22
                    text: "J"
                }
                Image {
                    id: idQuickScroll05Dot
                    y: idQuickScroll05Text.y + 40
                    source: imageInfo.imgFolderMusic + "quickscroll_dot.png"
                    sourceSize.width: 6
                    sourceSize.height: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: idQuickScroll06Text
                    y: idQuickScroll05Dot.y + 15
                    color: colorInfo.brightGrey
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 22
                    text: "M"
                }
                Image {
                    id: idQuickScroll06Dot
                    y: idQuickScroll06Text.y + 40
                    source: imageInfo.imgFolderMusic + "quickscroll_dot.png"
                    sourceSize.width: 6
                    sourceSize.height: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: idQuickScroll07Text
                    y: idQuickScroll06Dot.y + 15
                    color: colorInfo.brightGrey
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 22
                    text: "P"
                }
                Image {
                    id: idQuickScroll07Dot
                    y: idQuickScroll07Text.y + 40
                    source: imageInfo.imgFolderMusic + "quickscroll_dot.png"
                    sourceSize.width: 6
                    sourceSize.height: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: idQuickScroll08Text
                    y: idQuickScroll07Dot.y + 15
                    color: colorInfo.brightGrey
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 22
                    text: "S"
                }
                Image {
                    id: idQuickScroll08Dot
                    y: idQuickScroll08Text.y + 40
                    source: imageInfo.imgFolderMusic + "quickscroll_dot.png"
                    sourceSize.width: 6
                    sourceSize.height: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: idQuickScroll09Text
                    y: idQuickScroll08Dot.y + 15
                    color: colorInfo.brightGrey
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 22
                    text: "V"
                }
            }
        }

        ImplicitSizeItem {
            id: toolTip

            objectName: "toolTip"
            visible: !platformSingleRow
            opacity: 0
            anchors.right: parent.right
            anchors.rightMargin: 350
            anchors.verticalCenter: parent.verticalCenter
            width: childrenRect.width
            height: childrenRect.height
            property bool opa: false

            onOpaChanged: {
                if(opa == true)
                {
                    idTimerForDisappear.stop();
                    toolTip.opacity = 1;
                }else
                {
                    idTimerForDisappear.start();
                }
            }

            Timer{
                id: idTimerForDisappear
                interval: 1000
                running: false;
                onTriggered: {
                    running = false;
                    toolTip.opacity = 0;
                }
            }

            Image {
                id: background
                width: 203
                height: 149
                source: imageInfo.imgFolderBt_phone + "bg_popup_quickscroll.png"

                Text{
                    anchors.fill: parent
                    text: container.showingText
                    font.pixelSize: 100
                    font.family: systemInfo.font_NewHDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colorInfo.brightGrey

                }

//                SectionScrollerLabel {
//                    id: previousSectionLabel

//                    objectName: "previousSectionLabel"
//                    text: internal.prevSection
//                    highlighted: internal.currentArea === text
//                    up: !internal.down
//                    anchors.horizontalCenter: internal.prevSection.length == 1 ? parent.horizontalCenter : undefined
//                    visible: false
//                }

//                SectionScrollerLabel {
//                    id: currentSectionLabel

//                    objectName: "currentSectionLabel"
//                    text: internal.currentSection
//                    highlighted: internal.currentArea === text
//                    up: !internal.down
//                    anchors.horizontalCenter: internal.currentSection.length == 1 ? parent.horizontalCenter : undefined
//                }

//                SectionScrollerLabel {
//                    id: nextSectionLabel

//                    objectName: "nextSectionLabel"
//                    text: internal.nextSection
//                    highlighted: internal.currentArea === text
//                    up: !internal.down
//                    anchors.horizontalCenter: internal.nextSection.length == 1 ? parent.horizontalCenter : undefined
//                    visible: false
//                }
            }

//            BorderImage {
//                id: background

//                width: childrenRect.width
//                height: childrenRect.height
//                anchors.left: parent.left
//                source: imageInfo.imgFolderMusic + "quickscroll_popup.png"
//                border { left: 10; top: 10; right: 10; bottom: 10 }

//                Column {
//                    width: Math.max(previousSectionLabel.text.length, currentSectionLabel.text.length, nextSectionLabel.text.length) == 1 ? 100 : internal.backgroundWidth()
//                    height: childrenRect.height

//                    SectionScrollerLabel {
//                        id: previousSectionLabel

//                        objectName: "previousSectionLabel"
//                        text: internal.prevSection
//                        highlighted: internal.currentArea === text
//                        up: !internal.down
//                        anchors.horizontalCenter: internal.prevSection.length == 1 ? parent.horizontalCenter : undefined
//                        visible: false
//                    }

//                    Image {
//                        objectName: "divider1"
//                        source: imageInfo.imgFolderMusic + "quickscroll_dot.png"
//                        sourceSize.width: 6/*40*/    // TODO: not aligned with the layout spec
//                        sourceSize.height: 6/*40*/   // TODO: not aligned with the layout spec
//                        width: 34/*parent.width - 2 * platformStyle.paddingLarge*/
//                        height: 29/*Math.round(platformStyle.graphicSizeTiny / 2) / 10*/
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        visible: false
//                    }

//                    SectionScrollerLabel {
//                        id: currentSectionLabel

//                        objectName: "currentSectionLabel"
//                        text: internal.currentSection
//                        highlighted: internal.currentArea === text
//                        up: !internal.down
//                        anchors.horizontalCenter: internal.currentSection.length == 1 ? parent.horizontalCenter : undefined
//                    }

//                    Image {
//                        objectName: "divider2"
//                        source: imageInfo.imgFolderMusic + "quickscroll_dot.png"/*privateStyle.imagePath("qtg_fr_popup_divider")*/
//                        sourceSize.width: 6/*40*/    // TODO: not aligned with the layout spec
//                        sourceSize.height: 6/*40*/   // TODO: not aligned with the layout spec
//                        width: 34/*parent.width - 2 * platformStyle.paddingLarge*/
//                        height: 29/*Math.round(platformStyle.graphicSizeTiny / 2) / 10*/
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        visible: false
//                    }

//                    SectionScrollerLabel {
//                        id: nextSectionLabel

//                        objectName: "nextSectionLabel"
//                        text: internal.nextSection
//                        highlighted: internal.currentArea === text
//                        up: !internal.down
//                        anchors.horizontalCenter: internal.nextSection.length == 1 ? parent.horizontalCenter : undefined
//                        visible: false
//                    }
//                }
//            }

//            states: [
//                State {
//                    name: "Visible"
//                    when: container.dragging
//                },

//                State {
//                    extend: "Visible"
//                    name: "AtTop"
//                    when: internal.currentPosition === "first"

//                    PropertyChanges {
//                        target: previousSectionLabel
//                        text: internal.currentSection
//                    }

//                    PropertyChanges {
//                        target: currentSectionLabel
//                        text: internal.nextSection
//                    }

//                    PropertyChanges {
//                        target: nextSectionLabel
//                        text: Sections.nextSection(internal.nextSection)
//                    }
//                },

//                State {
//                    extend: "Visible"
//                    name: "AtBottom"
//                    when: internal.currentPosition === "last"

//                    PropertyChanges {
//                        target: previousSectionLabel
//                        text: Sections.previousSection(internal.prevSection)
//                    }

//                    PropertyChanges {
//                        target: currentSectionLabel
//                        text: internal.prevSection
//                    }

//                    PropertyChanges {
//                        target: nextSectionLabel
//                        text: internal.currentSection
//                    }
//                }
//            ]

        }
    }

    Timer {
        id: dirtyTimer

        interval: 5000
        running: false

        onTriggered: {
            Sections.initSectionData(listViewForQuickScroll);
            internal.modelDirty = false;
        }
    }

    Connections {
        target: root.listViewForQuickScroll
        onCurrentSectionChanged: internal.currentArea == container.dragging ? internal.currentArea : ""
    }

    QtObject {
        id: internal

        property string prevSection: ""
        property string currentSection: listViewForQuickScroll.currentSection
        property string nextSection: ""
        property string currentArea: ""
        property string currentPosition: "first"
        property int oldY: 0
        property bool modelDirty: false
        property bool down: true
        property int dragAreaWidth: 35  // TODO: not aligned with the layout spec

        function backgroundWidth() {
            return 34/*Math.min(screen.width, screen.height) - 8 * platformStyle.paddingLarge*/
        }

        function initDirtyObserver() {
            Sections.initSectionData(listViewForQuickScroll);

            function dirtyObserver() {
                if (!internal.modelDirty) {
                    internal.modelDirty = true;
                    dirtyTimer.running = true;
                }
            }

            if (listViewForQuickScroll.model.countChanged)
                listViewForQuickScroll.model.countChanged.connect(dirtyObserver);

            if (listViewForQuickScroll.model.itemsChanged)
                listViewForQuickScroll.model.itemsChanged.connect(dirtyObserver);

            if (listViewForQuickScroll.model.itemsInserted)
                listViewForQuickScroll.model.itemsInserted.connect(dirtyObserver);

            if (listViewForQuickScroll.model.itemsMoved)
                listViewForQuickScroll.model.itemsMoved.connect(dirtyObserver);

            if (listViewForQuickScroll.model.itemsRemoved)
                listViewForQuickScroll.model.itemsRemoved.connect(dirtyObserver);
        }

        function adjustContentPosition(y) {
            if (y < 0 || y > dragArea.height) return;

            internal.down = y > internal.oldY;
//            var sect = Sections.closestSection(y/* / dragArea.height*/, internal.down);
            var sectPos = Sections.closestSection(y/* / dragArea.height*/, internal.down);
            internal.oldY = y;

            if(sectPos == '#' || sectPos == '+')
            {
                internal.currentSection = sectPos;
                internal.currentArea = sectPos;
                listViewForQuickScroll.positionViewAtIndex(0, listViewForQuickScroll.Beginning);
                listViewForQuickScroll.currentIndex = 0;
                return;
            }

            var sect;
            for(var nCnt = 0; nCnt < 24 ; nCnt++)  // a to z
            {
                if(Sections.verifyRelativeSection(String.fromCharCode(sectPos+nCnt)))
                {
                    sect = String.fromCharCode(sectPos+nCnt);
                    break;
                }
            }

            if(Sections.verifyRelativeSection(sect) == false)
                return;

            if (internal.currentArea != sect) {
                internal.currentArea = sect;
                internal.currentPosition = Sections.sectionPositionString(internal.currentArea);
                var relativeSection = Sections.relativeSections(internal.currentArea);
                internal.prevSection = relativeSection[0];
                internal.currentSection = relativeSection[1];
                internal.nextSection = relativeSection[2];
                var idx = Sections.indexOf(sect);
                listViewForQuickScroll.positionViewAtIndex(idx, listViewForQuickScroll.Beginning);
                listViewForQuickScroll.currentIndex = idx;
            }
        }
    }
}
