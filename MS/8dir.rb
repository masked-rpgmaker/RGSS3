#==============================================================================
# MS - Movimento em 8 Direções
#------------------------------------------------------------------------------
# por Masked
#------------------------------------------------------------------------------
# O script permite que o jogador se movimente em 8 direções, é compatível com o
# script MBS - Spritesheet, ele usa o spriteset :isometric e :isometric_run
# para mudar o gráfico do personagem
#==============================================================================
module MS_8dir_Config
#==============================================================================
# Configurações
#==============================================================================
 
# Se quiser que o gráfico do ppersonagem seja mudado ao andar na diagonal,deixe
# como true
Change_Graphics = true
 
# O sufixo que o nome do char deve ter para ser usado como char andando na
# diagonal
DiagSFX = "_diag"
 
# Se estiver utilizando o script MBS - Spritesheet e quiser que o gráfico da
# diagonal seja um spriteset, deixe como true e configure um spriteset com
# nome :isometric, se não, deixe como false
MSSprite_DiagChar = true
 
#==============================================================================
# Fim das configurações
#==============================================================================
end
#==============================================================================
# ** Game_Player
#==============================================================================
class Game_Player < Game_Character
  include MS_8dir_Config
  #--------------------------------------------------------------------------
  # * Processamento de movimento através de pressionar tecla
  #--------------------------------------------------------------------------
  def move_by_input
    return if !movable? || $game_map.interpreter.running?
    case Input.dir8
    when 1
      @direction = 2
      move_diagonal(4,2)
    when 2
      move_straight(2)
    when 3
      @direction = 6
      move_diagonal(6,2)
    when 4
      move_straight(4)
    when 6
      move_straight(6)
    when 7
      @direction = 4
      move_diagonal(4,8)
    when 8
      move_straight(8)
    when 9
      @direction = 8
      move_diagonal(6,8)
    end
  end
end
#==============================================================================
# ** Game_Character
#==============================================================================
class Game_Character < Game_CharacterBase
  include MS_8dir_Config
  
  alias ms_mov_diag move_diagonal
  
  def move_diagonal(horz,vert)
    ms_mov_diag(horz,vert)
    spritesheet = !MBS_Spritesheet_Config.nil? && MSSprite_DiagChar == true
    Change_Graphics && spritesheet ? @pose = :isometric : (@character_name = "#{@character_name.sub(DiagSFX,"")}#{DiagSFX}" if FileTest.file?("#{@character_name.sub(DiagSFX,"")}#{DiagSFX}")) 
  end
  
  alias ms_mov_str move_straight
  
  def move_straight(dir,turn_ok=true)
    ms_mov_str(dir,turn_ok)
    spritesheet = !MBS_Spritesheet_Config.nil? && MSSprite_DiagChar == true
    Change_Graphics && spritesheet ? @pose = :default : @character_name = @character_name.sub(DiagSFX,"")
  end
end
