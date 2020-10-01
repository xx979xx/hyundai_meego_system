/**
 * FileName: MScrollText.qml
 * Author: blacktip
 * Time: 2012-02-03 11:20
 *
 * - 2012-08-21 Created by blacktip
 * - 2012-08-22 Modified elide by HYANG
 */

import Qt 4.7

Item{
    id: marqueeBox
    clip: true

    property bool scrollEnable: true
    property bool onewayMode: true
    property bool isLeftSide: true

    property string text: ""                            // marqueeText.text
    property string fontfamily: ""                      // marqueeText.font.family

    property int fontpixelSize: 36                      // marqueeText.font.pixelSize
    property int horizontalAlignment: Text.AligLeft     // marqueeText.horizontalAlignment
    property int verticalAlignment: Text.AlignVCenter   // marqueeText.verticalAlignment
    property int elide: Text.ElideRight
    property int interval: 20
    property int lastWidth: 0                           // for performance
    property int breakInterval: 1000

    property color textColor: colorInfo.brightGrey      // marqueeText.color

    function moveMarquee()
    {
        if(marqueeBox.onewayMode == true)
        {
            if(marqueeText.x + marqueeText.width < 0)
            {
                marqueeText.x = marqueeText.parent.width;
            }
            marqueeText.x -= 5;
        }
        else
        {
            if(marqueeBox.isLeftSide)
                marqueeText.x -= 5;
            else
                marqueeText.x += 5;

            if(marqueeText.x + marqueeText.width < marqueeText.parent.width)
            {
                marqueeBox.isLeftSide = false;
                marqueeTimer.running = false;
                breakTimer.running = true;
            }
            else if(marqueeText.x > 0)
            {
                marqueeBox.isLeftSide = true;
                marqueeTimer.running = false;
                breakTimer.running = true;
            }
        }
    }

    function onTextChange()
    {
        if(marqueeText.paintedWidth != lastWidth && marqueeBox.scrollEnable == true && marqueeBox.parent.visible == true)   // for performance
        {
            marqueeBox.lastWidth = marqueeText.paintedWidth;
            if(marqueeText.paintedWidth < marqueeBox.width)
            {
                marqueeTimer.running = false;
                marqueeText.width = marqueeBox.width;
                marqueeText.x = 0;
            }
            else
            {
                marqueeTimer.running = true;
                marqueeText.width = marqueeText.paintedWidth;
            }
        }
        else
        {
            marqueeTimer.running = false;
            marqueeText.width = marqueeBox.width;
            marqueeText.x = 0;
            marqueeBox.lastWidth = 0;
        }
    }

    Text{
        id: marqueeText
        x: 0;y:0;
        height: parent.height
        text: parent.text
        font.family: marqueeBox.fontfamily
        font.pixelSize: marqueeBox.fontpixelSize
        color: marqueeBox.textColor
        horizontalAlignment: marqueeBox.horizontalAlignment
        verticalAlignment: marqueeBox.verticalAlignment
        wrapMode: marqueeBox.scrollEnable == true ? Text.NoWrap : Text.WordWrap
        elide: marqueeBox.scrollEnable == true ? Text.ElideNone : marqueeBox.elide
        onPaintedSizeChanged: {
            if(marqueeText.text.length > 0)
                onTextChange()
        }
    }

    Timer {
        id: marqueeTimer
        interval: marqueeBox.interval
        onTriggered: moveMarquee()
        running: false
        repeat: true
        triggeredOnStart: true
    }

    Timer {
        id: breakTimer
        interval: breakInterval
        onTriggered: {
            marqueeTimer.running = true;
        }
        running: false
        repeat: false
        triggeredOnStart: false
    }

    onScrollEnableChanged: {
        onTextChange();
    }

    onVisibleChanged: {
        onTextChange();
    }
}
