extends Node

## Card stances available to use on a card
enum CardStance
{
	Null = 0, ## She's dead, Jim
	Attack = 1 << 0, ## Attack stance
	Defend = 1 << 1, ## Defense stance
	Vulnerable = 1 << 2, ## Vulnerable / open
	Passthrough = 1 << 3 ## Passthrough / no mask
}