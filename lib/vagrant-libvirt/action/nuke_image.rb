require 'log4r'

module VagrantPlugins
  module ProviderLibvirt
    module Action
      class NukeImage
        def initialize(app, env)
          @logger = Log4r::Logger.new('vagrant_libvirt::action::nuke_image')
          @app = app
        end

        def call(env)
env[:ui].info("NukeImage")
require 'pp'

          # Get config options
          config = env[:machine].provider_config
          env[:box_volume_name] = env[:machine].box.name.to_s.dup
          env[:box_volume_name] << '_vagrant_box_image.img'

          # Create new volume in storage pool
          message = "Nuking volume #{env[:box_volume_name]}"
          message << " in storage pool #{config.storage_pool_name}."
          @logger.info(message)
          begin
            fog_volume = env[:libvirt_compute].volumes.find { |v| v.name == env[:box_volume_name] }
            fog_volume.destroy unless fog_volume.nil?
          rescue Fog::Errors::Error => e
            raise Errors::FogCreateVolumeError,
              :error_message => e.message
          end

          @app.call(env)
        end
      end
    end
  end
end

