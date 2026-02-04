@icon("res://Andrew/Platinum/Misc/P_Icon_Card.png")

## Information about a card
class_name P_CardInfo extends P_Resource

@export var CardID: String ## Unique ID for each card (not instance ID)
@export var Name: String ## Card name
@export var Description: String ## Card description that appears on the card
@export var PowerCard: bool ## Whether this card is a power card
@export var Graphic: Texture2D ## Graphic that appears on the front of the card
@export var Stances: Dictionary[Plat.P_StancePosition, Plat.P_Stance] = { ## Stance configuration
	Plat.P_StancePosition.Top: Plat.P_Stance.Null,
	Plat.P_StancePosition.Middle: Plat.P_Stance.Null,
	Plat.P_StancePosition.Bottom: Plat.P_Stance.Null,
}
# Could have an export for special abilities, which would be a resource