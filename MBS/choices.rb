#==============================================================================
# RGSS3 - Fábrica: Choices
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# Configurações
#==============================================================================
module RGSS3F_Choice_Config
  
  # Posições das janelas de escolha 
  Windows_Positions = {
  
  'x' => 16,
  'y' => [Graphics.height-106,Graphics.height-48]
  
  }
  
  # Tom da janela selecionada
  Selected_Window_Tone = Tone.new(0,170,0,30)
  
  # SE tocada ao mudar de opção
  Cursor_SE = "Cursor2"
  
  # SE tocada ao confirmar a escolha
  Confirm_SE = "Decision3"
#==============================================================================
# Fim das Configurações
#==============================================================================
end

module MBS_Choice
  
  @images = []
  
def self.add_image(standard,selected)
  file = [standard,selected]
  @images << file
end

def self.clear_image
  @images.clear
end

def self.return_image
  @images << @images[-2]
end

def self.image
  return @images[-1]
end
end
#==============================================================================
# ** Scene_Choices
#==============================================================================
$choicesss = false
class Scene_Choice < Scene_Base
  include RGSS3F_Choice_Config
  #==========================================================================#
  #                            Métodos principais                            #
  #--------------------------------------------------------------------------#
  #---------------------------------------------------------------------------
  # Inicialização do Processo 
  #---------------------------------------------------------------------------
  def start
    super
    # Criação das variáveis
    @choices = $game_message.choices
    @windows = []
    @index = 0
    @background = Spriteset_Map.new
    @old_index = 0
    # Métodos a serem chamados
    create_windows
    @windows[@index].selected = true
    @windows[@index].refresh unless @windows[@index].nil? || @windows[@index].disposed?
  end
  #---------------------------------------------------------------------------
  # Atualização do Processo
  #---------------------------------------------------------------------------
  def update
    super 
    @index += 1 if Input.trigger?(:RIGHT) && @choices.size > @index + 1
    @index -= 1 if Input.trigger?(:LEFT) && @index > 0
    @index += 2 if Input.trigger?(:DOWN) && @choices.size > @index + 2
    @index -= 2 if Input.trigger?(:UP) && @index > 1

    unless @old_index == @index
      Audio.se_play("Audio/SE/#{Cursor_SE}")
      @old_index = @index
      @windows.each {|window| window.selected = false}
      @windows[@index].selected = true
      @windows.each {|win| win.refresh} unless @windows[@index].nil? || @windows[@index].disposed?
    end
    
    if Input.trigger?(:B) && $game_message.choice_cancel_type > 0
      Audio.se_play("Audio/SE/#{Confirm_SE}")
      SceneManager.return
      $game_message.choice_proc.call($game_message.choice_cancel_type - 1)
    elsif Input.trigger?(:C)
      Audio.se_play("Audio/SE/#{Confirm_SE}")
      SceneManager.return
      $game_message.choice_proc.call(@index)
    end
  end
  def terminate
    $game_message.clear
    $game_map.interpreter.choice_done = true
    super
    @background.dispose
  end
  #--------------------------------------------------------------------------#
  #                                   Fim                                    #
  #==========================================================================#
  
  #==========================================================================#
  #                            Métodos auxiliares                            #
  #--------------------------------------------------------------------------#
  #---------------------------------------------------------------------------
  # Criação das janelas de escolha
  #---------------------------------------------------------------------------
  def create_windows  
    i = 0
    @choices.each {|choice|
    @windows << Window_Choice.new(@choices.size,i,choice)
    i += 1
    }
  end
  #--------------------------------------------------------------------------#
  #                                   Fim                                    #
  #==========================================================================#  
end
#==============================================================================
# ** Window_Choice
#==============================================================================
class Window_Choice < Window_Base
  include RGSS3F_Choice_Config
  
  attr_accessor :selected
  
  #==========================================================================#
  #                            Métodos principais                            #
  #--------------------------------------------------------------------------#
  #---------------------------------------------------------------------------
  # Inicialização do Objeto
  #---------------------------------------------------------------------------
  def initialize(choice_number,number,choice)
    # Criação das variáveis
    @selected = false
    @number=number
    width = get_width(choice_number)
    x = get_x(choice_number,number)
    y = get_y(choice_number,number)
    
    # Métodos a serem chamados
    super(x,y,width,48)
    
    unless MBS_Choice::image.nil?
      self.windowskin = Bitmap.new(1,1)
      @skin = Sprite.new
      @skin.bitmap = Cache.system(MBS_Choice::image[0])
      @skin.x = x
      @skin.y = y
      @skin.zoom_x = width/@skin.width.to_f
      @skin.zoom_y = 48/@skin.height.to_f
    end
    
    self.contents.draw_text(0,0,self.width,24,choice)
  end
  #---------------------------------------------------------------------------
  # Atualização do Objeto
  #---------------------------------------------------------------------------
  def refresh
    if @selected && @skin.nil?
      self.tone = Selected_Window_Tone
    elsif @skin.nil?
      self.tone = $game_system.window_tone
    end
    
    if @selected && !@skin.nil?
      @skin.bitmap = Cache.system(MBS_Choice::image[1])
    elsif !@skin.nil?
      @skin.bitmap = Cache.system(MBS_Choice::image[0])
    end
  end
  #--------------------------------------------------------------------------#
  #                                   Fim                                    #
  #==========================================================================#
  #==========================================================================#
  #                            Métodos auxiliares                            #
  #--------------------------------------------------------------------------#
  def get_width(choice_number)
    case choice_number
    when 1
      return Graphics.width-Windows_Positions['x']*2
    when 2..4
      return (Graphics.width-Windows_Positions['x']*2)/2-Windows_Positions['x']
    end
  end
  
  def get_x(choice_number,number)
    case choice_number
    when 1..2
      Windows_Positions['x'] + (get_width(choice_number)+Windows_Positions['x']*(number+1))*number
    when 3
      case number
      when 0
        Windows_Positions['x'] + (get_width(choice_number)+Windows_Positions['x']*(number+1))*number
      when 1
        Windows_Positions['x'] + (get_width(choice_number)+Windows_Positions['x']*(number+1))*number
      when 2
        Windows_Positions['x'] + (get_width(choice_number)+Windows_Positions['x'])*0.5
      end
    when 4
      case number
      when 0..1
        Windows_Positions['x'] + (get_width(choice_number)+Windows_Positions['x']*(number+1))*number
      when 2..3
        Windows_Positions['x'] + (get_width(choice_number)+Windows_Positions['x']*(number-1))*(number-2)
      end
    end
  end
  
  def get_y(choice_number,number)
    case choice_number
    when 1..2
      return Windows_Positions['y'][0]
    when 3
      case number
      when 0..1
        return Windows_Positions['y'][0]
      when 2
        return Windows_Positions['y'][1]
      end
    when 4
      return Windows_Positions['y'][number/2]
    end
  end
  #--------------------------------------------------------------------------#
  #                                   Fim                                    #
  #==========================================================================#
end

class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # * Criação de todas as janelas
  #--------------------------------------------------------------------------
  def create_all_windows
    @gold_window = Window_Gold.new
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = 0
    @gold_window.openness = 0
    @number_window = Window_NumberInput.new(self)
    @item_window = Window_KeyItem.new(self)
  end
  #--------------------------------------------------------------------------
  # * Disposição de todas as janelas
  #--------------------------------------------------------------------------
  def dispose_all_windows
    @gold_window.dispose
    @number_window.dispose
    @item_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Atualização de todas as janelas
  #--------------------------------------------------------------------------
  def update_all_windows
    @gold_window.update
    @number_window.update
    @item_window.update
  end
  #--------------------------------------------------------------------------
  # * Execução da entrada de comandos
  #--------------------------------------------------------------------------
  def process_input
    if $game_message.num_input?
      input_number
    elsif $game_message.item_choice?
      input_item
    else
      input_pause unless @pause_skip
    end
  end
  #--------------------------------------------------------------------------
  # * Definição se todas as jalenas estão fechadas
  #--------------------------------------------------------------------------
  def all_close?
    close? && @number_window.close? && @item_window.close?
  end
end
#==============================================================================
# ** Game_Interpreter
#==============================================================================
class Game_Interpreter
  attr_accessor :choice_done
  alias mbs_init initialize
  def initialize
  mbs_init
  @choice_done = false
  end
  #==========================================================================#
  #                           Método a ser editado                           #
  #--------------------------------------------------------------------------#
  alias mbs_comm command_102
  def command_102
    wait_for_message
    @params[0].each {|s| $game_message.choices.push(s) }
    $game_message.choice_cancel_type = @params[1]
    $game_message.choice_proc = Proc.new {|n| @branch[@indent] = n }
    SceneManager.call(Scene_Choice)
    Fiber.yield while @choice_done == false
    @choice_done = false
  end
  #--------------------------------------------------------------------------
  # * Mostrar Mensagem
  #--------------------------------------------------------------------------
  def command_101
    wait_for_message
    $game_message.face_name = @params[0]
    $game_message.face_index = @params[1]
    $game_message.background = @params[2]
    $game_message.position = @params[3]
    while next_event_code == 401       # Texto
      @index += 1
      $game_message.add(@list[@index].parameters[0])
    end
    case next_event_code
    when 103  # Entrada numérica
      @index += 1
      setup_num_input(@list[@index].parameters)
    when 104  # Selecionar item
      @index += 1
      setup_item_choice(@list[@index].parameters)
    end
    wait_for_message
  end
  #--------------------------------------------------------------------------#
  #                                  Fim                                     #
  #==========================================================================#
end
