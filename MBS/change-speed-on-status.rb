#==============================================================================
# MBS - Status de Ferido
#
# por Masked
#==============================================================================
#==============================================================================
# Configurações
#==============================================================================
module MBS_Hurt_Config
  # ID do stado que muda a velocidade do personagem
  State_ID = 26
  
  # Velocidade ao ficar com o estado configurado
  Speed = 2
  
end
#==============================================================================
# Fim das Configurações
#==============================================================================
class Scene_Map
  alias mbs_update update
  def update
  mbs_update
  $game_party.members[0].state?(MBS_Hurt_Config::State_ID) ? $game_player.change_speed(MBS_Hurt_Config::Speed)  : $game_player.change_speed(4)
  end
  end
  class Game_Player
    alias mbs_update update
  def change_speed(speed)
    @move_speed = speed
    end
    end
