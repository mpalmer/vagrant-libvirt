require 'log4r'
require 'ostruct'
module VagrantPlugins
  module ProviderLibvirt
    module Action
      class MockMachine
        def initialize(app, env)
          @logger = Log4r::Logger.new('vagrant_libvirt::action::MockMachine')
          @app = app
        end

        def call(env)
          # This is a terrible, terrible thing to have to do, but we need
          # *something* that can trick connect_libvirt into doing what we
          # want.
          env[:machine] = OpenStruct.new
          env[:machine].provider_config = env[:global_config].vm.get_provider_config(:libvirt)
          env[:machine].box = env[:box_collection].find(env[:box_name], :libvirt)

			 @app.call(env)
        end
      end
    end
  end
end
