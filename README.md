# UltimateRpg


FOLDER STRUCTURE:
	
	your-game/
│
├── project.godot           # Godot project file
├── main.tscn               # Main scene (or in /scenes)
│
├── assets/                 # Raw assets (e.g. PSD, WAV, FBX - not used directly in game)
│
├── scenes/                 # All scenes (.tscn)
│   ├── main/               # Main scene(s)
│   ├── ui/                 # UI-related scenes (menus, HUDs)
│   ├── player/             # Player-related scenes
│   ├── enemies/            # Enemy-related scenes
│   └── world/              # Level/world scenes
│
├── scripts/                # GDScript files
│   ├── player/             
│   ├── enemies/
│   ├── systems/            # Managers, game state, etc.
│   └── ui/
│
├── prefabs/                # Reusable, pre-configured scenes (e.g. bullets, pickups)
│
├── resources/              # .tres, .res, materials, animation resources
│
├── audio/                  # Music and sound effects
│   ├── music/
│   └── sfx/
│
├── sprites/                # Optimized image assets (e.g. .png)
│   ├── ui/
│   ├── player/
│   └── enemies/
│
├── fonts/                  # Bitmap or dynamic fonts
│
├── shaders/                # Shader code (.gdshader or .shader files)
│
└── addons/                 # Godot plugins and third-party tools
