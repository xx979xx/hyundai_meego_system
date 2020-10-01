import QtQuick 1.1
import "Components/BackButton"

DHAVN_AppSettings_FocusedItem
{
    id: titleBarMain
    anchors.top: parent.top
    anchors.left: parent.left

    default_x: 0
    default_y: 0

    property string titleText: ""

    Image{
        id: title_bg
        anchors.top: parent.top
        anchors.left: parent.left
        source: isVideoMode && (!isBrightEffectShow) ?
                    "/app/share/images/AppSettings/general/bg_media_title.png" : "/app/share/images/AppSettings/general/bg_title.png"

        Text{
            id: title_text
            width: 770
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 37
            //anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 464
            text: qsTranslate ("main", titleText) + LocTrigger.empty;
            //verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            //height: 73
            color: "#FAFAFA"
            font.pointSize: 40
            font.family: EngineListener.getFont(true)
            style: Text.Sunken
            clip: true
        }
    }

    DHAVN_AppSettings_BackButton{
        id: btn_back

        width:141; height: 73
        anchors.top: title_bg.top
        anchors.left: title_bg.left
        anchors.leftMargin: 3 // added for ITS 176083 Back Button x order

        focus_x: 0
        focus_y: 0

        onBackButtonByTouch:
        {
            root.backButtonHandler(0)
        }

        onBackButtonByJog:
        {
            if (rrc)
            {
                root.backButtonHandler(2)
            }
            else
            {
                root.backButtonHandler(1)
            }
        }
    }
}
