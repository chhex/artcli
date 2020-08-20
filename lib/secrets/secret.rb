module Secrets
  require 'openssl'
  require 'tmpdir'
  class Store
    attr_reader :cache

    def initialize
      @cache = FileCache.new("credentials", "#{Dir.tmpdir}/artcli", 600, 1)
    end

    def save(user, password)
      @cache.set(user,encrypt(password))
    end

    def exist(user)
      c = @cache.get(user)
      c != nil
    end

    def retrieve(user)
      c = @cache.get(user)
      decrypt(c)
    end

    private def encrypt(pw)
      cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
      key = cipher.random_key
      cipher.key = key
      s = cipher.update(pw) + cipher.final
      Credentials.new(key ,s.unpack('H*')[0].upcase)
    end

    private def decrypt(user)
      cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
      cipher.key = user.key
      s = [user.pw].pack("H*").unpack("C*").pack("c*")
      cipher.update(s) + cipher.final
    end
  end

  class Credentials
    attr_reader :key, :pw
    def initialize(key,pw)
      @key = key
      @pw = pw
    end
  end
end