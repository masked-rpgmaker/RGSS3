#==============================================================================
# MBS - DLC
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# Requerimentos:
#------------------------------------------------------------------------------
# - Coloque o script FileUtils acima deste script, o FileUtils pode ser 
#   obtido em 'http://goo.gl/K6FXJ6'
#==============================================================================
#==============================================================================
# Instruções
#------------------------------------------------------------------------------
#
#   OBS.: Por enquanto não é possível colocar gráficos e audio na DLC, 
# com o tempo isso será adicionado
#
#------------------------------------------------------------------------------
# Criando o projeto:
#------------------------------------------------------------------------------
#     Para criar uma DLC, primeiro crie um novo projeto no RPG Maker e faça tudo
#   normalmente, não é preciso colocar no projeto da DLC o conteúdo já existente
#   na versão original do jogo, e lembre-se de criar as coisas no database com o 
#   ID a partir do último ID já usado no jogo.
#
#     Por questão de segurança, deixe, na versão original do jogo, todos os
#   primeiros espaços do database vazios.
#
#   (OBS.: Para fazer os mapas, recomendo que os faça no projeto original e 
#   depois passe tudo que foi criado ou alterado para o projeto da DLC, assim
#   o ID do mapa não fica igual ao de outro mapa)
#
#     Lembre-se também que, exceto os mapas, todos os elementos da DLC são 
#   "somados" aos originais.
#     No caso dos mapas, todo mapa que existir na DLC vai substituir qualquer 
#   mapa que tenha o mesmo ID.
#
#------------------------------------------------------------------------------
# Exportando a DLC:
#------------------------------------------------------------------------------
#     Para exportar a DLC, coloque num script acima do main:
#       MBS::DLC.save(nome, itens_exportados)
#     
#     Nesse caso, nome deve ser o nome do arquivo da DLC a ser criada, e deve
#   vir entre aspas, e itens exportados deve ser uma Array com a lista de itens
#   que a DLC vai ter, existem algumas listas prontas que podem ser usadas, 
#   elas são: 
#
#     - MBS::DLC::ALL       = Exporta tudo que for possível
#
#     - MBS::DLC::ALL_DATA  = Exporta tudo exceto as pastas Graphics e Audio
#
#     - MBS::DLC::MAPS      = Exporta todos os mapas, dados dos mapas, 
#                            tilesets e eventos comuns
#
#     - MBS::DLC::BATTLERS  = Exporta heróis, habilidades, animações, inimigos,
#                            tropas, estados, classes, itens, armas e armaduras
#
#     - MBS::DLC::ITEMS     = Exporta itens, armas e armaduras
#
#     - MBS::DLC::USABLE    = Exporta itens e habilidades
#
#     - MBS::DLC::RESOURCES = Exporta gráficos, audio e scripts
#
#     Além dessas listas pré-definidas, podem ser feitas outras listas, usando
#   para isso os seguintes itens precedidos por : (dois pontos):
#
#     - maps
#     - tilesets
#     - c_events
#     - map_data
#     - items
#     - weapons
#     - armors
#     - skills
#     - actors
#     - classes
#     - enemies
#     - troops
#     - states
#     - animations
#     - system
#     - scripts
#     - graphics
#     - audio
#
#------------------------------------------------------------------------------
#   Ex.:
#------------------------------------------------------------------------------
#
#     # exporta tudo
#     MBS::DLC.save('dlc1', MBS::DLC::ALL) 
#
#     # exporta itens, animações, estados e scripts
#     MBS::DLC.save('dlc2', [:items, :animations, :states, :scripts])
#
#------------------------------------------------------------------------------
# Colocando a DLC no jogo
#------------------------------------------------------------------------------
#     Para colocar a DLC no jogo, é só copiar o arquivo que aparece depois de
#   exportar a DLC (algumacoisa.rvdlc2) na pasta do jogo, com isso, o script
#   carrega os dados do arquivo junto com o resto.
#==============================================================================
 
($imported ||= {})[:mbs_dlc] = true
module MBS
  module DLC
#==============================================================================
# Configurações
#==============================================================================
    
    # Nome da pasta onde ficarão os arquivos de DLC
    FOLDER = "DLC"   
    
    # Extensão usada nos arquivos de DLC
    EXTENSION = '.rvdlc2'
    
    # Caso queira que o arquivo seja encriptado, deixe como true, se não
    # deixe como false
    # Obs.: Essa opção deixa o processo mais lento e aumenta consideravelmente 
    # o tamanho do arquivo da DLC, mas protege os dados.
    ENCRYPT = true
    
    # Chave de encriptação que deve ser menor que 0x1FFF03 (2096899)
    CRYPT_KEY = 0xFF
    
    # Caso queira que a tela de loading apareça, mude este valor para um dos
    # números:
    # 1 = Loading antes da tela de título
    # 2 = Loading antes de todos os mapas
    # 3 = Loading antes da tela de título e antes de todos os mapas
    LOADING = 0
    
    # Caso queira que alguns mapas não tenha a tela de loading, coloque os
    # ids deles dentro dos colchetes, separados por vírgulas
    M_EXCLUDE = []
    
    # Caso queira que apenas alguns mapas tenham a tela de loading, coloque os
    # ids deles dentro dos colchetes, separados por vírgulas
    M_INCLUDE = []
    
    # Caso esteja usando o Loading, insira aqui o nome do arquivo (na pasta
    # System) das imagens que serão usadas, a primeira é a imagem de fundo
    # e a segunda a imagem de um círculo para ficar girando enquanto o
    # carregamento é feito
    IMAGE = "Loading_BG"
 
  end
#==============================================================================
# Fim das Configurações
#==============================================================================
end
  
$need_upd = false
 
#==============================================================================
# Bitmap Export v5.4 for XP, VX and VXace by Zeus81
#==============================================================================
def vxace?() true end
def xp?() false end
def vx?() false end
  
class String
  alias getbyte  []
  alias setbyte  []=
  alias bytesize size
end unless vxace?
 
class Font
  def marshal_dump()     end
  def marshal_load(dump) end
end
 
class Bitmap
  RtlMoveMemory = Win32API.new('kernel32', 'RtlMoveMemory', 'ppi', 'i')
  def last_row_address
    return 0 if disposed?
    RtlMoveMemory.call(buf=[0].pack('L'), __id__*2+16, 4)
    RtlMoveMemory.call(buf, buf.unpack('L')[0]+8 , 4)
    RtlMoveMemory.call(buf, buf.unpack('L')[0]+16, 4)
    buf.unpack('L')[0]
  end
  def bytesize
    width * height * 4
  end
  def get_data
    data = [].pack('x') * bytesize
    RtlMoveMemory.call(data, last_row_address, data.bytesize)
    data
  end
  def set_data(data)
    RtlMoveMemory.call(last_row_address, data, data.bytesize)
  end
  def get_data_ptr
    data = String.new
    RtlMoveMemory.call(data.__id__*2, [vxace? ? 0x6005 : 0x2007].pack('L'), 4)
    RtlMoveMemory.call(data.__id__*2+8, [bytesize,last_row_address].pack('L2'), 8)
    def data.free(); RtlMoveMemory.call(__id__*2, String.new, 16); end
    return data unless block_given?
    yield data ensure data.free
  end
  def _dump(level)
    get_data_ptr do |data|
      dump = Marshal.dump([width, height, Zlib::Deflate.deflate(data, 9)])
      dump.force_encoding('UTF-8') if vxace?
      dump
    end
  end
  def self._load(dump)
    width, height, data = *Marshal.load(dump)
    data.replace(Zlib::Inflate.inflate(data))
    bitmap = new(width, height)
    bitmap.set_data(data)
    bitmap
  end
end
 
module Graphics
  if xp?
    FindWindow             = Win32API.new('user32', 'FindWindow'            , 'pp'       , 'i')
    GetDC                  = Win32API.new('user32', 'GetDC'                 , 'i'        , 'i')
    ReleaseDC              = Win32API.new('user32', 'ReleaseDC'             , 'ii'       , 'i')
    BitBlt                 = Win32API.new('gdi32' , 'BitBlt'                , 'iiiiiiiii', 'i')
    CreateCompatibleBitmap = Win32API.new('gdi32' , 'CreateCompatibleBitmap', 'iii'      , 'i')
    CreateCompatibleDC     = Win32API.new('gdi32' , 'CreateCompatibleDC'    , 'i'        , 'i')
    DeleteDC               = Win32API.new('gdi32' , 'DeleteDC'              , 'i'        , 'i')
    DeleteObject           = Win32API.new('gdi32' , 'DeleteObject'          , 'i'        , 'i')
    GetDIBits              = Win32API.new('gdi32' , 'GetDIBits'             , 'iiiiipi'  , 'i')
    SelectObject           = Win32API.new('gdi32' , 'SelectObject'          , 'ii'       , 'i')
    def self.snap_to_bitmap
      bitmap  = Bitmap.new(width, height)
      info    = [40,width,height,1,32,0,0,0,0,0,0].pack('LllSSLLllLL')
      hDC     = GetDC.call(hwnd)
      bmp_hDC = CreateCompatibleDC.call(hDC)
      bmp_hBM = CreateCompatibleBitmap.call(hDC, width, height)
      bmp_obj = SelectObject.call(bmp_hDC, bmp_hBM)
      BitBlt.call(bmp_hDC, 0, 0, width, height, hDC, 0, 0, 0xCC0020)
      GetDIBits.call(bmp_hDC, bmp_hBM, 0, height, bitmap.last_row_address, info, 0)
      SelectObject.call(bmp_hDC, bmp_obj)
      DeleteObject.call(bmp_hBM)
      DeleteDC.call(bmp_hDC)
      ReleaseDC.call(hwnd, hDC)
      bitmap
    end
  end
  class << self
    def hwnd() @hwnd ||= FindWindow.call('RGSS Player', nil) end
    def width()  640 end unless method_defined?(:width)
    def height() 480 end unless method_defined?(:height)
    def export(filename=Time.now.strftime("snapshot %Y-%m-%d %Hh%Mm%Ss #{frame_count}"))
      bitmap = snap_to_bitmap
      bitmap.export(filename)
      bitmap.dispose
    end
    alias save     export
    alias snapshot export
  end
end
$loaded_bitmaps = {}
#==============================================================================
# ** MBS
#==============================================================================
module MBS
  
  #----------------------------------------------------------------------------
  # * Copia dados de 'from' para 'to'
  #----------------------------------------------------------------------------
  def self.copy_data(from, to)
    save_data(load_data(from), to)
  end
  
#==============================================================================
# ** MBS::Crypt
#==============================================================================
  module Crypt
  extend self
 
    #--------------------------------------------------------------------------
    # * Encripta o texto 'txt' usando a chave 'key'
    #--------------------------------------------------------------------------
    def encrypt(txt, key)
      return txt.unpack("U*").collect do |i| 
        i + DLC::CRYPT_KEY
      end.pack('U*').unpack('S*').pack('U*')
    end
 
    #--------------------------------------------------------------------------
    # * Desencripta o texto 'txt' usando a chave 'key'
    #--------------------------------------------------------------------------
    def decrypt(txt, key)
      return txt.unpack('U*').pack('S*').unpack("U*").collect do |i| 
        i - DLC::CRYPT_KEY > 0 ? i - DLC::CRYPT_KEY : i
      end.pack('U*')
    end
  end
  
#==============================================================================
# Verificação da existência do módulo FileUtils
#==============================================================================
 
  begin
    FileUtils
  rescue
    if $TEST
      msgbox ('Necessário o script FileUtils para usar o MBS - DLC,' + 
              'certifique-se também de colocá-lo acima do MBS - DLC')
      system 'start http://goo.gl/K6FXJ6'
    else
      msgbox ('Falta um script no jogo, tente instalá-lo novamente,' + 
              'caso o erro persista, entre em contato com o desenvolvedor')
    end
    exit
  end
  
#==============================================================================
# MBS::DLC
#==============================================================================
  module DLC
    
    #--------------------------------------------------------------------------
    # * Encripta o texto 'text' usando a chave de ecriptação escolhida
    #--------------------------------------------------------------------------
    def self.encrypt(text)
      return Crypt.encrypt(text, CRYPT_KEY)
    end
    
    #--------------------------------------------------------------------------
    # * Desencripta o texto 'text' usando a chave de encriptação escolhida
    #--------------------------------------------------------------------------
    def self.decrypt(text)
      return Crypt.decrypt(text, CRYPT_KEY)
    end
    
    #==========================================================================
    # >> Definição das constantes
    #==========================================================================
    
    #--------------------------------------------------------------------------
    # Todas os dados e pastas
    #--------------------------------------------------------------------------
    ALL = [
            :maps,      :c_events,   :actors,    :classes,  :items,   
            :weapons,   :armors,     :skills,    :enemies,  :troops,   
            :states,    :animations, :tilesets,  :system,   :graphics,  
            :audio,     :scripts,    :map_info
          ]
 
    #--------------------------------------------------------------------------
    # Todas os dados
    #--------------------------------------------------------------------------
    ALL_DATA = ALL - [:audio, :graphics]
    
    #--------------------------------------------------------------------------
    # Todos os dados de itens
    #--------------------------------------------------------------------------
    ITEMS = [:items, :weapons, :armors]
    
    #--------------------------------------------------------------------------
    # Todos os dados de batalha
    #--------------------------------------------------------------------------
    BATTLERS = [:actors, :classes, :skills,     :armors, :weapons, :enemies, 
                :troops, :states,  :animations, :items]
    
    #--------------------------------------------------------------------------
    # Todos os dados de objetos usáveis
    #--------------------------------------------------------------------------
    USABLE = [:skills, :items]
    
    #--------------------------------------------------------------------------
    # Todos os dados de mapas
    #--------------------------------------------------------------------------
    MAPS = [:maps, :c_events, :tilesets, :map_info]
    
    #--------------------------------------------------------------------------
    # Todos os recursos (Gráficos, Audio e Scripts)
    #--------------------------------------------------------------------------
    RESOURCES = [:graphics, :audio, :scripts]
    
    #==========================================================================
    # Fim das constantes
    #==========================================================================
    
    #--------------------------------------------------------------------------
    # * Carregamentos de dados de um arquivo de DLC
    #--------------------------------------------------------------------------
    def self.load(filename, i)
      puts "Carregando #{i}..."
      t = get_content(filename, i)
      File.open('temp', 'wb') {|f| f.write(t || " ")}
      system('attrib temp +h +s')
      begin
        o = load_data('temp') 
      rescue 
        if $TEST
          raise "Erro com o carregamento da DLC '#{filename}', provavelmente a"+ 
          " chave de encriptação está incorreta"
        else
          raise "Erro com o carregamento da DLC '#{filename}', verifique se " + 
          "ela pertence a este jogo e se é válida."
        end
      end
      File.delete('temp')
      puts "Carregamento terminado", ''
      return o
    end
    
    #--------------------------------------------------------------------------
    # * Carregamento de um arquivo 'v' na pasta da DLC 'name'
    #--------------------------------------------------------------------------
    def self.load_file(name, v)
      File.open("#{FOLDER}/#{name}/" + v.to_s + EXTENSION, 'rb') {|f| f.read}
    end
    
    #--------------------------------------------------------------------------
    # * Carregamento de um Bitmap a partir de uma DLC
    #--------------------------------------------------------------------------
    def self.load_graphic(path, dlc=nil)
      if $loaded_bitmaps[path]
        return $loaded_bitmaps[path] 
      end
      return unless path =~ /Graphics\/(.+)\/(.+)/
      n = ''
      if dlc
        return unless get_exported(dlc).include?("graphic:#{$1}:#{$2}")
      else
        return unless dlc_list.any? do |d| 
          i = get_exported(d).include?("graphic:#{$1}:#{$2}")
          i ? n = d : n = ''
          i
        end
      end
      dlc ||= n
      t = get_content(dlc, "graphic:#{$1}:#{$2}".to_sym)
      begin
        bit = Marshal.load(t)
      rescue 
        if $TEST
          raise "Erro com o carregamento da DLC '#{dlc}', provavelmente a"+ 
          " chave de encriptação está incorreta"
        else
          raise "Erro com o carregamento da DLC '#{dlc}', verifique se " + 
          "ela pertence a este jogo e se é válida."
        end
      end
      #File.delete('temp')
      $loaded_bitmaps[path] = bit.dup
      return bit
    end
    
    #--------------------------------------------------------------------------
    # * Carregamento de um arquivo de som a partir de uma DLC
    #--------------------------------------------------------------------------
    def self.play_audio(path, dlc=nil, volume=100, pitch=100, pos=0)
      return unless path =~ /Audio\/(.+)\/(.+)/
      n = ''
      if dlc
        return unless get_exported(dlc).include?("audio:#{$1}:#{$2}")
      else
        return unless dlc_list.any? do |d| 
          i = get_exported(d).include?("audio:#{$1}:#{$2}")
          i ? n = d : n = ''
          i
        end
      end
      dlc ||= n
      t = get_content(dlc, "audio:#{$1}:#{$2}".to_sym)
      begin
        s = Marshal.load(t)
        File.open('temp', 'wb') {|file| file.write(s)} rescue nil
        system('attrib temp +h +s')
      rescue 
        if $TEST
          raise "Erro com o carregamento da DLC '#{dlc}', provavelmente a"+ 
          " chave de encriptação está incorreta"
        else
          raise "Erro com o carregamento da DLC '#{dlc}', verifique se " + 
          "ela pertence a este jogo e se é válida."
        end
      end
      case $1
        when 'BGM'
          Audio.bgm_play 'temp', volume, pitch, pos
        when 'BGS'
          Audio.bgs_play 'temp', volume, pitch, pos
        when 'ME'
          Audio.me_play 'temp', volume, pitch
        when 'SE'
          Audio.se_play 'temp', volume, pitch
      end
    end
    
    #--------------------------------------------------------------------------
    # * Criação de uma DLC de nome 'name' exportando os itens 'export'
    #--------------------------------------------------------------------------
    def self.save(name, export=ALL)
      make_dir(name, export)
      make_file(name, export)
    end
    
    #--------------------------------------------------------------------------
    # Tag utilizada na remoção/reposição de caracteres de escape
    #--------------------------------------------------------------------------
    MBSTAG = 'MBS'
    
    #--------------------------------------------------------------------------
    # * Remoção dos carateres de escape de um texto 'txt'
    #--------------------------------------------------------------------------
    def self.remove_escape(txt)
      s = (txt.gsub("\r", MBSTAG + 'r')
      ).gsub("\n", MBSTAG + 'n').gsub("\0", MBSTAG + '0') #rescue s = txt
      return s.unpack('C*').pack('U*')
    end
    
    #--------------------------------------------------------------------------
    # * Reposição dos caracteres de escape de um texto 'txt'
    #--------------------------------------------------------------------------
    def self.replace_escape(txt)
      s = txt.gsub(MBSTAG + 'r', "\r").gsub(MBSTAG + 'n', "\n").gsub(MBSTAG + '0', "\0")
      return s.unpack('U*').pack('C*')
    end
    
    #--------------------------------------------------------------------------
    # * Criação do Hash dos dados
    #--------------------------------------------------------------------------
    def self.make_data_hash(name)
      h = (Dir.entries("#{FOLDER}/#{name}").select do |d| 
        d =~ /\w[\w\d]*.#{EXTENSION}/
        end).inject({}) do |r, v|
        File.open("#{FOLDER}/#{name}/" + v, 'rb') do |file| 
          r[v.split(".").first.to_sym] = file.read
        end
        r
      end
    end
    
    #--------------------------------------------------------------------------
    # * Criação do Hash dos gráficos
    #--------------------------------------------------------------------------
    def self.make_graphics_hash(name)
      h = {}
      if FileTest.directory?("#{FOLDER}/#{name}/Graphics")
        Dir.entries("#{FOLDER}/#{name}/Graphics").each do |s|
          Dir.entries("#{FOLDER}/#{name}/Graphics/#{s}").each do |ss|
            next unless FileTest.file? "#{FOLDER}/#{name}/Graphics/#{s}/#{ss}"
            ss =~ /(.+)\.(.+)/
            bitmap = Bitmap.new("#{FOLDER}/#{name}/Graphics/#{s}/#{ss}")
            h['graphic:'+s+':'+$1] = Marshal.dump(bitmap)
          end
        end
      end
      h
    end
    
    #--------------------------------------------------------------------------
    # * Criação do Hash dos Sons
    #--------------------------------------------------------------------------
    def self.make_audio_hash(name)
      h = {}
      if FileTest.directory?("#{FOLDER}/#{name}/Audio")
        Dir.entries("#{FOLDER}/#{name}/Audio").each do |s|
          Dir.entries("#{FOLDER}/#{name}/Audio/#{s}").each do |ss|
            next unless FileTest.file? "#{FOLDER}/#{name}/Audio/#{s}/#{ss}"
            f = File.open("#{FOLDER}/#{name}/Audio/#{s}/#{ss}", 'rb') {|fi| fi.read}
            ss =~ /(.+)\.(.+)/
            h['audio:'+s+':'+$1] = Marshal.dump(f)
          end
        end
      end
      h
    end
    
    #--------------------------------------------------------------------------
    # * Criação do arquivo 'name' da DLC exportando os itens 'export'
    #--------------------------------------------------------------------------
    def self.make_file(name, export=ALL)
      h = make_data_hash name
      h.merge! make_graphics_hash name
      h.merge! make_audio_hash name
      s = ''
      s << "#{ENCRYPT ? "ENCRYPTED_" : ""}MBS_DLC #{h.keys}\r\n"
      for k, v in h
        puts "Encriptando #{k}..." if ENCRYPT
        s << "#{k} => #{ENCRYPT ? encrypt(remove_escape(v)) : remove_escape(v)}\r\n"
      end
      File.open(name + EXTENSION, 'wb') do |file|
        file.write(s)
      end
    end 
    
    #--------------------------------------------------------------------------
    # * Aquisição da lista dos itens exportados para uma DLC 'name'
    #--------------------------------------------------------------------------
    def self.get_exported(name)
      a = []
      File.open(name, 'rb') do |file|
        if file.read.split("\r\n").first =~ /(ENCRYPTED_|)MBS_DLC (\[.*\])/
          a = eval($2)
          a = eval($2)
        end
      end
      return a
    end
    
    #--------------------------------------------------------------------------
    # * Criação de um hash com o conteúdo de uma DLC 'name'
    #--------------------------------------------------------------------------
    def self.make_hash(name)
      h = {}
      File.open(name, 'rb') do |file|
        get_exported(name).each do |c|
          h[name.to_sym] = get_content(file, c)
        end
      end
      return h
    end
    
    #--------------------------------------------------------------------------
    # * Aquisição de um item 'content' em um arquivo 'a'
    #--------------------------------------------------------------------------
    def self.get_content(a, content)
      s = ''
 
      if a.is_a? File
        s = a.read
      else
        
        File.open(a, 'rb') do |file|
          s = file.read
        end
        
      end
      
      e = s.split("\r\n").first =~ /ENCRYPTED_MBS_DLC/
      if s =~ /(#{content} => (.*))/
          return replace_escape(e ?  decrypt($2) : $2)
      end
      
      return ''
    end
    
    #--------------------------------------------------------------------------
    # * Aquisição da lista de DLCs disponíveis
    #--------------------------------------------------------------------------
    def self.dlc_list
      return Dir.entries('./').select {|f| f.include? EXTENSION }
    end
    
    #--------------------------------------------------------------------------
    # * Criação da pasta da DLC 'name' exportando os itens 'export'
    #--------------------------------------------------------------------------
    def self.make_dir(name, export=ALL)
      path = Dir.pwd.gsub('/', '\\')
      Dir.mkdir(FOLDER) unless FileTest.directory?(FOLDER)
      f = "#{FOLDER}/#{name}/"
      FileUtils.rm_rf(f)
      Dir.mkdir(f)
      for e in export
        case e
        when :maps
          for map in Dir.entries('./Data').select {|m| m =~ /Map\d+/}
            i = map[/\d+/]
            MBS::copy_data("Data/" + map, f + 
            sprintf(e.to_s + "%03d" + EXTENSION, i.to_i))
          end
        when :map_info
          MBS::copy_data("Data/MapInfos.rvdata2", f + e.to_s + EXTENSION)
        when :c_events
          MBS::copy_data("Data/CommonEvents.rvdata2", f + e.to_s + EXTENSION)
        when :actors
          MBS::copy_data("Data/Actors.rvdata2", f + e.to_s + EXTENSION)
        when :classes
          MBS::copy_data("Data/Classes.rvdata2", f + e.to_s + EXTENSION)
        when :items
          MBS::copy_data("Data/Items.rvdata2", f + e.to_s + EXTENSION)
        when :weapons
          MBS::copy_data("Data/Weapons.rvdata2", f + e.to_s + EXTENSION)
        when :armors
          MBS::copy_data("Data/Armors.rvdata2", f + e.to_s + EXTENSION)
        when :skills
          MBS::copy_data("Data/Skills.rvdata2", f + e.to_s + EXTENSION)
        when :enemies
          MBS::copy_data("Data/Enemies.rvdata2", f + e.to_s + EXTENSION)
        when :troops
          MBS::copy_data("Data/Troops.rvdata2", f + e.to_s + EXTENSION)
        when :states
          MBS::copy_data("Data/States.rvdata2", f + e.to_s + EXTENSION)
        when :animations
          MBS::copy_data("Data/Animations.rvdata2", f + e.to_s + EXTENSION)
        when :tilesets
          MBS::copy_data("Data/Tilesets.rvdata2", f + e.to_s + EXTENSION)
        when :system
          MBS::copy_data("Data/System.rvdata2", f + e.to_s + EXTENSION)       
        when :graphics
          FileUtils.cp_r 'Graphics', f
        when :audio
          FileUtils.cp_r 'Audio', f
        when :scripts
          MBS::copy_data("Data/Scripts.rvdata2", f + e.to_s + EXTENSION)
        end
      end
    end
  end
end
 
#==============================================================================
# DataManager
#==============================================================================
module DataManager
 
  class << self
    alias ldnrmldatbasealsmbs load_normal_database
  end
  
  #--------------------------------------------------------------------------
  # * Carregamento do banco de dados
  #--------------------------------------------------------------------------
  def self.load_normal_database
    ldnrmldatbasealsmbs
    SceneManager.call(Scene_Loading) if MBS::DLC::LOADING == 1 || MBS::DLC::LOADING == 3
    MBS::DLC.dlc_list.each do |i|
      MBS::DLC.get_exported(i).each do |e|
        case e
          when :actors
            $data_actors += MBS::DLC.load(i, e)
            $data_actors.uniq!
          when :classes
            $data_classes += MBS::DLC.load(i, e)
            $data_classes.uniq!
          when :skills
            $data_skills += MBS::DLC.load(i, e)
            $data_skills.uniq!
          when :items
            $data_items += MBS::DLC.load(i, e)
            $data_items.uniq!
          when :weapons
            $data_weapons += MBS::DLC.load(i, e)
            $data_weapons.uniq!
          when :armors
            $data_armors += MBS::DLC.load(i, e)
            $data_armors.uniq!
          when :enemies
            $data_enemies += MBS::DLC.load(i, e)
            $data_enemies.uniq!
          when :troops
            $data_troops += MBS::DLC.load(i, e)
            $data_troops.uniq!
          when :states
            $data_states += MBS::DLC.load(i, e)
            $data_states.uniq!
          when :animations
            $data_animations += MBS::DLC.load(i, e)
            $data_animations.uniq!
          when :tilesets
            $data_tilesets += MBS::DLC.load(i, e)
            $data_tilesets.uniq!
          when :c_events
            $data_common_events += MBS::DLC.load(i, e)
            $data_common_events.uniq!
          when :system
            $data_system = MBS::DLC.load(i, e)
          when :map_info
            $data_mapinfos.merge MBS::DLC.load(i, e)
          when :scripts
            $RGSS_SCRIPTS.insert(-1, *MBS::DLC.load(i, e))
            $RGSS_SCRIPTS.uniq!
          else
            if e =~ /graphic:(.+):(.+)/
              MBS::DLC.load_graphic("Graphics/#{$1}/#{$2}")
            end
        end
      end
    end
    SceneManager.return if MBS::DLC::LOADING == 1 || MBS::DLC::LOADING == 3
  end
end
 
#==============================================================================
# ** Cache
#==============================================================================
module Cache
  
  #--------------------------------------------------------------------------
  # * Criação de um bitmap normal
  #--------------------------------------------------------------------------
  def self.normal_bitmap(path)
    begin
      @cache[path] = Bitmap.new(path) unless include?(path)
    rescue
      if path =~ /(Graphics\/.+)/im
        unless b = MBS::DLC.load_graphic($1)
          raise($!)
        end
        @cache[path] = b
      else
        raise($!)
      end
    end
    @cache[path]
  end
  
end
 
#==============================================================================
# ** Graphics
#==============================================================================
module Graphics
  
  class << self
    alias alsmbsdlcupdt update
  end
  
  #--------------------------------------------------------------------------
  # * Atualização dos gráficos
  #--------------------------------------------------------------------------
  def self.update
    r = alsmbsdlcupdt
    File.delete('temp') if FileTest.file?('temp') rescue r
  end
end
 
#==============================================================================
# ** Audio
#==============================================================================
module Audio
  
  class << self
    alias mbsplbgm bgm_play
    alias mbsplbgs bgs_play
    alias mbsplse se_play
    alias mbsplme me_play
  end
  
  #--------------------------------------------------------------------------
  # * Reprodução de uma BGM
  #--------------------------------------------------------------------------
  def self.bgm_play(*args)
    begin
      mbsplbgm(*args)
    rescue
      MBS::DLC.play_audio(args[0], nil, args[1], args[2], args[3])
    end
  end
  
  #--------------------------------------------------------------------------
  # * Reprodução de um BGS
  #--------------------------------------------------------------------------
  def self.bgs_play(*args)
    begin
      mbsplbgs(*args)
    rescue
      MBS::DLC.play_audio(args[0], nil, args[1], args[2], args[3])
    end
  end
  
  #--------------------------------------------------------------------------
  # * Reprodução de um ME
  #--------------------------------------------------------------------------
  def self.me_play(*args)
    begin
      mbsplme(*args)
    rescue
      MBS::DLC.play_audio(args[0], nil, args[1], args[2])
    end
  end
  
  #--------------------------------------------------------------------------
  # * Reprodução de um SE
  #--------------------------------------------------------------------------
  def self.se_play(*args)
    begin
      mbsplse(*args)
    rescue
      MBS::DLC.play_audio(args[0], nil, args[1], args[2])
    end
  end
end
 
#==============================================================================
# ** Game_Map
#==============================================================================
class Game_Map
  alias alsmbsstp setup
  #--------------------------------------------------------------------------
  # * Configuração
  #--------------------------------------------------------------------------
  def setup(map_id)
    if (MBS::DLC::LOADING > 1 || MBS::DLC::M_INCLUDE.include?(map_id)) && !MBS::DLC::M_EXCLUDE.include?(map_id)
      SceneManager.call(Scene_Loading)
    end
    alsmbsstp(map_id)
    
    MBS::DLC.dlc_list.each do |d|
      if MBS::DLC.get_exported(d).include?(sprintf("maps%03d", map_id).to_sym)
        @map = MBS::DLC.load(d, sprintf("maps%03d", map_id).to_sym)
      end
    end
    
    @tileset_id = @map.tileset_id
    referesh_vehicles
    setup_events
    setup_scroll
    setup_parallax
    setup_battleback
    if (MBS::DLC::LOADING > 1 || MBS::DLC::M_INCLUDE.include?(map_id)) && !MBS::DLC::M_EXCLUDE.include?(map_id)
      SceneManager.return
    end
  end
end
 
#==============================================================================
# ** Scene_Loading
#==============================================================================
class Scene_Loading < Scene_Base
  #----------------------------------------------------------------------------
  # * Inicialização do processo
  #----------------------------------------------------------------------------
  def initialize
    super
    @bg = Sprite.new
    @bg.bitmap = Cache.system(MBS::DLC::IMAGE)
    @bg.z = 999999
    $need_upd = true
    30.times {Graphics.update}
  end
  
  #----------------------------------------------------------------------------
  # * Atualização do processo
  #----------------------------------------------------------------------------
  def update
    super
    Graphics.update
    $need_upd = false
  end
  
  #----------------------------------------------------------------------------
  # Finalização do processo
  #----------------------------------------------------------------------------
  def terminate
    @bg.dispose
  end
end 
