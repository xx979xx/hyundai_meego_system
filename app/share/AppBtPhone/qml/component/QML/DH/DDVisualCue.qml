/**
 * /QML/DH/DDVisualCue.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


Item
{
    id: idVisualCue
    x: 0;
    y: 0;
    opacity: 1;


    // PROPERTIES
    property bool arrowKeyOnOff: true  //# Key On/Off

    property bool arrowUpFlag: true
    property bool arrowDownFlag: true
    property bool arrowLeftFlag: false
    property bool arrowRightFlag: true

    property string imgArrowUp:             ImagePath.imgFolderGeneral + "ch_visual_cue_u_n.png"
    property string imgArrowDown:           ImagePath.imgFolderGeneral + "ch_visual_cue_d_n.png"
    property string imgArrowLeft:           ImagePath.imgFolderGeneral + "ch_visual_cue_l_n.png"
    property string imgArrowRight:          ImagePath.imgFolderGeneral + "ch_visual_cue_r_n.png"

    property string imgArrowUpSelected:     ImagePath.imgFolderGeneral + "ch_visual_cue_u_s.png"
    property string imgArrowDownSelected:   ImagePath.imgFolderGeneral + "ch_visual_cue_d_s.png"
    property string imgArrowLeftSelected:   ImagePath.imgFolderGeneral + "ch_visual_cue_l_s.png"
    property string imgArrowRightSelected:  ImagePath.imgFolderGeneral + "ch_visual_cue_r_s.png"

    property string imgArrowUpDisable:      ImagePath.imgFolderGeneral + "ch_visual_cue_u_d.png"
    property string imgArrowDownDisable:    ImagePath.imgFolderGeneral + "ch_visual_cue_d_d.png"
    property string imgArrowLeftDisable:    ImagePath.imgFolderGeneral + "ch_visual_cue_l_d.png"
    property string imgArrowRightDisable:   ImagePath.imgFolderGeneral + "ch_visual_cue_r_d.png"

    property bool upKeyPressed:         idAppMain.upKeyPressed;
    property bool downKeyPressed:       idAppMain.downKeyPressed;
    property bool rightKeyPressed:      idAppMain.rightKeyPressed;
    property bool leftKeyPressed:       idAppMain.leftKeyPressed;

    property bool upKeyLongPressed:     idAppMain.upKeyLongPressed;
    property bool downKeyLongPressed:   idAppMain.downKeyLongPressed;
    property bool rightKeyLongPressed:  idAppMain.rightKeyLongPressed;
    property bool leftKeyLongPressed:   idAppMain.leftKeyLongPressed;


    /* INTERNAL functions */
    function setVisualCue(top, right, bottom, left) {
        arrowUpFlag     = top;
        arrowLeftFlag   = left;
        arrowDownFlag   = bottom;
        arrowRightFlag  = right;
    }


    /* CONNECTIONS */
    Connections {
        target: idAppMain

        onSigSetVisualCue: {
            arrowUpFlag     = top;
            arrowRightFlag  = right;
            arrowDownFlag   = bottom;
            arrowLeftFlag   = left;
        }
    }


    /* EVENT handlers */
    onUpKeyPressedChanged: {
        if(true == upKeyPressed) {
            if(false == arrowUpFlag) {
                // do nothing
            } else {
                state = "STATE_UP";
                idVisualCueBg.y = -3;
            }
        } else {
            state = "";
            idVisualCueBg.y = 0;
        }
    }

    onDownKeyPressedChanged: {
        if(true == downKeyPressed) {
            if(false == arrowDownFlag) {
                // do nothing
            } else {
                state = "STATE_DOWN";
                idVisualCueBg.y = 3;
            }
        } else {
            state = "";
            idVisualCueBg.y = 0;
        }
    }

    onLeftKeyPressedChanged: {
        if(true == leftKeyPressed) {
            if(false == arrowLeftFlag) {
                // do nothing
            } else { 
                state = "STATE_LEFT";
                idVisualCueBg.x = -3;
            }
        } else {
            state = "";
            idVisualCueBg.x = 0;
        }
    }
 
    onRightKeyPressedChanged: {
        if(true == rightKeyPressed) {
            if(false == arrowRightFlag) {
                // do nothing
            } else {
                state = "STATE_RIGHT";
                idVisualCueBg.x = 3;
            }
        } else {
            state = "";
            idVisualCueBg.x = 0;
        }
    }

    onUpKeyLongPressedChanged: {
        if(true == upKeyLongPressed){
            if(false == arrowUpFlag) {
                // do nothing
            } else {
                state = "";
                idVisualCueBg.y = 0;
            }
        }
        else{
            state = "";
            idVisualCueBg.y = 0;
        }
    }

    onDownKeyLongPressedChanged: {
        if(true == downKeyLongPressed) {
            //[ITS 0272297]
            if((false == arrowLeftFlag)&&(false == arrowDownFlag))
            {
                if(false == arrowDownFlag) {
                    if(true == visualCueDownActive) {
                        state = "STATE_DOWN";
                        idVisualCueBg.y = 3;
                    }
                } else {
                    state = "";
                    idVisualCueBg.y = 0;
                }
            }
        } else {
            state = "";
            idVisualCueBg.y = 0;
        }
    }
    
    onLeftKeyLongPressedChanged: {
        if(true == leftKeyLongPressed) {
            if(false == arrowLeftFlag) {
                // do nothing
            } else {
                state = "";
                idVisualCueBg.x = 0;
            }
        } else {
            state = "";
            idVisualCueBg.x = 0;
        }
    }

    onRightKeyLongPressedChanged: {
        if(true == rightKeyLongPressed) {
            if(false == arrowRightFlag) {
                //
            } else {
                state = "";
                idVisualCueBg.x = 0;
            }
        } else {
            state = "";
            idVisualCueBg.x = 0;
        }
    }


    /* WIDGETS */
    Image {
        id: idVisualCueBg
        source: ImagePath.imgFolderGeneral + "menu_visual_cue_bg.png"
        x: 0
        y: 0;

        Image {
            id: idUp
            x: 53
            y: 27
            z: 1
            source: (true == arrowUpFlag) ? imgArrowUp : imgArrowUpDisable
            visible: (true == arrowKeyOnOff) ? true : false
        }

        Image {
            id: idDown
            x: 53
            y: 92
            z: 1
            source:  (true == arrowDownFlag) ? imgArrowDown : imgArrowDownDisable
            visible: (true == arrowKeyOnOff) ? true : false
        }

        Image {
            id: idLeft
            x: 22
            y: 58
            z: 1
            source: (true == arrowLeftFlag) ? imgArrowLeft : imgArrowLeftDisable
            visible: (true == arrowKeyOnOff) ? true : false
        }

        Image {
            id: idRight
            x: 87
            y: 58
            z: 1
            source: (true == arrowRightFlag) ? imgArrowRight : imgArrowRightDisable
            visible: (true == arrowKeyOnOff) ? true : false
        }
    }

    /* STATES */
    states: [
          State { name:"STATE_UP";      PropertyChanges {target: idUp;      source: imgArrowUpSelected;} }
        , State { name:"STATE_DOWN";    PropertyChanges {target: idDown;    source: imgArrowDownSelected; } }
        , State { name:"STATE_LEFT";    PropertyChanges {target: idLeft;    source: imgArrowLeftSelected; } }
        , State { name:"STATE_RIGHT";   PropertyChanges {target: idRight;   source: imgArrowRightSelected; } }
    ]
}
/* EOF */
