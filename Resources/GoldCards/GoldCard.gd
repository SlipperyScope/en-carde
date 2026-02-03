extends Resource
# Resource info for a Gold™ card
class_name GoldCard

@export var CardName: String
@export_multiline var Description: String
@export var Graphic: Texture2D
@export var TopStance: EnumDefinitions.CardStance
@export var MiddleStance: EnumDefinitions.CardStance
@export var BottomStance: EnumDefinitions.CardStance

## Prints a new card with this info[br]id: Unique ID for the new card instance
func PrintCard(id: String, deck: GoldDeck) -> GoldCardInst:
	var card = GoldCardInst.new()
	card.Build(id, self , deck)
	return card

# todo: bake the layers into a single texture