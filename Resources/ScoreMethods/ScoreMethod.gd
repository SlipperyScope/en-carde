extends Resource
# Defines how a stack of cards should be scored
class_name ScoreMethod

@export var _MaskingRules: Array[MaskingRule]

func Score(playStack: Array[GoldCard]) -> void:
	# iterate through stack, applying rules
	# return score
	pass