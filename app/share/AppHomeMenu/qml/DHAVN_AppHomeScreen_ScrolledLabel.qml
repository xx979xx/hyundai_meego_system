import QtQuick 1.1
import QmlHomeScreenDefPrivate 1.0

Item
{
   id: scrolledLabel

   property int nTextWidth: firstText.paintedWidth +
                            EHSDefP.AV_SCROLLED_LABEL_SECOND_TEXT_LO +
                            secondText.paintedWidth

   height: firstText.height
   clip: true

   Text
   {
      id: firstText

      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left

      font.family: EngineListener.getFont(true)
      font.pointSize: EHSDefP.AV_SCROLLED_LABEL_FIRST_TEXT_PIXEL_SIZE
      color: HM.const_COLOR_BRIGHT_GREY
      horizontalAlignment: Qt.AlignLeft
   }

   Text
   {
      id: secondText

      anchors.verticalCenter: parent.verticalCenter
      anchors.verticalCenterOffset: EHSDefP.AV_SCROLLED_LABEL_SECOND_TEXT_VCO
      anchors.left: firstText.right
      anchors.leftMargin: EHSDefP.AV_SCROLLED_LABEL_SECOND_TEXT_LO

      font.family: EngineListener.getFont(true)
      font.pointSize: EHSDefP.AV_SCROLLED_LABEL_SECOND_TEXT_PIXEL_SIZE
      color: HM.const_COLOR_DIMMED_GREY
      horizontalAlignment: Qt.AlignLeft
   }

   SequentialAnimation
   {
      id: anim

      loops: Animation.Infinite
      running: ( scrolledLabel.nTextWidth > scrolledLabel.width );

      PauseAnimation{ duration: EHSDefP.AV_SCROLLED_LABEL_ANIMATION_PAUSE; }

      NumberAnimation
      {
         target: firstText
         property: "anchors.leftMargin"
         from: 0
         to: scrolledLabel.width - scrolledLabel.nTextWidth
         duration: ( scrolledLabel.nTextWidth / scrolledLabel.width ) * EHSDefP.AV_SCROLLED_LABEL_ANIMATION_DURATION_DELTA

         onCompleted: __LOG();
      }

      PauseAnimation{ duration: EHSDefP.AV_SCROLLED_LABEL_ANIMATION_PAUSE; }

      NumberAnimation
      {
         target: firstText
         property: "anchors.leftMargin"
         from: scrolledLabel.width - scrolledLabel.nTextWidth
         to: 0
         duration: ( scrolledLabel.nTextWidth / scrolledLabel.width ) * EHSDefP.AV_SCROLLED_LABEL_ANIMATION_DURATION_DELTA
      }
   }

   function setText( sText1, sText2 )
   {
      firstText.text = sText1
      secondText.text = sText2

      anim.stop();
      firstText.anchors.leftMargin = 0;
      anim.running = ( scrolledLabel.nTextWidth > scrolledLabel.width );
   }
}
