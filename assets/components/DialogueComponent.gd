class_name DialoguesComponent extends Node

signal dialogueFinished;

#variables
@export var parent : Control;
@export var output : Label;
@export var Lines : Array[String] = [];

var TimerNextWord : Timer = Timer.new();

var CurrentLine : int = -1;
var DialogueSize : int;

var selectedDialogue : bool = false;

#functions
func _ready() -> void:
	DialogueSize = Lines.size();
	
	add_child(TimerNextWord);
	TimerNextWord.wait_time = 0.1;
	TimerNextWord.one_shot = true;

func _reset() -> void:
	output.visible = false;
	output.text = "";
	output.visible_characters = 0;
	CurrentLine = -1;

func _input(_event: InputEvent) -> void:
	if main.isOnDialogue:
		if selectedDialogue && Input.is_action_just_pressed("DIALOGUE"):
			if output.visible_characters >= Lines[CurrentLine].length():
				if CurrentLine < DialogueSize - 1: _next_line();
				elif CurrentLine >= DialogueSize - 1: _stop_dialogue();

func _begin_dialogue() -> void:
	main.isOnDialogue = true;
	selectedDialogue = true;
	if parent:
		var t : Tween = create_tween();
		t.tween_property(parent,"modulate:a",1,0.5).set_trans(Tween.TRANS_CUBIC);
		await t.finished;
	output.visible = true;
	_next_line();

func _next_line() -> void:
	CurrentLine += 1;
	if output.text != Lines[CurrentLine]:
		output.text = Lines[CurrentLine];
	output.visible_characters = 0;
	for i in range(Lines[CurrentLine].length()):
		TimerNextWord.start();
		output.visible_characters += 1;
		await TimerNextWord.timeout;

func _stop_dialogue() -> void:
	main.isOnDialogue = false;
	selectedDialogue = false;
	_reset();
	if parent:
		var t : Tween = create_tween();
		t.tween_property(parent,"modulate:a",0,0.5).set_trans(Tween.TRANS_CUBIC);
		await t.finished;
	dialogueFinished.emit();
