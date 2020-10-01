import Qt  4.7

Item
{
    id: root_text
    clip: true
    height: originText.height

    //property string text: ""
    property alias text: originText.text
    property string fontFamily: "NewHDB"
    property int fontSize : 40
    property string fontStyle : Text.Normal
    property color color: "#FAFAFA"
    property int scrollingTextMargin: 120
    property bool scrollingTicker: false
    property bool updateElide: true

    property bool marque: false
    property bool infinite : true

    signal marqueeNext();

    function restart(/*looping*/)
    {
        infinite ? scrollStartAni.loops = Animation.Infinite : scrollStartAni.loops = 1
        scrollingTicker = true;
        scrollStartAni.running = true
    }

    function stop()
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
        color: root_text.color
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
        color: root_text.color
        text: visible ? originText.text : ""
        visible: scrollStartAni.running
        font.family: fontFamily
    }

    SequentialAnimation
    {
        id: scrollStartAni
        running: false
        loops: infinite ? Animation.Infinite : 1
        PauseAnimation { duration: 1000 }       //modified by esjang 1sec wait for starting ticker.
        PropertyAnimation {
            target: originText
            property: "anchors.leftMargin"
            to: -(originText.paintedWidth + scrollingTextMargin)
            //moving 50px / sec
            duration: (originText.paintedWidth + 120)/50 * 1000 // modified by esjang 2013.10.01 for ITS #187769, change Ticker speed.
            
        }
        PauseAnimation { duration: 1500 }       //modified by esjang 1.5 sec wailt for ending ticker.
        PropertyAction { target: originText; property: "anchors.leftMargin"; value: 0 }

        onRunningChanged:{
            if(running === false){
                originText.anchors.leftMargin = 0
                marqueeNext();
            }
        }
    }


    Timer
    {
        id : tickerTimer
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

            //console.log("Animation onTriggered for :  " + scrollText.text +  " , running : " + scrollStartAni.running);
        }
    }
}
