class ContactsController < ApplicationController
  layout 'main'
 
  # GET /contacts
  # GET /contacts.xml
  def index
    unless @current_user.is_admin
      redirect_to :controller => :main
      return
    end
    @contacts = Contact.all
    respond_to do |format|
      format.fbml # index.html.erb
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
 #  def show
 #    @contact = Contact.find(params[:id])
 #
 #    respond_to do |format|
 #      format.fbml # show.html.erb
 #    end
 #  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = Contact.new
    @user = @current_user
    respond_to do |format|
      format.fbml # new.html.erb
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
    unless @current_user == @contact.user || @current_user == @contact.contacted_user || @current_user.is_admin
      redirect_to :controller => :main
      return
    end
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    #@contact = Contact.new(params[:contact])contact[description]
    #@contact = @current_user.contacts.build(:contacted_user_id => params(:contacted_user_id))

    @contact = @current_user.contacts.build(params[:contact])
    respond_to do |format|
      if @contact.save
        if @contact.when.to_time > Time.now()
          flash[:error] = "ERROR:", "you've set a date in the future! please correct"
        else
          flash[:notice] = 'Contact added.'
        end
        # format.fbml { redirect_to(@contact) }
        if @contact.user == @current_user
          format.fbml { redirect_to @contact.contacted_user }
        else
          format.fbml { redirect_to @contact.user }
        end
      else
        format.fbml { render :action => "new" }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = Contact.find(params[:id])
    unless @current_user == @contact.user || @current_user == @contact.contacted_user || @current_user.is_admin
      redirect_to :controller => :main
      return
    end
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        if @contact.when.to_time > Time.now()
          flash[:error] = "ERROR:", "you've set a date in the future! please correct"
        else
          flash[:notice] = 'Contact updated.'
        end
        if @contact.user == @current_user
          format.fbml { redirect_to @contact.contacted_user }
        else
          format.fbml { redirect_to @contact.user }
        end
      else
        format.fbml { render :action => "edit" }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy

    @contact = Contact.find(params[:id])
    unless @current_user == @contact.user || @current_user == @contact.contacted_user || @current_user.is_admin
      redirect_to :controller => :main
      return
    end
    contacted_user = @contact.contacted_user
    user = @contact.user
    @contact.destroy
    flash[:notice] = 'Contact removed.'

    respond_to do |format|
      if @current_user.is_admin
        format.fbml { redirect_to contacts_path }
      else
        if @contact.user == @current_user
          format.fbml { redirect_to contacted_user }
        else
          format.fbml { redirect_to user }
        end
      end
    end
  end
end
