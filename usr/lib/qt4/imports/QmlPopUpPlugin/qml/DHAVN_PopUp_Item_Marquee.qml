import QtQuick 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES
Item {
    id:scrolling_rect
    clip:true

    property string text
    property int padding
    property int fontSize
    property string fontFamily
    property int interval : 100
    property color textColor
    property bool scrolling
    property int icon_offset
    property int hAlign
    anchors.fill: parent
//    anchors.verticalCenter: parent.verticalCenter

//    Rectangle{
//        width:scrolling_rect.width
//        height:scrolling_rect.height
//        color: "transparent"
    Text {
        id:marqueeText
        font.pointSize: CONST.const_TEXT_LIST_PT
        font.family: CONST.const_TEXT_FONT_FAMILY
        color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
        text: scrolling_rect.text
        visible:true
//        elide: Text.ElideRight

        anchors.top: parent.top
        horizontalAlignment: hAlign //Text.AlignHCenter
    }
//}

    SequentialAnimation{
        id:ticker_scroll
        NumberAnimation {
            target: marqueeText
            properties: "x"
            from: marqueeText.x
            to: marqueeText.x - (marqueeText.width - scrolling_rect.width)
            duration: 5000
        }
        NumberAnimation{
            target: marqueeText
            properties: "x"
            from: marqueeText.x - (marqueeText.width - scrolling_rect.width)
            to: marqueeText.x
            duration: 5000
        }
        loops: Animation.Infinite
        running:true
}

    states: [
        State
        {
            name: "Scroll"; when: ( scrolling == true &&  marqueeText.width > scrolling_rect.width )
            PropertyChanges { target: ticker_scroll; running: true }
        },
       State
        {
            name: "noScroll"; when: ( scrolling == true && marqueeText.width <= scrolling_rect.width)
            PropertyChanges { target: ticker_scroll; running: false }
            PropertyChanges { target: marqueeText; x: (scrolling_rect.width/2) - (marqueeText.width/2)  }
        },
        State
         {
             name: "Elide"; when: ( scrolling == false && marqueeText.width > scrolling_rect.width)
             PropertyChanges { target: ticker_scroll; running: false }
             PropertyChanges { target: marqueeText; x: 0 }
             PropertyChanges { target: marqueeText; width:parent.width }
             PropertyChanges { target: marqueeText; elide:Text.ElideRight }
         },
         State
          {
              name: "noElide"; when: ( scrolling == false && marqueeText.width <= scrolling_rect.width)
              PropertyChanges { target: ticker_scroll; running: false }
              PropertyChanges { target: marqueeText; x: (scrolling_rect.width/2) - (marqueeText.width/2)  }
          }
    ]

}
