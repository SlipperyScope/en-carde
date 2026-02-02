extends Node

# Card stances available to use on a card
enum CardStance
{
	Null = 0,
	Attack = 1 << 0,
	Defend = 1 << 1,
	Vulnerable = 1 << 2,
	Passthrough = 1 << 3
}