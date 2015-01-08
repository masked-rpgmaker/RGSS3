($imported ||= {})[:ms_stage_selection]
#==============================================================================
# MS - Stage Selection
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# Instruções
#------------------------------------------------------------------------------
# Para chamar a cena, use um chamar script com o seguinte código:
# SceneManager.call(Scene_StageSelect)
#
# Para desbloquear um estágio, use o código:
# MBS::Stage_Selection.unlock(n)
# Sendo n um número de 0 a quanto der, que é o número do estágio menos 1 (se
# for o estágio 1, digite 0, se for estágio 2, digite 1...)
#
# Para bloquear novamente um estágio, use o código:
# MBS::Stage_Selection.lock(n)
# Sendo n um número de 0 a quanto der, que é o número do estágio menos 1 (se
# for o estágio 1, digite 0, se for estágio 2, digite 1...)
#==============================================================================
#==============================================================================
# Alterações
#------------------------------------------------------------------------------
# Cenas:
#   • Scene_Title
#
# Modulos:
#   • DataManager
#==============================================================================
module MBS
  module Stage_Selection
  #============================================================================
  # Configurações
  #============================================================================
    
  #============================================================================
  #                                   Geral
  #============================================================================

    # Deixe como true caso queira que a cena de seleção de estágio seja a 
    # primeira logo após o 'Novo Jogo'
    INITIAL_SCENE = true
    
    # Caso queira que haja alguma música tocando no fundo, ponha o nome do 
    # arquivo da música na pasta BGM, o volume e o tom separados
    # por vírgula entre colchetes (como está abaixo), senão, deixe vazio (só
    # abre e fecha colchetes).
    BGM = ["Theme3", 100, 100] #[]
  
    # Caso queira que a descrição do estágio seja mostrada, deixe como true,
    # se não, deixe como false
    SHOW_DESCRIPTION = false
  
    # Altura da janela de descrição
    DESCRIPTION_WINDOW_HEIGHT = 120
    
  #============================================================================
  #                           Configuração dos estágios
  #============================================================================
    STAGES = [
    
      # Estágio 1
      {
        # Nome do estágio
        name: "O início", 
        
        # Mapa onde ele começa (id, x e y)
        map: [1, 10, 5], 
        
        # Caso o estágio seja inicialmente bloqueado deixe como true, se não, 
        # deixe como false
        locked: false, 
        
        # A imagem usada para representar o estágio
        image: "stage1",
        
        # A images usada quando o estágio estiver selecionado
        selected_image: "stage1",
        
        # Descrição do estágio
        description: "???"
      },
      
      # Estágio 2
      {
        # Nome do estágio
        name: "Depois do início", 
        
        # Mapa onde ele começa (id, x e y)
        map: [2, 5, 5], 
        
        # Caso o estágio seja inicialmente bloqueado deixe como true, se não, 
        # deixe como false
        locked: false, 
        
        # A imagem usada para representar o estágio
        image: "stage2",
        
        # A images usada quando o estágio estiver selecionado
        selected_image: "stage2",
        
        # Descrição do estágio
        description: "??????"
      }
    ]
    
  #============================================================================
  #                                   Imagens
  #============================================================================
    
    # Imagem usada nos estágios bloqueados
    LOCKED_IMAGE = ""
    
    # Imagem de fundo da cena
    BACKGROUND = "stage_bg"
    
    # Caso queira que o fundo seja borrado, deixe como true, se não, deixe como
    # false
    BLUR_BACKGROUND = true
    
    # Retângulo padrão dos estágios (o primeiro valor é a largura e o 
    # segundo a altura), usado para padronizar o tamanho das imagens
    DEFAULT_RECT = [150, 400]
    
    # Borda padrão para cada imagem (o primeiro é a borda dos lados e o segundo
    # a borda de cima e de baixo)
    DEFAULT_BORDER = [120, 8]
    
    # Deixe como true caso queira que as imagens sejam redimensionadas para
    # ficar do tamanho do retângulo padrão
    RESIZE_IMAGES = true
    
#==============================================================================
# Fim das Configurações
#==============================================================================

    @unlocked = []
#==============================================================================
# ** Images
#==============================================================================
    class Images 
      
      attr_accessor :list
      
      #------------------------------------------------------------------------
      # * Inicialização do objeto
      #------------------------------------------------------------------------
      def initialize
        @list = []
      end
      
      #------------------------------------------------------------------------
      # * Adição de um item à lista
      #------------------------------------------------------------------------
      def <<(s)
        @list << s
      end
    end
    
    #--------------------------------------------------------------------------
    # * Desbloqueio de um estágio
    #--------------------------------------------------------------------------
    def self.unlock(n)
      @unlocked << n
      @unlocked.uniq!
    end
    
    #--------------------------------------------------------------------------
    # * Bloqueio de um estágio
    #--------------------------------------------------------------------------
    def self.lock(n)
      @unlocked.delete(n)
    end
    
    #--------------------------------------------------------------------------
    # * Aquisição da lista de estágios desbloqueados
    #--------------------------------------------------------------------------
    def self.unlocked
      @unlocked
    end
    
    #--------------------------------------------------------------------------
    # * Atribuição de uma lista de estágios desbloqueados                                                                        
    #--------------------------------------------------------------------------
    def self.unlocked=(u)
      @unlocked = u
    end
  end
end
#==============================================================================
# ** Scene_StageSelect
#==============================================================================
class Scene_StageSelect < Scene_Base
  
  include MBS::Stage_Selection
  
  #----------------------------------------------------------------------------
  # * Inicialização do processo
  #----------------------------------------------------------------------------
  def initialize
    super
    @index = 0
    @page = 0
    @list = make_stage_list
    create_background
    create_images
    create_description_window if SHOW_DESCRIPTION
    refresh
    play_music
  end
  
  #----------------------------------------------------------------------------
  # * Atualização do processo
  #----------------------------------------------------------------------------
  def update
    super
    @old_index = @index
    @old_page = @page
    update_cursor
    return_scene if Input.trigger?(:B)
    confirm if Input.trigger?(:C)
    refresh if changed?
    update_description if SHOW_DESCRIPTION && changed?
  end
  
  #----------------------------------------------------------------------------
  # * Finalização do processo
  #----------------------------------------------------------------------------
  def terminate
    @images.list.each {|i| i.dispose}
    @description.dispose if SHOW_DESCRIPTION
  end
  
  #----------------------------------------------------------------------------
  # * Criação do plano de fundo
  #----------------------------------------------------------------------------
  def create_background
    @background = Sprite.new
    @background.bitmap = Cache.picture(BACKGROUND)
    @background.bitmap.blur if BLUR_BACKGROUND
  end
  
  #----------------------------------------------------------------------------
  # * Aquisição da lista de estágios
  #----------------------------------------------------------------------------
  def make_stage_list
    a = []
    b = []
    x = 1
    r = images_per_page
    
    STAGES.each do |i| 
      b << i
      if x % r == 0
        a << b
        b.clear
        x = 0
      end
      x += 1
    end
    a << b unless b.empty?
    return a
  end

  #----------------------------------------------------------------------------
  # * Aquisição do número de imagens que cabem em uma página
  #----------------------------------------------------------------------------
  def images_per_page
    return images_per_line * images_per_column
  end
  
  #----------------------------------------------------------------------------
  # * Aquisição do número de imagens que cabe em uma linha
  #----------------------------------------------------------------------------
  def images_per_line
    sw = Graphics.width
    
    w = DEFAULT_RECT[0] + DEFAULT_BORDER[0]
    
    w = (w <= sw ? w : sw)
    
    return sw / w
  end
  
  #----------------------------------------------------------------------------
  # * Aquisição do número de imagens que cabe em uma coluna
  #----------------------------------------------------------------------------
  def images_per_column
    sh = Graphics.height
    
    h = DEFAULT_RECT[1] + DEFAULT_BORDER[1]
    h = (h <= sh ? h : sh)
    
    return sh / h
  end
  
  #----------------------------------------------------------------------------
  # * Aquisição do número de páginas
  #----------------------------------------------------------------------------
  def get_page_number 
    return STAGES.size / images_per_page
  end
  
  #----------------------------------------------------------------------------
  # * Redesenho das imagens
  #----------------------------------------------------------------------------
  def refresh
    Sound.play_cursor
    @images.list.each_with_index do |s, i|
      next if STAGES[@page * images_per_page + i][:locked] && !MBS::Stage_Selection.unlocked.include?(@page * images_per_page + i)
      if @index == @page * images_per_page + i
        s.bitmap = Cache.picture(STAGES[@index][:selected_image])
      else
        s.bitmap = Cache.picture(STAGES[@page * images_per_page + i][:image])
      end
    end
  end
  
  #----------------------------------------------------------------------------
  # * Verificação de alteração no número da página
  #----------------------------------------------------------------------------
  def page_changed
    @old_page != @page
  end
  
  #----------------------------------------------------------------------------
  # * Verificação de alteração no item selecionado
  #----------------------------------------------------------------------------
  def index_changed
    @old_index != @index
  end
  
  #----------------------------------------------------------------------------
  # * Verificação de se qualquer coisa (item ou página) mudou
  #----------------------------------------------------------------------------
  def changed?
    page_changed || index_changed
  end
  
  #----------------------------------------------------------------------------
  # * Atualização do item selecionado
  #----------------------------------------------------------------------------
  def update_cursor
    @index += 1 if Input.repeat?(:RIGHT)
    @index -= 1 if Input.repeat?(:LEFT)
    @index += images_per_line if Input.repeat?(:DOWN)
    @index -= images_per_line if Input.repeat?(:UP)
    @index += images_per_page if Input.repeat?(:R)
    @index -= images_per_page if Input.repeat?(:L)
    @index = 0 if @index < 0
    @index = STAGES.size - 1 if @index >= STAGES.size
    @index = @old_index if STAGES[@index][:locked] && !MBS::Stage_Selection.unlocked.include?(@index)
    update_page   
  end
  
  #----------------------------------------------------------------------------
  # * Execução da confirmação do estágio
  #----------------------------------------------------------------------------
  def confirm
    stage = STAGES[@index]
    if stage[:locked] && !MBS::Stage_Selection.unlocked.include?(@index)
      Sound.play_buzzer
      return
    end
    Sound.play_ok
    Graphics.freeze
    $game_map.setup(stage[:map][0])
    $game_player.moveto(stage[:map][1], stage[:map][2])
    SceneManager.call(Scene_Map)
  end
  
  #----------------------------------------------------------------------------
  # * Atualização da página selecionada
  #----------------------------------------------------------------------------
  def update_page
    @page = (@index / images_per_page).floor
    if page_changed
      create_images 
      refresh
    end
  end
  
  #----------------------------------------------------------------------------
  # * Ajuste da posição da imagem
  #----------------------------------------------------------------------------
  def adjust_position(sprite, n)
    i = Graphics.width - ((DEFAULT_BORDER[0] + DEFAULT_RECT[0]) * images_per_line + DEFAULT_BORDER[0])
    x = i / 2 + (DEFAULT_BORDER[0] + DEFAULT_RECT[0]) * n + DEFAULT_BORDER[0]
    y = DEFAULT_BORDER[1]
    sprite.x = x
    sprite.y = y
  end
  
  #----------------------------------------------------------------------------
  # * Criação da imagem
  #----------------------------------------------------------------------------
  def create_images
    @images.list.each {|s| s.dispose} if @images
    @images = Images.new
    list = STAGES[(@page * images_per_page)...((@page + 1)*images_per_page)]
    list.each_with_index do |image, i|
      s = Sprite.new
      if !image[:locked] || MBS::Stage_Selection.unlocked.include?(i + @page * images_per_page)
        s.bitmap = Cache.picture(image[:image])
      else
        s.bitmap = Cache.picture(LOCKED_IMAGE)
      end
      s.zoom_x = DEFAULT_RECT[0] / s.width.to_f if RESIZE_IMAGES
      s.zoom_y = DEFAULT_RECT[1] / s.height.to_f if RESIZE_IMAGES
      adjust_position(s, i)
      @images << s
    end
  end
  
  #----------------------------------------------------------------------------
  # * Criação da janela de descrição
  #----------------------------------------------------------------------------
  def create_description_window
    @description = Window_Base.new(0, Graphics.height - DESCRIPTION_WINDOW_HEIGHT, Graphics.width, DESCRIPTION_WINDOW_HEIGHT)
    update_description
  end
  
  #----------------------------------------------------------------------------
  # * Atualização da janela de descrição
  #----------------------------------------------------------------------------
  def update_description
    stage = STAGES[@index]
    @description.contents.clear
    return if stage[:locked] && !MBS::Stage_Selection.unlocked.include?(@index)
    @description.change_color(@description.system_color)
    @description.draw_text(0, 0, Graphics.width, 24, stage[:name])
    @description.change_color(@description.normal_color)
    @description.draw_text_ex(0, 24, stage[:description])
  end  
  #--------------------------------------------------------------------------
  # * Executar música de fundo
  #--------------------------------------------------------------------------
  def play_music
    RPG::BGM.new(BGM[0], BGM[1], BGM[2]).play if BGM[2]
    RPG::BGS.stop
    RPG::ME.stop
  end
end

#==============================================================================
# ** Scene_Title
#==============================================================================
class Scene_Title < Scene_Base
  
  alias mbscmdngm command_new_game
  
  #--------------------------------------------------------------------------
  # * Comando [Novo Jogo]
  #--------------------------------------------------------------------------
  def command_new_game
    unless MBS::Stage_Selection::INITIAL_SCENE
      mbscmdngm
      return
    end
    DataManager.setup_new_game
    close_command_window
    fadeout_all
    $game_map.autoplay
    SceneManager.goto(Scene_StageSelect)
  end
end

#==============================================================================
# ** DataManager
#==============================================================================
module DataManager
  class << self
    alias mbsmkscnt make_save_contents
    alias mbsexsvcn extract_save_contents
  end
  #--------------------------------------------------------------------------
  # * Salvar a criação de conteúdo
  #--------------------------------------------------------------------------
  def self.make_save_contents
    contents = mbsmkscnt
    contents[:stages] = MBS::Stage_Selection.unlocked
    contents
  end
  #--------------------------------------------------------------------------
  # * Extrair conteúdo salvo
  #--------------------------------------------------------------------------
  def self.extract_save_contents(contents)
    mbsexsvcn(contents)
    MBS::Stage_Selection.unlocked = contents[:stages]
  end
end
#==============================================================================
#                                FIM DO SCRIPT
#==============================================================================
