#==============================================================================
# MBS - SpriteSheet Characters
#------------------------------------------------------------------------------
# Script por Masked
# Ideia dada por Shiroyasha, no tópico do jogo 'Rise of Dragon Souls'
#------------------------------------------------------------------------------
# O script faz com que os gráficos dos personagens e eventos seja carregado de
# um único arquivo, com todas as poses e frames, é possível criar animações com
# mais de 3 frames, criar animações customizadas, como poses para um ABS, por
# exemplo.
#==============================================================================
module MBS_Spritesheet_Config
#==============================================================================
# Configurações:
#==============================================================================
 
# A tag que deverá aparecer no gráfico para este ser um Spritesheet
Spritesheet_tag = "[sprite]"
 
# Aqui são configurados os characters, seus frames e poses
Characters = {"player[sprite]" => {
 
# Padrão
:default => [
# Gráficos do personagem olhando abaixo
[[508,134,37,90],[556,132,36,92],[601,131,36,94],[648,131,35,92],[694,134,37,90],[743,133,35,91],[789,131,33,93],[834,131,34,93]],
# Gráficos do personagem olhando a esquerda
[[509,331,27,91],[545,332,34,91],[589,333,44,91],[645,332,36,91],[693,332,29,91],[730,333,32,91],[774,333,43,91],[828,333,39,90]],
# Gráficos do personagem olhando a direita
[[509,331,27,91,true],[545,332,34,91,true],[589,333,44,91,true],[645,332,36,91,true],[693,332,29,91,true],[730,333,32,91,true],[774,333,43,91,true],[828,333,39,90,true]],
# Gráficos do personagem olhando acima
[[508,533,36,90],[555,531,36,92],[602,531,34,93],[648,531,34,93],[694,534,36,89],[742,530,35,93],[789,531,33,94],[834,532,34,91]]
],
}}
#==============================================================================
# Fim das Configurações
#==============================================================================
end
#==============================================================================
# Sprite_Character
#==============================================================================
class Sprite_Character < Sprite_Base
  include MBS_Spritesheet_Config
 
  alias ms_upd update
  def update
    ms_upd
    force_animation(@character.anime_force_frames,@character.anime_force_wait) if @character.anime_force
  end
  #----------------------------------------------------------------------------
  # * Atualização do retângulo de origem
  #----------------------------------------------------------------------------
  def update_src_rect
    unless @character_name.nil?
    if @character_name.include?(Spritesheet_tag)
      index = @character.character_index
      direction = @character.direction/2-1
      direction = 0 if direction < 0
      unless Characters[@character.character_name].keys.include?(@character.pose)
        @character.pose = :default
      end
      @char = Characters[@character.character_name][@character.pose][direction]
      pattern = @character.pattern < @char.size ? @character.pattern : 1
      @char = Characters[@character.character_name][@character.pose][direction][pattern-1]
      self.mirror = @char[4]
      self.src_rect.set(@char[0],@char[1],@char[2],@char[3])
    elsif @tile_id == 0
      index = @character.character_index
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
  end
end
end
alias ms_s_char_bit set_character_bitmap
  #--------------------------------------------------------------------------
  # * Definição de bitmap do personagem
  #--------------------------------------------------------------------------
  def set_character_bitmap
    ms_s_char_bit
    if @character_name.include?(Spritesheet_tag)
      unless Characters[@character.character_name].keys.include?(@character.pose)
        @character.pose = :default
      end
    direction = @character.direction/2-1
    direction = 0 if direction < 0 ||direction.nil?
    char = Characters[@character.character_name][@character.pose][direction]
    @character.pattern = 0 if char[@character.pattern].nil? 
    self.ox = char[@character.pattern][2]/2
    self.oy = char[@character.pattern][3]
    end
  end
  #----------------------------------------------------------------------------
  # * Forçamento de animação
  #----------------------------------------------------------------------------
  def force_animation(frames,wait)
        if wait.is_a?(Integer)
                pr = ->(i) { Graphics.wait(wait) }
        elsif wait.is_a?(Array)
                pr = ->(i) { Graphics.wait(wait[i%wait.size]) }
        else
                pr = ->(i) { }
        end
               
        frames.each {|i|
                @character.pattern = i
                update_src_rect
                Graphics.update
                pr[i]
        }
       
        @character.anime_force = false
end
end
#==============================================================================
# Game_CharacterBase
#==============================================================================
class Game_CharacterBase
  include MBS_Spritesheet_Config
  attr_accessor :pose
  attr_accessor :anime_force
  attr_accessor :anime_force_frames
  attr_accessor :anime_force_wait
  attr_accessor :pattern
 
  alias ms_init initialize
  #----------------------------------------------------------------------------
  # * Inicialização do Processo
  #----------------------------------------------------------------------------
  def initialize
    @pose = :default
    @anime_force = false
    @anime_force_wait = 0
    @anime_force_frames = []
    ms_init
  end
  #----------------------------------------------------------------------------
  # * Atualização do padrão da animação
  #----------------------------------------------------------------------------
  def update_anime_pattern
  unless @character_name.nil? || @anime_force == true
    unless @character_name.include?(Spritesheet_tag)
    if !@step_anime && @stop_count > 0
      @pattern = @original_pattern
    else
      @pattern = (@pattern + 1) % 4
    end
  else
      dir = @direction/2-1
      dir = 0 if dir < 0
    if !@step_anime && @stop_count > 0
      @pattern = @original_pattern
    else
      @pattern = (@pattern + 1) % Characters[@character_name][Characters[@character_name].keys.include?(@pose) ? @pose : :default][dir].size
    end
  end
end
end
  #----------------------------------------------------------------------------
  # * Forçamento de animação
  #----------------------------------------------------------------------------
  def force_animation(frames,wait=6)
   @anime_force = true
   @anime_force_frames = frames
   @anime_force_wait = wait
  end
end
