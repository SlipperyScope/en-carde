extends Node2D

func _ready() -> void:
    %bench.card_drawn.connect(_on_card_drawn)
    %bench.card_activated.connect(_on_card_activated)

func _on_card_drawn() -> void:
    # validate draw action
    # update hand
    pass

func _on_card_activated(index:int) -> void:
    # validate card can play
    # Remove card from hand
    # Update UI
    pass

func WhenDrawPileGetsAdded() -> void:
    var pileSize:int = 50 # get from data
    %bench.SetDrawCount(pileSize)

func WhenCardGetsAddedToHand() -> void:
    # update hand; null makes empty space
    for i in range(Global.CARDS_IN_HAND):
        %bench.SetCardAt(i, null) # pass in card data
    