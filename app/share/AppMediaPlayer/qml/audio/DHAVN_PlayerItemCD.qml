import QtQuick 1.0
import "DHAVN_AppMusicPlayer_General.js" as MPC

Item {
    id: playerItem

    width: parent.width
    height: parent.height

    property string filePath: ""

    function nextCD( filePath )
    {
        flipable.nextSide(filePath)
    }

    Component
    {
        id: cdComponent

        Image
        {
            id: cdBgImg

            anchors.fill: parent
            fillMode: Image.PreserveAspectFit

            Timer
            {
                id: timer
                interval: MPC.const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_TIMER_INTERVAL
                running: false

                onTriggered:
                {
                    animation.running = true
                    timer.interval = MPC.const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_TIMER_INTERVAL
                }
            }

            PropertyAnimation on rotation
            {
                id: animation
                running: false
                to: 360
                duration: 4000
                loops: Animation.Infinite
            }

            function firstStart()
            {
                timer.interval = 1000
            }

            function startRotation()
            {
                //timer.running = true
                //timer.restart()
                cdBgImg.rotation = 0
            }

            function stopRotation()
            {
                animation.running = false
                timer.stop()
            }

            function setFilePath( filePath )
            {
                source = filePath
            }
        }
    }

    Flipable
    {
        id: flipable

        width: MPC.const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_WIDTH
        height: MPC.const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_HEIGHT
        anchors.right: parent.right
        anchors.rightMargin: MPC.const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_RIGHT_MARGIN

        property bool flipped: false
        property string newFile: ""
        property bool isCompleted: false
        property int __duration: MPC.const_APP_MUSIC_PLAYER_PLAYER_ITEM_CD_DURATION

        front: Loader
        {
            id: frontSide
            sourceComponent: cdComponent
            anchors.fill: parent
        }

        back: Loader
        {
            id: backSide
            sourceComponent: cdComponent
            anchors.fill: parent
        }

        transform: Rotation
        {
            id: rotation
            origin.x: flipable.width / 2
            origin.y: flipable.height / 2
            axis.x: 0
            axis.y: 1
            axis.z: 0
            angle: 0
        }

        states: State
        {
            name: "back"
            PropertyChanges { target: rotation; angle: flipable ? 180 : 0 }
            when: flipable.flipped;
        }

        transitions: Transition
        {
            NumberAnimation { property: "angle"; duration: flipable.__duration }
        }

        Component.onCompleted:
        {
            frontSide.item.setFilePath(filePath)
            frontSide.item.firstStart()
            if (visible) frontSide.item.startRotation()
            isCompleted = true
        }

        onFlippedChanged:
        {
            switch (side)
            {
                case Flipable.Front:
                {
                    frontSide.item.stopRotation()
                    backSide.item.setFilePath(newFile)
                    backSide.item.startRotation()
                }
                break;

                case Flipable.Back:
                {
                    backSide.item.stopRotation()
                    frontSide.item.setFilePath(newFile)
                    frontSide.item.startRotation()
                }
                break;
            }
        }

        onVisibleChanged:
        {
            if ( !isCompleted )
            {
                return
            }

            switch (side)
            {
                case Flipable.Front:
                    if (visible)
                        frontSide.item.startRotation()
                    else
                        frontSide.item.stopRotation()
                    break;

                case Flipable.Back:
                    if (visible)
                        backSide.item.startRotation()
                    else
                        backSide.item.stopRotation()
                    break;
            }
        }

        function nextSide( filePath )
        {
            flipable.newFile = filePath
            flipable.flipped = !flipable.flipped
        }
    }
}
