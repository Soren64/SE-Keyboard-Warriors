extends Node2D

@onready var enemy_container = $EnemyContainer
@onready var currTurn = $Turn
@onready var enemy1 = $EnemyContainer/Enemy
@onready var prompt_txt = $EnemyContainer/Enemy/RichTextLabel
@onready var vocabQ = $EnemyContainer/Enemy/RichTextLabel2
@onready var choices = $EnemyContainer/Enemy/Choices
@onready var A = $EnemyContainer/Enemy/Choices/AnswerA
@onready var B = $EnemyContainer/Enemy/Choices/AnswerB
@onready var C = $EnemyContainer/Enemy/Choices/AnswerC
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
					active_enemy.queue_free()
					active_enemy = null
					enemy_count -= 1
				if enemy_count == 0:
					EndScreen.show()
					get_tree().paused = true
					save_game()
			else:
				print("failure!")
				
func save_game():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_string("res://assets/levels/level1.tscn")
	save_file.close()

func _on_timer_timeout() -> void:
	if playerTurn == true:
		vocabQ.hide()
		choices.hide()
		prompt_txt.show()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	
	if enemyTurn == true:
		current_letter_index = -1
		enemy1.reset_prompt()
		vocabQ.show()
		choices.show()
		prompt_txt.hide()
		enemyTurn = false
		playerTurn = true
		currTurn.text = "Current Turn: Enemy"
		
func _on_answer_a_pressed() -> void:
	vocabQ.hide()
	choices.hide()
	prompt_txt.show()
	timeReset.start()
	playerTurn = false
	enemyTurn = true
	currTurn.text = "Current Turn: Player"

func _on_answer_b_pressed() -> void:
	playerHealth -= 1
	
	if playerHealth == 2:
		pHp1.texture = emptyHp
		vocabQ.hide()
		choices.hide()
		prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 1:
		pHp2.texture = emptyHp
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
	playerHealth -= 1
	
	if playerHealth == 2:
		pHp1.texture = emptyHp
		vocabQ.hide()
		choices.hide()
		prompt_txt.show()
		timeReset.start()
		playerTurn = false
		enemyTurn = true
		currTurn.text = "Current Turn: Player"
	if playerHealth == 1:
		pHp2.texture = emptyHp
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
