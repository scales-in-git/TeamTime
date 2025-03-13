class_name BaseSaveableItem
extends Node3D


@export var level: String
@export var id: String

func get_full_id() -> String:
    return _category() + ":" + level + "/" + id

func save():
    CollectiblesManager.register_collection(_category(), get_full_id(), _get_data())

func _category() -> String:
    assert(false, "_category() must be implemented in child class")
    return ''

func _get_data():
    assert(false, "_get_data() must be implemented in child class")

func _enter_tree():
    if CollectiblesManager.item_collected(_category(), get_full_id()):
        queue_free()

func _ready():
    # Note: Loading is expected to only occur on file select,
    #  this is here more as a debug qol
    SaveManager.loaded.connect(func ():
        if CollectiblesManager.item_collected(_category(), get_full_id()):
            queue_free()
    )
    