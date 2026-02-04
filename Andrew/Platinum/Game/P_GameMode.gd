@icon("res://Andrew/Platinum/Misc/P_Icon_Rule.png")

## Defines rules for a single game type, and tracks information used while playing it[br]
## For different configurations, create a .tres (or make in the inspector directly)[br]
## For game modes with unique logic, derive this class
class_name P_GameMode extends P_Resource

## Client type filters
enum Filter
{
	Local = 1 << 0,
	Online = 1 << 1
}

@export var Name: String ## Name of this game more
@export var Description: String ## Description of this game mode
@export var Players: int = 2 ## Number of people to play this game mode
@export_flags("Local", "Online") var _PlayFilter: int = Filter.Local | Filter.Online ## Where this game can be played (select all that apply)
@export var DrawCount: int ## Amount of cards to draw at the beginning of each match
@export var DiscardCount: int ## Amount of cards to discard before the game starts
@export var Decks: Array[P_DeckInfo] ## Decks that are valid to use with this game mode

var PlayFilter: Filter:
	get:
		return _PlayFilter as Filter