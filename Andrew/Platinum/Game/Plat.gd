class_name Plat

## Different stances a card can have
enum P_Stance {
	Null = 0 << 0,
	Attack = 1 << 0,
	Defence = 1 << 1,
	Vulnerable = 1 << 2,
	Passthrough = 1 << 3
}

## Stance position on a card
enum P_StancePosition {
	Top, ## Top of card
	Middle, ## Middle of card
	Bottom ## Bottom of card
}