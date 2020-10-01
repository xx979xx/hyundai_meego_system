import Qt  4.7

Item
{
    id: root
    clip: true
    height: originText.height

    //property string text: ""
    property alias text: originText.text
    property string fontFamily: ""
    property int fontSize : 40
    property string fontStyle : Text.Normal
    property color color: "#FAFAFA"
    property int scrollingTextMargin: 120
    property bool scrollingTicker: false
    property bool updateElide: true
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
    property bool marque: false
    property bool infinite : true
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
    signal marqueeNext();

    function restart(/*looping*/)   //wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
    {
        infinite ? scrollStartAni.loops = Animation.Infinite : scrollStartAni.loops = 1
        scrollingTicker = true;
        scrollStartAni.running = true
    }

    function stop() //wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
    {
        scrollingTicker = false;
        updateElide = true
        scrollStartAni.running = false;
    }

    Text {
        id: originText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: fontSize
        color: root.color
        text: parent.text
        width: parent.width
        horizontalAlignment: Text.AlignLeft
        elide: !updateElide ? Text.ElideNone : (!scrollingTicker && (paintedWidth > width) ) ? Text.ElideRight : Text.ElideNone
        style: fontStyle

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
        visible: scrollStartAni.running
        font.family: fontFamily
    }

    SequentialAnimation
    {
        id: scrollStartAni
        running: false
        loops: infinite ? Animation.Infinite : 1
        PauseAnimation { duration: 1000 }   //wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
        PropertyAnimation {
            target: originText
            property: "anchors.leftMargin"
            to: -(originText.paintedWidth + scrollingTextMargin)
            duration: (originText.paintedWidth + 120)/50 * 1000 //wsuk.kim 131002 ITS_187769 Text scroll speed 50px/1sec.
        }
        PauseAnimation { duration: 1500 }    //wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
        PropertyAction { target: originText; property: "anchors.leftMargin"; value: 0 }

//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
        onRunningChanged:{
            if(running === false){
                originText.anchors.leftMargin = 0
                marqueeNext();
//wsuk.kim 131011 ITS_194664 Text scroll during searching by tune knob.
//                if(infinite && scrollingTicker)
//                {
//                    scrollStartAni.running = true
//                }
            }
        }
//wsuk.kim 130813 ITS_0182986 one by one text scroll on trackview
    }


    Timer
    {
        id : tickerTimer
        running: scrollingTicker
        interval: 1000
        triggeredOnStart: true
        onTriggered:
        {
            console.log("Animation onTriggered :  ");

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



//import QtQuick 1.1

//Item
//{
//    id: scrolledLabel
//    height: scrollText.height
//    clip: true

//    property bool scrollingTicker: false

//    property alias text: scrollText.text
//    property alias font: scrollText.font
//    property alias color: scrollText.color
//    //property alias fontSize: scrollText.font.pixelSize
//    property alias fontSize: scrollText.font.pointSize  //modified by aettie.ji 2012.11.28 for uxlaunch update
//    property alias fontFamily: scrollText.font.family

//    state: "left"
//    states: [
//        State {
//            name: "left"
//            AnchorChanges {
//                target: scrollText
//                anchors.left: scrolledLabel.left
//                anchors.right: undefined
//            }
//        },
//        State {
//            name: "right"
//            AnchorChanges {
//                target: scrollText
//                anchors.right: (scrollText.width > scrolledLabel.width) ? scrolledLabel.right : undefined
//                anchors.left: (scrollText.width > scrolledLabel.width) ? undefined : anchors.left
//            }
//        }
//    ]

//    transitions: Transition {
//        ParallelAnimation {
//            AnchorAnimation
//            {
//                targets:scrollText
//                duration: scrollingTicker * Math.floor( Math.abs(scrollText.width - scrolledLabel.width) * 10) //modified by aettie.ji ISV_KR 83143
//            }
//        }
//    }

//    Timer {
//        id: scroll_timer
//        repeat: true
//        running: scrollingTicker && (scrollText.width > scrolledLabel.width)
//        interval: Math.floor( 2500 + Math.abs(scrollText.width - scrolledLabel.width) * 10) //modified by aettie.ji ISV_KR 83143
//        onRunningChanged:
//        {
//            if(!running) {
//                scrolledLabel.state = "left"
//            }
//        }

//        triggeredOnStart: true
//        onTriggered: {
//            if(scrolledLabel.state === "left")
//            {
//                scrolledLabel.state = "right"
//            }
//            else
//            {
//                scrolledLabel.state = "left"
//            }
//        }
//    }

//    Text
//    {
//        id: scrollText
//        visible: true
//        width: scrollingTicker ? implicitWidth : parent.width
//        elide: scrollingTicker ? Text.ElideNone : Text.ElideRight
//        anchors.verticalCenter: parent.verticalCenter
//        horizontalAlignment: Text.AlignLeft // added by Dmitry 08.05.13
//    }
//}
