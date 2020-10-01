import QtQuick 1.0
import "DRSPopUp.js" as DRSPopUp

Item
{
    id: container
    width: 354
    height: 163
    state: DRSPopUp.const_STATE_STOP
    signal clicked(int buttonId)

    ImageButton
    {
        id: imagebutton_prev
        x: 0
        y: 46
        width: 90
        height: 81
        img_n: DRSPopUp.const_REW_BUTTON_N
        img_p: DRSPopUp.const_REW_BUTTON_P
        anchors.verticalCenterOffset: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        onClicked:
        {
            container.clicked(DRSPopUp.const_BUTTON_PREV);
        }
    }

    ImageButton
    {
        id: imagebutton_play
        x: 104
        y: 0
        width: 132
        height: 163
        img_n: DRSPopUp.const_PLAY_BG_N
        img_p: DRSPopUp.const_PLAY_BG_P
        anchors.verticalCenterOffset: 0
        anchors.horizontalCenterOffset: 0
        anchors.centerIn: parent
        onClicked:
        {
            if (container.state == DRSPopUp.const_STATE_STOP)
            {
               container.state = DRSPopUp.const_STATE_PLAY;
               container.clicked( DRSPopUp.const_BUTTON_PLAY );
            }
            else
            {
               container.state = DRSPopUp.const_STATE_STOP;
               container.clicked( DRSPopUp.const_BUTTON_STOP );
            }
        }

        onButtonStateChanged:
        {
           if ( container.state == DRSPopUp.const_STATE_STOP )
           {
              if ( pressed )
              {
                 image_play.source = DRSPopUp.const_PLAY_BUTTON_P
              }
              else
              {
                 image_play.source = DRSPopUp.const_PLAY_BUTTON_N
              }
           }
           else
           {
              if ( pressed )
              {
                 image_play.source = DRSPopUp.const_PAUSE_BUTTON_N
              }
              else
              {
                 image_play.source = DRSPopUp.const_PAUSE_BUTTON_P
              }
           }
        }

        Image
        {
            id: image_play
            width: 132
            height: 163
            anchors.leftMargin: 0
            anchors.topMargin: 0
            source: DRSPopUp.const_PLAY_BUTTON_N
        }
    }

    ImageButton
    {
        id: imagebutton_next
        x: 250
        y: 46
        width: 90
        height: 81
        img_n: DRSPopUp.const_FOR_BUTTON_N
        img_p: DRSPopUp.const_FOR_BUTTON_P
        onClicked:
        {
            container.clicked(DRSPopUp.const_BUTTON_NEXT);
        }
    }

    Connections
    {
       target: ViewWidgetController

       onSetDeckStatus:
       {
          if ( deckStatus == 0x0 )
          {
             container.state = DRSPopUp.const_STATE_PLAY;
          }
          else if ( deckStatus == 0x2 )
          {
             container.state = DRSPopUp.const_STATE_STOP;
          }
       }
    }

    states: [
        State
        {
            name: DRSPopUp.const_STATE_STOP
            PropertyChanges
            {
                target: image_play

                width: 132
                height: 163
                anchors.centerIn: imagebutton_play
                source: DRSPopUp.const_PLAY_BUTTON_N
            }
        },
        State
        {
            name: DRSPopUp.const_STATE_PLAY
            PropertyChanges
            {
                target: image_play

                width: 76
                height: 74
                anchors.centerIn: imagebutton_play
                source: DRSPopUp.const_PAUSE_BUTTON_N
            }
        }
    ]

}
