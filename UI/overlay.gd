extends PanelContainer

var _cardScene:PackedScene = preload("res://UI/UICard.tscn")
var _cardClipperScene:PackedScene = preload("res://UI/CardClipper.tscn")
var _handSlots: Array[HandSlot] = []

var _deck:Array[UICard] = []

func _ready() -> void:
    %draw_pile.stack_clicked.connect(_on_draw_pile_clicked)

    # testing
    var dummyData:Array[CardInfo] = []
    var info:CardInfo = null

    for i in range(10):
        info = CardInfo.new()
        info._CardType = Global.CardType.Michael
        info._ModifierTop = Global.CardModifier.Attack
        info._ModifierMiddle = Global.CardModifier.Exposed
        info._ModifierBottom = Global.CardModifier.Defend
        dummyData.append(info)

    BuildUIDeck(dummyData)

    for card in _deck:
        %draw_pile.AddCard(card)

func _on_draw_pile_clicked() -> void:
    print("card clicked")
    var drawnCard:UICard = %draw_pile.DrawCard()
    if drawnCard != null:
        for slot in _handSlots:
            if slot.GetChildCount() == 0:
                slot.AddCard(drawnCard)
                return

func _on_hand_slot_clicked_twice() -> void:
    pass # card is played

var _handSlotScene: PackedScene = preload("res://UI/HandSlot.tscn")
func _addCardToHand(card:UICard) -> void:
    var slot:HandSlot = _handSlotScene.instantiate() as HandSlot
    _handSlots.append(slot)
    %hand_slots.add_child(slot)
    slot.AddCard(card)
    slot.slot_clicked_twice.connect(_on_hand_slot_clicked_twice)

var _UICardScene:PackedScene = preload("res://UI/UICard.tscn")
func BuildUIDeck(cardInfo:Array[CardInfo]) -> void:
    for data in cardInfo:
        var card = _UICardScene.instantiate() as UICard
        _deck.append(card)

        card.SetCardType(data._CardType)
        card.SetFaceUp(false)
        card.SetCardModifier(Global.CardModifierSlot.Top, data._ModifierTop)
        card.SetCardModifier(Global.CardModifierSlot.Middle, data._ModifierMiddle)
        card.SetCardModifier(Global.CardModifierSlot.Bottom, data._ModifierBottom)