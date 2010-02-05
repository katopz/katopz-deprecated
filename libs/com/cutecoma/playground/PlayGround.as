/*
	PlayGround | 3DEngine
	
	World -> Character -> Area -> PlayGround
	
	+ World (NetConnection)
		- Connector
		- Authentication
		- AreaMap
		
	+ Area (AreaData)
		+ Map (MapData)
			- PathFinder
			- Marker
			- Radar
			
		+ Ground (GroundData)
			- HighField
			- Terrain
		
		+ Decor (DecorData)
			- DecorLayout
			
		+ PlayerManager (PlayerData)
			- in/out data (# Engine -> ChatEngine)
		
	+ Character
		+ AbstractPlayer
			- id (# Area -> Player -> Character)
			
			- pos (# Area -> Ground -> Position)
			- des (# Area -> Ground -> Pathfinder)
			
			- ins (# Area -> Character)
			- act (# Area -> Character)
			
			- alias (# Area -> Chat)
			- msg (# Area -> Chat)
			
			- tag (# Events -> UpdateEvent)
			
		+ Player (^ Events -> PlayerEvent)
			- instance (# Objects -> SDM)
			* Act (# Engine -> ActionEngine {label, beg, end}
			* Spawn (# Area -> Ground -> Position)
			* Walk (# Area -> Ground -> Pathfinder)
			* Talk (# Area -> Chat)
			
		+ NPC (^ Events -> PlayerEvent)
			- Rally Path (N/A)
			- Talk Script (N/A)
			- Memory (N/A)
			- Quest (N/A)
		
	+ Objects
		+ SDM
			- model (DAE, MD2)
			- skin (movie, png)
			
		+ Clips
			- Clip (ClipField)
			- Label (SimpleTextField)
		
	+ Engine
		+ 3DEngine
			- Engine3D
			- Interactive
			
		+ ActionEngine
			- Action : {label, beg, end}
			
		+ ChatEngine
			- Balloon (# Objects -> Clips)
			- Dialog : {Hello, Quest}
		
	+ Status
		- WorldStatus
		- AreaStatus
		- CharacterStatus
		- DecorStatus
		
	+ Events
		- Interactive3DEvent
		- DecorEvent
		- PlayerEvent
		- NPCEvent
		
	+ Editor
		+ WorldEditor
			- BuildTools (Menu)
			+ MapEditor (Area top view)
			+ AreaEditor
				- Ground : APainter
*/