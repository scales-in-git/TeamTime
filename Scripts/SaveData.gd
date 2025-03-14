# The @export inside the subclass may look weird, but they're actually needed
#  in order to have them saved on disk. 
class_name SaveData 
extends Resource

@export var name: String # No plans to let player name their save file
@export var play_time: float # In seconds
@export var collectibles: Dictionary
@export var last_save: float # Unix timestamp
@export var last_load: float # Unix timestamp
@export var game_started: float # Unix timestamp
@export var game_beaten: float # Unix timestamp. Will also determine if this file is beaten or not?
