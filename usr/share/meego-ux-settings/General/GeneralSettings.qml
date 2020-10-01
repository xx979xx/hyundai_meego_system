import Qt 4.7
import MeeGo.Components 0.1 as MeeGo
import MeeGo.Settings 0.1

MeeGo.AppPage {
    id: page
    pageTitle: qsTr("General")

    MeeGo.VolumeControl {
        id: volumeControl
    }

    Flickable {
        anchors.fill:  parent
        contentHeight: childrenRect.height
        interactive: true
        clip: true

        Column {
            width:  parent.width

            MeeGo.ExpandingBox {
                id: timedateexpandingbox
                property int containerHeight: 80
                height: containerHeight
                anchors.margins: 20
                anchors.left: parent.left
                anchors.right: parent.right

                detailsComponent: TimeDateSettings { }

                Text {
                    text: qsTr ("Time and Date")
                    height: timedateexpandingbox.containerHeight
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MeeGo.ExpandingBox {
                id: volumeexpandingbox
                property int containerHeight: 80
                height: containerHeight

                anchors.margins: 20
                anchors.left: parent.left
                anchors.right: parent.right

                Text {
                    text: qsTr ("Sound")
                    height: volumeexpandingbox.containerHeight
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    // %1 is volume level percentage
                    text: qsTr("%1%").arg(volumeControl.volume)
                    height: volumeexpandingbox.containerHeight
                    anchors.right: parent.right
                    anchors.rightMargin: 40
                    verticalAlignment: Text.AlignVCenter
                }

                detailsComponent: VolumeSettings { }
            }

            MeeGo.ExpandingBox {
                id: backlightexpandingbox
                property int containerHeight: 80
                height: containerHeight

                anchors.margins: 20
                anchors.left: parent.left
                anchors.right: parent.right

                Text {
                    text: qsTr ("Backlight Control")
                    height: backlightexpandingbox.containerHeight
                    verticalAlignment: Text.AlignVCenter
                }

                detailsComponent: BacklightSettings { }
            }

            MeeGo.ExpandingBox {
                id: screensaverexpandingbox
                property int containerHeight: 80
                height: containerHeight

                anchors.margins: 20
                anchors.left: parent.left
                anchors.right: parent.right

                Text {
                    text: qsTr ("Screen Saver")
                    height: screensaverexpandingbox.containerHeight
                    verticalAlignment: Text.AlignVCenter
                }

                detailsComponent: ScreensaverSettings { }
            }
        }
    }
}
