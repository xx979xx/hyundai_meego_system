/**
 * FileName: MFocusScope.qml
 * Author: David Bae
 * Time: 2011-10-27 14:58
 *
 * - 2011-10-26 Initial Crated by David Bae
 */
import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

FocusScope {
    id: container

    function goingToHere()
    {
        container.focus = true;
        parent.goingToHere();
    }

    property int debugOnOff: idAppMain.debugOnOff;
}
