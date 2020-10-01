/**
 * FileName: MDimCheck.qml
 * Author: WSH
 * Time: 2012-03-08
 *
 * - 2012-03-08 Modified by WSH
 */
import QtQuick 1.0

MComponent {
    id: idDimCheck
    x: iconX; y: iconY
    width: 45; height: 45
    anchors.verticalCenter: parent.verticalCenter

    //--------------------- Active Info(Property) ##
    property bool flagToggle: (state=="on")? true : false

    //--------------------- Icon Info(Property) ##
    property int iconX: 0
    property int iconY: 0
    property string bgImage: imgFolderGeneral+"ico_check_n.png"
    property string bgImageSelected : imgFolderGeneral+"ico_check_s.png"
    property string bgImageDisabled : imgFolderGeneral+"ico_check_d.png" // JSH 130527

    //--------------------- Image Path Info(Property) #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    //--------------------- (signal) #
    signal dimUnchecked()
    signal dimChecked()

    //--------------------- Click Event(Function) #
    onClickOrKeySelected: { if(!idDimCheck.dimmed) toggle() }

//KSW 140613 delete mouseArea
//    //KSW 131129 [ITS][211424]
//    MouseArea {
//        id:mouseArea
//        anchors.fill: parent
//        property bool isExited : false
//        onPressAndHold: {
//            //console.log("#### onPressAndHold mEnabled ="+mEnabled +"pressCancel = "+pressCancel);
//            pressAndHoldFlag = true
//            if(!mEnabled || pressCancel) return;
//            idDimCheck.pressAndHold(idDimCheck.target, idDimCheck.buttonName);
//            idAppMain.returnToTouchMode();
//        }
//        onReleased: {
//            //console.log("#### mouseArea.containsMouse ="+mouseArea.containsMouse +" isExited = "+isExited);
//            if((mouseArea.containsMouse == true) && (!isExited)){
//                pressAndHoldFlag    = false;
//                if(!mEnabled || pressCancel) return;
//                idDimCheck.clicked(idDimCheck.target, idDimCheck.buttonName);
//                playBeepOn = true;     // JSH 130404
//                //console.log("############################  touch - 1before signal");
//                idAppMain.enterType = 0;
//                clickOrKeySelected(0);
//                //console.log("############################  touch - 1after signal");
//            }
//            clickReleased();
//        }
//        onMousePositionChanged: {
//            //console.log("############################  touch - onMousePositionChanged????? mEnabled" + mEnabled);
//            if(!mEnabled || pressCancel){
//                //console.log("[CHECK_11_14_DRAG] : Mouse pressCanceled " + pressCancel );
//                return;
//            }
//            ////
//            mousePosChanged(mouseX,mouseY); // JSH 121121
//        }
//        onPressed: { //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)
//            idAppMain.returnToTouchMode(); // JSH 130624
//            console.log("############################  touch - 1onPressed?????z");
//            pressedForFlickable(mouseX,mouseY);
//            isExited            = false; // JSH 130717
//            pressAndHoldFlag    = false;
//            pressCancel         = false; // JSH 130906
//        }
//        onExited: { // JSH 130717
//            //console.debug("############################  touch - 1onExited?????")
//            if(!mouseArea.pressed)
//                return;

//            isExited = true ;
//            cancel();
//        }
//        onCanceled :{
//            //console.debug("1onCanceled ???");
//            cancel();
//        }

//    }

    function toggle() {
        if (idDimCheck.state == "on"){
            idDimCheck.state = "off";
            dimUnchecked();
        }
        else if(idDimCheck.state == "off"){
            idDimCheck.state = "on";
            dimChecked();
        } // End if
        idAppMain.playBeep(); // JSH 130925 ISV Issue
    } // End function

    //-------------------- View the background
    Image {
        id: imgDimCheckOff
        source: (mEnabled) ? bgImage : bgImageDisabled // JSH 130527
    } // End Image

    //-------------------- View the Button
    Image {
        id: imgDimCheckOn
        source: bgImageSelected
        visible: false
    } // End Image

    states: [
        State { name: "on" ; PropertyChanges { target: imgDimCheckOn; visible: true } },
        State { name: "off"; PropertyChanges { target: imgDimCheckOn; visible: false } }
    ]
} // End MComponent
