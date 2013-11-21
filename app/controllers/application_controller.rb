class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :except => [:not_found]
  before_filter :set_current_year

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :current_year

  def not_found
    render(:file => "#{Rails.root.to_s}/public/404.html", :layout => false, :status => 404, :content_type => Mime::HTML)
  end


  def set_current_year
    cookies[:current_year] = Date.today.year unless cookies[:current_year] 
  end

  def current_year
    cookies[:current_year] 
  end

  def change_year
    year = params[:year]
    # TODO: check validity of the input parameter 
    cookies[:current_year] = year
    redirect_to root_path
  end

  def index
    # render :layout => false
    @dashboard = {}
    
    Client.where(:company_id => current_user.company.id).order('name').each do |client|
    #current_user.company.clients.each do |client|
      @dashboard[client] = {}
      @invoices = Invoice.where('client_id = (?)', client.id)
      
      @paid_invoices = @invoices.find_all{|invoice| invoice.payment_status == 'paid' }
      @paid_invoices_sum = @paid_invoices.collect(&:total).sum
      
      @dashboard[client][:paid] = @paid_invoices.length
      @dashboard[client][:paid_invoices_sum] = @paid_invoices_sum

#      expired_invoices = Invoice.where('client_id = (?)', client.id).where(' status = "sent" ')
#      paid_invoices_sum = paid_invoices.collect(&:total).sum
      

      
    end
    # @dashboard.sort{ |c1, c2| c1.name <= c2.name }
    # @dashboard = @dashboard.sort { |a,b| b.invoices.count <=> a.invoices.count }
    
    
    
  end

  def dashboard
  end

  private  
    def current_user  
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]  
    end
    
    def user_signed_in?
      return 1 if current_user 
    end
      
    def authenticate_user!
      if !current_user
        
        flash[:error] = "You need to sign in before accessing this page: [#{request.fullpath}]" if request.fullpath != '/'

        redirect_to signin_services_path
      end
    end



end
