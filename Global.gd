extends Node
# Global class for things you want to access anywhere

enum CardModifier{
    Null,
    Empty,
    Exposed,
    Attack,
    Defend,
    Michael
}

enum CardType {
    Null,
    Placeholder,
    Action,
    Michael
}

enum CardModifierSlot {
    Top,
    Middle,
    Bottom
}

const SELECTED_CARD_OFFSET: float = 20
const CARDS_IN_HAND: int = 10
const CARD_HEIGHT: float = 135
const CARD_WIDTH: float = 90
const CARD_CLIP_WIDTH: float = 15

