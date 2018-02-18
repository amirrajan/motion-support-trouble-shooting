# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
$:.unshift("~/.rubymotion/rubymotion-templates")

# ===========================================================================================
# 1. Be sure to read `readme.md`.
# ===========================================================================================

require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end
# encoding: utf-8

# Copyright (c) 2012, HipByte SPRL and contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

module Motion; module Project
  class Dependency
    begin
      require 'ripper'
    rescue LoadError => err
      App.warn("Please use newer Ruby instead of Ruby v1.8.x for build process.")
      raise err
    end

    @file_paths = []

    def initialize(paths, dependencies)
      @file_paths = paths.flatten.sort
      @dependencies = dependencies
    end

    def cyclic?(dependencies, def_path, ref_path)
      deps = dependencies[def_path]
      if deps
        if deps.include?(ref_path)
          App.warn("Possible cyclical dependency between #{def_path} and #{ref_path}'s class hierarchy. Consider revision if runtime exceptions occur around undefined symbols.")
          return true
        end
        deps.each do |file|
          return true if cyclic?(dependencies, file, ref_path)
        end
      end

      false
    end

    def run
      consts_defined  = {}
      consts_referred = {}
      @file_paths.each do |path|
        parser = Constant.new(File.read(path))
        parser.parse
        parser.defined.each do |const|
          consts_defined[const] = path
        end
        parser.referred.each do |const|
          puts "#{path} #{const}"
          consts_referred[const] ||= []
          consts_referred[const] << path
        end

        if parser.referred.length == 0
          puts "No constants found in the following file: #{path}."
        end
      end

      dependency = @dependencies.dup
      consts_defined.each do |const, def_path|
        if consts_referred[const]
          consts_referred[const].each do |ref_path|
            if def_path != ref_path
              if cyclic?(dependency, def_path, ref_path)
                # remove cyclic dependencies
                next
              end

              dependency[ref_path] ||= []
              dependency[ref_path] << def_path
              dependency[ref_path].uniq!
            end
          end
        end
      end

      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "#{dependency}"
      puts "\r\n\r\n"
      dependency.keys.each do |k|
        puts "#{k}", "#{dependency[k]}"
        puts "\r\n\r\n"
      end
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

      dependency
    end

    class Constant < Ripper::SexpBuilder
      attr_accessor :defined
      attr_accessor :referred

      def initialize(source)
        @defined  = []
        @referred = []
        super
      end

      def on_const_ref(args)
        args
      end

      def on_var_field(args)
        args
      end

      def on_var_ref(args)
        type, name, _position = args
        if type == :@const
          @referred << name
          return [:referred, name]
        end
      end

      def on_const_path_ref(parent, args)
        type, name, _position = args
        if type == :@const
          @referred << name
          if parent && parent[0] == :referred
            register_referred_constants(parent[1], name)
          end
        end
        args
      end

      def on_assign(const, *args)
        type, name, _position = const
        if type == :@const
          @defined << name
          return [:defined, name]
        end
      end

      def on_module(const, *args)
        handle_module_class_event(const, args)
      end

      def on_class(const, *args)
        handle_module_class_event(const, args)
      end

      def handle_module_class_event(const, *args)
        type, name, _position = const
        if type == :@const
          @defined << name
          @referred.delete(name)
          children = args.flatten
          children.each_with_index do |key, i|
            if key == :defined
              register_defined_constants(name, children[i+1])
            end
          end
          return [:defined, name]
        end
      end

      def register_defined_constants(parent, child)
        construct_nest_constants!(@defined, parent, child)
      end

      def register_referred_constants(parent, child)
        construct_nest_constants!(@referred, parent, child)
      end

      def construct_nest_constants!(consts, parent, child)
        nested = []
        consts.each do |const|
          if md = const.match(/^([^:]+)/)
            nested << "#{parent}::#{const}" if md[0] == child
          end
        end
        consts.concat(nested)
      end
    end
  end
end; end


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  define_icon_defaults!(app)

  app.detect_dependencies = true

  # ===========================================================================================
  # 2. Set your app name (this is what will show up under the icon when your app is installed).
  # ===========================================================================================
  app.name = 'motionsupportincludedb8'

  # version for your app
  app.version = '1.0'

  # ===========================================================================================
  # 3. Set your deployment target (it's recommended that you at least target 10.0 and above).
  #    If you're using RubyMotion Starter Edition. You cannot set this value (the latest
  #    version of iOS will be used).
  # ===========================================================================================
  # app.deployment_target = '10.0'

  # ===========================================================================================
  # 4. Your app identifier is needed to deploy to an actual device. You do not need to set this
  #    if you are using the simulator. You can create an app identifier at:
  #    https://developer.apple.com/account/ios/identifier/bundle. You must enroll into Apple's
  #    Developer program to get access to this screen (there is an annual fee of $99).
  # ===========================================================================================
  # app.identifier = ''

  # ===========================================================================================
  # 5. If you need to reference any additional iOS libraries, use the config array below.
  # ===========================================================================================
  # app.frameworks << "StoreKit"

  # resonable defaults
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:portrait]
  app.info_plist['UIRequiresFullScreen'] = true
  app.info_plist['ITSAppUsesNonExemptEncryption'] = false

  # ===========================================================================================
  # 6. To deploy to an actual device, you will need to create a developer certificate at:
  #    https://developer.apple.com/account/ios/certificate/development
  #    The name of the certificate will be accessible via Keychain Access. Set the value you
  #    see there below.
  # ===========================================================================================
  # app.codesign_certificate = ''

  # ===========================================================================================
  # 7. To deploy to an actual device, you will need to create a provisioning profile. First:
  #    register your device at:
  #    https://developer.apple.com/account/ios/device/
  #
  #    Then create a development provisioning profile at:
  #    https://developer.apple.com/account/ios/profile/limited
  #
  #    Download the profile and set the path to the download location below.
  # ===========================================================================================
  # app.provisioning_profile = ''

  # ===========================================================================================
  # 8. Similar to Step 7. Production, create a production certificate at:
  #    https://developer.apple.com/account/ios/certificate/distribution.
  #    These values will need to be set to before you can deploy to the App Store. Compile
  #    using `rake clean archive:distribution` and upload the .ipa under ./build using
  #    Application Loader.
  # ===========================================================================================
  # app.codesign_certificate = ''
  # app.provisioning_profile = ''

  # ===========================================================================================
  # 9. If you want to create a beta build. Uncomment the line below and set your profile to
  #    point to your production provisions (Step 8).
  # ===========================================================================================
  # app.entitlements['beta-reports-active'] = true
end

def define_icon_defaults!(app)
  # This is required as of iOS 11.0 (you must use asset catalogs to
  # define icons or your app will be regected. More information in
  # located in the readme.

  app.info_plist['CFBundleIcons'] = {
    'CFBundlePrimaryIcon' => {
      'CFBundleIconName' => 'AppIcon',
      'CFBundleIconFiles' => ['AppIcon60x60']
    }
  }

  app.info_plist['CFBundleIcons~ipad'] = {
    'CFBundlePrimaryIcon' => {
      'CFBundleIconName' => 'AppIcon',
      'CFBundleIconFiles' => ['AppIcon60x60', 'AppIcon76x76']
    }
  }
end
