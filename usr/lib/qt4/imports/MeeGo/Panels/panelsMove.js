var middlePanel;
var panelWidth;
var panelWidthAndSpacing;

var scrollMarginSize;
var scrollMarginXL;
var scrollMarginXR;
var scrollAmount;

var origPanelX;
var startingMouse;
var middlePanelOffset;
var enableScrollRight;


function startDrag(mouse)
{
    origPanelX = flipablePanel.x
    startingMouse = mouse.x;
    panelWidth = flipablePanel.width;
    panelWidthAndSpacing = panelWidth + allPanels.spacing;
    middlePanel = panelWidth/2;
    middlePanelOffset = mouse.x - middlePanel;


    scrollMarginSize = allPanels.width/10;
    scrollMarginXL = scrollMarginSize;
    scrollMarginXR = allPanels.width - scrollMarginSize;
    scrollAmount = scrollMarginSize/2;

//    console.log("Dragging panel " + flipablePanel.parent.aDisplayName + ", curIdx: " + flipablePanel.parent.aIndex);
    var mousePosInWin = allPanels.mapFromItem(flipablePanel, mouse.x, mouse.y);
    //If we picked up the panel in the right 1/10th of the view, we initially
    //disable right-scrolling so we don't immediately scroll on pick-up
    if (mousePosInWin.x >= scrollMarginXR) {
        enableScrollRight = false;
    } else {
        enableScrollRight = true;
    }
}

function continueDrag(mouse)
{
    var newPanelX = (mouse.x - startingMouse) + flipablePanel.x

    var mousePosInWin = allPanels.mapFromItem(flipablePanel, mouse.x, mouse.y)


    //If scroll-right was disabled, re-enable it after we have drug (dragged?)
    //left out of the right scroll area
    if ((!enableScrollRight) && (mousePosInWin.x < scrollMarginXR))
        enableScrollRight = true;

    var newX = allPanels.contentX;
    if (mousePosInWin.x < scrollMarginXL){
        newX -=  scrollAmount;
    } else if (((mousePosInWin.x > scrollMarginXR) && (enableScrollRight)) ||
               ((!enableScrollRight) && (mousePosInWin.x >= allPanels.width))) {
        //If the touch point has moved to > the right scroll margin, or
        //If right scroll was disabled (due to picking up the panel in the
        //right scroll margin), but the user has moved their touch beyond the
        //right edge of the view (as that must indicate that they actually *do*
        //want to scroll right...), then scroll right
        newX += scrollAmount;
    }

    //Don't scroll the content view < 0, or beyond the last panel + .5 panel
    if (newX < 0)
        newX = 0;
    else if (newX > (allPanels.contentWidth - middlePanel)) {
        newX = allPanels.contentWidth - middlePanel;
    }
    //If we're dragging the last panel, don't scroll beyond what is sane
    if ((flipablePanel.parent.aIndex >= (allPanels.count - 1)) &&
            (newX > (allPanels.contentWidth - allPanels.width))) {
        newX = allPanels.contentWidth - allPanels.width;
    }

    allPanels.contentX = newX;

    //console.log("starting newPanelX: " + newPanelX);
    //If the user is dragging left on the very first panel, don't allow it.
    if ((newPanelX < 0) && (flipablePanel.parent.aIndex == 0))
        newPanelX = 0;

//    console.log("newPanelX after 1st test: " + newPanelX);

    //Don't allow the panel to go beyond the last available panel position + .5
    var maxX = ((allPanels.count-1) * panelWidthAndSpacing) + middlePanel;
    //If we're dragging the last panel, don't allow the extra .5 panel width
    if (flipablePanel.parent.aIndex >= (allPanels.count - 1))
        maxX -= middlePanel;
    if (newPanelX > maxX)
        newPanelX = maxX;

//    console.log("newPanelX final: " + newPanelX);
    flipablePanel.x = newPanelX;
}

function endDrag(mouse)
{
    var oldIndex = flipablePanel.parent.aIndex;
    var newIndex = 0;

    if (flipablePanel.x > 0) {
	 newIndex = Math.floor(flipablePanel.x/panelWidthAndSpacing);
    } else {
	 newIndex = Math.ceil(flipablePanel.x/panelWidthAndSpacing);
    }

    //console.log("index change: " + newIndex);
    newIndex = oldIndex + newIndex;
    //console.log("newIndex: " + newIndex);


    //console.log("curFP.x: " + flipablePanel.x + ", panelWidthAndSpacing: " + panelWidthAndSpacing);
    //console.log ("oldIndex: " + oldIndex + ", newIndex: " + newIndex + ", curFP.x: " + flipablePanel.x + ", origFP.x: " + origPanelX)
    if (oldIndex == newIndex)
        flipablePanel.x = origPanelX;
    //console.log("curFP.x: " + flipablePanel.x);
    if (newIndex < 0)
        newIndex = 0;

    flipablePanel.draggingFinished(oldIndex, newIndex)
    if (newIndex >= allPanels.count-1)
        allPanels.contentX = allPanels.contentWidth - allPanels.width
}

