extends PanelContainer
class_name UICard

# This is the card that appears in the UI, differentiating it from on that might be used in the stage that isn't a UI element. 
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

var _cardType:Global.CardType = Global.CardType.Null
var _isFaceUp:bool = true

func SetCardType(cardType:Global.CardType) -> void:
    _cardType = cardType
    if _isFaceUp:
        %card_graphic.texture = GraphicTextures[cardType]

func SetFaceUp(isFaceUp:bool) -> void:
    _isFaceUp = isFaceUp
    if isFaceUp:
        %card_graphic.texture = GraphicTextures[_cardType]
    else:
        %card_graphic.texture = CardBackTexture

func SetCardModifier(slot:Global.CardModifierSlot, modifier:Global.CardModifier) -> void:
    match slot:
        Global.CardModifierSlot.Top:
            %modifier_top.texture = ModifierTextures[modifier]
        Global.CardModifierSlot.Middle:
            %modifier_middle.texture = ModifierTextures[modifier]
        Global.CardModifierSlot.Bottom:
            %modifier_bottom.texture = ModifierTextures[modifier]

func _ready() -> void:
    #SetCardType(_cardType)
    #SetFaceUp(_isFaceUp)
    pass
