#==============================================================================
# MS - Language System
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# Características
#------------------------------------------------------------------------------
# O script cria um sistema de linguagens onde você pode criar arquivos contendo
# textos em diferentes línguas.
#==============================================================================
#==============================================================================
# Criando um script de linguagem
#------------------------------------------------------------------------------
# Os scripts de linguagem são feitos em uma linguagem própria que é bem 
# simples, para criar uma 'tag' (uma variável contendo texto), usa-se o 
# seguinte código:
# 
# begin 'tag'
# =Texto que você quiser aqui,
# + continua na primeira linha
# =Segunda linha do texto
# =...
# end 'tag'
#
# O texto só será adicionado à tag se o símbolo '=' estiver no começo da linha,
# para se adicionar um comentário, coloque * no começo da linha.
#
# Exemplo para a tag 'apple':
#
# * arquivo: pt-br.txt
# begin 'apple'
# =Maçã é bom
# + e eu gosto
# end 'apple'
#
# * arquivo: en-us.txt
# begin 'apple'
# =Apple is good
# + and I like it
# end 'apple'
#
# * arquivo: gr.txt (Google Tradutor =P)
# begin 'apple'
# =Apple ist gut und
# + Ich mag
# end 'apple'
#
# Para que o script funcione, você deve salvar o arquivo com o LANG Script na
# codificação UTF-8
#==============================================================================
#==============================================================================
# Convertendo scripts de linguagem para arquivos de linguagem
#------------------------------------------------------------------------------
# Depois de ter feito os scripts de linguagem e salvo eles em arquivos de
# texto em uma pasta, você precisa convertê-los em arquivos de linguagem,
# que podem ser encriptados.
#
# Para isso, use o seguinte comando:
# Language.compile('pasta')
# Ou, caso queira que os arquivos sejam encriptados;:
# Language.compile('pasta', true)
#
# Com isso, serão criados arquivos '.lang' na pasta escolhida nas configurações
#
# Ex.:
# Languagem.compile('lang') #=> lang/pt-br.txt -> Language/pt-br.lang
#                           #=> lang/en-us.txt -> Language/en-us.lang
#                           #=> lang/gr.txt    -> Language/gr.lang
#
# Obs.: Na compilação, é recomendável ativar a janela de depuração
#==============================================================================
#==============================================================================
# Carregando as tags pelo RPG Maker
#------------------------------------------------------------------------------
# Para carregar uma tag, basta chamar em um script:
# Language.load('tag', 'lingua')
#
# Ex.:
# Language.load('apple', 'pt-br') #=> Maçã é bom e eu gosto
# Language.load('apple', 'en-us') #=> Apple is good and I like it
# Language.load('apple', 'gr')    #=> Apple ist gut und Ich mag
#
# Além disso, esse script já vem com uma modificação na janela de mensagens,
# então além dos caracteres de controle padrão (\C, \G, \N, ...) você pode usar
# o \L[tag].
# 
# Ex.:
# \L[apple], porque sim
# 
# Resultado:
# Maçã é bom e eu gosto, porque sim
#==============================================================================
#==============================================================================
# Definindo a linguagem a ser usada
#------------------------------------------------------------------------------
# Para escolher a linguagem a ser usada no jogo, você pode:
#   1. Adicionar um item 'Language=...' no Game.ini 
#
#   Ex.: 
#     [Game]
#     RTP=RPGVXAce
#     Library=System\RGSS300.dll
#     Scripts=Data\Scripts.rvdata2
#     Title=Project1
#     Language=pt-br
#
#   2. Mudando diretamente a variável $LANGUAGE através de scripts
#
#   Ex.:
#   $LANGUAGE = 'pt-br'
#==============================================================================
#==============================================================================
# Configurações
#==============================================================================
module Language
  
  # Pasta onde ficarão os arquivos de linguagem
  FOLDER    = 'Language'
  
  # Extensão dos arquivos de linguagem
  EXTENSION = 'lang'
  
  # Linguagem usada por padrão
  DEFAULT = 'pt-br'
  
  # Chave usada para encriptação
  CRYPT = 'maçã'
  
#==============================================================================
# Fim das configurações
#==============================================================================
end
#==============================================================================
# ** Language
#==============================================================================
module Language
  extend self
 
  # Versão
  MAJOR = 0x01
  MINOR = 0x00
  
  # Caracteres de marcação
  TAG_BEGIN = [140].pack('C')
  TAG_NAME  = [150].pack('C')
  TAG_TEXT  = [160].pack('C')
=begin
  #----------------------------------------------------------------------------
  # * Encriptação de texto
  #----------------------------------------------------------------------------
  def encrypt(txt)
    i = -1
    m = 0
    txt = txt.dup.force_encoding('ASCII-8BIT')
    n = txt.unpack('U*').collect do |v|
      i += 1
      i %= CRYPT.size
      s = (v * CRYPT[i].unpack('U').first).to_i
      m = s.to_s.size if s.to_s.size > m
      s
    end
    e = n.inject('') {|r, v| r + sprintf("%0#{m}d", v)}
    [m].pack('U') + e.scan(/.{#{m}}/).collect {|s| s.to_i}.pack('U*')
  end
  
  #----------------------------------------------------------------------------
  # * Desencriptação de texto
  #----------------------------------------------------------------------------
  def decrypt(txt)
    txt = txt.dup.force_encoding('ASCII-8BIT')
    m = txt.unpack('U').first
    txt = txt[1..-1]
    d = txt.unpack('U*').inject('') do |r, v|
      r + sprintf("%0#{m}d", v)
    end[0...-m]
    p d
    t = ''
    i = -1
    d.scan(/.{#{m}}/).collect {|s| s.to_i}.each do |s|
      i += 1
      i %= CRYPT.size
      t += [s.to_i / CRYPT[i].unpack('U').first].pack('U')
    end
    t
  end
  
=end
  #--------------------------------------------------------------------------
  # * Encripta o texto 'txt'
  #--------------------------------------------------------------------------
  def encrypt(txt)
    x = -1
    return txt.unpack("U*").collect do |i| 
      x += 1
      x %= CRYPT.size
      i + CRYPT[x].unpack('U').first
    end.pack('U*').unpack('S*').pack('U*')
  end
 
  #--------------------------------------------------------------------------
  # * Desencripta o texto 'txt'
  #--------------------------------------------------------------------------
  def decrypt(txt)
    x = -1
    return txt.unpack('U*').pack('S*').unpack("U*").collect do |i| 
      x += 1
      x %= CRYPT.size
      i - CRYPT[x].unpack('U').first > 0 ? i - CRYPT[x].unpack('U').first : i
    end.pack('U*')
  end
 
  #----------------------------------------------------------------------------
  # * Aquisição de um hash com as tags do script 'txt'
  #----------------------------------------------------------------------------
  def make_tags(file)
    tags = {}
    tag = nil
    txt = File.open(file, 'rb') {|f| f.read}
    f = file
    err = false
    text = ''
    text.force_encoding('UTF-8')
    a = txt[3..-1].split(/[\r\n]+/)
    a.each_with_index do |line, i|
      if line[/\s*begin[ ]+'(.+)'\s*/] == line
 
        unless tag
          tag = $1
        else
          puts("LANG Script (file #{f}, line #{i}): Can not open a new tag '#{$1}' before closing tag '#{tag}'")
          err = true
        end
 
      elsif line[/\s*end[ ]+'(.+)'\s*/] == line
 
        if tag
          tags[tag] = text
          tag = nil
          text = ''
        else
          puts("LANG Script (file #{f}, line #{i}): Could not close tag because there were no tag to be closed ")
          err = true
        end
 
      elsif line[/\s*=(.+)/] == line
 
        if tag
          text += "#{text.empty? ? '' : "\r\n"}#{$1}".force_encoding('UTF-8')
        else
          puts("LANG Script (file #{f}, line #{i}): No tag available to add text")
        end
 
      elsif line[/\s*\+(.+)/] == line
 
        if tag
          text += $1.force_encoding('UTF-8')
        else
          puts("LANG Script (file #{f}, line #{i}): No tag available to add text")
          err = true
        end
 
      elsif line =~ /\S/ && line[/\s*\*(.*)/] != line
        puts("LANG Script (file #{f}, line #{i}): Syntax error")
        err = true
      end
    end
    return err ? [:ERROR, a.size] : tags
  end
  
  #----------------------------------------------------------------------------
  # * Carregamento de uma string de um arquivo de linguagem
  #----------------------------------------------------------------------------
  def load(tag, lang)
    txt   = File.open(FOLDER + '/' + lang + '.' + EXTENSION, 'rb') {|f| f.read}
    major = txt[0].unpack('U').first
    minor = txt[1].unpack('U').first
    
    if major > MAJOR || (major >= MAJOR && minor > MINOR)
      puts "Failed to load tag '#{tag}' from file #{FOLDER}/#{lang}.#{EXTENSION}: LANG Script version not compatible"
      return ''
    end
    
    enc   = txt[2].unpack('U').first > 0
    txt   = txt[3..-1]
    
    txt.split("\n").each do |t|
      unless t[0] == TAG_BEGIN
        puts "Failed to load tag '#{tag}' from file #{FOLDER}/#{lang}.#{EXTENSION}: Invalid language file"
        return ''
      end
      unless t[1] == TAG_NAME
        puts "Failed to load tag '#{tag}' from file #{FOLDER}/#{lang}.#{EXTENSION}: Invalid language file"
        return ''
      end
      i = t.index(TAG_TEXT)
      unless i
        puts "Failed to load tag '#{tag}' from file #{FOLDER}/#{lang}.#{EXTENSION}: Invalid language file"
        return ''
      end
      name = enc ? decrypt(t[2...i]) : t[2...i].force_encoding('UTF-8')
      next unless name == tag
      text = enc ? decrypt(t[(i+1)...t.size]) : t[(i+1)...t.size].force_encoding('UTF-8')
      begin
        return text.gsub('&line', "\n")
      rescue
        puts "Failed to load tag '#{tag}' from file #{FOLDER}/#{lang}.#{EXTENSION}: Invalid language file"
        return ''
      end
    end
    puts "Failed to load tag '#{tag}' from file #{FOLDER}/#{lang}.#{EXTENSION}: Could not find tag"
    return ''
  end
  
  #----------------------------------------------------------------------------
  # * Compilação dos scripts de linguagem na pasta 'folder'
  #----------------------------------------------------------------------------
  def compile(folder, enc=false)
    Dir.entries(folder).select {|e| FileTest.file?(folder + '/' + e)}.each do |f|
      puts
      puts "LANG Script #{MAJOR}.#{MINOR}: #{folder}/#{f} -> #{FOLDER}/#{f.split('.').first}.#{EXTENSION}"
      puts '-' * 79
      if (tags = make_tags(folder + '/' + f))[0] == :ERROR
        puts '-' * 79
        puts "Failed compiling #{folder}/#{f}"
        return
      end
      Dir.mkdir FOLDER unless FileTest.directory? FOLDER
      File.open("#{FOLDER}/#{f.split('.').first}.#{EXTENSION}", 'w+b') do |file|
        file.write([MAJOR, MINOR, enc ? 1 : 0].pack('UUU'))
        tags.each do |k, v|
          file.write(TAG_BEGIN + TAG_NAME)
          file.write(enc ? encrypt(k) : k)
          file.write(TAG_TEXT)
          file.write(enc ? encrypt(v).gsub("\n", '&line') : v.gsub("\n", '&line'))
          file.write("\n")
          puts ">> '#{k}'#{enc ? sprintf("%#{tags.keys.collect {|t| t.to_s.size}.max + 1 - k.to_s.size}s", '') + ': encrypted' : ''}"
        end
      end
      puts '-' * 79
      puts "Finished compiling #{folder}/#{f}"
    end
  end
end
 
#==============================================================================
# ** Window_Base
#==============================================================================
class Window_Base < Window
  
  alias cvtscpchrctslang convert_escape_characters
  
  #--------------------------------------------------------------------------
  # * Pré-conversão dos caracteres de controle
  #--------------------------------------------------------------------------  
  def convert_escape_characters(text)
    result = cvtscpchrctslang(text)
    result.gsub(/\eL\[(.+)\]/i) {Language.load($1, $LANGUAGE)}
  end
end
 
#==============================================================================
# Aquisição da linguagem a ser usada a partir do arquivo Game.ini
#==============================================================================
ini = File.read('Game.ini')
if ini
  if ini =~ /Language=(.+)/
    $LANGUAGE = $1
  end
end
$LANGUAGE ||= Language::DEFAULT 
