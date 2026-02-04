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
	Top = 1 << 0, ## Top of card
	Middle = 1 << 1, ## Middle of card
	Bottom = 1 << 2 ## Bottom of card
}

## Type of client playing the game
enum ClientType {
	Null = 0 << 0,
	Local = 1 << 0, ## Plays local/offline games only
	RemoteClient = 1 << 1, ## Connects to a server
	RemoteHost = 1 << 2, ## Client that also hosts game logic
	DedicatedServer = 1 << 3 ## Server only, does not participate in gameplay
}