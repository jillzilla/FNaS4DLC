class_name RoomTravelComponent extends Node

signal doneTraveling;

#variables
enum inputs {ENTERED, PRESSED};

@export var input: Variant = inputs.PRESSED;
@export var button: Button;
@export var walkSFX: AudioStreamPlayer;

@export var room: Sprite2D;
@export var roomPosition: Vector2;

@export var fadeTransition: AnimationPlayer;

@export var scrolling: ScrollingComponent;
@export var disableScrolling: bool = true;

@export var camEffect: bool = true;

@export var camPosYEffectStart: float;
@export var camPosYEffectEnd: float;

@export var buttonToDisable: Array[Button];
@export var buttonToActivate: Array[Button];

@export var roomToLeave: Array[Sprite2D];
@export var roomToLeavePosition: Array[Vector2];

@export var flashlight: FlashLightComponent;

@export var mask: Node2D;
@export var canUseMaskHere: bool = false;

@export var disabled: bool = false;

@export var shadow_mario: Sprite2D;
@export var big: Sprite2D;
@export var toadette: Sprite2D;
@export var golden: Sprite2D;

#functions
func _ready() -> void:
	button.connect("pressed", _pressed);
	button.connect("mouse_entered", _entered);
	if roomToLeave != []:
		for i in range(roomToLeave.size()):
			if roomToLeave[i].visible:
				roomToLeave[i].visible = false;
			if roomToLeave[i].position != roomToLeavePosition[i]:
				roomToLeave[i].position = roomToLeavePosition[i];

func _travel() -> void:
	if main.PlayerNotMoving && !mask.isUsingMask && !mask.PuttingMask:
		main.PlayerNotMoving = false;

		walkSFX.play();
		scrolling.disable = true;

		for i in range(buttonToDisable.size()):
			buttonToDisable[i].mouse_filter = Control.MOUSE_FILTER_IGNORE;
			
		for i in range(buttonToActivate.size()):
			buttonToActivate[i].mouse_filter = Control.MOUSE_FILTER_STOP;

		if roomToLeave != []:
			for i in range(roomToLeave.size()):
				if roomToLeave[i].get_node("RoomTravelComponent").flashlight:
					if roomToLeave[i].get_node("RoomTravelComponent").flashlight.enabled:
						roomToLeave[i].get_node("RoomTravelComponent").flashlight.enabled = false;
				if roomToLeave[i].get_node("RoomTravelComponent").canUseMaskHere:
					if mask.canUseMask:
						mask.canUseMask = false;
		
		fadeTransition.play("fade");

		await fadeTransition.animation_finished;

		fadeTransition.play_backwards("fade");
		
		if get_parent().name == "Office":
			if main.random_chance(0.05):
				shadow_mario.modulate.a = 1;
				var tween: Tween = create_tween();
				tween.tween_property(shadow_mario, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_CUBIC);

		elif get_parent().name == "Hallway":
			if main.random_chance(0.1):
				big.visible = true;
			else:
				big.visible = false;
			
			if main.random_chance(0.05):
				golden.visible = true;
			else:
				golden.visible = false;
				
		elif get_parent().name == "Left_Vent" || get_parent().name == "Right_Vent":
			if main.random_chance(0.1):
				toadette.visible = true;
			else:
				toadette.visible = false;

		if !disableScrolling:
			scrolling.disable = false;

		scrolling._center_camera();

		room.visible = true;
		room.position = roomPosition;

		if roomToLeave != []:
			for i in range(roomToLeave.size()):
				if roomToLeave[i].visible:
					roomToLeave[i].visible = false;
				if roomToLeave[i].position != roomToLeavePosition[i]:
					roomToLeave[i].position = roomToLeavePosition[i];

		main.PlayerPosition = room.name;

		if camEffect:
			scrolling.get_parent().position.y = camPosYEffectStart;
			var camMove: Tween = create_tween();
			camMove.tween_property(scrolling.get_parent(), "position:y", camPosYEffectEnd, 0.5).set_trans(Tween.TRANS_CUBIC);
			await camMove.finished;

		if canUseMaskHere:
			mask.canUseMask = true;

		if flashlight:
			flashlight.enabled = true;

		main.PlayerNotMoving = true;
		
		doneTraveling.emit();

func _pressed() -> void:
	if input == inputs.PRESSED && main.PlayerAlive && !disabled:
		_travel();

func _entered() -> void:
	if !main.ntsDeskRunning && !main.ntmDeskWalking && !main.ncDeskWalking && !main.nlnDeskWalking:
		if input == inputs.ENTERED && main.PlayerAlive && !disabled:
			_travel();
