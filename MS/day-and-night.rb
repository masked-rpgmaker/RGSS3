#==============================================================================
# MS - Real Time Day and Night System
#
# O script cria um sistema de dia e noite baseando-se no horário do computador,
# conforme o horário for atingindo os números definidos nas configurações, o 
# tom da tela muda para o tom definido para o horário.
#
#==============================================================================

module MS_Time_Config
  
#==============================================================================
# Configurações:
#==============================================================================
  
  Hours = {

  # Configuração das horas, lembre-se de configurar conforme o sistema 24h
  
  'sunrise' => 6,     # Hora do nascer do sol
  'morning' => 7,     # Hora do começo da manhã
  'day' => 12,        # Hora do meio dia
  'afternoon' => 16,  # Hora do começo da tarde
  'sunset' => 18,     # Hora do pôr do sol
  'night' => 19       # Hora do começo da noite
  
  }
  
  Tones = {
  
  # Configuração dos Tons, para criar um tom, use o modelo:
  # Tone.new(Tom de vermelho, Tom de Verde, Tom de azul, Tom de cinza)
  # O tom de cinza é opcional.
  
  'sunrise' => Tone.new(-110, -110, -110), # Tom do nascer do sol
  'morning' => Tone.new(0, -5, -50),       # Tom da manhã
  'day' => Tone.new(0, 0, 0, 0),           # Tom do meio dia
  'afternoon' => Tone.new(0, -30, -55),    # Tom da tarde
  'sunset' => Tone.new(-100, -130, -155),  # Tom do pôr do sol
  'night' => Tone.new(-175, -175, -125)    # Tom da noite
  
  }  
  
  Switches = {
  
  # Configuração das switches, o número se refere ao ID da switch.
  
  'sunrise' => 1,   # Switch do nascer do sol
  'morning' => 2,   # Switch da manhã
  'day' => 3,       # Switch do meio dia
  'afternoon' => 4, # Switch da tarde
  'sunset' => 5,    # Switch do pôr do sol
  'night' => 6      # Switch da noite
  
  }
  
  Variables = {
  
  # Configuração das variáveis, o primeiro número é o ID da variável e o 
  # segundo é o valor que ela adquirirá
  
  'sunrise' => [1, 1],   # Variável do nascer do sol
  'morning' => [1, 2],   # Variável da manhã
  'day' => [1, 3],       # Variável do meio dia
  'afternoon' => [1, 4], # Variável da tarde
  'sunset' => [1, 5],    # Variável do pôr do sol
  'night' => [1, 6]      # Variável da noite
  
  }
  
  Change_Duration = 60  # Duração da alteração de tom da tela
  
end

#==============================================================================
# Fim das Configurações
#==============================================================================

class Scene_Map
  
   include MS_Time_Config
   
  alias ms_start start
  alias ms_update update
  
  def start
    ms_start
    
    @time = Time.now.hour
    refresh_time(0)
    
  end
    
  def update
    ms_update
    
    unless @time == Time.now.hour
    
      refresh_time(Change_Duration)
      
    end
    
  end
  
  def refresh_time(d)
    
  if Time.now.hour >= Hours['sunrise']
     
  if Time.now.hour >= Hours['morning']
    
  if Time.now.hour >= Hours['day']
    
  if Time.now.hour >= Hours['afternoon']
    
  if Time.now.hour >= Hours['sunset']  
    
  if Time.now.hour >= Hours['night']
  
    $game_map.screen.start_tone_change(Tones['night'], d)
    $game_switches[Switches['night']] = true
    $game_variables[Variables['night'][0]] = Variables['night'][1]
    
    else
    
    $game_map.screen.start_tone_change(Tones['sunset'], d)
    $game_switches[Switches['sunset']] = true
    $game_variables[Variables['sunset'][0]] = Variables['sunset'][1]  
    
  end
    
else
  
  $game_map.screen.start_tone_change(Tones['afternoon'], d)
  $game_switches[Switches['afternoon']] = true
  $game_variables[Variables['afternoon'][0]] = Variables['afternoon'][1]
  
  end
  
else
  
  $game_map.screen.start_tone_change(Tones['day'], d)
  $game_switches[Switches['day']] = true
  $game_variables[Variables['day'][0]] = Variables['day'][1]
    
  end
  
else
  
  $game_map.screen.start_tone_change(Tones['morning'], d)
  $game_switches[Switches['morning']] = true
  $game_variables[Variables['morning'][0]] = Variables['morning'][1]  
  
  end
  
else
  
  $game_map.screen.start_tone_change(Tones['sunrise'], d)
  $game_switches[Switches['sunrise']] = true
  $game_variables[Variables['sunrise'][0]] = Variables['sunrise'][1]
  
  end
    
else
  
  $game_map.screen.start_tone_change(Tones['night'], d)
  $game_switches[Switches['night']] = true
  $game_variables[Variables['night'][0]] = Variables['night'][1]
  
  end

end

end
