import QtQuick 1.0
import "DRSPopUp.js" as DRSPopUp

Item
{
    id: container
    width: 1280
    height: 720
    signal buttonClicked(int buttonId)
    signal stateChanged(string state)
    property string state: DRSPopUp.const_STATE_STOP

    Image
    {
       id: image_bg
       source: DRSPopUp.const_BG
       anchors{ left: parent.left; leftMargin: 0; top: parent.top; topMargin: 0 }
    }

    Image
    {
       id: image_block_icon
       source: DRSPopUp.const_BLOCK_ICON
       anchors{ left: parent.left; leftMargin: 562; top: parent.top; topMargin: 96 }
    }

    Text
    {
       id: item_text_one;
       width:DRSPopUp.const_APP_IBOX_DRS_POPUP_TEXT_WIDTH
       horizontalAlignment: Text.AlignHCenter

       anchors{ left: parent.left; leftMargin: 100; top: parent.top; topMargin: 258; horizontalCenter: parent.horizontalCenter }

       text: qsTranslate("main", QT_TR_NOOP("STR_APP_DRS_MESSAGE")) + LocTrigger.empty
       color: DRSPopUp.const_COLOR_TEXT_BRIGHT_GREY
       font.pixelSize: DRSPopUp.const_APP_IBOX_FONT_SIZE_TEXT_32PT
       font.family: "DH_HDB"
    }

    PlayerController
    {
        id: playercontroller1
        x: 471
        y: 367
        width: 354
        height: 163
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        state: container.state
        onClicked:
        {
            container.buttonClicked(buttonId);
        }
        onStateChanged:
        {
            container.stateChanged(state)
        }
    }

    ImageTextButton
    {
        id: button_list
        x: 1041
        y: 0
        width: 121
        height: 73
        img_n: DRSPopUp.const_LIST_BUTTON_N
        img_p: DRSPopUp.const_LIST_BUTTON_P
        text: "LIST"
        onClicked:
        {
            container.buttonClicked( DRSPopUp.const_BUTTON_LIST )
        }
    }

    ImageButton
    {
        id: button_back
        x: 1162
        y: 0
        width: 121
        height: 73
        img_n: DRSPopUp.const_BACK_BUTTON_N
        img_p: DRSPopUp.const_BACK_BUTTON_P
        onClicked:
        {
            container.buttonClicked( DRSPopUp.const_BUTTON_BACK )
        }
    }

    /*
    Connections
    {
        target: UIListener

        onRetranslateUi:
        {
           LocTrigger.retrigger()
           item_text_one.text = qsTranslate("main", QT_TR_NOOP("STR_APP_DRS_MESSAGE")) + LocTrigger.empty
        }
    }
    */
}
