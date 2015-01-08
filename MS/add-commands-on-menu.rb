#==============================================================================
# MS - Adicionar Comandos no Menu
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
($imported ||= {})[:ms_add_commands_in_menu] = true
#==============================================================================
# Configurações
#==============================================================================
module MS_AddCommandsInMenu
  
  # Lista com os comandos adicionais, para adicionar um novo comando, digite
  # entre os [] o seguinte código:
  # :cena => ["Texto",Scene_Cena,switch],
  # No lugar de :cena, ponha o identificador do comando, que será usado 
  # posteriormente, no lugar de Texto, ponha o texto que será escrito na 
  # janela de comandos, e no lugar de Scene_Cena ponha a classe da
  # cena a ser chamada com o comando
  # A switch deve ser substituída pelo ID da switch que habilita/bloqueia
  # o comando, se ela não for declarada, o comando estará sempre habilitado
  Add_Commands = {:quests => ["Missões",Scene_Quest]}
  
  # Lista com os comandos do menu, a ordem em que os identificadores dos 
  # comandos estiverem nessa lista será a ordem em que os respectivos comandos
  # aparecerão na janela de comandos do menu.
  # Os identificadores padrão são:
  # :item      => Itens
  # :skill     => Habilidades
  # :equip     => Equipamentos
  # :status    => Condições
  # :formation => Formação
  # :save      => Salvar
  # :game_end  => Sair
  Command_Order = [
  :item,
  :skill,
  :equip,
  :status,
  :quests,
  :formation,
  :save,
  :game_end]
  
end
#==============================================================================
# Fim das Configurações
#==============================================================================
#==============================================================================
# ** Scene_Menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  alias ms_crtmncomw create_command_window
  #--------------------------------------------------------------------------
  # * Criação da janela de comando
  #--------------------------------------------------------------------------
  def create_command_window
    ms_crtmncomw
    
    MS_AddCommandsInMenu::Add_Commands.each {|command|
      @command_window.set_handler(command[0], method(:command_check))
    }
    
  end
  #--------------------------------------------------------------------------
  # * Processamento do comando adicional
  #--------------------------------------------------------------------------
  def command_check
     SceneManager.call(MS_AddCommandsInMenu::Add_Commands[@command_window.current_symbol][1])
  end
end
#==============================================================================
# ** Window_MenuCommand
#==============================================================================
class Window_MenuCommand < Window_Command
  alias ms_cllokhndlr call_ok_handler
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def make_command_list
    
    MS_AddCommandsInMenu::Command_Order.each {|command|
      case command
      when :item
        add_command(Vocab::item,   :item,   main_commands_enabled)
      when :skill
        add_command(Vocab::skill,  :skill,  main_commands_enabled)
      when :equip
        add_command(Vocab::equip,  :equip,  main_commands_enabled)
      when :status
        add_command(Vocab::status, :status, main_commands_enabled)
      when :formation
        add_command(Vocab::formation, :formation, formation_enabled)
      when :save
        add_command(Vocab::save, :save, save_enabled)
      when :game_end
        add_command(Vocab::game_end, :game_end)
      else
        add_command(MS_AddCommandsInMenu::Add_Commands[command][0],command,MS_AddCommandsInMenu::Add_Commands[command][2] ? $game_switches[MS_AddCommandsInMenu::Add_Commands[command][2]] : true)
      end
    }
    
  end
end
