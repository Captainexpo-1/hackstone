extends Node

const CardType = preload("res://scripts/CardController.gd").CardType

# Should not be changed
func is_ai():
	return true

# Takes in [current_mana, battlefields, ai's hand, avatars] and returns an array of [NEW_MANA: int, ACTION: Callable|null, SAVED_DATA: Optional[Array]]
# ACTION can be null (no action/end turn) or a Callable function that is executed by the game 
# SAVED_DATA is an optional miscellaneous array that gets saved between actions 
func get_next_action(mana: int, ai_hand: Node3D, ai_battlefield: Node3D, player_battlefield: Node3D, ai_avatar: Node3D, player_avatar: Node3D, saved_data: Array) -> Array:
	return [mana, null, []] # Default: end turn immediately
