extends CanvasLayer

#variables
var reward_icon: Array[String] = [];
var reward_name: Array[String] = [];

@onready var reward_texture: TextureRect = $Control/PopupSizeHandler/Background/IconLimiter/IconPanel/IconContainer/IconSprite;
@onready var reward_text: Label = $Control/PopupSizeHandler/Background/TextLimiter/TextContainer/RewardText;

@onready var animation: AnimationPlayer = $Control/AnimationPlayer;

#functions
func add_to_queue(reward: String, icon: String = "res://assets/images/title/Star_Title_0.png") -> void:
    reward_icon.push_back(icon);
    reward_name.push_back(reward);

func showcase() -> void:
    if reward_name != [] && reward_icon != []:
        var size: int = reward_name.size();
        
        for i in range(size):
            reward_texture.texture = load(reward_icon[i]);
            reward_text.text = reward_name[i];
            animation.play("popup");
            await animation.animation_finished;
        
        for i in range(size):
            reward_icon.pop_front();
            reward_name.pop_front();
    else:
        return ;