($imported ||= {})[:mbs_custom_battle_interface] = true
#==============================================================================
# MS - Custom Battle Interface
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# Alterações
#------------------------------------------------------------------------------
# Janelas:
#   • Window_PartyCommand
#   • Window_ActorCommand
#   • Window_BattleEnemy
#   • Window_BattleStatus
#
# Sprites/Spritesets:
#   • Sprite_Battler
#   • Spriteset_Battle
#
# Cenas:
#   • Scene_Battle
#
#==============================================================================
#==============================================================================
# Configurações
#==============================================================================
module MBS
  module Battle_Interface
    # Tom do inimigo quando selecionado (vermelho, verde, azul, cinza)
    # se não quiser alterar o tom do inimigo, apenas deixe tudo como 0:
    # Tone.new(0, 0, 0, 0)
    SELECTED_TONE = Tone.new(100,100,100,100)
    
    # Quando true mostra as janelas, quando false não
    SHOW_WINDOWS = false
  end
end
#==============================================================================
# Fim das configurações
#==============================================================================
#==============================================================================
# ** Window_PartyCommand
#==============================================================================
class Window_PartyCommand
  alias mbsintlz initialize

  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(viewport)
    mbsintlz()
    self.y = Graphics.height - 146 - viewport.rect.y
    self.opacity = 0 unless MBS::Battle_Interface::SHOW_WINDOWS
    self.viewport = viewport
  end
end
#==============================================================================
# ** Window_ActorCommand
#==============================================================================
class Window_ActorCommand
  alias mbsintlz initialize

  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(viewport)
    mbsintlz()
    self.y = Graphics.height - 146 - viewport.rect.y
    self.opacity = 0 unless MBS::Battle_Interface::SHOW_WINDOWS
    self.viewport = viewport
  end
end
#==============================================================================
# ** Window_BattleEnemy
#==============================================================================
class Window_BattleEnemy
  alias mbsintlz initialize

  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(*args, &block)
    mbsintlz(*args, &block)
    self.opacity = 0 unless MBS::Battle_Interface::SHOW_WINDOWS
    self.y = Graphics.height - 146
  end
  
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    super
    self.x = Graphics.width / 2 - window_width / 2
    return unless self.visible
    SceneManager.scene.spriteset.enemy_sprites.each do |s|
      if s.battler == enemy
        s.tone = MBS::Battle_Interface::SELECTED_TONE
      else
        s.tone = Tone.new(0, 0, 0, 0)
      end
    end
  end
  
  alias mbshide hide
  
  #--------------------------------------------------------------------------
  # * Ocultação da janela
  #--------------------------------------------------------------------------
  def hide
    SceneManager.scene.spriteset.enemy_sprites.each do |s| 
      s.tone = Tone.new(0, 0, 0, 0)
    end
    mbshide
  end
  
end

#==============================================================================
# ** Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Selectable
  alias mbsintlz initialize
  
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    mbsintlz
    self.opacity = 0 unless MBS::Battle_Interface::SHOW_WINDOWS
    self.y += 25
  end
  #--------------------------------------------------------------------------
  # * Aquisição do retangulo para desenhar o item
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(100 * index, 0, 100, 161)
    rect
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura da janela
  #--------------------------------------------------------------------------
  def window_height
    200
  end
  #--------------------------------------------------------------------------
  # * Aquisição do retângulo da área da base
  #--------------------------------------------------------------------------
  def basic_area_rect(index)
    rect = Rect.new(2 + 100 * index , 5, 100, 185)
    rect
  end
  #--------------------------------------------------------------------------
  # * Aquisição do retângulo da área do medidor
  #--------------------------------------------------------------------------
  def gauge_area_rect(index)
    rect = Rect.new(2 + 100 * index, 96, 100, 185)
    rect
  end
  #--------------------------------------------------------------------------
  # * Desenho da área básica
  #--------------------------------------------------------------------------
  def draw_basic_area(rect, actor)
    draw_face(actor.face_name, actor.face_index, rect.x, rect.y)
    draw_actor_name(actor, rect.x, rect.y, 100)
    draw_actor_icons(actor, rect.x, rect.y + 70, rect.width)
  end
  #--------------------------------------------------------------------------
  # * Desenho da área do medidor
  #--------------------------------------------------------------------------
  def draw_gauge_area(rect, actor)
    if $data_system.opt_display_tp
      draw_gauge_area_with_tp(rect, actor)
    else
      draw_gauge_area_without_tp(rect, actor)
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho da área do medidor (com TP)
  #--------------------------------------------------------------------------
  def draw_gauge_area_with_tp(rect, actor)
    draw_actor_hp(actor, rect.x, rect.y, 72)
    draw_actor_mp(actor, rect.x, rect.y + 20, 64)
    draw_actor_tp(actor, rect.x, rect.y + 40, 64)
  end
  #--------------------------------------------------------------------------
  # * Desenho da área do medidor (sem TP)
  #--------------------------------------------------------------------------
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x, rect.y, 134)
    draw_actor_mp(actor, rect.x, rect.y + 40, 76)
  end
  #--------------------------------------------------------------------------
  # * Execução do movimento do cursor
  #--------------------------------------------------------------------------
  def process_cursor_move
    return unless cursor_movable?
    last_index = @index
    cursor_down (Input.trigger?(:DOWN))  if Input.repeat?(:DOWN) || Input.repeat?(:RIGHT)
    cursor_up   (Input.trigger?(:UP))    if Input.repeat?(:UP) || Input.repeat?(:LEFT)
    Sound.play_cursor if @index != last_index
  end
end

#==============================================================================
# ** Spriteset_Battle
#==============================================================================
class Spriteset_Battle
  attr_reader :enemy_sprites
end

#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle
  attr_reader :spriteset
  #--------------------------------------------------------------------------
  # * Criação da janela de comandos do grupo
  #--------------------------------------------------------------------------
  def create_party_command_window
    @party_command_window = Window_PartyCommand.new(@info_viewport)
    @party_command_window.set_handler(:fight,  method(:command_fight))
    @party_command_window.set_handler(:escape, method(:command_escape))
    @party_command_window.unselect
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de comandos do herói
  #--------------------------------------------------------------------------
  def create_actor_command_window
    @actor_command_window = Window_ActorCommand.new(@info_viewport)
    @actor_command_window.set_handler(:attack, method(:command_attack))
    @actor_command_window.set_handler(:skill,  method(:command_skill))
    @actor_command_window.set_handler(:guard,  method(:command_guard))
    @actor_command_window.set_handler(:item,   method(:command_item))
    @actor_command_window.set_handler(:cancel, method(:prior_command))
    @actor_command_window.x = Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Seleção da escolha de inimigos
  #--------------------------------------------------------------------------
  def select_enemy_selection
    @enemy_window.refresh
    @status_window.hide
    @enemy_window.show.activate
  end
  #--------------------------------------------------------------------------
  # * Inimigo [Confirmação]
  #--------------------------------------------------------------------------
  def on_enemy_ok
    BattleManager.actor.input.target_index = @enemy_window.enemy.index
    @enemy_window.hide
    @skill_window.hide
    @item_window.hide
    @status_window.show
    next_command
  end
  #--------------------------------------------------------------------------
  # * Inimigo [Cancelamento]
  #--------------------------------------------------------------------------
  def on_enemy_cancel
    @enemy_window.hide
    case @actor_command_window.current_symbol
    when :attack
      @actor_command_window.activate
    when :skill
      @skill_window.activate
    when :item
      @item_window.activate
    end
    @status_window.show
  end
end
