Some additions/extensions to CouchPotato, because awesome needs more awesome.

### Encrypted attributes

A simple way to encrypt specific attributes with a specific password and salt.
Each attribute can be encrypted differently, by specifying password and salt
when declaring them.

    require 'couch_potato'
    require 'couch_potato/extensions'
    
    class User
      include CouchPotato::Persistence
      include CouchPotato::Extensions::Encryption
      encrypted\_property :email, :password => "your mum", :salt => "your dad"
    end

Of course what's the point if you can't query that stuff? Fret not, help is near:

    class User
      view :by_email, :key => :email, :type => CouchPotato::Extensions::EncryptedViewSpec
    end
    
    CouchPotato.database.view(User.by_email(:key => "paul@example.com"))

Easy as pie!

Speaking of easy, so far it's both very simple, because that's what I need, only views
with one key are supported so far.

License: MIT baby!

Sponsored by [Peritor](http://peritor.com)