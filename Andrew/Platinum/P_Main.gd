extends Node2D

@export var MainMenu: PackedScene

var _CurrentScene: CanvasItem

func _ready():
	_LoadMenu()

func _LoadMenu():
	var menu = MainMenu.instantiate() as P_MainMenu

	%Canvas.add_child(menu)
	menu.Exit.connect(func(): get_tree().quit())
	menu.Play.connect(func(c): _StartGame(c))

	_CurrentScene = menu

func _StartGame(client: Plat.ClientType) -> void:
	match client:
		Plat.ClientType.Local:
			_StartLocal()
		Plat.ClientType.RemoteClient:
			_StartClient()
		Plat.ClientType.RemoteHost:
			_StartClientHost()
		Plat.ClientType.DedicatedServer:
			_StartDedicatedHost()

func _StartLocal() -> void:
	print("Starting local game...")

func _StartClient() -> void:
	print("Starting as client...")

func _StartClientHost() -> void:
	print("Starting as host...")

func _StartDedicatedHost() -> void:
	print("Starting dedicated server...")
