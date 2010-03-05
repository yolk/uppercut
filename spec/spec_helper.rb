require 'rubygems'
require 'spec'
require 'set'

$: << File.dirname(__FILE__)
$: << File.join(File.dirname(__FILE__), '../lib')

# Loads uppercut and jabber
require 'uppercut'

# Unloads jabber, replacing it with a stub
require 'jabber_stub'

class TestAgent < Uppercut::Agent
  command 'hi' do |c, args|
    c.instance_eval { @base.instance_eval { @called_hi = true } }
    c.send 'called hi'
  end
  
  command /^hi/ do |c, args|
    c.instance_eval { @base.instance_eval { @called_hi_regex = true } }
    c.send 'called high regex'
  end
  
  command 'hello' do |c|
    c.instance_eval { @base.instance_eval { @called_hello = true } }
    c.send 'called hello'
  end

  Uppercut::Agent::VALID_CALLBACKS.each do |cb|
    on(cb) do |c, presence|
      c.instance_eval { @base.instance_eval { @last_callback = cb.to_sym } }
    end
  end
end

class FrenchTestAgent < Uppercut::Agent
  command 'salut' do |c, args|
    c.instance_eval { @base.instance_eval { @called_salut = true } }
    c.send 'called salut'
  end
end

class TestNotifier < Uppercut::Notifier
  notifier :foo do |m, data|
    m.to = 'foo@bar.com'
    m.send 'Foo happened!'
  end
end
