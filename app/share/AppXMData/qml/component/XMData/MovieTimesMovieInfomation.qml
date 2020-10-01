/**
 * FileName: XMDataSubscriptionStatus.qml
 * Author: David.Bae
 * Time: 2012-04-27 15:20
 *
 * - 2012-04-27 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp

MComp.MComponent{
    id:container
    property string textTitle : "";
    property string pgText : "";
    property string hourText : "";
    property string descriptionText:"";
    property string actorText:"";//for Actors Name
    focus: true;


    MComp.MPopupTypeXMDataEPG{
        id: idMovieInfoPopup

        popupBtnCnt: 1

        popupFirstText: textTitle
        imgPath: getGradeBgImage()
        gradeText: getGradeText()
        popupSecondText: hourText
        popupFourthText: actorText//for Actors Name
        popupThirdText: descriptionText
        popupFirstBtnText: stringInfo.sSTR_XMDATA_OK

        onPopupFirstBtnClicked: {
            close();
        }
    }

    function getGradeBgImage()
    {
        if(pgText === "NC-17"){
            return imageInfo.imgFolderXMData + "ico_grade_r.png";
        }else if(pgText === "R"){
            return imageInfo.imgFolderXMData + "ico_grade_b.png";
        }else if(pgText === "G"){
            return imageInfo.imgFolderXMData + "ico_grade_g.png";
        }else if(pgText === "PG-13"){
            return imageInfo.imgFolderXMData + "ico_grade_g.png";
        }else if (pgText === "PG"){
            return imageInfo.imgFolderXMData + "ico_grade_g.png";
        }else if(pgText === "Unrated"){
            return imageInfo.imgFolderXMData + "ico_grade_grey.png";
        }
        return imageInfo.imgFolderXMData + "ico_grade_g.png";
    }

    function getGradeText()
    {
        if(pgText === "G" || pgText === "PG-13" || pgText === "NC-17" || pgText === "PG"
            || pgText === "R" || pgText === "Unrated"){
            return pgText;
        }
        else
            return "";
    }

    function close(){
        parent.hide();
    }

    Connections{
        target:UIListener
        onTemporalModeMaintain:{
            if(!mbTemporalmode)
            {
                if(visible)
                    close();
            }
        }

        onSignalShowSystemPopup:{
            console.log("onSignalShowSystemPopup")
            if(visible)
                close();
        }
    }

}
