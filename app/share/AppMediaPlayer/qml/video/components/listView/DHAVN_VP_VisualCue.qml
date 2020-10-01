// { modified by Sergey 08.09.2013 for ITS#188248
import Qt 4.7
import QtQuick 1.1
import AppEngineQMLConstants 1.0

import "../../components"
import "../../models"
import "../../DHAVN_VP_CONSTANTS.js" as VP
import "../../DHAVN_VP_RESOURCES.js" as RES




Image
{
    id: visual_cue

    source: "/app/share/images/general/menu_visual_cue_bg.png"

    // { added by cychoi 2013.11.26 for ITS 211070
    LayoutMirroring.enabled: east
    LayoutMirroring.childrenInherit: east
    property bool east: EngineListenerMain.middleEast
    //property bool bMirrored: false
    // } added by cychoi 2013.11.26

    property bool bVertical: false // show vertical arrows
    property string sVertArrow: "none" // "up", "down", "none"
    property int oldArrow : -1
    property int oldStatus: -1
    // { removed by yungi 2013.12.05 for ITS 211269 // { added by yungi 2013.11.19 for ITS 209826
    property int currentFocusIndex : 0 // added by cychoi 2014.12.22 for visual cue animation on quick scroll

    states:
        [
        State
        {
            name: "rightActive"
            PropertyChanges { target: east ? visual_cue_left_arrow : visual_cue_right_arrow;  active: true } // modified by cychoi 2013.11.26 for ITS 211070
        },
        State
        {
            name: "leftActive"
            PropertyChanges { target: east ? visual_cue_right_arrow : visual_cue_left_arrow;  active: true } // modified by cychoi 2013.11.26 for ITS 211070
        },
        State
        {
            name: "upActive"
            PropertyChanges { target: visual_cue_up_arrow;  active: true }
        },
        State
        {
            name: "downActive"
            PropertyChanges { target: visual_cue_down_arrow;  active: true }
        },
        State
        {
            name: "upleftActive"
            PropertyChanges { target: visual_cue_up_arrow;   active: true }
            PropertyChanges { target: visual_cue_left_arrow;  active: true } // restored by yungi 2013.12.05 for ITS 211269// modified by cychoi 2013.11.26 for ITS 211070
        },
        State
        {
            name: "uprightActive"
            PropertyChanges { target: visual_cue_up_arrow;      active: true }
            PropertyChanges { target: visual_cue_right_arrow;  active: true } // restored by yungi 2013.12.05 for ITS 211269 // modified by cychoi 2013.11.26 for ITS 211070
        },
        State
        {
            name: "downleftActive"
            PropertyChanges { target: visual_cue_down_arrow; active: true }
            PropertyChanges { target: visual_cue_left_arrow;  active: true } // restored by yungi 2013.12.05 for ITS 211269 // modified by cychoi 2013.11.26 for ITS 211070
        },
        State
        {
            name: "downrightActive"
            PropertyChanges { target: visual_cue_down_arrow;    active: true }
            PropertyChanges { target: visual_cue_right_arrow;  active: true } // restored by yungi 2013.12.05 for ITS 211269 // modified by cychoi 2013.11.26 for ITS 211070
        },
        // { added by yungi 2013.12.04 for ITS 211269
        State
        {
            name: "upleftdownActive"
            PropertyChanges { target: visual_cue_up_arrow;   active: true }
            PropertyChanges { target: visual_cue_down_arrow;  active: true }
            PropertyChanges { target: visual_cue_left_arrow;  active: true } // restored by yungi 2013.12.05 for ITS 211269 // modified by cychoi 2013.11.26 for ITS 211070
        },
        State
        {
            name: "upleftrightActive"
            PropertyChanges { target: visual_cue_up_arrow;   active: true }
            PropertyChanges { target: visual_cue_left_arrow;    active: true }
            PropertyChanges { target: visual_cue_right_arrow;    active: true }
        },
        State
        {
            name: "uprightdownActive"
            PropertyChanges { target: visual_cue_up_arrow;   active: true }
            PropertyChanges { target: visual_cue_down_arrow;    active: true }
            PropertyChanges { target: visual_cue_right_arrow;  active: true }
        },
        State
        {
            name: "allActive"
            PropertyChanges { target: visual_cue_left_arrow;  active: true}
            PropertyChanges { target: visual_cue_right_arrow; active: true}
            PropertyChanges { target: visual_cue_up_arrow;    active: true}
            PropertyChanges { target: visual_cue_down_arrow;  active: true}
        },
        // } added by yungi
        State
        {
            name: "noneActive"
            PropertyChanges { target: visual_cue_left_arrow;  active: false }
            PropertyChanges { target: visual_cue_right_arrow; active: false }
            PropertyChanges { target: visual_cue_up_arrow;    active: false }
            PropertyChanges { target: visual_cue_down_arrow;  active: false }
        }
    ]


    // { added by cychoi 2014.12.22 for visual cue animation on quick scroll
    onCurrentFocusIndexChanged:
    {
        if(oldArrow == UIListenerEnum.JOG_DOWN &&
           (oldStatus == UIListenerEnum.KEY_STATUS_LONG_PRESSED ||
            oldStatus == UIListenerEnum.KEY_STATUS_PRESSED))
        {
            visual_cue_down_arrow.pressed = true;
        }
    }
    // } added by cychoi 2014.12.22


    Connections
    {
        target: visual_cue.visible ? /*UIListener */EngineListener: null

        onSignalJogNavigation:
        {
            if(oldArrow == arrow && oldStatus == status )
                return;

            oldArrow  = arrow 
            oldStatus = status

            // { modified by yungi 2013.12.05 for ITS 211269
            if(status == UIListenerEnum.KEY_STATUS_PRESSED)
            {
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_UP:
                    {
                         switch(visual_cue.state)
                         {
                         case "allActive": case "upActive": case "upleftActive": case "uprightActive": case "upleftdownActive": case "upleftrightActive": case "uprightdownActive":
                                visual_cue_up_arrow.pressed = true;
                                break;
                         }
                         break;
                    }
                    case UIListenerEnum.JOG_DOWN:
                    {
                        switch(visual_cue.state)
                        {
                           case "allActive": case "downActive": case "downleftActive": case "downrightActive": case "upleftdownActive": case "uprightdownActive":
                               visual_cue_down_arrow.pressed = true;
                               break;
                        }
                        break;
                    }
                    case UIListenerEnum.JOG_RIGHT:
                    // { commented by cychoi 2014.02.28 for UX & GUI fix
                    //case UIListenerEnum.JOG_TOP_RIGHT: // added by yungi 2014.02.14 for ITS 225174
                    //case UIListenerEnum.JOG_BOTTOM_RIGHT: // added by yungi 2014.02.14 for ITS 225174
                    // } commented by cychoi 2014.02.28
                    {
                        switch(visual_cue.state)
                        {
                            case "allActive": case "rightActive": case "uprightActive": case "downrightActive": case "upleftrightActive": case "uprightdownActive":
                                visual_cue_right_arrow.pressed = true;
                                break;
                        }
                        break;
                    }
                    case UIListenerEnum.JOG_LEFT:
                    // { commented by cychoi 2014.02.28 for UX & GUI fix
                    //case UIListenerEnum.JOG_TOP_LEFT: // added by yungi 2014.02.14 for ITS 225174
                    //case UIListenerEnum.JOG_BOTTOM_LEFT: // added by yungi 2014.02.14 for ITS 225174
                    // } commented by cychoi 2014.02.28
                    {
                        switch(visual_cue.state)
                        {
                            case "allActive": case "upleftdownActive": case "upleftrightActive": case "leftActive": case "upleftActive": case "downleftActive":
                                visual_cue_left_arrow.pressed = true;
                                break;
                        }
                        break;
                    }
                }
            }
            // } modified by yungi

            if(status == UIListenerEnum.KEY_STATUS_RELEASED)
            {
                visual_cue_left_arrow.pressed = false;
                visual_cue_right_arrow.pressed = false;
                visual_cue_up_arrow.pressed = false;
                visual_cue_down_arrow.pressed = false;
            }
        }
    }




// =================================== SUB ELEMENTS ========================================================


    Image
    {
        id: visual_cue_left_arrow

        anchors.top: parent.top
        anchors.topMargin: 58 //modified by aettie 20130625 for New GUI
        anchors.left: parent.left
        anchors.leftMargin: 22 //modified by aettie 20130625 for New GUI

        LayoutMirroring.enabled: false
        source: pressed ? RES.const_URL_IMG_VISUALCUE_LEFT_ARR_P : (active ?  RES.const_URL_IMG_VISUALCUE_LEFT_ARR_N : RES.const_URL_IMG_VISUALCUE_LEFT_ARR_D)

        property bool active: false
        property bool pressed: false


        onPressedChanged:
        {
            if(pressed)
                visual_cue.anchors.leftMargin += east ? 3 : -3;
            else
                visual_cue.anchors.leftMargin += east ? -3 : 3;
        }
    }


    Image
    {
        id: visual_cue_right_arrow

        anchors.top: parent.top
        anchors.topMargin: 58 //modified by aettie 20130625 for New GUI
        anchors.left: parent.left
        anchors.leftMargin: 87 //modified by aettie 20130625 for New GUI

        LayoutMirroring.enabled: false
        source: pressed ? RES.const_URL_IMG_VISUALCUE_RIGHT_ARR_P : (active ?  RES.const_URL_IMG_VISUALCUE_RIGHT_ARR_N : RES.const_URL_IMG_VISUALCUE_RIGHT_ARR_D)

        property bool active: false
        property bool pressed: false


        onPressedChanged:
        {
            if(pressed)
                visual_cue.anchors.leftMargin += east ? -3 : 3;
            else
                visual_cue.anchors.leftMargin += east ? 3 : -3;
        }
    }


    Image
    {
        id: visual_cue_up_arrow

        anchors.top: parent.top
        anchors.topMargin: 27 //modified by aettie 20130625 for New GUI
        anchors.left: parent.left
        anchors.leftMargin: 53 //modified by aettie 20130625 for New GUI

        LayoutMirroring.enabled: false
        source: pressed ? RES.const_URL_IMG_VISUALCUE_UP_ARR_P : (active ?  RES.const_URL_IMG_VISUALCUE_UP_ARR_N : RES.const_URL_IMG_VISUALCUE_UP_ARR_D)

        property bool active: false
        property bool pressed: false


        onPressedChanged:
        {
            if(pressed)
                visual_cue.anchors.topMargin -= 3;
            else
                visual_cue.anchors.topMargin += 3;
        }
    }


    Image
    {
        id: visual_cue_down_arrow

        anchors.top: parent.top
        anchors.topMargin: 92 //modified by aettie 20130625 for New GUI
        anchors.left: parent.left
        anchors.leftMargin: 53 //modified by aettie 20130625 for New GUI

        LayoutMirroring.enabled: false
        source: pressed ? RES.const_URL_IMG_VISUALCUE_DOWN_ARR_P : (active ?  RES.const_URL_IMG_VISUALCUE_DOWN_ARR_N : RES.const_URL_IMG_VISUALCUE_DOWN_ARR_D)
        visible: bVertical

        property bool active: false
        property bool pressed: false


        onPressedChanged:
        {
            if(pressed)
                visual_cue.anchors.topMargin += 3;
            else
                visual_cue.anchors.topMargin -= 3;
        }
    }
}
// } modified by Sergey 08.09.2013 for ITS#188248
