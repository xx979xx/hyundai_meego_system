import QtQuick 1.1
import "../system" as MSystem

MComponent {
    enableClick: false;

    MSystem.SystemInfo { id: systemInfo }

    Component.onCompleted: {
        UIListener.SendAutoTestSignal(); //For AutoTest
    }

    //BG rectangle image
    Image {
        x:0; y:0
        width: 128; height: 132
        source : systemInfo.imageInternal + "bg_car_status_info.png"
        z:1

    }

    // Car Icons
    Image {
        x:0; y:0
        width: 128; height: 132
        source : (canDB.CarStatusNo)? systemInfo.imageInternal + "icon_car_status_info_" + canDB.CarStatusNo + ".png" : ""
        z:2
    }

    // Mirror Icons
    Image {
        id: idMirrorLImg
        x: 2; y: 5
        width:  53; height:  46
        source : (canDB.IsMirrorFold)? systemInfo.imageInternal + "ico_mirror_l.png" : ""
        z:3
    }
    Image {
        x: 2+72; y: 5
        width:  53; height:  46
        source : (canDB.IsMirrorFold)? systemInfo.imageInternal + "ico_mirror_r.png" : ""
        z:3
    }

}
