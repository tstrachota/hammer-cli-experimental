require 'hammer_cli/abstract'

module HammerCLIExperimental
  class ConfigCommand < HammerCLI::AbstractCommand

    option '--paths', :flag, _("Show only used paths")
    option '--show', :flag, _("List final configuration")
    option '--show-by-path', :flag, _("List configurations from each of used files")

    def validate_options
      validator.one_of(:option_paths, :option_show, :option_show_by_path).required
    end

    def execute
      if option_paths?
        puts settings.path_history
      elsif option_show?
        puts settings.settings.to_yaml
      elsif option_show_by_path?
        settings.path_history.each do |cfg_file|
          puts cfg_file
          puts YAML::load(File.open(cfg_file)).to_yaml
          puts
        end
      end
      HammerCLI::EX_OK
    end

    protected
    def settings
      HammerCLI::Settings
    end
  end

  HammerCLI::MainCommand.subcommand "config", _("Print current hammer config"), HammerCLIExperimental::ConfigCommand
end
