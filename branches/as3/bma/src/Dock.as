/**
* ...
* @author Default
* @version 0.1
*/

package {
	
	import flash.display.*
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.Equations;
	
	public class Dock extends MovieClip{
		
		var idle:Number = 0
		
		var isActivated = false;
		var isDeactivating = false;
		
		var oldMouseX=0;
		var oldMouseY=0;
				
		var scaleSmall:Number = 0.25; // Default scale
		var scaleBig:Number = 0.5; // Scale when closer to the cursor
		var scaleFalloff:Number = 100; // Scale falloff distance, in screen pixels

		var baseX:Number = 988*.5; // Center column for the dock
		var baseY:Number = 558; // 180; // Base row for all icons

		var iconMargin:Number = 10; // Distance between the margins of the bounding box of each icon
		var assumedIconWidth:Number = 128; // Assumed icon width if scale is 1; this is used as a bounding box for the icons
		var assumedIconHeight:Number = 128; // Assumed icon height if scale is 1
		var i:Number;

		var icons ;
		var iconNames ;
		
		public var zoomedAmmount = 0; // 0 when at rest, 1 when zoomed
		var cursorPosition = undefined;
		public var dockParent
		
		public function Dock() {
			
			// Properties
			dockParent = this;
			
			icons = [dockParent.iMap, dockParent.iReport, dockParent.iHistory, dockParent.iGraph, dockParent.iStation];
			iconNames = ["Map", "Report", "History", "Graph", "Station"];	

			isActivated = false;
			
			// Finally, redraws
			this.redraw();

			for (i = 0; i < this.icons.length; i++) {
				this.icons[i].addEventListener(MouseEvent.CLICK, clickHandler);
				this.icons[i].id = this.iconNames[i]
			}
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		function redraw () {
			// Redraws every item on their new position
			

			// Redraw: icons
			var defaultCols:Array = new Array(); // Default position of each icon when at rest - its mouseover position
			var itemScales:Array = new Array(); // Final scale of each icon
			var itemCols:Array = new Array(); // New horizontal position
			var itemRows:Array = new Array(); // New verticle position
			var totalWidth:Number = 0; // Total width of whole dock

			for (i = 0; i < this.icons.length; i++) {
				// Find the default position of each icon - this could be some separately one time only... but this way is a bit more dynamic
				defaultCols[i] = baseX + ((i-((this.icons.length-1)/2)) * ((assumedIconWidth * scaleSmall) + iconMargin));

				// Find the new scale of each icon depending on the mouse position
				var distanceFraction:Number = (this.mouseX - defaultCols[i]) / scaleFalloff; // -1 to 1 depending on the distance from the cursor
				if (distanceFraction < -1 || distanceFraction > 1) {
					// Too far, normal scale
					itemScales[i] = scaleSmall;
				} else {
					// Close enough to the cursor // easeInOutQuad is also good
					itemScales[i] = Equations.easeInOutSine(1-Math.abs(distanceFraction), scaleSmall, scaleBig - scaleSmall, 1);
				}

				// Set the new horizontal position of the icon
				itemCols[i] = baseX + totalWidth + (assumedIconWidth * itemScales[i] / 2);
			
				// Increase the position "head"
				totalWidth += assumedIconWidth * itemScales[i];
				if (i < this.icons.length - 1) totalWidth += iconMargin;

				// Set the vertical position
				itemRows[i] = baseY - (assumedIconHeight * itemScales[i] / 2);
			}

			// Calculates the total icon offset for correct centering
			var minMousePos:Number = defaultCols[0] - (scaleSmall * assumedIconWidth / 2);
			var mamouseXPos:Number = defaultCols[defaultCols.length-1] + (scaleSmall * assumedIconWidth / 2);;
			var mouseFraction:Number = (this.mouseX - minMousePos) / (mamouseXPos - minMousePos);
			mouseFraction = mouseFraction < 0 ? 0 : mouseFraction > 1 ? 1 : mouseFraction;
			var restOffset:Number = totalWidth - (mamouseXPos-minMousePos);
			var iconOffset:Number = restOffset * (mouseFraction - 0.5);

			// Nudges the icons to their correct positions
			for (i = 0; i < this.icons.length; i++) {
				itemCols[i] -= iconOffset + (totalWidth/2);
			}

			var unZoomedAmmount:Number = 1-this.zoomedAmmount;

			// Finally, update the whole thing -- separated step because of the "zoomedAmmount" control
			for (i = 0; i < this.icons.length; i++) {

				var calculatedScale:Number = ((scaleSmall * unZoomedAmmount) + (itemScales[i] * this.zoomedAmmount));
				this.icons[i].scaleX = this.icons[i].scaleY = calculatedScale ;
				this.icons[i].x = (itemCols[i] * this.zoomedAmmount) + (defaultCols[i] * unZoomedAmmount);
				this.icons[i].y = baseY - (assumedIconHeight * calculatedScale / 2);
			}

			// Redraw: text
			// Crappy/cheap way to calculate. Should be a hit movieclip on the object itself.
			var closestItem:Number = -1;
			var closestDistance:Number = -1;
			for (i = 0; i < this.icons.length; i++) {
				var iDistance:Number = Math.abs(this.icons[i].x - this.mouseX);
				if ((closestItem==-1 || iDistance < closestDistance) && (iDistance < assumedIconWidth * 0.5 * scaleBig)) {
					closestDistance = iDistance;
					closestItem = i;
				}
			}
			
			dockParent.caption.text = (closestItem==-1 || !this.isActivated) ? "" : this.iconNames[closestItem];
			
			if(closestItem!=-1){
				dockParent.caption.x = this.icons[closestItem].x-dockParent.caption.width*.5
				dockParent.caption.y = this.icons[closestItem].y-this.icons[closestItem].height+5
			}
			
			// Redraw: background bar
			var barMargin:Number = 8; // Horizontal bar margin
			this.dockParent.backgroundBar.y = baseY - this.dockParent.backgroundBar.height;

			var widthZoomedIn:Number = totalWidth + (barMargin * 2);
			var widthZoomedOut:Number = (mamouseXPos - minMousePos) + (barMargin * 2);
			this.dockParent.backgroundBar.width = (widthZoomedIn * this.zoomedAmmount) + (widthZoomedOut * unZoomedAmmount);

			var positionZoomedIn:Number = baseX - iconOffset - (totalWidth/2) - barMargin;
			var positionZoomedOut:Number = baseX - (widthZoomedOut / 2);

			this.dockParent.backgroundBar.x = (positionZoomedIn * this.zoomedAmmount) + (positionZoomedOut * unZoomedAmmount);
			
		};

		function activateDock () {
			this.isActivated = true;
			this.isDeactivating = false;
			Tweener.addTween(this, {zoomedAmmount:1, time:0.6, transition:"easeoutquint"});
			
		};

		function deActivateDock () {
			this.isActivated = false;
			this.isDeactivating = true;
			Tweener.addTween(this, {zoomedAmmount:0, time:0.6, transition:"easeoutquint"});
		};

		function enterFrameHandler(event:Event):void {
			if((this.mouseX==this.oldMouseX )&&(this.mouseY==this.oldMouseY )){
				idle++
			}else{
				idle=0;
				this.oldMouseX=this.mouseX;
				this.oldMouseY=this.mouseY;
			}
			
			if(idle>30*3){
				idle=30*3+1
				deActivateDock();
				this.redraw();
			} else {
				if (this.isActivated) {
					// Already activated
					this.redraw();
					// Check if it should be deactivated
					if ((this.mouseY < baseY-assumedIconHeight*scaleBig)||(this.mouseY > baseY-assumedIconHeight*scaleSmall*.25)) {
						deActivateDock();
					}
				} else {
					// Not activated yet
					// Check if it should be activated
					if ((this.mouseY > baseY-assumedIconHeight*scaleBig)&&(this.mouseY < baseY-assumedIconHeight*scaleSmall*.25)) {
						activateDock();
					}
				}	
			}
			
			this.redraw();
		};
		
		function clickHandler(event:MouseEvent):void {
			//trace("clickHandler"+event.target.id.toLowerCase());
			var caption = event.target.id.toLowerCase()
			
			dispatchEvent( new DockEvent( DockEvent.SELECTED, caption) );
			/*
			var myparent as 
			if(caption=="station"){
				parent.subFocus(caption)
			}else if(caption=="graph"){
				parent.subFocus(caption)
			}
			*/
		}
		
	}
	
}
