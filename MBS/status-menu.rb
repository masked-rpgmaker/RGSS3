#==============================================================================
# RGSS3 - Fábrica: Menu Status
#------------------------------------------------------------------------------
# por Masked
#
# agradecimentos ao Shiroyasha, pelo método de desenhar um círculo
#==============================================================================
module RGSS3_SWH_Status

# Texto que aparece na janela superior
Help_Text = "Status"

# Lista dos atributos, eles serão escritos na ordem em que estiverem 
# configurados aqui, com os nomes configurados
# :atk = Ataque
# :def = Defesa
# :mat = Ataque Mágico
# :mdf = Defesa Mágica
# :adi = Agilidade
# :luk = Sorte
Attributes = {
  :atk => "FOR",
  :def => "DES",
  :mat => "CON",
  :mdf => "INT",
  :agi => "SAB",
  :luk => "CAR"
  }  
  
# Espessura em píxels da linha de separação
Separator_Height = 1

# Cor da linha de separação
Separator_Color = Color.new(255,255,255)

# Cor do texto especial, como nome dos atributos e tipo de equipamento
Special_Color = Color.new(160,152,255)

end
#==============================================================================
# ** Scene_Status
#==============================================================================
class Scene_Status < Scene_MenuBase
  include RGSS3_SWH_Status
  
  #============================================================================
  # Métodos principais
  #----------------------------------------------------------------------------
  #----------------------------------------------------------------------------
  # * Inicialização do Processo
  #----------------------------------------------------------------------------
  def start
    super
    
    #==========================================================================
    # Criação das Janelas
    #--------------------------------------------------------------------------
    
    # Janela de Ajuda
    @help_window = Window_Help.new(1)
    
    # Definição dos valores padrão de largura e altura das janelas
    @window_width = Graphics.width/3
    @window_height = Graphics.height-@help_window.height-72
    
    # Janela de Atributos
    @attribute_window = Window_Base.new(0,@help_window.height,@window_width,@window_height)
    
    # Janela de Informações
    @information_window = Window_Base.new(@window_width,@help_window.height,@window_width,@window_height)
    
    # Janela de Equipamentos
    @equipment_window = Window_Base.new(@window_width*2,@help_window.height,@window_width,@window_height)
    
    # Janela de Descrição
    @description_window = Window_Base.new(0,@help_window.height+@window_height,Graphics.width,72)
    
    #--------------------------------------------------------------------------
    # Fim
    #==========================================================================
    
    # Definição do membro inicial do grupo
    @actor = $game_party.menu_actor
    
    #==========================================================================
    # Criação do conteúdo das janelas
    #--------------------------------------------------------------------------
    
    # Método auxiliar
    create_windows_contents
    
    #--------------------------------------------------------------------------
    # Fim
    #==========================================================================

  end
  
  #----------------------------------------------------------------------------
  # * Atualização do Processo
  #----------------------------------------------------------------------------
  def update
    super
     SceneManager.return if Input.trigger?(:B)  
     if Input.trigger?(:R) || Input.trigger?(:RIGHT)
      @actor = $game_party.menu_actor_next
      instance_variables.each {|ivar| 
      instance_variable_get(ivar).contents.clear if instance_variable_get(ivar).is_a?(Window)
      }
      create_windows_contents
     end
     if Input.trigger?(:L) || Input.trigger?(:LEFT)
      @actor = $game_party.menu_actor_prev
      instance_variables.each {|ivar| 
      instance_variable_get(ivar).contents.clear if instance_variable_get(ivar).is_a?(Window)
      }
      create_windows_contents
     end
  end
  #----------------------------------------------------------------------------
  # * Finalização do Processo
  #----------------------------------------------------------------------------
  def terminate
    super
    instance_variables.each {|ivar| 
    instance_variable_get(ivar).dispose if instance_variable_get(ivar).is_a?(Window) || instance_variable_get(ivar).is_a?(Bitmap)}
  end
  
  #----------------------------------------------------------------------------
  # Fim
  #============================================================================
  
  #============================================================================
  # Métodos auxiliares
  #----------------------------------------------------------------------------
    #--------------------------------------------------------------------------
    # * Criação do conteúdo das janelas
    #--------------------------------------------------------------------------
    def create_windows_contents
        
    # Definição do tamanho do conteúdo das janelas
    contents_width = @attribute_window.contents_width  
      
    # Janela de Ajuda
    @help_window.clear
    @help_window.set_text(Help_Text)
    
    # Janela de Atributos
    @attribute_window.contents.draw_text(0,0,contents_width,32,"Atributos",1)
    @attribute_window.contents.fill_rect(0,32,contents_width,Separator_Height,Separator_Color)
    
    @attribute_window.contents.font.color = Special_Color
    i = 0
    Attributes.each {|attr|
    @attribute_window.contents.draw_text(0,32+24*i,96,32,attr[1])
    @attribute_window.contents.font.color = Color.new(255,255,255)
    @attribute_window.contents.fill_rect(19+attr[1].size*8,40+24*i,100,14,Color.new(10,10,25))
    case attr[0]
    when :atk
      @attribute_window.contents.fill_rect(20+attr[1].size*8,41+24*i,@actor.atk/999.0*(contents_width-(54+attr[1].size*8)),12,Color.new(255,0,0))
      @attribute_window.contents.draw_text(24+attr[1].size*8+@actor.atk/999.0*(contents_width-(54+attr[1].size*8)),35+24*i,32,24,@actor.atk)    
      when :def
      @attribute_window.contents.fill_rect(20+attr[1].size*8,41+24*i,@actor.def/999.0*(contents_width-(54+attr[1].size*8)),12,Color.new(50,255,50))
      @attribute_window.contents.draw_text(24+attr[1].size*8+@actor.def/999.0*(contents_width-(54+attr[1].size*8)),35+24*i,32,24,@actor.def)    
    when :mat
      @attribute_window.contents.fill_rect(20+attr[1].size*8,41+24*i,@actor.mat/999.0*(contents_width-(54+attr[1].size*8)),12,Color.new(175,0,175))
      @attribute_window.contents.draw_text(24+attr[1].size*8+@actor.mat/999.0*(contents_width-(54+attr[1].size*8)),35+24*i,32,24,@actor.mat)    
    when :mdf
      @attribute_window.contents.fill_rect(20+attr[1].size*8,41+24*i,@actor.mdf/999.0*(contents_width-(54+attr[1].size*8)),12,Color.new(0,175,0))
      @attribute_window.contents.draw_text(24+attr[1].size*8+@actor.mdf/999.0*(contents_width-(54+attr[1].size*8)),35+24*i,32,24,@actor.mdf)    
    when :agi
      @attribute_window.contents.fill_rect(20+attr[1].size*8,41+24*i,@actor.agi/999.0*(contents_width-(54+attr[1].size*8)),12,Color.new(85,100,255))
      @attribute_window.contents.draw_text(24+attr[1].size*8+@actor.agi/999.0*(contents_width-(54+attr[1].size*8)),35+24*i,32,24,@actor.agi)    
    when :luk
      @attribute_window.contents.fill_rect(20+attr[1].size*8,41+24*i,@actor.agi/999.0*(contents_width-(54+attr[1].size*8)),12,Color.new(175,175,0))
      @attribute_window.contents.draw_text(24+attr[1].size*8+@actor.luk/999.0*(contents_width-(54+attr[1].size*8)),35+24*i,32,24,@actor.luk)    
    end
    @attribute_window.contents.font.color = Special_Color
    i += 1
    }
    @attribute_window.contents.font.color = Special_Color
    @attribute_window.contents.fill_rect(0,180,contents_width,Separator_Height,Separator_Color)
    @attribute_window.contents.draw_text(32,186,48,24,"HP")
    @attribute_window.contents.draw_text(contents_width-52,186,48,24,"MP")
    @attribute_window.contents.font.color = Color.new(255,255,255)
    @attribute_window.contents.draw_circle(42,242,28,Color.new(10,10,25))
    @attribute_window.contents.draw_text(15,242-24,56,24,@actor.hp,1)
    @attribute_window.contents.fill_rect(25,242,34,1,Color.new(255,255,255))
    @attribute_window.contents.draw_text(15,242+1,56,24,@actor.mhp,1)
    @attribute_window.contents.draw_circle(contents_width-42,242,28,Color.new(10,10,25))
    @attribute_window.contents.draw_text(contents_width-68,242-24,56,24,@actor.mp,1)
    @attribute_window.contents.fill_rect(contents_width-58,242,34,1,Color.new(255,255,255))
    @attribute_window.contents.draw_text(contents_width-68,242+1,56,24,@actor.mmp,1)
    
    # Janela de Informações
    @information_window.draw_text(0,0,contents_width,24,"#{@actor.name} #{@actor.nickname}",1)
    @information_window.draw_face(@actor.face_name, @actor.face_index, contents_width/2-47, 32)
    actor_class = $data_classes[@actor.class_id]
    @information_window.draw_text(0,132,contents_width,24,actor_class.name,1)
    @information_window.draw_text(0,156,contents_width,24,"Nível")
    @information_window.draw_text(contents_width-@actor.level.to_s.size*12,156,@actor.level.to_s.size*12,24,@actor.level)
    @information_window.contents.fill_rect(0,180,contents_width,Separator_Height,Separator_Color)
    @information_window.draw_text(0,180,64,24,"EXP")
    @information_window.draw_text(contents_width-@actor.current_level_exp.to_s.size*12,180,(@actor.exp-@actor.current_level_exp).to_s.size*12,24,@actor.exp-@actor.current_level_exp)
    @information_window.draw_text(0,204,108,24,"Próximo nível")
    @information_window.draw_text(contents_width-@actor.next_level_exp.to_s.size*12,204,@actor.next_level_exp.to_s.size*12,24,@actor.next_level_exp)
    i = 0
    @actor.states.each {|state|
    @information_window.draw_icon(state.icon_index,25*i,242) unless 25*i+24 > contents_width
    i += 1
    }
    
    # Janela de Equipamentos
    i = 0
    @equipment_window.draw_text(0,0,contents_width,24,"Equipamentos",1)
    @equipment_window.contents.fill_rect(0,32,contents_width,Separator_Height,Separator_Color)
    @actor.equips.each {|item|
    unless item.nil?
    @equipment_window.draw_icon(item.icon_index,0,48+32*i)
    @equipment_window.draw_text(32,48+32*i,contents_width-32,24,item.name)
    i += 1
    end
    }
    
    # Janela de Descrição
    @description_window.draw_text_ex(0,0,@actor.description)
    
  end
  #----------------------------------------------------------------------------
  # Fim
  #============================================================================
end

#==============================================================================
# ** Bitmap
#==============================================================================
class Bitmap
  #----------------------------------------------------------------------------
  # * Desenho de um círculo
  #----------------------------------------------------------------------------
def draw_circle(y,x,r,color)
 
  for i in (y - r).. (y + r)
    j1 = Math.sqrt((r**2) - ((i - y)*(i - y))) + x
    j2 = - Math.sqrt((r**2) - ((i - y)*(i - y))) + x
    j1 = j1.to_i
    j2 = j2.to_i
 
    for k in j2..j1
      self.set_pixel(i,k,color)
    end
   
  end
 
  for j in (x - r).. (x + r)
    i1 = Math.sqrt((r**2) - ((j - x)*(j - x))) + y
    i2 = - Math.sqrt((r**2) - ((j - x)*(j - x))) + y
    self.set_pixel(i1,j,color)
    self.set_pixel(i2,j,color)
  end
end
end
