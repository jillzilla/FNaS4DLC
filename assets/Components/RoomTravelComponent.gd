class_name RoomTravelComponent extends Node

#variables
enum inputs {ENTERED,PRESSED};

@export var input : Variant = inputs.PRESSED;
@export var button : Button;

@export var room : Sprite2D;
@export var roomPosition : Vector2;

@export var fadeTransition : AnimationPlayer;

@export var scrolling : ScrollingComponent;
@export var disableScrolling : bool = true;

@export var camEffect : bool = true;

@export var camPosYEffectStart : float;
@export var camPosYEffectEnd : float;

@export var buttonToDisable : Array[Button];
@export var buttonToActivate : Array[Button];

@export var roomToLeave : Array[Sprite2D];
@export var roomToLeavePosition : Array[Vector2];

@export var flashlight : FlashLightComponent;

#functions
func _ready() -> void:
	button.connect("pressed",_pressed);
	button.connect("mouse_entered",_entered);

func _travel() -> void:
	if scrolling.get_parent().position.y == camPosYEffectEnd:
		scrolling.disable = true;

		for i in range(buttonToDisable.size()):
			if buttonToDisable[i].visible:
				buttonToDisable[i].visible = false;

		if roomToLeave != []:
			for i in range(roomToLeave.size()):
				if roomToLeave[i].get_node("RoomTravelComponent").flashlight:
					if roomToLeave[i].get_node("RoomTravelComponent").flashlight.enabled:
						roomToLeave[i].get_node("RoomTravelComponent").flashlight.enabled = false;
		
		fadeTransition.play("fade");

		await fadeTransition.animation_finished;

		if !disableScrolling:
			scrolling.disable = false;
		scrolling._center_camera();

		if camEffect:
			scrolling.get_parent().position.y = camPosYEffectStart;
			var camMove : Tween = create_tween();
			camMove.tween_property(scrolling.get_parent(),"position:y",camPosYEffectEnd,0.5).set_trans(Tween.TRANS_CUBIC);

		for i in range(buttonToActivate.size()):
			if !buttonToActivate[i].visible:
				buttonToActivate[i].visible = true;
		
		if roomToLeave != []:
			for i in range(roomToLeave.size()):
				if roomToLeave[i].visible:
					roomToLeave[i].visible = false;
				if roomToLeave[i].position != roomToLeavePosition[i]:
					roomToLeave[i].position = roomToLeavePosition[i];

		if flashlight:
			flashlight.enabled = true;
		room.visible = true;
		room.position = roomPosition;

		fadeTransition.play_backwards("fade");

func _pressed() -> void:
	if input == inputs.PRESSED:
		_travel();

func _entered() -> void:
	if input == inputs.ENTERED:
		_travel();
