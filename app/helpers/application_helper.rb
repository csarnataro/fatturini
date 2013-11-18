# coding: utf-8
module ApplicationHelper


  def eur(number) 
    number_to_currency(number, unit: "&euro;", separator: ",", delimiter: ".", format: "%n", :negative_format => "- %n")
  end

  def eur_pdf(number)
    number_to_currency(number, unit: "€ ", separator: ",", delimiter: ".", format: "%u %n", :negative_format => "- %u %n")
  end

  def page_title
    if content_for(:title).blank?
      app_name
    else
      content_for(:title)
    end
  end

  def flash_class(level)
      case level
          when :success then "alert alert-success"
          when :notice then "alert alert-info"
          when :alert then "alert alert-warning"
          when :error then "alert alert-danger"
       
      end
  end


  def active(path)
    raw ' class="active"' if current_page?(path)    
  end

  def app_name 
    "Fatturini"
  end

  def title(page_title, options={})
    if page_title.blank?
      full_title = app_name
    else
      full_title = page_title.to_s
    end
    content_for(:title, full_title)
    # return content_tag(:h1, page_title, options)
  end

  def header(page_header, options={})
    if page_header.blank? 
      header = t('page_header')
    else
      header = page_header
    end
    content_for(:page_header, header)
  end

end
