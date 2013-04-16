# -*- encoding: UTF-8 -*-

require 'rubygems/command_manager'
require 'rubygems/install_update_options'
require 'rubygems/commands/changelog_command'

Gem::CommandManager.instance.register_command :changelog

module Gem::InstallUpdateOptions
  alias install_update_options_without_changelog add_install_update_options
  def add_install_update_options
    install_update_options_without_changelog

    add_option 'Install/Update', '--changelog[=LINES]', 'Show LINES lines the changelog of given gem, LINES defaults to 10' do |value, option|
      Gem.post_install do |installer|
        lines = (value && value =~ OptionParser::DecimalInteger) ? value.to_i : 10
        command = Gem::Commands::ChangelogCommand.new
        changelog_file = options[:changelog_name] || command.find_changelog_file(installer.spec)
        puts command.show_first_lines(File.join(installer.spec.gem_dir, changelog_file), lines)
      end
    end
  end
end
