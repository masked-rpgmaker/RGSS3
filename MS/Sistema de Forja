#==============================================================================#
# MS - Crafting System                                                         
#                                                                              
# by Masked                                                                    
#                                                                              
# Cria um sistema de forja, é possível configurar as receitas, para habilitar 
# uma receita digite em chamar script: MS_Craft.add_recipe(id)
#
#==============================================================================#
module MS_Craft_System_Config
  Recipe = []
#==============================================================================#
# Configurações 
#==============================================================================#
Recipe[0] = [
# Receita 1

# Nome da receita
Title = "Armadura Espinhosa",
# Tipo dos ingredientes ( I = item, E = Equipamento, W = Arma)
Ingredient_Types = ["I", "E", "W","I"],
# ID dos ingredientes no database, segue na mesma ordem de Ingredient_Types
Ingredients_ID = [1, 3, 4, 3],
# Número de ingredientes necessários para fazer o item, segue na ordem dos dois acima
Ingredients_Number = [1, 2, 1, 10],
# Tipo do item resultante
Result_Type = "E",
# ID do item resultante no database
Result_ID = 5,
# Se a receita for habilitada automaticamente mude para true
Enabled = false
]
Recipe[1] = [
# Receita 1

# Nome da receita
Title = "Poção",
# Tipo dos ingredientes ( I = item, E = Equipamento, W = Arma)
Ingredient_Types = ["I","I"],
# ID dos ingredientes no database, segue na mesma ordem de Ingredient_Types
Ingredients_ID = [1, 3],
# Número de ingredientes necessários para fazer o item, segue na ordem dos dois acima
Ingredients_Number = [1, 2],
# Tipo do item resultante
Result_Type = "I",
# ID do item resultante no database
Result_ID = 1,
# Se a receita for habilitada automaticamente mude para true
Enabled = false
]
end
#==============================================================================#
# Fim das Configurações 
#==============================================================================#
class MS_Craft < Scene_Base
  include MS_Craft_System_Config
  def initialize
    super
    @recipe_window = Window_Base.new(0, 50, 544, 366)
    @head_window = Window_Base.new(0, 0, 544, 50)
    @head_window.contents.draw_text(0, -10, 500, 50, "Forja:")
    @recipe_index = 0
    @text_writen = false
    @disponible_writen = false
    @ingredients = []
  end
  def update
    super
     if @text_writen == false
    @recipe_window.contents.draw_text(0, -100, 500, 300, "Receita nº#{@recipe_index + 1}")
    if Recipe[@recipe_index][6]
    @recipe_window.contents.draw_text(0, -70, 500, 300, "#{Recipe[@recipe_index][0]}")
    @recipe_window.contents.draw_text(0, -10, 198, 300, "Ingredientes:")
    for i in 0...Recipe[@recipe_index][2].size
    @recipe_window.draw_text(0, 30 + i * 20, 300, 300, "#{Recipe[@recipe_index][3][i]} #{$data_items[Recipe[@recipe_index][2][i]].name}") if Recipe[@recipe_index][1][i] == "I"
      @recipe_window.draw_text(0, 30 + i * 20, 300, 300, "#{Recipe[@recipe_index][3][i]} #{$data_armors[Recipe[@recipe_index][2][i]].name}") if Recipe[@recipe_index][1][i] == "E"
          @recipe_window.draw_text(0, 30 + i * 20, 300, 300, "#{Recipe[@recipe_index][3][i]} #{$data_weapons[Recipe[@recipe_index][2][i]].name}") if Recipe[@recipe_index][1][i] == "W"
    end
  for i in 0...Recipe[@recipe_index][1].size
  if Recipe[@recipe_index][1][i] == "I" 
    if $game_party.has_item?($data_items[Recipe[@recipe_index][2][i]])
      if $game_party.item_number($data_items[Recipe[@recipe_index][2][i]]) == Recipe[@recipe_index][3][i]
      @ingredients[i] = true
        end
  end
end
  if Recipe[@recipe_index][1][i] == "E" 
    if $game_party.has_item?($data_armors[Recipe[@recipe_index][2][i]])
      if $game_party.item_number($data_armors[Recipe[@recipe_index][2][i]]) == Recipe[@recipe_index][3][i]
      @ingredients[i] = true
        end
  end
end
  if Recipe[@recipe_index][1][i] == "W" 
    if $game_party.has_item?($data_weapons[Recipe[@recipe_index][2][i]])
      if $game_party.item_number($data_weapons[Recipe[@recipe_index][2][i]]) == Recipe[@recipe_index][3][i]
      @ingredients[i] = true
  end
end
end
end
if @ingredients == Array.new(Recipe[@recipe_index][2].size, true)
  @recipe_window.contents.draw_text(150, - 10, 500, 300, "Disponível!") if @disponible_writen != true
  @disponible_writen = true
end
    else 
  @recipe_window.contents.draw_text(0, -70, 500, 300, "???????")
    @recipe_window.contents.draw_text(0, -10, 198, 300, "Ingredientes:")
    @recipe_window.draw_text(0, 30, 300, 300, "???????") 
    end
    end
        @text_writen = true 
    if Input.trigger?(:C) and @ingredients == Array.new(Recipe[@recipe_index][2].size, true)
  $game_party.gain_item($data_items[Recipe[@recipe_index][5]], 1) if Recipe[@recipe_index][4] == "I"
  $game_party.gain_item($data_armors[Recipe[@recipe_index][5]], 1, true) if Recipe[@recipe_index][4] == "E"
  $game_party.gain_item($data_weapons[Recipe[@recipe_index][5]], 1, true) if Recipe[@recipe_index][4] == "W"
  for i in 0...Recipe[@recipe_index][2].size
  $game_party.lose_item($data_items[Recipe[@recipe_index][2][i]], Recipe[@recipe_index][3][i]) if Recipe[@recipe_index][1][i] == "I"
  $game_party.lose_item($data_armors[Recipe[@recipe_index][2][i]], Recipe[@recipe_index][3][i]) if Recipe[@recipe_index][1][i] == "E"
  $game_party.lose_item($data_weapons[Recipe[@recipe_index][2][i]], Recipe[@recipe_index][3][i]) if Recipe[@recipe_index][1][i] == "W"
  @ingredients = Array.new(Recipe[@recipe_index][2].size, false)
  end
  @recipe_window.contents.clear
  @text_writen = false
  @disponible_writen = false
end
    SceneManager.goto(Scene_Map) if Input.trigger?(:B)
    if Input.repeat?(:DOWN) and @recipe_index < Recipe.size - 1
      @recipe_window.contents.clear
    @recipe_index += 1
      @text_writen = false
  @disponible_writen = false
    end
    if Input.repeat?(:UP) and @recipe_index > 0
    @recipe_index -= 1 
    @recipe_window.contents.clear
      @text_writen = false
  @disponible_writen = false
    end
end
def self.add_recipe(id)
  Recipe[id][6] = true
  end
    end
