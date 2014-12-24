#==============================================================================
# MS - Quest System
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
($imported ||= {})[:ms_quest_system] = true
#==============================================================================
# Configurações:
#==============================================================================
module MS_Quests
  Quests = Array.new # Não mexa
  #===========================================================================#
  #                               Vocabulário                                 #
  #===========================================================================#
  
  # Palavra para 'Rank'
  Rank = "Rank:"
  
  # Palavra para 'NPC'
  NPC = "NPC: "
  
  # Palavra para 'Local'
  Location = "Local:"
  
  # Palavra para 'Progresso'
  Progress = "Progresso: "
  
  # Palavra para 'Recompensa'
  Rewards = "Recompensa: "
  
  # Palavra para '???'
  Unknown = "???"
  
  # Palavra para 'EXP'
  EXP_Word = "EXP: "
  
  # Palavra para 'Ouro'
  Gold_Word = "Ouro: "
  
  #===========================================================================#
  #                                  Ícones                                   #
  #===========================================================================#
  
  # Índice do ícone para a experiência
  EXP_Icon = 125
  
  # Índice do ícone para o ouro 
  Gold_Icon = 361
  
  #===========================================================================#
  #                                  Missões                                  #
  #===========================================================================#
  #----------------------------------------------------------------------------
  # 1ª Missão: Caça às Slimes
  #----------------------------------------------------------------------------  
  Quests[0] = {
  
    # Nome da missão
    name: "Caça às Slimes",
    
    # Dificuldade da missão
    rank: "E",
    
    # Configurações do primeiro estágio da missão
    stage_1: {
      
      # Descrição do estágio
      description: "As Slimes estão infestando o meu \njardim! Mate 10 Slimes",
      
      # Variáveis que guardam o progresso do estágio
      progress_vars: [1],
      
      # Valor que as variáveis devem ter para a missão ser considerada completa
      completion: [10],
      
      # IDs das recompensas, se ela for EXP ou Ouro, deixe como 0
      rewards: [0,0],
      
      # Quantidade das recompensas
      r_quantity: [100, 500],
      
      # Tipos das recompensas, os tipos são:
      # E = Experiência
      # G = Ouro
      # A = Armadura
      # W = Arma
      # I = Item
      r_types: "EG",
      
      # Se quiser que a recompensa seja mostrada na descição da missão, deixe 
      # como true, senão, deixe como false
      s_rewards: [true,true],
      
      # NPC da missão, o primeiro texto é o nome do NPC, o segundo o nome do 
      # arquivo do char dele e o terceiro é o índice do char dele no arquivo
      npc: ['Camponês',"People2",3],
      
      # Lugar onde a missão acontece (apenas um texto a ser mostrado, não 
      # influencia na missão em si)
      location: "Campo"
    },
    
    # Configurações do segundo estágio da missão
    stage_2: {
    
      # Descrição do estágio
      description: "Ainda não é suficiente!\nMate mais 30 Slimes",
      
      # Variáveis que guardam o progresso do estágio
      progress_vars: [1],
      
      # Valor que as variáveis devem ter para a missão ser considerada completa
      completion: [30],
      
      # IDs das recompensas, se ela for EXP ou Ouro, deixe como 0
      rewards: [0,0],
      
      # Quantidade das recompensas
      r_quantity: [300,2000],
      
      # Tipos das recompensas, os tipos são:
      # E = Experiência
      # G = Ouro
      # A = Armadura
      # W = Arma
      # I = Item
      r_types: "EG",
      
      # Se quiser que a recompensa seja mostrada na descição da missão, deixe 
      # como true, senão, deixe como false
      s_rewards: [true,true],
      
      # NPC da missão, o primeiro texto é o nome do NPC, o segundo o nome do 
      # arquivo do char dele e o terceiro é o índice do char dele no arquivo
      npc: ['Camponês',"People2",3],
      
      # Lugar onde a missão acontece (apenas um texto a ser mostrado, não 
      # influencia na missão em si)
      location: "Campo"
    }
  }
  
#==============================================================================
# Fim das Configurações
#==============================================================================
 
  attr_accessor :unlocked_quests, :completed, :quest_stages, :rewarded

  @unlocked_quests = Array.new
  @completed = Hash.new
  @quest_stages = Hash.new
  @rewarded = Hash.new
 
  def unlock(id,stage)
    if Quests[id]
      @unlocked_quests << quests[id][:name]
      @quest_stages[quests[id][:name]] = stage
    end
  end
 
  def complete_stage(id)
    @completed[quests[id][:name]] ||= Array.new
    @completed[quests[id][:name]] << @quest_stages[quests[id][:name]]
    @completed[quests[id][:name]].uniq!
    apply_rewards(quests[id])
    @quest_stages[quests[id][:name]] += 1
    @unlocked_quests.delete(quests[id][:name]) if @quest_stages[quests[id][:name]] > stages(id)
  end
  
  def check_completion(id, stage)
    stage = quests[id]["stage_#{stage}".to_sym]
    if stage
      b_ary = []
      stage[:progress_vars].size.times {|i|
        b_ary << false unless $game_variables[stage[:progress_vars][i]] >= stage[:completion][i]
      }
      return true if b_ary.all? {|i| i == true}
      return false
    end
  end

  def apply_rewards(quest)
    stage = quest["stage_#{@quest_stages[quest[:name]]}".to_sym]
    stage[:rewards].size.times {|i|
      case stage[:r_types][i]
      when "E"
        $game_party.members[0].gain_exp(stage[:r_quantity][i])
      when "G"
        $game_party.gain_gold(stage[:r_quantity][i])
      when "W"
        $game_party.gain_item($data_weapons[stage[:rewards][i]],stage[:r_quantity][i],false)
      when "A"      
        $game_party.gain_item($data_armors[stage[:rewards][i]],stage[:r_quantity][i],false)
      when "I"
        $game_party.gain_item($data_items[stage[:rewards][i]],stage[:r_quantity][i],false)
      end
    }
  end
 
  def quests
    return Quests.compact
  end
  
  def stages(id)
    stages = 0
   
    quests[id].keys.each {|key|
    stages += 1 if key.to_s =~ /stage_\d*/
    }
   
    return stages
  end
 
end
#==============================================================================
# ** Scene_Quest
#==============================================================================
class Scene_Quest < Scene_Base
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
    create_windows
    create_background    
  end
  #--------------------------------------------------------------------------
  # * Atualização do processo
  #--------------------------------------------------------------------------  
  def update
    super
    SceneManager.return if Input.trigger?(:B)
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Criação das janelas
  #--------------------------------------------------------------------------
  def create_windows
    @quest_d_window = Window_QuestDescription.new
    @quest_window = Window_QuestList.new(@quest_d_window)
  end
  #--------------------------------------------------------------------------
  # * Criação do plano de fundo
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Disposição do plano de fundo
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
end
#==============================================================================
# ** Window_QuestList
#==============================================================================
class Window_QuestList < Window_Command
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(quest_window)
    @handler = {}
    super(0,0)
    @quest_window = quest_window
  end
  #--------------------------------------------------------------------------
  # * Atualização do objeto
  #--------------------------------------------------------------------------
  def update
    super
    @quest_window.id = MS_Quests::unlocked_quests[self.index] ? self.index : nil
    @quest_window.active = true
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def make_command_list
   
    MS_Quests.quests.each {|quest|
    add_command(MS_Quests::unlocked_quests.include?(quest[:name]) ? quest[:name] : MS_Quests::Unknown, method(:check_quest))
    }
   
  end
  #-------------------------------------------------------------------------
  # * Processo de confirmação
  #-------------------------------------------------------------------------
  def call_ok_handler
    #check_quest
    super
  end
  #--------------------------------------------------------------------------
  # * Verificação da missão
  #--------------------------------------------------------------------------
  def check_quest
    stage = MS_Quests.quests[self.index]["stage_#{MS_Quests::quest_stages[MS_Quests.quests[self.index][:name]]}".to_sym]
    if stage
      b_ary = []
      stage[:progress_vars].size.times {|i|
        b_ary << false unless $game_variables[stage[:progress_vars][i]] >= stage[:completion][i]
      }
   
      MS_Quests::completed[MS_Quests.quests[self.index][:name]] ||= Array.new
      MS_Quests.complete_stage(self.index) unless b_ary.include?(false)
      refresh
      apply_rewards(MS_Quests.quests[self.index]) if MS_Quests::completed[MS_Quests.quests[self.index][:name]].include?(MS_Quests::quest_stages[MS_Quests.quests[self.index][:name]]-1)
    end
  end
  #--------------------------------------------------------------------------
  # * Aplicação das recompensas da missão
  #--------------------------------------------------------------------------
  def apply_rewards(quest)
    stage = quest["stage_#{MS_Quests::quest_stages[quest[:name]]-1}".to_sym]
    stage[:rewards].size.times {|i|
      case stage[:r_types][i]
      when "E"
        $game_party.members[0].gain_exp(stage[:r_quantity][i])
      when "G"
        $game_party.gain_gold(stage[:r_quantity][i])
      when "W"
        $game_party.gain_item($data_weapons[stage[:rewards][i]],stage[:r_quantity],false)
      when "A"      
        $game_party.gain_item($data_armors[stage[:rewards][i]],stage[:r_quantity],false)
      when "I"
        $game_party.gain_item($data_items[stage[:rewards][i]],stage[:r_quantity],false)
      end
    }
  end
end
#==============================================================================
# ** Window_QuestDescription
#==============================================================================
class Window_QuestDescription < Window_Base
  attr_accessor :id
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(160,0,Graphics.width-160,Graphics.height)
    @id = nil
    self.active = false
  end
  #--------------------------------------------------------------------------
  # * Atualização do objeto
  #--------------------------------------------------------------------------
  def update
    super
    @quest = @id.is_a?(Integer) ? MS_Quests.quests[@id] : nil
    @quest_stage = @quest ? @quest["stage_#{MS_Quests::quest_stages[@quest[:name]]}".to_sym] : nil
   
    if self.active
      self.contents.clear
      draw_header
      draw_description
      draw_progress
      draw_rewards
    end
   
  end
  #--------------------------------------------------------------------------
  # * Desenho do cabeçalho da missão
  #--------------------------------------------------------------------------
  def draw_header
    change_color(system_color)
    draw_text(5,32,100,24,MS_Quests::Rank)
    change_color(normal_color)
   
    change_color(system_color)
    draw_text(140,32,200,24,MS_Quests::NPC)
    change_color(normal_color)
   
    change_color(system_color)
    draw_text(5,64,200,24,MS_Quests::Location)
    change_color(normal_color)
     
    if @quest_stage
      draw_text(5,0,200,24,MS_Quests.quests[@id][:name])
      draw_text_ex(300,0,"#{MS_Quests::quest_stages[@quest[:name]].to_i}/#{MS_Quests.stages(@id)}")
      draw_text_ex(5+MS_Quests::Rank.size*12,32,@quest[:rank])
 
      draw_text_ex(156+MS_Quests::NPC.size*12,32,@quest_stage[:npc][0])
      draw_character(@quest_stage[:npc][1],@quest_stage[:npc][2],140+MS_Quests::NPC.size*12,64)
     
      draw_text_ex(5+MS_Quests::Location.size*12,64,@quest_stage[:location])
    else
      draw_text_ex(5,0,MS_Quests::Unknown)
     
      draw_text_ex(325,0,MS_Quests::Unknown)
     
      draw_text_ex(5+MS_Quests::Rank.size*12,32,MS_Quests::Unknown)
 
      draw_text_ex(140+MS_Quests::NPC.size*12,32,MS_Quests::Unknown)
 
      draw_text_ex(5+MS_Quests::Location.size*12,64,MS_Quests::Unknown)
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho da descrição da missão
  #--------------------------------------------------------------------------
  def draw_description
    if @quest_stage
      draw_text_ex(5,96,@quest_stage[:description])
    else
      draw_text_ex(5,96,MS_Quests::Unknown)
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho do progresso da missão
  #--------------------------------------------------------------------------
  def draw_progress
   
    change_color(system_color)
    draw_text(5,178,200,24,MS_Quests::Progress)
    change_color(normal_color)
   
    if @quest_stage
      @quest_stage[:progress_vars].size.times {|i|
        draw_text_ex(5+MS_Quests::Progress.size*12,178+24*i,"#{$game_variables[@quest_stage[:progress_vars][i]]}/#{@quest_stage[:completion][i]}")
      }
    else
      draw_text_ex(5+MS_Quests::Progress.size*12,178,"#{MS_Quests::Unknown}/#{MS_Quests::Unknown}")      
    end
   
  end
  #--------------------------------------------------------------------------
  # * Desenho das recompensas da missão
  #--------------------------------------------------------------------------
  def draw_rewards
    change_color(system_color)
    draw_text(5,226,200,24,MS_Quests::Rewards)
    change_color(normal_color)
    if @quest_stage  
    @quest_stage[:rewards].size.times {|i|
      next unless @quest_stage[:s_rewards][i]
      case @quest_stage[:r_types][i]
      when "E"
        draw_icon(MS_Quests::EXP_Icon,5,250+24*i)
        draw_text_ex(32,250+24*i,MS_Quests::EXP_Word+@quest_stage[:r_quantity][i].to_s)
      when "G"
        draw_icon(MS_Quests::Gold_Icon,5,250+24*i)
        draw_text_ex(32,250+24*i,MS_Quests::Gold_Word+@quest_stage[:r_quantity][i].to_s)
      when "W"
        weapon = $data_weapons[@quest_stage[:rewards][i]]
        draw_text_ex(5,250+24*i,@quest_stage[:r_quantity])
        draw_icon(weapon.icon_index,5+@quest_stage[:r_quantity][i].to_s.size*12,250+24*i)
        draw_text_ex(26,250+24*i,weapon.name)
      when "A"
        armor = $data_armors[@quest_stage[:rewards][i]]
        draw_text_ex(5,250+24*i,@quest_stage[:r_quantity])
        draw_icon(armor.icon_index,5+@quest_stage[:r_quantity][i].to_s.size*12,250+24*i)
        draw_text_ex(26,250+24*i,armor.name)
      when "I"
        item = $data_items[@quest_stage[:rewards][i]]
        draw_text_ex(5,250+24*i,@quest_stage[:r_quantity])
        draw_icon(item.icon_index,5+@quest_stage[:r_quantity][i].to_s.size*12,250+24*i)
        draw_text_ex(26,250+24*i,item.name)
      else  
        next
      end
    }
    else
      draw_text_ex(5,250,MS_Quests::Unknown)
    end
  end
end
#==============================================================================
# ** DataManager
#==============================================================================
module DataManager
  
  class << self
    alias mbsesc extract_save_contents 
    alias mbsmsc make_save_contents 
  end

  #--------------------------------------------------------------------------
  # * Extrair conteúdo salvo
  #--------------------------------------------------------------------------
  def self.extract_save_contents(contents)
    mbsesc(contents)
    load_quest_data(contents[:quests])
  end
  
  #--------------------------------------------------------------------------
  # * Salvar a criação de conteúdo
  #--------------------------------------------------------------------------
  def self.make_save_contents
    contents = mbsmsc
    contents[:quests] = make_quest_data
    contents
  end
  
  def self.load_quest_data(data)
    MS_Quests.quest_stages = data[:stages]
    MS_Quests.unlocked_quests = data[:unlocked]
    MS_Quests.completed = data[:completed]
    MS_Quests.rewarded = data[:rewarded]
  end
  
  def self.make_quest_data
    data = {
      stages: MS_Quests.quest_stages,
      unlocked: MS_Quests.unlocked_quests,
      completed: MS_Quests.completed,
      rewarded: MS_Quests.rewarded
    }
    return data
  end
  
end
