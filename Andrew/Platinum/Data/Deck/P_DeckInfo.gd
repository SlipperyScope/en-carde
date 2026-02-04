## Information about a deck (aka a collection of cards)
class_name P_DeckInfo extends P_Resource

@export var Name: String ## Name of the deck
@export var Description: String ## Description about the deck
@export var BackgroundGraphic: Texture2D ## Graphic for the background of the card
@export var ChromeGraphic: Texture2D ## Graphic of the chrome around the card
@export var ReverseGraphic: Texture2D ## Graphic on the back of the card
@export var StanceGraphics: Dictionary[Plat.P_Stance, Texture2D] = { ## Graphic for each stance. These should be 1/3 the height of a card
	Plat.P_Stance.Null: null,
	Plat.P_Stance.Attack: null,
	Plat.P_Stance.Defence: null,
	Plat.P_Stance.Vulnerable: null,
	Plat.P_Stance.Passthrough: null,
}
@export var Cards: Dictionary[P_CardInfo, int] ## Cards and their quantity in this deck
