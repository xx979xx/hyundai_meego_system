import Qt 4.7

import com.engineer.data 1.0


import "../Component" as MComp
import "../System" as MSystem






Row {
    id: blank
    height: 110
    spacing: 7

    property alias button1 : item1.item
    property alias button2 : item2.item
    property alias button3 : item3.item
    property alias button4 : item4.item

    property alias focus1: item1.focus
    property alias focus2: item2.focus
    property alias focus3: item3.focus
    property alias focus4: item4.focus

    property int current : 0

    signal buttonClick(variant num)

    Component {
        id: password
        FocusScope {
            id: items
            MSystem.ImageInfo { id: imageInfo }
            property string imgFolderSettings : imageInfo.imgFolderSettings
            property string textItem: ""
            //property bool focusItem: false//focus
            focus: true //focusItem

            states: [
                State {
                    name: "nocursor"
                    PropertyChanges { target: aniPassword; visible:false; }
                },
                State {
                    name: "cursor1"
                    PropertyChanges { target: aniPassword; x : 13; }
                },
                State {
                    name: "cursor2"
                    PropertyChanges { target: aniPassword; x : (138-26)/3+13; }
                },
                State {
                    name: "cursor3"
                    PropertyChanges { target: aniPassword; x : (138-26)/3*2+13; }
                }
            ]

            Image {
                id: aniPassword
                x: 13 ; y: 15
                source: imgFolderSettings + "cursor_password.png"
                visible: parent.activeFocus? true:false

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    PropertyAnimation { to: 0; duration: 500; easing.type: Easing.InExpo }
                    PropertyAnimation { to: 1; duration: 500; easing.type: Easing.InExpo }
                }
            }

            Text {
                id: txtPassword
                x:28; y:14
                //x:13;//width:100
                text: textItem
                color: colorInfo.black; //selectionColor: "green"
                font.pixelSize: 50;
                font.family: UIListener.getFont(false) //"HDR"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    switch( text.length )
                    {
                    case 0:
                        parent.state = "cursor1"
                        break;
                    case 1:
                        parent.state = "cursor2"
                        break;
                    case 2:
                        parent.state = "cursor3"
                        break;
                    case 3:
                        parent.state = "nocursor";
                        break;
                    default:
                        parent.state = "nocursor"
                        break;
                    }
                }
            }
        }
    }

    onVisibleChanged: {
        if( visible == false )
        {
            //console.log("HiHi")
            item1.source = ""
            item2.source = ""
            item3.source = ""
            item4.source = ""
        }
    }

    Rectangle {
        width: 138; height: 81
        color: colorInfo.transparent

        BorderImage {
            anchors.fill: parent
            source: imgFolderSettings + "bg_password_4.png"
            border.left: 25;
        }
        Loader {
            id: item1
            sourceComponent: password
            focus: true

            anchors.fill: parent
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.focus = true
                }
            }
        }

        Connections {
            target: button1
            onTextItemChanged: {
                if( button1.textItem.length == 3 )
                {
                    item2.focus = true
                }
            }
        }
    } // End Rectangle
    Rectangle {
        width: 138; height: 81
        color: colorInfo.transparent

        BorderImage {
            anchors.fill: parent
            source: imgFolderSettings+"bg_password_4.png"
            border.left: 25;
        }
        Loader {
            id: item2
            sourceComponent: password
            focus: true

//            onLoaded: focus = true

            anchors.fill: parent

            MouseArea {
                anchors.fill: parent
                onClicked: parent.focus = true
            }
        }

        Connections {
            target: button2
            onTextItemChanged: {
                if( button2.textItem.length == 3 )
                {
                    item3.focus = true
                }
            }
        }
    } // End Rectangle
    Rectangle {
        width: 138; height: 81
        color: colorInfo.transparent

        BorderImage {
            source: imgFolderSettings+"bg_password_4.png"
            border.left: 25;
        }
        Loader {
            id: item3
            sourceComponent: password

//            onLoaded: focus = true

            anchors.fill: parent
            focus: true

            MouseArea {
                anchors.fill: parent
                onClicked: parent.focus = true
            }
        }

        Connections {
            target: button3
            onTextItemChanged: {
                if( button3.textItem.length == 3 )
                {
                    item4.focus = true
                }
            }
        }
    } // End Rectangle
    Rectangle {
        width: 138; height: 81
        color: colorInfo.transparent

        BorderImage {
            source: imgFolderSettings+"bg_password_4.png"
            border.left: 25;
        }
        Loader {
            id: item4
            sourceComponent: password
            focus: true

//            onLoaded: focus = true

            anchors.fill: parent

            MouseArea {
                anchors.fill: parent
                onClicked: parent.focus = true


            }
        }
    } // End Rectangle
} // End Row

//}

