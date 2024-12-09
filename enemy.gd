extends Sprite2D

@export var green = Color("#639765")
@export var black = Color("#000000")
@export var pink = Color("#da5c72")

@onready var prompt = $RichTextLabel
@onready var prompt_txt = prompt.get_parsed_text()

func _ready() -> void:
	prompt_txt = PromptList.get_prompt()
	prompt.parse_bbcode(set_center(prompt_txt))
## ^This is for random prompts. Will adjust in final game.

func get_prompt() -> String:
	return prompt_txt

func set_next_char(next_char_index: int):
	var green_txt = get_bbcode_color_tag(green) + prompt_txt.substr(0, next_char_index) + get_bbcode_end_color_tag()
	var pink_txt = get_bbcode_color_tag(pink) + prompt_txt.substr(next_char_index, 1) + get_bbcode_end_color_tag()
	var black_txt = ""
	
	if next_char_index != prompt_txt.length():
		black_txt = get_bbcode_color_tag(black) + prompt_txt.substr(next_char_index + 1, prompt_txt.length() - next_char_index + 1) + get_bbcode_end_color_tag()
	
	prompt.parse_bbcode(set_center(green_txt + pink_txt + black_txt))
	
func set_center(string_to_center: String):
	return "[center]" + string_to_center + "[/center]"

func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"
	
func get_bbcode_end_color_tag() -> String:
	return "[/color]"
	
func reset_prompt():
	prompt.parse_bbcode(set_center(get_bbcode_color_tag(black) + prompt_txt.substr(0, prompt_txt.length()) + get_bbcode_end_color_tag()))
