
import Qt 4.7
import QmlSimpleItems 1.0
import com.engineer.data 1.0


import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
MComp.MComponent
{
    id:idLogmain

    width: 1280
    height: 720
    clip:true
    focus: true

    y:0

    function setRightMenuScreen(index, save){
        MOp. setLogMain(index, save)
    }
    Component.onCompleted:{

        setRightMenuScreen(0, true)
    }
    MComp.MBand{
        y:parent.y
        titleText: qsTr("Engineering Mode > Log Setting")
        onBackKeyClicked: {
            mainViewState="Main"
            setMainAppScreen("", true)
            mainViewState = "AutoTest"
            setMainAppScreen("AutoTest", false)
        }
        subBtnFlag: true
        subBtnFlag1: true
        subBtnFlag2: true
        logSaveBtnFlag: true
        subKeyText: "App List 3"
        subKey2Text: "App List 2"
        subKey1Text: "App List 1"
        logSaveKeyText: "Disable Log"
        bandSubButtonWidth: 150
        bandSub1ButtonWidth: 150
        bandSub2ButtonWidth: 150
        bandSubButtonTextSize: 23
        bandSub1ButtonTextSize: 23
        bandSub2ButtonTextSize: 23
        bandSubButtonfirstTextX: 0
        bandSubButtonfirstTextWidth: 150
        onSubKeyClicked: {
            setRightMenuScreen(2, true)
        }
        onSubKey1Clicked: {
            setRightMenuScreen(0, true)
        }
        onSubKey2Clicked: {
            setRightMenuScreen(1, true)
        }
        onLogSaveKeyClicked: {
//            UpgradeVerInfo.copyLogFileToUSB()
            LogSettingData.DisableAllLog();

        }
    }
    onBackKeyPressed: {
        mainViewState="Main"
        setMainAppScreen("", true)
        mainViewState = "AutoTest"
        setMainAppScreen("AutoTest", false)
    }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }

  MComp.MComponent{
      id:idLogSystemList
      y:69

      Loader{ id:idAppList1Loader   }
      Loader{   id:idAppList2Loader }
      Loader{   id:idAppList3Loader }
      Loader{   id:idAppList4Loader }
      Loader{   id:idAppList5Loader }

  }
  Engineer_LogSavePopUp{
      id:idENGSaveLogPopUp
      y:0; z:100
      visible: false
      onVisibleChanged: {

      }

  }



}








