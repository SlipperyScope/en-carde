extends Control
class_name CardClipper

var _isClipping: bool = false
var _childCard:UICard = null

func SetClipping(isClipping:bool) -> void:
    _isClipping = isClipping
    if isClipping:
        custom_minimum_size = Vector2(Global.CARD_CLIP_WIDTH, Global.CARD_HEIGHT)
    else:
        custom_minimum_size = Vector2(Global.CARD_WIDTH, Global.CARD_HEIGHT)

func AddCard(cardInstance:UICard) -> void:
    if cardInstance == _childCard:
        return

    if _childCard != null:
        remove_child(_childCard)
        _childCard.queue_free()
    
    add_child(cardInstance)

func _ready() -> void:
    SetClipping(true)

func getCard() -> UICard:
    return _childCard