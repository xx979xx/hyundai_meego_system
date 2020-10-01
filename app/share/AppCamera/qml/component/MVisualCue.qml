import QtQuick 1.1

import "../system" as MSystem

FocusScope {
    id: idVisualCue
    z: 1
    width: 158; height: 170

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }

    //****************************** # Property #
    property int arrowMode : 5 // 0 : only down is available, 1 : left/down Arrow is disable, 2 : right and down Arrows are disable
    // 3: down is disable, 4: up and down are disable,  5 : all Arrows are available.

    // visual_cue image
    property string imgArrow_U_N        :systemInfo.imageInternal+"ch_visual_cue_u_n.png"
    property string imgArrow_D_N        :systemInfo.imageInternal+"ch_visual_cue_d_n.png"
    property string imgArrow_L_N        :systemInfo.imageInternal+"ch_visual_cue_l_n.png"
    property string imgArrow_R_N        :systemInfo.imageInternal+"ch_visual_cue_r_n.png"

    property string imgArrow_U_D        :systemInfo.imageInternal+"ch_visual_cue_u_d.png"
    property string imgArrow_D_D        :systemInfo.imageInternal+"ch_visual_cue_d_d.png"
    property string imgArrow_L_D        :systemInfo.imageInternal+"ch_visual_cue_l_d.png"
    property string imgArrow_R_D        :systemInfo.imageInternal+"ch_visual_cue_r_d.png"

    property string imgArrow_U_S        :systemInfo.imageInternal+"ch_visual_cue_u_s.png"
    property string imgArrow_D_S        :systemInfo.imageInternal+"ch_visual_cue_d_s.png"
    property string imgArrow_L_S        :systemInfo.imageInternal+"ch_visual_cue_l_s.png"
    property string imgArrow_R_S        :systemInfo.imageInternal+"ch_visual_cue_r_s.png"

    property bool keyPressed: idAppMain.keyPressed;

    property bool upKeyPressed : idAppMain.upKeyPressed;
    property bool downKeyPressed : idAppMain.downKeyPressed;
    property bool rightKeyPressed : idAppMain.rightKeyPressed;
    property bool leftKeyPressed : idAppMain.leftKeyPressed;

    //****************************** # VisualCue background Image #
    Image{
        source: systemInfo.imageInternal+"menu_visual_cue_bg.png"
    }

    //****************************** # Arrow default image #
    Image{
        id: idUp;
        x: 28+31-5; y: 33-4;
        source: (arrowMode==0 || arrowMode==4)? imgArrow_U_D : imgArrow_U_N
    }
    Image{
        id: idDown;
        x: 28+31-5; y: 33+31+34-4;
        source: (arrowMode==0 || arrowMode==5)? imgArrow_D_N : imgArrow_D_D
    }
    Image{
        id: idLeft;
        x: 28-5; y: 33+31-4;
        source: (arrowMode>1)? imgArrow_L_N : imgArrow_L_D
    }
    Image{
        id: idRight;
        x: 28+31+34-5; y: 33+31-4;
        source: (arrowMode==0 || arrowMode==2)? imgArrow_R_D : imgArrow_R_N
    }

    //****************************** # when keypressed changed #
    onUpKeyPressedChanged: {
        if (upKeyPressed) {
            if (arrowMode!=0 && arrowMode!=4) state = "up";
        }
        else state = "";
    }
    onDownKeyPressedChanged: {
        if (downKeyPressed) {
            if (arrowMode==0 || arrowMode==5) state = "down";
        }
        else state = "";
    }
    onLeftKeyPressedChanged: {
        if (leftKeyPressed) {
           if (arrowMode!=0 && arrowMode!=1)  state = "left";
        }
        else state = "";
    }
    onRightKeyPressedChanged: {
        if (rightKeyPressed)  {
           if (arrowMode!=0 && arrowMode!=2)  state = "right";
        }
        else state = "";
    }

    //****************************** # state #
    states: [
        State {
            name:"up";
            PropertyChanges {
                target: idUp;
                source: imgArrow_U_S;
            }
            PropertyChanges {
                target: idVisualCue;
                y: y-3;
            }
        },
        State {
            name:"down";
            PropertyChanges {
                target: idDown;
                source: imgArrow_D_S;
            }
            PropertyChanges {
                target: idVisualCue;
                y: y+3;
            }
        },
        State {
            name:"left";
            PropertyChanges {
                target: idLeft;
                source:  imgArrow_L_S;
            }
            PropertyChanges {
                target: idVisualCue;
                x: x-3;
            }
        },
        State {
            name:"right";
            PropertyChanges {
                target: idRight;
                source: imgArrow_R_S;
            }
            PropertyChanges {
                target: idVisualCue;
                x: x+3;
            }
        }
    ]

}

