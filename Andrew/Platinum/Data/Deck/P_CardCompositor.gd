## Defines a compositor that merges card elements into a single graphic
@abstract class_name P_CardCompositor extends P_Resource

## Parameters needed to composite a card
class CompositeParams extends RefCounted:
	var Name: String ## Name of card
	var CardText: String ## Text on the card
	var CardID: String ## Card ID
	var InstID: String ## Unique ID created at runtime
	var Background: Texture2D ## Background graphic
	var Graphic: Texture2D ## Card graphic
	var Top: Texture2D ## Top stance graphic for the card
	var Middle: Texture2D ## Middle stance graphic for the card
	var Bottom: Texture2D ## Bottom stance graphic for the card
	var Chrome: Texture2D ## Card chrome

	func _init() -> void:
		pass

	## Creates a new CompositeParams and returns it
	static func Make(deck: P_DeckInfo, card: P_CardInfo, cardInstID: String) -> CompositeParams:
		var params = CompositeParams.new()
		print("making params for card %s" % cardInstID)
		params.Name = card.Name
		params.CardText = card.Description
		params.CardID = card.CardID
		params.InstID = cardInstID
		params.Background = deck.BackgroundGraphic
		params.Graphic = card.Graphic
		params.Top = deck.StanceGraphics[card.Stances[Plat.P_StancePosition.Top]]
		params.Middle = deck.StanceGraphics[card.Stances[Plat.P_StancePosition.Middle]]
		params.Bottom = deck.StanceGraphics[card.Stances[Plat.P_StancePosition.Bottom]]
		params.Chrome = deck.ChromeGraphic

		return params

## Merges cards layers into a single texture2D[br][param owner]used to hook into the scene tree, if needed
## [br][b]Note:[/b] Use await, as this is sometimes a coroutine
func Composite(owner: Node, params: P_CardCompositor.CompositeParams) -> Texture2D:
	var texture = await _Composite(owner, params)
	return texture

func _Composite(_owner: Node, _params: P_CardCompositor.CompositeParams) -> Texture2D:
	await null # Can't use an abstract function because of the way Godot identifies coroutines
	return null
