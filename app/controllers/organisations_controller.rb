class OrganisationsController < ApplicationController
  layout 'main'

  # GET /organisations
  # GET /organisations.xml
  def index
    @organisations = Organisation.all(:order => 'short_name ASC')
    respond_to do |format|
      format.fbml # index.html.erb
    end
  end

  # GET /organisations/1
  # GET /organisations/1.xml
  def show
    @organisation = Organisation.find(params[:id])
    #@organisation.increment_view_counter  @organisation == @current_user.organisation
    @organisation_users = User.find(:all, :conditions => "organisation_id = #{@organisation.id} AND (signup_step >= 3)")

    # this is for the visit form
    @visit = Visit.new


    @url_for_iframe = FACEBOOKER['callback_url'] + "/iframe/iframe_organisation_map?"+
                                 "organisation_id=#{@organisation.id}&"+
                                 "searching_user_id=#{@current_user.id}"
    respond_to do |format|
      format.fbml # show.html.erb
    end
  end

  # GET /organisations/new
  # GET /organisations/new.xml
  def new
    @organisation = Organisation.new

    respond_to do |format|
      format.fbml # new.html.erb
    end
  end

  # GET /organisations/1/edit
  def edit
    @organisation = Organisation.find(params[:id])
    unless @current_user.is_admin || (@current_user.organisation == @organisation)
      redirect_to :action => :show, :id => params[:id]
    end
  end

  # POST /organisations
  # POST /organisations.xml
  def create
    @organisation = Organisation.new(params[:organisation])

    respond_to do |format|
      if @organisation.save
        flash[:notice] = "Organisation created"
        ## check if the organisation has been created from a new user
        # Only administrator create organisations which are not their organisation
        # so, if @current_user is not admin, we set his organisation to the new one
        if @organisation.update_organisation_geo_info
          flash[:notice] += " (geographic information found, and updated) "
        else
          flash[:error] = "Error", "NO geographic information found, please review address!"
        end
        format.fbml { redirect_to(organisations_url) }
        #  format.fbml { redirect_to(:controller => 'main', :action => 'index_for_new_users') }
      else
        format.fbml { render :action => "new" }
      end
    end
  end

  # PUT /organisations/1
  # PUT /organisations/1.xml
  def update
    @organisation = Organisation.find(params[:id])

    respond_to do |format|
    address_has_changed = true   if params[:organisation][:city]      != @organisation.city ||
                              params[:organisation][:post_code] != @organisation.post_code ||
                              params[:organisation][:state]     != @organisation.state ||
                              params[:organisation][:country]   != @organisation.country ||
                              params[:organisation][:street]    != @organisation.street
      if @organisation.update_attributes(params[:organisation])
        @organisation.update_organisation_geo_info if address_has_changed
        flash[:notice] = 'Organisation was successfully updated.'
        format.fbml { redirect_to(@organisation) }
      else
        format.fbml { render :action => "edit" }
      end
    end
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.xml
  def destroy
    @organisation = Organisation.find(params[:id])
    @organisation.destroy

    respond_to do |format|
      format.fbml { redirect_to(organisations_url) }
    end
  end
end
