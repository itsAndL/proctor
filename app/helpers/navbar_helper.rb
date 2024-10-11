module NavbarHelper
  include PagesHelper
  def navbar_item(path)
    classes = 'whitespace-nowrap inline-flex items-center border-b-4 px-1 pt-1 text-sm font-medium'
    if normalize_path(request.path) == normalize_path(path)
      "#{classes} border-blue-500 text-gray-900"
    else
      "#{classes} border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700"
    end
  end

  def dropdown_item(path)
    classes = 'block border-l-4 py-2 pl-3 pr-4 text-base font-medium'
    if normalize_path(request.path) == normalize_path(path)
      "#{classes} border-blue-600 bg-blue-50 text-blue-700"
    else
      "#{classes} border-transparent text-gray-500 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700"
    end
  end
end
