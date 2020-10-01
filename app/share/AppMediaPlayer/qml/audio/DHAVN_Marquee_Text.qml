import QtQuick 1.1

Item
{
    id: root
    clip: true
    height: originText.height

    //property string text: ""
    property alias text: originText.text
    property string fontFamily: ""
    property int fontSize : 40
    property int fontStyle : Text.Normal
    property color color: "#FAFAFA"
    property int scrollingTextMargin: 120
    property bool scrollingTicker: false
    property bool updateElide: true
    property bool leftAlide: EngineListenerMain.middleEast
    property int    paintedWidth: 0 //added by junam 2013.11.27 for ITS_ME_211327

    Text {
        id: originText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: fontSize
        color: root.color
        text: parent.text
        width: parent.width
        horizontalAlignment: Text.AlignLeft
	// modified by ravikanth for ITS 0189163

        //{ changed by junam 2013.11.27 for ITS_ME_211327
        //elide: !updateElide ? ( leftAlide ? Text.ElideLeft : Text.ElideNone ) : ( (!scrollingTicker && (paintedWidth > width) )
        //                                     ? ( leftAlide ?  Text.ElideLeft : Text.ElideRight)
        //                                     : Text.ElideNone )
        elide: !updateElide ? ( leftAlide ? Text.ElideLeft : Text.ElideNone ) : ( (!scrollingTicker && (root.paintedWidth > width) )
                                                                                 ? ( leftAlide ?  Text.ElideLeft : Text.ElideRight)
                                                                                 : Text.ElideNone )
        //}changed by junam

        style: fontStyle

	// modified by ravikanth for ITS 0187237
        onWidthChanged:
        {
            if(paintedWidth <= width)
            {
                updateElide = false
                updateElide = true

                scrollStartAni.running = false
                originText.anchors.leftMargin = 0
            }
        }

        onElideChanged:
        {
            if(scrollingTicker)
            {
                if(originText.elide == Text.ElideNone)
                {
                    scrollStartAni.running = true
                }
            }
            else
            {
                scrollStartAni.running = false
                originText.anchors.leftMargin = 0
            }
        }

        onTextChanged:
        {
            root.paintedWidth = EngineListener.getStringWidth(originText.text, originText.font.family, originText.font.pointSize); //added by junam 2013.11.27 for ITS_ME_211327
           
            scrollStartAni.running = false
            originText.anchors.leftMargin = 0

            updateElide = false
            updateElide = true

            if(scrollingTicker && (originText.elide == Text.ElideNone) && (paintedWidth > width) )
            {
                scrollStartAni.running = true
            }
            else
            {
                scrollStartAni.running = false
                originText.anchors.rightMargin = 0
            }
        }

        font.family: fontFamily
    }

    Text {
        id: scrollText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: originText.left
        anchors.leftMargin: originText.paintedWidth + scrollingTextMargin
        font.pointSize: fontSize
        color: root.color
        text: visible ? originText.text : ""
        visible: scrollingTicker && scrollStartAni.running
        font.family: fontFamily
    }

    SequentialAnimation
    {
        id: scrollStartAni
        running: false
        loops: Animation.Infinite
        PauseAnimation { duration: 1000 }  //changed by junam 2013.10.15 from 2500
        PropertyAnimation {
            target: originText
            property: "anchors.leftMargin"
            to: -(originText.paintedWidth + scrollingTextMargin)
            //{changed by junam 2013.08.16 for moving 50px / sec
            //duration: (originText.paintedWidth + 120)/100 * 1000
            duration: (originText.paintedWidth + 120)/50 * 1000
            //}changed by junam
        }
        PauseAnimation { duration: 1500 } //changed by junam 2013.10.15 from 100
        PropertyAction { target: originText; property: "anchors.leftMargin"; value: 0 }
    }


    Timer
    {
        running: scrollingTicker
        interval: 1000
        triggeredOnStart: true
        onTriggered:
        {
            if(scrollingTicker && (originText.elide == Text.ElideNone) && (originText.paintedWidth > width) )
            {
                scrollStartAni.running = true
            }
            else
            {
                scrollStartAni.running = false
                originText.anchors.rightMargin = 0
            }
        }
    }
}
//}changed by junam
