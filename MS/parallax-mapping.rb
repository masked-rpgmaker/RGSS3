#==============================================================================
# MS - Parallax Mapping
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# Instruções
#------------------------------------------------------------------------------
# Primeiro, crie uma pasta 'Overlay' (sem aspas) dentro da pasta 'Graphics' do 
# seu projeto, depois, crie as camadas do mapa usando um programa de edição de
# imagem com suporte para transparência, e ponha o arquivo na pasta que você
# criou, o nome do arquivo deve ser 'Map00X_sufixo' (sem aspas), ou seja, a 
# camada '_ground' (layer1) do mapa de número 1 deve ter um arquivo com nome
# 'Map001_ground' na pasta.
#==============================================================================
($imported ||= {})[:ms_parallax] = true
#==============================================================================
# Configurações
#==============================================================================
module MS_ParallaxMapping
  
  #--------------------------------------------------------------------------
  # Configurações das camadas
  #--------------------------------------------------------------------------
  # Para criar novas camadas, basta adicionar um novo item à lista de 
  # camadas, o item deve seguir o modelo:
  # nome_da_camada: ["_sufixo","down/up",z]
  # no caso, o nome_da_camada pode ser qualquer um, o sufixo também, o 
  # down/up significa que pode ser down ou up, down fará a imagem ficar 
  # abaixo do jogador e up fará ela ficar acima, caso esse item fuja do 
  # padrão proposto, será assumido o valor como "up".
  # O z é opcional, e define a prioridade de cada camada, uma camada com z 1
  # fica acima de outra com z 0
  #--------------------------------------------------------------------------
  Layers = {
    layer1: ["_ground","down"],
    layer11: ["_ground2","down",50],
    layer2: ["_overlay","up"],
  }
  
  #--------------------------------------------------------------------------
  # Configurações das switches
  #--------------------------------------------------------------------------
  # As switches são as switches que fazem as camadas aparecerem ou não, se
  # a switch estiver ligada, a camada aparece.
  #
  # A switch deve ser configurada para a respectiva camada, com o mesmo nome
  # usado na 'Layers', da configuração das camadas, para definir a switch, 
  # apenas ponha o ID dela depois do nome da camda
  #--------------------------------------------------------------------------
  Switches = {
    layer1: 1,
    layer11: 1,
    layer2: 2,
  }
  
end
#==============================================================================
# Fim das Configurações
#==============================================================================
#==============================================================================
# ** Spriteset_Map
#==============================================================================
class Spriteset_Map
  
  attr_accessor :layers
  
  alias ms_initlz initialize
  alias ms_updt update
  alias ms_crtvwprts create_viewports
  alias ms_updvwprts update_viewports
  
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    create_viewports
    create_tilemap
    create_parallax
    create_characters
    create_shadow
    create_weather
    create_pictures
    create_timer
    create_layers
    update
  end
  #--------------------------------------------------------------------------
  # * Criação do viewport
  #--------------------------------------------------------------------------
  def create_viewports
    ms_crtvwprts
    @viewport0 = Viewport.new
    @viewport_down = Viewport.new
    @viewport_up = Viewport.new
    @viewport0.z = -50
    @viewport_down.z = -10
    @viewport_up.z = 150
  end
  #--------------------------------------------------------------------------
  # * Criação do tilemap
  #--------------------------------------------------------------------------
  def create_tilemap
    @tilemap = Tilemap.new(@viewport0)
    @tilemap.map_data = $game_map.data
    load_tileset
  end
  #--------------------------------------------------------------------------
  # * Criação das camadas de imagens do mapa
  #--------------------------------------------------------------------------
  def create_layers
    
    @layers = {}
    
    MS_ParallaxMapping::Layers.each {|layer|
           
      @layers[layer[0]] = Sprite.new(layer[1][1] == "down" ? @viewport_down : @viewport_up)
      @layers[layer[0]].z = layer[1][2] unless layer[1][2].nil?
      @layers[layer[0]].bitmap = Cache.overlay(sprintf("Map%03d",$game_map.map_id) + layer[1][0])
      
    }
    
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    ms_updt
    update_layers
  end
  #--------------------------------------------------------------------------
  # * Atualização das camadas
  #--------------------------------------------------------------------------
  def update_layers
    MS_ParallaxMapping::Layers.each {|layer|
      @layers[layer[0]].visible = MS_ParallaxMapping::Switches[layer[0]] ? $game_switches[MS_ParallaxMapping::Switches[layer[0]]] : true
      @layers[layer[0]].ox = $game_map.display_x*32
      @layers[layer[0]].oy = $game_map.display_y*32
    }
  end
  #--------------------------------------------------------------------------
  # * Atualização dos viewports
  #--------------------------------------------------------------------------
  def update_viewports
    ms_updvwprts
    
    @viewport0.ox = $game_map.screen.shake
    @viewport_down.ox = $game_map.screen.shake
    @viewport_up.ox = $game_map.screen.shake
    
    @viewport0.update
    @viewport_down.update
    @viewport_up.update
    
  end
end
#==============================================================================
# ** Cache
#==============================================================================
module Cache
  #--------------------------------------------------------------------------
  # * Carregamento dos gráficos de overlay
  #--------------------------------------------------------------------------
  def self.overlay(filename)
    
    exists = false
    
    Dir.entries("Graphics/Overlay/").each {|file|
      if file =~ /#{filename}\.[[:ascii:]]*/
        exists = true
        break
      end
    }
    
    exists ? load_bitmap("Graphics/Overlay/",filename) : empty_bitmap
  end
end
