class Footer < ActiveRecord::Base

    has_many :footer_items, :dependent => :destroy
    has_many :invoices 
    has_many :clients

    accepts_nested_attributes_for :footer_items, :allow_destroy => true

end

=begin  
  lista di campi calcolati (in oggetto fattura)
    - totale

    - opzionali, in footer: altre tasse da calcolare con algoritmo


    es:

    - iva (solo italiane)

    iva = imponibile * percentuale
    totale fattura = imponibile + iva

    altri campi:
    - mia ritenuta d'acconto = -20% imponibile
    - addebito 4% professionisti = +6% imponibile


    altri campi (altran):
    - iva
    - mia ritenuta d'acconto = -20% imponibile


    altri campi (zema):
    - iva
    - mia ritenuta d'acconto = -20% imponibile
    - addebito 4% professionisti = +6% imponibile


    - netto a corrispondere = somma di imponibile + iva + tutti questi campi

quindi:
straniere = base
italiane = iva


=end

