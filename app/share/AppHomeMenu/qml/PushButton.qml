import QtQuick 1.1

Item {
    id:container1

    signal pressed()
    signal clicked()
    signal released()

    property bool isDisalbe: false
    property string image_path_normal
    property string image_path_press
    property string image_path_focus
    property string image_path_disable
    property string name
    property color  brighrGray: "#fafafa"

    property int btnID

    property bool imageMirror: false

    function setPressed()
    {
        image_press.visible = true
    }

    function setReleased()
    {
        image_press.visible = false
    }

    function setFocused(bEnable)
    {
        image_focus.visible = bEnable
    }


    Image {
        id: image_normal
        source: isDisalbe ? image_path_disable : image_path_normal

        mirror: imageMirror

        MouseArea {
            anchors.fill: parent
            beepEnabled: false

            onPressed: {
                image_press.visible = true
                container1.pressed()
            }

            onExited: image_press.visible = false

            onReleased: {
                if (image_press.visible)
                {
                    EngineListener.playBeep()
                    container1.clicked();
                    image_press.visible = false
                }
                else
                {
                    container1.released()
                }
            }


        }
    }

    Image {
        id: image_focus

        visible: false
        source: image_path_focus
        mirror: imageMirror
    }

    Image {
        id: image_press

        visible: false
        source: image_path_press
        mirror: imageMirror
    }

    Text {
        id: btnName

        width: image_normal.width
        height: image_normal.height

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.family: EngineListener.getFont() //"HDB"
        font.pointSize: 30

        color: brighrGray

        text: container1.name
    }
}

