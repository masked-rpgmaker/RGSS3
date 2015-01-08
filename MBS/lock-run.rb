#==============================================================================
# MBS - Lock Run
#
# por Masked
#
# O script permite bloquear o uso da tecla SHIFT para correr quando uma switch 
# estiver ativa
#==============================================================================
#==============================================================================
# Configurações
#==============================================================================
module MS_LockRun_Config
   
  # ID da switch que desativa a corrida
  
  ID = 1
  
end
#==============================================================================
# Fim das configurações
#==============================================================================
class Game_Player < Game_Character
  
    def dash?
    return false if $game_switches[MS_LockRun_Config::ID]
    return false if @move_route_forcing
    return false if $game_map.disable_dash?
    return false if vehicle
    return Input.press?(:A)
  end
  
  end
