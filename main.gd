extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var deck_manager = load("res://DeckManager.gd")
	var deck = deck_manager.load_deck()
	print("Deck loaded with ", deck.size(), " cards.")
	for i in range(deck.size()):
		var card = deck[i]
		print("Card ", i, ": ", card.card_name)
		print("  Top: ", CardSlot.ACTIONS.keys()[card.top.action], " (", card.top.strength, ")")
		print("  Middle: ", CardSlot.ACTIONS.keys()[card.middle.action], " (", card.middle.strength, ")")
		print("  Bottom: ", CardSlot.ACTIONS.keys()[card.bottom.action], " (", card.bottom.strength, ")")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
