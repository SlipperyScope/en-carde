extends Resource
## Defines how a stack of cards should be scored
class_name ScoreMethod

## List of rules used by this score method
@export var _MaskingRules: Array[MaskingRule]

## Score the cards
func Score(playStack: Array[GoldCard]) -> void:
	# iterate through stack, applying rules
	# return score
	pass