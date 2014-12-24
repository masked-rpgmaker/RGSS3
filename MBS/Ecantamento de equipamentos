($imported ||= {})[:mbs_equip_enchantment] = true
$e_weapons ||= []
$e_armors ||= []
#==============================================================================
# MBS - Aprimoramento / Encantamento de equipamentos
#==============================================================================
#==============================================================================
# Instruções
#------------------------------------------------------------------------------
# Para chamar a cena, use um chamar script com o seguinte código:
# SceneManager.call(Scene_Enchant)
#
# Para desbloquear um encantamento:
# MBS::Equip_Enchantment.unlock(s) # s é o símbolo (:atk_up, por exemplo) do efeito
#
# Para bloquear:
# MBS::Equip_Enchantment.lock(s)
#==============================================================================
#==============================================================================
# Alterações
#------------------------------------------------------------------------------
# Classes:
#   • RPG::EquipItem
#
# Modulos:
#   • DataManager
#==============================================================================
#==============================================================================
# Configurações
#==============================================================================
module MBS
  module Equip_Enchantment
    
    #==========================================================================
    # Configurações Gerais
    #==========================================================================
    
    # Palavra para o título da janela de encantamentos
    WORD = "Encantamentos"
    
    # Textos utilizados na janela de Ajuda
    HELP_TEXTS = ["Escolha um equipamento para encantar",
    
                  "Escolha um encantamento para aplicar, pressione A" + 
                  "\r\npara mais informações sobre um encantamento",
                  
                  "Não há nenhum equipamento disponível para encantar"]
    
    # Botão a ser pressionado para mostrar as informações do encantamento,
    # o botão deve seguir o padrão das teclas do F1 e deve vir depois de :
    INFO_BUTTON = :X  # Tecla A
    
    # Palavra usada quando não há nenhum equipamento ou encantamento 
    # disponível
    EMPTY_TEXT = "Nenhum"
    
    #==========================================================================
    # Configuração dos efeitos
    #==========================================================================
    EFFECTS = {
    
      :atk_up => {
        
        # Nome do encantamento
        name: 'Ataque +',
        
        # Índice do icone do encantamento
        icon: 34,
        
        # Número de vezes que um item pode ser encantado com ele
        max: 5,
        
        # Deixe como true se quiser que o encantamento não precise ser 
        # desbloqueado, se não, deixe como false
        enabled: true,
      
        # Fórmula de cálculo do preço do encantamento:
        # atk = ataque do item, df = defesa do item, mat = ataque mágico,
        # mdf = defesa mágica, luk = sorte, agi = agilidade, 
        # price = preço padrão do item, level = número de vezes
        # que o item já foi encantado
        cost_formula: 'level * 1000 + atk * 10',
        
        # Fórmula para o cálculo do preço do item encantado
        item_cost: 'price * 1.5',
        
        # Sufixo a ser adicionado no item quando encantado
        suffix: 'de Guerra',
        
        # ID do(s) item(s) a ser consumido(s) para o encantamento (tipo alguma 
        # pedra de encantamento ou sei lá) e a quantidade
        # Exemplo:
        # [[1, 3]] #=> 3 itens de ID 1
        items: [],
        
        # Número dos tipos de equipamento que podem ser encantados com esse efeito
        # (por exemplo, arma, elmo, escudo) e o tipo secundário (espada,
        # armadura pesada...), o tipo secundário pode ser omitido, nesse caso
        # qualquer tipo secundário é aceito
        #
        # Números:
        # Arma = 0
        # Escudo = 1
        # Elmo = 2
        # Armadura = 3
        # Acessório = 4
        type: [[0]],
        
        # Os efeitos em si, os efeitos devem estar organizados em uma lista,
        # assim o primeiro número da lista altera o primeiro efeito, o segundo
        # o segundo efeito e assim por diante, a ordem segue:
        # HP, MP, Ataque, Defesa, Ataque M., Defesa M., Agilidade, Sorte, 
        # Elemento, Estado (ID), Estado (Chance)
        # No caso do Elemento e do estado, pode-se adicionar mais de um,
        # então deve-se colocar os IDs dos estados dentro de outra lista
        # Exemplo:
        # [0, 0, 0, 0, 0, 0, 0, 0, [3, 8], [1], [25]]
        # Caso não queira nenhum elemento ou estado, apenas deixe as listas
        # vazias
        effects: [0, 0, 15, 0, 0, 0, 0, 0, [], [], []],
        
        # Ajuste do efeito por nível
        adjust: 1.25
        
      },
      
      :fire => {
        name: 'Fogo',                       # Chama 'Fogo'
        icon: 96,                           # O ícone é o ícone no índice 96
        max: 1,                             # Pode ser usado apenas uma vez
        enabled: false,                     # Precisa ser desbloqueado
        cost_formula: '1050',               # Custa exatamente 1050G para encantar
        item_cost: 'price * 1.5',           # O preço do item aprimorado vira 1,5 vezes o preço original
        suffix: 'Flamejante',               # Adiciona 'Flamejante' ao nome do equipamento
        items: [],                          # Consome o item de ID 5 no encantamento
        type: [[0]],                        # Funciona apenas em armas (em qualquer uma)
        effects: [0,0,0,0,0,0,0,0,[3],[],[]], # Adiciona o elemento Fogo ao ataque
        adjust: 1.0                         # Não muda nada de nível para nível
      },
      
      :def_up => {
        name: 'Defesa +',
        icon: 35,
        max: 5,
        enabled: true,
        cost_formula: '1000 * level + df * 10',
        item_cost: 'price * 1.5',
        suffix: 'Resistente',
        items: [],
        type: [[1], [3]],
        effects: [0,0,0,15,0,0,0,0,[],[],[]],
        adjust: 1.25
      },
    }
#==============================================================================
# Fim das configurações
#==============================================================================

    @unlocked = []

    #--------------------------------------------------------------------------
    # * Criação de item aprimorado/encantado
    #--------------------------------------------------------------------------
    def self.create_enchanted(effect, type, id)
      #return enchanted(type, effect, id) if enchanted(effect, type, id)
      d = type == :weapon ? $e_weapons : $e_armors
      data = type == :weapon ? $data_weapons : $data_armors
      d[id] ||= {}
      d[id][effect] ||= data.size
      i = data[d[id][effect]].nil?
      unless data[d[id][effect]]
        w = data[id].dup
        w.id = data.size
        data[d[id][effect]] = w
      end
      return i ? data[d[id][effect]].add_enchant(effect) : data[d[id][effect]]
    end
    
    #--------------------------------------------------------------------------
    # * Obtenção do item encantado caso ele já exista
    #--------------------------------------------------------------------------
    def self.enchanted(effect, type, id)
      data = type == :weapon ? $data_weapons : $data_armors
      d = type == :weapon ? $e_weapons : $e_armors
      if d[id]
        if d[id][effect]
          create_enchanted(effect, type, id) unless data[d[id][effect]]
        else
          create_enchanted(effect, type, id)
        end
      else
        create_enchanted(effect, type, id)
      end
      return data[d[id][effect]] if d[id][effect] if d[id]
      return nil
    end
    
    #--------------------------------------------------------------------------
    # * Aquisição da lista dos equipamentos debloqueados
    #--------------------------------------------------------------------------
    def self.unlocked
      EFFECTS.each {|k, v| @unlocked << k if v[:enabled] && !@unlocked.include?(k)}
      u = EFFECTS.select {|i| @unlocked.include?(i)}
      r = {}
      u.each {|s| r[s[0]] = s[1]}
      return r
    end
    
    #--------------------------------------------------------------------------
    # * Definição da lista dos equipamentos debloqueados
    #--------------------------------------------------------------------------
    def self.unlocked=(u)
      @unlocked = u
    end
    #--------------------------------------------------------------------------
    # * Desbloqueio de um encantamento
    #--------------------------------------------------------------------------
    def self.unlock(symbol)
      @unlocked << symbol
      @unlocked.uniq!
    end
    
    #--------------------------------------------------------------------------
    # * Bloqueio de um encantamento
    #--------------------------------------------------------------------------
    def self.lock(symbol)
      @unlocked.delete(symbol)
    end
    
    #--------------------------------------------------------------------------
    # * Aquisição dos encantamento que um item pode receber
    #--------------------------------------------------------------------------
    def self.enabled(item)
      return {} unless item
      t = item.is_a?(RPG::Weapon) ? item.wtype_id : item.atype_id 
      r = {}
      self.unlocked.each do |k, i|
        r[k] = i if i[:type].include?([item.etype_id, t]) || i[:type].include?([item.etype_id])
      end
      return r
    end
  end
end

#==============================================================================
# ** RPG::EquipItem
#==============================================================================
class RPG::EquipItem < RPG::BaseItem
  attr_reader :enchant

  alias mbsintlzcp initialize_copy
  
  #----------------------------------------------------------------------------
  # * Inicialização do objeto como cópia
  #----------------------------------------------------------------------------
  def initialize_copy(obj)
    mbsintlzcp(obj)
    @features = []
    obj.features.each {|i| @features << i}
    @params = [0] * 8
    obj.params.each_with_index {|x, i| @params[i] = x}
  end
  
  #----------------------------------------------------------------------------
  # * Cálculo do custo para a aplicação do encantamento
  #----------------------------------------------------------------------------
  def enchant_cost(symbol)
    e = MBS::Equip_Enchantment::EFFECTS[symbol]
    mhp = @params[0]
    mmp = @params[1]
    atk = @params[2]
    df = @params[3]
    mat = @params[4]
    mdf = @params[5]
    agi = @params[6]
    luk = @params[7]
    price = @price
    level = @name.include?(e[:suffix]) ? (@name[-1] =~ /\d+/ ? @name[-1].to_i : 1) : 0
    return eval(e[:cost_formula]).to_i
  end
  
  #----------------------------------------------------------------------------
  # * Verificação do nível de encantamento
  #----------------------------------------------------------------------------
  def max_level?(symbol)
    da = etype_id == 0 ? $data_weapons : $data_armors
    d = etype_id == 0 ? $e_weapons : $e_armors
    i = 0
    d.each do |x| 
      next unless x
      i += x.size
    end
    s = MBS::Equip_Enchantment.enchanted(symbol, etype_id == 0 ? :weapon : :armor, @id) if @id < da.size - i
    e = MBS::Equip_Enchantment::EFFECTS[symbol]
    return false unless e
    level = @name[-1] =~ /\d+/ ? @name[-1].to_i : 0
    return level >= e[:max]
  end
  
  #----------------------------------------------------------------------------
  # * Aplicação dos encantamentos
  #----------------------------------------------------------------------------
  def apply_enchant(symbol)
    e = MBS::Equip_Enchantment::EFFECTS[symbol]
    level = @name[-1] =~ /\d+/ ? @name[-1].to_i : 1
    return false if max_level?(symbol)
    unless e[:suffix].empty?
      unless @name.include?(e[:suffix]) 
        @name += (' ' + e[:suffix]) 
      else
        n = @name[-1] =~ /\d+/ ? @name.split(' ')[0...-1].inject('') {|s, i| s += i + ' '} : @name + ' '
        @name = n + (level + 1).to_s
      end
    end
    
    mhp = @params[0]
    mmp = @params[1]
    atk = @params[2]
    df = @params[3]
    mat = @params[4]
    mdf = @params[5]
    agi = @params[6]
    luk = @params[7]
    price = @price
    @price = eval(e[:item_cost])
    
    8.times do |i|
      p = e[:effects][i]
      level.times {p *= e[:adjust]}
      @params[i] += p
    end
    
    e[:effects][8].each {|x| @features << RPG::BaseItem::Feature.new(31, x)}
    e[:effects][9].size.times {|x| @features << RPG::BaseItem::Feature.new(32, e[:effects][9][x], e[:effects][10][x])}
    return true
  end
  
  #----------------------------------------------------------------------------
  # * Adição de um encantamento
  #----------------------------------------------------------------------------
  def add_enchant(symbol)
    return false if @enchant != symbol && @enchant
    return false unless MBS::Equip_Enchantment::EFFECTS[symbol][:type].any? {|j| j[0] == etype_id}
    @enchant = symbol
    return apply_enchant(symbol)
  end
  
  protected :apply_enchant
  
end

#==============================================================================
# ** Window_EquipList
#==============================================================================
class Window_EquipList < Window_Selectable
  #----------------------------------------------------------------------------
  # * Inicialização do objeto
  #----------------------------------------------------------------------------
  def initialize
    w = 244
    h = 416
    super(0, 72, w, h - 72)
    @index = 0
    @disabled = []
    refresh
    @oas = self.active
  end
  
  #----------------------------------------------------------------------------
  # * Atualização do processo
  #----------------------------------------------------------------------------
  def update
    super
    refresh if @oas != self.active
  end

  #--------------------------------------------------------------------------
  # * Aquisição da lista de itens equipáveis do grupo
  #--------------------------------------------------------------------------
  def equips
    $game_party.equip_items
  end
  
  #--------------------------------------------------------------------------
  # * Aquisição do item selecionado
  #--------------------------------------------------------------------------
  def item
    equips[@index]
  end
  
  #--------------------------------------------------------------------------
  # * Aquisição do número máximo de itens
  #--------------------------------------------------------------------------
  def item_max
    return equips.size
  end
  
  #--------------------------------------------------------------------------
  # * Definição de confirmação
  #--------------------------------------------------------------------------
  def ok_enabled?
    super && !@disabled.include?(@index)
  end
  
  #--------------------------------------------------------------------------
  # * Definição de controle de confirmação e cancelamento
  #--------------------------------------------------------------------------
  def process_handling
    super
    Sound.play_buzzer if !ok_enabled? && Input.trigger?(:C)
  end
  
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    @disabled.clear
    equips.each_with_index {|e, i| @disabled << i if MBS::Equip_Enchantment.enabled(e).empty?}
    @oas = self.active
    change_color(normal_color, self.active)
    unless equips.empty?
      super
    else
      contents.clear
      draw_text(5, 0, self.width, 24, MBS::Equip_Enchantment::EMPTY_TEXT)
    end
  end
  
  #----------------------------------------------------------------------------
  # * Criação dos encantamentos disponíveis
  #----------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color, !@disabled.include?(index))
    draw_icon(equips[index].icon_index, 5, index * 24, self.active && !@disabled.include?(index))
    s = sprintf(":%02d", $game_party.item_number(equips[index]))
    draw_text(32, index * 24, self.width - 102, 24, equips[index].name)
    draw_text(self.width - 65, index * 24, 36, 24, s)
  end
end

#==============================================================================
# ** Window_EnchantList
#==============================================================================
class Window_EnchantList < Window_Selectable
  
  attr_reader :item
  #----------------------------------------------------------------------------
  # * Inicialização do objeto
  #----------------------------------------------------------------------------
  def initialize(item)
    @item = item
    @enchants = MBS::Equip_Enchantment.enabled(item)
    w = 300
    h = 416
    super(Graphics.width - w, 72, w, h - 72)
    @index = -1
    @disabled = []
    refresh
    @oas = self.active
  end
  
  #----------------------------------------------------------------------------
  # * Atualização do processo
  #----------------------------------------------------------------------------
  def update
    super
    refresh if @oas != self.active
  end
  
  #--------------------------------------------------------------------------
  # * Definição de confirmação
  #--------------------------------------------------------------------------
  def ok_enabled?
    super && !@disabled.include?(@index)
  end
  
  #--------------------------------------------------------------------------
  # * Alteração do item a ser encantado
  #--------------------------------------------------------------------------
  def item=(i)
    @item = i
    @enchants = MBS::Equip_Enchantment.enabled(i)
  end
  
  #--------------------------------------------------------------------------
  # * Definição de controle de confirmação e cancelamento
  #--------------------------------------------------------------------------
  def process_handling
    super
    call_handler(:info) if Input.trigger?(MBS::Equip_Enchantment::INFO_BUTTON)
    Sound.play_buzzer if !ok_enabled? && Input.trigger?(:C)
  end
  
  #----------------------------------------------------------------------------
  # * Aquisição do encantamento selecionado
  #----------------------------------------------------------------------------
  def enchant
    return @enchants.values[@index]
  end
  
  #--------------------------------------------------------------------------
  # * Aquisição do número máximo de itens
  #--------------------------------------------------------------------------
  def item_max
    return @enchants.size
  end
  
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    @oas = self.active
    @disabled.clear
    change_color(normal_color, self.active)
    super
    change_color(system_color, self.active)
    draw_text(5, 0, self.width, 24, MBS::Equip_Enchantment::WORD)
    change_color(normal_color, self.active)
  end
  
  #--------------------------------------------------------------------------
  # * Aquisição do retangulo para desenhar o item
  #     index : índice do item
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing)
    rect.y = 32 + index / col_max * item_height
    rect
  end
  
  #--------------------------------------------------------------------------
  # * Aquisição do símbolo do encantamento
  #--------------------------------------------------------------------------
  def symbol
    @enchants.keys[@index]
  end
  
  #--------------------------------------------------------------------------
  # * Verificação de se um encantamento está disponível
  #--------------------------------------------------------------------------
  def e_enabled?(symbol)
    return false unless @item
    e = MBS::Equip_Enchantment.unlocked[symbol]
    a = e[:type].include?([@item.etype_id, @item.etype_id == 0 ? @item.wtype_id : @item.atype_id]) || e[:type].include?([@item.etype_id])
    cost = @item.enchant_cost(symbol).to_i
    b = $game_party.gold >= cost
    c = e[:items].all? {|i| $game_party.item_number($data_items[i[0]]) >= i[1]}
    return a && b && c && !@item.max_level?(symbol)
  end
  
  #----------------------------------------------------------------------------
  # * Criação dos encantamentos disponíveis
  #----------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color, e_enabled?(@enchants.keys[index]))
    @disabled << index unless e_enabled?(@enchants.keys[index])
    draw_icon(@enchants.values[index][:icon], 5, 32 + index * 24, self.active)
    draw_text(32, 32 + index * 24, self.width - 37, 24, @enchants.values[index][:name])
  end
end

#==============================================================================
# ** Window_EnchantInfo
#==============================================================================
class Window_EnchantInfo < Window_Base
  
  attr_accessor :enchant, :item
  
  #----------------------------------------------------------------------------
  # * Inicialização do objeto
  #----------------------------------------------------------------------------
  def initialize(enchant, item)
    @item = item
    @symbol = enchant
    @enchant = MBS::Equip_Enchantment::EFFECTS[enchant]
    @page = 0
    w = 260
    h = 416
    super(Graphics.width / 2 - w / 2, Graphics.height / 2 - h / 2, w, h)
    self.back_opacity = 255
    refresh
  end
  
  #----------------------------------------------------------------------------
  # * Atualização do objeto
  #----------------------------------------------------------------------------
  def update
    return if disposed?
    super
    dispose if Input.trigger?(:B)
    next_page if Input.trigger?(:DOWN) || Input.trigger?(:RIGHT) || Input.trigger?(:R)
    prev_page if Input.trigger?(:UP) || Input.trigger?(:LEFT) || Input.trigger?(:L)
  end
  
  #----------------------------------------------------------------------------
  # * Próxima página
  #----------------------------------------------------------------------------
  def prev_page
    return if @page == 0
    @page -= 1
    refresh
  end
  
  #----------------------------------------------------------------------------
  # * Página anterior
  #----------------------------------------------------------------------------
  def next_page
    return if @page == 3
    @page += 1
    refresh
  end

  #----------------------------------------------------------------------------
  # * Renovação
  #----------------------------------------------------------------------------
  def refresh
    return unless @enchant && @item
    contents.clear
    case @page
      when 0
        draw_attributes
      when 1
        draw_elements
      when 2
        draw_states
      when 3
        draw_cost
    end
  end
  
  #--------------------------------------------------------------------------
  # * Desenho de uma linha horzontal
  #--------------------------------------------------------------------------
  def draw_horz_line(y)
    contents.fill_rect(0, y, contents_width, 2, system_color)
  end
  
  #--------------------------------------------------------------------------
  # * Aquisção da cor da linha horizontal
  #--------------------------------------------------------------------------
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  
  #----------------------------------------------------------------------------
  # * Desenho dos atributos alterados pelo encantamento
  #----------------------------------------------------------------------------
  def draw_attributes
    draw_header
    
    change_color(system_color)
    #draw_text(5, 32, self.width, 24, "Categoria:")
    draw_text(5, 32, self.width, 24, "Atributos:")
    change_color(normal_color)
      
    8.times do |i|
      draw_text(5, 56 + i * 24, 131, 24, Vocab.param(i))
    end

    8.times do |i|
      change_color(normal_color)
      draw_text(self.width - 108, 54 + i * 24, 64, 24, "#{@item.params[i].to_i}")
      draw_text(self.width - 75, 54 + i * 24, 64, 24, "→")
      change_color(@enchant[:effects][i] > 0 ? power_up_color : normal_color)
      draw_text(self.width - 54, 54 + i * 24, 64, 24, "#{(@item.params[i] + @enchant[:effects][i]).to_i}")
    end
  end
  
  #----------------------------------------------------------------------------
  # * Desenho dos elementos dados ao item encantado
  #----------------------------------------------------------------------------
  def draw_elements
    draw_header
    
    change_color(system_color)
    draw_text(5, 32, self.width, 24, "Elementos:")
    
    change_color(normal_color)
    @enchant[:effects][8].each_with_index do |x, i|
      draw_text(5, 56 + 24 * i, self.width - 5, 24, $data_system.elements[x])
    end
    draw_text(5, 56, self.width, 24, MBS::Equip_Enchantment::EMPTY_TEXT) if @enchant[:effects][8].empty?
  end
  
  #----------------------------------------------------------------------------
  # * Desenho dos estados que o item encantado causa
  #----------------------------------------------------------------------------
  def draw_states
    draw_header
    
    change_color(system_color)
    draw_text(5, 32, self.width, 24, "Estados:")
    
    change_color(normal_color)
    @enchant[:effects][9].each_with_index do |x, i|
      draw_icon($data_states[x].icon_index, 5, 56 + 24 * i)
      draw_text(32, 56 + 24 * i, self.width - 32, 24, $data_states[x].name)
    end
    
    @enchant[:effects][10].each_with_index do |x, i|
      draw_text(self.width - 64, 56 + 24 * i, 64, 24, "#{x}%")
    end
    
    draw_text(5, 56, self.width, 24, MBS::Equip_Enchantment::EMPTY_TEXT) if @enchant[:effects][9].empty?
  end
  
  #----------------------------------------------------------------------------
  # * Desenho do custo do encantamento
  #----------------------------------------------------------------------------
  def draw_cost
    draw_header
    
    change_color(system_color)
   
    draw_text(5, 32, self.width, 24, "Custo:")
    
    cost = @item.enchant_cost(@symbol).to_i
    
    change_color(cost > $game_party.gold ? crisis_color : normal_color)
    draw_text(self.width - 96, 32, 96, 25, "#{cost} #{Vocab.currency_unit}")
    
    change_color(system_color)
    draw_text(5, 64, self.width, 24, "Itens necessários:")
    change_color(normal_color)
    
    @enchant[:items].each_with_index do |x, i|
      change_color(x[1] > $game_party.item_number($data_items[x[0]]) ? crisis_color : normal_color)
      draw_icon($data_items[x[0]].icon_index, 5, 88 + 24 * i)
      draw_text(32, 88 + 24 * i, self.width - 52, 24, $data_items[x[0]].name)
      draw_text(self.width - 64, 88 + 24 * i, 64, 24, sprintf(":%02d", x[1]))
    end
    
    draw_text(5, 88, self.width, 24, MBS::Equip_Enchantment::EMPTY_TEXT) if @enchant[:items].empty?
    
  end
  
  #----------------------------------------------------------------------------
  # * Desenho do cabeçalho
  #----------------------------------------------------------------------------
  def draw_header
    change_color(normal_color)
    draw_icon(@enchant[:icon], 5, 0)
    draw_text(32, 0, self.width, 24, @enchant[:name])
    draw_text(self.width - 64, 0, 64, 24, "#{@page+1}/4")
    draw_horz_line(28)
  end
  
end

#==============================================================================
# ** Scene_Enchant
#==============================================================================
class Scene_Enchant < Scene_Base
  
  #----------------------------------------------------------------------------
  # * Inicialização do processo
  #----------------------------------------------------------------------------
  def start
    super
    create_all_windows
    @oi = @equip_list.index
  end
  
  #----------------------------------------------------------------------------
  # * Criação das janelas
  #----------------------------------------------------------------------------
  def create_all_windows
    @help = Window_Help.new(2)
    
    @equip_list = Window_EquipList.new
    @equip_list.set_handler(:ok, method(:choose_enchant))
    @equip_list.set_handler(:cancel, method(:return_scene))
    
    @enchant_list = Window_EnchantList.new(@equip_list.item)
    @enchant_list.set_handler(:ok, method(:do_enchant))
    @enchant_list.set_handler(:cancel, method(:choose_equip))
    @enchant_list.set_handler(:info, method(:show_info))
    
    choose_equip unless $game_party.equip_items.empty?
  end
  
  #----------------------------------------------------------------------------
  # * Criação do item encantado
  #----------------------------------------------------------------------------
  def do_enchant
    if @equip_list.item.max_level?(@enchant_list.symbol)
      choose_enchant
      return
    end
    e = @enchant_list.enchant
    m = MBS::Equip_Enchantment
    s = @equip_list.item.is_a?(RPG::Weapon) ? :weapon : :armor
    r = m.create_enchanted(@enchant_list.symbol, s, @equip_list.item.id)
    @enchant_list.refresh
    unless r
      choose_enchant
      return
    end
    w = m.enchanted(@enchant_list.symbol, s, @equip_list.item.id)
    $game_party.lose_gold(@equip_list.item.enchant_cost(@enchant_list.symbol))
    $game_party.lose_item(@equip_list.item, 1, true)
    e[:items].each {|i| $game_party.lose_item($data_items[i], 1, false)}
    $game_party.gain_item(w, 1, true)
    @equip_list.refresh
    choose_equip
  end
  
  #----------------------------------------------------------------------------
  # * Exibição das informações do encantamento
  #----------------------------------------------------------------------------
  def show_info
    return unless @enchant_list.active
    if @info_window
      @info_window = Window_EnchantInfo.new(MBS::Equip_Enchantment.enabled(@enchant_list.item).keys[@enchant_list.index], @equip_list.item) if @info_window.disposed?
    else
      @info_window = Window_EnchantInfo.new(MBS::Equip_Enchantment.enabled(@enchant_list.item).keys[@enchant_list.index], @equip_list.item)
    end
    @equip_list.deactivate
    @enchant_list.deactivate
    @info_window.activate
  end
  
  #----------------------------------------------------------------------------
  # * Seleção de equipamento
  #----------------------------------------------------------------------------
  def choose_equip
    @enchant_list.deactivate
    @enchant_list.index = -1
    @enchant_list.refresh
    @equip_list.activate
    @equip_list.refresh
    @help.set_text(MBS::Equip_Enchantment::HELP_TEXTS[0])
  end
  
  #----------------------------------------------------------------------------
  # * Seleção de encantamento
  #----------------------------------------------------------------------------
  def choose_enchant
    @equip_list.deactivate
    @equip_list.refresh
    @enchant_list.activate
    @enchant_list.index = 0
    @help.set_text(MBS::Equip_Enchantment::HELP_TEXTS[1])
  end
  
  #----------------------------------------------------------------------------
  # * Desativação de todas as janelas
  #----------------------------------------------------------------------------
  def deactivate_all
    @equip_list.deactivate
    @equip_list.index = -1
    @enchant_list.deactivate
    @enchant_list.index = -1
  end
  
  #----------------------------------------------------------------------------
  # * Atualização do processo
  #----------------------------------------------------------------------------
  def update
    if @info_window
      if @info_window.disposed? && !(@equip_list.active || @enchant_list.active)
        choose_enchant
      end
    end
    super
    deactivate_all if $game_party.equip_items.empty?
    return_scene if Input.trigger?(:B) && $game_party.equip_items.empty?
    if @oi != @equip_list.index
      @oi = @equip_list.index
      @enchant_list.item = @equip_list.item
      @enchant_list.refresh
    end
    @help.set_text(MBS::Equip_Enchantment::HELP_TEXTS[2]) if $game_party.equip_items.empty?
  end
end

#==============================================================================
# ** DataManager
#==============================================================================
module DataManager
  class << self
    alias mbsmkscnts make_save_contents
    alias mbsexsvcns extract_save_contents
  end
  #--------------------------------------------------------------------------
  # * Salvar a criação de conteúdo
  #--------------------------------------------------------------------------
  def self.make_save_contents
    contents = mbsmkscnts
    contents[:e_weapons] = $e_weapons
    contents[:e_armors] = $e_armors
    contents[:e_unlocked] = MBS::Equip_Enchantment.unlocked.keys
    contents
  end
  #--------------------------------------------------------------------------
  # * Extrair conteúdo salvo
  #--------------------------------------------------------------------------
  def self.extract_save_contents(contents)
    mbsexsvcns(contents)
    $e_weapons = contents[:e_weapons]
    
    $e_weapons.each_with_index do |x, i|
      next unless x
      x.each do |k, y|
        $data_weapons[y] = MBS::Equip_Enchantment.enchanted(k, :weapon, i)
      end
    end
    
    $e_armors = contents[:e_armors]
    
    $e_armors.each_with_index do |x, i|
      next unless x
      x.each do |k, y|
        $data_armors[y] = MBS::Equip_Enchantment.enchanted(k, :armor, i)
      end
    end
    
    MBS::Equip_Enchantment.unlocked = contents[:e_unlocked]
  end
end
