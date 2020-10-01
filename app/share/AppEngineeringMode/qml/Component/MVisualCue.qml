/**
 * FileName: MVisualCue.qml
 * Author: HYANG
 * Time: 2012-02-14
 *
 * - 2012-02-14 Initial Crated by HYANG
 */

import Qt 4.7
import "../System" as MSystem
import "../Component" as MComp

FocusScope {
    id: idVisualCue
    x: 0; y: 0; z: 1
    width: menuVisualCue? 144 : 158; height: menuVisualCue? 163 : 170
    opacity: 0;

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Property #
    property bool menuVisualCue: false  // true: arrow-2 (use bluetooth) , false: arrow-4 (use radio)

    // visual_cue image
    property string imgArrow_U_N        :imageInfo.imgFolderGeneral+"ch_visual_cue_u_n.png"
    property string imgArrow_D_N        :imageInfo.imgFolderGeneral+"ch_visual_cue_d_n.png"
    property string imgArrow_L_N        :imageInfo.imgFolderGeneral+"ch_visual_cue_l_n.png"
    property string imgArrow_R_N        :imageInfo.imgFolderGeneral+"ch_visual_cue_r_n.png"

    property string imgArrow_U_S        :imageInfo.imgFolderGeneral+"ch_visual_cue_u_s.png"
    property string imgArrow_D_S        :imageInfo.imgFolderGeneral+"ch_visual_cue_d_s.png"
    property string imgArrow_L_S        :imageInfo.imgFolderGeneral+"ch_visual_cue_l_s.png"
    property string imgArrow_R_S        :imageInfo.imgFolderGeneral+"ch_visual_cue_r_s.png"

    // menu visual_cue image
    property string imgArrowMenu_L_N    :imageInfo.imgFolderGeneral+"menu_visual_cue_arrow_l_n.png"
    property string imgArrowMenu_R_N    :imageInfo.imgFolderGeneral+"menu_visual_cue_arrow_r_n.png"
    property string imgArrowMenu_L_P    :imageInfo.imgFolderGeneral+"menu_visual_cue_arrow_l_p.png"
    property string imgArrowMenu_R_P    :imageInfo.imgFolderGeneral+"menu_visual_cue_arrow_r_p.png"

    property string inputMode: idAppMain.inputMode;
    property bool keyPressed: idAppMain.keyPressed;

    property bool upKeyPressed : idAppMain.upKeyPressed;
    property bool downKeyPressed : idAppMain.downKeyPressed;
    property bool rightKeyPressed : idAppMain.rightKeyPressed;
    property bool leftKeyPressed : idAppMain.leftKeyPressed;

    //****************************** # VisualCue background Image #
    Image{
        source: menuVisualCue? imageInfo.imgFolderGeneral+"menu_visual_cue_bg.png" : imageInfo.imgFolderGeneral+"ch_visual_cue_bg.png"
    }

    //****************************** # Arrow default image #
    Image{
        id: idUp;
        x: 28+31; y: 33;
        source: imgArrow_U_N;
        visible: !menuVisualCue
    }
    Image{
        id: idDown;
        x: 28+31; y: 33+31+34;
        source: imgArrow_D_N;
        visible: !menuVisualCue
    }
    Image{
        id: idLeft;
        x: 28; y: menuVisualCue? 65 : 33+31;
        source: menuVisualCue? imgArrowMenu_L_N : imgArrow_L_N;
    }
    Image{
        id: idRight;
        x: 28+31+34; y: menuVisualCue? 65 : 33+31;
        source: menuVisualCue? imgArrowMenu_R_N : imgArrow_R_N;
    }

    //****************************** # when keypressed changed #
    onUpKeyPressedChanged: {
        if(upKeyPressed) state = "up";
        else state = "";
    }
    onDownKeyPressedChanged: {
        if(downKeyPressed) state = "down";
        else state = "";
    }
    onLeftKeyPressedChanged: {
        if(leftKeyPressed) state = "left";
        else state = "";
    }
    onRightKeyPressedChanged: {
        if(rightKeyPressed) state = "right";
        else state = "";
    }

    //****************************** # state #
    states: [
        State { name:"up";          PropertyChanges {target: idUp;          source: imgArrow_U_S;} },
        State { name:"down";        PropertyChanges {target: idDown;        source: imgArrow_D_S;} },
        State { name:"left";        PropertyChanges {target: idLeft;        source: menuVisualCue? imgArrowMenu_L_P : imgArrow_L_S;} },
        State { name:"right";       PropertyChanges {target: idRight;       source: menuVisualCue? imgArrowMenu_R_P : imgArrow_R_S;} }
    ]

    //****************************** # event by inputmode changed #
    onInputModeChanged: {
        if(inputMode == "jog") opacity = 1 //show VisualCue
        else if(inputMode == "touch") opacity = 1; //hide VisualCue
        else opacity = 1; // inputMode == "tuneFocus"
    }
}
