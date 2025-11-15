@tool
extends EditorPlugin

# A class member to hold the editor export plugin  during its lifecycle
var export_plugin: AndroidExportPlugin

func _enter_tree():
    # Initialization of the plugin goes here.
    export_plugin = AndroidExportPlugin.new()
    add_export_plugin(export_plugin)

func _exit_tree():
    # Clean-up of the plugin goes here
    remove_export_plugin(export_plugin)
    export_plugin = null

class AndroidExportPlugin extends EditorExportPlugin:
    # TODO: Update yo your plugin's name
    var _plugin_name = "CodeQuestCompilerPythonLib"

    func _supports_platform(platform):
        if platform is EditorExportPlatformAndroid:
            return true
        return false

    func _get_android_libraries(platform, debug):
        if debug:
            return PackedStringArray(["code-quest_compiler_python/bin/debug/compilerlib-py312-debug.aar"])
        else:
            return PackedStringArray(["code-quest_compiler_python/bin/release/compilerlib-py312-release.aar"])

    func get_name():
        return _plugin_name