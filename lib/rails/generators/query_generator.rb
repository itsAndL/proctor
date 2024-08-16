# frozen_string_literal: true

require 'rails/generators'

module Rails
  module Generators
    class QueryGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      desc "Generates a query object in app/queries directory"

      def self.help(shell)
        shell.say "Usage:"
        shell.say "  rails generate query NAME"
        shell.say ""
        shell.say "Description:"
        shell.say "  This generator creates a new query object in the app/queries directory."
        shell.say "  It will create a file named NAME_query.rb with a basic query object structure."
        shell.say ""
        shell.say "Example:"
        shell.say "  rails generate query user"
        shell.say "    This will create: app/queries/user_query.rb"
      end

      def create_query_file
        template 'query.rb.tt', File.join('app/queries', class_path, "#{file_name}_query.rb")
      end
    end
  end
end
