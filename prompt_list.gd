extends Node

var sentences = [
	"I went to the store to buy food to eat later.",
	"School starts at 8 o'clock in the morning.",
	"He hates fruits and vegetables a lot.",
	"My friends and I are very happy!",
	"You are doing super awesome at typing!",
	"The quick brown fox jumps over the lazy dog.",
	"Her parents are currently at work.",
	"Instead, his favorite sport is basketball.",
	"Studying for school is a very important task.",
	"There are seven continents in the world.",
	"Video games are fun to play with others!",
	"Some people like cats, others like dogs.",
	"That new restaurant opened just last week.",
	"The group project is due next Thursday night.",
	"The sun rises in the east and sets in the west.",
	"He is planning a birthday party for his mom.",
	"I forgot my homework, so I got a low grade.",
	"There are 50 states in the United States."
]

var sentences_full = []

func get_prompt() -> String:
	sentences_full = sentences.duplicate()
	sentences.shuffle()
	
	if sentences.is_empty():
		sentences = sentences_full.duplicate()
		sentences.shuffle()
		
	var sentence = sentences.pop_front()
	
	return sentence
