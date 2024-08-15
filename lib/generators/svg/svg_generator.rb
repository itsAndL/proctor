class SvgGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  desc "Generates an SVG file in the app/assets/images/icons directory"

  def self.help(shell)
    shell.say "Usage:"
    shell.say "  rails generate svg NAME"
    shell.say ""
    shell.say "Description:"
    shell.say "  This generator creates a new SVG file in the app/assets/images/icons directory."
    shell.say "  It generates a basic SVG structure with a 24x24 viewBox and 'size-6' class."
    shell.say ""
    shell.say "Example:"
    shell.say "  rails generate svg arrow"
    shell.say "    This will create: app/assets/images/icons/arrow.svg"
    shell.say ""
    shell.say "Note:"
    shell.say "  Remember to add your specific SVG content inside the generated file."
  end

  def create_svg_file
    create_file "app/assets/images/icons/#{file_name}.svg" do
      <<~SVG
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <!-- Add your SVG content here -->
        </svg>
      SVG
    end
  end
end
