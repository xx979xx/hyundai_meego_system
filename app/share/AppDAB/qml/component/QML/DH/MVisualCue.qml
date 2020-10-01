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
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

FocusScope {
    id: idVisualCue
    x: 0; y: 0; z: 1   

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Property # 
    property bool lastItemOfListFlag: false;
    property bool arrowUpFlag: true     //# Key normal or disable
    property bool arrowDownFlag: true
    property bool arrowLeftFlag: true
    property bool arrowRightFlag: true

    property int upKeyX: 22 + 31
    property int upKeyY: 27
    property int downKeyX: 22 + 31
    property int downKeyY: 27 + 31 + 34
    property int leftKeyX: 22
    property int leftKeyY: 27 + 31
    property int rightKeyX: 22 + 31 + 34
    property int rightKeyY: 27 + 31

    //****************************** # VisualCue Image (normal/selected/focus/disable) #
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderPhoto: imageInfo.imgFolderPhoto

    property string imgVisualCueBg: imgFolderGeneral+"menu_visual_cue_bg.png"

    property string imgArrowUp: imgFolderGeneral+"ch_visual_cue_u_n.png"
    property string imgArrowDown: imgFolderGeneral+"ch_visual_cue_d_n.png"
    property string imgArrowLeft: imgFolderGeneral+"ch_visual_cue_l_n.png"
    property string imgArrowRight: imgFolderGeneral+"ch_visual_cue_r_n.png"

    property string imgArrowUpSelected: imgFolderGeneral+"ch_visual_cue_u_s.png"
    property string imgArrowDownSelected: imgFolderGeneral+"ch_visual_cue_d_s.png"
    property string imgArrowLeftSelected: imgFolderGeneral+"ch_visual_cue_l_s.png"
    property string imgArrowRightSelected: imgFolderGeneral+"ch_visual_cue_r_s.png"

    property string imgArrowUpDisable: imgFolderGeneral+"ch_visual_cue_u_d.png"
    property string imgArrowDownDisable: imgFolderGeneral+"ch_visual_cue_d_d.png"
    property string imgArrowLeftDisable: imgFolderGeneral+"ch_visual_cue_l_d.png"
    property string imgArrowRightDisable: imgFolderGeneral+"ch_visual_cue_r_d.png"

    //****************************** # Key, LongKey pressed event #
    property string inputMode: idAppMain.inputMode;
    property bool upKeyPressed : idAppMain.upKeyPressed;
    property bool downKeyPressed : idAppMain.downKeyPressed;
    property bool rightKeyPressed : idAppMain.rightKeyPressed;
    property bool leftKeyPressed : idAppMain.leftKeyPressed;

    property bool upKeyLongPressed : idAppMain.upKeyLongPressed;
    property bool downKeyLongPressed : idAppMain.downKeyLongPressed;
    property bool rightKeyLongPressed : idAppMain.rightKeyLongPressed;
    property bool leftKeyLongPressed : idAppMain.leftKeyLongPressed;

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
        }
        Image{
            id: idDown;
            x: downKeyX; y: downKeyY;
            source:  arrowDownFlag == true? imgArrowDown : imgArrowDownDisable    
        }
        Image{
            id: idLeft;
            x: leftKeyX; y: leftKeyY;
            source: arrowLeftFlag == true? imgArrowLeft : imgArrowLeftDisable    
        }
        Image{
            id: idRight;
            x: rightKeyX; y: rightKeyY
            source: arrowRightFlag == true? imgArrowRight : imgArrowRightDisable
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
            if((arrowDownFlag == false) && (lastItemOfListFlag == true)){}
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
        State { name:"touchMode";
            PropertyChanges { target: idUp;         source: imgArrowUpDisable; }
            PropertyChanges { target: idDown;       source: imgArrowDownDisable; }
            PropertyChanges { target: idLeft;       source: imgArrowLeftDisable; }
            PropertyChanges { target: idRight;      source: imgArrowRightDisable; }
        }
    ]   
}
