import Qt 4.7

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"

    property int displayFR: -1
    property bool btPopupOn: false

    states: [
        State {
            name:  "projectionState"
            PropertyChanges {
                target: popupLoader;
                source: ""
            }
        },
        State {
            name:  "ProjectionPopupState"
            PropertyChanges {
                target: popupLoader;
                source: "ProjectionPopup.qml"
            }
        },
        State {
            name:  "BTPopupState"
            PropertyChanges {
                target: popupLoader;
                source: "BTPopup.qml"
            }
        }
    ]

    Loader { id: popupLoader;}

    Connections {
        target: EngineListenerMain

        onNotiSwap:
        {
            __LOG("onNotiSwap  swap: " +  EngineListenerMain.isSwap + "  displayFR: " + root.displayFR);
            if((EngineListenerMain.isSwap == false && root.displayFR == 0) || (EngineListenerMain.isSwap == true && root.displayFR == 1))
                root.state = "projectionState"
            else
                root.state = "ProjectionPopupState"
        }

        onNotiBTPopup:
        {
            __LOG("sub onNotiBTPopup " + isShow);
            if((EngineListenerMain.isSwap == false && root.displayFR == 0) || (EngineListenerMain.isSwap == true && root.displayFR == 1))
            {
                if (isShow == true)
                {
                    root.state = "BTPopupState"
                }
                else
                {
                    root.state = "projectionState"
                }
            }
            else
            {
                root.state = "ProjectionPopupState"
            }
        }
    }

    function __LOG( textLog )
    {
        EngineListenerMain.qmlLog( "__LOG " + textLog )
    }
}

