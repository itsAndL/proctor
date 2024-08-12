class SvgGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def self.desc
    "Generates an SVG file in the app/assets/images/icons directory"
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
