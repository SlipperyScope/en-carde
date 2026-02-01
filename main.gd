extends Node2D


func _ready() -> void:
	var card_pile = load("res://CardPile.gd")
	var card_factory = load("res://CardFactory.gd")
	
	# 1. Setup Piles
	var main_deck = card_pile.new()
	var discard_pile = card_pile.new()
	var player1_hand = card_pile.new()
	var player2_hand = card_pile.new()
	
	# 2. Load and shuffle deck
	main_deck.cards = card_factory.load_deck_data()
	main_deck.shuffle()
	#print("Main deck initialized with ", main_deck.size(), " cards.")
	
	# 3. Draw cards for players
	#print("\n--- Dealing cards ---")
	player1_hand.draw_from(main_deck, 3)
	player2_hand.draw_from(main_deck, 3)
	
	#print("Player 1 hand size: ", player1_hand.size())
	#print("Player 2 hand size: ", player2_hand.size())
	#print("Main deck size: ", main_deck.size())
	
	# 4. Player 1 plays a card
	if not player1_hand.is_empty():
		var card = player1_hand.cards[0]
		#print("\nPlayer 1 plays: ", card.card_name)
		player1_hand.transfer_card(card, discard_pile)
	
	# 5. Player 2 discards a card
	if not player2_hand.is_empty():
		var card = player2_hand.cards[0]
		#print("Player 2 discards: ", card.card_name)
		player2_hand.transfer_card(card, discard_pile)
		
	# 6. Create a single custom card
	#print("\n--- Creating a custom card ---")
	var custom_card = CardFactory.create_card(
		{"action": "ATTACK", "strength": 5},
		{"action": "DEFEND", "strength": 3},
		{"action": "OPEN", "strength": 0}
	)
	#print("Custom card created: ", custom_card.card_name)
	#print("  Top: ", custom_card.top.strength, " Middle: ", custom_card.middle.strength, " Bottom: ", custom_card.bottom.strength)
	player1_hand.add_card(custom_card)
	#print("Player 1 hand size after adding custom card: ", player1_hand.size())

	#print("\nFinal State:")
	#print("Player 1 hand size: ", player1_hand.size())
	#print("Player 2 hand size: ", player2_hand.size())
	#print("Discard pile size: ", discard_pile.size())
	#print("Main deck size: ", main_deck.size())

	# Wire UI


	# Update UI
	%bench.SetDrawCount(main_deck.size())
	print(player1_hand.size())
	for i in range(Global.CARDS_IN_HAND):
		if i < player1_hand.size():
			%bench.SetCardAt(i, player1_hand.cards[i])
		else:
			%bench.SetCardAt(i, null)
