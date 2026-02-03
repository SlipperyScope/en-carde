extends MarginContainer

func _ready():
	pass


func Deal(hand: Array[GoldCardInst]) -> void:
	%GoldBench.QueueCards(hand)
	%GoldBench.StartDeal()
