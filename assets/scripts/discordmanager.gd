extends Node

#functions
func _ready():
	DiscordRPC.app_id = 1467594714244186124;
	print("Discord working: " + str(DiscordRPC.get_is_discord_working()));
	#DiscordRPC.large_image = "";
	#DiscordRPC.large_image_text = "";
	#DiscordRPC.small_image = "";
	#DiscordRPC.small_image_text = "";
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system());
	#DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600;
	DiscordRPC.refresh();
	
func _update_details(d: String) -> void:
	DiscordRPC.details = d;
	DiscordRPC.refresh();
	
func _update_state(s: String) -> void:
	DiscordRPC.state = s;
	DiscordRPC.refresh();
