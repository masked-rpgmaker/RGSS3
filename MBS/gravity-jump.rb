#==============================================================================
# MBS - Gravity Jump [por Masked]
#------------------------------------------------------------------------------
# [Funções]
#
# GravityJump.gravity     : Retorna a gravidade do sistema
# GravityJump.gravity = X : Define a gravidade para X
# GravityJump.height      : Retorna a altura de um pulo com a gravidade atual
# GravityJump.radix       : Retorna as raízes da parábola do pulo
# GravityJump.length      : Retorna a distância entre as raízes da parábola
# GravityJump.parabola(x) : Retorna a cordenada Y na parábola equivalente a X
#==============================================================================
$imported ||= {}
$imported[:mbs_gravity_jump] = true
#==============================================================================
# ** GravityJump
#------------------------------------------------------------------------------
# Módulo com as principais funções e valores usados pelo script
#==============================================================================
module GravityJump
#==============================================================================
# ** Configurações
#==============================================================================

  HEIGHT = 0.3                 # Altura do pulo em tiles
  @@_gravity = 0.9807          # Gravidade (da Terra, no caso)
  
  DIVISION_RATE = 16.0         # Grau de divisão (quanto menor for, mais rápido
                               # é o pulo)
  
#==============================================================================
# Fim das configurações
#==============================================================================
  #--------------------------------------------------------------------------
  # * Obtém a gravidade atual do sistema
  #--------------------------------------------------------------------------
  def self.gravity
    return @@_gravity
  end
  #--------------------------------------------------------------------------
  # * Define a gravidade atual do sistema
  #--------------------------------------------------------------------------
  def self.gravity=(n)
    @@_gravity = n
  end
  #--------------------------------------------------------------------------
  # * Obtém a altura do pulo
  #--------------------------------------------------------------------------
  def self.height
    return HEIGHT / gravity
  end
  #--------------------------------------------------------------------------
  # * Obtém as raízes da parábola
  #--------------------------------------------------------------------------
  def self.radix
    d = 1 + 4 * height
    r = []
    r[0] = (1 + Math.sqrt(d)) / 2
    r[1] = (1 - Math.sqrt(d)) / 2
    return r
  end
  #--------------------------------------------------------------------------
  # * Obtém a largura do pulo
  #--------------------------------------------------------------------------
  def self.length
    r = radix
    return (r.max - r.min)
  end
  #--------------------------------------------------------------------------
  # * Fórmula de 2º grau para a parábola do pulo
  #--------------------------------------------------------------------------
  def self.parabola(x)
    return (-x * x) + x + height
  end
end
#==============================================================================
# ** Game_CharacterBase
#==============================================================================
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Inicialização de variáveis privadas
  #--------------------------------------------------------------------------
  alias mbsoldinit_private_members init_private_members
  def init_private_members
    mbsoldinit_private_members
    @jump_duration = 0
    @jump_x_rate = 0
    @jump_y_rate = 0
  end
end
#==============================================================================
# ** Game_Character
#==============================================================================
class Game_Character < Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Salto
  #     x_plus : valor adicional da coordenada X
  #     y_plus : valor adicional da coordenada Y
  #--------------------------------------------------------------------------
  def jump(x_plus, y_plus)
    if x_plus.abs > y_plus.abs
      set_direction(x_plus < 0 ? 4 : 6) if x_plus != 0
    else
      set_direction(y_plus < 0 ? 8 : 2) if y_plus != 0
    end
    @x += x_plus
    @y += y_plus
    distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
    @jump_peak = distance
    @jump_duration = GravityJump.length
    @jump_x_rate = (@x-@real_x)/@jump_duration/GravityJump::DIVISION_RATE#32.0
    @jump_y_rate = (@y-@real_y)/@jump_duration/GravityJump::DIVISION_RATE#32.0
    @jump_count = @jump_duration
    @stop_count = 0
    straighten
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura do salto
  #--------------------------------------------------------------------------
  def jump_height
    @jump_duration ||= 0
    h = GravityJump.parabola(GravityJump.radix.min + @jump_duration - @jump_count)
    h
  end
  #--------------------------------------------------------------------------
  # * Definição de coordenada Y na tela
  #--------------------------------------------------------------------------
  def screen_y
    $game_map.adjust_y(@real_y) * 32 + 32 - shift_y - jump_height * 32
  end
  #--------------------------------------------------------------------------
  # * Atualização do salto
  #--------------------------------------------------------------------------
  def update_jump
    @jump_count -= 1/GravityJump::DIVISION_RATE#32.0
    @real_x += @jump_x_rate
    @real_y += @jump_y_rate
    update_bush_depth
    if @jump_count <= 0
      @real_x = @x = $game_map.round_x(@x)
      @real_y = @y = $game_map.round_y(@y)
      @jump_count = 0
      @jump_duration = 0
    end
  end
end
#==============================================================================
# ** Game_Player
#==============================================================================
class Game_Player
  #--------------------------------------------------------------------------
  # * Atualização do salto
  #--------------------------------------------------------------------------
  def jump_by_input
    return unless Input.trigger?(:X) && !jumping?
    
    d = @move_speed / 4
    x = 0
    y = 0
    
    if Input.press?(:RIGHT)
        x = d
    elsif Input.press?(:LEFT)
        x = -d
      end
      
    if Input.press?(:UP)
        y = -d
    elsif Input.press?(:DOWN)
        y = d
      end
      
    jump(x, y)
    
  end
  #--------------------------------------------------------------------------
  # * Atualização
  #--------------------------------------------------------------------------
  alias mbsoldupdate update
  def update
    mbsoldupdate
    jump_by_input
  end
end
