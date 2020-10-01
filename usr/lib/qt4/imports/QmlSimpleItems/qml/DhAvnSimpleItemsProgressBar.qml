import Qt 4.7

Image
{
   id: progressBar

   property string bg: ""
   property string fg: ""
   property int nMaxValue: 1
   property int nCurrentValue: 1

   property double delta: progressBar.width / progressBar.nMaxValue

   source: progressBar.bg

   Image
   {
      anchors.top: parent.top
      anchors.left: parent.left

      width: progressBar.delta * progressBar.nCurrentValue

      source: progressBar.fg
   }
}
