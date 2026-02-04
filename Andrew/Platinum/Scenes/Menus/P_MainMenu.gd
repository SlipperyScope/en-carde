## Interface for the main menu of the game
class_name P_MainMenu extends Control

const _ClientType = Plat.ClientType

enum _Menu {
	Title,
	GMSelect,
}

@onready var _Menus: Dictionary[_Menu, Node] = {
	_Menu.Title: %TitleMenu,
	_Menu.GMSelect: %GMSelect,
}

signal Play(client: _ClientType) ## User clicked one of the play buttons
signal Exit() ## User pressed the quit button

@export var GameModes: Array[P_GameMode] ## Game modes to choose from (will filter by type)
@export var MenuTransition: P_Transition_Fade ## Transition to use between menu screens. User FadeOut() and FadeIn()


var _SelectedClient: _ClientType = _ClientType.Null
var _GMMenuLookup: Dictionary[Button, P_GameMode] = {}
var _CurrentMenu: _Menu = _Menu.Title

func _ready():
	_SetupTitleMenu()
	_SetupGMSelectMenu()

	_NavToMenu(_Menu.Title)

# Hiding inactive menus should work
func _NavToMenu(menu: _Menu) -> void:
	if _Menus[_CurrentMenu].visible == true:
		MenuTransition.FadeOut(_Menus[_CurrentMenu])
		await MenuTransition.FadedOut
		_Menus[_CurrentMenu].visible = false

	_CurrentMenu = menu
	
	_Menus[menu].visible = true
	MenuTransition.FadeIn(_Menus[menu])
	await MenuTransition.FadedIn

	
func _SetupTitleMenu() -> void:
	_Menus[_Menu.Title].visible = false
	%OfflineButton.pressed.connect(_on_client_type_selected.bind(_ClientType.Local))
	%HostButton.pressed.connect(_on_client_type_selected.bind(_ClientType.RemoteHost))
	%ClientButton.pressed.connect(_on_client_type_selected.bind(_ClientType.RemoteClient))
	%DedicatedButton.pressed.connect(_on_client_type_selected.bind(_ClientType.DedicatedServer))
	%ExitButton.pressed.connect(Exit.emit)

func _SetupGMSelectMenu() -> void:
	_Menus[_Menu.GMSelect].visible = false
	MenuTransition.FadeOut(%GMConfig)
	%GMBackButton.pressed.connect(_NavToMenu.bind(_Menu.Title))

	for gameMode in GameModes:
		var button = Button.new()
		button.text = gameMode.Name
		%GMList.add_child(button)
		_GMMenuLookup[button] = gameMode
		button.pressed.connect(_on_game_mode_selected.bind(gameMode))

func _on_client_type_selected(type: _ClientType) -> void:
	_SelectedClient = type
	var menu := _Menu.Title
	if type == _ClientType.RemoteClient:
		# nav to connect screen
		pass
	else:
		_FilterGameModes(P_GameMode.Filter.Local if type == _ClientType.Local else P_GameMode.Filter.Online)
		menu = _Menu.GMSelect

	_NavToMenu(menu)

# Filters the list on the game mode select screen
func _FilterGameModes(allowed: P_GameMode.Filter) -> void:
	var entries = %GMList.get_children()
	for entry: Button in entries:
		entry.visible = _GMMenuLookup[entry].PlayFilter & allowed > 0

# Swaps the GM info display 
func _on_game_mode_selected(gameMode: P_GameMode) -> void:
	MenuTransition.FadeOut(%GMConfig)
	await MenuTransition.FadedOut

	%MaxPlayers.text = str(gameMode.Players)
	%DrawCount.text = str(gameMode.DrawCount)
	%DiscardCount.text = str(gameMode.DiscardCount)
	%GMDescription.text = gameMode.Description

	MenuTransition.FadeIn(%GMConfig)
	await MenuTransition.FadedIn
