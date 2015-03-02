#==============================================================================
# MS - Crypt
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
($imported ||= {})[:mbs_crypt] = true
#==============================================================================
# >> MBS
#------------------------------------------------------------------------------
# Este é o módulo básico dos scripts MS/MBS
#==============================================================================
module MBS
  #============================================================================
  # >> Crypt
  #----------------------------------------------------------------------------
  # Este módulo contém as funções necessárias para encriptar texto, arquivos
  # e pastas
  #============================================================================
  module Crypt
    #--------------------------------------------------------------------------
    # Win32API
    #--------------------------------------------------------------------------
    Encrypt = Win32API.new('MBS', 'Encrypt', 'PLLP', 'V')
    Decrypt = Win32API.new('MBS', 'Decrypt', 'PLLP', 'V')
      
    #--------------------------------------------------------------------------
    # [Privado] Geração de um número (teoricamente) único para a chave
    #     key : A chave de encriptação
    #--------------------------------------------------------------------------
    def self.gen_key(key)
      return key if key.is_a?(Fixnum)
      i = key.unpack('C').first
      key[1..-1].each_char do |c|
        i = (i << 1) ^ c.unpack('C').first
      end
      i
    end
    private_class_method :gen_key
    
    #--------------------------------------------------------------------------
    # * Encriptação de texto [String]
    #     text : O texto a ser encriptado
    #     key  : A chave de encriptação
    #--------------------------------------------------------------------------
    def self.encrypt(text, key)
      text = text.unpack('U*').pack('C*') if text.encoding == 'UTF-8'
      buffer = ' ' * text.size
      begin
        Encrypt.call(text, gen_key(key), text.size / 4 + 1, buffer)
      rescue
        raise "[MBS] Um erro ocorreu na encriptação, tenha certeza que a sua chave não é grande demais"
      end
      buffer
    end
    
    #--------------------------------------------------------------------------
    # * Desencriptação de texto [String]
    #     text : O texto a ser encriptado
    #     key  : A chave de encriptação
    #--------------------------------------------------------------------------
    def self.decrypt(text, key)
      buffer = ' ' * text.size
      begin
        Decrypt.call(text, gen_key(key), text.size / 4 + 1, buffer)
      rescue
        raise "[MBS] Um erro ocorreu na desencriptação, tenha certeza que a sua chave não é grande demais"
      end
      buffer
    end
    
    #--------------------------------------------------------------------------
    # * Encriptação de um arquivo [NilClass]
    #     filename : O nome do arquivo a ser encriptado
    #     key      : A chave de encriptação
    #     dest     : O arquivo onde serão salvos os dados encriptados, caso não
    #                seja definido, será igual ao nome do arquivo original
    #--------------------------------------------------------------------------
    def self.encrypt_file(filename, key, dest=nil)
      content = File.open(filename, 'rb') {|file| file.read}
      dest ||= filename
      File.open(dest, 'wb') do |file| 
        file.write(encrypt(Zlib::Deflate.deflate(content), key))
      end
      nil
    end
    
    #--------------------------------------------------------------------------
    # * Desencriptação de um arquivo [NilClass]
    #     filename : O nome do arquivo com os dados encriptados
    #     key      : A chave de encriptação
    #     dest     : O arquivo para onde vão os dados desencriptados, caso não
    #                seja definido, será igual ao nome do arquivo original
    #--------------------------------------------------------------------------
    def self.decrypt_file(filename, key, dest=nil)
      content = decrypt(File.open(filename, 'rb') {|file| file.read}, key)
      dest ||= filename
      File.open(dest, 'wb') do |file| 
        file.write(Zlib::Inflate.inflate(content))
      end
      nil
    end
    
    #--------------------------------------------------------------------------
    # [Privado] Aquisição da lista de arquivos em uma pasta e suas subpastas
    #     foldername : O nome da pasta que será verificada
    #--------------------------------------------------------------------------
    def self.get_entries(foldername)
      return Dir.entries(foldername).delete_if do |e|
        e == '.' ||  e == '..'
      end.inject([]) do |r, v|
        if FileTest.file?(foldername + '/' + v) 
          r << v 
          return r
        elsif FileTest.directory?(foldername + '/' + v)
          return r + get_entries(foldername + '/' + v).collect {|f| v + '/' + f}
        end
        r
      end
    end
    
    private_class_method :get_entries
    
    #--------------------------------------------------------------------------
    # * Encriptação de uma pasta [NilClass]
    #     foldername : O nome da pasta que será encriptada
    #     key        : A chave de encriptação
    #     dest       : O arquivo para onde vão os dados encriptados, caso não 
    #                  seja definido, será igual ao nome da pasta
    #--------------------------------------------------------------------------
    def self.encrypt_folder(foldername, key, dest=nil)
      files = get_entries(foldername)
      hash = {}
      files.each do |f| 
        File.open(foldername + '/' + f, 'rb') do |file|
          hash[f] = Zlib::Deflate.deflate(encrypt(file.read, key))
        end
      end
      dest ||= foldername
      File.open(dest, 'wb') do |file|
        file.write(Zlib::Deflate.deflate(Marshal.dump(hash)))
      end
      nil
    end
    
    #--------------------------------------------------------------------------
    # * Desencriptação de uma pasta [NilClass]
    #     filename : O nome do arquivo com os dados encriptados
    #     key      : A chave de encriptação
    #     dest     : O nome da pasta para onde vão os dados desencriptados, 
    #                caso não seja definido, será igual ao nome do arquivo
    #--------------------------------------------------------------------------
    def self.decrypt_folder(filename, key, dest=nil)
      hash = {}
      File.open(filename, 'rb') do |file|
        hash = Marshal.load(Zlib::Inflate.inflate(file.read))
      end
      dest ||= filename
      cr = dest + '/'
      Dir.mkdir(dest) unless FileTest.directory?(dest)
      hash.each do |filename, content|
        path = filename.split('/')
        path[0...-1].each do |e|
          Dir.mkdir(cr + e) unless FileTest.directory?(cr + e)
          cr << "#{e}/"
        end
        File.open(dest + '/' + filename, 'wb') do |file|
          file.write(decrypt(Zlib::Inflate.inflate(content), key))
        end
      end
      nil
    end
  end
end
