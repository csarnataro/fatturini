# encoding: utf-8
class CristinaContiniPdf < BasePdf


def _build_pdf  

    
    initialmove_y = 0
    address_x = 0
    lineheight_y = 14
    font_size = 11

    show_bounds = false

    stroke_bounds if show_bounds


    # Title
    # text "#{t('.invoice')} ##{@invoice.id.to_s}", :size => 25

    move_down initialmove_y

    # Add the font style and size
    font "Helvetica"
    font_size font_size

    #company info
    bounding_box [bounds.left, bounds.top], :width => bounds.right do

      enhanced_text_box current_user.company.name, :size => 13, :style => :bold
      move_down lineheight_y * 1.1

      current_user.company.invoice_header.split(/^/).each_with_index do |line, index|
        if index == 0
          enhanced_text_box line, :style => :bold_italic
        else
          enhanced_text_box line
        end
        move_down lineheight_y
      end



# => :     text_box "Christian Sarnataro", :at => [address_x,  cursor], :size => 18, :style => :bold
#      move_down lineheight_y*1.5
#      text_box "Via Antonio Sacchini, 1", :at => [address_x,  cursor]
#      move_down lineheight_y
#      text_box "20131 Milano", :at => [address_x,  cursor]
#      move_down lineheight_y
#      text_box "Tel: +39 349 0895840", :at => [address_x,  cursor]
#      move_down lineheight_y
#      text_box "Email: christian.sarnataro@gmail.com", :at => [address_x,  cursor]
#      move_down lineheight_y
#      text_box "Partita IVA: IT07661970967", :at => [address_x,  cursor]
#      move_down lineheight_y
#      text_box "Codice Fiscale: SRNCRS71A21E507C", :at => [address_x,  cursor]
#      move_down lineheight_y
    end



    last_measured_y = cursor

    # fill_color "0000FF"
    #   fill_color "00bb00"

    stroke_bounds if show_bounds
    line_width(0.5)


    # Client info
    # text @invoice.client.name
    # text @invoice.client.name
    # text @invoice.client.address

    #draw_text "#{t('.created_at')}: #{l(@invoice.created_at, :format => :short)}", :at => [bounds.width / 2, bounds.height - 30]

    # Our company info
    bounding_box [bounds.left, bounds.top-100], :width => bounds.right do
      
      stroke_bounds if show_bounds

      # invoice info

      bounding_box [bounds.left, bounds.top - 118], :width => 250 do
      
        stroke_bounds if show_bounds


        enhanced_text_box "{it=>Fattura N.|en=>Invoice No.}"
        # text_box "Fattura N."
        # rounded_rectangle [59, 5], 71, lineheight_y*1.3, 3
        text_box @invoice.number|'', :at => [69,0]
        enhanced_text_box "{it=>del|en=>Date}", :at => [140, 0]
        # rounded_rectangle [170, 5], 71, lineheight_y*1.3, 3
        text_box @invoice.invoice_date.try(:to_s), :at => [180,0], :width => 100
      end

    # client info
      bounding_box [bounds.right - 260, bounds.top], :width => 290 do

        # rounded_rectangle([-10, 10], 270, lineheight_y*10, 20)
        move_down lineheight_y
        text_box @invoice.client.salutation|'', :at => [address_x,  cursor]
        move_down lineheight_y
        text_box @invoice.client.name, :at => [address_x,  cursor], :style => :bold
        
        move_down lineheight_y
        text_box @invoice.client.attention_to, :at => [address_x,  cursor]

        move_down lineheight_y
        text_box @invoice.client.address, :at => [address_x,  cursor]

        move_down lineheight_y
        text_box @invoice.client.english_invoice_address_without_country, :at => [address_x,  cursor]

        move_down lineheight_y
        text_box @invoice.client.country, :at => [address_x,  cursor]

        move_down lineheight_y * 2


        enhanced_text_box(@invoice.client.vat_code.pref('{it=>P.I.: |en=>VAT ID: }'))
        # text_box  , :at => [address_x,  cursor]
        move_down lineheight_y
        enhanced_text_box(@invoice.client.fiscal_code.pref('{it=>C.F.: |en=>F.C.: }'))
        # text_box @invoice.client.fiscal_code.pref('C.F.') , :at => [address_x,  cursor]
      end


    end

    float do
      bounding_box [bounds.left + 10, bounds.top - 610], :width => bounds.right do


        # Terms
        # rounded_rectangle([-10, 10], bounds.right, lineheight_y*9, 20)

        enhanced_text_box @invoice.term.pref('{it=>Condizioni di pagamento|en=>Payment terms}:')
        move_down lineheight_y

        unless current_user.company.account_holder.blank?
          enhanced_text_box '{it=>Pagamento con bonifico bancario|en=>Payment via wire transfer}'
          move_down lineheight_y
          
          enhanced_text_box '{it=>Intestazione:|en=>Account holder}:'
          text_box current_user.company.account_holder, :at => [address_x+130,  cursor]
          move_down lineheight_y

          text_box 'IBAN:', :at => [address_x,  cursor], :style => :bold
          text_box current_user.company.iban, :at => [address_x+130,  cursor], :style => :bold
          move_down lineheight_y

          enhanced_text_box '{it=>BANCA|en=>BANK NAME}:', :at => [address_x,  cursor]
          text_box current_user.company.bank_name, :at => [address_x+130,  cursor]
          move_down lineheight_y

          enhanced_text_box '{it=>FILIALE|en=>CITY}:', :at => [address_x,  cursor]
          text_box current_user.company.branch, :at => [address_x+130,  cursor]
          move_down lineheight_y

          enhanced_text_box 'BIC/SWIFT {it=>SEDE|en=>}:', :at => [address_x,  cursor]
          text_box current_user.company.bic, :at => [address_x+130,  cursor]
          move_down lineheight_y

          enhanced_text_box 'BIC/SWIFT {it=>|en=>BRANCH}:', :at => [address_x,  cursor]
          text_box 'POSOIT22', :at => [address_x+130,  cursor]
        end

      end
    end

    float do
      bounding_box [bounds.left, bounds.top - 580], :width => bounds.right do
        text_box @invoice.notes, :at => [address_x,  cursor], :align => :right
      end
    end

#     float do
#       bounding_box [bounds.left, 8], :width => bounds.right do
#         enhanced_text_box current_user.company.invoice_footer, :align => :center, :size => 8
#       end
#     end


    # apparently this line set the transparent background on the rounded boxes
    # stroke_rounded_rectangle([0, 0], 0, 0, 10)


    header = [t('.item.description'), t('.item.quantity'), t('.item.unit_cost'), t('.item.price')]

    items = @invoice.items.collect do |item|
      item.description = item.description.gsub(/^\s+/, Prawn::Text::NBSP * 6)
      
      quantity = item.quantity % 1 != 0 ? item.quantity : item.quantity.floor unless item.quantity.nil?
      
      [item.description, quantity, @view.eur_pdf(item.unit_cost), @view.eur_pdf(item.total)]
    end

    items.unshift header

    footer_items = @invoice.footer_items.collect do |item|
      [item[:description], '', @view.eur_pdf(item[:calculated_value])]
    end



    (18 - items.length - footer_items.length).times{items<<['','','','']}

    move_down 30

    table(items, :width => bounds.width) do

      # BORDERS
      cells.style(:border_width => 0.5)
      rows(0..items.length-1).style(:height => lineheight_y+4, :padding => [2, 5, 2, 5])

      cells.borders = [:left, :right]
      rows(0).style(:borders => [:left, :top, :bottom, :right]) # selects rows four and five
      row(0).style(
        :background_color => 'e9e9e9', 
        :border_color => '000000', 
        :font_style => :bold, 
        :borders => [:top, :bottom, :left, :right]
      )
      row((items.length - 1)).style(:borders => [:bottom, :left, :right])

      # CELL WIDTHS
      columns(1).style( :width => 45)
      columns(2).style( :width => 110)
      columns(3).style( :width => 110)

      columns(1..3).style( :align => :right)
      row(0).style(
        :align=> :center
      )



    end


    table(footer_items, :width => bounds.width) do

      # BORDERS
      cells.style(:border_width => 0.5)
      rows(0..footer_items.length-1).style(:height => lineheight_y+4, :padding => [2, 5, 2, 5])
      cells.borders = [:left, :right]
      rows(0).style(:borders => [:left, :top, :right]) # selects rows four and five
      columns(0).style(:borders => [:left])
      columns(1).style(:borders => [:right])
      columns(2).style(:borders => [:left, :top, :right, :bottom])
      # row(0).style(:background_color => 'e9e9e9', :border_color => '000000', :font_style => :bold, :borders => [:top, :bottom, :left, :right])
      row((footer_items.length - 1)).style(:borders => [:bottom, :left, :right], :font_style => :bold)
      row((footer_items.length - 1)).column(0).style(:borders => [:bottom, :left])
      row((footer_items.length - 1)).column(1).style(:borders => [:bottom])

      # CELL WIDTHS
      columns(1).style( :width => 15)
      columns(2).style( :width => 110)
      #columns(2).style( :width => 90)
      #columns(3).style( :width => 90)

      columns(0..2).style( :align => :right)

      rows(footer_items.length-1).columns(2).style(:border_widths => [0.5, 0.5, 2, 0.5], :background_color => 'e9e9e9')

    end


    # Footer
    # draw_text "#{t('.generated_at')} #{l(Time.now, :format => :short)}", :at => [0, 0]




    # don't know why, but it't better if the 2 tables are written after the rest
  end
end