import Qt 4.7
import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent {
    id:delegate
    //    x: 18; //y:200
    width:100; height: 240

    MSystem.ColorInfo { id:colorInfo }

    Rectangle{
        id:idDTCfirstData
//        x:0; y:20
        width:600 ; height: 50
        color:colorInfo.transparent
        border.color : colorInfo.buttonGrey
        border.width : 2
        //anchors.verticalCenter: parent.verticalCenter

        //**************************************** ENG Data Name Text
        MComp.Label{
            id: idDTCfirstValue
            anchors.fill: parent
            //x: 20
            text: modelData
            fontColor: colorInfo.dimmedGrey
            fontSize: 23
            txtAlign: "Left"
            fontName: "HDR"
        }
    }
//    Rectangle{
//        id:idDTCInfoData
//        x:120; y:0
//        width:400 ; height: 60
//        color:colorInfo.transparent
//        border.color : colorInfo.buttonGrey
//        border.width : 2
//        //anchors.verticalCenter: parent.verticalCenter

//        //**************************************** ENG Data Name Text
//        MComp.Label{
//            id: idDTCInfoValue
//            anchors.fill: parent
//            //x: 20
//            text: modelData
//            fontColor: colorInfo.dimmedGrey
//            fontSize: 26
//            txtAlign: "Center"
//            fontName: "HDR"
//        }
//    }
}


