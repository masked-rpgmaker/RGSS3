class Scene_Menu < Scene_MenuBase
 
  def create_command_window
    @command_window = Window_MenuCommand.new
    @command_window.set_handler(:item,      method(:command_item))
    @command_window.set_handler(:skill,     method(:command_personal))
    @command_window.set_handler(:equip,     method(:command_personal))
    @command_window.set_handler(:status,    method(:command_personal))
    @command_window.set_handler(:points,    method(:command_points))
    @command_window.set_handler(:formation, method(:command_formation))
    @command_window.set_handler(:save,      method(:command_save))
    @command_window.set_handler(:game_end,  method(:command_game_end))
    @command_window.set_handler(:cancel,    method(:return_scene))
    end  
  def command_points
    SceneManager.call(Scene_MBS_Stat_Point)
    end
  end
class Window_MenuCommand < Window_Command
    def make_command_list
    add_main_commands
    add_command("Pontos",  :points,  true)
    add_formation_command
    add_original_commands
    add_save_command
    add_game_end_command
      end
    end
