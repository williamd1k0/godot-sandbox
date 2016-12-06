# Godot Project

>Windows only

Simple tool to start Godot Engine from project folder.

This tool was made for temporary usage, since that this feature will be implemented in future.

Related issue on Godot repo: https://github.com/godotengine/godot/issues/6915


## Usage

1. Download the binary (or compile yourself using pyinstaller module).
2. Extract files in a safe folder.
3. Open `.gdpath` file and set `default` key to actual godot path (this file is a simple yaml file).
4. Create an empty `.gdproj` file in the root of your project (eg: `myawesomegame.gdproj`)
5. Open file properties to set the "open with" config and choose the `GodotProject.exe`.
6. Double-click in `myawesomegame.gdproj`!

PS: An empty `.gdproj` will trigger default godot path, you can add other path and set it in `.gdproj` file.
