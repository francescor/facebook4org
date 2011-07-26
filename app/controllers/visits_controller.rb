class VisitsController < ApplicationController
  layout 'main'

  # GET /visits
  # GET /visits.xml
  def index
    unless @current_user.is_admin
      redirect_to :controller => :main
      return
    end
    @visits = Visit.all
    respond_to do |format|
      format.fbml # index.html.erb
    end
  end

  # GET /visits/1
  # GET /visits/1.xml
#  def show
#    @visit = Visit.find(params[:id])
#
#    respond_to do |format|
#      format.fbml # show.html.erb
#    end
#  end

  # GET /visits/new
  # GET /visits/new.xml
  def new
    @visit = Visit.new
    @user = @current_user
    respond_to do |format|
      format.fbml # new.html.erb
    end
  end

  # GET /visits/1/edit
  def edit
    @visit = Visit.find(params[:id])
    unless @current_user == @visit.user || @current_user.is_admin
      redirect_to :controller => :main
      return
    end
  end

  # POST /visits
  # POST /visits.xml
  def create
    #@visit = Visit.new(params[:visit])visit[description]
    #@visit = @current_user.visits.build(:organisation_id => params(:organisation_id))

    @visit = @current_user.visits.build(params[:visit])
    respond_to do |format|
      if @visit.save
        if @visit.when.to_time > Time.now()
          flash[:error] = "ERROR:", "you've set a date in the future! please correct"
        else
          flash[:notice] = 'Visit added.'
        end
        # format.fbml { redirect_to(@visit) }
        format.fbml { redirect_to @visit.organisation }
      else
        format.fbml { render :action => "new" }
      end
    end
  end

  # PUT /visits/1
  # PUT /visits/1.xml
  def update
    @visit = Visit.find(params[:id])
    unless @current_user == @visit.user || @current_user.is_admin
      redirect_to :controller => :main
      return
    end
    respond_to do |format|
      if @visit.update_attributes(params[:visit])
        if @visit.when.to_time > Time.now()
          flash[:error] = "ERROR:", "you've set a date in the future! please correct"
        else
          flash[:notice] = 'Visit updated.'
        end
        format.fbml { redirect_to @visit.organisation }
      else
        format.fbml { render :action => "edit" }
      end
    end
  end

  # DELETE /visits/1
  # DELETE /visits/1.xml
  def destroy

    @visit = Visit.find(params[:id])
    unless @current_user == @visit.user || @current_user.is_admin
      redirect_to :controller => :main
      return
    end
    organisation = @visit.organisation
    @visit.destroy
    flash[:notice] = 'Visit removed.'

    respond_to do |format|
      if @current_user.is_admin
        format.fbml { redirect_to visits_path }
      else
        format.fbml { redirect_to organisation }
      end
    end
  end
end
