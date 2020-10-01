import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0

MComp.MComponent{
    id:idASDMain
    x:0
    y:0
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea

    function setInitialASD(){
        if( UIListener.getASDvalue()  == 1 ){
            return 0
        }
        else if( UIListener.getASDvalue() == 2 ){
            return 1
        }
        else
            return 2
    }

    //property int currentASDMode: UIListener.getASDvalue() //0

    Component.onCompleted:{

    }

    Text{
        width: 200
        height: 60
        x:0
        y:20
        text: "ASD"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        verticalAlignment: "AlignVCenter"
    }
    MComp.Spinner{
        x:200; y:20
        id: asdMode
        focus: true
        aSpinControlTextModel: asd_textModel
        currentIndexVal: setInitialASD()//currentASDMode

        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            softwareBand
        }
        onSpinControlValueChanged: {

            if(curVal == 0){
                UIListener.NotifyASDChanged(1);
            }
            else if(curVal == 1){
                UIListener.NotifyASDChanged(2);
            }
            else if(curVal == 2){
                UIListener.NotifyASDChanged(0);
            }

        }

    }
    ListModel{
        id:asd_textModel
        property int count: 3
        ListElement{name:"On";}
        ListElement{ name: "Moderate"; }
        ListElement{ name: "Off"; }

    }

    Image{
        x:20
        y:100
        source: imgFolderGeneral+"line_menu_list.png"
    }
}

