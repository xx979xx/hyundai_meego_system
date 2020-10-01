import QtQuick 1.0

Item
{
    id: marqueeText
    height: scrollText.height
    clip: true

    property alias text: scrollText.text
    property alias font: scrollText.font
    property alias color: scrollText.color
    property alias fontSize: scrollText.font.pointSize
    property string fontFamily: popUpBase.getFont()
    property alias style: scrollText.style
    property alias styleColor: scrollText.styleColor
    property alias enableMarquee: marqueeTimer.running
    Connections
    {
       target: UIListener
       onRetranslateUi:{
           fontFamily = popUpBase.getFont(languageId);
           LocTrigger.retrigger();
       }
    }
    Text
    {
        id:scrollText
        verticalAlignment: Text.AlignVCenter
        font.family: fontFamily

        onTextChanged:
        {
            scrollText.x = 0;

            if(enableMarquee)
                marqueeTimer.restart()
            else
                marqueeTimer.stop()
        }
    }

    Timer {
        id: marqueeTimer
        interval: 1
        onTriggered:
        {
            //if(scrollText.x + scrollText.width < 0)
            if(scrollText.x == (scrollText.parent.width-scrollText.width))
            {
                //scrollText.x = 0// scrollText.parent.width;
                marqueeTimer.stop()
                marqueeTimer_reverse.restart()
            }
            scrollText.x -= 1;
        }
        repeat: true
    }
    Timer {
        id: marqueeTimer_reverse
        interval: 1
        onTriggered:
        {
            //if(scrollText.x + scrollText.width < 0)
            if(scrollText.x == 0)
            {
                //scrollText.x = 0// scrollText.parent.width;
                marqueeTimer_reverse.stop()
                marqueeTimer.restart()
            }
            scrollText.x += 1;
        }
        repeat: true
    }
}
