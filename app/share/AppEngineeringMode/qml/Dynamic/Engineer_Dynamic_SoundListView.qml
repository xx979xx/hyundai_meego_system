import QtQuick 1.0
import "../System" as MSystem
import "../Component" as MComp
MComp.MComponent {
    id:idDTCListView

    focus:true

    ListModel{
        id:idDynamicSoundData

        ListElement {   name:"Bass/Mid/Treble"; nextname:   "Balance/Fader"}
        ListElement {   name:"Variable EQ";  nextname:   "AVC"   }
        ListElement {   name:"Surround"; nextname:   "Beep"   }
        ListElement {   name: "Sound Ratio"    ; nextname:   "Quantum"  }
        ListElement {   name: "Power Bass"    ; nextname:   "Welcoming"  }

    }
    ListView{
        x:18; y:150;
        id:idDynamicSoundView
        opacity:  1
        clip:  true
        focus:  true
        anchors.fill: parent
        model:idDynamicSoundData
        delegate: Engineer_DynamicSoundDelegate{
            onWheelLeftKeyPressed:idDynamicSoundView.decrementCurrentIndex()
            onWheelRightKeyPressed: idDynamicSoundView.incrementCurrentIndex()
        }
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
    }
    //--------------------- ScrollBar #
    MComp.MScroll {
        property int  scrollWidth: 13
        property int  scrollY: 5
        x:systemInfo.lcdWidth -50; y: scrollY; z:1
        scrollArea: idDynamicSoundView;
        height: idDynamicSoundView.height-(scrollY*2)-20; width: scrollWidth
        //anchors.right: idHeadUnitView.right
        visible: true
    } //# End MScroll

}
