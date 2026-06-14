extends Node

#functions
func _ready():
	DiscordRPC.app_id = 1467594714244186124;
	print("Discord working: " + str(DiscordRPC.get_is_discord_working()));
	DiscordRPC.large_image = "icon";
	#DiscordRPC.large_image_text = "Game Icon";
	#DiscordRPC.small_image = "icon";
	#DiscordRPC.small_image_text = "Small Game Icon";
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system());
	#DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600;
	DiscordRPC.refresh();
	
func _update_details(d: String) -> void:
	DiscordRPC.details = d;
	DiscordRPC.refresh();
	
func _update_state(s: String) -> void:
	DiscordRPC.state = s;
	DiscordRPC.refresh();