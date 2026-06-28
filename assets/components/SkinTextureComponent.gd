class_name SkinTextureComponent extends Component

#variables
@export_file("*.json") var data_json: String = "";
@export var load_at_start: bool = true;
@export var character_name: String;
@export var sprite_name: String;
@export var update_scale: bool = false;
@export var update_offset: bool = false;

var data: Dictionary = {};

#functions
func _ready() -> void:
    main.connect("update_skin", update_skin);
    if main.selected_skins[character_name] != "":
        if load_at_start:
            _load_skin();

func _load_skin() -> void:
    var file: FileAccess = FileAccess.open(data_json, FileAccess.READ);
    var json_text: String = file.get_as_text();

    data = JSON.parse_string(json_text);
    
    file.close();

    if main.selected_skins[character_name] != "":
        var datapath: Dictionary = data[character_name][main.selected_skins[character_name]][sprite_name];

        if get_parent() is Sprite2D || get_parent() is AnimatedSprite2D || get_parent() is TextureRect:
            get_parent().texture = load(datapath["Texture Path"]);
            if update_offset: get_parent().offset = Vector2(datapath["Offset X"], datapath["Offset Y"]);
            if update_scale: get_parent().scale = Vector2(datapath["Scale X"], datapath["Scale Y"]);
        elif get_parent() is AnimatedSprite2D:
            get_parent().sprite_frames = load(datapath["Texture Path"]);
        elif get_parent() is TextureButton:
            get_parent().texture_normal = load(datapath["Texture Path"]);
    else:
        return ;

func update_skin() -> void:
    _load_skin();