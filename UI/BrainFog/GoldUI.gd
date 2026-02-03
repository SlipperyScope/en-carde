extends MarginContainer

signal DealFinished() ## Card deal has finished
signal DiscardFinished() ## Cards finished discarding

var MaxSelectableCards: int:
	get: return %GoldBench.MaxSelectableCards
	set(value): %GoldBench.MaxSelectableCards = value

func _ready():
	pass

func Deal(hand: Array[GoldCardInst]) -> void:
	%GoldBench.AllowMultiSelect = true
	%GoldBench.QueueCards(hand)
	%GoldBench.DealFinished.connect(func(): DealFinished.emit())
	%GoldBench.StartDeal()

func StartPlay() -> void:
	%GoldBench.AllowMultiSelect = false

func StartDiscard() -> void:
	print("discarding selected cards...")
	pass

# DEAL BUTTON

signal DealButtonPressed() ## Deal button has been pressed

## Enables the deal button
func EnableDealButton() -> void:
	%DealButton.visible = true
	%DealButton.pressed.connect(_on_deal_button_pressed)

## Disables the deal button
func DisableDealButton() -> void:
	%DealButton.visible = false
	%DealButton.pressed.disconnect(_on_deal_button_pressed)

func _on_deal_button_pressed() -> void:
	DealButtonPressed.emit()

# DISCARD BUTTON

signal DiscardButtonPressed() ## Discard button has been pressed
const DISCARD_TEXT = "Select %s more cards to discard"

## Enables the discard button
func EnableDiscardButton() -> void:
	%Discard.visible = true
	_UpdateDiscardButtonHintText(0)
	%DiscardButton.pressed.connect(_on_discard_button_pressed)
	%GoldBench.SelectedCardsChanged.connect(_UpdateDiscardButtonHintText)

## Disables the discard button
func DisableDiscardButton() -> void:
	%Discard.visible = false
	%DiscardButton.pressed.disconnect(_on_discard_button_pressed)
	%GoldBench.SelectedCardsChanged.disconnect(_UpdateDiscardButtonHintText)

## Updates the discard button hint text with remaining selection count
func _UpdateDiscardButtonHintText(selected: int) -> void:
	var remaining = MaxSelectableCards - selected
	%DiscardHint.text = DISCARD_TEXT % remaining

func _on_discard_button_pressed() -> void:
	if %GoldBench.SelectedCards == MaxSelectableCards:
		DiscardButtonPressed.emit()
