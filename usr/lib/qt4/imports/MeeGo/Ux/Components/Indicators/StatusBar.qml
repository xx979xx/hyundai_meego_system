import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Ux.Gestures 0.1

/*!
  \qmlclass StatusBar
  \title StatusBar
  \section1 StatusBar

  \section2 API properties
      \qmlproperty bool active
      \qmlcm indicates if the statusbar is active or not.

      \qmlproperty bool showClock
      \qmlcm the top most item's width.

      \qmlproperty int hintHeight
      \qmlcm the desired Height of the statusbar.

      \qmlproperty bool triggered
      \qmlcm true if a pan or a tab

  \section2 Signals
  \qmlfn panned
  \qmlcm is sent when the GestureArea was panned.

  \qmlfn tapAndHolded
  \qmlfn is sent when the GestureArea was holded.

  \section2 Signals
  \qmlfn show()
  \qmlcm triggers a show of the

  \qmlfn tapAndHolded
  \qmlfn is sent when the GestureArea was holded.

  \section2 Example
  \qml
        // used in Window.qml only
  \endqml
*/

Item {
    id: container
    property variant networkIndicator: null
    property variant clockIndicator: null
    property variant batteryIndicator: null
    property bool active: true
    property alias backgroundOpacity: background.opacity
    property bool showClock: true
    property int hintHeight: 30
    property bool triggered: false

    signal panned()
    signal tapAndHolded()

    function hide()
    {
        //nop in this implementation
    }

    function show()
    {
        //nop in this implementation
    }
    Behavior on y {
        PropertyAnimation {
            duration: theme.dialogAnimationDuration
            easing.type: "OutSine"
        }
    }

    Behavior on height {
        PropertyAnimation {
            duration: theme.dialogAnimationDuration
            easing.type: "OutSine"
        }
    }

    Item {
        id: privateData
        property variant notifyBanner: null
    }

    function showBanner(message) {
        if (privateData.notifyBanner) {
            return;
        }

        privateData.notifyBanner = notifyComponent.createObject(container);
        privateData.notifyBanner.text = message;
    }

    Theme {
        id: theme
    }

    Component {
        id: notifyComponent
        Rectangle {
            id: notifyInstance
            x: 0
            y: -height
            Behavior on y {
                PropertyAnimation { duration: 200; }
            }
            onYChanged: {
                if (y == -height)
                    notifyInstance.destroy();
            }

            width: container.width
            height: container.height
            color: theme.statusBarBackgroundColor

            Component.onCompleted: y = 0

            property alias text: notifyText.text
            Text {
                id: notifyText
                anchors.fill: parent
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: theme.statusBarFontPixelSize
                elide: Text.ElideRight
                color: theme.statusBarFontColor
            }
            Timer {
                id: notifyTimer
                running: true
                interval: 3000
                onTriggered: notifyInstance.y = -notifyInstance.height
            }
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: theme.statusBarBackgroundColor
        opacity: theme.statusBarOpacity
    }
    Row {
        anchors.left: parent.left
        NetworkIndicator {
            active: container.active
        }
        BluetoothIndicator {
            hideOnActiveNetwork: true
            active: container.active
        }
    }
    Text {
        anchors.centerIn: parent
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: theme.statusBarFontPixelSize
        color:  theme.statusBarFontColor
        opacity: container.showClock ? 1.0 : 0.0
        LocalTime {
            id: localTime
            interval: active ? 60000 : 0
        }
        text: localTime.shortTime
    }
    Image {
        anchors.centerIn: parent
        opacity: container.showClock ? 0.0 : 1.0
        source:  "image://themedimage/icons/statusbar/locked"
    }

    NotificationIndicator {
        id: notificationIndicator
        anchors.right: volumeIndicator.left
        active: container.active
        onNotify: {
            var msg = qsTr("%1: %2").arg(summary).arg(body)
            showBanner(msg.replace(/\n/g, ' '));
        }
    }
    Image {
        id:musicPlayingIcon
        anchors.right: notificationIndicator.left
        source: "image://themedimage/icons/actionbar/media-play"
        height: volumeIndicator.paintedHeight
        width: volumeIndicator.paintedWidth
        visible: musicIndicator.state == "playing"
    }
    MusicIndicator {
        id: musicIndicator
        onStateChanged: {
            musicPlayingIcon.visible = state == "playing" ? 1 : 0;
        }
    }

    Image {
        id: volumeIndicator
        anchors.right: batteryIndicator.left
        source: "image://themedimage/icons/statusbar/volume-muted"

        property variant controller: null
        property bool active: container.active

        function updateVolumeGraphic() {
            if (controller.mute)
            {
                source = "image://themedimage/icons/statusbar/volume-muted";
            }
            else
            {
                if (controller.volume > 66)
                {
                    source = "image://themedimage/icons/statusbar/volume-high";
                }
                else if (controller.volume > 33)
                {
                    source = "image://themedimage/icons/statusbar/volume-medium";
                }
                else
                {
                    source = "image://themedimage/icons/statusbar/volume-low";
                }
            }
        }

        onActiveChanged: {
            if (active)
            {
                controller = volumeControlComponent.createObject(volumeIndicator);
                updateVolumeGraphic();
            }
            else
            {
                controller.destroy();
            }
        }

        Component {
            id: volumeControlComponent
            VolumeControl {
                onMute: {
                    volumeIndicator.updateVolumeGraphic();
                }
                onVolumeChanged: {
                    volumeIndicator.updateVolumeGraphic();
                }
            }
        }
    }

    BatteryIndicator {
        id: batteryIndicator
        anchors.right: parent.right
        active: container.active
    }

    GestureArea {
        id: gestureArea
        anchors.fill: parent

        TapAndHold {
            onFinished: {
                container.triggered = true
                tapAndHolded();
            }
        }

        Pan {
            onStarted: {

            }
            onUpdated: {
                if( gesture.offset.y  > 10 && !container.triggered ) {
                    mainWindow.triggerSystemUIMenu();
                    container.triggered = true;
                    panned();
                }
            }
            onCanceled: {
                container.triggered = false
            }
            onFinished: {
                container.triggered = false
            }

        }
    }

}
