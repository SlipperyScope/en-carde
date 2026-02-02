extends Resource
## Params used to initialize a [GoldHandSlot]
class_name GoldHandSlotParams

## True: Card should start collapsed (zero-width)
## [br]False: Card should start fully visible
@export var StartCollapsed: bool = true

## True: Card should start selected
## [br]False: Card should start not selected
@export var StartSelected: bool = false

## True: Card will animate
## False: Card will not animate
@export var EnableAnimation: bool = true

## Speed multiplier of animations[br]
## E.g., 2.0 = twice normal speed
@export var AnimationSpeed: float = 1.0

## True: Can be clicked right away[br]
## False: Click must be enabled later
@export var StartClickable: bool = true