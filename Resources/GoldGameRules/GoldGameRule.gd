extends Resource
## Defines game rules
class_name GoldGameRule

@export_category("Hand Setup")
@export var Draw: int = 0 ## Number of cards to draw
@export var Discard: int = 0 ## Number of cards to discard after draw
