#==============================================================================#
# MBS - Menu Simples                                                           #
#                                                                              #
# by Masked                                                                    #
#                                                                              #
#==============================================================================#
#==============================================================================#
# Configurações                                                                #
#==============================================================================#
module MBS_SimpleMenu

  Age = 13                   # Idade do Herói
  DialogAge = "Idade"        # Texto de Idade
  DialogItem = "Item"        # Texto do botão Item
  DialogLoad = "Carregar"    # Texto do botão Load
end
# Não mexa daqui para baixo
class MBSMenu < Scene_Base
  include MBS_SimpleMenu
  def start
    super
    @player = $game_party.members[0]
    @hp = @player.hp
    @mhp = @player.mhp
    @status_win = Window_Base.new(175, 275, 335, 125)
    @choice_win = Window_Selectable.new(10, 300, 145, 80)
    create_background
    @status_win.contents.fill_rect(130, @choice_win.item_height * 4 - 8, 100, 9,Color.new(70,70,70))
    @status_win.contents.gradient_fill_rect(130, @choice_win.item_height * 4 - 8, 100*@hp/@mhp, 9,Color.new(0,70,0),Color.new(0,255,0))
    @choice_win.contents.draw_text(5, - 8, 192 - 24, 64 - 24,DialogItem)
    @choice_win.contents.draw_text(5, @choice_win.item_height - 8, 192 - 24, 64 - 24,DialogLoad)
    @status_win.draw_face($game_actors[1].face_name, $game_actors[1].face_index, 5, 10)
    @status_win.contents.draw_text(130, @choice_win.item_height - 8, 100, 30, $game_actors[1].name)
    @status_win.contents.draw_text(130, @choice_win.item_height * 2 - 8, 100, 30, "#{DialogAge}:#{Age}")
    @status_win.contents.draw_text(130, @choice_win.item_height * 3 - 8, 120, 30, "#{Vocab.hp_a}: #{@hp}/#{@mhp}")
    @choice_win.index = 0
    end
  def update
    
  @choice_win.index += 1 if Input.repeat?(:DOWN) and @choice_win.index < 1
  @choice_win.index -= 1 if Input.repeat?(:UP) and @choice_win.index > 0
  SceneManager.call(Scene_Item) if Input.trigger?(:C)and @choice_win.index == 0
  SceneManager.call(Scene_Load) if Input.trigger?(:C) and @choice_win.index == 1 
  SceneManager.goto(Scene_Map) if Input.trigger?(:B)
    super
  end
  def dispose
    super 
  end    
  def terminate
  super
  dispose_background
end
def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  def dispose_background
    @background_sprite.dispose
  end
end
class Scene_Map
  alias mbs_call call_menu
  def call_menu
    mbs_call
    SceneManager.goto(MBSMenu)
  end
end
