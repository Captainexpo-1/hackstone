extends "res://scripts/AI/AIBase.gd"

func get_next_action(mana: int, ai_hand: Node3D, ai_battlefield: Node3D, player_battlefield: Node3D, ai_avatar: Node3D, player_avatar: Node3D, saved_data: Array) -> Array:
	if player_avatar == null || player_avatar.toughness <= 0:
		return [mana, null] # Catch these cases and end turn. They should ideally never show up, but we don't want to do stuff to a null avatar
	
	var ai_hand_cards: Array[Node3D] = ai_hand.get_cards()
	var ai_battlefield_cards: Array[Node3D] = ai_battlefield.get_cards()
	var player_battlefield_cards: Array[Node3D] = player_battlefield.get_cards()
	
	var card = null
	var is_hack = false
	
	# Search through ai's cards and see if we can play one
	for i in ai_hand_cards:
		if i.casting_cost <= mana:
			card = i
			is_hack = i.type == CardType.HACK
			break

	# Play the card if we can
	if card != null:
		if not is_hack:
			return [mana - card.casting_cost, func(): ai_battlefield.insert_card(ai_hand.take(card), 0, card.transform.origin)]
		elif player_battlefield_cards.size() > 0: 
			return [mana - card.casting_cost, func(): card.play(player_battlefield_cards[randi() % player_battlefield_cards.size()])]
		else:
			return [mana - card.casting_cost, func(): card.play(player_avatar)]
			
	# Can't play anything, must start attacking now
	for c in ai_battlefield_cards:
		if c.tapped == false:
			var rng = RandomNumberGenerator.new()
			var f = func(): 
				if rng.randf_range(0.0, 1.0)>0.5 && player_battlefield_cards.size() > 0:
					c.play(player_battlefield_cards[randi() % player_battlefield_cards.size()])
				else:
					c.play(player_avatar) # Attack player
	
			return [mana, f]
	
	return [mana, null]
