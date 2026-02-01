extends Node

const EMP = 0
const ATK = 1
const DEF = 2
const EXP = 3

var CARDS = {
	1: { "name": "Poop", "top": ATK, "mid": ATK, "bot": EMP },
	2: { "name": "Pee", "top": DEF, "mid": EXP, "bot": EMP },
	3: { "name": "Barf", "top": DEF, "mid": EMP, "bot": DEF },
	4: { "name": "Burp", "top": EMP, "mid": ATK, "bot": EMP },
	5: { "name": "Sneeze", "top": EMP, "mid": EMP, "bot": ATK },
}
