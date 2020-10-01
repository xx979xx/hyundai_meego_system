import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: container

    property alias mainTitleText : titleText.text
    property alias buttonText : button.text
    property alias firstHelpTitle : firstTitle.text
    property alias secondHelpTitle : secondTitle.text
    property alias firstHelpText : firstText.text
    property alias secondHelpText : secondText.text
    property alias firstImageSource : firstImage.source
    property alias secondImageSource : secondImage.source
    property alias helpContentVisible : helpContent.visible

    signal buttonClicked()

    Column {
        id: titlePart
        width: parent.width
        height: topLine.height + row.height + bottomLine.height + 60
        spacing: 15
        Rectangle {
            id: topLine
            color: "black"
            width: parent.width
            height: 1
        }

        Item {
            id: row
            width: parent.width
            height: Math.max(titleText.paintedHeight, button.height)
            Text {
                id: titleText
                anchors.left: parent.left
                anchors.margins: 30
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 25
                font.bold: true
            }
            Button {
                id: button

                anchors.right: parent.right
                anchors.rightMargin: 30

                onClicked: {
                    container.buttonClicked();
                }
            }
        }

        Rectangle {
            id: bottomLine
            color: "black"
            width: parent.width
            height: 1
        }
    }

    Row {
        id: helpContent
        x: 30
        anchors.top: titlePart.bottom
        spacing: 50
        Column {
            spacing: 10
            Rectangle {
                width: blankStateScreen.width / 3.5
                height: blankStateScreen.height / 3

                border.color: "gray"

                Image {
                    id: firstImage
                    anchors.fill: parent
                }
            }

            Text {
                id: firstTitle
                font.pixelSize: theme_fontPixelSizeLarge
            }

            Text {
               id: firstText
               width: blankStateScreen.width / 3.7
               font.pixelSize: theme_fontPixelSizeSmall
               wrapMode: Text.WordWrap
            }
        }

        Column {
            spacing: 10
            Rectangle {
                width: blankStateScreen.width / 3.5
                height: blankStateScreen.height / 3

                border.color: "gray"

                Image {
                    id: secondImage
                    anchors.fill: parent
                }
            }

            Text {
                id: secondTitle
                font.pixelSize: theme_fontPixelSizeLarge
            }

            Text {
               id: secondText
               width: blankStateScreen.width / 3.7
               font.pixelSize: theme_fontPixelSizeSmall
               wrapMode: Text.WordWrap
            }
        }
    }
}
