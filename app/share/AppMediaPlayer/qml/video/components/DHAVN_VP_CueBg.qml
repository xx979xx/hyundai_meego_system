// { modified by Sergey 08.09.2013 for ITS#188248
import Qt 4.7
import QtQuick 1.1
import AppEngineQMLConstants 1.0

import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../DHAVN_VP_RESOURCES.js" as RES  
import "../components/listView"


Item
{
    id: main

    property bool east: false
    property alias bVertical: cue.bVertical   // show vertical arrows in cue
    property alias sVertArrow: cue.sVertArrow // "up", "down", "none"
    property alias cueState : cue.state
    // { removed by yungi 2013.12.05 for ITS 211269 // { added by yungi 2013.11.19 for ITS 209826
    property alias currentFocusIndex : cue.currentFocusIndex // added by cychoi 2014.12.22 for visual cue animation on quick scroll


    states: [
    State
    {
        name: "left"
        PropertyChanges { target: leftFrame; visible: true }
        PropertyChanges { target: rightFrame; visible: false }
        PropertyChanges { target: leftFrameBG; visible: true } //added by shkim for ITS 189040
        PropertyChanges { target: rightFrameBG; visible: false }//added by shkim for ITS 189040
    },
    State
    {
        name: "right"
        PropertyChanges { target: leftFrame; visible: false }
        PropertyChanges { target: rightFrame; visible: true }
        PropertyChanges { target: leftFrameBG; visible: false }//added by shkim for ITS 189040
        PropertyChanges { target: rightFrameBG; visible: true }//added by shkim for ITS 189040
    },
    State
    {
        name: "none"
        PropertyChanges { target: leftFrame; visible: false }
        PropertyChanges { target: rightFrame; visible: false }
        PropertyChanges { target: leftFrameBG; visible: false }//added by shkim for ITS 189040
        PropertyChanges { target: rightFrameBG; visible: false }//added by shkim for ITS 189040
    }
    ]




    // =================================== SUB ELEMENTS ========================================================
    //added by shkim for ITS 189040
    Image
    {
        id: leftFrameBG

        anchors.top: main.top
        anchors.bottom: main.bottom
        anchors.left: main.left

        source: "/app/share/images/general/bg_menu_l.png"
        mirror: main.east
    }
    //added by shkim for ITS 189040
    Image
    {
        id: leftFrame

        z: main.z + 4

        anchors.top: main.top
        anchors.bottom: main.bottom
        anchors.left: main.left

        source: "/app/share/images/general/bg_menu_l_s.png"//added by shkim for ITS 189040
        mirror: main.east
    }

    //added by shkim for ITS 189040
    Image
    {
        id: rightFrameBG

        anchors.top: main.top
        anchors.bottom: main.bottom
        anchors.right: main.right


        source: "/app/share/images/general/bg_menu_r.png"
        mirror: main.east
    }
    //added by shkim for ITS 189040
    Image
    {
        id: rightFrame

        z: main.z + 4

        anchors.top: main.top
        anchors.bottom: main.bottom
        anchors.right: main.right

        source: "/app/share/images/general/bg_menu_r_s.png"
        mirror: main.east
    }


    DHAVN_VP_VisualCue
    {
        id: cue

        z: main.z + 5

        // { added by cychoi 2013.11.26 for ITS 211070
        LayoutMirroring.enabled: east
        LayoutMirroring.childrenInherit: east
        property bool east: EngineListenerMain.middleEast
        // } added by cychoi 2013.11.26

        anchors.top : main.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET + 10
        anchors.left: main.left
        anchors.leftMargin: 560 // the resource is not symmetric
        // removed by yungi 2013.12.05 for ITS 211269 // { added by yungi 2013.11.19 for ITS 209826

        //LayoutMirroring.enabled: false // commented by cychoi 2013.11.26 for ITS 211070
        state: "uprightActive" // modified by yungi 2013.08.05 for 4-arrow display error
        bVertical: main.bVertical
        //bMirrored: main.east // commented by cychoi 2013.11.26 for ITS 211070
        currentFocusIndex : main.currentFocusIndex // added by cychoi 2014.12.22 for visual cue animation on quick scroll
    }
}
// } modified by Sergey 08.09.2013 for ITS#188248
