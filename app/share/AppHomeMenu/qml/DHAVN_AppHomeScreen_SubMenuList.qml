import QtQuick 1.1

import QmlHomeScreenDef 1.0
import QmlHomeScreenDefPrivate 1.0
import AppEngineQMLConstants 1.0


Item {
    id: subMenuListContainer

    x: 0; y:0; width: 1280; height: 720

    function wheelLeft() {
        subMenuList.wheelLeft()
    }

    function wheelRight() {
        subMenuList.wheelRight()
    }

    function setFocusIndex(focusIndex) {
        subMenuList.setFocusIndex(focusIndex)
    }


    function setDefaultFocusIndex () {
        subMenuList.setDefaultFocusIndex()
    }


    function setFocusVisible (value) {
        subMenuList.setFocusVisible(value)
    }

    Item {
        x:0; y:93; width: 1280; height: 720-93

        clip: true

        CurvedList {
            id: subMenuList

            x: LocTrigger.arab ? 210 : 394
            y: 120-93; width: 700; height: 112*5
        }
    }
}
