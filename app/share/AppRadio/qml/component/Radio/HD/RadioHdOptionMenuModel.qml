/**
 * FileName: RadioOptionMenuModel.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7

ListModel {
    id: idRadioHdOptionMenuModel

    ListElement { name: "HD Radio"; opType: "dimCheck"}
    //ListElement { name: "Tagging"; opType: ""}
    ListElement { name: "Auto Store";opType: ""}
    ListElement { name: "Save as Preset";opType: ""}
    ListElement { name: "Edit Preset Order";opType: ""}
    ListElement { name: "Preset Scan";opType: ""}
    ListElement { name: "All Channel Scan";opType: ""}
    //ListElement { name: "Scan";opType: "subMenu"}
    ListElement { name: "Radio Text"; opType: "dimCheck"} //"Info"
    ListElement { name: "Sound Setting";opType: ""}

}
