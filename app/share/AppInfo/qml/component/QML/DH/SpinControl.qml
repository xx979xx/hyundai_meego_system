import QtQuick 1.0

import "../../system/DH" as MSystem

Item {
    id:container
    width: parent.width+75+75; height: itemHeight

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id: imageInfo }

    property string imgFolderSettings : imageInfo.imgFolderSettings
    property string bgImage: imgFolderSettings+"bg_info_switch.png"
    property string bgImageToggle: imgFolderSettings+"info_switch.png"
    property int itemWidth: 441+81*2
    property int itemHeight: 68
    property int itemCount:spinnerModel.count
    property string selectedItemName;

    property QtObject spinnerModel

    ListView {
        id: spinListView
        model: spinnerModel
        preferredHighlightBegin: 0; preferredHighlightEnd: 0
        highlightRangeMode: ListView.StrictlyEnforceRange
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem; flickDeceleration: 3000
        highlightMoveSpeed :3000
        currentIndex: 0
        delegate: SpinDelegate {}
    } // End ListView

//    Connections{
//        target: UIListener
//        onRetranslateUi:{
//            console.log("[QML] SpineListView retranslateUi");
//            console.log("Count: " + idDmbDisasterTabListView.count);
//            for(var i = 0; i < spinListView.count; i++)
//            {
//                console.log("["+i+"]:" + idDmbDisasterTabListView.model.get(i).name);
//                switch(i){
//                case 0:{
//                    spinListView.model.get(i).name = stringInfo.
//                    break;
//                }
//                case 1:{
//                    spinListView.model.get(i).name = stringInfo.strDmbDis_SortType_Area
//                    break;
//                }
//                case 2:{
//                    spinListView.model.get(i).name = stringInfo.strDmbDis_SortType_Priority
//                    break;
//                }
//                default:
//                    break;
//                }
//            } // End for
//        } // End onRetranslateUi
//    } // End Connections
} // End Item
