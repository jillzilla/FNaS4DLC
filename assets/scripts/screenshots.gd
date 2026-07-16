extends Node

#variables
const FOLDER_DIR: String = "user://";
const SCREENSHOT_FOLDER_NAME: String = "screenshots";
const SCREENSHOT_DEFAULT_NAME: String = "screenshot_";

#functions
func _ready() -> void:
    var dir: DirAccess = DirAccess.open(FOLDER_DIR);
    dir.make_dir(SCREENSHOT_FOLDER_NAME);

    dir = DirAccess.open(FOLDER_DIR + SCREENSHOT_FOLDER_NAME);

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("SCREENSHOT"):
        screenshot();

func screenshot() -> void:
    await RenderingServer.frame_post_draw;

    var viewport: Viewport = get_viewport();
    var image: Image = viewport.get_texture().get_image();
    
    image.save_png(FOLDER_DIR + SCREENSHOT_FOLDER_NAME + "/" + SCREENSHOT_DEFAULT_NAME + str(main.save_data_file.saved_screenshots) + ".png");
    
    main.save_data_file.saved_screenshots += 1;
    main._save();