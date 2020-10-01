import Qt 4.7
import "../Component" as MComp
import "../System" as MSystem
import com.engineer.data 1.0

MComp.MComponent {
    id: idAppEngineerPinCodeChange
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus:true
    property string changeLockNum:""
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property alias bandBackKey:  passwordBand.backKeyButton //added for Password UpKeyPress Issue

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
    }

    //added for BGFG structure
    Connections{
        target: UIListener
        onHideGUI:{
            if(isMapCareMain)
            {
                if(isMapCareEx)
                {
                    console.log("[QML] Password : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                }
                else
                {
                    console.log("[QML] Password : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                }


            }

            console.log("[QML] Password : onHideGUI --");
            isMapCareMain = false
            mainViewState="Main"
            setMainAppScreen("", true)
        }
    }
    //added for BGFG structure

    //    Image{
    //        id:bgImg
    //        width: systemInfo.lcdWidth
    //        height: systemInfo.lcdHeight
    //        y:-systemInfo.modeAreaHeight
    //        source:imgFolderGeneral+"bg.png"
    //    }

    //    MouseArea{
    //        anchors.fill: parent
    //        Rectangle{


    //        }
    //    }

    //--------------- PinCodeChange Band #
    MComp.MBand{
        id:passwordBand
        titleText: isMapCareMain ? qsTr("Dealer Mode") : qsTr("Engineering Mode")
        onBackKeyClicked:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    console.log("[QML] Password  : onBackKeyClicked -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    console.log("[QML] Password  : onBackKeyClicked -----------")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                //added for BGFG structure
            }
            else
            {
                mainViewState="Main"
                setMainAppScreen("", true)
            }
        }//added for Password UpKeyPress Issue
        onDownKeyPressed: {
            console.log("[QML] passwordBand  : onDownKeyPressed -----------")
            //idVisualCue.setVisualCue(true, false, false, true) //top, right, bottom, left
            idAppEngineerPinCodeKeypad.focus = true
            idAppEngineerPinCodeKeypad.forceActiveFocus()

        }
    }
    Text{
        x:280
        y:215-systemInfo.statusBarHeight-16
        text: "Please enter 4-digit Password number"
        horizontalAlignment: "AlignHCenter"
        width:66+151+151+151+201
        color:colorInfo.brightGrey;
        font{pixelSize:32; family:"HDB"}
    }

    //--------------------- Keypad #
   AppEngineer_PinCodeKeypad {
        id: idAppEngineerPinCodeKeypad
        x:280; y: 215-90
        focus: true
    }
    onBackKeyPressed: {
        if(isMapCareMain)
        {
            //added for BGFG structure
            if(isMapCareEx)
            {
                console.log("[QML] Password  : onBackKeyClicked -----------")
                mainViewState = "MapCareMainEx"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            else
            {
                console.log("[QML] Password  : onBackKeyClicked -----------")
                mainViewState = "MapCareMain"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            //added for BGFG structure
        }
        else
        {
            mainViewState="Main"
            setMainAppScreen("", true)
        }


    }
}  // End Item

