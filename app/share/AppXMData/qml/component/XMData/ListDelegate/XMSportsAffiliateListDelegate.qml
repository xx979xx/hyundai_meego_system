/**
 * FileName: XMSportsAffiliateListDelegate.qml
 * Author: David.Bae
 * Time: 2012-06-04 09:59
 *
 * - 2012-06-04 Initial Created by David
 */

import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData

XMDataSmallTypeListDelegate{
    id: idListItem

    //Signal
    signal affiliateSelected(int leagueId, int aID, int sID, string aName);

    Text {
        id: idText
        x: /*idBrandIcon.x+idBrandIcon.width+23*/47; y: /*12*/17+27-font.pixelSize/2;
        width: 845; height: 40
        text: affiliateName
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide:Text.ElideRight
        MXData.XMRectangleForDebug{}
    }

    onClickOrKeySelected: {
        if(pressAndHoldFlag == false)
        {
            if(playBeepOn)
                UIListener.playAudioBeep();
            ListView.view.currentIndex = index;
            affiliateSelected(leagueID, affiliateID, sportID, affiliateName);
        }
    }
}
