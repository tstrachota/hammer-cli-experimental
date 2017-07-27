require 'hammer_cli/abstract'

module HammerCLIExperimental
  module DebugParameters
    def request_params
      require 'pry'; binding.pry
      super
    end
  end

  module DebugTransformFormat
    def transform_format(d)
      require 'pry'; binding.pry
      super
    end
  end

  module DebugHandleException
    module HandlerExtension
      def handle_exception(*args)
        require 'pry'; binding.pry
        super
      end
    end

    def handle_exception(e)
      exception_handler.send(:extend, HandlerExtension)
      super
    end
  end

  module CommandDebugging
    def self.prepended(base)
      base.option "--debug", 'BREAKPOINT', _("Start pry at a given breakpoint"),
        :format => HammerCLI::Options::Normalizers::Enum.new(['execute', 'params', 'transform_result', 'handle_exception'])
    end

    def run(arguments)
      begin
        begin
          exit_code = super_run(arguments)
          raise "exit code must be integer" unless exit_code.is_a? Integer
        rescue => e
          exit_code = handle_exception(e)
        end
        logger.debug 'Retrying the command' if (exit_code == HammerCLI::EX_RETRY)
      end while (exit_code == HammerCLI::EX_RETRY)
      return exit_code
    end

    def super_run(arguments)
      parse(arguments)
      extend DebugParameters if option_debug == 'params' && self.is_a?(HammerCLI::Apipie::Command)
      extend DebugTransformFormat if option_debug == 'transform_result' && self.is_a?(HammerCLIForeman::Command)
      extend DebugHandleException if option_debug == 'handle_exception'
      require 'pry'; binding.pry if option_debug == 'execute'
      execute
    end
  end
end

HammerCLI::AbstractCommand.prepend(HammerCLIExperimental::CommandDebugging)
