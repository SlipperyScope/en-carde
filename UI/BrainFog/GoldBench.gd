extends PanelContainer

var CardSlotScene: PackedScene = preload("res://UI/BrainFog/GoldHandSlot.tscn")

signal PlayCard(id: String) ## Card selected for play
signal DealFinished() ## Cards have been dealt

## Params to use for adding new cards
@export var CardSlotParams: GoldHandSlotParams

var _DealtCards: Array[GoldHandSlot] = []
var _DealQueue: Array[GoldHandSlot] = []

var AllowMultiSelect: bool = false:
	get:
		return AllowMultiSelect
	set(new_value):
		AllowMultiSelect = new_value

func _ready():
	#%CollapseAnimation.animation_finished.connect(_on_collapse_finish)
	# Test deal cards
	for i in range(8):
		_QueueCard()

	_DealCards()

	pass

# Adds a card to the deal queue
func _QueueCard():
	var card = CardSlotScene.instantiate() as GoldHandSlot
	card.ready.connect(func(): card.Build(CardSlotParams))

	_DealQueue.append(card)

# Deals the each card from the queue
func _DealCards():
	if _DealQueue.size() > 0:
		var nextCard = _DealQueue.pop_back()
		%CardSlots.add_child(nextCard)
		nextCard.ExpandAnimationFinished.connect(_on_card_deal_animation_finished)
		nextCard.Expand()
		_DealtCards.append(nextCard)
	else:
		for card in _DealtCards:
			card.Clickable = true
			card.SelectCard.connect(_on_select_card)
			card.PlayCard.connect(_on_play_card)
		DealFinished.emit()

## Handles card deal animation complete
func _on_card_deal_animation_finished(card: GoldHandSlot, position: GoldHandSlot.ExpandTarget) -> void:
	card.ExpandAnimationFinished.disconnect(_on_card_deal_animation_finished)
	%DealCooldown.timeout.connect(_on_cooldown_finished)
	%DealCooldown.start()

## Deal next card after cooldown
func _on_cooldown_finished() -> void:
	%DealCooldown.timeout.disconnect(_on_cooldown_finished)
	_DealCards()

func _on_select_card(card: GoldHandSlot) -> void:
	if AllowMultiSelect == true:
		card.Select()
		return
		
	for slot in _DealtCards:
		if slot == card:
			slot.Select()
		else:
			slot.Deselect()
	pass

func _on_play_card(card: GoldHandSlot) -> void:
	if AllowMultiSelect == true:
		card.Deselect()
	else:
		print("Played card")
		PlayCard.emit("")
		pass
