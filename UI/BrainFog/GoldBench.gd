extends PanelContainer

var CardSlotScene: PackedScene = preload("res://UI/BrainFog/GoldHandSlot.tscn")


# Notifies when a card is designated for 
signal PlayCard(id: String)

var _DealtCards: Array[GoldHandSlot] = []
var _DealQueue: Array[GoldHandSlot] = []

var AllowMultiSelect: bool = true:
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
	_DealQueue.append(card)

# Deals the each card from the queue
func _DealCards():
	if _DealQueue.size() > 0:
		%SpacerSlot.move_to_front()
		%CollapseAnimation.seek(0.1, true)
		%SpacerSlot.visible = true
		%CollapseAnimation.animation_finished.connect(_on_shift_hand_finished)
		%CollapseAnimation.play_backwards("collapse")

# Spacer finished shifting hand over for new card
func _on_shift_hand_finished(anim_name: String):
	%CollapseAnimation.animation_finished.disconnect(_on_shift_hand_finished)
	#%SpacerSlot.visible = false
	_DealCard(_DealQueue.pop_back())
	if _DealQueue.size() > 0:
		%Cooldown.timeout.connect(_on_cooldown_finished)
		%Cooldown.start()
	else:
		%SpacerSlot.visible = false

# Adds card to hand
func _DealCard(card: GoldHandSlot):
	_DealtCards.append(card)
	%CollapseAnimation.seek(0.1, true)
	%CardSlots.add_child(card)
	card.SelectCard.connect(_on_select_card)
	card.PlayCard.connect(_on_play_card)

# Deal next card after cooldown
func _on_cooldown_finished() -> void:
	%Cooldown.timeout.disconnect(_on_cooldown_finished)
	_DealCards()

func _on_select_card(selectedCard: GoldHandSlot) -> void:
	if AllowMultiSelect == true:
		selectedCard.IsSelected = true
		return
		
	for card in _DealtCards:
		if card == selectedCard:
			card.IsSelected = true
		else:
			card.IsSelected = false
	pass

func _on_play_card(selectedCard: GoldHandSlot) -> void:
	if AllowMultiSelect == true:
		selectedCard.IsSelected = false
	else:
		print("Played card")
		PlayCard.emit("")
		pass
