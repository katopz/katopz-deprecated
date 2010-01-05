/**
 * Stats - MooTools
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * How to use:
 * 
 * new Stats(
 * 		fps(int),
 * 		destination(dom-node)
 * 		[,
 * 			left(int),
 * 			top(int),
 * 			position:fixed(bool)
 * 		]
 * 		).go();
 * 
 * 
 * //element.appendChild( Stats.init(60) );
 * 
 * version log:
 *
 *	09.11.25		1.1		mtillmann		+ Mootools port
 * 	09.06.18		1.1		Mr.doob			+ Firefox support
 * 	09.06.10		1.0		Mr.doob			+ First version
 **/

var Stats = new Class({
	baseFps: null,
	
	timer: null,
	timerStart: null,
	timerLast: null,
	fps: null,
	ms: null,
	
	container: null,
	fpsText: null,
	msText: null,
	memText: null,
	memMaxText: null,
	
	graph: null,
	graphData: null,
	
	initialize: function(userfps,destination,$left,$top,$fixed)
	{
		this.baseFps = userfps;
		
		this.timer = 0;
		this.timerStart = new Date() - 0;
		this.timerLast = 0; 
		this.fps = 0;
		this.ms = 0;
		
		var container = new Element('div',{
			id : '__stats_container',
			styles : {
				fontFamily:'arial',
				fontSize:'10px',
				backgroundColor:'#000033',
				width:70,
				paddingTop:2,
				position:$fixed?'fixed':'absolute',
				zIndex:9999,
				left : $left || 0,
				top : $top || 0
			}
		});
		
		new Element('div',{
			id : '__stats_fpsText',
			text : 'FPS:',
			styles : {
				color : '#ffff00',
				marginLeft : 3,
				marginBottom : -3,
			}
		}).inject(container);

		new Element('div',{
			id : '__stats_msText',
			text : 'MS:',
			styles : {
				color : '#ffff00',
				marginLeft : 3,
				marginBottom : -3,
			}
		}).inject(container);

		new Element('div',{
			id : '__stats_memText',
			text : 'MEM:',
			styles : {
				color : '#ffff00',
				marginLeft : 3,
				marginBottom : -3,
			}
		}).inject(container);

		new Element('div',{
			id : '__stats_maxText',
			text : 'MAX:',
			styles : {
				color : '#ffff00',
				marginLeft : 3,
				marginBottom : 3,
			}
		}).inject(container);
	
		var canvas = new Element('canvas',{
			id : '__stats_canvas',
			height : 50,
			width : 70
		}).inject(container);	
		
		this.graph = canvas.getContext("2d");
		this.graph.fillStyle = '#000033';
		this.graph.fillRect(0, 0, canvas.width, canvas.height );
		
		this.graphData = this.graph.getImageData(0, 0, canvas.width, canvas.height);
		
		container.inject(destination);
	},
	
	go : function()
	{
		this.update.periodical( 1000/ this.baseFps, this);		
	},
	
	update: function()
	{
		this.timer = new Date() - this.timerStart;

		if ((this.timer - 1000) > this.timerLast)
		{
			$('__stats_fpsText').set('text',"FPS: " + this.fps + " / " + this.baseFps);
			this.timerLast = this.timer;
		
			this.graphData = this.graph.getImageData(0, 0, 69, 50);		
			this.graph.putImageData(this.graphData, 1, 0);
			
			this.graph.fillRect(0,0,1,50);
			this.graphData = this.graph.getImageData(0, 0, 1, 50);
			
			var index = ( Math.floor(50 - Math.min(50, (this.fps / this.baseFps) * 50)) * 4 );
			this.graphData.data[index] = this.graphData.data[index + 1] = 255;
			
			index = ( Math.floor(50 - Math.min(50, (this.timer - this.ms) * .5)) * 4 );
			this.graphData.data[index + 1] = 255;			
			
 			this.graph.putImageData (this.graphData, 0, 0);
			
			this.fps = 0;
		}
		
		++this.fps;
		
		$('__stats_msText').set('text',"MS: " + (this.timer - this.ms));
		this.ms = this.timer;
	}
	
});
