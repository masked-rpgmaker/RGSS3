#==============================================================================
# MBS - Animated GameOver
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
$imported ||= Hash.new
$imported[:mbs_animated_gameover] = true
#==============================================================================
# Configurações
#==============================================================================
module MBS_AnimatedGameOver_Config
  
  # Número de camadas que a tela de gameover apresenta
  # esse número não inclui a camada do fundo
  LAYERS = 1
  
  # Nome das imagens usadas, elas devem estar na ordem 
  # das camadas e devem estar na pasta Graphics/System
  # lembrando que a imagem de fundo deve chamar 
  # GameOver, essas imagens são apenas imagens adicionais
  IMAGES = ["Eyes"]
  
  # Posição
  
  # Efeitos que as imagens possuem, devem estar na ordem
  # das camadas, os efeitos podem ser:
  # :blink  => piscar
  # :wave   => ondular
  # :erase  => apagar (como piscar, mas ele apaga e não volta mais)
  # :appear => aparecer (como piscar, mas ele aparece e não desaparece mais) 
  # nil     => sem efeito
  EFFECTS = [:blink]
  
  # Números associados aos efeitos, devem estar na ordem
  # das camadas, os números associados aos efeitos são:
  # :blink  => a velocidade com que a imagem some/desaparece
  # :wave   => [a amplitude da ondulação, a velocidade da ondulação]
  # :erase  => a velocidade com que a imagem desaparece
  # :appear => a velocidade com que a imagem aparece
  # nil     => nada, simplesmente coloque 0
  E_NUMBERS = [2]
  
end
#==============================================================================
# Fim das Configurações
#==============================================================================
#==============================================================================
# ** Scene_Gameover
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de game over.
#==============================================================================

class Scene_Gameover < Scene_Base
  
  alias mbs_strt start
  
  #--------------------------------------------------------------------------
  # * Processamento principal
  #--------------------------------------------------------------------------
  def start
    mbs_strt
    create_layers
  end
  #--------------------------------------------------------------------------
  # * Criação das camadas
  #--------------------------------------------------------------------------
  def create_layers
    @layers = []
    @blinding = []
    MBS_AnimatedGameOver_Config::LAYERS.times {|i|
    
    @layers << Sprite.new
    @layers[-1].bitmap = Cache.system(MBS_AnimatedGameOver_Config::IMAGES[i])
    
    if MBS_AnimatedGameOver_Config::EFFECTS[i] == :appear
      @layers[-1].opacity = 0
    end
    
    }
  end
  
  alias mbs_upd update
  
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    mbs_upd
    
    pr = ->(i){
      if @layers[-1].opacity == 0
        @blinding[i] = 1
      elsif @layers[-1].opacity == 255
        @blinding[i] = -1
      end
    }
    
    MBS_AnimatedGameOver_Config::LAYERS.times {|i|
    
      case MBS_AnimatedGameOver_Config::EFFECTS[i]
      when :blink
        pr[i]
        @layers[i].opacity += (MBS_AnimatedGameOver_Config::E_NUMBERS[i] * @blinding[i])
      when :wave
        @layers[i].wave_amp = MBS_AnimatedGameOver_Config::E_NUMBERS[i][0]
        @layers[i].wave_phase += MBS_AnimatedGameOver_Config::E_NUMBERS[i][1]
      when :erase
        @layers[i].opacity -= MBS_AnimatedGameOver_Config::E_NUMBERS[i]
      when :appear
        @layers[i].opacity += MBS_AnimatedGameOver_Config::E_NUMBERS[i]
      end
    
    }
    
  end
end
