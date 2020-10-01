/**
 * FileName: MVisualCue.qml
 * Author: HYANG
 * Time: 2012-02-14
 *
 * - 2012-02-14 Initial Crated by HYANG
 * - 2012-09-19 added visualcue movement, longkey by HYANG
 * - 2012-11-16 VisualCue Arrow - Disable added
 * - 2012-12-07 Add WheelKey
 * - 2012-12-21 Add touchMode - Dim
 */

import Qt 4.7

FocusScope {
    id: idVisualCue
    x: 0; y: 0; z: 1

    //****************************** # Property #
    property bool arrowKeyOnOff: true   //# Key On/Off
    property bool wheelKeyOnOff: false  //# WheelKey On/Off

    property bool arrowUpFlag: true     //# Key, WheelKey normal or disable
    property bool arrowDownFlag: true
    property bool arrowLeftFlag: true
    property bool arrowRightFlag: true
    property bool wheelLeftFlag: true
    property bool wheelRightFlag: true

    property int upKeyX: 22 + 31
    property int upKeyY: 27
    property int downKeyX: 22 + 31
    property int downKeyY: 27 + 31 + 34
    property int leftKeyX: 22
    property int leftKeyY: 27 + 31
    property int rightKeyX: 22 + 31 + 34
    property int rightKeyY: 27 + 31
    property int wheelLeftKeyX: 14
    property int wheelLeftKeyY: 34
    property int wheelRightKeyX: 14 + 44
    property int wheelRightKeyY: 34

    //****************************** # VisualCue Image (normal/selected/focus/disable) #
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderPhoto: imageInfo.imgFolderPhoto

    //property string imgVisualCueBg: imgFolderGeneral+"ch_visual_cue_bg.png"
    property string imgVisualCueBg: imgFolderGeneral+"menu_visual_cue_bg.png"

    property string imgArrowUp: imgFolderGeneral+"ch_visual_cue_u_n.png"
    property string imgArrowDown: imgFolderGeneral+"ch_visual_cue_d_n.png"
    property string imgArrowLeft: imgFolderGeneral+"ch_visual_cue_l_n.png"
    property string imgArrowRight: imgFolderGeneral+"ch_visual_cue_r_n.png"
    property string imgWheelLeft: wheelKeyOnOff == true ? imgFolderPhoto+"photo_wheel_zoom_l_n.png" : ""
    property string imgWheelRight: wheelKeyOnOff == true ? imgFolderPhoto+"photo_wheel_zoom_r_n.png" : ""

    property string imgArrowUpSelected: imgFolderGeneral+"ch_visual_cue_u_s.png"
    property string imgArrowDownSelected: imgFolderGeneral+"ch_visual_cue_d_s.png"
    property string imgArrowLeftSelected: imgFolderGeneral+"ch_visual_cue_l_s.png"
    property string imgArrowRightSelected: imgFolderGeneral+"ch_visual_cue_r_s.png"
    property string imgWheelLeftFocus: wheelKeyOnOff == true ? imgFolderPhoto+"photo_wheel_zoom_l_f.png" : ""
    property string imgWheelRightFocus: wheelKeyOnOff == true ? imgFolderPhoto+"photo_wheel_zoom_r_f.png" : ""

    property string imgArrowUpDisable: imgFolderGeneral+"ch_visual_cue_u_d.png"
    property string imgArrowDownDisable: imgFolderGeneral+"ch_visual_cue_d_d.png"
    property string imgArrowLeftDisable: imgFolderGeneral+"ch_visual_cue_l_d.png"
    property string imgArrowRightDisable: imgFolderGeneral+"ch_visual_cue_r_d.png"
    property string imgWheelLeftDisable: wheelKeyOnOff == true ? imgFolderPhoto+"photo_wheel_zoom_l_d.png" : ""
    property string imgWheelRightDisable: wheelKeyOnOff == true ? imgFolderPhoto+"photo_wheel_zoom_r_d.png" : ""

    //****************************** # Key, LongKey, WheelKey pressed event #
    property string inputMode: idAppMain.inputMode;
    property bool upKeyPressed : idAppMain.upKeyPressed;
    property bool downKeyPressed : idAppMain.downKeyPressed;
    property bool rightKeyPressed : idAppMain.rightKeyPressed;
    property bool leftKeyPressed : idAppMain.leftKeyPressed;

    property bool upKeyLongPressed : idAppMain.upKeyLongPressed;
    property bool downKeyLongPressed : idAppMain.downKeyLongPressed;
    property bool rightKeyLongPressed : idAppMain.rightKeyLongPressed;
    property bool leftKeyLongPressed : idAppMain.leftKeyLongPressed;

    property bool wheelLeftKeyPressed : idAppMain.wheelLeftKeyPressed;
    property bool wheelRightKeyPressed : idAppMain.wheelRightKeyPressed

    //****************************** # VisualCue background Image #
    Image{
        id: idVisualCueBg
        x: 0; y: 0;
        source: imgVisualCueBg

        //****************************** # Arrow image #
        Image{
            id: idUp;
            x: upKeyX; y: upKeyY;
            source: arrowUpFlag == true? imgArrowUp : imgArrowUpDisable
            visible: arrowKeyOnOff == true
        }
        Image{
            id: idDown;
            x: downKeyX; y: downKeyY;
            source:  arrowDownFlag == true? imgArrowDown : imgArrowDownDisable
            visible: arrowKeyOnOff == true
        }
        Image{
            id: idLeft;
            x: leftKeyX; y: leftKeyY;
            source: arrowLeftFlag == true? imgArrowLeft : imgArrowLeftDisable
            visible: arrowKeyOnOff == true
        }
        Image{
            id: idRight;
            x: rightKeyX; y: rightKeyY
            source: arrowRightFlag == true? imgArrowRight : imgArrowRightDisable
            visible: arrowKeyOnOff == true
        }
        //****************************** # Wheel image #
        Image{
            id: idWheelLeft;
            x: wheelLeftKeyX; y: wheelLeftKeyY
            source: arrowRightFlag == true? imgWheelLeft : imgWheelLeftDisable
            visible: wheelKeyOnOff == true
        }
        Image{
            id: idWheelRight;
            x: wheelRightKeyX; y: wheelRightKeyY
            source: arrowRightFlag == true? imgWheelRight : imgWheelRightDisable
            visible: wheelKeyOnOff == true
        }
    }
    //****************************** # KeyPressed changed (Key Pressed) #
    onUpKeyPressedChanged: {
        if(upKeyPressed){
            if(arrowUpFlag == false){}
            else{state = "up"; idVisualCueBg.y = -3}
        }
        else{
            state = "";
            idVisualCueBg.y = 0
        }
    }
    onDownKeyPressedChanged: {
        if(downKeyPressed){
            if(arrowDownFlag == false){}
            else{state = "down"; idVisualCueBg.y = 3}
        }
        else{
            state = "";
            idVisualCueBg.y = 0
        }
    }
    onLeftKeyPressedChanged: {
        if(leftKeyPressed){
            if(arrowLeftFlag == false){}
            else{state = "left"; idVisualCueBg.x = -3}
        }
        else{
            state = "";
            idVisualCueBg.x = 0
        }
    }
    onRightKeyPressedChanged: {
        if(rightKeyPressed){
            if(arrowRightFlag == false){}
            else{state = "right"; idVisualCueBg.x = 3}
        }
        else{
            state = "";
            idVisualCueBg.x = 0
        }
    }

    //****************************** # KeyPressed changed (Wheel Key Pressed) #
    onWheelLeftKeyPressedChanged:{
        if(wheelLeftKeyPressed){
            if(wheelLeftFlag == false){}
            else{state = "wheelLeft"; }
        }
        else{ state = ""; }
    }
    onWheelRightKeyPressedChanged:{
        if(wheelRightKeyPressed){
            if(wheelRightFlag == false){}
            else{state = "wheelRight"; }
        }
        else{ state = ""; }
    }

    //****************************** # LongKeyPressed changed (Long Key Pressed) #
    onUpKeyLongPressedChanged:{
        if(upKeyLongPressed){
            if(arrowUpFlag == false){}
            else{state = "up"; idVisualCueBg.y = -3}
        }
        else{
            state = "";
            idVisualCueBg.y = 0
        }
    }
    onDownKeyLongPressedChanged:{
        if(downKeyLongPressed){
            if(arrowDownFlag == false){}
            else{state = "down"; idVisualCueBg.y = 3}
        }
        else{
            state = "";
            idVisualCueBg.y = 0
        }
    }
    onLeftKeyLongPressedChanged:{
        if(leftKeyLongPressed){
            if(arrowLeftFlag == false){}
            else{state = "left"; idVisualCueBg.x = -3}
        }
        else{
            state = "";
            idVisualCueBg.x = 0
        }
    }
    onRightKeyLongPressedChanged:{
        if(rightKeyLongPressed){
            if(arrowRightFlag == false){}
            else{state = "right"; idVisualCueBg.x = 3}
        }
        else{
            state = "";
            idVisualCueBg.x = 0
        }
    }
    //****************************** # TouchMode #
    onInputModeChanged:{
        if(inputMode == "touch") idVisualCue.state = "touchMode"
    }

    //****************************** # state #
    states: [
        State { name:"up";          PropertyChanges {target: idUp;          source: imgArrowUpSelected;} },
        State { name:"down";        PropertyChanges {target: idDown;        source: imgArrowDownSelected;} },
        State { name:"left";        PropertyChanges {target: idLeft;        source: imgArrowLeftSelected;} },
        State { name:"right";       PropertyChanges {target: idRight;       source: imgArrowRightSelected;} },
        State { name:"wheelLeft";   PropertyChanges {target: idWheelLeft;   source: imgWheelLeftFocus;} },
        State { name:"wheelRight";  PropertyChanges {target: idWheelRight;  source: imgWheelRightFocus;} },
        State { name:"touchMode";
            PropertyChanges { target: idUp;         source: imgArrowUpDisable; }
            PropertyChanges { target: idDown;       source: imgArrowDownDisable; }
            PropertyChanges { target: idLeft;       source: imgArrowLeftDisable; }
            PropertyChanges { target: idRight;      source: imgArrowRightDisable; }
        }
    ]

    Connections{
        target: idAppMain
        onDownKeyLongListDownOperation:{
            if((idAppMain.state == "AppRadioOptionMenu") || (idAppMain.state == "AppRadioOptionMenuSub") || (idAppMain.state == "AppRadioListMenu") || (idAppMain.state == "AppRadioEPGMenu"))
                return;

            if(bDownLong)
            {
                state = "down";
                idVisualCueBg.y = 3
            }
            else
            {
                state = "";
                idVisualCueBg.x = 0
            }
        }
    }
}
