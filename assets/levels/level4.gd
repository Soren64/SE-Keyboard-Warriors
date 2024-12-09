extends Node2D

@onready var enemy_container = $EnemyContainer
@onready var currTurn = $Turn
@onready var enemy = $EnemyContainr/Enemy
@onready var enemy2 = $EnemyContainer/Enemy2
@onready var enemy3 = $EnemyContainer/Enemy3
@onready var enemy2_txt = $EnemyContainer/Enemy2/RichTextLabel
@onready var enemy3_txt = $EnemyContainer/Enemy3/RichTextLabel
@onready var prompt_txt = $EnemyContainer/Enemy/RichTextLabel
@onready var prompt_txt2 = $EnemyContainer/Enemy2/RichTextLabel
@onready var prompt_txt3 = $EnemyContainer/Enemy3/RichTextLabel
@onready var vocabQ = $EnemyContainer/Enemy/RichTextLabel2
@onready var choices = $EnemyContainer/Enemy/Choices
@onready var vocabQ2 = $EnemyContainer/Enemy2/RichTextLabel2
@onready var choices2 = $EnemyContainer/Enemy2/Choices
@onready var vocabQ3 = $EnemyContainer/Enemy3/RichTextLabel2
@onready var choices3 = $EnemyContainer/Enemy3/Choices
@onready var timeReset = $GameTimer/Timer
@onready var pHp1 = $Player/PlayerHealth
@onready var pHp2 = $Player/PlayerHealth2
@onready var pHp3 = $Player/PlayerHealth3

var playerTurn: bool
var enemyTurn: bool
var active_enemy = null
var current_letter_index: int = -1
var enemy_count: int
var playerHealth: int = 3
var save_path = "user://savedata.save"
var emptyHp = preload("res://assets/sprites/empty_heart.png")

func _ready() -> void:
	playerTurn = true
	enemyTurn = false
	choices.hide()
	vocabQ.hide()
	choices2.hide()
	vocabQ2.hide()
	choices3.hide()
	vocabQ3.hide()

func find_new_active_enemy(typed_char: String):
	for enemy in enemy_container.get_children():
		var prompt = enemy.get_prompt()
		var next_char = prompt.substr(0, 1)
		if next_char == typed_char:
			active_enemy = enemy
			current_letter_index = 1
			enemy_count = enemy_container.get_child_count()
			active_enemy.set_next_char(current_letter_index)
			return
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var typed_event := event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		
		if active_enemy == null:
			find_new_active_enemy(key_typed)
		else:
			var prompt = active_enemy.get_prompt()
			var next_char = prompt.substr(current_letter_index, 1)
			if key_typed == next_char:
				print("success!")
				current_letter_index += 1
				active_enemy.set_next_char(current_letter_index)
				if current_letter_index == prompt.length():
					print("done!")
					current_letter_index = -1
					enemy_count -= 1
					active_enemy.queue_free()
					active_enemy = null
					if is_instance_valid(prompt_txt) == true:
						enemy2_txt.show()
					elif is_instance_valid(prompt_txt2) == true:
						enemy3_txt.show()
				if enemy_count == 0:
					EndScreen.show()
					get_tree().paused = true
					save_game()
			else:
				print("failure!")
				
func save_game():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_string("res://assets/levels/level4.tscn")
	save_file.close()

func _on_timer_timeout() -> void:
	if playerTurn == true:
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
		
	if enemyTurn == true:
		current_letter_index = -1
		if is_instance_valid(enemy) == false && is_instance_valid(enemy2) == true:
			enemy2.reset_prompt()
		elif is_instance_valid(enemy2) == false && is_instance_valid(enemy3) == true:
			enemy3.reset_prompt()
		else:
			enemy.reset_prompt()
		
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false \
		&& is_instance_valid(vocabQ2) == true && is_instance_valid(choices2) == true:
			vocabQ2.show()
			choices2.show()
			prompt_txt2.hide()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false \
		&& is_instance_valid(vocabQ3) == true && is_instance_valid(choices3) == true:
			vocabQ3.show()
			choices3.show()
			prompt_txt3.hide()
		else:
			vocabQ.show()
			choices.show()
			prompt_txt.hide()
		enemyTurn = false
		playerTurn = true
		currTurn.text = "Current Turn: Enemy"

func _on_answer_a_pressed() -> void:
	playerHealth -= 1
	
	if playerHealth == 2:
		pHp1.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 1:
		pHp2.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 0:
		pHp3.texture = emptyHp
		LostScreen.show()
		get_tree().paused = true

func _on_answer_b_pressed() -> void:
	playerHealth -= 1
	
	if playerHealth == 2:
		pHp1.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 1:
		pHp2.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 0:
		pHp3.texture = emptyHp
		LostScreen.show()
		get_tree().paused = true

func _on_answer_c_pressed() -> void:
	if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false:
		vocabQ2.hide()
		choices2.hide()
		prompt_txt2.show()
	elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false:
		vocabQ3.hide()
		choices3.hide()
		prompt_txt3.show()
	else:
		vocabQ.hide()
		choices.hide()
		prompt_txt.show()
	timeReset.start()
	playerTurn = false
	enemyTurn = true
	currTurn.text = "Current Turn: Player"

func _on_answer_d_pressed() -> void:
	playerHealth -= 1
	
	if playerHealth == 2:
		pHp1.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 1:
		pHp2.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 0:
		pHp3.texture = emptyHp
		LostScreen.show()
		get_tree().paused = true

func _on_answer_e_pressed() -> void:
	if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false:
		vocabQ2.hide()
		choices2.hide()
		prompt_txt2.show()
	elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false:
		vocabQ3.hide()
		choices3.hide()
		prompt_txt3.show()
	else:
		vocabQ.hide()
		choices.hide()
		prompt_txt.show()
	timeReset.start()
	playerTurn = false
	enemyTurn = true
	currTurn.text = "Current Turn: Player"

func _on_answer_f_pressed() -> void:
	playerHealth -= 1
	
	if playerHealth == 2:
		pHp1.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 1:
		pHp2.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 0:
		pHp3.texture = emptyHp
		LostScreen.show()
		get_tree().paused = true

func _on_answer_g_pressed() -> void:
	if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false \
	&& is_instance_valid(vocabQ2) == true && is_instance_valid(choices2) == true:
		vocabQ2.hide()
		choices2.hide()
		prompt_txt2.show()
	elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false \
	&& is_instance_valid(vocabQ3) == true && is_instance_valid(choices3) == true:
		vocabQ3.hide()
		choices3.hide()
		prompt_txt3.show()
	else:
		vocabQ.hide()
		choices.hide()
		prompt_txt.show()
	timeReset.start()
	playerTurn = false
	enemyTurn = true
	currTurn.text = "Current Turn: Player"

func _on_answer_h_pressed() -> void:
	playerHealth -= 1
	
	if playerHealth == 2:
		pHp1.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false \
		&& is_instance_valid(vocabQ2) == true && is_instance_valid(choices2) == true:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false \
		&& is_instance_valid(vocabQ3) == true && is_instance_valid(choices3) == true:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 1:
		pHp2.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false \
		&& is_instance_valid(vocabQ2) == true && is_instance_valid(choices2) == true:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false \
		&& is_instance_valid(vocabQ3) == true && is_instance_valid(choices3) == true:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 0:
		pHp3.texture = emptyHp
		LostScreen.show()
		get_tree().paused = true

func _on_answer_i_pressed() -> void:
	playerHealth -= 1
	
	if playerHealth == 2:
		pHp1.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false \
		&& is_instance_valid(vocabQ2) == true && is_instance_valid(choices2) == true:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false \
		&& is_instance_valid(vocabQ3) == true && is_instance_valid(choices3) == true:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 1:
		pHp2.texture = emptyHp
		if is_instance_valid(vocabQ) == false && is_instance_valid(choices) == false \
		&& is_instance_valid(vocabQ2) == true && is_instance_valid(choices2) == true:
			vocabQ2.hide()
			choices2.hide()
			prompt_txt2.show()
		elif is_instance_valid(vocabQ2) == false && is_instance_valid(choices2) == false \
		&& is_instance_valid(vocabQ3) == true && is_instance_valid(choices3) == true:
			vocabQ3.hide()
			choices3.hide()
			prompt_txt3.show()
		else:
			vocabQ.hide()
			choices.hide()
			prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 0:
		pHp3.texture = emptyHp
		LostScreen.show()
		get_tree().paused = true
