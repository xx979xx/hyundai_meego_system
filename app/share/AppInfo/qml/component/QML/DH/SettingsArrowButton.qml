import Qt 4.7

import "../../system/DH" as MSystem

MComponent {
    id: btnArrow
    x: 0 ; y: 0; z: 1
    focus: true
    width: parent.width; height: parent.height
    anchors.verticalCenter: parent.verticalCenter

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }

    property int btnX: 1195-422-33
    property int btnY: idtiteText.height //6
    property string titleText: ""
    property string onImg: imgFolderSettings+"btn_arrow_open.png"
    property string offImg: imgFolderSettings+"btn_arrow_close.png"
    property int titleState: 0 // off-0 , on-1
    property int btnState: 0 // off-0 , on-1
    property string imgFolderSettings: imageInfo.imgFolderSettings

    function toggle(_btnState){
        if (_btnState==0) { btnState=1 }
        else { btnState=0 }
    } // End function

    //--------------------- Title Label #
    Text {
        id: idtiteText
        text: titleText
        color: (titleState==0) ? colorInfo.disableGrey : colorInfo.brightGrey
        font.pixelSize: 40
        font.family: "HDR"
        anchors.verticalCenter: parent.verticalCenter
    }

    //-------------------- Arrow Image(default) #
    Image {
        id: imgArrow
        x: btnX; y: btnY
        source: (btnState==0) ? offImg : onImg
    }

    //--------------------- Focus Image #
    Image {
        id:idFocusImage5
        x: -30; y: btnArrow.y+24; z: 1
        width: btnArrow.width-20; height: btnArrow.height+12
        source: (btnArrow.activeFocus)? imgFolderSettings + "line_list_l_f.png":""
    } // End Image

    onClickOrKeySelected: {
        console.log("btnArrow_onClickOrKeySelected")
    }
} // End MComponent
