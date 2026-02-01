extends PanelContainer
class_name BenchCard

@export var ModifierTextures:Dictionary[Global.CardModifier, Texture2D] = {
	Global.CardModifier.Null: null,
	Global.CardModifier.Empty: null,
	Global.CardModifier.Exposed: null,
	Global.CardModifier.Attack: null,
	Global.CardModifier.Defend: null,
	Global.CardModifier.Michael: null
}

@export var GraphicTextures:Dictionary[Global.CardType, Texture2D] = {
	Global.CardType.Null: null,
	Global.CardType.Placeholder: null,
	Global.CardType.Action: null,
	Global.CardType.Michael: null
}

@export var CardBackTexture:Texture2D = null

func _ready() -> void:
	custom_minimum_size = Vector2(Global.CARD_WIDTH, Global.CARD_HEIGHT)

func ConfigureCard(data:CardData) -> void:
	if data == null:
		%top_texture.texture = ModifierTextures.get(Global.CardModifier.Empty)
		%middle_texture.texture = ModifierTextures.get(Global.CardModifier.Empty)
		%bottom_texture.texture = ModifierTextures.get(Global.CardModifier.Empty)
		%background.texture = GraphicTextures.get(Global.CardType.Placeholder)
		return

	var topAction = data.get_slot(CardData.Position.TOP).action
	var middleAction = data.get_slot(CardData.Position.MIDDLE).action
	var bottomAction = data.get_slot(CardData.Position.BOTTOM).action

	%top_texture.texture = ModifierTextures.get(remapCardDataAction(topAction))
	%middle_texture.texture = ModifierTextures.get(remapCardDataAction(middleAction))
	%bottom_texture.texture = ModifierTextures.get(remapCardDataAction(bottomAction))
	%background.texture = GraphicTextures.get(Global.CardType.Action)

func remapCardDataAction(action:CardSlot.ACTIONS) -> Global.CardModifier:
	match action:
		CardSlot.ACTIONS.ATTACK:
			return Global.CardModifier.Attack
		CardSlot.ACTIONS.DEFEND:
			return Global.CardModifier.Defend
		CardSlot.ACTIONS.OPEN:
			return Global.CardModifier.Exposed
		CardSlot.ACTIONS.MASK:
			return Global.CardModifier.Empty
	return Global.CardModifier.Null
