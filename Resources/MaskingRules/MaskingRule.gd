extends Resource

# Defines a rule for masking stances
class_name MaskingRule

@export_flags("Attack", "Defend", "Vulnerable", "Passthrough") var _Starting: int
@export_flags("Attack", "Defend", "Vulnerable", "Passthrough") var _Mask: int
@export var _Result: EnumDefinitions.CardStance

# Resulting stance
var Result: EnumDefinitions.CardStance:
	get:
		return _Result

# Checks if this rule can consider a starting stance. True if it is able
func MatchStartingStance(stance: EnumDefinitions.CardStance) -> bool:
	return stance & _Starting != 0

# Checks if this rule can consider a masking stance. True if it is able
func MatchMaskStance(stance: EnumDefinitions.CardStance) -> bool:
	return stance & _Mask != 0

# Checks if this rule can consider the starting and masking stance. True if it is able
func IsValid(starting: EnumDefinitions.CardStance, mask: EnumDefinitions.CardStance) -> bool:
	var validStart = MatchMaskStance(starting)
	var validMask = MatchMaskStance(mask)
	return validStart && validMask